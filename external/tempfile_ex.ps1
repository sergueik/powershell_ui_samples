# based on: http://www.cyberforum.ru/powershell/thread2535517.html

param(
  [string]$url,
  [switch]$noop
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Status Server'
$form.Size = New-Object System.Drawing.Size(350,500)
$form.StartPosition = 'CenterScreen'


$eventHandler = [System.EventHandler]{
$textBox.Text
$listbox.Items.Add
$url = $textBox.Text

$file = [System.IO.Path]::GetTempFileName()

if ([bool]$PSBoundParameters['noop'].IsPresent) {

$data = @'
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis 
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. 
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu 
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in 
culpa qui officia deserunt mollit anim id est laborum
'@
  Out-String -InputObject $data | Out-File $file
} else {
  (Invoke-WebRequest -Uri $url).RawContent | Out-File $file
}
write-host ('written {0}' -f $file)

get-content $file | foreach-object {
  [Void]$listbox.Items.Add($_)
}

Remove-Item $file -errorAction silentlycontinue

}

$eventHandler2 = [System.EventHandler]{
  param(
    [Object]$sender,
    [EventArgs]$eventargs
  )

  $listbox =  $sender.parent.Controls | where-object {$_.name -eq 'listbox' }
  $data = $listbox.Items -join "`n"
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
}

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(10,420)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Anchor = "Top, Right"
$OKButton.Text = 'OK'
$OKButton.Add_Click($eventHandler)
$form.Controls.Add($OKButton)

$NButton = New-Object System.Windows.Forms.Button
$NButton.Location = New-Object System.Drawing.Point(250,420)
$NButton.Size = New-Object System.Drawing.Size(75,23)
$NButton.Anchor = "Top, Right"
$NButton.Text = 'Notepad'
$NButton.Add_Click($eventHandler2)
$form.Controls.Add($NButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(90,420)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Anchor = "Top, Right"
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Вставьте ссылку:'
$form.Controls.Add($label)

$textBox = New-Object "System.Windows.Forms.TextBox"
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(315,20)
$textBox.Anchor = 'Top, Left, Right'
$textBox.width = 315;
$form.Controls.Add($textBox)

$listbox = New-Object System.Windows.Forms.ListBox
$listbox.DisplayMember = $tmp.FullName
$listbox.Name = "listbox"
$listbox.Location = New-Object System.Drawing.Point(10,75)
$listbox.Size = New-Object System.Drawing.Size(315,330)
$listbox.Anchor = "Top, Bottom, Left, Right"
$listbox.Height = 330

$form.Controls.Add($listbox)

$form.Topmost = $true
$form.Add_Shown({$textBox.Select()})
$form.Add_Shown({$listbox.Select()})
$form.ShowDialog()
