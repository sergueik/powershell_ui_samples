# Hide process console window, shows dialog(s) to collect info, continues with the run in avisibly mode
# based on: http://www.cyberforum.ru/powershell/thread2403772.html
Add-type -name 'user32' -namespace 'native' -member @'
[DllImport("user32.dll")]
public static extern bool ShowWindow(int handle, int state);
'@

$handle = ([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle
[native.user32]::ShowWindow($handle, 0)

add-type -assemblyName 'Microsoft.VisualBasic'
$input = [Microsoft.VisualBasic.Interaction]::InputBox('Input','dummy')
# NOTE: copy paste practices danger here:
# uncommenting the following line with intent to toggle console window back to shown would "fail": no console will become visible
# [native.user32]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 1)
# saving the handle in the variable solves that
[native.user32]::ShowWindow($handle, 1)
write-output ('Input: "{0}"' -f $input)