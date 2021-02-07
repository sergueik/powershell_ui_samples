using System;
using System.Runtime.InteropServices;
using System.Reflection;
using System.Windows.Forms;

namespace MonthCalendar
{
    class GlobalHook : IDisposable
    {        
        private HookProc m_KeyboardHookProcedure;
        private bool m_bDisposed;
        private int m_iKeyBoardHook = 0;

        public event KeyEventHandler OnKeyDown;
        public event KeyEventHandler OnKeyUp;

        protected virtual void Dispose(bool disposing)
        {
            if (!m_bDisposed)
            {
                if (disposing)
                {
                    //remove an existing keyboarhook here
                    this.RemoveHook();
                }
                // shared cleanup logic
                m_bDisposed = true;
            }
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        public void InstallKeyBoardHook()
        {
            try
            {
                if (m_iKeyBoardHook == 0)
                {
                    m_KeyboardHookProcedure = new HookProc(KeyboardHookProc);
                    m_iKeyBoardHook = GlobalHookHelpers.SetWindowsHookEx(GlobalHookHelpers.WH_KEYBOARD_LL,
                                                                         m_KeyboardHookProcedure,
                                                                         Marshal.GetHINSTANCE(
                                                                         Assembly.GetExecutingAssembly().GetModules()[0]), 0);

                }
            }
            catch (Exception)
            {
            }
        }

        public void RemoveHook()
        {
            try
            {
                if (m_iKeyBoardHook != 0)
                {
                    bool bReturnKeyboard = true;
                    bReturnKeyboard = GlobalHookHelpers.UnhookWindowsHookEx(m_iKeyBoardHook);
                    m_iKeyBoardHook = 0;
                }
            }
            catch (Exception)
            {
            }
        }

        private int KeyboardHookProc(int nCode, Int32 wParam, IntPtr lParam)
        {
            if (nCode >= 0 && OnKeyDown != null && OnKeyUp != null)
            {
                GlobalHookHelpers.KeyboardHookStruct myKeyBoardStruct = (GlobalHookHelpers.KeyboardHookStruct)Marshal.PtrToStructure(lParam, typeof(GlobalHookHelpers.KeyboardHookStruct));
                if (OnKeyDown != null && (wParam == GlobalHookHelpers.WM_KEYDOWN ||
                    wParam == GlobalHookHelpers.WM_SYSKEYDOWN))
                {
                    Keys myKeyData = (Keys)myKeyBoardStruct.vkCode;
                    KeyEventArgs myKeyEventArgs = new KeyEventArgs(myKeyData);
                    this.OnKeyDown(this, myKeyEventArgs);
                }

                if (OnKeyUp != null && (wParam == GlobalHookHelpers.WM_KEYUP || 
                    wParam == GlobalHookHelpers.WM_SYSKEYUP))
                {
                    Keys myKeyData = (Keys)myKeyBoardStruct.vkCode;
                    KeyEventArgs myKeyEventArgs = new KeyEventArgs(myKeyData);
                    this.OnKeyUp(this,myKeyEventArgs);
                }
            }
            return GlobalHookHelpers.CallNextHookEx(m_iKeyBoardHook, nCode, wParam, lParam); 
        }
    }
}
