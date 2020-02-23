#Copyright (c) 2015,2019 Serguei Kouzmine
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the 'Software'), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

# based on:
# https://stackoverflow.com/questions/4993926/maximize-window-and-bring-it-in-front-with-powershell

# see also:
# https://www.pinvoke.net/default.aspx/user32.showwindowasync
# for nCmdShow parameter:
# https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-showwindow
# https://ss64.com/vb/appactivate.html for shell .AppActivate COM method to
param(
  [String]$filepath =  'c:\windows\system32\notepad.exe'
)

# e.g. .\show_window_async_win32.ps1 C:\ProgramData\PortableApps.com\Geany\App\Geany\bin\geany.exe
$name = $filepath -replace '^.*\\', '' -replace '.exe' ,''
start-process -filepath $filepath
$main_window_handle = 0
while ($main_window_handle -eq 0) {
  $main_window_handle  = (get-process -name $name).MainWindowHandle
  start-sleep -millisecond 100
}
Add-Type -MemberDefinition @'
private const int SW_SHOWMINIMIZED  = 2;
private const int SW_SHOWNOACTIVATE = 4;
private const int SW_RESTORE    = 9;

[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
'@ -namespace win32 -name 'helper'

write-host ('Minimize window {0}' -f $main_window_handle )
[win32.helper]::ShowWindowAsync($main_window_handle, 2)
start-sleep -millisecond 1000

write-host ('Restore window {0}' -f $main_window_handle )
[win32.helper]::ShowWindowAsync($main_window_handle, 4)
start-sleep -millisecond 1000

write-host ('Activate process window (optional): {0}' -f $name )
(new-object -ComObject 'WScript.Shell').AppActivate($main_window_handle )

start-sleep -millisecond 1000
write-host ('Stop process {0}' -f $name )

stop-process -Name $name



