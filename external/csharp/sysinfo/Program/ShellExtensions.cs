//============================================================================
// SYSInfo 2.0
// Copyright © 2010 Stephan Berger
// 
//This file is part of SYSInfo.
//
//SYSInfo is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.
//
//SYSInfo is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.
//
//You should have received a copy of the GNU General Public License
//along with SYSInfo.  If not, see <http://www.gnu.org/licenses/>.
//
//============================================================================
//functions for shell context menu and file icons

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;

namespace SYSInfo
{
    class ShellExtensions
    {        //Shellinterface to SHGetFileInfo for getting fileicons
        [StructLayout(LayoutKind.Sequential)]
        public struct SHFILEINFO
        {
            public IntPtr hIcon;
            public IntPtr iIcon;
            public uint dwAttributes;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 260)]
            public string szDisplayName;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 80)]
            public string szTypeName;
        };
        public class Win32
        {
            public const uint SHGFI_ICON = 0x100;
            public const uint SHGFI_LARGEICON = 0x0;    // 'Large icon
            public const uint SHGFI_SMALLICON = 0x1;    // 'Small icon
            public const uint SHGFI_TYPENAME = 0x000000400;

            [DllImport("shell32.dll")]
            public static extern IntPtr SHGetFileInfo(string pszPath,
                                        uint dwFileAttributes,
                                        ref SHFILEINFO psfi,
                                        uint cbSizeFileInfo,
                                        uint uFlags);
            [DllImport("user32")]
            public static extern int DestroyIcon(IntPtr hIcon);

        }
        [DllImport("shell32.dll")] //, CharSet = CharSet.Auto
        public static extern int SHGetSpecialFolderLocation(IntPtr hWnd, CSIDL nFolder, out IntPtr Pidl);
        [Flags]
        public enum CSIDL
        {
            CSIDL_DESKTOP = 0x0000,    // <desktop>
            CSIDL_INTERNET = 0x0001,    // Internet Explorer (icon on desktop)
            CSIDL_PROGRAMS = 0x0002,    // Start Menu\Programs
            CSIDL_CONTROLS = 0x0003,    // My Computer\Control Panel
            CSIDL_PRINTERS = 0x0004,    // My Computer\Printers
            CSIDL_PERSONAL = 0x0005,    // My Documents
            CSIDL_FAVORITES = 0x0006,    // <user name>\Favorites
            CSIDL_STARTUP = 0x0007,    // Start Menu\Programs\Startup
            CSIDL_RECENT = 0x0008,    // <user name>\Recent
            CSIDL_SENDTO = 0x0009,    // <user name>\SendTo
            CSIDL_BITBUCKET = 0x000a,    // <desktop>\Recycle Bin
            CSIDL_STARTMENU = 0x000b,    // <user name>\Start Menu
            CSIDL_MYDOCUMENTS = 0x000c,    // logical "My Documents" desktop icon
            CSIDL_MYMUSIC = 0x000d,    // "My Music" folder
            CSIDL_MYVIDEO = 0x000e,    // "My Videos" folder
            CSIDL_DESKTOPDIRECTORY = 0x0010,    // <user name>\Desktop
            CSIDL_DRIVES = 0x0011,    // My Computer
            CSIDL_NETWORK = 0x0012,    // Network Neighborhood (My Network Places)
            CSIDL_NETHOOD = 0x0013,    // <user name>\nethood
            CSIDL_FONTS = 0x0014,    // windows\fonts
            CSIDL_TEMPLATES = 0x0015,
            CSIDL_COMMON_STARTMENU = 0x0016,    // All Users\Start Menu
            CSIDL_COMMON_PROGRAMS = 0X0017,    // All Users\Start Menu\Programs
            CSIDL_COMMON_STARTUP = 0x0018,    // All Users\Startup
            CSIDL_COMMON_DESKTOPDIRECTORY = 0x0019,    // All Users\Desktop
            CSIDL_APPDATA = 0x001a,    // <user name>\Application Data
            CSIDL_PRINTHOOD = 0x001b,    // <user name>\PrintHood

            CSIDL_LOCAL_APPDATA = 0x001c,    // <user name>\Local Settings\Applicaiton Data (non roaming)

            CSIDL_ALTSTARTUP = 0x001d,    // non localized startup
            CSIDL_COMMON_ALTSTARTUP = 0x001e,    // non localized common startup
            CSIDL_COMMON_FAVORITES = 0x001f,

            CSIDL_INTERNET_CACHE = 0x0020,
            CSIDL_COOKIES = 0x0021,
            CSIDL_HISTORY = 0x0022,
            CSIDL_COMMON_APPDATA = 0x0023,    // All Users\Application Data
            CSIDL_WINDOWS = 0x0024,    // GetWindowsDirectory()
            CSIDL_SYSTEM = 0x0025,    // GetSystemDirectory()
            CSIDL_PROGRAM_FILES = 0x0026,    // C:\Program Files
            CSIDL_MYPICTURES = 0x0027,    // C:\Program Files\My Pictures

            CSIDL_PROFILE = 0x0028,    // USERPROFILE
            CSIDL_SYSTEMX86 = 0x0029,    // x86 system directory on RISC
            CSIDL_PROGRAM_FILESX86 = 0x002a,    // x86 C:\Program Files on RISC

            CSIDL_PROGRAM_FILES_COMMON = 0x002b,    // C:\Program Files\Common

            CSIDL_PROGRAM_FILES_COMMONX86 = 0x002c,    // x86 Program Files\Common on RISC
            CSIDL_COMMON_TEMPLATES = 0x002d,    // All Users\Templates

            CSIDL_COMMON_DOCUMENTS = 0x002e,    // All Users\Documents
            CSIDL_COMMON_ADMINTOOLS = 0x002f,    // All Users\Start Menu\Programs\Administrative Tools
            CSIDL_ADMINTOOLS = 0x0030,    // <user name>\Start Menu\Programs\Administrative Tools

            CSIDL_CONNECTIONS = 0x0031,    // Network and Dial-up Connections
            CSIDL_COMMON_MUSIC = 0x0035,    // All Users\My Music
            CSIDL_COMMON_PICTURES = 0x0036,    // All Users\My Pictures
            CSIDL_COMMON_VIDEO = 0x0037,    // All Users\My Video

            CSIDL_CDBURN_AREA = 0x003b    // USERPROFILE\Local Settings\Application Data\Microsoft\CD Burning
        }




        [DllImport("shell32.dll")]
        static extern bool ShellExecuteEx(ref SHELLEXECUTEINFO lpExecInfo);
        [StructLayout(LayoutKind.Sequential)]
        public struct SHELLEXECUTEINFO
        {
            public int cbSize;
            public uint fMask;
            public IntPtr hwnd;
            [MarshalAs(UnmanagedType.LPStr)]
            public string lpVerb;
            [MarshalAs(UnmanagedType.LPStr)]
            public string lpFile;
            [MarshalAs(UnmanagedType.LPStr)]
            public string lpParameters;
            [MarshalAs(UnmanagedType.LPStr)]
            public string lpDirectory;
            public int nShow;
            public IntPtr hInstApp;
            public IntPtr lpIDList;
            [MarshalAs(UnmanagedType.LPStr)]
            public string lpClass;
            public IntPtr hkeyClass;
            public uint dwHotKey;
            public IntPtr hIcon;
            public IntPtr hProcess;
        }
        private const int SW_SHOW = 5;
        private const uint SEE_MASK_INVOKEIDLIST = 12;
        public static void ShowFileProperties(string Filename)
        {
            SHELLEXECUTEINFO info = new SHELLEXECUTEINFO();
            info.cbSize = System.Runtime.InteropServices.Marshal.SizeOf(info);
            info.lpVerb = "properties";
            info.lpFile = Filename;
            info.nShow = SW_SHOW;
            info.fMask = SEE_MASK_INVOKEIDLIST;
            ShellExecuteEx(ref info);
        }
    }
}
