#Copyright (c) 2014,2020 Serguei Kouzmine
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

Add-Type -TypeDefinition @"

// "
using System;
using System.Windows.Forms;
public class Win32Window : IWin32Window
{
    private IntPtr _hWnd;
    private int _data;
    private string _message;

    public int Data
    {
        get { return _data; }
        set { _data = value; }
    }
    public string Message
    {
        get { return _message; }
        set { _message = value; }
    }

    public Win32Window(IntPtr handle)
    {
        _hWnd = handle;
    }

    public IntPtr Handle
    {
        get { return _hWnd; }
    }
}

"@ -ReferencedAssemblies 'System.Windows.Forms.dll'



function PromptWithCheckboxesAndRadionbuttons(
    [String] $title,
    [String] $message,
    [String] $arg_data,
    [Object] $caller = $null
    ){

  $arg_obj = $arg_data | convertFrom-json

  @('System.Drawing','System.Collections', 'System.ComponentModel' , 'System.Windows.Forms', 'System.Data') |  foreach-object {   [void] [System.Reflection.Assembly]::LoadWithPartialName($_) }

  $f = new-object System.Windows.Forms.Form
  $f.Text = $title
  $groupBox1 = new-object System.Windows.Forms.GroupBox
  $groupBox2 = new-object System.Windows.Forms.GroupBox

  $checkBox1 = new-object System.Windows.Forms.CheckBox
  $checkBox2 = new-object System.Windows.Forms.CheckBox
  $checkBox3 = new-object System.Windows.Forms.CheckBox

  $radioButton1 = new-object System.Windows.Forms.RadioButton
  $radioButton2 = new-object System.Windows.Forms.RadioButton
  $radioButton3 = new-object System.Windows.Forms.RadioButton
  $button1  = new-object System.Windows.Forms.Button
  $components =  new-object System.ComponentModel.Container

  $groupBox1.SuspendLayout()
  $groupBox2.SuspendLayout()
  $f.SuspendLayout()
  $color = ''
  $shapes = @()

  # groupBox1
  $groupBox1.Controls.AddRange( @( $radioButton1, $radioButton2, $radioButton3 ))
  # groupBox2
  $groupBox2.Controls.AddRange( @(  $checkBox1, $checkBox2, $checkBox3 ))
  $groupBox1.Location = new-object System.Drawing.Point(8, 120)
  $groupBox1.Name = 'groupBox1'
  $groupBox1.Size = new-object System.Drawing.Size(120, 144)
  $groupBox1.TabIndex = 1
  $groupBox1.TabStop = $false
  $groupBox1.Text = 'Color'


  $groupBox2.Location = new-object System.Drawing.Point(8, 8)
  $groupBox2.Name = 'groupBox2'
  $groupBox2.Size = new-object System.Drawing.Size(124, 112)
  $groupBox2.TabIndex = 0
  $groupBox2.TabStop = $false
  $groupBox2.Text = 'Shape'

  $color = $arg_obj.'Color'
  $shapes = $arg_obj.'Shape'

  # checkBox1
  $checkBox1.Location = new-object System.Drawing.Point(16, 16)
  $checkBox1.Name = 'checkBox1'
  $checkBox1.TabIndex = 1
  $checkBox1.Text = 'Circle'

  # checkBox2

  $checkBox2.Location = new-object System.Drawing.Point(16, 48)
  $checkBox2.Name = 'checkBox2'
  $checkBox2.TabIndex = 2
  $checkBox2.Text = 'Rectangle'

  # checkBox3

  $checkBox3.Location = new-object System.Drawing.Point(16, 80)
  $checkBox3.Name = 'checkBox3'
  $checkBox3.TabIndex = 3
  $checkBox3.Text = 'Triangle'

  @($checkBox1, $checkBox2, $checkBox3) | foreach-object {
    $control = $_
    # NOTE: fancy implementation of "find"

    if ($shapes.where( { $_ -eq $control.Text })){
      # write-host ('Setting {0} to checked' -f $control.Text)
      $control.Checked  = $true
    }
<#
NOTE: using raw c# collection methods from Powershell appears to be a challenge
[String[]] $y = [Array]::CreateInstance([String],$shapes.count)
[System.Array]::Copy($shapes,$y,$shapes.count)
$y.getType() will show
BaseType
--------
System.Array
and
Name
----
String[]

but attempt to invoke Array methods
https://docs.microsoft.com/en-us/dotnet/api/system.array.createinstance?view=netframework-4.0
will fail:

$y.Find("")
Method invocation failed because [System.String] does not contain a method named 'Find'.

$z = New-Object System.Collections.ArrayList
$z.GetType()
will return
Name
----
ArrayList
and

BaseType
--------
System.Object
$shapes | foreach-object  {$z.add($_) }

Now despite
$z  |get-member
listing methods of underlying type (String) but not of collection


$z will support the ArrayList methods
https://docs.microsoft.com/en-us/dotnet/api/system.collections.arraylist?view=netframework-4.0
e.g.
$z.Item(1)
'b'
$z.Contains('b')
True

#>
  }

  # radioButton1

  $radioButton1.Location = new-object System.Drawing.Point(8, 32)
  $radioButton1.Name = 'radioButton1'
  $radioButton1.TabIndex = 4
  $radioButton1.Text = 'Red'
  $radioButton1.Add_CheckedChanged({ })

  # radioButton2

  $radioButton2.Location = new-object System.Drawing.Point(8, 64)
  $radioButton2.Name = 'radioButton2'
  $radioButton2.TabIndex = 5
  $radioButton2.Text = 'Green'

  # radioButton3

  $radioButton3.Location = new-object System.Drawing.Point(8, 96)
  $radioButton3.Name = 'radioButton3'
  $radioButton3.TabIndex = 6
  $radioButton3.Text = 'Blue'

  @($radioButton1, $radioButton2, $radioButton3) | foreach-object {
    $control = $_
    if ($color -eq $control.Text){
      # write-host ('Setting {0} to checked' -f $control.Text)
      $control.Checked  = $true
    }
  }

  # button1

  $button1.Location = new-object System.Drawing.Point(8, 280)
  $button1.Name = 'button1'
  $button1.Size = new-object System.Drawing.Size(112, 32)
  $button1.TabIndex = 4
  $button1.Text = 'Draw'

  # NOTE: no event args specified or used
  $button1.Add_Click({

    $color = ''
    $shapes = @()

    foreach ($o in @($radioButton1, $radioButton2, $radioButton3)){
      if ($o.Checked){
        $color = $o.Text
      }
    }
    foreach ($o in @($checkBox1, $checkBox2, $checkBox3)){
      if ($o.Checked){
        $shapes += $o.Text
      }
    }
    $arg_obj.'Shape' = $shapes
    $arg_obj.'Color' = $color
    $caller.Message = convertTo-json $arg_obj
    # visual
    $g = [System.Drawing.Graphics]::FromHwnd($f.Handle)
    $g.FillRectangle(new-object System.Drawing.SolidBrush([System.Drawing.Color]::White), new-object System.Drawing.Rectangle(160, 50, 250, 250))
    $font = new-object System.Drawing.Font('Verdana', 12)
    $col = new-object System.Drawing.SolidBrush([System.Drawing.Color]::Black)

    $g.DrawString($color, $font, $col , new-object System.Drawing.PointF(176, 60))
    $g.DrawString([String]::Join(';', $shapes ), $font, $col , new-object System.Drawing.PointF(176, 80))
    start-sleep 1
    $f.Close()
  })

  # Form1

  $f.AutoScaleBaseSize = new-object System.Drawing.Size(5, 13)
  $f.ClientSize = new-object System.Drawing.Size(308, 317)
  $f.Controls.AddRange( @( $button1, $groupBox1, $groupBox2))

  $f.Name = 'Form1'
  $f.Text = 'CheckBox and RadioButton Sample'
  $groupBox1.ResumeLayout($false)
  $f.ResumeLayout($false)

  $f.StartPosition = 'CenterScreen'

  $f.KeyPreview = $true

  # NOTE: using default script argument $_ (providing the signature)
  $f.Add_KeyDown({
  <#
    param(
      [object]$s,
      [System.Windows.Forms.KeyPressEventArgs]$e
    )
  #>
    if ($_.KeyCode -eq 'Escape') {
      $caller.Data = $RESULT_CANCEL
    } else {  }
    $f.Close()
  })

  $f.Topmost = $true
  if ($caller -eq $null ){
    $caller = new-object Win32Window -ArgumentList `
    ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)
  }

  $f.Add_Shown( { $f.Activate() } )

  [Void] $f.ShowDialog([Win32Window] ($caller) )
  $f.Dispose()
  # this does data return explicitly
  return $caller.Message
}

$arg_data = @'
{
  "Shape": ["Triangle", "Circle"],
  "Color": "Green"
}
'@ -join ''
$result = PromptWithCheckboxesAndRadionbuttons -message 'x,y,z' -arg_data $arg_data
write-output ($result | convertfrom-json)