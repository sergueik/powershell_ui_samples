#Copyright (c) 2019 Serguei Kouzmine
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
#

# based on: http://www.cyberforum.ru/powershell/thread2535517.html

param(
  [string]$url,
  [switch]$noop
)

$editors = @(
 'C:\Windows\System32\notepad.exe',
 'C:\ProgramData\PortableApps.com\Geany\App\Geany\bin\geany.exe',
 # NOTE: refrain from installing the geany system-wide
 # the geany gtk 2.0 dependency version (2.24.32 for 1.3.6)
 # may conflict with older version of gtk 2.0 runtime already present
 'C:\Program Files (x86)\Notepad++\notepad++.exe'
)
$editor_filepath = $editors[(new-object System.Random).Next() % $editors.Count ]

$editor_processname = $editor_filepath -replace '^.*\\([^\\]*).exe$', '$1'

# $editor_processname_matcher = $editor_processname -replace '([+-])', '\$1'
# alternatively use
# https://docs.microsoft.com/en-us/dotnet/api/system.string.replace?view=netframework-4.5#System_String_Replace_System_String_System_String_
$editor_processname_matcher = $editor_processname.Replace('+', '\+').Replace( '-', '\-')

write-debug ('Matching :{0}' -f $editor_processname_matcher )

@('System.Windows.Forms', 'System.Drawing') | foreach-object {
  add-type -assembly $_ }

$f = new-object System.Windows.Forms.Form
$f.Text = 'Status Server'
$f.Size = new-object System.Drawing.Size(350,500)
$f.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

$o = new-object System.Windows.Forms.Button
$o.Location = new-object System.Drawing.Point(10,420)
$o.Size = new-object System.Drawing.Size(75,23)
$o.Text = 'Browse'
$o.Name = 'Browse Button'

if ([bool]$PSBoundParameters['noop'].IsPresent) {
  $noop = $true
} else {
  $noop = $false
}
if ($noop) {
  $o.Enabled = $true
} else {
  # TODO: access enum fields [System.Windows.Forms]::ButtonState.Inactive	
  # https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.buttonstate?view=netframework-4.5
  $o.Enabled = $false
}
$o.Add_Click([System.EventHandler]{
  $filepath = [System.IO.Path]::GetTempFileName()

if ($noop) {
  $data = @'
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu
fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in
culpa qui officia deserunt mollit anim id est laborum
'@
  out-string -InputObject $data | out-file $filepath
  } else {
    write-host ('Open: {0}' -f $global:url)
    (Invoke-WebRequest -Uri $global:url).RawContent | out-file $filepath -encoding 'utf8'
  }
  # write-host ('written {0}' -f $filepath)

  get-content $filepath | foreach-object {
    [Void]$i.Items.Add($_)
  }
  remove-item $filepath -errorAction silentlycontinue
})

$n = new-object System.Windows.Forms.Button
$n.Location = new-object System.Drawing.Point(250,420)
$n.Size = new-object System.Drawing.Size(75,23)
$n.Text = $editor_processname

$n.Add_Click([System.EventHandler]{
  param(
    [Object]$sender,
    [EventArgs]$eventargs
  )

  $i =  $sender.parent.Controls | where-object {$_.name -eq 'listbox with the name' }
  $data = $i.Items -join "`n"
  $filepath = [System.IO.Path]::GetTempFileName()
  out-string -InputObject $data | out-file $filepath
  start-process -filepath $editor_filepath -argumentlist $filepath
  write-host "Launching: ${editor_processname} ${filepath}"

  $filename = $filepath -replace '^.*\\', ''
  $retry_count = 10
  while (($retry_count -gt 0) -and (-not (get-process | where-object { $_.mainWindowTItle -match $filename -and $_.ProcessName -match $editor_processname_matcher } | select-object -expandproperty Responding ))){
    start-sleep -millisecond 100
    $retry_count --
  }
  $sender.parent.close()
})

$c = new-object System.Windows.Forms.Button
$c.Location = new-object System.Drawing.Point(90,420)
$c.Size = new-object System.Drawing.Size(75,23)
$c.Text = 'Cancel'
$c.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

$l = new-object System.Windows.Forms.Label
$l.Location = new-object System.Drawing.Point(10,20)
$l.Size = new-object System.Drawing.Size(280,20)
$l.Text = 'Вставьте ссылку:'

$t = new-object -typename 'System.Windows.Forms.TextBox'
if (-not $noop) {
  $t.add_LostFocus([System.EventHandler]{
    param(
      [Object]$sender,
      [EventArgs]$eventargs
    )
    $o = $sender.parent.Controls | where-object {$_.name -eq 'Browse Button' }
    if ($sender.Text -match '[a-z]' ) {
      $global:url = $sender.Text
      $o.Enabled = $true
      write-host ('url: {0}' -f $global:url)
    } else  {
      $o.Enabled = $false
    }
  })
}
$t.Location = new-object System.Drawing.Point(10,40)
$t.Size = new-object System.Drawing.Size(315,20)
$t.text = $url
$t.width = 315;

$i = new-object System.Windows.Forms.ListBox
$i.Name = 'listbox with the name'
$i.Location = new-object System.Drawing.Point(10,75)
$i.Size = new-object System.Drawing.Size(315,330)
$i.Height = 330

$f.Controls.AddRange(@($i, $t, $l, $c, $n, $o ))

$f.Topmost = $true
$f.Add_Shown({$t.Select()})
$f.ShowDialog() | out-null

