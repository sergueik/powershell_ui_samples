#Copyright (c) 2015,2020 Serguei Kouzmine
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
#
# Activate a running command

# NOTE: Shell can not manage window that is minimized to become a tray item:
#  poor thing no longer has a main window title
#
# http://www.cyberforum.ru/powershell/thread2553302.html
#
# see also: https://www.cyberforum.ru/powershell/thread2587244.html (in Russian
# same topic discussed for spying for the window handle
# of the already launched process with -windowstyle hidden
# TODO: extract into standlone script
<#
param (
  [int]$copies = 4,
  [int]$delay = 4,
  [switch]$debug
)
$savedDebugpreference = $debugpreference
if ([bool]$PSBoundParameters['debug'].IsPresent) {
  $debugpreference = 'continue'
}
# origins:
# https://www.pinvoke.net/default.aspx/user32.enumwindows
# https://www.pinvoke.net/default.aspx/user32.getwindowthreadprocessid
# https://www.pinvoke.net/default.aspx/coredll/GetClassName.html
add-type -typedefinition @'

// with few typo fixes made
using System;
using System.Runtime.InteropServices;
using System.IO;
using System.Threading;
// TODO: restore process tracking (restored)
using System.Diagnostics;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Globalization;

public class EnumReport {

public delegate bool CallBackPtr(IntPtr hwnd, int lParam);
  private static CallBackPtr callBackPtr;
  private static StringBuilder results = new StringBuilder();
  private static Boolean debug;

  [DllImport("user32.dll")]
  private static extern int EnumWindows(CallBackPtr callPtr, int lPar);

  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
  static extern int GetClassName(IntPtr hWnd, StringBuilder lpClassName, int nMaxCount);

  [DllImport("user32.dll", SetLastError = true)]
  public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out IntPtr lpdwProcessId);

  public static bool Report(IntPtr hwnd, int lParam) {
    String windowClassName = GetWindowClassName(hwnd);
    if (string.Compare(windowClassName, "ConsoleWindowClass", true, CultureInfo.InvariantCulture) == 0){
      IntPtr lngPid = System.IntPtr.Zero;
      GetWindowThreadProcessId(hwnd, out lngPid);
      int processId = Convert.ToInt32(/* Marshal.ReadInt32 */ lngPid.ToString());
      String report = "window handle: " + hwnd +  " pid: " + processId + "\n";
      EnumReport.results.Append(report);
      if (debug){
        Console.Error.WriteLine(report);
      }
    }
    return true;   // continue
  }
  private static string GetWindowClassName(IntPtr hWnd) {
    StringBuilder ClassName = new StringBuilder(256);
    int nRet = GetClassName(hWnd, ClassName, ClassName.Capacity);
    return (nRet != 0) ? ClassName.ToString() : null;
  }
  public static String Collect(Boolean debug) {
    EnumReport.debug = debug;
    results.Clear();
    callBackPtr = new CallBackPtr(EnumReport.Report);
    EnumWindows(callBackPtr, 0);
    String result = EnumReport.results.ToString();
    if (debug){
      Console.Error.WriteLine(result);
    }
    return result;
  }
}
'@

write-debug ('Launch and hide {0} dummies' -f $copies )

$demoScript = "${env:TEMP}\example.cmd"

out-File -FilePath $demoScript -Encoding ASCII -InputObject 'powershell.exe -windowstyle hidden -Command "&{write-output \"wait\"; start-sleep 10; write-output \"Done\"}"'

1..$copies | foreach-object {
  start-process -FilePath 'C:\Windows\System32\cmd.exe' -argumentList "start cmd.exe /c ${demoScript}"
}

# a different pid may be chosen
$ownProcessid = (get-process -id $pid).id

Add-Type -MemberDefinition @'
private const int SW_SHOWMINIMIZED  = 2;
private const int SW_SHOWNOACTIVATE = 4;
private const int SW_RESTORE    = 9;
t
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
'@ -namespace win32 -name 'helper'

start-sleep $delay

write-debug ('Ignore own process: {0}' -f $ownProcessid )

# TODO: instance
$results = [EnumReport]::Collect($false) -split '\n'
$resultsLog = "${env:TEMP}\results.txt"
if ($debug) {
  # save a copy of the results to enable testing the following code quickly
  out-File -FilePath $resultsLog -Encoding ASCII -InputObject  $results
  $results = (get-content -path $resultsLog )  -split '\n'
}
$results | where-object { -not ($_ -match ('pid: {0}' -f $ownProcessid) ) }|
  foreach-object {
    $line = $_
    if ($line -eq '' ) { return }
    write-debug ('Line: "{0}"' -f $line)
    $matcher = 'window handle: (\d+) pid: (\d+) *$'
    $handle = $line -replace $matcher, '$1'
    $processid = $line -replace $matcher, '$2'
    if ($processid -ne $null) {
      if ($debug) {
        write-debug ('Process id: {0}' -f $processid)
        $processName = get-process -id $processid | select-object -expandproperty processName
        $commandLine = get-WmiObject Win32_Process -Filter "processid = ${processid}" | select-Object -expandproperty CommandLine
        write-debug ('Process name: {0}' -f $processName)
        write-debug ('Commandline: {0}' -f $commandLine)
      }
    write-debug ('Raise the window {0}' -f $handle)
    [win32.helper]::ShowWindowAsync(0 + $handle, 4) | out-null
  }
}
$debugpreference = $savedDebugpreference
exit 0
#>

write-host ('Restore window {0}' -f $main_window_handle )
[win32.helper]::ShowWindowAsync($main_window_handle, 4)
start-sleep -millisecond 1000

write-host ('Activate process window (optional): {0}' -f $name )
(new-object -ComObject 'WScript.Shell').AppActivate($main_window_handle )

start-sleep -millisecond 1000
write-host ('Stop process {0}' -f $name )

stop-process -Name $name


