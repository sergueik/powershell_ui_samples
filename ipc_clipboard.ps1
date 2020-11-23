#Copyright (c) 2020 Serguei Kouzmine
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

#requires -version 2

# based on: https://www.cyberforum.ru/powershell/thread901801.html
params(
  [switch] $debug
)

$debug_flag = [bool]$PSBoundParameters['debug'].IsPresent
[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')
[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')

[System.Windows.Forms.Clipboard]::Clear()
$o = new-object System.Windows.Forms.Form
$o.Text = 'input clipboard'
$o.Size = new-object System.Drawing.Size(300,200)
$o.StartPosition = 'CenterScreen'

$o.KeyPreview = $True
$o.Add_KeyDown({
  if ($_.KeyCode -eq 'Enter'){
    $x = $t.Text
    $o.Close()
  }
  if ($_.KeyCode -eq 'Escape'){
    $x = $null
    $o.Close()
  }
})

$b = new-object System.Windows.Forms.Button
$b.Location = new-object System.Drawing.Size(75,120)
$b.Size = new-object System.Drawing.Size(75,23)
$b.Text = 'OK'
$b.Add_Click({
  [System.Windows.Forms.Clipboard]::SetText($t.Text)
  $data = @()
  $data += $t.Text
  $data += 'more data'
  if ($debug_flag){
    write-host $data
  }
  set-variable -name z -value $data -force -scope Global -option AllScope
  $o.Close()
}
)
$o.Controls.Add($b)

$l = new-object System.Windows.Forms.Label
$l.Location = new-object System.Drawing.Size(10,20)
$l.Size = new-object System.Drawing.Size(280,20)
$l.Text = 'label:'
$o.Controls.Add($l)

$t = new-object System.Windows.Forms.TextBox
$t.Location = new-object System.Drawing.Size(10,40)
$t.Size = new-object System.Drawing.Size(260,20)
$t.Focus()
$t.Add_Leave({
  $x = $t.Text
})
$o.Controls.Add($t)

$o.Topmost = $True

$o.Add_Shown({
  $o.Activate()
})
[void] $o.ShowDialog()

# the Powershell script will be blocked until the form is closed
$data = [System.Windows.Forms.Clipboard]::GetText();
write-output ('clipboard: {0}' -f $data)
$z | foreach-object { $o = $_
  write-output ('global variable: {0}' -f $o)
}
if ($debug_flag){
  write-output ('Data size: {0}' -f $z.Length)
}

