param(
[String]$title = $null
)
# based on: https://superuser.com/questions/677012/in-windows-how-can-i-view-a-list-of-all-window-titles

add-type -typeDefinition @'

using System;
using System.Text;
using System.Collections.Generic;
using System.Runtime.InteropServices;

namespace Utils {

	public class WinStruct {
		public string WinTitle { get; set; }
		public int WinHwnd { get; set; }
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

		private static bool Callback(int hWnd, int lparam) {
			StringBuilder sb = new StringBuilder(256);
			int res = GetWindowText((IntPtr)hWnd, sb, 256);
			listWinStruct.Add(new WinStruct { WinHwnd = hWnd, WinTitle = sb.ToString() });
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

[Utils.Helper]::GetWindows() | where-object {
  $wintitle = $_.WinTitle
  (($title -eq $null) -and ($winTitle -ne '')) -or  ($winTitle -match $title )
} | 
sort-object property WinTitle | select-object WinTitle, @{Name="Handle"; Expression={"{0:X0}" -f $_.WinHwnd}}

