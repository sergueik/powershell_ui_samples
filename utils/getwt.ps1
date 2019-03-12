param(
  [string]$title = $null
)
# based on: https://superuser.com/questions/677012/in-windows-how-can-i-view-a-list-of-all-window-titles
# https://stackoverflow.com/questions/21508662/how-does-getwindowtext-get-the-name-of-a-window-owned-by-another-process-without
# https://stackoverflow.com/questions/1888863/how-to-get-main-window-handle-from-process-id
# https://www.pinvoke.net/default.aspx/user32.GetWindowThreadProcessId
# https://www.codeproject.com/Articles/2286/Window-Hiding-with-C
add-type -typeDefinition @'

using System;
using System.Text;
using System.Collections.Generic;
using System.Runtime.InteropServices;

namespace Utils {

	public class WinStruct {
		public string WinTitle { get; set; }
		public int WinHwnd { get; set; }
    public int ProcessId { get; set; }
	}

	public class Helper {
		private delegate bool CallBackPtr(int hwnd, int lParam);
		private static CallBackPtr callBackPtr = Callback;
		private static List<WinStruct> listWinStruct = new List<WinStruct>();

		[DllImport("User32.dll")]
		[return: MarshalAs(UnmanagedType.Bool)]
		private static extern bool EnumWindows(CallBackPtr lpEnumFunc, IntPtr lParam);

		[DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
		static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

    [DllImport("user32.dll", SetLastError=true)]
    static extern int GetWindowThreadProcessId(IntPtr hWnd, IntPtr lpdwProcessId);

		private static bool Callback(int hWnd, int lparam) {
			StringBuilder sb = new StringBuilder(256);
			int res = GetWindowText((IntPtr)hWnd, sb, 256);
      int processId = GetWindowThreadProcessId((IntPtr)hWnd,IntPtr.Zero);

			listWinStruct.Add(new WinStruct { WinHwnd = hWnd, WinTitle = sb.ToString(), ProcessId = processId});
			return true;
		}

		public static List<WinStruct> GetWindows() {
			listWinStruct = new List<WinStruct>();
			EnumWindows(callBackPtr, IntPtr.Zero);
			return listWinStruct;
		}

	}
}
'@ # NOTE: NO extra referencedassemblies necessary
$debug = $false
$width = 64
$results = [Utils.Helper]::GetWindows() | where-object {
  $wintitle = $_.WinTitle
  (($title -eq $null) -and ($winTitle -ne '')) -or  ($winTitle -match $title )
} |
sort-object -property WinTitle
if ($debug -eq $true) {
  $results |
  select-object @{Name='Window Title'; Expression= {"{0,-${width}}" -f  ($_.WinTitle).substring(0, $width)}}, @{Name='Handle'; Expression={'{0:X0}' -f $_.WinHwnd}}
}
return $results

<#

$x =  .\getwt1.ps1 -title 'Personalization'
$x | format-list

WinTitle  : Personalization
WinHwnd   : 131432
ProcessId : 2100
#>

# alternative
# based on: https://devblogs.microsoft.com/scripting/hey-scripting-guy-how-can-i-use-windows-powershell-to-get-a-list-of-all-the-open-windows-on-a-computer/

$shellApplication = new-object -com 'Shell.Application'
$windows = $shellApplication.windows() | select-object LocationName, HWND, Name
$window = $windows | where-object {$_.LocationName -match 'Personalization' -and $_.Visible -eq $true} | select-object -first 1
write-output $window | select-object LocationName,HWND,Name,FullName | format-list
$window.Quit()
<#
LocationName : Personalization
HWND         : 196982
Name         : Windows Explorer
FullName     : C:\Windows\Explorer.EXE

#>


<%
set THEME=C:\Windows\Resources\Themes\nature.theme
REM Need quotes in the argument
rundll32.exe %SystemRoot%\system32\shell32.dll,Control_RunDLL %SystemRoot%\system32\desk.cpl desk,@Themes /Action:OpenTheme /file:"%THEME%"
%>

# Scriptable Shell Objects
# https://msdn.microsoft.com/en-us/library/windows/desktop/bb776890(v=vs.85).aspx
<#
var debug = false
var shell_app_com_obj = new ActiveXObject('Shell.Application');
var windows_objs = shell_app_com_obj.Windows();
var shell_obj = new ActiveXObject('WScript.Shell');

if (debug) {
    WScript.echo(windows_objs.Count);
}
if (windows_objs.Count > 0) {
    for (var cnt = 0; cnt < windows_objs.Count; cnt++) {
        if (debug) {
            WScript.echo('cnt ' + cnt);
        }

        window_obj = windows_objs.item(cnt);
        if (window_obj.LocationName.match('Personalization')) {
            WScript.echo('Name:\t' + window_obj.Name);
            WScript.echo('HWND:\t' + window_obj.HWND);
            WScript.echo('FullName:\t' + window_obj.FullName);
            WScript.echo('LocationName:\t' + window_obj.LocationName);
            window_obj.Quit();
        }
    }
}
Microsoft (R) Windows Script Host Version 5.8
Copyright (C) Microsoft Corporation. All rights reserved.

Name:   Windows Explorer
HWND:   328060
FullName:       C:\Windows\Explorer.EXE
LocationName:   Personalization
#>

<#
Dim objShell: Set objShell = WScript.CreateObject("WScript.Shell")
Dim objShellApplication: Set objShellApplication = WScript.CreateObject("shell.application")
Dim objWindows : set objWindows = objShellApplication.Windows()
Wscript.echo objWindows.Count
Dim objWindow
For cnt = 0 To objWindows.Count-1
  set objWindow = objWindows.item(cnt)
  LocationName = objWindow.LocationName
  ' NOTE double quotes
  if InStr(LocationName,"Personalization") > 0  then
    Wscript.echo "Closing " & objWindow.HWND
    objWindow.Quit()
  end if
Next
Set objShell = Nothing
Set objWindows = Nothing
Set objShellApplication = Nothing
#>