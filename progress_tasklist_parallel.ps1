#Copyright (c) 2014 Serguei Kouzmine
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

# $DebugPreference = 'Continue'

$shared_assemblies = @(
  # http://www.codeproject.com/Articles/11588/Progress-Task-List-Control
  'ProgressTaskList.dll',
  'nunit.core.dll',
  'nunit.framework.dll'
)


$shared_assemblies_path = 'c:\developer\sergueik\csharp\SharedAssemblies'

if (($env:SHARED_ASSEMBLIES_PATH -ne $null) -and ($env:SHARED_ASSEMBLIES_PATH -ne '')) {

  Write-Debug ('Using environment: {0}' -f $env:SHARED_ASSEMBLIES_PATH)
  $shared_assemblies_path = $env:SHARED_ASSEMBLIES_PATH
}

try {
  pushd $shared_assemblies_path -erroraction  'Stop' 
} catch [System.Management.Automation.ItemNotFoundException] {

# no shared assemblies 
throw
return

} catch [Exception]  {
# possibly System.Management.Automation.ItemNotFoundException
write-output ("Unexpected exception {0}`n{1}" -f  ( $_.Exception.GetType() ) , ( $_.Exception.Message) ) 

}

$shared_assemblies | ForEach-Object {
  $assembly = $_

  if ($host.Version.Major -gt 2) {
    Unblock-File -Path $assembly
  }
  Add-Type -Path $assembly
  Write-Debug $assembly
}
popd


# http://poshcode.org/2887
# http://stackoverflow.com/questions/8343767/how-to-get-the-current-directory-of-the-cmdlet-being-executed
# https://msdn.microsoft.com/en-us/library/system.management.automation.invocationinfo.pscommandpath%28v=vs.85%29.aspx
function Get-ScriptDirectory
{
  [string]$scriptDirectory = $null

  if ($host.Version.Major -gt 2) {
    $scriptDirectory = (Get-Variable PSScriptRoot).Value
    Write-Debug ('$PSScriptRoot: {0}' -f $scriptDirectory)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }
    $scriptDirectory = [System.IO.Path]::GetDirectoryName($MyInvocation.PSCommandPath)
    Write-Debug ('$MyInvocation.PSCommandPath: {0}' -f $scriptDirectory)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }

    $scriptDirectory = Split-Path -Parent $PSCommandPath
    Write-Debug ('$PSCommandPath: {0}' -f $scriptDirectory)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }
  } else {
    $scriptDirectory = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value
    if ($Invocation.PSScriptRoot) {
      $scriptDirectory = $Invocation.PSScriptRoot
    } elseif ($Invocation.MyCommand.Path) {
      $scriptDirectory = Split-Path $Invocation.MyCommand.Path
    } else {
      $scriptDirectory = $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf('\'))
    }
    return $scriptDirectory
  }
}

$so = [hashtable]::Synchronized(@{
    'Title' = [string]'';
    'Visible' = [bool]$false;
    'ScriptDirectory' = [string]'';
    'Form' = [System.Windows.Forms.Form]$null;
    'Current' = 0;
    'Previous' = 0;
    'Last' = 0;
    'Tasks' = [System.Management.Automation.PSReference];
    'Progress' = [Ibenza.UI.Winforms.ProgressTaskList]$null;
  })

$so.ScriptDirectory = Get-ScriptDirectory
$rs = [runspacefactory]::CreateRunspace()
$rs.ApartmentState = 'STA'
$rs.ThreadOptions = 'ReuseThread'
$rs.Open()
$rs.SessionStateProxy.SetVariable('so',$so)

$run_script = [powershell]::Create().AddScript({

    function ProgressbarTasklist {
      param(
        [string]$title,
        [System.Management.Automation.PSReference]$tasks_ref,
        [object]$caller
      )

      @( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }

      $f = New-Object -TypeName 'System.Windows.Forms.Form'
      $so.Form = $f
      $f.Text = $title
      $t = New-Object System.Windows.Forms.Timer
      function start_timer {

        $t.Enabled = $true
        $t.Start()

      }

      $t_OnTick = {
        # TODO 
        # $elapsed = New-TimeSpan -Seconds ($p.Maximum - $p.Value)
        # $text = ('{0:00}:{1:00}:{2:00}' -f $elapsed.Hours,$elapsed.Minutes,$elapsed.Seconds)
        if ($so.Current -eq $so.Last) {
          $t.Enabled = $false
          $f.Close()
        } else {
          if ($so.Current -gt $so.Previous) {
            $o.NextTask()
            $so.Previous = $so.Current
          }
        }
      }
      $t.Interval = 300
      $t.add_tick($t_OnTick)

      $f.Size = New-Object System.Drawing.Size (650,150)
      $f.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
      $f.AutoScaleBaseSize = New-Object System.Drawing.Size (5,14)
      $f.ClientSize = New-Object System.Drawing.Size (292,144)


      $panel = New-Object System.Windows.Forms.Panel
      $panel.BackColor = [System.Drawing.Color]::Silver
      $panel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

      $b = New-Object System.Windows.Forms.Button
      $b.Location = New-Object System.Drawing.Point (210,114)
      $b.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font
      $b.Font = New-Object System.Drawing.Font ('Microsoft Sans Serif',7,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)

      $b.Text = 'Skip forward'
      [scriptblock]$progress = {

        if (-not $o.Visible) {
          # set the first task to 'in progress'
          $o.Visible = $true
          $so.Current = 1
          $o.Start()

        } else {
          # TODO: set the following task to 'skipped'
          $so.Current = $so.Current + 1
          $o.NextTask()
        }
      }

      $progress_click = $b.add_click
      $progress_click.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          if ($so.Current -eq $so.Last)
          {
            $b.Enabled = $false
            Start-Sleep -Millisecond 300
            $so.Current = $so.Current + 1
            $so.Visible = $false
          } else {
            Invoke-Command $progress -ArgumentList @()
          }

        })
      $b.Enabled = $false
      $o = New-Object -TypeName 'Ibenza.UI.Winforms.ProgressTaskList' -ArgumentList @()
      $o.BackColor = [System.Drawing.Color]::Transparent
      $o.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
      $o.Dock = [System.Windows.Forms.DockStyle]::Fill
      $o.Location = New-Object System.Drawing.Point (0,0)
      $o.Name = "progressTaskList1"
      $o.Size = New-Object System.Drawing.Size (288,159)
      $o.TabIndex = 2
      $so.Progress = $o
      $o.TaskItems.AddRange(@( [string[]]$tasks_ref.Value))

      $so.Last = $tasks_ref.Value.Count + 1 # will use 1-based index 
      $o.Visible = $false
      $panel.SuspendLayout()
      $panel.ForeColor = [System.Drawing.Color]::Black
      $panel.Location = New-Object System.Drawing.Point (0,0)
      $panel.Name = 'panel'
      $panel.Size = New-Object System.Drawing.Size (($f.Size.Width),($f.Size.Height))
      $panel.TabIndex = 1

      $panel.Controls.Add($o)
      $panel.ResumeLayout($false)
      $panel.PerformLayout()
      $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState

      $f.Controls.AddRange(@( $b,$panel))
      $f.Topmost = $True

      $so.Visible = $true
      $f.Add_Shown({
          $f.WindowState = $InitialFormWindowState
          $f.Activate()
          Invoke-Command $progress -ArgumentList @()
          start_timer
        })
      [void]$f.ShowDialog()

      $f.Dispose()
    }
    $tasks_ref = $so.Tasks
    ProgressbarTasklist -tasks_ref $tasks_ref -Title $so.Title
    Write-Debug ("Processed:`n{0}" -f ($tasks_ref.Value -join "`n"))
  })

$tasks = @(
  'Verifying cabinet integrity',
  'Checking necessary disk space',
  'Extracting files',
  'Modifying registry',
  'Installing files',
  'Removing temporary files')


$task_status = @{}

$tasks | ForEach-Object { $task_status[$_] = $null }

$so.Tasks = ([ref]$tasks)
$so.Title = 'Task List'

$run_script.Runspace = $rs

$handle = $run_script.BeginInvoke()

function PerformStep {

  param(
    [int]$step,
    [switch]$skip
  )
  $task_status[$step] = $true

  $so.Current = $step
  # can call Progress class methods across Runspaces 
  # $so.Progress.NextTask() 

}

Start-Sleep -Millisecond 100
while ($so.Visible) {
  for ($cnt = 0; $cnt -ne $tasks.Count; $cnt++) {
    $step_name = $tasks[$cnt]
    Start-Sleep -Milliseconds (Get-Random -Maximum 5000)
    PerformStep -Step $cnt
    Write-Host ('Completes step [{0}] "{1}"' -f $cnt,$step_name)
  }
  $so.Visible = $false
}

# Close the progress form
$so.Form.Close()

# Close the runspace
$run_script.EndInvoke($handle)
$rs.Close()
