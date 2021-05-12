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

/// <summary>
///Simple filebrowser class
///parses all files and folders in the given path
///populates a context menu with results
///
/// uses unmanaged code of SHFILEINFO interface for retrieving file icons
/// right click opens shell context menu
/// 
/// double click opens selected file/folder
///</summary>

using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Linq;
using ICSharpCode.SharpZipLib.Zip;
using ICSharpCode.SharpZipLib.Tar;

namespace SYSInfo
{
    public class ToolStripDropDownItemEx : ToolStripDropDownItem
    {
        string _Path;

        public ToolStripDropDownItemEx():base()
        {
        }

        public string Path
        {
            get
            {
                return _Path;
            }
            set
            {
                _Path = value;
            }
        }
    }
    public class ToolStripMenuItemEx : ToolStripMenuItem
    {
        string _Path, _fileInfo;
        long _zipEntry;
        bool _compressed;

        public ToolStripMenuItemEx():base()
        {
        }
        public ToolStripMenuItemEx(string Name, Image i):base(Name,i)
        {
        }

        public string Path
        {
            get
            {
                return _Path;
            }
            set
            {
                _Path = value;
            }
        }
        public long zipEntry
        {
            get
            {
                return _zipEntry;
            }
            set
            {
                _zipEntry = value;
            }
        }
        public bool compressed
        {
            get
            {
                return _compressed;
            }
            set
            {
                _compressed = value;
            }
        }
    }

    class FileBrowser
    {
        Form f1;
        ImageList imageList;
        string rootDir;
        int xPos,yPos;
 //       List<string> lExt = new List<string>(new string[] { ".zip", "r.gz", ".tar", ".bz2", ".gz" });
        List<string> lExt = new List<string>(new string[] { ".zip"});

        public FileBrowser(Form1 f1, int xPos, int yPos)
        {
            this.f1 = f1;   //reference to form for positioning
            imageList = f1.imageList1;  //folder icon
            this.xPos = xPos;   //position of hdd-bar
            this.yPos = yPos;
        }

        //Create and populate the contextmenu with files/folders of selected directory
        public void populateList(string sPath)
        {

            ContextMenuStrip cMenue = new ContextMenuStrip();
            DirectoryInfo nodeDirInfo = new DirectoryInfo(sPath);
            if (nodeDirInfo.Exists)
            {
                rootDir = sPath;
                int i = 0;
                FileInfo[] fileInf = nodeDirInfo.GetFiles();
                DirectoryInfo[] dirInf = nodeDirInfo.GetDirectories();
                ToolStripMenuItemEx[] tsMenDir = new ToolStripMenuItemEx[dirInf.Length];
                ToolStripMenuItemEx[] tsMenFile = new ToolStripMenuItemEx[fileInf.Length];

                foreach (DirectoryInfo dir in dirInf)
                {
                    tsMenDir[i] = new ToolStripMenuItemEx(dir.Name,imageList.Images[0]);
                    tsMenDir[i].Path = dir.FullName;
                    if (System.Threading.Thread.CurrentThread.CurrentUICulture.ToString() == "de-DE")
                        tsMenDir[i].ToolTipText = de[3]; //"Erstellt: "
                    else
                        tsMenDir[i].ToolTipText = en[3]; //"created: "  - means the local time when the file was first seen in this system ;) not necessarly the real creation time...
                    tsMenDir[i].ToolTipText += dir.CreationTime.ToString();
                    tsMenDir[i].compressed = false;
                    tsMenDir[i].DropDownItems.Add("...");
                    tsMenDir[i].DropDownOpening += new EventHandler(iItem_DropDownOpening);
                    Console.Write(tsMenDir[i].Name + "\n");
                    i++;
                }
                
                cMenue.Items.AddRange(tsMenDir);
                cMenue.DoubleClick += new EventHandler(DropDown_DoubleClick);
                cMenue.MouseClick += new MouseEventHandler(DropDown_MouseClick);

                // Integration of SharpZipLib for compressed folders
                var query = (from fileExt in fileInf
                         where lExt.Contains(fileExt.Extension)
                         select fileExt)
                         .ToList();

                i = 0;
                if (query.Count > 0)
                {
                    tsMenDir = new ToolStripMenuItemEx[query.Count];
                    foreach (FileInfo fi in query)
                    {
                        tsMenDir[i] = new ToolStripMenuItemEx(fi.Name, imageList.Images[2]);
                        tsMenDir[i].Path = fi.FullName;
                        tsMenDir[i].compressed = true;
                        tsMenDir[i].DropDownItems.Add("...");
                        tsMenDir[i].DropDown.Closing += new ToolStripDropDownClosingEventHandler(DropDown_Closing);
                        tsMenDir[i].DropDownOpening += new EventHandler(ziItem_DropDownOpening);
                        i++;
                    }
                    cMenue.Items.AddRange(tsMenDir);

                }
                // *************************************************************

                i = 0;
                foreach (FileInfo file in fileInf)
                {
                    tsMenFile[i] = fileInfo(file, tsMenFile.Length);
                    i++;
                }
                cMenue.Items.AddRange(tsMenFile);
                Rectangle rScreen = Screen.GetWorkingArea(f1);
                if (rScreen.Width + rScreen.X > f1.Location.X + xPos + cMenue.Width)
                    cMenue.Show(f1.Location.X + xPos, f1.Location.Y + yPos);
                else
                    cMenue.Show(f1.Location.X - cMenue.Width, f1.Location.Y + yPos);
            }
        }
        void iItem_DropDownOpening(object sender, EventArgs e)
        {
            ToolStripMenuItemEx iParentItem = (ToolStripMenuItemEx)sender;
            string DirTemp = iParentItem.Path;
            DirectoryInfo nodeDirInfo = new DirectoryInfo(DirTemp);
            int i = 0;
            if (nodeDirInfo.Exists)
            {

                rootDir = DirTemp;
                iParentItem.DropDownItems.Clear();

                DirectoryInfo[] dir = null;
                try
                {
                    dir = nodeDirInfo.GetDirectories();
                }
                catch (UnauthorizedAccessException)
                {
                     ; ;
                }
                ToolStripMenuItemEx[] iItem;

                if (dir != null)
                {
                    iItem = new ToolStripMenuItemEx[dir.Length];
                    i = 0;
                    foreach (DirectoryInfo dDir in dir)
                    {
                        iItem[i] = new ToolStripMenuItemEx(dDir.Name, imageList.Images[0]);
                        iItem[i].Path = dDir.FullName;
                        iItem[i].compressed = false;
                        iItem[i].DropDownItems.Add("...");
                        iItem[i].DropDown.Closing += new ToolStripDropDownClosingEventHandler(DropDown_Closing);
                        iItem[i].DropDownOpening += new EventHandler(iItem_DropDownOpening);
                        i++;
                    }
                    iParentItem.DropDownItems.AddRange(iItem);
                    iParentItem.DropDown.DoubleClick += new EventHandler(DropDown_DoubleClick);
                    iParentItem.DropDown.MouseClick += new MouseEventHandler(DropDown_MouseClick);
                }
                FileInfo[] fFile = null;
                try
                {
                    fFile = nodeDirInfo.GetFiles();
                }
                catch (UnauthorizedAccessException)
                {
                     ; ;
                }
                i = 0;
                if (fFile != null)
                {
                    // Integration of SharpZipLib for compressed folders

                    var query = (from fileExt in fFile
                                 where lExt.Contains(fileExt.Extension)
                                 select fileExt)
                             .ToList();


                    if (query.Count > 0)
                    {
                        iItem = new ToolStripMenuItemEx[query.Count];
                        foreach (FileInfo fi in query)
                        {
                            iItem[i] = new ToolStripMenuItemEx(fi.Name, imageList.Images[2]);
                            iItem[i].Path = fi.FullName;
                        //    iItem[i].compressed = true;
                            iItem[i].DropDownItems.Add("...");
                            iItem[i].DropDown.Closing += new ToolStripDropDownClosingEventHandler(DropDown_Closing);
                            iItem[i].DropDownOpening += new EventHandler(ziItem_DropDownOpening);
                            iItem[i].MouseDown += new MouseEventHandler(iItem_Click);
                            i++;
                        }
                        iParentItem.DropDownItems.AddRange(iItem);
                    }
                    //********************************************************

                    i = 0;
                    iItem = new ToolStripMenuItemEx[fFile.Length - query.Count];
                    foreach (FileInfo file in fFile)
                    {
                        if(!lExt.Contains(file.Extension))
                        { 
                            iItem[i] = fileInfo(file, fFile.Length);
                            i++;
                        }
                    }
                    iParentItem.DropDownItems.AddRange(iItem);
                }
            }
        }
        void ziItem_DropDownOpening(object sender, EventArgs e)
        {
            ToolStripMenuItemEx iParentItem = (ToolStripMenuItemEx)sender;
            string DirTemp = iParentItem.Path;
            DirectoryInfo nodeDirInfo = new DirectoryInfo(DirTemp);
            int i = 0;
           // if (iParentItem.compressed)
            {
                switch (DirTemp.Substring(DirTemp.Length - 4, 4))
                {
                    case ".zip":
                        using (var zipFile = new ZipFile(DirTemp))
                        {
                            i = 0;
                            ToolStripMenuItemEx[] iItem = new ToolStripMenuItemEx[zipFile.Count];
                            foreach (ZipEntry entry in zipFile)
                            {
                               iItem[i] = zipInfo(entry);
                               iItem[i].Path = DirTemp;
                               i++;
                            }
                            iParentItem.DropDownItems.Clear();
                            iParentItem.DropDownItems.AddRange(iItem);
                        }
                        break;
                    case ".tar":
                        break;
                    case ".bz2":
                        break;
                    case "r.gz":
                        break;
                    default:
                        break;
                }   
            }
        }

        void DropDown_MouseClick(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Right)
            {
              //  Point location = new Point(f1.Location.X, f1.Location.Y + yPos);
                string dirSelected, dirRoot;
                DirectoryInfo nodeDirInfo = new DirectoryInfo(rootDir);

                if (nodeDirInfo.Exists)
                {
                    if (nodeDirInfo.Parent != null)
                    {
                        dirRoot = nodeDirInfo.Parent.FullName.ToString();
                        dirSelected = nodeDirInfo.Name.ToString();
                        IShellContextMenu contextmen = new IShellContextMenu();
                        contextmen.iContextMenu(dirRoot, dirSelected,false);
                    }
                }
            }
        }

        ToolStripMenuItemEx fileInfo(FileInfo file, int iLength)
        {
            ToolStripMenuItemEx iItem = new ToolStripMenuItemEx();
            ShellExtensions.SHFILEINFO shinfo = new ShellExtensions.SHFILEINFO();
            IntPtr hImgSmall = ShellExtensions.Win32.SHGetFileInfo(file.FullName, 0, ref shinfo,
               (uint)Marshal.SizeOf(shinfo),
                ShellExtensions.Win32.SHGFI_ICON |
                ShellExtensions.Win32.SHGFI_SMALLICON);
            System.Drawing.Icon shellIcon =
                System.Drawing.Icon.FromHandle(shinfo.hIcon);
            Image iImage = shellIcon.ToBitmap();
            ShellExtensions.Win32.DestroyIcon(shinfo.hIcon);
            iItem = new ToolStripMenuItemEx(file.Name, iImage);
            iItem.DoubleClick += new EventHandler(iItem_DoubleClick);
            iItem.MouseDown += new MouseEventHandler(iItem_Click);
            iItem.Path = file.FullName;
            iItem.compressed = false;
            IntPtr hFileInfo = ShellExtensions.Win32.SHGetFileInfo(file.FullName, 0, ref shinfo,
               (uint)Marshal.SizeOf(shinfo),
                ShellExtensions.Win32.SHGFI_TYPENAME);
            string[] sCultureText;
            if (System.Threading.Thread.CurrentThread.CurrentUICulture.ToString() == "de-DE")
                sCultureText = de;
            else
                sCultureText = en;

            iItem.ToolTipText = sCultureText[0] + shinfo.szTypeName + "\n";
            iItem.ToolTipText += sCultureText[1] + CalcSize(file.Length) + "\n";
            iItem.ToolTipText += sCultureText[2] + file.LastWriteTime + "\n";
            iItem.ToolTipText += sCultureText[3] + file.CreationTime + "\n";
            return iItem;
        }

        ToolStripMenuItemEx zipInfo(ZipEntry entry)
        {
            ToolStripMenuItemEx iItem = new ToolStripMenuItemEx();
            iItem = new ToolStripMenuItemEx(entry.Name, imageList.Images[1]);
            iItem.DoubleClick += new EventHandler(iItem_DoubleClick);
            iItem.MouseDown += new MouseEventHandler(iItem_Click);
            iItem.Path = entry.ZipFileIndex.ToString();
            iItem.zipEntry = entry.ZipFileIndex;
            iItem.compressed = true;
            string[] sCultureText;
            if (System.Threading.Thread.CurrentThread.CurrentUICulture.ToString() == "de-DE")
                sCultureText = de_zip;
            else
                sCultureText = en_zip;

            iItem.ToolTipText = sCultureText[0] + CalcSize(entry.CompressedSize) + "\n";
            iItem.ToolTipText += sCultureText[1] + CalcSize(entry.Size) + "\n";
            iItem.ToolTipText += sCultureText[2] + entry.DateTime.ToString() + "\n";
            iItem.ToolTipText += sCultureText[3] + entry.Comment + "\n";
            return iItem;
        }

        string CalcSize(float lVal)
        {
            if (lVal < 1024)
                return lVal.ToString() + " Bytes";
            else
            {
                lVal /= 1024;
                if (lVal < 1024)
                    return lVal.ToString("##.##") + " KB";
                else
                {
                    lVal /= 1024;
                    if (lVal < 1024)
                        return lVal.ToString("##.##") + " MB";
                    else
                    {
                        lVal /= 1024;
                        return lVal.ToString("##.##") + " GB";
                    }

                }
            }
        }

        void iItem_Click(object sender, MouseEventArgs e)
        {
        //    Point location = new Point(f1.Location.X, f1.Location.Y + yPos);
            if (e.Button == MouseButtons.Right)
            {
                IShellContextMenu contextmen = new IShellContextMenu();
                ToolStripMenuItemEx mItem = (ToolStripMenuItemEx)sender;
                string root = mItem.Path.Substring(0, mItem.Path.LastIndexOf("\\")+1);
                contextmen.iContextMenu(root, sender.ToString(), false);
            }
            if (e.Button == MouseButtons.Left)
                iItem_DoubleClick(sender, e);
        }

        void iItem_DoubleClick(object sender, EventArgs e)
        {
            System.Diagnostics.Process proc = new System.Diagnostics.Process();
            proc.StartInfo.FileName = "rundll32.exe";
            ToolStripMenuItemEx mItem = (ToolStripMenuItemEx)sender;
            if (mItem.compressed)
            {
                try
                {
                    using (var fs = new FileStream(mItem.Path, FileMode.Open, FileAccess.Read))
                    using (var zf = new ZipFile(fs))
                    {
                        ZipEntry ze = zf.GetEntry(sender.ToString());
                        if (ze != null)
                        {
                            System.IO.Stream s = zf.GetInputStream(ze);
                            if(ze.IsFile)
                            {
                                using (BinaryReader reader = new BinaryReader(s))
                                {

                                    String filename = ze.Name;
                                    if (filename.Contains("/"))
                                        filename = Path.GetFileName(filename);

                                    string filepath = Path.GetTempPath() + filename;

                                    using (BinaryWriter writer = new BinaryWriter(File.Open(filepath, FileMode.Create)))
                                    {

                                        byte[] buffer = new byte[8 * 1024];
                                        int len;
                                        while ( (len = reader.Read(buffer, 0, buffer.Length)) > 0)
                                        {
                                            writer.Write(buffer, 0, len);
                                        }
                                        proc.StartInfo.Arguments = " shell32.dll,ShellExec_RunDLL " + filepath;
                                    }
                                }
                            }
                        }

                    }

                }
                catch (Exception)
                {
                    
                    ;
                }
           
            }
            else
                proc.StartInfo.Arguments = " shell32.dll,ShellExec_RunDLL " + rootDir + "\\" + sender.ToString(); 
            try
            {
                if (proc.StartInfo.Arguments != "")
                    proc.Start();
            }
            catch (Exception ex)
            {
                if (ex.Message == "Application not found" || ex.Message == "Anwendung nicht gefunden") //open "OpenAs" filedialog
                {
                    proc.StartInfo.FileName = "rundll32.exe";
                    proc.StartInfo.Arguments = " shell32.dll, OpenAs_RunDLL " + rootDir + "\\" + sender.ToString();
                    proc.Start();
                }
            }
        }
        void DropDown_DoubleClick(object sender, EventArgs e)
        {
            System.Diagnostics.Process.Start(rootDir);
        }
        void DropDown_Closing(object sender, ToolStripDropDownClosingEventArgs e)
        {
        }

        string[] de = { "Typ: ", "Größe: ", "Geändert: ", "Erstellt: " };
        string[] en = { "type: ", "size: ", "changed: ", "created: " };
        string[] de_zip = { "kompr. Größe: ", "Größe: ", "Datum: ", "Kommentar: " };
        string[] en_zip = { "compr. size: ", "size: ", "date: ", "comment: " };
    }
}
