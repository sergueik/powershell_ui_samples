# origin: https://github.com/dalred/Mystruggle/blob/Pshellish/Test/test.ps1

function Show-FormProcess_psf {

  [void][reflection.assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
  [void][reflection.assembly]::Load('System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
  [void][reflection.assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')

  try {
    [progressbaroverlay] | Out-Null
  }
  catch
  {
    Add-Type -ReferencedAssemblies ('System.Windows.Forms','System.Drawing') -TypeDefinition @" 
using System;
using System.Windows.Forms;
using System.Drawing;
namespace DaniilProgress
{
	public class ProgressBarOverlay : System.Windows.Forms.ProgressBar
	{
		public ProgressBarOverlay()
			: base()
		{
			SetStyle(ControlStyles.OptimizedDoubleBuffer | ControlStyles.AllPaintingInWmPaint, true);
		}
		protected override void WndProc(ref Message m)
		{ 
			base.WndProc(ref m);
			if (m.Msg == 0x000F) {// WM_PAINT
				if (Style != System.Windows.Forms.ProgressBarStyle.Marquee || !string.IsNullOrEmpty(this.Text)) {
					using (Graphics g = this.CreateGraphics()) {
						using (var stringFormat = new StringFormat(StringFormatFlags.NoWrap)) {
							stringFormat.Alignment = StringAlignment.Center;
							stringFormat.LineAlignment = StringAlignment.Center;
							if (!string.IsNullOrEmpty(this.Text))
								g.DrawString(this.Text, this.Font, Brushes.Black, this.ClientRectangle, stringFormat);
							else {
								int percent = (int)(((double)Value / (double)Maximum) * 100);
								g.DrawString(percent.ToString() + "%", this.Font, Brushes.Black, this.ClientRectangle, stringFormat);
							}
						}
					}
				}
			}
		}
              
		public string TextOverlay {
			get {
				return base.Text;
			}
			set {
				base.Text = value;
				Invalidate();
			}
		}
	}
}
"@ -IgnoreWarnings | Out-Null
  }

  $Global:DownloadComplete = $False

  $timerUpdate_Tick = {
    $timerUpdate.start()
    do { [System.Windows.Forms.Application]::DoEvents() } until ($Global:DownloadComplete)
    $timerUpdate.stop()
    $ProgressForm.close()
    $webclient.Dispose()
  }

  [System.Windows.Forms.Application]::EnableVisualStyles()
  $ProgressForm = New-Object 'System.Windows.Forms.Form'
  $label1 = New-Object 'System.Windows.Forms.Label'
  $progressbaroverlay1 = New-Object 'DaniilProgress.ProgressBarOverlay'
  $InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
  $timerUpdate = New-Object 'System.Windows.Forms.Timer'

  $ProgressForm_Load = {
    $script:webclient = New-Object -TypeName System.Net.WebClient
    $webclient.add_DownloadProgressChanged([System.Net.DownloadProgressChangedEventHandler]$webclient_DownloadProgressChanged)
    $webclient.add_DownloadFileCompleted($webclient_DownloadFileCompleted)
    $webclient.DownloadFileAsync($source,$dest)
  }

  $webclient_DownloadProgressChanged = {
    param([object]$sender,[System.Net.DownloadProgressChangedEventArgs]$Global:e)
    $progressbaroverlay1.value = $e.ProgressPercentage
    $TotalBytes = (($e.TotalBytesToReceive) / 1MB).ToString(.00)
    $ReceivedBytes = (($e.BytesReceived) / 1MB).ToString(.00)
    $label1.Text = @"
Загружается $ReceivedBytes mb из $TotalBytes mb `n
"@
  }

  $webclient_DownloadFileCompleted = {
    $label1.Text = 'Загрузка завершена'
    $Global:DownloadComplete = $true
  }

  $Form_StateCorrection_Load =
  {
    $ProgressForm.WindowState = $InitialFormWindowState
  }

  $Form_Cleanup_FormClosed =
  {
    try
    {
      $ProgressForm.remove_Load($ProgressForm_Load)
      $ProgressForm.remove_Load($Form_StateCorrection_Load)
      $ProgressForm.remove_FormClosed($Form_Cleanup_FormClosed)
    }
    catch { Out-Null <# Prevent PSScriptAnalyzer warning #> }
  }

  $ProgressForm.SuspendLayout()
  $ProgressForm.Controls.Add($label1)
  $ProgressForm.Controls.Add($progressbaroverlay1)
  $ProgressForm.AutoScaleDimensions = '7, 15'
  $ProgressForm.AutoScaleMode = 'Font'
  $ProgressForm.BackgroundImageLayout = 'None'
  $ProgressForm.ClientSize = '674, 258'
  $ProgressForm.Cursor = 'Default'
  $ProgressForm.Font = 'Comic Sans MS, 8.25pt'
  $ProgressForm.Margin = '4, 3, 4, 3'
  $ProgressForm.Name = 'ProgressForm'
  $ProgressForm.Text = 'Процесс загрузки'
  $ProgressForm.add_Load($ProgressForm_Load)


  $label1.Location = '13, 145'
  $label1.Margin = '4, 0, 4, 0'
  $label1.Name = 'label1'
  $label1.Size = '648, 81'
  $label1.TabIndex = 3
  $label1.TextAlign = 'MiddleCenter'

  $progressbaroverlay1.Location = '13, 74'
  $progressbaroverlay1.Margin = '4, 3, 4, 3'
  $progressbaroverlay1.Name = 'progressbaroverlay1'
  $progressbaroverlay1.Size = '648, 50'
  $progressbaroverlay1.TabIndex = 0
  $ProgressForm.ResumeLayout()

  $InitialFormWindowState = $ProgressForm.WindowState
  $timerUpdate.add_Tick($timerUpdate_Tick)
  $timerUpdate.Interval = 1000
  $timerUpdate.Enabled = $True
  $ProgressForm.add_Load($Form_StateCorrection_Load)
  $ProgressForm.add_FormClosed($Form_Cleanup_FormClosed)
  $ProgressForm.ShowDialog()
}

$script:source = 'https://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.18.tar.bz2'
$script:dest = 'C:\temp\linux-2.6.18.tar.bz2'
Show-FormProcess_psf | Out-Null

