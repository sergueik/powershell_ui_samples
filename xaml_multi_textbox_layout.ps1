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

# for the original feature request see: http://forum.oszone.net/thread-342212.html
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

write-output 'Locating HTML5-style Labels'
$label_nodes = $xaml.SelectNodes('//*[contains(name(.) ,"Label")][contains(text(), "Name")]')# May not have Name  yet
format-list -inputObject $label_nodes
write-output 'Locating TextBox nodes by their Labels'
$labeled_textbox_nodes = $xaml.SelectNodes('//*[contains(name(.) ,"Label")][contains(text(), "Name")]/../*[contains(name(.), "TextBox")]')# May not have Name  yet
format-list -inputObject $labeled_textbox_nodes
try {
write-output 'Locating TextBox nodes Name attributes by their Labels'
$textbox_names = $xaml.SelectNodes('//*[contains(name(.) ,"Label")][contains(text(), "Name")]/../*[contains(name(.), "TextBox")]/@x:Name')# May not have Name yet
format-list -inputObject $textbox_names
} catch [Exception] {
  write-output "Exception (ignored): $($_.Exception.GetType().FullName)"
  write-output $_.Exception.Message
  # Exception calling "SelectNodes" with "1" argument(s): "Namespace Manager or XsltContext needed. This query has a prefix, variable, or user-defined function."
}
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

<#

<?xml version="1.0"?>
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:d="http://schemas.microsoft.com/expression/blend/2008" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" x:Class="WPF_Inkass.MainWindow" Title="&#x418;&#x43D;&#x43A;&#x430;&#x441;&#x441;&#x430;&#x446;&#x438;&#x44F;" Height="400" Width="500" ResizeMode="NoResize" WindowStartupLocation="CenterScreen">
  <Grid ForceCursor="True" Width="auto">
    <Grid.ColumnDefinitions>
      <ColumnDefinition Width="auto" MinWidth="180"/>
      <ColumnDefinition/>
    </Grid.ColumnDefinitions>
    <Grid.RowDefinitions>
      <RowDefinition/>
    </Grid.RowDefinitions>
    <Grid x:Name="GridBills" Height="auto" Width="auto" Grid.Column="0" Grid.Row="0">
      <Grid.ColumnDefinitions>
        <ColumnDefinition Width="auto"/>
        <ColumnDefinition Width="auto"/>
        <ColumnDefinition Width="auto"/>
      </Grid.ColumnDefinitions>
      <Grid.RowDefinitions>
        <RowDefinition Height="auto"/>
        <RowDefinition/>
        <RowDefinition/>
        <RowDefinition/>
        <RowDefinition/>
        <RowDefinition/>
        <RowDefinition/>
        <RowDefinition/>
        <RowDefinition/>
        <RowDefinition/>
        <RowDefinition/>
      </Grid.RowDefinitions>
      <Label Content="&#x41D;&#x43E;&#x43C;&#x438;&#x43D;&#x430;&#x43B;" HorizontalContentAlignment="Center" Grid.Column="0" Background="AntiqueWhite"/>
      <Label Content="&#x41A;&#x43E;&#x43B;&#x438;&#x447;&#x435;&#x441;&#x442;&#x432;&#x43E;" HorizontalContentAlignment="Center" Grid.Column="1" Background="AntiqueWhite" BorderBrush="Transparent"/>
      <Label Content="&#x418;&#x442;&#x43E;&#x433;&#x43E;" HorizontalContentAlignment="Center" Grid.Column="2" Background="AntiqueWhite"/>
      <Label Content="1 &#x433;&#x440;&#x43D;" Width="auto" Height="auto" VerticalAlignment="Center" HorizontalAlignment="Center" Grid.Column="0" Grid.Row="1"/>
      <Label Content="2 &#x433;&#x440;&#x43D;" Width="auto" Height="auto" VerticalAlignment="Center" HorizontalAlignment="Center" Grid.Column="0" Grid.Row="2"/>
      <Label Content="5 &#x433;&#x440;&#x43D;" Width="auto" Height="auto" VerticalAlignment="Center" HorizontalAlignment="Center" Grid.Column="0" Grid.Row="3"/>
      <Label Content="10 &#x433;&#x440;&#x43D;" Width="auto" Height="auto" VerticalAlignment="Center" HorizontalAlignment="Center" Grid.Column="0" Grid.Row="4"/>
      <Label Content="20 &#x433;&#x440;&#x43D;" Width="auto" Height="auto" VerticalAlignment="Center" HorizontalAlignment="Center" Grid.Column="0" Grid.Row="5"/>
      <Label Content="50 &#x433;&#x440;&#x43D;" Width="auto" Height="auto" VerticalAlignment="Center" HorizontalAlignment="Center" Grid.Column="0" Grid.Row="6"/>
      <Label Content="100 &#x433;&#x440;&#x43D;" Width="auto" Height="auto" VerticalAlignment="Center" HorizontalAlignment="Center" Grid.Column="0" Grid.Row="7"/>
      <Label Content="200 &#x433;&#x440;&#x43D;" Width="auto" Height="auto" VerticalAlignment="Center" HorizontalAlignment="Center" Grid.Column="0" Grid.Row="8"/>
      <Label Content="500 &#x433;&#x440;&#x43D;" Width="auto" Height="auto" VerticalAlignment="Center" HorizontalAlignment="Center" Grid.Column="0" Grid.Row="9"/>
      <Label Content="1000 &#x433;&#x440;&#x43D;" Width="auto" Height="auto" VerticalAlignment="Center" HorizontalAlignment="Center" Grid.Column="0" Grid.Row="10"/>
      <TextBox Name="Bills1UAH_NumberTextbox" TabIndex="1" IsTabStop="True" BorderBrush="IndianRed" Grid.Column="1" Grid.Row="1" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center"/>
      <TextBox Name="Bills2UAH_NumberTextbox" BorderBrush="IndianRed" Grid.Column="1" Grid.Row="2" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center"/>
      <TextBox Name="Bills5UAH_NumberTextbox" BorderBrush="IndianRed" Grid.Column="1" Grid.Row="3" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center"/>
      <TextBox Name="Bills10UAH_NumberTextbox" BorderBrush="IndianRed" Grid.Column="1" Grid.Row="4" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center"/>
      <TextBox Name="Bills20UAH_NumberTextbox" BorderBrush="IndianRed" Grid.Column="1" Grid.Row="5" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center"/>
      <TextBox Name="Bills50UAH_NumberTextbox" BorderBrush="IndianRed" Grid.Column="1" Grid.Row="6" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center"/>
      <TextBox Name="Bills100UAH_NumberTextbox" BorderBrush="IndianRed" Grid.Column="1" Grid.Row="7" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center"/>
      <TextBox Name="Bills200UAH_NumberTextbox" BorderBrush="IndianRed" Grid.Column="1" Grid.Row="8" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center"/>
      <TextBox Name="Bills500UAH_NumberTextbox" BorderBrush="IndianRed" Grid.Column="1" Grid.Row="9" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center"/>
      <TextBox Name="Bills1000UAH_NumberTextbox" BorderBrush="IndianRed" Grid.Column="1" Grid.Row="10" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center"/>
      <TextBox Name="Bills1UAH_ResultTextbox" IsTabStop="False" Text="0" Grid.Column="2" Grid.Row="1" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" IsReadOnly="True" BorderBrush="Transparent"/>
      <TextBox Name="Bills2UAH_ResultTextbox" IsTabStop="False" Text="0" Grid.Column="2" Grid.Row="2" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" IsReadOnly="True" BorderBrush="Transparent"/>
      <TextBox Name="Bills5UAH_ResultTextbox" IsTabStop="False" Text="0" Grid.Column="2" Grid.Row="3" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" IsReadOnly="True" BorderBrush="Transparent"/>
      <TextBox Name="Bills10UAH_ResultTextbox" IsTabStop="False" Text="0" Grid.Column="2" Grid.Row="4" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" IsReadOnly="True" BorderBrush="Transparent"/>
      <TextBox Name="Bills20UAH_ResultTextbox" IsTabStop="False" Text="0" Grid.Column="2" Grid.Row="5" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" IsReadOnly="True" BorderBrush="Transparent"/>
      <TextBox Name="Bills50UAH_ResultTextbox" IsTabStop="False" Text="0" Grid.Column="2" Grid.Row="6" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" IsReadOnly="True" BorderBrush="Transparent"/>
      <TextBox Name="Bills100UAH_ResultTextbox" IsTabStop="False" Text="0" Grid.Column="2" Grid.Row="7" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" IsReadOnly="True" BorderBrush="Transparent"/>
      <TextBox Name="Bills200UAH_ResultTextbox" IsTabStop="False" Text="0" Grid.Column="2" Grid.Row="8" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" IsReadOnly="True" BorderBrush="Transparent"/>
      <TextBox Name="Bills500UAH_ResultTextbox" IsTabStop="False" Text="0" Grid.Column="2" Grid.Row="9" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" IsReadOnly="True" BorderBrush="Transparent"/>
      <TextBox Name="Bills1000UAH_ResultTextbox" IsTabStop="False" Text="0" Grid.Column="2" Grid.Row="10" Width="auto" Height="auto" Margin="0,0,0,0" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" IsReadOnly="True" BorderBrush="Transparent"/>
    </Grid>
    <Grid x:Name="GridAdditionals" Height="auto" Width="auto" Grid.Column="1" Grid.Row="0">
      <Grid.ColumnDefinitions>
        <ColumnDefinition Width="auto"/>
        <ColumnDefinition/>
      </Grid.ColumnDefinitions>
      <Grid.RowDefinitions>
        <RowDefinition x:Name="Title0" Height="auto"/>
        <RowDefinition x:Name="Date1" MinHeight="40" Height="auto"/>
        <RowDefinition x:Name="Bag2" MinHeight="30" Height="auto"/>
        <RowDefinition x:Name="Sender3" MinHeight="30" Height="auto"/>
        <RowDefinition x:Name="Recipient4" MinHeight="30" Height="auto"/>
        <RowDefinition x:Name="ResultSum5"/>
        <RowDefinition x:Name="Button6"/>
        <RowDefinition x:Name="Notes7" Height="auto"/>
      </Grid.RowDefinitions>
      <Label HorizontalContentAlignment="Center" Content="&#x414;&#x43E;&#x43F;. &#x438;&#x43D;&#x444;&#x43E;&#x440;&#x43C;&#x430;&#x446;&#x438;&#x44F;" Grid.Row="0" Grid.Column="0" Grid.ColumnSpan="2" Background="AntiqueWhite"/>
      <Label x:Name="InkassDateLabel" HorizontalContentAlignment="Right" Content="&#x414;&#x430;&#x442;&#x430; &#x438;&#x43D;&#x43A;&#x430;&#x441;&#x441;&#x430;&#x446;&#x438;&#x438;" VerticalAlignment="Center" Grid.Row="1" Grid.Column="0"/>
      <DatePicker Name="InkassDate" IsTodayHighlighted="True" VerticalContentAlignment="Center" Grid.Row="1" Grid.Column="1"/>
      <Label x:Name="BagNumberLabel" HorizontalContentAlignment="Right" Content="&#x421;&#x443;&#x43C;&#x43A;&#x430; &#x2116;" VerticalAlignment="Center" Grid.Row="2" Grid.Column="0"/>
      <TextBox BorderBrush="IndianRed" Name="BagNumberTextbox" VerticalContentAlignment="Center" Grid.Row="2" Grid.Column="1"/>
      <Label x:Name="SenderLabel" HorizontalContentAlignment="Right" Content="&#x41E;&#x442;&#x43F;&#x440;&#x430;&#x432;&#x438;&#x442;&#x435;&#x43B;&#x44C;:" VerticalAlignment="Center" Grid.Row="3" Grid.Column="0"/>
      <TextBox BorderBrush="IndianRed" Name="SenderTextbox" Text="&#x424;&#x41E;&#x41F; " VerticalContentAlignment="Center" Grid.Row="3" Grid.Column="1"/>
      <Label x:Name="RecipientLabel" HorizontalContentAlignment="Right" Content="&#x41F;&#x43E;&#x43B;&#x443;&#x447;&#x430;&#x442;&#x435;&#x43B;&#x44C;:" VerticalAlignment="Center" Grid.Row="4" Grid.Column="0"/>
      <TextBox BorderBrush="IndianRed" Name="RecipientTextbox" Text="&#x424;&#x41E;&#x41F; " VerticalContentAlignment="Center" Grid.Row="4" Grid.Column="1"/>
      <Label Name="ResultLabel" VerticalContentAlignment="Center" HorizontalContentAlignment="Right" Grid.Row="5" Grid.Column="0"/>
      <TextBox Name="ResultTextbox" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" Grid.Row="5" Grid.Column="1" IsTabStop="False" BorderBrush="Transparent" IsReadOnly="True" IsHitTestVisible="False"/>
      <Button IsTabStop="False" IsEnabled="True" Name="FinalButton" Content="&#x421;&#x43D;&#x430;&#x447;&#x430;&#x43B;&#x430; &#x437;&#x430;&#x43F;&#x43E;&#x43B;&#x43D;&#x438; &#x432;&#x441;&#x451; &#x43A;&#x440;&#x430;&#x441;&#x43D;&#x43E;&#x435;" Grid.ColumnSpan="2" Grid.Row="6" Width="auto" Height="auto" BorderBrush="Black"/>
    </Grid>
  </Grid>
</Window>
#>

<#

# To be able to export GUI made in Visual Studio into Powershell:
# Change first XAML row
# From: <Window x:Class="WPF_Inkass.MainWindow"
# To: <Window
# TODO: format automatically

function fValidate {
  # todo
}

function fCalculateSumms {
  # Bills
  $Bills1UAH_ResultTextbox.Text = (1 * $($Bills1UAH_NumberTextbox.Text))
  $Bills2UAH_ResultTextbox.Text = (2 * $($Bills2UAH_NumberTextbox.Text))
  $Bills5UAH_ResultTextbox.Text = (5 * $($Bills5UAH_NumberTextbox.Text))
  $Bills10UAH_ResultTextbox.Text = (10 * $($Bills10UAH_NumberTextbox.Text))
  $Bills20UAH_ResultTextbox.Text = (20 * $($Bills20UAH_NumberTextbox.Text))
  $Bills50UAH_ResultTextbox.Text = (50 * $($Bills50UAH_NumberTextbox.Text))
  $Bills100UAH_ResultTextbox.Text = (100 * $($Bills100UAH_NumberTextbox.Text))
  $Bills200UAH_ResultTextbox.Text = (200 * $($Bills200UAH_NumberTextbox.Text))
  $Bills500UAH_ResultTextbox.Text = (500 * $($Bills500UAH_NumberTextbox.Text))
  $Bills1000UAH_ResultTextbox.Text = (1000 * $($Bills1000UAH_NumberTextbox.Text))

  # Overall Result
  $overall = $(
    [decimal]$($Bills1UAH_ResultTextbox.Text) +
    [decimal]$($Bills2UAH_ResultTextbox.Text) +
    [decimal]$($Bills5UAH_ResultTextbox.Text) +
    [decimal]$($Bills10UAH_ResultTextbox.Text) +
    [decimal]$($Bills20UAH_ResultTextbox.Text) +
    [decimal]$($Bills50UAH_ResultTextbox.Text) +
    [decimal]$($Bills100UAH_ResultTextbox.Text) +
    [decimal]$($Bills200UAH_ResultTextbox.Text) +
    [decimal]$($Bills500UAH_ResultTextbox.Text) +
    [decimal]$($Bills1000UAH_ResultTextbox.Text)
  )
  $ResultLabel.Content = "Итоговая сумма:"
  $ResultTextbox.Text = "$overall грн."
  $ResultTextbox.Background = "LightGreen"
}

function fButtonClick {
  fCalculateSumms
}

[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @' форма '@

# Read XAML
$reader = (New-Object System.Xml.XmlNodeReader $XAML)
try{
  $Form=[Windows.Markup.XamlReader]::Load( $reader )
}
catch{
  Write-Warning $_.Exception
  throw
}

# Store Form Objects In PowerShell
$allnewelements = @()
$xaml.SelectNodes("//*[@Name]") | foreach-object {
  Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name); $allnewelements += $_
}

# Make DatePicker select today's date by default
$InkassDate.SelectedDate = [datetime]::Now

$button = $Form.FindName("FinalButton")
$button.Add_Click({ fButtonClick })

# Show Form SHOULD BE LAST ROW
$Form.ShowDialog() | Out-Null

# Get date with ukrainian month name in genitive case
if ($null -ne $($InkassDate.Text)) {
  [int]$MonthNumber = $InkassDate.Text | Get-Date -Format "MM"
  $MonthName = ([cultureinfo]::CreateSpecificCulture("uk-UA")).DateTimeFormat.MonthGenitiveNames[$($MonthNumber - 1)]
  $UkrainianDateText = $InkassDate.Text | Get-Date -Format "dd $($MonthName) yyyy"
}
else {
  $InkassDate.SelectedDate = [datetime]::Now
}

#>
