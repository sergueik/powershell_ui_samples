# based on:
# https://github.com/dlwyatt/WinFormsExampleUpdates/blob/master/DateTimePicker.ps1
# Original example posted at http://technet.microsoft.com/en-us/library/ff730942.aspx
# see also: month_calendar_range_picker.ps1
#
#
param (
  [int]$tiles = 1
)
write-output $tiles
if ($tiles -eq 1) {
  write-output '1'
}
if ($tiles -eq 2) {
  write-output '2'
}
# exit
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$f = new-object Windows.Forms.Form

$f.Text = "Select a Date"
if ($tiles -eq 2) {
  $f.size =  new-object Drawing.Size(466,433)
}
if ($tiles -eq 1) {
  $f.Size = new-object Drawing.Size @(238,262)
}
$f.StartPosition = "CenterScreen"

$calendar = new-object System.Windows.Forms.MonthCalendar
# https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.monthcalendar.calendardimensions?view=netframework-4.0
if ($tiles -eq 2) {
  $calendar.CalendarDimensions = new-object Drawing.Size(2,2)
}
# NOTE: MonthCalenar does not appear to populate DefaultSize here.
# write-host $calenar.DefaultSize.Height

$calendar.ShowTodayCircle = $False
$calendar.MaxSelectionCount = 1
$f.Controls.Add($calendar)

$b1 = new-object System.Windows.Forms.Button
if ($tiles -eq 1) {
  $b1.Location = new-object System.Drawing.Point(8,192)
}
if ($tiles -eq 2) {
  $b1.Location = new-object System.Drawing.Point(8,362)
}
$b1.Size = new-object System.Drawing.Size(75,23)
$b1.Text = "OK"
$b1.DialogResult = [System.Windows.Forms.DialogResult]::OK
$f.AcceptButton = $b1
$f.Controls.Add($b1)
$f.add_ResizeEnd({
  $size = $f.Size 
  write-host ('Size : {0},{1}' -f $size.Width, $size.Height)
})
$b2 = new-object System.Windows.Forms.Button
if ($tiles -eq 1) {
  $b2.Location = new-object System.Drawing.Point(92,192)
}
if ($tiles -eq 2) {
  $b2.Location = new-object System.Drawing.Point(92,362)
}
$b2.Size = new-object System.Drawing.Size(75,23)
$b2.Text = "Cancel"
$b2.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$f.CancelButton = $b2
$f.Controls.Add($b2)

$f.Topmost = $True

$result = $f.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
  $date = $calendar.SelectionStart
  Write-Host "Date selected: $($date.ToShortDateString())"
}
