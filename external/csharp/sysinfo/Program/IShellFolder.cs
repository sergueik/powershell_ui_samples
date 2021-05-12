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
//
//This modified code is adapted from
//http://www.pinvoke.net/default.aspx/Interfaces/IShellFolder.html
//
//============================================================================
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;

namespace SYSInfo
{
    class iShellFolder

    {

        /// <summary>
        ///  managed equivalent of IShellFolder interface
        /// </summary>
        [ComImport]
        [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
        [Guid("000214E6-0000-0000-C000-000000000046")]
        public interface IShellFolder
        {
            [PreserveSig]
            Int32 ParseDisplayName(
                IntPtr hwnd,
                IntPtr pbc,
                [MarshalAs(UnmanagedType.LPWStr)] 
            string pszDisplayName,
                ref uint pchEaten,
                out IntPtr ppidl,
                ref SFGAO pdwAttributes);

            void EnumObjects(
                IntPtr hwnd,
                ESHCONTF grfFlags,
                out IntPtr ppenumIDList);

            Int32 BindToObject(
                IntPtr pidl,
                IntPtr pbc,
                [In] ref Guid riid,
                out IntPtr ppv);

            void BindToStorage(
                IntPtr pidl,
                IntPtr pbc,
                [In] ref Guid riid,
                out IntPtr ppv);

            [PreserveSig]
            Int32 CompareIDs(
            Int32 lParam,
            IntPtr pidl1,
            IntPtr pidl2);

            void CreateViewObject(
                IntPtr hwndOwner,
                [In] ref Guid riid,
                out IntPtr ppv);

            void GetAttributesOf(
                UInt32 cidl,
                [MarshalAs(UnmanagedType.LPArray, SizeParamIndex = 0)]
                IntPtr[] apidl,
                ref SFGAO rgfInOut);
            
            void GetUIObjectOf( 
                IntPtr hwndOwner,
                UInt32 cidl,    // number of IntPtr's in incoming array
                [MarshalAs(UnmanagedType.LPArray, SizeParamIndex=1)]
                IntPtr[] apidl,
                [In] ref Guid riid,
                UInt32 rgfReserved,
                out IntPtr ppv);
            
            void GetDisplayNameOf(
                IntPtr pidl,
                ESHGDN uFlags,
                out STRRET pName);

            void SetNameOf(
                IntPtr hwnd,
                IntPtr pidl,
                String pszName,
                ESHCONTF uFlags,
                out IntPtr ppidlOut);

        }

        // from ShObjIdl.h
        [Flags]
        public enum SFGAO : uint
        {
            BROWSABLE = 0x8000000,
            CANCOPY = 1,
            CANDELETE = 0x20,
            CANLINK = 4,
            CANMONIKER = 0x400000,
            CANMOVE = 2,
            CANRENAME = 0x10,
            CAPABILITYMASK = 0x177,
            COMPRESSED = 0x4000000,
            CONTENTSMASK = 0x80000000,
            DISPLAYATTRMASK = 0xfc000,
            DROPTARGET = 0x100,
            ENCRYPTED = 0x2000,
            FILESYSANCESTOR = 0x10000000,
            FILESYSTEM = 0x40000000,
            FOLDER = 0x20000000,
            GHOSTED = 0x8000,
            HASPROPSHEET = 0x40,
            HASSTORAGE = 0x400000,
            HASSUBFOLDER = 0x80000000,
            HIDDEN = 0x80000,
            ISSLOW = 0x4000,
            LINK = 0x10000,
            NEWCONTENT = 0x200000,
            NONENUMERATED = 0x100000,
            READONLY = 0x40000,
            REMOVABLE = 0x2000000,
            SHARE = 0x20000,
            STORAGE = 8,
            STORAGEANCESTOR = 0x800000,
            STORAGECAPMASK = 0x70c50008,
            STREAM = 0x400000,
            VALIDATE = 0x1000000
        }

        public enum ESHCONTF
        {
        SHCONTF_FOLDERS = 0x0020,
        SHCONTF_NONFOLDERS = 0x0040,
        SHCONTF_INCLUDEHIDDEN = 0x0080,
        SHCONTF_INIT_ON_FIRST_NEXT = 0x0100,
        SHCONTF_NETPRINTERSRCH  = 0x0200,
        SHCONTF_SHAREABLE = 0x0400,
        SHCONTF_STORAGE = 0x0800   
        }
          // from shlobj.h
        public enum ESHGDN 
        {
        SHGDN_NORMAL         = 0x0000,
        SHGDN_INFOLDER       = 0x0001,
        SHGDN_FOREDITING     = 0x1000,
        SHGDN_FORADDRESSBAR    = 0x4000,
        SHGDN_FORPARSING     = 0x8000,
        }

        public  enum ESTRRET : int
        {
        eeRRET_WSTR     = 0x0000,            // Use STRRET.pOleStr
        STRRET_OFFSET   = 0x0001,    // Use STRRET.uOffset to Ansi
        STRRET_CSTR     = 0x0002            // Use STRRET.cStr
        }

        [StructLayout(LayoutKind.Explicit, Size=520)]
        public struct STRRETinternal
        {
        [FieldOffset(0)]
        public IntPtr pOleStr;

        [FieldOffset(0)]
        public IntPtr pStr;  // LPSTR pStr;   NOT USED

        [FieldOffset(0)]
        public uint  uOffset;

        }

        [StructLayout(LayoutKind.Sequential )]
        public struct STRRET
        {
        public uint uType;
        public STRRETinternal data;
        }

        public class Guid_IShellFolder 
        {
        public static Guid IID_IShellFolder =
            new Guid("{000214E6-0000-0000-C000-000000000046}");
        }

        public const int S_OK = 0;
        public const int S_FALSE = 1;
        public const int MAX_PATH = 260;


    }

}
