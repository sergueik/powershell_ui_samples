#Copyright (c) 2014,2019 Serguei Kouzmine
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

$so = [hashtable]::Synchronized(@{
  'Result' = '';
  'Debug_Data' = 0;
  'Window' = [System.Windows.Window]$null;
  'TextBox' = [System.Windows.Controls.TextBox]$null;
})
$so.Result = ''
$rs = [runspacefactory]::CreateRunspace()
$rs.ApartmentState = 'STA'
$rs.ThreadOptions = 'ReuseThread'
$rs.Open()
$rs.SessionStateProxy.SetVariable('so',$so)
$run_script = [powershell]::Create().AddScript({

    Add-Type -AssemblyName PresentationFramework
    [xml]$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" x:Name="Window" Title="Example with Text Boxes" Height="100" Width="300">
  <StackPanel Height="100" Width="300">
    <TextBlock FontSize="14" FontWeight="Bold" Text="A spell-checking TextBox:"/>
   <!-- 
    <TextBox FontSize="14" Text="Some other text" x:Name="another input"/>
    -->
    <TextBox AcceptsReturn="True" AcceptsTab="True" FontSize="14" Margin="5" SpellCheck.IsEnabled="True" TextWrapping="Wrap" x:Name="textbox">
        </TextBox>
  </StackPanel>
</Window>
'@
    $reader = (New-Object System.Xml.XmlNodeReader $xaml)
    $target = [Windows.Markup.XamlReader]::Load($reader)
    $so.Window = $target
    $handler = {
      param(
        [object]$sender,
        [System.Windows.Controls.TextChangedEventArgs]$eventargs
      )
      $so.Result = $sender.Text
      # omitted: stash sender details into shared object
      write-host $so.Result
    }
    # TODO: iteration over multipl etext boxes
    # @('other input','textbox')| foreach-object {
    @('another input','textbox')| foreach-object {
      $name = $_
      $control = $target.FindName($name)
      if ($control -ne $null) {
        write-host ('Processing {0}' -f $control)
        $so.TextBox = $control
	$so.Debug_Data = 10
        $event = $control.Add_TextChanged
        $event.Invoke($handler)
      }
    }
    $target.ShowDialog() | Out-Null
  })

function send_text {
  param(
    $content,
    [switch]$append
  )
  # WARNING - uncommenting the following line leads to exception
  # "The calling thread cannot access this object because a different thread owns it."
  # $so.Textbox = $so.Window.FindName("textbox")

  # NOTE - host-specific method signature:
  # TODO: select-object : Property "TextBox" cannot be found.
  ## write-host ($so|select-object -expandproperty TextBox)
  write-host $so.TextBox
  write-host $so.Debug_Data
  $so.TextBox.Dispatcher.Invoke([System.Action]{

      if ($PSBoundParameters['append_content']) {
        $so.TextBox.AppendText($content)
      } else {
        $so.TextBox.Text = $content
      }
      $so.Result = $so.TextBox.Text
    },'Normal')
}

function close_dialog {
  $so.Window.Dispatcher.Invoke([action]{
      $so.Window.Close()
    },'Normal')
}

$run_script.Runspace = $rs
Clear-Host

$data = $run_script.BeginInvoke()

# TODO - synchronize properly
# http://stackoverflow.com/questions/10330446/how-to-know-when-a-control-or-window-has-been-rendered-drawn-in-wpf
Start-Sleep 1
Write-Host $so.Result
send_text -Content 'The qick red focks jumped over the lasy brown dog.'
$cnt = 10
[bool]$done = $false
while (($cnt -ne 0) -and -not $done) {
  Write-Output ('Text: {0} ' -f $so.Result)
  if ($so.Result -eq 'The quick red fox jumped over the lazy brown dog.') {
    $done = $true;
  }
  else {
    Start-Sleep 1
  }
  $cnt --
}
close_dialog

if (-not $done) {
  Write-Output 'Time is up!'
} else {
  Write-Output 'Well done!'
}

