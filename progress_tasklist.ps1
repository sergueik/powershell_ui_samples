#Copyright (c) 2014,2015 Serguei Kouzmine
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

# http://www.codeproject.com/Articles/11588/Progress-Task-List-Control
Add-Type -TypeDefinition @"
// "
using System;
using System.Collections;
using System.Collections.Specialized;
using System.ComponentModel;
using System.ComponentModel.Design;
using System.Drawing;
using System.Data;
using System.Windows.Forms;
using System.IO;

namespace WIP
{
    public class ProgressTaskList : System.Windows.Forms.Panel
    {
        private System.ComponentModel.IContainer components;
        private Label[] labels;
        private StringCollection2 tasks;
        private System.Windows.Forms.ImageList imageList1;
        private int currentTask = 0;
        private string iconPath = @"C:\developer\sergueik\powershell_ui_samples";
        private string[] iconNames = new string[] {
          "1420429962_216151.ico",
          "1420429337_5880.ico",
          "1420429523_62690.ico",
          "1420429596_9866.ico"        
        } ;

        public ProgressTaskList(string iconPath = null)
        { 
            if (iconPath != null){ 
                this.iconPath = iconPath ;
            }
            InitializeComponent();
            tasks = new StringCollection2(this);
        }

        public void InitLabels()
        {
            this.Controls.Clear();
            if (tasks != null && tasks.Count > 0)
            {
                labels = new Label[tasks.Count];
                int leftIndent = 3;
                int topPos = 3;
                for (int i = 0; i < tasks.Count; i++)
                {
                    Label l = new Label();
                    l.AutoSize = true;
                    l.Height = 23;
                    l.Location = new Point(leftIndent, topPos);
                    l.Text = "      " + tasks[i];		// preceeding spaces to leave room for image
                    l.ImageAlign = ContentAlignment.MiddleLeft;
                    l.TextAlign = ContentAlignment.MiddleLeft;
                    l.ImageList = this.imageList1;
                    topPos += 23;
                    this.labels[i] = l;
                    this.Controls.Add(l);
                }
            }
        }

        public StringCollection2 TaskItems
        {
            get
            {
                return tasks;
            }
            set
            {
                tasks = value;
                this.InitLabels();
            }
        }

        delegate void StartDelegate();
        public void Start()
        {
            if (this.InvokeRequired)
            {
                StartDelegate del = new StartDelegate(this.Start);
                BeginInvoke(del, null);
            }
            else
            {
                currentTask = 0;
                InitLabels();
                if (labels != null && labels.Length > 0)
                    this.labels[0].ImageIndex = 0;
            }
        }

        delegate void NextTaskDelegate();
        public void NextTask()
        {
            if (this.InvokeRequired)
            {
                NextTaskDelegate del = new NextTaskDelegate(this.NextTask);
                BeginInvoke(del, null);
            }
            else
            {
                if (currentTask < this.labels.Length)
                    this.labels[currentTask].ImageIndex = 1;
                currentTask++;
                if (currentTask < labels.Length)
                {
                    this.ScrollControlIntoView(this.labels[currentTask]);	// make sure the label is visible. this is necessary in the case where the panel is scrolling vertically. it is nice for the user to see the current task scrolling into view automatically.
                    this.labels[currentTask].ImageIndex = 0;
                }
            }
        }
        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (components != null)
                {
                    components.Dispose();
                }
            }
            base.Dispose(disposing);
        }

        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.Resources.ResourceManager resources = new System.Resources.ResourceManager(typeof(ProgressTaskList));
            this.imageList1 = new System.Windows.Forms.ImageList(this.components);
            this.imageList1.ImageSize = new System.Drawing.Size(16, 16);
            foreach (string iconName in this.iconNames)
            {
                this.imageList1.Images.Add(new Icon(Path.Combine(this.iconPath, iconName)));
            }
            this.imageList1.TransparentColor = System.Drawing.Color.Transparent;
            this.AutoScroll = true;
            this.Size = new System.Drawing.Size(175, 50);
        }
    }

    public class StringCollection2 : CollectionBase
    {
        private ProgressTaskList parent;
        public StringCollection2(ProgressTaskList parent)
            : base()
        {
            this.parent = parent;
        }

        public string this[int index]
        {
            get
            {
                return ((string)List[index]);
            }
            set
            {
                List[index] = value;
            }
        }

        public ProgressTaskList Parent
        {
            get
            {
                return this.parent;
            }
        }

        public int Add(string value)
        {
            int result = List.Add(value);
            return result;
        }

        public void AddRange(string[] strings)
        {
            // Use external to validate and add each entry
            foreach (string s in strings)
            {
                this.Add(s);
            }
        }

        public int IndexOf(string value)
        {
            return (List.IndexOf(value));
        }

        public void Insert(int index, string value)
        {
            List.Insert(index, value);
        }

        public void Remove(string value)
        {
            List.Remove(value);
        }

        public bool Contains(string value)
        {
            return (List.Contains(value));
        }

        protected override void OnInsertComplete(int index, object value)
        {
            base.OnInsertComplete(index, value);
            parent.InitLabels();
        }

        protected override void OnRemoveComplete(int index, object value)
        {
            base.OnRemoveComplete(index, value);
            parent.InitLabels();
        }
    }
}


"@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Drawing.dll','System.Data.dll','System.ComponentModel.dll'


# http://www.codeproject.com/Articles/11588/Progress-Task-List-Control

$shared_assemblies = @{
  'ProgressTaskList.dll' = $null;
  'nunit.core.dll' = $null;
  'nunit.framework.dll' = $null;

}


$shared_assemblies_path = 'c:\developer\sergueik\csharp\SharedAssemblies'

if (($env:SHARED_ASSEMBLIES_PATH -ne $null) -and ($env:SHARED_ASSEMBLIES_PATH -ne '')) {

  Write-Debug ('Using environment: {0}' -f $env:SHARED_ASSEMBLIES_PATH)
  $shared_assemblies_path = $env:SHARED_ASSEMBLIES_PATH
}

pushd $shared_assemblies_path

$shared_assemblies.Keys | ForEach-Object {
  $assembly = $_

  if ($host.Version.Major -gt 2) {
    Unblock-File -Path $assembly
  }
  Add-Type -Path $assembly
  Write-Debug $assembly
}
popd

Add-Type -TypeDefinition @"
using System;
using System.Windows.Forms;
public class Win32Window : IWin32Window
{
    private IntPtr _hWnd;
    private int _current;
    private int _last;

    private string _script_directory;

    public int Current
    {
        get { return _current; }
        set { _current = value; }
    }
    public int Last
    {
        get { return _last; }
        set { _last = value; }
    }
    public string ScriptDirectory
    {
        get { return _script_directory; }
        set { _script_directory = value; }
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


function ProgressbarTasklist {
  param(
    [string]$title,
    [System.Management.Automation.PSReference]$data_ref,
    [object]$caller
  )

  @( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }

  $f = New-Object -TypeName 'System.Windows.Forms.Form'
  $f.Text = $title

  $f.Size = New-Object System.Drawing.Size (650,150)
  $f.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
  $f.AutoScaleBaseSize = New-Object System.Drawing.Size (5,14)
  $f.ClientSize = New-Object System.Drawing.Size (292,144)


  $panel = New-Object System.Windows.Forms.Panel
  $panel.BackColor = [System.Drawing.Color]::Silver
  $panel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle

  $b = New-Object System.Windows.Forms.Button
  $b.Location = New-Object System.Drawing.Point (210,114)
  # $b.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font
  $b.Font = New-Object System.Drawing.Font ('Microsoft Sans Serif',7,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)

  $b.Text = 'forward'

  $b.add_click({

      if ($caller.Current -eq $caller.Last)
      {

        $b.Enabled = $false
      } else {

        if (-not $o.Visible) {
          # set the first task to 'in progress'
          $o.Visible = $true
          $caller.Current = 1
          $o.Start()


        } else {
          # set the following task to 'in progress'
          $o.NextTask()
          $caller.Current = $caller.Current + 1
        }
      }
    })

  # control is now inline
  # $i = New-Object -TypeName 'Ibenza.UI.Winforms.ProgressTaskList' -ArgumentList @()
  $o = New-Object -TypeName 'WIP.ProgressTaskList' -ArgumentList @((Get-ScriptDirectory))


  $o.BackColor = [System.Drawing.Color]::Transparent
  $o.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
  $o.Dock = [System.Windows.Forms.DockStyle]::Fill
  $o.Location = New-Object System.Drawing.Point (0,0)
  $o.Name = "progressTaskList1"
  $o.Size = New-Object System.Drawing.Size (288,159)
  $o.TabIndex = 2

  $o.TaskItems.AddRange(@( [string[]]$data_ref.Value.Keys))

  $caller.Last = $data_ref.Value.Keys.Count + 1 # will use 1-based index 
  $o.Visible = $false
  $panel.SuspendLayout()
  $panel.ForeColor = [System.Drawing.Color]::Black
  $panel.Location = New-Object System.Drawing.Point (0,0)
  $panel.Name = 'panel'
  $panel.Size = New-Object System.Drawing.Size (($f.Size.Width),($f.Size.Height))
  $panel.TabIndex = 1

  $panel.Controls.Add($o)
  $panel.ResumeLayout($false)
  $panel.PerformLayout()


  $f.Controls.AddRange(@( $b,$panel))
  $f.Topmost = $True

  # $so.Visible = $caller.Visible = $true
  $f.Add_Shown({ $f.Activate() })

  [void]$f.ShowDialog([win32window]($caller))

  $f.Dispose()
}
$data = @{
  'Verifying cabinet integrity' = $null;
  'Checking necessary disk space' = $null;
  'Extracting files' = $null;
  'Modifying registry' = $null;
  'Installing files' = $null;
  'Removing temporary files' = $null; }

$title = 'test'
$caller = New-Object Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)
[void](ProgressbarTasklist -Title $title -caller $caller -data_ref ([ref]$data))




