#Copyright (c) 2021 Serguei Kouzmine
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

param(
  # NOTE: Powershell does some conversion silently, based on param type 
  # [string[]]$options = @(),
  [String]$option = $null
)


# inspired by: https://www.cyberforum.ru/powershell/thread2805448.html

$caller_class = 'Win32Window_2'
Add-Type -TypeDefinition @"

using System;
using System.Collections;
using System.ComponentModel;

using System.Windows.Forms;
public class ${caller_class}: IWin32Window {
    private IntPtr _hWnd;
    private ArrayList _input =  new ArrayList();
    public ArrayList Input
    {
        get { return _input; }
        set { _input = value; }
    }

    public ${caller_class}(IntPtr handle)
    {
        _hWnd = handle;
    }

    public IntPtr Handle
    {
        get { return _hWnd; }
    }
}

"@ -ReferencedAssemblies 'System.Windows.Forms.dll'



[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
Add-Type -AssemblyName System.Windows.Forms


function collect_input {
  param(
    [string]$label,
    [object]$caller

  )
  $f = new-object System.Windows.Forms.Form
  $f.Size = new-object System.Drawing.Size(300,415)
  $f.AutoSize = $true
  $f.StartPosition = 'CenterScreen'
  $f.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
  $f.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowOnly
  # $f.FormBorderStyle = FormBorderStyle.Sizable
  $f.ControlBox = $false
  $f.Text = ''
  $l = new-object System.Windows.Forms.Label
  $l.Location = new-object System.Drawing.Point(10,5)
  $l.Size = new-object System.Drawing.Size(280,20)
  $l.Font = New-Object System.Drawing.Font ('Microsoft Sans Serif',11 ,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)
  $l.Text = $label
  $l.add_MouseEnter({
    param(
      [object] $sender, [System.EventArgs] $e    
    )
    $l.Text = 'Press Enter twice to submit'
  })
  $l.add_MouseLeave({
    param(
      [object] $sender, [System.EventArgs] $e
    )
    $l.Text = $label
  })
  # _MouseHover ?
 
        
  $f.Controls.Add($l)
 
  
  $t = new-object System.Windows.Forms.TextBox
  $t.Location = new-object System.Drawing.Size(10,35)
  $t.Size = new-object System.Drawing.Size(290,367)
  $t.Multiline = $true
  $t.Font = New-Object System.Drawing.Font ('Microsoft Sans Serif',13 ,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)
  $t.ScrollBars = 'Vertical'
  $f.Controls.Add($t)
  $t.focus()

  $t.Add_TextChanged({
    $caller.Input.Clear()
    $debug = $false
    $done = $false
    $reader = new-object System.IO.StringReader($t.Text)
    while ($true){
      $line = $reader.readline()
      if ($line -eq $null){
        break
      }
      if ($line -eq '') { 
        if ($debug){
          write-host ('procesed empty line "{0}"' -f $line)
        }
        $done = $true
        break
      }
      if ($debug){
        write-host ('procesing {0}' -f $line)
      }
      $caller.Input.Add($line)
    }
    $reader.dispose()
    if ($done) {
      if ($debug){
        write-host ('returning array: "{0}"' -f ($caller.Input.ToArray([System.String]) -join ','))
      }
      # NOTE: $t.Clear() should not be called here:
      # leads to resending the original event
      # $t.Clear()
      $f.Close()
    }
  })

  $f.Topmost = $true
  $f.Add_Shown({$f.Activate()})
  [void] $f.ShowDialog()
}

if ($option -eq '-') {
  
  $window_handle = [System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle
  if ($window_handle -eq 0) {
    $processid = [System.Diagnostics.Process]::GetCurrentProcess().Id
    $parent_process_id = get-wmiobject win32_process | where-object {$_.processid -eq  $processid } | select-object -expandproperty parentprocessid
  
    $window_handle = get-process -id $parent_process_id | select-object -expandproperty MainWindowHandle
    write-output ('Using current process parent process {0} handle {1}' -f $parent_process_id, $window_handle)
  } else {
    write-output ('Using current process handle {0}' -f $window_handle)
  }
  
  $caller = new-object $caller_class -ArgumentList ($window_handle)
  
  collect_input -label 'enter value for option:' -caller $caller
   
  write-output ('option: "{0}"' -f ($caller.Input.ToArray([System.String]) -join ','))
} else {
  if (($option -ne $null) -and ($option -ne '')) {
    write-output ('option: "{0}"' -f (($option -split ' ') -join ','))
  } else { 
    write-output ('Usage: {0} -option [-|DATA]' -f ($MyInvocation.MyCommand.Name))
  }
}
