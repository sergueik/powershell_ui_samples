#Copyright (c) 2021 Serguei Kouzmine
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

param(
  # NOTE: Powershell does some conversion silently, based on param type
  # [String]$option = $null,
  [string[]]$options = @()
)


# inspired by: https://www.cyberforum.ru/powershell/thread2805448.html
$global:value = @()
[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
Add-Type -AssemblyName System.Windows.Forms


function collect_input {
  param(
    [string]$label
  )
  # clear the global result value
  $global:value = @()
  $f = new-object System.Windows.Forms.Form
  $f.Size = new-object System.Drawing.Size(300,415)
  $f.AutoSize = $true
  $f.StartPosition = 'CenterScreen'
  $f.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
  $f.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowOnly
  $f.ControlBox = $false
  $f.Text = ''
  $l = new-object System.Windows.Forms.Label
  $l.Location = new-object System.Drawing.Point(10,5)
  $l.Size = new-object System.Drawing.Size(140,20)
  $l.Font = New-Object System.Drawing.Font ('Microsoft Sans Serif',11 ,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)
  $l.Text = $label

  $f.Controls.Add($l)

  $b = new-object System.Windows.Forms.Button
  $b.Location = new-object System.Drawing.Size(145,5)
  $b.Size = new-object System.Drawing.Size(75,23)
  $b.Text = 'OK'
  $b.Add_Click({
    $global:value  = @()
    $debug = $false
    $reader = new-object System.IO.StringReader($t.Text)
    while ($true){
      $line = $reader.readline()
      if ($line -eq $null){
        break
      }
      if ($debug){
        write-host ('procesing {0}' -f $line)
      }
      $global:value += $line
    }
    $reader.dispose()
    if ($debug){
      write-host ('returning array: "{0}"' -f ($global:value -join ','))
    }
    $t.Clear()
    $f.Close()
  })
  $f.Controls.Add($b)

  $t = new-object System.Windows.Forms.TextBox
  $t.Location = new-object System.Drawing.Size(10,35)
  $t.Size = new-object System.Drawing.Size(290,367)
  $t.Multiline = $true
  $t.Font = New-Object System.Drawing.Font ('Microsoft Sans Serif',13 ,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)
  $t.ScrollBars = 'Vertical'
  $f.Controls.Add($t)
  $t.focus()

  $f.Topmost = $true
  $f.Add_Shown({$f.Activate()})
  [void] $f.ShowDialog()
}

if ($option.size -eq 0) {
  write-output ('Usage: {0} -option [-|DATA]' -f ($MyInvocation.MyCommand.Name))
} else {
  if ($options[0] -eq '-') {
    collect_input -label 'enter value for option:'
    $options = $global:value
  }
   write-output ('options: "{0}"' -f ($options -join ','))
}
