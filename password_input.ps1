#Copyright (c) 2020 Serguei Kouzmine
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

param (
  [string]$user = 'demouser',
  [switch]$debug
)

function measure_width{
  # NOTE no type declarations
  param(
    $control,
    [System.Drawing.Font]$font
  )
 $text_width = ($control.CreateGraphics().MeasureString($control.Text, $font).Width)
 if ($text_width -lt $control.Size.Width) {
  # write-host ('Width: automatic {0}' -f $control.Size.Width)
  $result = $text_width
} else {
  $result = $text_width
  write-host ('Width: calculated {0}' -f $result)
}
 return $result
}

$RESULT_OK = 0
$RESULT_CANCEL = 2

function PromptPassword {
  param(
    [string]$title,
    [string]$user,
    [object]$caller
  )

  @( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }

  $f = new-object System.Windows.Forms.Form
  $f.MaximizeBox = $false
  $f.MinimizeBox = $false
  $f.Text = $title
  $f.size = new-object System.Drawing.Size(390,272)

  $l1 = new-object System.Windows.Forms.Label
  $l1.Location = new-object System.Drawing.Size (10,20)
  $l1.Size = new-object System.Drawing.Size (100,20)
  $l1.Text = 'Username'
  $f.Controls.Add($l1)
  
  $f.Font = new-object System.Drawing.Font ('Microsoft Sans Serif',10,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)
  # alternatively just
  $l1.Font = 'Microsoft Sans Serif,10'
  $t1 = new-object System.Windows.Forms.TextBox
  $t1.Location = new-object System.Drawing.Point (120,20)
  $t1.Size = new-object System.Drawing.Size (190,20)
  $t1.Text = $user
  $t1.Name = 'txtUser'
  $f.Controls.Add($t1)

  $l2 = new-object System.Windows.Forms.Label
  $l2.Location = new-object System.Drawing.Size (10,50)
  $l2.Size = new-object System.Drawing.Size (100,20)
  $l2.Text = 'Password'
  $f.Controls.Add($l2)

  $t2 = new-object System.Windows.Forms.TextBox
  $t2.Location = new-object System.Drawing.Point (120,50)
  $t2.Size = new-object System.Drawing.Size (190,20)
  $t2.Text = ''
  $t2.Name = 'txtPassword'
  $t2.PasswordChar = '*'
  $f.Controls.Add($t2)

  $bOK = new-object System.Windows.Forms.Button

  $bOK.Text = 'OK'
  $bOK.Name = 'btnOK'
  $right_margin = 24
  $margin_y = 16
  $left_margin = 24
  $y = ($t2.Location.Y +  $t2.Size.Height + $margin_y)
  $bOK.Location = new-object System.Drawing.Point($left_margin, $y)
  $f.Controls.Add($bOK)
  $f.AcceptButton = $bOK
  # https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.control.creategraphics
  # https://docs.microsoft.com/en-us/dotnet/api/system.drawing.graphics.measurestring

  $bCancel = new-object System.Windows.Forms.Button
  $bCancel.Text = 'Cancel'
  $bCancel.Name = 'btnCancel'
  $bCancel.AutoSize = $true
  $w = measure_width  -font $f.Font -control $bCancel
  write-host ('measure_width: {0}' -f $w)
  $bCancel.Location = new-object System.Drawing.Point(($t2.Location.x + $t2.Size.Width - $w - $right_margin ), $bOK.Location.y)
  $f.Controls.Add($bCancel)
<#
  $f.SuspendLayout()
  $f.Controls.AddRange(@( $l1, $t1, $l2, $t2, $bOK, $bCancel))
  $f.ResumeLayout($true)
  $f.PerformLayout()
#>

  $bCancel.add_click({
    $caller.txtPassword = $null
    $caller.txtUser = $null
    $f.Close()
  })
  $bOK.add_click({
    $caller.Data = $RESULT_OK
    $caller.txtPassword = $t2.Text
    $caller.txtUser = $t1.Text
    $f.Close()
  })

  $f.Controls.Add($l)
  $f.Topmost = $true

  $caller.Data = $RESULT_CANCEL
  $f.Add_Shown({
    $f.ActiveControl = $t2
    $f.Activate()
  })
  $f.KeyPreview = $True
  $f.Add_KeyDown({
    if ($_.KeyCode -eq 'Escape') {
      $caller.Data = $RESULT_CANCEL
    }
    else { return }
    $f.Close()
  })

  [void]$f.ShowDialog([win32window]($caller))
  $f.Dispose()
}

Add-Type -TypeDefinition @"
using System;
using System.Windows.Forms;
public class Win32Window : IWin32Window
{
    private IntPtr _hWnd;
    private int _data;
    private string _txtUser;
    private string _txtPassword;

    public int Data
    {
        get { return _data; }
        set { _data = value; }
    }


    public string TxtUser
    {
        get { return _txtUser; }
        set { _txtUser = value; }
    }
    public string TxtPassword
    {
        get { return _txtPassword; }
        set { _txtPassword = value; }
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

[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')

$debug_flag = [bool]$PSBoundParameters['debug'].IsPresent
if ($debug_flag){
  $DebugPreference = 'Continue'
}
$title = 'Enter credentials'
<#
NOTE: launch powershell window
[System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle
788284
within powershell window, launch powershell again
- this is often done when debugging c# code embedded in Powershell script via add-type
 - this will lose MainWindowHandle
powershell.exe
Windows PowerShell
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

[System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle
0
#>

$window_handle = [System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle
write-output ('Using current process handle {0}' -f $window_handle)
if ($window_handle -eq 0) {
  $processid = [System.Diagnostics.Process]::GetCurrentProcess().Id
  $parent_process_id = get-wmiobject win32_process | where-object {$_.processid -eq  $processid } | select-object -expandproperty parentprocessid

  $window_handle = get-process -id $parent_process_id | select-object -expandproperty MainWindowHandle
  write-output ('Using current process parent process {0} handle {1}' -f $parent_process_id, $window_handle)
}

$caller = new-object Win32Window -ArgumentList ($window_handle)
PromptPassword -Title $title -user $user -caller $caller
if ($caller.Data -ne $RESULT_CANCEL) {
  if ($debug_flag){
    Write-Debug ('Original username/password was: {0} / {1}' -f $caller.txtUser, $caller.txtPassword)
  }    
}
