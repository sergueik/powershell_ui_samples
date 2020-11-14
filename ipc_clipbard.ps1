# based on: https://www.cyberforum.ru/powershell/thread901801.html

[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')
[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')

$o = new-object System.Windows.Forms.Form
$o.Text = 'text input clipboard exchange'
$o.Size = new-object System.Drawing.Size(300,200)
$o.StartPosition = 'CenterScreen'

$o.KeyPreview = $True
$o.Add_KeyDown({
  if ($_.KeyCode -eq 'Enter'){
    $x = $t.Text
    $o.Close()
  }
})
$o.Add_KeyDown(
{
  if ($_.KeyCode -eq 'Escape'){
    $o.Close()
  }
})

$b = new-object System.Windows.Forms.Button
$b.Location = new-object System.Drawing.Size(75,120)
$b.Size = new-object System.Drawing.Size(75,23)
$b.Text = 'OK'
$b.Add_Click({
  [System.Windows.Forms.Clipboard]::SetText($t.Text)
  $o.Close()
}
)
$o.Controls.Add($b)

$l = new-object System.Windows.Forms.Label
$l.Location = new-object System.Drawing.Size(10,20)
$l.Size = new-object System.Drawing.Size(280,20)
$l.Text = 'inpt label:'
$o.Controls.Add($l)

$t = new-object System.Windows.Forms.TextBox
$t.Location = new-object System.Drawing.Size(10,40)
$t.Size = new-object System.Drawing.Size(260,20)
$o.Controls.Add($t)

$o.Topmost = $True

$o.Add_Shown({
  $o.Activate()
})
[void] $o.ShowDialog()

# the Powershell script will be blocked until the form is closed
$y = [System.Windows.Forms.Clipboard]::GetText();
$y
