#Copyright (c) 2019 Serguei Kouzmine
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

Add-Type -AssemblyName PresentationFramework

# see also: http://forum.oszone.net/thread-342212.html
# for the original feature request
# TODO: (+de-)serialize the shared data
$so = [hashtable]::Synchronized(@{
  'Result' = '';
  'Window' = [System.Windows.Window]$null;
  'TextBox' = [System.Windows.Controls.TextBox]$null;
})
$so.Result = ''
$rs = [runspacefactory]::CreateRunspace()
$rs.ApartmentState = 'STA'
$rs.ThreadOptions = 'ReuseThread'
$rs.Open()

# dialog origin: http://www.java2s.com/Tutorial/CSharp/0470__Windows-Presentation-Foundation/LayoutaFormwithStackPanelandGrid.htm
[xml]$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" x:Name="Window" Title="Example with Text Boxes" Height="400" Width="300">
  <Grid>
    <StackPanel Name="StackPanel1" Margin="0,0,0,0">
      <Expander Header="Name" Margin="0,0,0,0" Name="Expander1" IsExpanded="True">
        <StackPanel Margin="20,0,0,0">
          <StackPanel Height="Auto" Width="Auto" Orientation="Horizontal">
            <Label Height="25.96" Width="84">First Name</Label>
            <TextBox Height="25" Width="147" x:Name="First_Name"/>
          </StackPanel>
          <StackPanel Height="Auto" Width="Auto" Orientation="Horizontal">
            <Label Height="25.96" Width="84">Last Name</Label>
            <TextBox Height="25" Width="147" x:Name="Last_Name"/>
          </StackPanel>
        </StackPanel>
      </Expander>
      <Separator/>
      <Expander Header="Address" Margin="0,0,0,0" IsExpanded="True">
        <StackPanel Margin="20,0,0,0">
          <StackPanel Height="Auto" Width="Auto" Orientation="Horizontal">
            <Label Height="25.96" Width="84">Street</Label>
            <TextBox Height="25" Width="147" x:Name="Street"/>
          </StackPanel>
          <StackPanel Height="Auto" Width="Auto" Orientation="Horizontal">
            <Label Height="25.96" Width="84">City</Label>
            <TextBox Height="25" Width="147" x:Name="City"/>
          </StackPanel>
          <StackPanel Height="Auto" Width="Auto" Orientation="Horizontal">
            <Label Height="25.96" Width="84">State</Label>
            <TextBox Height="25" Width="147"/>
            <!-- NOTE: Constrained! when adding redundant "x:Name" attribute
            Exception calling "Load" with "1" argument(s):
            "Could not register named object. Cannot register duplicate name 'City' in this scope."
            -->
          </StackPanel>
          <StackPanel Height="Auto" Width="Auto" Orientation="Horizontal">
            <Label Height="25.96" Width="84">Zip</Label>
            <TextBox Height="25" Width="147" x:Name="Zip"/>
          </StackPanel>
        </StackPanel>
      </Expander>
      <Separator/>
    </StackPanel>
  </Grid>
</Window>
'@

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$target = [Windows.Markup.XamlReader]::Load($reader)

$so.Window = $target

# interactive exercise
<#

$textbox_nodes = $xaml.SelectNodes('//*[contains(name(.) ,"TextBox")]')
$textbox_nodes | foreach-object { write-output $_}

Height Width Name
------ ----- ----
25     147   First_Name
25     147   Last_Name
25     147   Street
25     147   City
25     147   TextBox
25     147   Zip

$textbox_nodes | select-object -first 1 | select-object -property 'Attributes'

Attributes
----------
{Height, Width, x:Name}

$textbox_nodes | select-object -first 1 | select-object -expandproperty'Attributes'

#text
-----
25
147
First_Name

#>

$textbox_nodes = $xaml.SelectNodes('//*[contains(name(.) ,"TextBox")]')
$textbox_names = @()
$textbox_nodes | foreach-object {
  $textbox_node = $_
  if (($textbox_node.Attributes -ne $null) -and ($textbox_node.Attributes.GetNamedItem('x:Name') -ne $null )) {
     $name = $textbox_node.Attributes['x:Name'].'#text'
     if ($name -ne $null) {
       write-host ('Found DOM element attribute: {0} of {1} of namepace {2} ' -f $name, $textbox_node.getType(), $textbox_node.GetNamespaceOfPrefix('x'))
       $textbox_names += $name
     }
  }
}

write-host ('names: {0}' -f ( $textbox_names -join ','))
# @('First_Name','Last_Name','Street','City','State', 'Zip')
$textbox_names | foreach-object {
  $name = $_
  $control = $target.FindName($name)
  if ($control -ne $null) {
    write-host ('Adding event handler to {0} named {1}' -f $control.getType() , $control.Name)
    $control.Background = [System.Windows.Media.Brushes]::Aqua
    $so.TextBox = $control
    $event = $control.Add_TextChanged
    $handler = {
      param(
        [object]$sender,
        [System.Windows.Controls.TextChangedEventArgs]$eventargs
      )
      $so.Result = $sender.Text
      # omitted: stash sender details into shared object
      write-host $so.Result
      write-host $sender.Name
    }
	# $hander is an System.Management.Automation.ScriptBlock
	# TODO: figure out how to clone
    $event.Invoke($handler)
  }
}
$target.ShowDialog() | Out-Null


