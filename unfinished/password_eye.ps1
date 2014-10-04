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

#  http://www.codeplex.com/Articles/660751/PasswordEye-Control
function PromptPasswordEye (
  [object]$caller
) {


  $f = New-Object System.Windows.Forms.Form
  $f.MaximizeBox = $false
  $f.MinimizeBox = $false

  [void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
  [void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')

  $panel = New-Object System.Windows.Forms.Panel
  $button = New-Object System.Windows.Forms.Button
  $textbox = New-Object System.Windows.Forms.TextBox
  $panel.SuspendLayout()
  $f.SuspendLayout()

  $panel.Controls.Add($button)
  $panel.Controls.Add($textbox)
  $panel.ForeColor = [System.Drawing.Color]::Black
  $panel.Location = New-Object System.Drawing.Point (0,0)
  $panel.Name = 'panel'
  $panel.Size = New-Object System.Drawing.Size (250,27)
  $panel.TabIndex = 3
  $image_path = 'C:\developer\sergueik\powershell_ui_samples\unfinished\PasswordEyeImage.png'
  [System.Drawing.Bitmap]$bitmap = New-Object System.Drawing.Bitmap ($image_path)
  $button.BackgroundImage = $bitmap
  $button.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Zoom
  $button.FlatAppearance.BorderSize = 0
  $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
  $button.ForeColor = [System.Drawing.Color]::Black
  $button.Location = New-Object System.Drawing.Point (226,2)
  $button.Name = 'button'
  $button.Size = New-Object System.Drawing.Size (21,21)
  $button.TabIndex = 1
  $button.UseVisualStyleBackColor = $false

  $textbox.BackColor = [System.Drawing.Color]::White
  $textbox.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $textbox.Font = New-Object System.Drawing.Font ('Arial',12,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,[byte]0)
  $textbox.ForeColor = [System.Drawing.Color]::Black
  $textbox.Location = New-Object System.Drawing.Point (1,1)
  $textbox.MaxLength = 20
  $textbox.Name = 'textbox'
  $textbox.PasswordChar = [char]0x002A #  '*'
  $textbox.PasswordChar = [char]0x00A4 #  '¤'
  $textbox.PasswordChar = [char]0x25CF # '?'
  $textbox.Size = New-Object System.Drawing.Size (224,23)
  $textbox.TabIndex = 0

  $f.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::None
  $f.BackColor = [System.Drawing.Color]::White
  $f.Controls.Add($panel)
  $f.Name = "PasswordEye"
  $f.Size = New-Object System.Drawing.Size (256,136)
  $panel.ResumeLayout($false)
  $panel.PerformLayout()
  $f.ResumeLayout($false)
  #  [void]$f.ShowDialog([win32window ]($caller))
  [void]$f.ShowDialog()
  $f.Dispose()
}



$DebugPreference = 'Continue'
$title = 'Enter credentials'
$user = 'admin'
# $caller = New-Object Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)
PromptPasswordEye
# PromptPasswordEye -caller $caller
#if ($caller.Data -ne $RESULT_CANCEL) {
#  Write-Debug ("Result is : {0} / {1}  " -f $caller.txtUser,$caller.txtPassword)
#}



