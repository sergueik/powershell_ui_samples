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
