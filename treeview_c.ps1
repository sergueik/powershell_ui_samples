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

Add-Type -TypeDefinition @"
using System;
using System.Windows.Forms;
public class Win32Window : IWin32Window
{
    private IntPtr _hWnd;
    private int _data;
    private string _script_directory;

    public int Data
    {
        get { return _data; }
        set { _data = value; }
    }
    public string ScriptDirectory
    {
        get { return _script_directory; }
        set { _script_directory = value; }
    }

    public Win32Window(IntPtr handle)
    {
        _hWnd = handle;
    }

    public IntPtr Handle
    {
        get { return _hWnd; }
    }
}

"@ -ReferencedAssemblies 'System.Windows.Forms.dll'

# http://www.java2s.com/Code/CSharp/GUI-Windows-Form/CheckedListBoxItemCheckevent.htm

function PromptTreeView
{
  param(
    [string]$title,
    [object]$caller = $null
  )

  @( 'System.Drawing','System.Collections.Generic','System.Collections','System.ComponentModel','System.Text','System.Data','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }
  $f = New-Object System.Windows.Forms.Form
  $f.Text = $title
  $t = New-Object System.Windows.Forms.TreeView
  $components = New-Object System.ComponentModel.Container
  $f.SuspendLayout()
  $t.Font = New-Object System.Drawing.Font ('Arial',9.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,[System.Byte]0);

  $i = New-Object System.Windows.Forms.ImageList ($components)
  $i.Images.Add([System.Drawing.SystemIcons]::Application)
  try {
    $script_path = $caller.ScriptDirectory
  } catch [exception]{
    # slurp the exception - debug code omitted            
  }
  if (-not $script_path) {
    $script_path = Get-Location
  }
  foreach ($n in @( 1,2,3)) {
    $image_path = ('{0}\color{1}.gif' -f $script_path,$n)
    $image = [System.Drawing.Image]::FromFile($image_path)
    $i.Images.Add($image)
  }
  $t.ImageList = $i


  $t.Anchor = (((0 `
           -bor [System.Windows.Forms.AnchorStyles]::Top `
           -bor [System.Windows.Forms.AnchorStyles]::Bottom) `
         -bor [System.Windows.Forms.AnchorStyles]::Left) `
       -bor [System.Windows.Forms.AnchorStyles]::Right)
  $t.ImageIndex = -1
  $t.Location = New-Object System.Drawing.Point (4,5)
  $t.Name = "treeFood"
  $t.SelectedImageIndex = -1
  $t.Size = New-Object System.Drawing.Size (284,256)
  $t.TabIndex = 1
  $t_AfterSelect = $t.add_AfterSelect
  $t_AfterSelect.Invoke({
      param(
        [object]$sender,
        [System.Windows.Forms.TreeViewEventArgs]$eventargs
      )
      if ($eventargs.Action -eq [System.Windows.Forms.TreeViewAction]::ByMouse)
      {
        [System.Windows.Forms.MessageBox]::Show($eventargs.Node.FullPath);
        $worker.RunWorkerAsync()
        # write-host $eventargs.Node.FullPath
      }

    })

  $f.AutoScaleBaseSize = New-Object System.Drawing.Size (5,13)
  $f.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
  $f.ClientSize = New-Object System.Drawing.Size (292,266)
  $f.Controls.Add($t)
  $f.Name = "TreeViewExample"
  $f.Text = "TreeView Example"
  $f_Load = $f.add_Load

  # for loading AD data see http://www.codeproject.com/Tips/295882/Use-PowerShell-to-Query-and-Display-Data-II-Active
  $f_Load.Invoke({
      param(
        [object]$sender,
        [System.EventArgs]$eventargs
      )

      $node = $t.Nodes.Add("Fruits")
      $apple = $node.Nodes.Add("Apple")
      $apple.ImageIndex = 1

      $node.Nodes.Add("Peach")

      $node = $t.Nodes.Add("Vegetables")
      $tomato = $node.Nodes.Add("Tomato")
      $tomato.ImageIndex = 2
      $node.Nodes.Add("Eggplant")


    })

  $f.ResumeLayout($false)

  # http://www.dotnetperls.com/backgroundworker

  $worker = New-Object System.ComponentModel.BackgroundWorker
  $worker.WorkerReportsProgress = $false
  $worker.WorkerSupportsCancellation = $false
  $worker_DoWork = $worker.Add_DoWork
  $worker_DoWork.Invoke({
      param(
        [object]$sender,
        [System.Windows.Forms.DoWorkEventArgs]$eventargs
      )
    })

  $worker_RunWorkerCompleted = $worker.Add_RunWorkerCompleted
  $worker_RunWorkerCompleted.Invoke({
      param(
        [object]$sender,
        [System.ComponentModel.RunWorkerCompletedEventArgs]$eventargs
      )

      $child_proc = [System.Diagnostics.Process]::Start('notepad',"$env:windir\system32\drivers\etc\hosts")
      $child_proc.WaitForExit()

    })

  $f.Name = 'Form1'
  $f.Text = 'TreeView Sample'
  $t.ResumeLayout($false)
  $f.ResumeLayout($false)
  $f.KeyPreview = $false

  $f.Topmost = $True
  if ($caller -eq $null) {
    $caller = New-Object Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)
  }

  $f.Add_Shown({ $f.Activate() })

  [void]$f.ShowDialog([win32window]($caller))

  $t.Dispose()
  $f.Dispose()
  $result = $caller.Message
  $caller = $null
  return $result
}

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


$DebugPreference = 'Continue'
$caller = New-Object Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)
$caller.ScriptDirectory = Get-ScriptDirectory
$result = PromptTreeView 'Items' $caller

Write-Debug ('Selection is : {0}' -f $result)
