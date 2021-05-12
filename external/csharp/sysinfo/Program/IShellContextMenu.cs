//============================================================================
// SYSInfo 2.0
// Copyright © 2010 Stephan Berger
// 
//This file is part of SYSInfo.
//
//SYSInfo is free software: you can redistribute it and/or modify
//it under the terms of the GNU General private License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.
//
//SYSInfo is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General private License for more details.
//
//You should have received a copy of the GNU General private License
//along with SYSInfo.  If not, see <http://www.gnu.org/licenses/>.
//
//============================================================================
//
//This modified code is adapted from
//http://www.codeproject.com/KB/miscctrl/FileBrowser.aspx#TheShellContextMenu
//
//and
//
//http://www.pinvoke.net/default.aspx/Interfaces.IContextMenu
//
//and
//
//http://afjohansson.spaces.live.com
//
//============================================================================

using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace SYSInfo
{
    class IShellContextMenu : NativeWindow
    {

        IContextMenu _oContextMenu;
        IContextMenu2 _oContextMenu2;
        IContextMenu3 _oContextMenu3;

        private static Guid IID_IContextMenu = new Guid("{000214e4-0000-0000-c000-000000000046}");
        private static Guid IID_IContextMenu2 = new Guid("{000214f4-0000-0000-c000-000000000046}");
        private static Guid IID_IContextMenu3 = new Guid("{bcfce0a0-ec17-11d0-8d10-00a0c90f2719}");
        private const uint CMD_FIRST = 1;
        private const uint CMD_LAST = 30000;
        private const int S_FALSE = 1;
        private const int S_OK = 0;


        /// <summary>Default constructor</summary>
        public IShellContextMenu()
        {
            this.CreateHandle(new CreateParams());
        }


        [ComImport]
        [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
        [Guid("000214e4-0000-0000-c000-000000000046")]
        private interface IContextMenu
        {
            [PreserveSig()]
            int QueryContextMenu(
                    IntPtr hmenu,
                    uint iMenu,
                    uint idCmdFirst,
                    uint idCmdLast,
                    CMF uFlags);

            [PreserveSig]
            int InvokeCommand(
                    ref CMINVOKECOMMANDINFOEX info);

            [PreserveSig()]
            void GetCommandString(
                int idcmd,
                uint uflags,
                int reserved,
                [MarshalAs(UnmanagedType.LPWStr)]
                StringBuilder commandstring,
                int cch);
        }

        [ComImport]
        [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
        [Guid("000214f4-0000-0000-c000-000000000046")]
        interface IContextMenu2
        {
            [PreserveSig]
            int QueryContextMenu(
                IntPtr hMenu, 
                uint indexMenu, 
                uint idCmdFirst, 
                uint idCmdLast, 
                CMF uFlags);

            [PreserveSig]
            void InvokeCommand(ref CMINVOKECOMMANDINFOEX info);

            [PreserveSig]
            void GetCommandString(
                int idcmd, 
                uint uflags, 
                int reserved, 
                [MarshalAs(UnmanagedType.LPWStr)] 
                StringBuilder commandstring, 
                int cch);

            [PreserveSig]
            int HandleMenuMsg(
                uint uMsg, 
                IntPtr wParam, 
                IntPtr lParam);
        }



        [ComImport] 
        [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
        [Guid("bcfce0a0-ec17-11d0-8d10-00a0c90f2719")]
        private interface IContextMenu3
        {
            #region Methods

            // Retrieves information about a shortcut menu command,
            // including the help string and the language-independent,
            // or canonical, name for the command
            [PreserveSig]
            int GetCommandString(
                    uint idcmd,
                    GCS uflags,
                    uint reserved,
                    [MarshalAs(UnmanagedType.LPWStr)]
                    StringBuilder commandstring,
                    int cch);

            // Allows client objects of the IContextMenu interface to
            // handle messages associated with owner-drawn menu items
            [PreserveSig]
            int HandleMenuMsg(
                    uint uMsg,
                    IntPtr wParam,
                    IntPtr lParam);

            // Allows client objects of the IContextMenu3 interface to
            // handle messages associated with owner-drawn menu items
            [PreserveSig]
            int HandleMenuMsg2(
                    uint uMsg,
                    IntPtr wParam,
                    IntPtr lParam,
                    IntPtr plResult);

            // Carries out the command associated with a shortcut menu item
            [PreserveSig]
            int InvokeCommand(
                    ref CMINVOKECOMMANDINFOEX info);

            //// Adds commands to a shortcut menu
            [PreserveSig]
            int QueryContextMenu(
                    IntPtr hmenu,
                    uint iMenu,
                    uint idCmdFirst,
                    uint idCmdLast,
                    CMF uFlags);

            #endregion Methods
        }


        /// <summary>
        /// This method receives WindowMessages. It will make the "Open With" and "Send To" work
        /// by calling HandleMenuMsg and HandleMenuMsg2. It will also call the OnContextMenuMouseHover
        /// method of Browser when hovering over a ContextMenu item.
        /// </summary>
        /// <param name="m">the Message of the Browser's WndProc</param>
        /// <returns>true if the message has been handled, false otherwise</returns>
     //   [System.Security.Permissions.PermissionSet(System.Security.Permissions.SecurityAction.Demand, Name = "FullTrust")]
        protected override void WndProc(ref Message m)
        {
            #region IContextMenu
            if (_oContextMenu != null &&
                m.Msg == (int)WM.MENUSELECT &&
                ((int)ShellHelper.HiWord(m.WParam) & (int)MFT.SEPARATOR) == 0 &&
                ((int)ShellHelper.HiWord(m.WParam) & (int)MFT.POPUP) == 0)
            {
                string info = string.Empty;

                if (ShellHelper.LoWord(m.WParam) == (int)CMD_CUSTOM.ExpandCollapse)
                    info = "Expands or collapses the current selected item";
                else
                {
                    info = "BLUBB!";
                }
            }

            #endregion

            #region IContextMenu2
            if (_oContextMenu2 != null &&
                (m.Msg == (int)WM.INITMENUPOPUP ||
                 m.Msg == (int)WM.MEASUREITEM ||
                 m.Msg == (int)WM.DRAWITEM))
            {
                if (_oContextMenu2.HandleMenuMsg(
                    (uint)m.Msg, m.WParam, m.LParam) == S_OK)
                    return;
            }

            #endregion

            #region IContextMenu3
            if (_oContextMenu3 != null &&
                m.Msg == (int)WM.MENUCHAR)
            {
                if (_oContextMenu3.HandleMenuMsg2(
                    (uint)m.Msg, m.WParam, m.LParam, IntPtr.Zero) == S_OK)
                    return;
            }

            #endregion

            base.WndProc(ref m);
        }
        internal static class ShellHelper
        {
            #region Methods

            /// <summary>
            /// Retrieves the High Word of a WParam of a WindowMessage
            /// </summary>
            /// <param name="ptr">The pointer to the WParam</param>
            /// <returns>The unsigned integer for the High Word</returns>
            public static uint HiWord(IntPtr ptr)
            {
                if (((uint)ptr & 0x80000000) == 0x80000000)
                    return ((uint)ptr >> 16);
                else
                    return ((uint)ptr >> 16) & 0xffff;
            }

            /// <summary>
            /// Retrieves the Low Word of a WParam of a WindowMessage
            /// </summary>
            /// <param name="ptr">The pointer to the WParam</param>
            /// <returns>The unsigned integer for the Low Word</returns>
            public static uint LoWord(IntPtr ptr)
            {
                return (uint)ptr & 0xffff;
            }

            #endregion Methods
        }
        // The cmd for a custom added menu item
        private enum CMD_CUSTOM
        {
            ExpandCollapse = (int)CMD_LAST + 1
        }


        [DllImport("shell32.dll")]
        private static extern Int32 SHGetDesktopFolder(out IntPtr ppshf);
        // The CreatePopupMenu function creates a drop-down menu, submenu, or shortcut menu. The menu is initially empty. You can insert or append menu items by using the InsertMenuItem function. You can also use the InsertMenu function to insert menu items and the AppendMenu function to append menu items.
        [DllImport("user32", SetLastError = true, CharSet = CharSet.Auto)]
        private static extern IntPtr CreatePopupMenu();
        // The DestroyMenu function destroys the specified menu and frees any memory that the menu occupies.
        [DllImport("user32", SetLastError = true, CharSet = CharSet.Auto)]
        private static extern bool DestroyMenu(IntPtr hMenu);
        //// Determines the default menu item on the specified menu
        //[DllImport("user32", SetLastError = true, CharSet = CharSet.Auto)]
        //private static extern int GetMenuDefaultItem(IntPtr hMenu, bool fByPos, uint gmdiFlags);
        // The TrackPopupMenuEx function displays a shortcut menu at the specified location and tracks the selection of items on the shortcut menu. The shortcut menu can appear anywhere on the screen.
        [DllImport("user32.dll", ExactSpelling = true, CharSet = CharSet.Auto)]
        private static extern uint TrackPopupMenuEx(IntPtr hmenu, TPM flags, int x, int y, IntPtr hwnd, IntPtr lptpm);
 
        // Window message flags
        [Flags]
        private enum WM : uint
        {
            ACTIVATE = 0x6,
            ACTIVATEAPP = 0x1C,
            AFXFIRST = 0x360,
            AFXLAST = 0x37F,
            APP = 0x8000,
            ASKCBFORMATNAME = 0x30C,
            CANCELJOURNAL = 0x4B,
            CANCELMODE = 0x1F,
            CAPTURECHANGED = 0x215,
            CHANGECBCHAIN = 0x30D,
            CHAR = 0x102,
            CHARTOITEM = 0x2F,
            CHILDACTIVATE = 0x22,
            CLEAR = 0x303,
            CLOSE = 0x10,
            COMMAND = 0x111,
            COMPACTING = 0x41,
            COMPAREITEM = 0x39,
            CONTEXTMENU = 0x7B,
            COPY = 0x301,
            COPYDATA = 0x4A,
            CREATE = 0x1,
            CTLCOLORBTN = 0x135,
            CTLCOLORDLG = 0x136,
            CTLCOLOREDIT = 0x133,
            CTLCOLORLISTBOX = 0x134,
            CTLCOLORMSGBOX = 0x132,
            CTLCOLORSCROLLBAR = 0x137,
            CTLCOLORSTATIC = 0x138,
            CUT = 0x300,
            DEADCHAR = 0x103,
            DELETEITEM = 0x2D,
            DESTROY = 0x2,
            DESTROYCLIPBOARD = 0x307,
            DEVICECHANGE = 0x219,
            DEVMODECHANGE = 0x1B,
            DISPLAYCHANGE = 0x7E,
            DRAWCLIPBOARD = 0x308,
            DRAWITEM = 0x2B,
            DROPFILES = 0x233,
            ENABLE = 0xA,
            ENDSESSION = 0x16,
            ENTERIDLE = 0x121,
            ENTERMENULOOP = 0x211,
            ENTERSIZEMOVE = 0x231,
            ERASEBKGND = 0x14,
            EXITMENULOOP = 0x212,
            EXITSIZEMOVE = 0x232,
            FONTCHANGE = 0x1D,
            GETDLGCODE = 0x87,
            GETFONT = 0x31,
            GETHOTKEY = 0x33,
            GETICON = 0x7F,
            GETMINMAXINFO = 0x24,
            GETOBJECT = 0x3D,
            GETSYSMENU = 0x313,
            GETTEXT = 0xD,
            GETTEXTLENGTH = 0xE,
            HANDHELDFIRST = 0x358,
            HANDHELDLAST = 0x35F,
            HELP = 0x53,
            HOTKEY = 0x312,
            HSCROLL = 0x114,
            HSCROLLCLIPBOARD = 0x30E,
            ICONERASEBKGND = 0x27,
            IME_CHAR = 0x286,
            IME_COMPOSITION = 0x10F,
            IME_COMPOSITIONFULL = 0x284,
            IME_CONTROL = 0x283,
            IME_ENDCOMPOSITION = 0x10E,
            IME_KEYDOWN = 0x290,
            IME_KEYLAST = 0x10F,
            IME_KEYUP = 0x291,
            IME_NOTIFY = 0x282,
            IME_REQUEST = 0x288,
            IME_SELECT = 0x285,
            IME_SETCONTEXT = 0x281,
            IME_STARTCOMPOSITION = 0x10D,
            INITDIALOG = 0x110,
            INITMENU = 0x116,
            INITMENUPOPUP = 0x117,
            INPUTLANGCHANGE = 0x51,
            INPUTLANGCHANGEREQUEST = 0x50,
            KEYDOWN = 0x100,
            KEYFIRST = 0x100,
            KEYLAST = 0x108,
            KEYUP = 0x101,
            KILLFOCUS = 0x8,
            LBUTTONDBLCLK = 0x203,
            LBUTTONDOWN = 0x201,
            LBUTTONUP = 0x202,
            LVM_GETEDITCONTROL = 0x1018,
            LVM_SETIMAGELIST = 0x1003,
            MBUTTONDBLCLK = 0x209,
            MBUTTONDOWN = 0x207,
            MBUTTONUP = 0x208,
            MDIACTIVATE = 0x222,
            MDICASCADE = 0x227,
            MDICREATE = 0x220,
            MDIDESTROY = 0x221,
            MDIGETACTIVE = 0x229,
            MDIICONARRANGE = 0x228,
            MDIMAXIMIZE = 0x225,
            MDINEXT = 0x224,
            MDIREFRESHMENU = 0x234,
            MDIRESTORE = 0x223,
            MDISETMENU = 0x230,
            MDITILE = 0x226,
            MEASUREITEM = 0x2C,
            MENUCHAR = 0x120,
            MENUCOMMAND = 0x126,
            MENUDRAG = 0x123,
            MENUGETOBJECT = 0x124,
            MENURBUTTONUP = 0x122,
            MENUSELECT = 0x11F,
            MOUSEACTIVATE = 0x21,
            MOUSEFIRST = 0x200,
            MOUSEHOVER = 0x2A1,
            MOUSELAST = 0x20A,
            MOUSELEAVE = 0x2A3,
            MOUSEMOVE = 0x200,
            MOUSEWHEEL = 0x20A,
            MOVE = 0x3,
            MOVING = 0x216,
            NCACTIVATE = 0x86,
            NCCALCSIZE = 0x83,
            NCCREATE = 0x81,
            NCDESTROY = 0x82,
            NCHITTEST = 0x84,
            NCLBUTTONDBLCLK = 0xA3,
            NCLBUTTONDOWN = 0xA1,
            NCLBUTTONUP = 0xA2,
            NCMBUTTONDBLCLK = 0xA9,
            NCMBUTTONDOWN = 0xA7,
            NCMBUTTONUP = 0xA8,
            NCMOUSEHOVER = 0x2A0,
            NCMOUSELEAVE = 0x2A2,
            NCMOUSEMOVE = 0xA0,
            NCPAINT = 0x85,
            NCRBUTTONDBLCLK = 0xA6,
            NCRBUTTONDOWN = 0xA4,
            NCRBUTTONUP = 0xA5,
            NEXTDLGCTL = 0x28,
            NEXTMENU = 0x213,
            NOTIFY = 0x4E,
            NOTIFYFORMAT = 0x55,
            NULL = 0x0,
            PAINT = 0xF,
            PAINTCLIPBOARD = 0x309,
            PAINTICON = 0x26,
            PALETTECHANGED = 0x311,
            PALETTEISCHANGING = 0x310,
            PARENTNOTIFY = 0x210,
            PASTE = 0x302,
            PENWINFIRST = 0x380,
            PENWINLAST = 0x38F,
            POWER = 0x48,
            PRINT = 0x317,
            PRINTCLIENT = 0x318,
            QUERYDRAGICON = 0x37,
            QUERYENDSESSION = 0x11,
            QUERYNEWPALETTE = 0x30F,
            QUERYOPEN = 0x13,
            QUEUESYNC = 0x23,
            QUIT = 0x12,
            RBUTTONDBLCLK = 0x206,
            RBUTTONDOWN = 0x204,
            RBUTTONUP = 0x205,
            RENDERALLFORMATS = 0x306,
            RENDERFORMAT = 0x305,
            SETCURSOR = 0x20,
            SETFOCUS = 0x7,
            SETFONT = 0x30,
            SETHOTKEY = 0x32,
            SETICON = 0x80,
            SETMARGINS = 0xD3,
            SETREDRAW = 0xB,
            SETTEXT = 0xC,
            SETTINGCHANGE = 0x1A,
            SHOWWINDOW = 0x18,
            SIZE = 0x5,
            SIZECLIPBOARD = 0x30B,
            SIZING = 0x214,
            SPOOLERSTATUS = 0x2A,
            STYLECHANGED = 0x7D,
            STYLECHANGING = 0x7C,
            SYNCPAINT = 0x88,
            SYSCHAR = 0x106,
            SYSCOLORCHANGE = 0x15,
            SYSCOMMAND = 0x112,
            SYSDEADCHAR = 0x107,
            SYSKEYDOWN = 0x104,
            SYSKEYUP = 0x105,
            TCARD = 0x52,
            TIMECHANGE = 0x1E,
            TIMER = 0x113,
            TVM_GETEDITCONTROL = 0x110F,
            TVM_SETIMAGELIST = 0x1109,
            UNDO = 0x304,
            UNINITMENUPOPUP = 0x125,
            USER = 0x400,
            USERCHANGED = 0x54,
            VKEYTOITEM = 0x2E,
            VSCROLL = 0x115,
            VSCROLLCLIPBOARD = 0x30A,
            WINDOWPOSCHANGED = 0x47,
            WINDOWPOSCHANGING = 0x46,
            WININICHANGE = 0x1A,
            SH_NOTIFY = 0x0401
        }
        // Specifies how TrackPopupMenuEx positions the shortcut menu horizontally
        [Flags]
        private enum TPM : uint
        {
            LEFTBUTTON = 0x0000,
            RIGHTBUTTON = 0x0002,
            LEFTALIGN = 0x0000,
            CENTERALIGN = 0x0004,
            RIGHTALIGN = 0x0008,
            TOPALIGN = 0x0000,
            VCENTERALIGN = 0x0010,
            BOTTOMALIGN = 0x0020,
            HORIZONTAL = 0x0000,
            VERTICAL = 0x0040,
            NONOTIFY = 0x0080,
            RETURNCMD = 0x0100,
            RECURSE = 0x0001,
            HORPOSANIMATION = 0x0400,
            HORNEGANIMATION = 0x0800,
            VERPOSANIMATION = 0x1000,
            VERNEGANIMATION = 0x2000,
            NOANIMATION = 0x4000,
            LAYOUTRTL = 0x8000
        }
        // Specifies how the shortcut menu can be changed when calling IContextMenu::QueryContextMenu
        [Flags]
        private enum CMF : uint
        {
            NORMAL = 0x00000000,
            DEFAULTONLY = 0x00000001,
            VERBSONLY = 0x00000002,
            EXPLORE = 0x00000004,
            NOVERBS = 0x00000008,
            CANRENAME = 0x00000010,
            NODEFAULT = 0x00000020,
            INCLUDESTATIC = 0x00000040,
            EXTENDEDVERBS = 0x00000100,
            RESERVED = 0xffff0000
        }
        // Specifies the content of the new menu item
        [Flags]
        private enum MFT : uint
        {
            GRAYED = 0x00000003,
            DISABLED = 0x00000003,
            CHECKED = 0x00000008,
            SEPARATOR = 0x00000800,
            RADIOCHECK = 0x00000200,
            BITMAP = 0x00000004,
            OWNERDRAW = 0x00000100,
            MENUBARBREAK = 0x00000020,
            MENUBREAK = 0x00000040,
            RIGHTORDER = 0x00002000,
            BYCOMMAND = 0x00000000,
            BYPOSITION = 0x00000400,
            POPUP = 0x00000010
        }
        // Flags specifying the information to return when calling IContextMenu::GetCommandString
        [Flags]
        private enum GCS : uint
        {
            VERBA = 0,
            HELPTEXTA = 1,
            VALIDATEA = 2,
            VERBW = 4,
            HELPTEXTW = 5,
            VALIDATEW = 6
        }
        // Flags used with the CMINVOKECOMMANDINFOEX structure
        [Flags]
        private enum CMIC : uint
        {
            HOTKEY = 0x00000020,
            ICON = 0x00000010,
            FLAG_NO_UI = 0x00000400,
            UNICODE = 0x00004000,
            NO_CONSOLE = 0x00008000,
            ASYNCOK = 0x00100000,
            NOZONECHECKS = 0x00800000,
            SHIFT_DOWN = 0x10000000,
            CONTROL_DOWN = 0x40000000,
            FLAG_LOG_USAGE = 0x04000000,
            PTINVOKE = 0x20000000
        }
        // Specifies how the window is to be shown
        [Flags]
        private enum SW
        {
            HIDE = 0,
            SHOWNORMAL = 1,
            NORMAL = 1,
            SHOWMINIMIZED = 2,
            SHOWMAXIMIZED = 3,
            MAXIMIZE = 3,
            SHOWNOACTIVATE = 4,
            SHOW = 5,
            MINIMIZE = 6,
            SHOWMINNOACTIVE = 7,
            SHOWNA = 8,
            RESTORE = 9,
            SHOWDEFAULT = 10,
        }

        private static void InvokeCommand(IContextMenu oContextMenu, uint nCmd, string strFolder, System.Drawing.Point pointInvoke, IntPtr hwnd)
        {
            CMINVOKECOMMANDINFOEX invoke = new CMINVOKECOMMANDINFOEX();
            invoke.cbSize = cbInvokeCommand;
            invoke.hwnd = hwnd;
            invoke.lpVerb = (IntPtr)(nCmd - CMD_FIRST);
            invoke.lpDirectory = strFolder;
            invoke.lpVerbW = (IntPtr)(nCmd - CMD_FIRST);
            invoke.lpDirectoryW = strFolder;
            invoke.fMask = CMIC.UNICODE| CMIC.PTINVOKE |
                           ((Control.ModifierKeys & Keys.Control) != 0 ? CMIC.CONTROL_DOWN : 0) |
                           ((Control.ModifierKeys & Keys.Shift) != 0 ? CMIC.SHIFT_DOWN : 0);
            invoke.ptInvoke = new POINT(pointInvoke.X, pointInvoke.Y);
            invoke.nShow = SW.SHOWNORMAL;

            int result = oContextMenu.InvokeCommand(ref invoke);
        }
        private static int cbInvokeCommand = Marshal.SizeOf(typeof(CMINVOKECOMMANDINFOEX));

        // Contains extended information about a shortcut menu command
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        private struct CMINVOKECOMMANDINFOEX
        {
            public int cbSize;
            public CMIC fMask;
            public IntPtr hwnd;
            public IntPtr lpVerb;
            [MarshalAs(UnmanagedType.LPStr)]
            public string lpParameters;
            [MarshalAs(UnmanagedType.LPStr)]
            public string lpDirectory;
            public SW nShow;
            public int dwHotKey;
            public IntPtr hIcon;
            [MarshalAs(UnmanagedType.LPStr)]
            public string lpTitle;
            public IntPtr lpVerbW;
            [MarshalAs(UnmanagedType.LPWStr)]
            public string lpParametersW;
            [MarshalAs(UnmanagedType.LPWStr)]
            public string lpDirectoryW;
            [MarshalAs(UnmanagedType.LPWStr)]
            public string lpTitleW;
            public POINT ptInvoke;
        }

        // Defines the x- and y-coordinates of a point
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
        private struct POINT
        {
            private int x;
            private int y;

            #region Constructors

            public POINT(int x, int y)
            {
                this.x = x;
                this.y = y;
            }

            #endregion Constructors
        }


   //     public void iContextMenu(string sParent, string sSelected, System.Drawing.Point location, object f1, bool bSpecialFolderFlag)
        public void iContextMenu(string sParent, string sSelected, bool bSpecialFolderFlag)
        {
            IntPtr shellFolderPtr;
            SHGetDesktopFolder(out shellFolderPtr);
            iShellFolder.IShellFolder shellFolder =
                (iShellFolder.IShellFolder)Marshal.GetTypedObjectForIUnknown(shellFolderPtr, typeof(iShellFolder.IShellFolder));

            uint pchEaten = 0;
            int nResult = 0;
            IntPtr pPIDL = IntPtr.Zero;
            iShellFolder.SFGAO pdwAttributes = iShellFolder.SFGAO.FILESYSTEM;

            if (bSpecialFolderFlag) //for root drives - get "My Computer"
            {
                nResult = ShellExtensions.SHGetSpecialFolderLocation(this.Handle,
                    ShellExtensions.CSIDL.CSIDL_DRIVES,
                    out pPIDL);
            }
            else
            {
                nResult = shellFolder.ParseDisplayName(this.Handle,
                    IntPtr.Zero,
                    sParent,
                    ref pchEaten,
                    out pPIDL,
                    ref pdwAttributes);
            }
            if(nResult == 0)
            {
                // Get the IShellFolder for folder
                IntPtr pUnknownParentFolder = IntPtr.Zero;

                if (shellFolder.BindToObject(pPIDL,
                    IntPtr.Zero,
                    ref iShellFolder.Guid_IShellFolder.IID_IShellFolder,
                    out pUnknownParentFolder) == S_OK)
                {
                    // Free the PIDL first
                    Marshal.FreeCoTaskMem(pPIDL);
                    pPIDL = IntPtr.Zero;
                    IntPtr[] aPidl = new IntPtr[1];
                    shellFolder = (iShellFolder.IShellFolder)Marshal.GetTypedObjectForIUnknown(pUnknownParentFolder,
                        typeof(iShellFolder.IShellFolder));

                    nResult = shellFolder.ParseDisplayName(this.Handle,
                        IntPtr.Zero,
                        sSelected,
                        ref pchEaten,
                        out pPIDL,
                        ref pdwAttributes);

                    aPidl[0] = pPIDL;

                    IntPtr iContextMenuPtr = IntPtr.Zero,
                       iContextMenuPtr2 = IntPtr.Zero,
                       iContextMenuPtr3 = IntPtr.Zero;;

                    shellFolder.GetUIObjectOf(this.Handle,
                        1,
                        aPidl,
                        ref IID_IContextMenu,
                        0,
                        out iContextMenuPtr);

                    //*********************

                    _oContextMenu = (IContextMenu)Marshal.GetTypedObjectForIUnknown(iContextMenuPtr, typeof(IContextMenu));

                    IntPtr pUnknownContextMenu2 = IntPtr.Zero;
                    if (S_OK == Marshal.QueryInterface(iContextMenuPtr, ref IID_IContextMenu2, out pUnknownContextMenu2))
                    {
                        _oContextMenu2 = (IContextMenu2)Marshal.GetTypedObjectForIUnknown(pUnknownContextMenu2, typeof(IContextMenu2));
                    }
                    IntPtr pUnknownContextMenu3 = IntPtr.Zero;
                    if (S_OK == Marshal.QueryInterface(iContextMenuPtr, ref IID_IContextMenu3, out pUnknownContextMenu3))
                    {
                        _oContextMenu3 = (IContextMenu3)Marshal.GetTypedObjectForIUnknown(pUnknownContextMenu3, typeof(IContextMenu3));
                    }


                    IntPtr pMenu = IntPtr.Zero;
                    pMenu = CreatePopupMenu();


                    nResult = _oContextMenu.QueryContextMenu(
                        pMenu,
                        0,
                        CMD_FIRST,
                        CMD_LAST,
                        CMF.EXPLORE |
                        CMF.NORMAL |
                        ((Control.ModifierKeys & System.Windows.Forms.Keys.Shift) != 0 ? CMF.EXTENDEDVERBS : 0));

                     Marshal.QueryInterface(iContextMenuPtr, ref IID_IContextMenu2, out iContextMenuPtr2);
                    Marshal.QueryInterface(iContextMenuPtr, ref IID_IContextMenu3, out iContextMenuPtr3);

                    _oContextMenu2 = (IContextMenu2)Marshal.GetTypedObjectForIUnknown(iContextMenuPtr2, typeof(IContextMenu2));
                    _oContextMenu3 = (IContextMenu3)Marshal.GetTypedObjectForIUnknown(iContextMenuPtr3, typeof(IContextMenu3));

                   uint nSelected = TrackPopupMenuEx(
                    pMenu,
                    TPM.RETURNCMD,
                    Control.MousePosition.X,
                    Control.MousePosition.Y,
                    this.Handle,            
                    IntPtr.Zero);


                    if (nSelected != 0)
                    {
                        InvokeCommand(_oContextMenu, nSelected, sParent, Control.MousePosition, this.Handle);
                    }

                    DestroyMenu(pMenu);
                    pMenu = IntPtr.Zero;

                    if (iContextMenuPtr != IntPtr.Zero)
                        Marshal.Release(iContextMenuPtr);

                    if (iContextMenuPtr2 != IntPtr.Zero)
                        Marshal.Release(iContextMenuPtr2);

                    if (iContextMenuPtr3 != IntPtr.Zero)
                        Marshal.Release(iContextMenuPtr3);

                    release();
                }
            }
        }
        private void release()
        {
            if (null != _oContextMenu)
            {
                Marshal.ReleaseComObject(_oContextMenu);
                _oContextMenu = null;
            }
            if (null != _oContextMenu2)
            {
                Marshal.ReleaseComObject(_oContextMenu2);
                _oContextMenu2 = null;
            }
            if (null != _oContextMenu3)
            {
                Marshal.ReleaseComObject(_oContextMenu3);
                _oContextMenu3 = null;
            }
        }

    }
}
