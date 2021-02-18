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
  [switch]$clipboard,
  [switch]$allow_automatic, # probably not useful, keep as an option to demonstrate
  [switch]$debug
)

function measure_width{
  # NOTE no type declarations
  param(
    $control,
    [System.Drawing.Font]$font,
    # both options are not precise
    [switch]$allow_automatic
  )
 $text_width = ($control.CreateGraphics().MeasureString($control.Text, $font).Width)
 if ($text_width -lt $control.Size.Width) {
  write-host ('Width: automatic {0}' -f $control.Size.Width)
  if ([bool]$PSBoundParameters['allow_automatic'].IsPresent) {
    $result = $control.Size.Width
  } else {
    $result = $text_width
  }
} else {
  $result = $text_width
  write-host ('Width: calculated {0}' -f $result)
}
 return $result
}

$RESULT_OK = 0
$RESULT_CANCEL = 2
$Readable = @{
  $RESULT_OK = 'OK'
  $RESULT_CANCEL = 'CANCEL'
}

function PromptPassword {
  param(
    [string]$title,
    [string]$user,
    [object]$caller,
    [switch]$clipboard,
    [switch]$allow_automatic
  )
  $clipboard_flag = [bool]$PSBoundParameters['clipboard'].IsPresent

  if ([bool]$PSBoundParameters['allow_automatic'].IsPresent) {
  $allow_automatic_flag = '-allow_automatic'
} else {
  $allow_automatic_flag = $null
}

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

  $t1 = new-object System.Windows.Forms.TextBox
  $t1.Location = new-object System.Drawing.Point (120,20)
  $t1.Size = new-object System.Drawing.Size (140,20)
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
  $t2.Size = new-object System.Drawing.Size (140,20)
  $t2.Text = ''
  $t2.Name = 'txtPassword'
  $t2.PasswordChar = '*'
  $f.Controls.Add($t2)

  $bOK = new-object System.Windows.Forms.Button

  $bOK.Text = 'OK'
  $bOK.Name = 'btnOK'
  $right_margin = 60
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
  $w = measure_width  -font $f.Font -control $bCancel $allow_automatic_flag
  write-host ('measure_width: {0}' -f $w)
  $bCancel.Location = new-object System.Drawing.Point(($f.Size.Width - $w - $right_margin), $bOK.Location.y)
  $f.Controls.Add($bCancel)
<#

  $bE1 = new-object System.Windows.Forms.Button
  $bE1.Text = 'Really Cancel'
  $bE1.Name = 'bE1'
  $bE1.AutoSize = $true
  $right_margin = 60
  $w = measure_width  -font $f.Font -control $bE1 $allow_automatic_flag
  write-host ('measure_width: {0}' -f $w)

  $bE1.Location = new-object System.Drawing.Point(($f.Size.Width - $w - $right_margin), ($bCancel.Location.y + $bCancel.Size.Height + $margin_y))
  $f.Controls.Add($bE1)

  $bE2 = new-object System.Windows.Forms.Button
  $bE2.Text = 'Really Really Cancel'
  $bE2.Name = 'bE2'
  $bE2.AutoSize = $true
  $right_margin = 60
  $w = measure_width  -font $f.Font -control $bE2 $allow_automatic_flag
  write-host ('measure_width: {0}' -f $w)

  $bE2.Location = new-object System.Drawing.Point(($f.Size.Width - $w - $right_margin), ($bE1.Location.y + $bE1.Size.Height + $margin_y))
  $f.Controls.Add($bE2)
#>
<#
  $f.SuspendLayout()
  $f.Controls.AddRange(@(
    $l1,
    $t1,
    $l2,
    $t2,
    $bOK,
    $bCancel,
    ))
  $f.ResumeLayout($true)
  $f.PerformLayout()
#>

  $bCancel.add_click({
    if ($clipboard_flag) {
      [System.Windows.Forms.Clipboard]::Clear()
    } else {
      $caller.txtPassword = $null
      $caller.txtUser = $null
    }
    $f.Close()
  })
  $bOK.add_click({
    if ($clipboard_flag) {
      $Password = $t2.Text
      $user = $t1.Text

      [String]$cred = "${user}:${Password}"
      write-host ('Encoding {0}' -f $cred)
      $encodedCred = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($cred))

      # $basicAuthValue = "Basic $encodedCred"
      #
      # $Headers = @{
      #  Authorization = $basicAuthValue
      # }

      # ContentType = 'application/json'
      # $uri = 'https://www.github.com
      # Invoke-WebRequest -Uri $uri -ContentType 'text/json' -Headers $Headers

      [System.Windows.Forms.Clipboard]::SetText($encodedCred)
    } else {
      $caller.Data = $RESULT_OK
      $caller.txtPassword = $t2.Text
      $caller.txtUser = $t1.Text
    }
    $f.Close()
  })

  $f.Controls.Add($l)
  $f.Topmost = $true

  if ($clipboard_flag) {
      [System.Windows.Forms.Clipboard]::Clear()
  } else {
    $caller.Data = $RESULT_CANCEL
  }
  $f.Add_Shown({
    $f.ActiveControl = $t2
    $f.Activate()
  })
  $f.KeyPreview = $True
  $f.Add_KeyDown({
    if ($_.KeyCode -eq 'Escape') {
      if ($clipboard_flag) {
        [System.Windows.Forms.Clipboard]::Clear()
      } else {
        $caller.Data = $RESULT_CANCEL
      }
    }
    else { return }
    $f.Close()
  })

  if ($clipboard_flag) {
    [void]$f.ShowDialog()
  } else {
    [void]$f.ShowDialog([win32window]($caller))
  }
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

$clipboard_flag = [bool]$PSBoundParameters['clipboard'].IsPresent
if ([bool]$PSBoundParameters['allow_automatic'].IsPresent) {
  $allow_automatic_flag = '-allow_automatic'
} else {
  $allow_automatic_flag = $null
}
if ($debug){
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
$o = new-object Helper
if (-not $clipboard_flag) {
  write-output '1'
  $window_handle = [System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle
  write-output ('Using current process handle {0}' -f $window_handle)
  if ($window_handle -eq 0) {
    $processid = [System.Diagnostics.Process]::GetCurrentProcess().Id
    $parent_process_id = get-wmiobject win32_process | where-object {$_.processid -eq  $processid } | select-object -expandproperty parentprocessid

    $window_handle = get-process -id $parent_process_id | select-object -expandproperty MainWindowHandle $allow_automatic_flag
    write-output ('Using current process parent process {0} handle {1}' -f $parent_process_id, $window_handle)
  }

  $caller = new-object Win32Window -ArgumentList ($window_handle)
  PromptPassword -Title $title -user $user -caller $caller
  if ($caller.Data -ne $RESULT_CANCEL) {
    if ($debug){
      Write-Debug ('Original username/password was: {0} / {1}' -f $caller.txtUser, $caller.txtPassword)
    }    
  }
} else {
  PromptPassword -Title $title -user $user -clipboard $allow_automatic_flag
  $data = [System.Windows.Forms.Clipboard]::GetText()
  if ($debug){
  [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String( $data))

  } else {
    write-output ('clipboard: {0}' -f $data)
  }
  [System.Windows.Forms.Clipboard]::Clear()

}
