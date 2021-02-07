using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.ComponentModel;
using System.Collections;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace MonthCalendar
{
    #region GlobalHook helpers
    internal delegate int HookProc(int nCode, Int32 wParam, IntPtr lParam);

    internal class GlobalHookHelpers
    {
        [StructLayout(LayoutKind.Sequential)]
        public class KeyboardHookStruct
        {
            public int vkCode = 0;	//Specifies a virtual-key code. The code must be a value in the range 1 to 254. 
            public int scanCode = 0; // Specifies a hardware scan code for the key. 
            public int flags = 0;  // Specifies the extended-key flag, event-injected flag, context code, and transition-state flag.
            public int time = 0; // Specifies the time stamp for this message.
            public int dwExtraInfo = 0; // Specifies extra information associated with the message. 
        }

        public const int WM_THEMECHANGED = 0x031A;
        public const int WM_KEYDOWN = 0x100;
        public const int WM_KEYUP = 0x101;
        public const int WM_SYSKEYDOWN = 0x104;
        public const int WM_SYSKEYUP = 0x105;
        public const int WH_KEYBOARD_LL = 13;

        // calls needed for globalhook..
        [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
        public static extern int SetWindowsHookEx(int idHook, HookProc lpfn, IntPtr hInstance, int threadId);

        [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool UnhookWindowsHookEx(int idHook);

        [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
        public static extern int CallNextHookEx(int idHook, int nCode, Int32 wParam, IntPtr lParam);

        [DllImport("user32.dll")]
        public static extern int GetKeyboardState(byte[] lpKeyState);

        [DllImport("user32")]
        public static extern int ToAscii(int uVirtKey, int uScanCode, byte[] lpbKeyState, byte[] lpwTransKey, int fuState);
    }

    #endregion
}
