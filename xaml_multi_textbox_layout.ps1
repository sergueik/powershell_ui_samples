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

# based on http://www.java2s.com/Tutorial/CSharp/0470__Windows-Presentation-Foundation/LayoutaFormwithStackPanelandGrid.htm

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

Add-Type -AssemblyName PresentationFramework
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

    @('First_Name','Last_Name','Street','City','Zip')| foreach-object {
      $name = $_
      $control = $target.FindName($name)
      if ($control -ne $null) {
        write-host ('Processing {0}' -f $control)
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


