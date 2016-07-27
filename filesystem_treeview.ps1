#Copyright (c) 2014 Serguei Kouzmine
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

param(
  [switch]$debug
)
# http://poshcode.org/2887
# http://stackoverflow.com/questions/8343767/how-to-get-the-current-directory-of-the-cmdlet-being-executed
# https://msdn.microsoft.com/en-us/library/system.management.automation.invocationinfo.pscommandpath%28v=vs.85%29.aspx
function Get-ScriptDirectory
{
  [string]$scriptDirectory = $null

  if ($host.Version.Major -gt 2) {
    $scriptDirectory = (Get-Variable PSScriptRoot).Value
    Write-Debug ('$PSScriptRoot: {0}' -f $scriptDirectory)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }
    $scriptDirectory = [System.IO.Path]::GetDirectoryName($MyInvocation.PSCommandPath)
    Write-Debug ('$MyInvocation.PSCommandPath: {0}' -f $scriptDirectory)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }

    $scriptDirectory = Split-Path -Parent $PSCommandPath
    Write-Debug ('$PSCommandPath: {0}' -f $scriptDirectory)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }
  } else {
    $scriptDirectory = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value
    if ($Invocation.PSScriptRoot) {
      $scriptDirectory = $Invocation.PSScriptRoot
    } elseif ($Invocation.MyCommand.Path) {
      $scriptDirectory = Split-Path $Invocation.MyCommand.Path
    } else {
      $scriptDirectory = $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf('\'))
    }
    return $scriptDirectory
  }
}




Add-Type -TypeDefinition @"

// "
using System;
using System.Windows.Forms;
public class Win32Window : IWin32Window
{
    private IntPtr _hWnd;
    private string _data;

    public String Data
    {
        get { return _data; }
        set { _data = value; }
    }

    public Win32Window(IntPtr handle)
    {
        _hWnd = handle;
    }

    public IntPtr Handle
    {
        get { return _hWnd; }
    }
}

"@ -ReferencedAssemblies 'System.Windows.Forms.dll'

Add-Type -TypeDefinition @"
using System;
using System.IO;
using System.Windows.Forms;
using System.ComponentModel;
using System.Collections;
using System.Drawing;
using System.Runtime.InteropServices;

namespace C2C.FileSystem
{
    public class FileSystemTreeView : TreeView
    {
        private TreeNode _selectedNode;
        private bool _showFiles = true;
        public bool ShowFiles
        {
            get { return this._showFiles; }
            set { this._showFiles = value; }
        }

        private ImageList _imageList = new ImageList();
        private Hashtable _systemIcons = new Hashtable();

        private string _data;
        public String Data
        {
            get { return this._data; }
            set { this._data = value; }
        }
        private string _iconPath = Path.Combine( Directory.GetCurrentDirectory(), "folder.ico" );
        public String IconPath
        {
            get { return this._iconPath; }
            set { this._iconPath = value; }
        }

        private bool _debug = false;
        public bool Debug
        {
            get { return this._debug; }
            set { this._debug = value; }
        }

        public static readonly int Folder = 0;

        public FileSystemTreeView()
        {
            this.ImageList = _imageList;
            this.MouseDown += new MouseEventHandler(FileSystemTreeView_MouseDown);
            this.BeforeExpand += new TreeViewCancelEventHandler(FileSystemTreeView_BeforeExpand);
            this.AfterSelect += new TreeViewEventHandler (FileSystemTreeView_AfterSelect);
        }

        void FileSystemTreeView_MouseDown(object sender, MouseEventArgs e)
        {
            TreeNode node = this.GetNodeAt(e.X, e.Y);
            _selectedNode = node;
            if (node == null)
                return;
            this.SelectedNode = node; //selected the node under the mouse         
        }

        void FileSystemTreeView_BeforeExpand(object sender, TreeViewCancelEventArgs e)
        {
            if (e.Node is FileNode) return;

            DirectoryNode node = (DirectoryNode)e.Node;

            if (!node.Loaded)
            {
                node.Nodes[0].Remove(); //remove the fake child node used for virtualization
                node.LoadDirectory();
                if (this._showFiles == true)
                    node.LoadFiles();
            }
        }
        private void FileSystemTreeView_AfterSelect(System.Object sender,
                System.Windows.Forms.TreeViewEventArgs e)
        {

            // MessageBox.Show(this._debug.ToString());
            // e.Action = Unknown
            if (_selectedNode != null && _selectedNode.Parent != null)
            {
                if (_debug)
                {
                    MessageBox.Show(String.Format("AfterSelect: {0}", _selectedNode.FullPath.ToString()));
                }
                this._data = _selectedNode.FullPath.ToString();
            }
        }

        public void Load(string directoryPath)
        {
            if (Directory.Exists(directoryPath) == false)
                throw new DirectoryNotFoundException(String.Format("Directory Not Found: {0}", directoryPath));

            _systemIcons.Clear();
            _imageList.Images.Clear();
            Nodes.Clear();
            Icon folderIcon = new Icon(this._iconPath);

            _imageList.Images.Add(folderIcon);
            _systemIcons.Add(FileSystemTreeView.Folder, 0);

            DirectoryNode node = new DirectoryNode(this, new DirectoryInfo(directoryPath));
            node.Expand();
        }

        public int GetIconImageIndex(string path)
        {
            string extension = Path.GetExtension(path);

            if (_systemIcons.ContainsKey(extension) == false)
            {
                Icon icon = ShellIcon.GetSmallIcon(path);
                _imageList.Images.Add(icon);
                _systemIcons.Add(extension, _imageList.Images.Count - 1);
            }

            return (int)_systemIcons[Path.GetExtension(path)];
        }

    }

    public class DirectoryNode : TreeNode
    {
        private DirectoryInfo _directoryInfo;

        public DirectoryNode(DirectoryNode parent, DirectoryInfo directoryInfo)
            : base(directoryInfo.Name)
        {
            this._directoryInfo = directoryInfo;

            this.ImageIndex = FileSystemTreeView.Folder;
            this.SelectedImageIndex = this.ImageIndex;

            parent.Nodes.Add(this);

            Virtualize();
        }

        public DirectoryNode(FileSystemTreeView treeView, DirectoryInfo directoryInfo)
            : base(directoryInfo.Name)
        {
            this._directoryInfo = directoryInfo;

            this.ImageIndex = FileSystemTreeView.Folder;
            this.SelectedImageIndex = this.ImageIndex;

            treeView.Nodes.Add(this);

            Virtualize();

        }

        void Virtualize()
        {
            int fileCount = 0;

            try
            {
                if (this.TreeView.ShowFiles == true)
                    fileCount = this._directoryInfo.GetFiles().Length;

                if ((fileCount + this._directoryInfo.GetDirectories().Length) > 0)
                    new FakeChildNode(this);
            }
            catch
            {
            }
        }

        public void LoadDirectory()
        {
            foreach (DirectoryInfo directoryInfo in _directoryInfo.GetDirectories())
            {
                new DirectoryNode(this, directoryInfo);
            }
        }

        public void LoadFiles()
        {
            foreach (FileInfo file in _directoryInfo.GetFiles())
            {
                new FileNode(this, file);
            }
        }

        public bool Loaded
        {
            get
            {
                if (this.Nodes.Count != 0)
                {
                    if (this.Nodes[0] is FakeChildNode)
                        return false;
                }

                return true;
            }
        }

        public new FileSystemTreeView TreeView
        {
            get { return (FileSystemTreeView)base.TreeView; }
        }
    }

    public class FileNode : TreeNode
    {
        private FileInfo _fileInfo;
        private DirectoryNode _directoryNode;

        public FileNode(DirectoryNode directoryNode, FileInfo fileInfo)
            : base(fileInfo.Name)
        {
            this._directoryNode = directoryNode;
            this._fileInfo = fileInfo;

            this.ImageIndex = ((FileSystemTreeView)_directoryNode.TreeView).GetIconImageIndex(_fileInfo.FullName);
            this.SelectedImageIndex = this.ImageIndex;

            _directoryNode.Nodes.Add(this);
        }
    }

    public class FakeChildNode : TreeNode
    {
        public FakeChildNode(TreeNode parent)
            : base()
        {
            parent.Nodes.Add(this);
        }
    }

    public class ShellIcon
    {
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

        class Win32
        {
            public const uint SHGFI_ICON = 0x100;
            public const uint SHGFI_LARGEICON = 0x0; // 'Large icon
            public const uint SHGFI_SMALLICON = 0x1; // 'Small icon

            [DllImport("shell32.dll")]
            public static extern IntPtr SHGetFileInfo(string pszPath, uint dwFileAttributes, ref SHFILEINFO psfi, uint cbSizeFileInfo, uint uFlags);
        }

        public ShellIcon()
        {
            // TODO: Add constructor logic here
        }

        public static Icon GetSmallIcon(string fileName)
        {
            IntPtr hImgSmall; //the handle to the system image list
            SHFILEINFO shinfo = new SHFILEINFO();

            //Use this to get the small Icon
            hImgSmall = Win32.SHGetFileInfo(fileName, 0, ref shinfo, (uint)Marshal.SizeOf(shinfo), Win32.SHGFI_ICON | Win32.SHGFI_SMALLICON);

            //The icon is returned in the hIcon member of the shinfo struct
            return System.Drawing.Icon.FromHandle(shinfo.hIcon);
        }

        public static Icon GetLargeIcon(string fileName)
        {
            IntPtr hImgLarge; //the handle to the system image list
            SHFILEINFO shinfo = new SHFILEINFO();

            //Use this to get the large Icon
            hImgLarge = Win32.SHGetFileInfo(fileName, 0, ref shinfo, (uint)Marshal.SizeOf(shinfo), Win32.SHGFI_ICON | Win32.SHGFI_LARGEICON);

            //The icon is returned in the hIcon member of the shinfo struct
            return System.Drawing.Icon.FromHandle(shinfo.hIcon);
        }
    }

}

"@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Drawing.dll'

[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Data')

$caller = New-Object -TypeName 'Win32Window' -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)

$f = New-Object System.Windows.Forms.Form
$f.Text = $title


$f.Size = New-Object System.Drawing.Size (700,450)

$panel = New-Object System.Windows.Forms.Panel


$p1 = New-Object System.Windows.Forms.Panel
$b2 = New-Object System.Windows.Forms.Button
$l1 = New-Object System.Windows.Forms.Label
$t1 = New-Object System.Windows.Forms.TextBox
$t = New-Object System.Windows.Forms.Panel
$p1.SuspendLayout()
$f.SuspendLayout()

# 
# panel1
# 
$p1.Controls.Add($b2)
$p1.Controls.Add($l1)
$p1.Controls.Add($t1)
$p1.Dock = [System.Windows.Forms.DockStyle]::Top
$p1.Location = New-Object System.Drawing.Point (0,0)
$p1.Name = 'panel1'
$p1.Size = New-Object System.Drawing.Size (681,57)
$p1.TabIndex = 0

#
# Include? Files checkbox
#
$cb1 = New-Object System.Windows.Forms.CheckBox
$cb1.Location = New-Object System.Drawing.Point (515,27)
$cb1.Size = New-Object System.Drawing.Size (120,20)
$cb1.Text = 'Files'

$p1.Controls.Add($cb1)


# 
# Close Button
# 
$b2.Location = New-Object System.Drawing.Point (560,27)
$b2.Name = "btnDirectory"
$b2.Size = New-Object System.Drawing.Size (60,21)
$b2.TabIndex = 2
$b2.Text = 'Select'
$b2.add_click({ if ($caller.Data -ne $null) { $f.Close() } })

# 
# Current Selection Label
# 
$l1.Location = New-Object System.Drawing.Point (9,9)
$l1.Name = 'label1'
$l1.Size = New-Object System.Drawing.Size (102,18)
$l1.TabIndex = 1
$l1.Text = 'Selection:'

# 
# Current Selection Result
# 
$t1.Location = New-Object System.Drawing.Point (9,27)
$t1.Name = 'txtDirectory'
$t1.Size = New-Object System.Drawing.Size (503,20)
$t1.TabIndex = 0
$t1.Text = ''

# 
# treePanel
# 
$t.Dock = [System.Windows.Forms.DockStyle]::Fill
$t.Location = New-Object System.Drawing.Point (0,57)
$t.Name = "treePanel"
$t.Size = New-Object System.Drawing.Size (621,130)
$t.TabIndex = 1

$c = New-Object -TypeName 'C2C.FileSystem.FileSystemTreeView'
$c.IconPath = [System.IO.Path]::Combine((Get-ScriptDirectory),'folder.ico')
if ($PSBoundParameters["debug"]) {
  $c.Debug = $true
}

$c.ShowFiles = $false
$c.Dock = [System.Windows.Forms.DockStyle]::Fill
$c.Add_AfterSelect({ if ($c.Debug) { Write-Host $c.Data; } $t1.Text = $caller.Data = $c.Data })
$c.Load('C:\')
$t.Controls.Add($c)

$cb1.add_click({ if ($cb1.Checked -eq $true) { $c.ShowFiles = $true } else { $c.ShowFiles = $false } })

# Form1
# 
$f.AutoScaleBaseSize = New-Object System.Drawing.Size (5,13)
$f.ClientSize = New-Object System.Drawing.Size (621,427)
$f.Controls.Add($t)
$f.Controls.Add($p1)
$f.Name = 'Form1'
$f.Text = 'Demo Chooser'
$p1.ResumeLayout($false)
$f.ResumeLayout($false)
$f.Add_Shown({ $f.Activate() })
$f.KeyPreview = $True
$f.Add_KeyDown({

    if ($_.KeyCode -eq 'Escape') { $caller.Data = $null }
    else { return }
    $f.Close()
  })

[void]$f.ShowDialog([win32window]($caller))

$f.Dispose()
Write-Output $caller.Data
