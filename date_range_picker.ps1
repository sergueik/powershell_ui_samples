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

function measure_width{
  # NOTE no type declarations
  param(
    $control,
    [System.Drawing.Font]$font
  )
 $text_width = ($control.CreateGraphics().MeasureString($control.Text, $font).Width)
 if ($text_width -lt $control.Size.Width) {
  $result = $text_width
} else {
  $result = $text_width
}
 return $result
}


# based on https://devblogs.microsoft.com/scripting/hey-scripting-guy-can-windows-powershell-alleviate-my-need-to-type-dates/
# see also https://www.codeproject.com/Articles/232318/Multiple-MonthView-DatePicker-Control-in-Silverlig
# https://www.codeproject.com/Articles/4632/PallaControls-for-Windows-forms
function DateRangeReportLauncher {
  param(
    [string]$title,
    [string]$user,
    [object]$caller
  )

  @( 'System.Drawing','System.Windows.Forms') | ForEach-Object {
    [System.Reflection.Assembly]::LoadWithPartialName($_)  | out-null
  }

  $f = new-object System.Windows.Forms.Form
  $f.MaximizeBox = $false
  $f.MinimizeBox = $false
  $f.Text = $title
  $f.size = new-object System.Drawing.Size(490,422)

  $l1 = new-object System.Windows.Forms.Label
  $l1.Font = 'Microsoft Sans Serif,10'
  $l1.Location = new-object System.Drawing.Size (10,20)
  $l1.Size = new-object System.Drawing.Size (100,20)
  $l1.Text = 'Start'
  $f.Controls.Add($l1)

  $f.Font = new-object System.Drawing.Font ('Microsoft Sans Serif',10,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)

  $d1 = New-Object System.Windows.Forms.DateTimePicker
  $d1.CalendarFont  = 'Microsoft Sans Serif,11'
  $d1.Location = new-object System.Drawing.Point (120,20)
  $d1.Size = new-object System.Drawing.Size (290,20)
  $d1.Name = 'txtFrom'
  $d1.Value = (get-date).AddDays(-3)
  $f.Controls.Add($d1)

  $l2 = new-object System.Windows.Forms.Label
  $l2.Location = new-object System.Drawing.Size (10,50)
  $l2.Size = new-object System.Drawing.Size (100,20)
  $l2.Font = 'Microsoft Sans Serif,10'
  $l2.Text = 'End Date'
  $f.Controls.Add($l2)

  $d2 = New-Object System.Windows.Forms.DateTimePicker
  $d2.CalendarFont  = 'Microsoft Sans Serif,11'
  $d2.Location = new-object System.Drawing.Point (120,50)
  $d2.Size = new-object System.Drawing.Size (290,20)
  # $d2.Text = $user
  $d2.Name = 'txtTill'
  $f.Controls.Add($d2)
  # https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.datetimepicker.closeup?view=netframework-4.0
  $d1.add_CloseUp( {
    param (
      [Object] $sender,
      [System.EventArgs]$eventargs
    )
    $d2.MinDate  = $d1.value
  })
  $d1.add_ValueChanged( {
    param (
      [Object] $sender,
      [System.EventArgs]$eventargs
    )
    $d2.MinDate  = $d1.value
  })



  $l3 = new-object System.Windows.Forms.Label
  $l3.Location = new-object System.Drawing.Size (10,80)
  $l3.Size = new-object System.Drawing.Size (100,20)
  $l3.Text = 'Command'
  $f.Controls.Add($l3)

  $t3 = new-object System.Windows.Forms.TextBox
  $t3.Location = new-object System.Drawing.Point (120,80)
  $t3.Multiline = $true 
  $t3.Size = new-object System.Drawing.Size (290,220)
  
  $t3.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
    $t3.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
    $t3.Anchor = [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Bottom
  #   strOriginal = txt.Text;
  # https://www.codeproject.com/Articles/13394/Multiline-TextBox-with-MaxLength-Validation
  $t3.Text = @'
curl.exe "https://www.wikipedia.org" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0)" "from": 1612933200, "till": 1612933200 ,"uri":""
'@

  $t3.Name = 'txtCommand'
  $t3.add_textChanged({  
    param (
      [Object] $sender,
      [System.EventArgs]$eventargs
    )
    $lines = $t3.Lines.Length
    $text = ($t3.Lines -join ' ')
    # write-host $text
  })
  $f.Controls.Add($t3)

  $bOK = new-object System.Windows.Forms.Button

  $bOK.Text = 'OK'
  $bOK.Name = 'btnOK'
  $right_margin = 60
  $margin_y = 16
  $left_margin = 24
  $y = ($t3.Location.Y +  $t3.Size.Height + $margin_y)
  $bOK.Location = new-object System.Drawing.Point($left_margin, $y)
  $f.Controls.Add($bOK)
  $f.AcceptButton = $bOK
  # https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.control.creategraphics
  # https://docs.microsoft.com/en-us/dotnet/api/system.drawing.graphics.measurestring

  $bCancel = new-object System.Windows.Forms.Button
  $bCancel.Text = 'Cancel'
  $bCancel.Name = 'btnCancel'
  $bCancel.AutoSize = $true
  $w = measure_width  -font $f.Font -control $bCancel
  $bCancel.Location = new-object System.Drawing.Point(($f.Size.Width - $w - $right_margin), $bOK.Location.y)
  $f.Controls.Add($bCancel)
<#
  $f.SuspendLayout()
  $f.Controls.AddRange(@( $l1, $d1, $l2, $d2, $bOK, $bCancel))
  $f.ResumeLayout($true)
  $f.PerformLayout()
#>


  $bCancel.add_click({
    $caller.txtTill = $null
    $caller.txtFrom = $null
    $f.Close()
  })
  $bOK.add_click({
    $caller.Data = $RESULT_OK
    $caller.TxtTill = $d2.value # using getter
    $caller.txtFrom = $d1.value
    $caller.TxtCommand = $t3.Text
    $f.Close()
  })

  $f.Controls.Add($l)
  $f.Topmost = $true

  $caller.Data = $RESULT_CANCEL
  $f.Add_Shown({
    $f.ActiveControl = $d2
    $f.Activate()
  })
  $f.KeyPreview = $True
  $f.Add_KeyDown({
    if ($_.KeyCode -eq 'Escape') {
      $caller.Data = $RESULT_CANCEL
    }
    else { return }
    $f.Close()
  })

  [void]$f.ShowDialog([win32window]($caller))
  $f.Dispose()
}

Add-Type -TypeDefinition @"
using System;
using System.Windows.Forms;
public class Win32Window : IWin32Window
{
    private IntPtr _hWnd;
    private int _data;
    private string _txtFrom;
    private string _txtTill;
    private string _txtCommand;

    public string txtCommand {
        get { return _txtCommand; }
        set { _txtCommand = value; }
    }

    public int Data
    {
        get { return _data; }
        set { _data = value; }
    }


    public string txtFrom {
        get { return _txtFrom; }
        set { _txtFrom = value; }
    }
    public string TxtTill
    {
        get { return _txtTill; }
        set { _txtTill = value; }
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

[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')

$debug_flag = [bool]$PSBoundParameters['debug'].IsPresent
if ($debug_flag){
  $DebugPreference = 'Continue'
}
$title = 'Enter Calendar Date Range'
$window_handle = [System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle
$caller = new-object Win32Window -ArgumentList ($window_handle)
$caller.Data = 1;
DateRangeReportLauncher -Title $title -user $user -caller $caller

if ($caller.Data -ne $RESULT_CANCEL) {
  if ($caller.txtFrom -ne '' -and $caller.txtTill -ne '') {
    $command = $caller.txtCommand
    $from = $caller.txtFrom
    $till = $caller.txtTill
    if ($debug) {
      write-output ('Range: {0} / {1}' -f $from, $till)
    }
    # https://stackoverflow.com/questions/38717490/convert-a-string-to-datetime-in-powershell
    $date1 = [datetime]::parseexact(($caller.txtFrom -replace ' .*$', ''), 'MM/dd/yyyy', $null)
    $date2 = [datetime]::parseexact(($caller.txtTill -replace ' .*$', ''), 'MM/dd/yyyy', $null)
    # https://stackoverflow.com/questions/22406841/powershell-list-the-dates-between-a-range-of-dates
    for ( $day = $date1; $day -lt $date2; $day = $day.AddDays(1) ) {
      # https://stackoverflow.com/questions/4192971/in-powershell-how-do-i-convert-datetime-to-unix-time
      $from = [Math]::Floor([decimal](Get-Date($day).ToUniversalTime() -uformat '%s'))
      if ($debug) {
        write-output ('Day: {0} Seconds: {1}' -f ($day.ToShortDateString()), $from )
      }
      $till = [Math]::Floor([decimal](Get-Date($day).AddDays(1).ToUniversalTime() -uformat '%s'))
      write-output (($command -replace '"from": *[0-9]+ *,', "`"from`": ${from} ") -replace '"till": *[0-9]+ *,', "`"till`":${till} ")
    }
  }
}

<#
curl.exe "https://www.wikipedia.org" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0)"interval_begin "from": 1612242000  "till":1612328400 "uri":""
curl.exe "https://www.wikipedia.org" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0)"interval_begin "from": 1612328400  "till":1612414800 "uri":""
curl.exe "https://www.wikipedia.org" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0)"interval_begin "from": 1612414800  "till":1612501200 "uri":""
#>