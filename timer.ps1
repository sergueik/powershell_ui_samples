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


Add-Type @" 

using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;

namespace ProgressBarHost
{

    public class Progress : System.Windows.Forms.UserControl
    {
        internal System.Windows.Forms.Label lblProgress;
        internal System.Windows.Forms.ProgressBar _bar;
        private System.ComponentModel.Container components = null;

        public Progress()
        {
            InitializeComponent();
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (components != null)
                {
                    components.Dispose();
                }
            }
            base.Dispose(disposing);
        }

        private void InitializeComponent()
        {
            this.lblProgress = new System.Windows.Forms.Label();
            this._bar = new System.Windows.Forms.ProgressBar();
            this.SuspendLayout();
/*
            this.lblProgress.Anchor = ((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                | System.Windows.Forms.AnchorStyles.Right);
            this.lblProgress.Location = new System.Drawing.Point(5, 46);
            this.lblProgress.Name = "lblProgress";
            this.lblProgress.Size = new System.Drawing.Size(152, 16);
            this.lblProgress.TabIndex = 3;
            this.lblProgress.Text = "0% Done";
            this.lblProgress.TextAlign = System.Drawing.ContentAlignment.TopCenter;
*/
            this._bar.Anchor = ((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                | System.Windows.Forms.AnchorStyles.Right);
            this._bar.Location = new System.Drawing.Point(5, 6);
            this._bar.Name = "Bar";
            this._bar.Size = new System.Drawing.Size(154, 32);
            this._bar.TabIndex = 2;

            this.Controls.AddRange(new System.Windows.Forms.Control[] {
                                                                          // this.lblProgress,
                                                                          this._bar});
            this.Name = "Progress";
            this.Size = new System.Drawing.Size(164, 68);
            this.ResumeLayout(false);

        }

        [Description("The current value (between 0 and Maximum) which sets the position of the progress bar"),
        Category("Behavior"), DefaultValue(0)]

        public int Value
        {
            get
            {
                return _bar.Value;
            }
            set
            {
                _bar.Value = value;
                UpdateLabel();
            }
        }

/*
        public System.Drawing.Size Size
        {
            get
            {
                return _bar.Size;
            }
            set
            {
                _bar.Size = value;
                UpdateLabel();
            }
        }
*/
        public int Maximum
        {
            get
            {
                return _bar.Maximum;
            }
            set
            {
                _bar.Maximum = value;
            }
        }

        public int Step
        {
            get
            {
                return _bar.Step;
            }
            set
            {
                _bar.Step = value;
            }
        }

        public void PerformStep()
        {
            _bar.PerformStep();
            UpdateLabel();
        }

        public void UpdateLabel()
        {
            lblProgress.Text = (Math.Round((decimal)(_bar.Value * 100) /
                _bar.Maximum)).ToString();
            lblProgress.Text += "% Done";
            _bar.Refresh(); 
            using (Graphics gr = _bar.CreateGraphics())
            {
                string sString = lblProgress.Text;
                Brush b = new SolidBrush(Color.Black);
                StringFormat sf = new StringFormat(StringFormatFlags.NoWrap);
                sf.Alignment = StringAlignment.Center;
                gr.DrawString(sString, new Font("Arial", 9.0f, FontStyle.Regular), b, _bar.ClientRectangle, sf);
                gr.Dispose();
                b.Dispose();
                sf.Dispose();
            }
        }
    }
}


"@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Drawing.dll', 'System.Data.dll'
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
    'Progress' = [System.Windows.Forms.ProgressBar]$null;
    'Data' = [string]$null;
  })

$so.ScriptDirectory = Get-ScriptDirectory

$rs = [runspacefactory]::CreateRunspace()
$rs.ApartmentState = 'STA'
$rs.ThreadOptions = 'ReuseThread'
$rs.Open()
$rs.SessionStateProxy.SetVariable('so',$so)

$run_script = [powershell]::Create().AddScript({

    # http://poshcode.org/1192
    function GenerateForm {
      param(
        [int]$timeout_sec
      )

      @( 'PresentationCore.dll','System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }

      $f = New-Object System.Windows.Forms.Form
      # $f.MaximumSize = $f.MinimumSize = New-Object System.Drawing.Size (220,65)
      $f.MaximumSize = $f.MinimumSize = New-Object System.Drawing.Size (220,42)
      $so.Form = $f
      $f.Text = 'Timer'
      $f.Name = 'form_main'
      $f.ShowIcon = $False
      $f.StartPosition = 1
      $f.DataBindings.DefaultDataSourceUpdateMode = 0
      $f.ClientSize = New-Object System.Drawing.Size (($f.MinimumSize.Width),($f.MinimumSize.Height))

      $components = New-Object System.ComponentModel.Container
      $f.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font
      $f.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
      $f.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

      $f.SuspendLayout()

      $t = New-Object System.Windows.Forms.Timer

      # $p = New-Object System.Windows.Forms.ProgressBar
      $p = new-object -typename 'ProgressBarHost.Progress'
      $p.DataBindings.DefaultDataSourceUpdateMode = 0
      $p.Maximum = $timeout_sec
      $p.Size = New-Object System.Drawing.Size (($f.ClientSize.Width),($f.ClientSize.Height))
      $p.Location = New-Object System.Drawing.Point (0,0)
      $p.Step = 1
      $p.TabIndex = 0
      $p.Style = 1
      $p.Name = 'progressBar1'
      $so.Progress = $p
<#     
      $p.add_Paint({
          param(
            [object]$sender,
            [painteventargs]$e
          )
          # $loc = New-Object System.Drawing.PointF (($p.Width / 2 - 10),($p.Height / 2 - 7))
          # $font = New-Object System.Drawing.Font ('Microsoft Sans Serif',8.25,[System.Drawing.FontStyle]::Regular)
          # $p.CreateGraphics().DrawString($f.Text,$font,[System.Drawing.Brush]::Black,$loc)

        })

#>
      $InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState

      function start_timer {

        $t.Enabled = $true
        $t.Start()

      }

      $t_OnTick = {

        $elapsed = New-TimeSpan -Seconds ($p.Maximum - $p.Value)
        $f.Text = ('{0:00}:{1:00}:{2:00}' -f $elapsed.Hours,$elapsed.Minutes,$elapsed.Seconds)
        $p.PerformStep()
        if ($p.Value -eq $p.Maximum) {
          $t.Enabled = $false
          $f.Close()
        }
      }

      $OnLoadForm_StateCorrection = {
        # Correct the initial state of the form to prevent the .Net maximized form issue
        $f.WindowState = $InitialFormWindowState
        start_timer
      }


      $l.TabIndex = 3
      $l.TextAlign = 32
      $l.Size = New-Object System.Drawing.Size (526,54)
      $elapsed = New-TimeSpan -Seconds ($p.Maximum - $p.Value)
      $f.Text = ('{0:00}:{1:00}:{2:00}' -f $elapsed.Hours,$elapsed.Minutes,$elapsed.Seconds)

      $f.Controls.Add($p)

      $t.Interval = 1000
      $t.add_tick($t_OnTick)

      $InitialFormWindowState = $f.WindowState
      $f.add_Load($OnLoadForm_StateCorrection)
      [void]$f.ShowDialog()

    }

    #Call the Function
    GenerateForm -timeout_sec 15


  })

Clear-Host
$run_script.Runspace = $rs

$handle = $run_script.BeginInvoke()
foreach ($work_step_cnt in @( 1,2,3,5,6,7)) {
  Write-Output ('Doing lengthy work step {0}' -f $work_step_cnt)
  Start-Sleep -Millisecond 1000
}
Write-Output 'All Work done'
$wait_timer_step = 0
$wait_timer_max = 2

while (-not $handle.IsCompleted) {
  Write-Output 'waiting on timer to finish'
  $wait_timer_step++
  Start-Sleep -Milliseconds 1000
  if ($wait_timer_step -ge $wait_timer_max) {
    $so.Progress.Value = $so.Progress.Maximum
    Write-Output 'Stopping timer'
    break
  }
}
Write-Output $so.Data
$run_script.EndInvoke($handle)
$rs.Close()

return
