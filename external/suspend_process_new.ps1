Add-Type -TypeDefinition @"

// "
using System;
using System.Windows.Forms;

public class Win32Window : IWin32Window
{
    private IntPtr _hWnd;

    private  String _item;

    public String Item    {
        get { return _item; }
        set { _item = value; }
    }
    private bool _asc = true;

    public bool IsAscending  {
        get { return _asc; }
        set { _asc = value; }
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
"@ -ReferencedAssemblies "System.Windows.Forms.dll"

Add-Type -TypeDefinition @"

// "
using System;
using System.Text;
using System.Net;
using System.Windows.Forms;

using System.Runtime.InteropServices;
namespace Nt
{
public class ProcessHelper
{

    [Flags]
    public enum ProcessAccessFlags : uint
    {
        All = 0x001F0FFF,
        Terminate = 0x00000001,
        CreateThread = 0x00000002,
        VMOperation = 0x00000008,
        VMRead = 0x00000010,
        VMWrite = 0x00000020,
        DupHandle = 0x00000040,
        SetInformation = 0x00000200,
        QueryInformation = 0x00000400,
        Synchronize = 0x00100000,
        ReadControl = 0x00020000
    }
    [DllImport("ntdll.dll", SetLastError = true)]
    public static extern IntPtr NtSuspendProcess(IntPtr ProcessHandle);

    [DllImport("kernel32.dll")]
    public static extern IntPtr OpenProcess(
         ProcessAccessFlags processAccess,
         bool bInheritHandle,
         IntPtr processId
    );

    public static uint PROCESS_SUSPEND_RESUME = 0x00000800;

    [DllImport("ntdll.dll", SetLastError = true)]
    public static extern IntPtr NtResumeProcess(IntPtr ProcessHandle);

    [DllImport("kernel32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern /* unsafe  */ bool CloseHandle(
            IntPtr hObject
            );


    public static IntPtr SuspendResumeProcess(IntPtr Pid, bool Action)
    {

        IntPtr hProcess = OpenProcess((ProcessAccessFlags)PROCESS_SUSPEND_RESUME, false, Pid);
        IntPtr result = IntPtr.Zero;
        if (hProcess != IntPtr.Zero)
        {           
          result = (Action) ? NtSuspendProcess(hProcess) : NtResumeProcess(hProcess);
        }
        return result;
    }

}

}
"@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Net.dll','System.Runtime.InteropServices.dll'
$o = New-Object -TypeName 'Nt.ProcessHelper'

function suspend_process {
  param([int]$process_id)

  [Nt.ProcessHelper]::SuspendResumeProcess($process_id,$true)

}

function resume_process {
  param([int]$process_id)

  [Nt.ProcessHelper]::SuspendResumeProcess($process_id,$false)

}

function draw_processes {
  param(
    [object[]]$data = $null,
    [string[]]$columnNames = $null,
    [string[]]$columnTag,
    [string[]]$columnProperties = $null,
    [bool]$debug
  )
  @( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }

  if ($columnNames -eq $null) {
    $columnNames = $columnProperties
  }
  if ($columnProperties -eq $null -or
    $columnNames.Count -lt 1 -or
    $columnNames.Count -ne $columnNames.Count) {

    throw 'Data validation failed: column count mismatch'
  }
  $numCols = $columnNames.Count

  # figure out form width
  $width = $numCols * 200

  $title = 'Select process'
  $f = New-Object System.Windows.Forms.Form
  $f.Text = $title
  $f.Size = New-Object System.Drawing.Size (300,200)
  $f.StartPosition = 'CenterScreen'

  $f.KeyPreview = $true

  $r = New-Object System.Windows.Forms.Button
  $r.Location = New-Object System.Drawing.Size (150,120)
  $r.Size = New-Object System.Drawing.Size (75,23)
  $r.Text = 'Resume'
  $r.add_click({
      resume_process ($owner.Item)
    })
  $f.Controls.Add($r)

  $s = New-Object System.Windows.Forms.Button
  $s.Location = New-Object System.Drawing.Size (75,120)
  $s.Size = New-Object System.Drawing.Size (75,23)
  $s.Text = 'Suspend'
  $s.add_click({
      suspend_process ($owner.Item)
    })
  $f.Controls.Add($s)

  $panel = New-Object System.Windows.Forms.Panel
  $panel.Dock = 'Fill'
  $f.Controls.Add($panel)
  $lv = New-Object windows.forms.ListView
  $panel.Controls.Add($lv)


  # create the columns
  $lv.View = [System.Windows.Forms.View]'Details'
  $lv.Size = New-Object System.Drawing.Size ($width,350)
  $lv.FullRowSelect = $true
  $lv.GridLines = $true
  $lv.Dock = 'Fill'
  foreach ($col in $columnNames) {
    $lv.Columns.Add($col,200) > $null
  }

  # populate the view
  foreach ($d in $data) {
    $item =
    New-Object System.Windows.Forms.ListViewItem (
      (Invoke-Expression ('$d.' + $columnProperties[0])).ToString())

    for ($i = 1; $i -lt $columnProperties.Count; $i++) {
      [void]$item.SubItems.Add(
        (Invoke-Expression ('$d.' + $columnProperties[$i])).ToString())
    }
    $item.Tag = $d
    [void]$lv.Items.Add($item)
  }
  <#
  $lv.add_ItemActivate({
      param(
        [object]$sender,[System.EventArgs]$e)

      [System.Windows.Forms.ListView]$lw = [System.Windows.Forms.ListView]$sender
      [string]$filename = $lw.SelectedItems[0].Tag.ToString()
    })
  #>
  $lv.add_ItemSelectionChanged({
      param(
        [object]$sender,[System.Windows.Forms.ListViewItemSelectionChangedEventArgs]$e)

      [System.Windows.Forms.ListView]$lw = [System.Windows.Forms.ListView]$sender
      $si = $e.Item.SubItems[1]
      [int]$process_id = 0
      [int32]::TryParse($si.Text,([ref]$process_id))
      $owner.Item = $process_id
    })

# sort 
  for ($i = 0; $i -lt $columnTag.Count; $i++) {

    $lv.Columns[$i].Tag = $columnTag[$i]

  }
# http://www.java2s.com/Code/CSharp/GUI-Windows-Form/SortaListViewbyAnyColumn.htm
# http://www.java2s.com/Code/CSharp/GUI-Windows-Form/UseRadioButtontocontroltheListViewdisplaystyle.htm
Add-Type -TypeDefinition @"
using System;
using System.Windows.Forms;
using System.Drawing;
using System.Collections;

public class ListViewItemComparer : System.Collections.IComparer
{
    public int col = 0;
    public System.Windows.Forms.SortOrder Order;
    public ListViewItemComparer()
    {
        col = 0;
    }

    public ListViewItemComparer(int column, bool asc)
    {
        col = column;
        if (asc)
        { Order = SortOrder.Ascending; }
        else
        { Order = SortOrder.Descending; }
    }

    public int Compare(object x, object y)
    {
        if (!(x is ListViewItem)) return (0);
        if (!(y is ListViewItem)) return (0);

        ListViewItem l1 = (ListViewItem)x;
        ListViewItem l2 = (ListViewItem)y;

        if (l1.ListView.Columns[col].Tag == null)
        {
            l1.ListView.Columns[col].Tag = "Text";
        }

        if (l1.ListView.Columns[col].Tag.ToString() == "Numeric")
        {
            float fl1 = float.Parse(l1.SubItems[col].Text);
            float fl2 = float.Parse(l2.SubItems[col].Text);
            return (Order == SortOrder.Ascending) ?  fl1.CompareTo(fl2) :  fl2.CompareTo(fl1);
/*
            if (Order == SortOrder.Ascending)
            {
                return fl1.CompareTo(fl2);
            }
            else
            {
                return fl2.CompareTo(fl1);
            }
*/
        }
        else
        {
            string str1 = l1.SubItems[col].Text;
            string str2 = l2.SubItems[col].Text;
            return (Order == SortOrder.Ascending) ? str1.CompareTo(str2) : str2.CompareTo(str1);
/*
            if (Order == SortOrder.Ascending)
            {
                return str1.CompareTo(str2);
            }
            else
            {
                return str2.CompareTo(str1);

            }
*/
        }

    }
}
"@ -ReferencedAssemblies 'System.Windows.Forms','System.Drawing'
  
  $lv.Add_ColumnClick({
   $lv.ListViewItemSorter = New-Object ListViewItemComparer ($_.Column, $owner.IsAscending)
   $owner.IsAscending = !$owner.IsAscending
  })

  $f.Topmost = $True
  $owner = New-Object Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)
  $owner.Item = 42;

  $f.Add_Shown({ $f.Activate() })
  $x = $f.ShowDialog($owner)

}

draw_processes -data (Get-Process) -columnNames ('Name','ID') -columnProperties ("Name","ID") -columnTag ("Text","Numeric")
