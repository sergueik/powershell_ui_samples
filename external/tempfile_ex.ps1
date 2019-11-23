# based on: http://www.cyberforum.ru/powershell/thread2535517.html

param(
  [string]$url,
  [switch]$noop
)

add-type -AssemblyName System.Windows.Forms
add-type -AssemblyName System.Drawing

$f = new-object System.Windows.Forms.Form
$f.Text = 'Status Server'
$f.Size = new-object System.Drawing.Size(350,500)
$f.StartPosition = 'CenterScreen'



$o = new-object System.Windows.Forms.Button
$o.Location = new-object System.Drawing.Point(10,420)
$o.Size = new-object System.Drawing.Size(75,23)
$o.Anchor = "Top, Right"
$o.Text = 'OK'
$o.Add_Click([System.EventHandler]{
  $t.Text
  $i.Items.Add
  $url = $t.Text

  $filepath = [System.IO.Path]::GetTempFileName()

  if ([bool]$PSBoundParameters['noop'].IsPresent) {

$data = @'
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis 
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. 
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu 
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in 
culpa qui officia deserunt mollit anim id est laborum
'@
  Out-String -InputObject $data | Out-File $filepath
  } else {
    (Invoke-WebRequest -Uri $url).RawContent | Out-File $filepath
  }
  #write-host ('written {0}' -f $filepath)

  get-content $filepath | foreach-object {
    [Void]$i.Items.Add($_)
  }

  remove-item $filepath -errorAction silentlycontinue

})

$n = new-object System.Windows.Forms.Button
$n.Location = new-object System.Drawing.Point(250,420)
$n.Size = new-object System.Drawing.Size(75,23)
$n.Anchor = "Top, Right"
$n.Text = 'Notepad'
$n.Add_Click([System.EventHandler]{
  param(
    [Object]$sender,
    [EventArgs]$eventargs
  )

  $i =  $sender.parent.Controls | where-object {$_.name -eq 'listbox with the name' }
  $data = $i.Items -join "`n"
  # write-host ('List box data: {0}' -f $data )
  $filepath = [System.IO.Path]::GetTempFileName()
  out-string -InputObject $data | out-file $filepath
  # write-host "Launching : notepad ${filepath}"
  start-process -filepath 'C:\Windows\System32\notepad.exe' -argumentlist $filepath
  # find by window title
  $filename = $filepath -replace '^.*\\', ''
  while (-not (get-Process | where-object { $_.mainWindowTItle -match $filename -and $_.ProcessName -match 'notepad' } | select-object -expandproperty Responding )){
    start-sleep -millisecond 100
  }
  $sender.parent.close()
})

$c = new-object System.Windows.Forms.Button
$c.Location = new-object System.Drawing.Point(90,420)
$c.Size = new-object System.Drawing.Size(75,23)
$c.Anchor = "Top, Right"
$c.Text = 'Cancel'
$c.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

$l = new-object System.Windows.Forms.Label
$l.Location = new-object System.Drawing.Point(10,20)
$l.Size = new-object System.Drawing.Size(280,20)
$l.Text = 'Вставьте ссылку:'
$t = new-object -typename 'System.Windows.Forms.TextBox'
$t.Location = new-object System.Drawing.Point(10,40)
$t.Size = new-object System.Drawing.Size(315,20)
$t.Anchor = 'Top, Left, Right'
$t.width = 315;

$i = new-object System.Windows.Forms.ListBox
$i.DisplayMember = $tmp.FullName
$i.Name = 'listbox with the name'
$i.Location = new-object System.Drawing.Point(10,75)
$i.Size = new-object System.Drawing.Size(315,330)
$i.Anchor = "Top, Bottom, Left, Right"
$i.Height = 330

$f.Controls.AddRange(@($i, $t, $l, $c, $n, $o ))

$f.Topmost = $true
$f.Add_Shown({$t.Select()})
$f.Add_Shown({$i.Select()})
$f.ShowDialog()
