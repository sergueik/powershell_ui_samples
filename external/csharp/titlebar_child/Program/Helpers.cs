using System;
using System.Runtime.InteropServices;

namespace Win32HooksDemo {
	public class Helpers {
		public static IntPtr Find(string ModuleName, string MainWindowTitle) {
			//Search the window using Module and Title
			IntPtr WndToFind = NativeMethods.FindWindow(ModuleName, MainWindowTitle);
			if (WndToFind.Equals(IntPtr.Zero)) {
				if (!string.IsNullOrEmpty(MainWindowTitle)) {
					//Search window using TItle only.
					WndToFind = NativeMethods.FindWindowByCaption(WndToFind, MainWindowTitle);
					if (WndToFind.Equals(IntPtr.Zero))
						return new IntPtr(0);
				}
			}
			return WndToFind;
		}

		public static WinPosition GetWindowPosition(IntPtr wnd) {
			NativeMethods.TITLEBARINFO pti = new NativeMethods.TITLEBARINFO();

			pti.cbSize = (uint)Marshal.SizeOf(pti);//Specifies the size, in bytes, of the structure. 
			//The caller must set this to sizeof(TITLEBARINFO).

			return NativeMethods.GetTitleBarInfo(wnd, ref pti) ? new WinPosition(pti) : new WinPosition() ;
		}

		public static IntPtr SetWindowLongPtr(HandleRef hWnd, int nIndex, IntPtr dwNewLong) {
			return (IntPtr.Size == 8) ? NativeMethods.SetWindowLongPtr64(hWnd, nIndex, dwNewLong): new IntPtr(NativeMethods.SetWindowLong32(hWnd, nIndex, dwNewLong.ToInt32()));
		}

		//Specifies the zero-based offset to the value to be set.
		//Valid values are in the range zero through the number of bytes of extra window memory, minus the size of an integer.
		public enum GWLParameter {
			GWL_EXSTYLE = -20,
			//Sets a new extended window style
			GWL_HINSTANCE = -6,
			//Sets a new application instance handle.
			GWL_HWNDPARENT = -8,
			//Set window handle as parent
			GWL_ID = -12,
			//Sets a new identifier of the window.
			GWL_STYLE = -16,
			// Set new window style
			GWL_USERDATA = -21,
			//Sets the user data associated with the window. This data is intended for use by the application that created the window. Its value is initially zero.
			GWL_WNDPROC = -4
			//Sets a new address for the window procedure.
		}

		public static int SetWindowLong(IntPtr windowHandle, GWLParameter nIndex, int dwNewLong) {
			return (IntPtr.Size == 8) ? (int)NativeMethods.SetWindowLongPtr64(windowHandle, nIndex, new IntPtr(dwNewLong)): NativeMethods.SetWindowLong32(windowHandle, nIndex, dwNewLong);
		}
	}
}
