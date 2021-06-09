param(
  [string]$path = 'c:\Windows\Installer\107effab.msi',
  [int[]]$Columns = @(0, 1,2, 22,24,35)
  # The information available for an item depends on the folder in which it is displayed.
  # This value corresponds to the zero-based column number that is displayed in a Shell view.
)
# NOTE: -recurse has no effect in the command 
# get-childitem -path 'C:\Windows\Installer' -filter '*msi' -recurse | foreach-object { & .\installer_property_list.ps1 $_.fullname}
$names = @{
  0 ='Name';
  1 = 'Size';
  2 = 'Type of File';
  35 = 'Program name';
  22 = 'Subject';
  24 = 'Comments';
}
$shell = New-Object -COMObject Shell.Application
$folder = Split-Path $path
$file = Split-Path $path -Leaf
$shellfolder = $shell.Namespace($folder)
$shellfile = $shellfolder.ParseName($file)
# write-output ("{0}:`t{1}" -f 'Name' , ($path -replace '^.*\\', ''))
$columns | foreach-object { $column = $_; write-output("{0}`t{1}" -f $names[$column], $shellfolder.GetDetailsOf($shellfile, $Column)) }
# https://stackoverflow.com/questions/22382010/what-options-are-available-for-shell32-folder-getdetailsof
# https://docs.microsoft.com/en-us/windows/win32/shell/folder-getdetailsof
write-output "`n"

