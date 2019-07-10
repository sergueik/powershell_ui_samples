#Copyright (c) 2014,2019 Serguei Kouzmine
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
# basd on http://www.java2s.com/Code/CSharp/GUI-Windows-Form/ProgressBarHost.htm
Add-Type -TypeDefinition @'

using System;
using System.Drawing;
using System.Collections;
using System.Windows.Forms;
using System.Data;

namespace ProgressBarUtility
{

    public class Progress : System.Windows.Forms.UserControl {
        internal System.Windows.Forms.Label lblProgress;
        internal System.Windows.Forms.ProgressBar Bar;

        private System.Windows.Forms.Form form;
        public System.Windows.Forms.Form Form {
            get {
                return this.form;
            }
            set {
                this.form = value;
            }
        }

        public Progress() {
            InitializeComponent();
        }

        // makes the bar portion of the window invisible, but form remain open
        public void Finish() {
          // The progress widget disappears but form remains visible
          this.Dispose(true);
          // invoking stock method of Component class
          // this.ParentForm.Close() would invalidate some container in between the User Control and the form is closed,
          // but form rcould remain visible
          // and may lead to NPE therefore
          // closes the Form using the reference passed explicitly
          this.Form.Close();
        }


        private void InitializeComponent()
        {
            this.lblProgress = new System.Windows.Forms.Label();
            this.Bar = new System.Windows.Forms.ProgressBar();
            this.SuspendLayout();
            // lblProgress
            this.lblProgress.Anchor = ((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                | System.Windows.Forms.AnchorStyles.Right);
            this.lblProgress.Location = new System.Drawing.Point(5, 46);
            this.lblProgress.Name = "lblProgress";
            this.lblProgress.Size = new System.Drawing.Size(152, 16);
            this.lblProgress.TabIndex = 3;
            this.lblProgress.Text = "0% Done";
            this.lblProgress.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            // Bar
            this.Bar.Anchor = ((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                | System.Windows.Forms.AnchorStyles.Right);
            this.Bar.Location = new System.Drawing.Point(5, 6);
            this.Bar.Name = "Bar";
            this.Bar.Size = new System.Drawing.Size(154, 32);
            this.Bar.TabIndex = 2;
            // Progress
            this.Controls.AddRange(new System.Windows.Forms.Control[] {
                                                                          this.lblProgress,
                                                                          this.Bar});
            this.Name = "Progress";
            this.Size = new System.Drawing.Size(164, 68);
            this.ResumeLayout(false);

        }

        public int Value
        {
            get
            {
                return Bar.Value;
            }
            set
            {
                Bar.Value = value;
                UpdateLabel();
            }
        }

        public int Maximum
        {
            get
            {
                return Bar.Maximum;
            }
            set
            {
                Bar.Maximum = value;
            }
        }

        public int Step
        {
            get
            {
                return Bar.Step;
            }
            set
            {
                Bar.Step = value;
            }
        }

        public void PerformStep()
        {
            Bar.PerformStep();
            UpdateLabel();
        }

        private void UpdateLabel()
        {
            lblProgress.Text = (Math.Round((decimal)(Bar.Value * 100) /
                Bar.Maximum)).ToString();
            lblProgress.Text += "% Done";
        }
    }



}

public class Win32Window : IWin32Window
{
    private IntPtr _hWnd;
    private bool _visible;

    public bool Visible
    {
        get { return _visible; }
        set { _visible = value; }
    }

    public Win32Window(IntPtr handle)
    {
        _hWnd = handle;
    }

    private ProgressBarUtility.Progress _target;
    public ProgressBarUtility.Progress Target
    {
        get { return _target; }
        set { _target = value; }
    }

    public IntPtr Handle
    {
        get { return _hWnd; }
    }
}

'@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Drawing.dll','System.Data.dll'


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
    'Result' = [string]'';
    'Visible' = [bool]$false;
    'ScriptDirectory' = [string]'';
    'Form' = [System.Windows.Forms.Form]$null;
    'Progress' = [ProgressBarUtility.Progress]$null;
  })

$so.ScriptDirectory = Get-ScriptDirectory

$rs = [runspacefactory]::CreateRunspace()
$rs.ApartmentState = 'STA'
$rs.ThreadOptions = 'ReuseThread'
$rs.Open()
$rs.SessionStateProxy.SetVariable('so',$so)

$caller = New-Object Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)

$run_script = [powershell]::Create().AddScript({

    # necessary Powershell method code embedded in runspace
    function showProgressBar {
      param(
        [string]$title,
        [string]$message,
        [object]$caller
      )

      @( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }

      $f = New-Object -TypeName 'System.Windows.Forms.Form'
      $f.Text = $title

      $f.Size = New-Object System.Drawing.Size (650,120)
      $f.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
      $f.AutoScaleBaseSize = New-Object System.Drawing.Size (5,14)
      $f.ClientSize = New-Object System.Drawing.Size (292,104)


      $components = New-Object -TypeName 'System.ComponentModel.Container'
      $u = New-Object -TypeName 'ProgressBarUtility.Progress'

      $so.Progress = $u
      # to close the form on 100 % progress
      # pass the form instance reference to the progress UserControl instance
      $u.Form = $f
      $u.Location = New-Object System.Drawing.Point (12,8)
      $u.Name = 'status'
      $u.Size = New-Object System.Drawing.Size (272,88)
      $u.TabIndex = 0

      $b = New-Object System.Windows.Forms.Button
      $b.Location = New-Object System.Drawing.Point (140,72)
      $b.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font
      $b.Font = New-Object System.Drawing.Font ('Microsoft Sans Serif',7,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)
      $b.Text = 'forward'
      $b.add_click({ $u.PerformStep()
          if ($u.Maximum -eq $u.Value)
          {
            $b.Enabled = false
          }

        })


      $f.Controls.AddRange(@( $b,$u))
      $f.Topmost = $True

      $so.Visible = $caller.Visible = $true
      $f.Add_Shown({ $f.Activate() })

      [void]$f.ShowDialog([win32window]($caller))

      $f.Dispose()
    }

    showProgressBar -Title $title -Message $message -caller $caller

  })


clear-Host
$run_script.Runspace = $rs

$handle = $run_script.BeginInvoke()

start-Sleep -millisecond 3000

$max_cnt = 10
$cnt = 0
while ($cnt -lt $max_cnt) {
  $cnt++
  $so.Progress.PerformStep()
  write-debug ('Sending progress step #{0}' -f $cnt )
  start-sleep -millisecond 250
}
if ($DebugPreference -eq 'Continue') {
  write-output $so.Progress
}
$so.Progress.Finish()
write-debug 'Closed the progress form'