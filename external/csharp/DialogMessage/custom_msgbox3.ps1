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

# $DebugPreference = 'Continue'
# Dialog Message in C# for .NET Framework
# https://www.codeproject.com/Articles/5264875/Dialog-Message-in-Csharp-for-NET-Framework-4-5
# https://github.com/chris-mackay/DialogMessage/tree/master/DialogMessage

param (
  [string]$user = 'demouser',
  [switch]$store,
  [switch]$debug
)
$RESULT_OK = 0
$RESULT_CANCEL = 2

function DialogMessage{
  param(
    [string]$title,
    [string]$mainInstruction,
    [string]$content_text = '',
    [object]$caller
  )
    @( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }

  $f = New-Object System.Windows.Forms.Form
  $f.Height = 157




  $components = New-Object System.ComponentModel.Container

  $f.MaximizeBox = $false
  $f.MinimizeBox = $false
  $f.Text = $title
  $panel = New-Object System.Windows.Forms.Panel
  $content = New-Object System.Windows.Forms.Label
  # Sets Content
  $content.Text = $content_text

  $m = New-Object System.Windows.Forms.Label
  # Sets MainInstruction
  $m.Text = $mainInstruction
  $tl = New-Object System.Windows.Forms.TableLayoutPanel
  $b1 = New-Object System.Windows.Forms.Button
  $b2 = New-Object System.Windows.Forms.Button
  $icon = New-Object System.Windows.Forms.PictureBox
  $panel.SuspendLayout()
  $tl.SuspendLayout()
  # ((System.ComponentModel.ISupportInitialize)($icon)).BeginInit()
  $f.SuspendLayout()

  # whiteSpace panel
  $panel.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
  $panel.BackColor = [System.Drawing.Color]::White
  $panel.Controls.Add($content)
  $panel.Controls.Add($m)
  $panel.Location = new-object System.Drawing.Point(0, 0)
  $panel.Name = 'whiteSpace'
  $panel.Size = new-object System.Drawing.Size(383, 79)
  $panel.TabIndex = 1

  # content
  $content.AutoSize = $true
  $content.Font = new-object System.Drawing.Font('Microsoft Sans Serif' , 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, 0)
  $content.Location = new-object System.Drawing.Point(54, 51)
  $content.MaximumSize = new-object System.Drawing.Size(305, 0)
  $content.Name = 'content'
  $content.Size = new-object System.Drawing.Size(44, 13)
  $content.TabIndex = 1
  $content.Text = 'Content'

  # mainInstruction
  $m.AutoSize = $true
  $m.Font = new-object System.Drawing.Font('Segoe UI', 12, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, 0)
  $m.ForeColor = [System.Drawing.Color]::FromArgb(0, 51, 188 )
  $m.Location = new-object  System.Drawing.Point(54, 13)
  $m.Margin = new-object System.Windows.Forms.Padding(5, 0, 3, 18)
  $m.MaximumSize = new-object System.Drawing.Size(305, 0)
  $m.Name = 'mainInstruction'
  $m.Size = new-object System.Drawing.Size(123, 21)
  $m.TabIndex = 0
  $m.Text = 'Main Instruction'

  # tablePanelLayout
  $tl.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]:: Right
  $tl.ColumnCount = 2
  $x1 = new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)
  $tl.ColumnStyles.Add($x1)
  $x2 = new-object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 50)
  $tl.ColumnStyles.Add($x2)
  $tl.Controls.Add($b1, 0, 0)
  $tl.Controls.Add($b2, 1, 0)
  $tl.Location = new-object System.Drawing.Point(232, 83)
  $tl.Name = 'tablePanelLayout'
  $tl.RowCount = 1
  $x3 = new-object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 50)
  $tl.RowStyles.Add($x3)
  $tl.Size = new-object System.Drawing.Size(146, 29)
  $tl.TabIndex = 2

  # Button 1
  $b1.Anchor = [System.Windows.Forms.AnchorStyles]::None
  $b1.Location = new-object System.Drawing.Point(3, 3)
  $b1.Name = 'button1'
  $b1.Size = new-object System.Drawing.Size(67, 23)
  $b1.TabIndex = 0
  $b1.Text = 'Button 1'

  # Button 2
  $b2.Anchor = [System.Windows.Forms.AnchorStyles]::None
  $b2.Location = new-object System.Drawing.Point(76, 3)
  $b2.Name = 'button2'
  $b2.Size = new-object System.Drawing.Size(67, 23)
  $b2.TabIndex = 1
  $b2.Text = 'Button 2'

  # Dialog Icon
  $icon.BackColor = [System.Drawing.Color]::White
  $icon.Location = new-object System.Drawing.Point(14, 14)
  $icon.Name = 'msgIcon'
  $icon.Size = new-object System.Drawing.Size(32, 32)
  $icon.TabIndex = 3
  $icon.TabStop = $false

  # TODO: fully convert buttons code
  $b1.Visible = $false
  # https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.dialogresult?view=netframework-4.0
  $b2.DialogResult = [System.Windows.Forms.DialogResult]::OK
  $b2.Text = 'OK'
  $f.AcceptButton = $b2
  $b2.TabIndex = 0
  $f.ActiveControl = $b2

  $icon.Image = [System.Drawing.SystemIcons]::Question.ToBitmap()

  # Main Form
  $f.AutoScaleDimensions = new-object System.Drawing.SizeF(6, 13)
  $f.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font
  $f.ClientSize = new-object System.Drawing.Size(383, 118)
  $f.Controls.Add($icon)
  $f.Controls.Add($tl)
  $f.Controls.Add($panel)
  $f.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
  $f.MaximizeBox = $false
  $f.MinimizeBox = $false
  $f.MinimumSize = new-object System.Drawing.Size(360, 157)
  $f.Name = 'MainForm'
  $f.ShowIcon = $false
  $f.ShowInTaskbar = $false
  $f.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterParent
  $f.Text = 'Window Title'
  # $f.Load += new-objectSystem.EventHandler($f.DialogMessage_Load)
  $panel.ResumeLayout($false)
  $panel.PerformLayout()
  $tl.ResumeLayout($false)
  # ((System.ComponentModel.ISupportInitialize)($icon)).EndInit()
  $f.ResumeLayout($false)

  [void]$f.ShowDialog([win32window]($caller))

  $f.Dispose()

}

$shared_assemblies = @(
  'nunit.core.dll',
  'nunit.framework.dll'
)

$shared_assemblies_path = 'c:\java\selenium\csharp\SharedAssemblies'

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

Add-Type -TypeDefinition @'
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

'@ -ReferencedAssemblies 'System.Windows.Forms.dll'



[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')


$panelindow_handle = [System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle
write-output ('Using current process handle {0}' -f $panelindow_handle)
if ($panelindow_handle -eq 0) {
  $processid = [System.Diagnostics.Process]::GetCurrentProcess().Id
  $parent_process_id = get-wmiobject win32_process | where-object {$_.processid -eq  $processid } | select-object -expandproperty parentprocessid

  $panelindow_handle = get-process -id $parent_process_id | select-object -expandproperty MainWindowHandle
  write-output ('Using current process parent process {0} handle {1}' -f $parent_process_id, $panelindow_handle)
}

$caller = new-object Win32Window -ArgumentList ($panelindow_handle)

dialogMessage -caller $caller