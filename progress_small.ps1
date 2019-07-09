# based on: http://www.cyberforum.ru/powershell/thread2480090.html
# uses stock form class:
# https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.progressbar?view=netframework-4.0
add-type -assembly System.Windows.Forms

$f = new-object System.Windows.Forms.Form
$f.Text = 'Working...'
$f.Height = 48
$f.Width = 280
$f.ControlBox = $false
$f.ShowInTaskbar = $false
$f.TopMost = $true
# $f.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
$f.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

# 
$b = new-object System.Windows.Forms.ProgressBar
$b.Name = 'PowerShellProgressBar'
$b.Style = 'Marquee'

$size = new-object 'System.Drawing.Size'
$size.Width = 280
$size.Height = 16
$b.Size = $size
$b.Left = 0
$b.Top = 0
$f.Controls.Add($b)

$f.Show() | out-null
$f.Focus() | out-null
$f.Refresh()

$max_cnt = 10
$b.maximum = $max_cnt
$cnt = 0
while ($cnt -lt $max_cnt) {
  $cnt++
  $b.step = $cnt
  write-output ('Sending progress step #{0}' -f $cnt )
  start-sleep -millisecond 250
}
$f.Close()
