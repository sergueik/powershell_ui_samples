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
param (
  [string]$user = 'demouser',
  [switch]$debug
)

function measure_width{
  # NOTE no type declarations
  param(
    $control,
    [System.Drawing.Font]$font,
    # both options are not precise
    [switch]$allow_automatic
  )
 $text_width = ($control.CreateGraphics().MeasureString($control.Text, $font).Width)
 if ($text_width -lt $control.Size.Width) {

  if ([bool]$PSBoundParameters['allow_automatic'].IsPresent) {
    $result = $control.Size.Widths
  } else {
    $result = $text_width
  }
} else {
  $result = $text_width
}
  write-host ('Width: calculated {0}' -f $result)
 return $result
}

function PromptPassword {
  param(
    [String]$title,
    [String]$user
  )

  $f = new-object System.Windows.Forms.Form
  $f.MaximizeBox = $false
  $f.MinimizeBox = $false
  $f.Text = $title
  $f.size = new-object System.Drawing.Size(290,182)

  $l1 = new-object System.Windows.Forms.Label
  $l1.Location = new-object System.Drawing.Size (10,20)
  $l1.Size = new-object System.Drawing.Size (100,20)
  $l1.Text = 'Username'
  $f.Controls.Add($l1)

  $f.Font = new-object System.Drawing.Font ('Microsoft Sans Serif',10,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)

  $t1 = new-object System.Windows.Forms.TextBox
  $t1.Location = new-object System.Drawing.Point (120,20)
  $t1.Size = new-object System.Drawing.Size (140,20)
  $t1.Text = $user
  $t1.Name = 'txtUser'
  $f.Controls.Add($t1)

  $l2 = new-object System.Windows.Forms.Label
  $l2.Location = new-object System.Drawing.Size (10,50)
  $l2.Size = new-object System.Drawing.Size (100,20)
  $l2.Text = ''
  $f.Controls.Add($l2)

  $t2 = new-object System.Windows.Forms.TextBox
  $t2.Location = new-object System.Drawing.Point (120,50)
  $t2.Size = new-object System.Drawing.Size (140,20)
  $t2.Text = ''
  $t2.Name = 'txtPassword'
  $t2.PasswordChar = '*'
  $f.Controls.Add($t2)

  $bOK = new-object System.Windows.Forms.Button

  $bOK.Text = 'OK'
  $bOK.Name = 'btnOK'
  $right_margin = 60
  $margin_y = 16
  $left_margin = 24
  $y = ($t2.Location.Y +  $t2.Size.Height + $margin_y)
  $bOK.Location = new-object System.Drawing.Point($left_margin, $y)
  $f.Controls.Add($bOK)
  $f.AcceptButton = $bOK

  $bCancel = new-object System.Windows.Forms.Button
  $bCancel.Text = 'Cancel'
  $bCancel.Name = 'btnCancel'
  $bCancel.AutoSize = $true
  # $w = measure_width  -font $f.Font -control $bCancel $allow_automatic_flag
  $w = 59
  $bCancel.Location = new-object System.Drawing.Point(($f.Size.Width - $w - $right_margin), $bOK.Location.y)
  $f.Controls.Add($bCancel)
  $bCancel.add_click({
    $t2.Text = ''
    $t1.Text = ''
    $f.Close()
  })
  $bOK.add_click({
    $f.Close()
  })

  $f.Controls.Add($l)
  $f.Topmost = $true

  $f.Add_Shown({
    $f.ActiveControl = $t2
    $f.Activate()
  })
  $f.KeyPreview = $True
  $f.Add_KeyDown({
    if ($_.KeyCode -eq 'Escape') {
      $t2.Text = ''
      $t1.Text = ''
    }
    else { return }
    $f.Close()
  })

  [void]$f.ShowDialog()
  # $f.Dispose()
  return $f
}

@( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }

if ($debug){
  $DebugPreference = 'Continue'
}
$title = 'Enter credentials'
$form = PromptPassword -Title $title -user $user
if ($form.Controls.ContainsKey('txtUser')) {
  $username = $form.Controls.find('txtUser', $false).Text
}
if ($form.Controls.ContainsKey('txtPassword')) {
  $password = $form.Controls.item($form.Controls.IndexOfKey('txtPassword')).Text
}
if (($username -ne '') -and ($password -ne '')){
  Write-Debug ('Entered username: {0} / password : {1}' -f $username, $password )
} else { 
  Write-Debug ('Dialog was canceled')
}

$form.Dispose()
