using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace Win32HooksDemo {
	static class NativeMethods {
		// Get a handle to an application window.
		[DllImport("user32.dll", SetLastError = true)]
		internal static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

		// Find window by Caption only. Note you must pass IntPtr.Zero as the first parameter.
		[DllImport("user32.dll", EntryPoint = "FindWindow", SetLastError = true)]
		internal static extern IntPtr FindWindowByCaption(IntPtr ZeroOnly, string lpWindowName);

		[return: MarshalAs(UnmanagedType.Bool)]
		[DllImport("user32.dll")]
		internal static extern bool GetTitleBarInfo(IntPtr hwnd, ref TITLEBARINFO pti);

		//GetLastError- retrieves the last system error.
		[DllImport("coredll.dll", SetLastError = true)]
		internal static extern Int32 GetLastError();

		[StructLayout(LayoutKind.Sequential)]
		internal struct TITLEBARINFO {
			public const int CCHILDREN_TITLEBAR = 5;
			public uint cbSize;
			//Specifies the size, in bytes, of the structure.
			//The caller must set this to sizeof(TITLEBARINFO).

			public RECT rcTitleBar;
			//Pointer to a RECT structure that receives the
			//coordinates of the title bar. These coordinates include all title-bar elements
			//except the window menu.

			[MarshalAs(UnmanagedType.ByValArray, SizeConst = 6)]

			//Add reference for System.Windows.Forms
            public AccessibleStates[] rgstate;
			//0	The title bar itself.
			//1	Reserved.
			//2	Minimize button.
			//3	Maximize button.
			//4	Help button.
			//5	Close button.
		}

		[StructLayout(LayoutKind.Sequential)]
		internal struct RECT {
			internal int left;
			internal int top;
			internal int right;
			internal int bottom;
		}
		///The SetWindowLongPtr function changes an attribute of the specified window

		[DllImport("user32.dll", EntryPoint = "SetWindowLong")]
		internal static extern int SetWindowLong32(HandleRef hWnd, int nIndex, int dwNewLong);

		[DllImport("user32.dll", EntryPoint = "SetWindowLong")]
		internal static extern int SetWindowLong32(IntPtr windowHandle, Win32HooksDemo.Helpers.GWLParameter nIndex, int dwNewLong);

		[DllImport("user32.dll", EntryPoint = "SetWindowLongPtr")]
		internal static extern IntPtr SetWindowLongPtr64(IntPtr windowHandle, Win32HooksDemo.Helpers.GWLParameter nIndex, IntPtr dwNewLong);

		[DllImport("user32.dll", EntryPoint = "SetWindowLongPtr")]
		internal static extern IntPtr SetWindowLongPtr64(HandleRef hWnd, int nIndex, IntPtr dwNewLong);


		[DllImport("user32.dll")]
		internal static extern IntPtr SetWinEventHook(
			AccessibleEvents eventMin, //Specifies the event constant for the lowest event value in the range of events that are handled by the hook function. This parameter can be set to EVENT_MIN to indicate the lowest possible event value.
			AccessibleEvents eventMax, //Specifies the event constant for the highest event value in the range of events that are handled by the hook function. This parameter can be set to EVENT_MAX to indicate the highest possible event value.
			IntPtr eventHookAssemblyHandle, //Handle to the DLL that contains the hook function at lpfnWinEventProc, if the WINEVENT_INCONTEXT flag is specified in the dwFlags parameter. If the hook function is not located in a DLL, or if the WINEVENT_OUTOFCONTEXT flag is specified, this parameter is NULL.
			WinEventProc eventHookHandle, //Pointer to the event hook function. For more information about this function
			uint processId, //Specifies the ID of the process from which the hook function receives events. Specify zero (0) to receive events from all processes on the current desktop.
			uint threadId,//Specifies the ID of the thread from which the hook function receives events. If this parameter is zero, the hook function is associated with all existing threads on the current desktop.
			SetWinEventHookParameter parameterFlags //Flag values that specify the location of the hook function and of the events to be skipped. The following flags are valid:
		);

		[return: MarshalAs(UnmanagedType.Bool)]
		[DllImport("user32.dll")]
		internal static extern bool UnhookWinEvent(IntPtr eventHookHandle);

		internal delegate void WinEventProc(IntPtr winEventHookHandle, AccessibleEvents accEvent, IntPtr windowHandle, int objectId, int childId, uint eventThreadId, uint eventTimeInMilliseconds);

		[DllImport("user32.dll")]
		internal static extern IntPtr SetFocus(IntPtr hWnd);

		[Flags]
		internal enum SetWinEventHookParameter {
			WINEVENT_INCONTEXT = 4,
			WINEVENT_OUTOFCONTEXT = 0,
			WINEVENT_SKIPOWNPROCESS = 2,
			WINEVENT_SKIPOWNTHREAD = 1

		}
	}
}
