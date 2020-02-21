
# based on:
# https://stackoverflow.com/questions/4993926/maximize-window-and-bring-it-in-front-with-powershell

# see also:
# https://www.pinvoke.net/default.aspx/user32.showwindowasync
# for nCmdShow parameter:
# https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-showwindow
# https://ss64.com/vb/appactivate.html for shell .AppActivate COM method to
# Activate a running command

# NOTE: Shell can not manage window that is minimized to become a tray item:
#  poor thing no longer has a main window title
#
# http://www.cyberforum.ru/powershell/thread2553302.html
#
# see also: https://www.cyberforum.ru/powershell/thread2587244.html (in Russian
# same topic discussed for spying for the window handle
# of the already launched process with -windowstyle hidden
#
param($filepath =  'c:\windows\system32\notepad.exe')

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

<#
param (
  [int]$delay = 10
)

add-type -typedefinition @'
// origin: https://www.pinvoke.net/default.aspx/user32.enumwindows
// with few typo fixes made
using System;
using System.Runtime.InteropServices;
public class EnumReport {

public delegate bool CallBackPtr(int hwnd, int lParam);
private static CallBackPtr callBackPtr;

  [DllImport("user32.dll")]
  private static extern int EnumWindows(CallBackPtr callPtr, int lPar);

  public static bool Report(int hwnd, int lParam) {
    Console.WriteLine("Window handle is "+hwnd);
    return true;
  }
  public static void Main() {
     callBackPtr = new CallBackPtr(EnumReport.Report);
    EnumWindows(callBackPtr, 0);
  }
}
'@


# hides and shows self
$proc = get-process -id $pid
$code = '[DllImport("user32.dll")]public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
$helper = add-type -memberdefinition $code -name 'win32showwindowasync' -namespace win32functions -pass
# invoke method by name, case-insensitive
$helper::ShowWindowAsync($proc.mainwindowhandle, 0) | out-null
$proc.mainwindowhandle|out-file $($env:temp + '\proc.tmp')

start-sleep $delay
[EnumReport]::Main()

$helper::showwindowasync($proc.mainwindowhandle, 4) | out-null
#>

write-host ('Restore window {0}' -f $main_window_handle )
[win32.helper]::ShowWindowAsync($main_window_handle, 4)
start-sleep -millisecond 1000

write-host ('Activate process window (optional): {0}' -f $name )
(new-object -ComObject 'WScript.Shell').AppActivate($main_window_handle )

start-sleep -millisecond 1000
write-host ('Stop process {0}' -f $name )

stop-process -Name $name
