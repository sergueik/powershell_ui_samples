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
  write-host ('Width: calculated {0}' -f $result)
}
 return $result
}


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
  $f.size = new-object System.Drawing.Size(490,272)

  $l1 = new-object System.Windows.Forms.Label
  $l1.Font = 'Microsoft Sans Serif,10'
  $l1.Location = new-object System.Drawing.Size (10,20)
  $l1.Size = new-object System.Drawing.Size (100,20)
  $l1.Text = 'Start'
  $f.Controls.Add($l1)

  $f.Font = new-object System.Drawing.Font ('Microsoft Sans Serif',10,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)

  $d1 = New-Object System.Windows.Forms.DateTimePicker
  # ignored
  $d1.CalendarFont  = 'Microsoft Sans Serif,11'
  $d1.Location = new-object System.Drawing.Point (120,20)
  $d1.Size = new-object System.Drawing.Size (290,20)
  $d1.Name = 'txtUser'
  $f.Controls.Add($d1)

  $l2 = new-object System.Windows.Forms.Label
  $l2.Location = new-object System.Drawing.Size (10,50)
  $l2.Size = new-object System.Drawing.Size (100,20)
  $l2.Font = 'Microsoft Sans Serif,10'
  $l2.Text = 'End Date'
  $f.Controls.Add($l2)

  $d2 = New-Object System.Windows.Forms.DateTimePicker
  # TODO: event etc
  $d2.CalendarFont  = 'Microsoft Sans Serif,11'
  $d2.Location = new-object System.Drawing.Point (120,50)
  $d2.Size = new-object System.Drawing.Size (290,20)
  # $d2.Text = $user
  $d2.Name = 'txtPassword'
  $f.Controls.Add($d2)
  $d1.add_CloseUp( {
    $d2.MinDate  = $d1.value
  })

  $bOK = new-object System.Windows.Forms.Button

  $bOK.Text = 'OK'
  $bOK.Name = 'btnOK'
  $right_margin = 60
  $margin_y = 16
  $left_margin = 24
  $y = ($d2.Location.Y +  $d2.Size.Height + $margin_y)
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
  write-host ('measure_width: {0}' -f $w)
  $bCancel.Location = new-object System.Drawing.Point(($f.Size.Width - $w - $right_margin), $bOK.Location.y)
  $f.Controls.Add($bCancel)
<#
  $f.SuspendLayout()
  $f.Controls.AddRange(@( $l1, $d1, $l2, $d2, $bOK, $bCancel))
  $f.ResumeLayout($true)
  $f.PerformLayout()
#>

  $bCancel.add_click({
    $caller.txtPassword = $null
    $caller.txtUser = $null
    $f.Close()
  })
  $bOK.add_click({
    $caller.Data = $RESULT_OK
    $caller.txtPassword = $d2.value
    $caller.txtUser = $d1.value
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
    private string _txtUser;
    private string _txtPassword;

    public int Data
    {
        get { return _data; }
        set { _data = value; }
    }


    public string TxtUser
    {
        get { return _txtUser; }
        set { _txtUser = value; }
    }
    public string TxtPassword
    {
        get { return _txtPassword; }
        set { _txtPassword = value; }
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
  # https://stackoverflow.com/questions/38717490/convert-a-string-to-datetime-in-powershell
  # https://stackoverflow.com/questions/22406841/powershell-list-the-dates-between-a-range-of-dates
  if ($caller.txtUser -ne $null -and $caller.txtPassword -ne $null) {
    write-output ('Range: {0} / {1}' -f $caller.txtUser, $caller.txtPassword)
    $date1 = [datetime]::parseexact(($caller.txtUser -replace ' .*$', ''), 'MM/dd/yyyy', $null)
    $date2 = [datetime]::parseexact(($caller.txtPassword -replace ' .*$', ''), 'MM/dd/yyyy', $null)
    for ( $i = $date1; $i -lt $date2; $i=$i.AddDays(1) )  {
      $h = $i.ToShortDateString()
      # https://stackoverflow.com/questions/4192971/in-powershell-how-do-i-convert-datetime-to-unix-time
      $u =[Math]::Floor([decimal](Get-Date($i).ToUniversalTime()-uformat '%s'))
      write-output ('Day: {0} Seconds: {1}' -f $h, $u )
    }
  }
}
