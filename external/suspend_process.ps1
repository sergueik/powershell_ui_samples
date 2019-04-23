# http://poshcode.org/5635
#requires -version 2.0

<#
    .Synopsis
        Output the results of a command in a Windows Form
    .Description
        Output the results of a command in a Windows Form with possibility to add buttons with actions
    .Example

        out-form
                 -title "Services"
                 -data (get-service)
                 -columnNames ("Name", "Status")
                 -columnProperties ("DisplayName", "Status")
                 -actions @{"Start" = {$_.start()}; "Stop" = {$_.stop()}; }
    #>
# http://stackoverflow.com/questions/11010165/how-to-suspend-resume-a-process-in-windows
# http://poshcode.org/2189

function Out-Form {
  param(
    $title = '',
    $data = $null,
    $columnNames = $null,
    $columnTag,
    $columnProperties = $null,
    $actions = $null )

  @( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }

  # a little data defaulting/validation
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
  $actionWidth = $actions.Count * 100 + 40
  if ($actionWidth -gt $width) {
    $width = $actionWidth
  }

  # set up form. Use alternative syntax
  $form = new-object System.Windows.Forms.Form
  $form.Text = $title
  $form.Size = new-object System.Drawing.Size ($width,400)
  $panel = new-object System.Windows.Forms.Panel
  $panel.Dock = 'Fill'
  $form.Controls.Add($panel)

  $lv = new-object windows.forms.ListView
  $panel.Controls.Add($lv)

  # add the buttons
  $btnPanel = new-object System.Windows.Forms.Panel
  $btnPanel.Height = 40
  $btnPanel.Dock = "Bottom"
  $panel.Controls.Add($btnPanel)

  $btns = new-object System.Collections.ArrayList
  if ($actions -ne $null) {
    $btnOffset = 20
    foreach ($action in $actions.GetEnumerator()) {
      $btn = new-object windows.forms.Button
      # https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.form.dialogresult?view=netframework-4.5s
      $btn.DialogResult = [System.Windows.Forms.DialogResult]'OK'
      $btn.Text = $action.Name
      $btn.Left = $btnOffset
      $btn.Width = 80
      $btn.Top = 10
      $exprString = '{$lv.SelectedItems | foreach-object { $_.Tag } | foreach-object {' + $action.Value + '}}'
      $scriptBlock = Invoke-Expression $exprString
      $btn.add_click($scriptBlock)
      $btnPanel.Controls.Add($btn)
      $btnOffset += 100
      $btns += $btn
    }
  }

  # create the columns
  $lv.View = [System.Windows.Forms.View]'Details'
  $lv.Size = new-object System.Drawing.Size ($width,350)
  $lv.FullRowSelect = $true
  $lv.GridLines = $true
  $lv.Dock = "Fill"
  foreach ($col in $columnNames) {
    $lv.Columns.Add($col,200) > $null
  }

  # populate the view
  foreach ($d in $data) {
    $item =
    new-object System.Windows.Forms.ListViewItem (
      (Invoke-Expression ('$d.' + $columnProperties[0])).ToString())

    for ($i = 1; $i -lt $columnProperties.Count; $i++) {
      $item.SubItems.Add(
        (Invoke-Expression ('$d.' + $columnProperties[$i])).ToString()) > $null
    }
    $item.Tag = $d
    $lv.Items.Add($item) > $null
  }

  # Added by Bar971.it
  for ($i = 0; $i -lt $columnTag.Count; $i++) {

    $lv.Columns[$i].Tag = $columnTag[$i]

  }
  # http://www.java2s.com/Code/CSharp/GUI-Windows-Form/SortaListViewbyAnyColumn.htm
  # http://www.java2s.com/Code/CSharp/GUI-Windows-Form/UseRadioButtontocontroltheListViewdisplaystyle.htm
  $comparerClassString = @'

  using System;
  using System.Windows.Forms;
  using System.Drawing;
  using System.Collections;

  public class ListViewItemComparer : System.Collections.IComparer
  {
    public int col = 0;

    public System.Windows.Forms.SortOrder Order; // = SortOrder.Ascending;

    public ListViewItemComparer()
    {
        col = 0;
    }

    public ListViewItemComparer(int column, bool asc)
    {
        col = column;
        if (asc)
        {Order = SortOrder.Ascending;}
        else
        {Order = SortOrder.Descending;}
    }

    public int Compare(object x, object y) // IComparer Member
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

                if (Order == SortOrder.Ascending)
                    {
                        return fl1.CompareTo(fl2);
                    }
                else
                    {
                        return fl2.CompareTo(fl1);
                    }
             }
         else
             {
                string str1 = l1.SubItems[col].Text;
                string str2 = l2.SubItems[col].Text;

                if (Order == SortOrder.Ascending)
                    {
                        return str1.CompareTo(str2);
                    }
                else
                    {
                        return str2.CompareTo(str1);
                    }
              }
    }
}
'@
  Add-Type -TypeDefinition $comparerClassString `
     -ReferencedAssemblies (`
       'System.Windows.Forms','System.Drawing')

  $bool = $true
  $columnClick =
  {
    $lv.ListViewItemSorter = new-object ListViewItemComparer ($_.Column,$bool)

    $bool = !$bool
  }
  $lv.Add_ColumnClick($columnClick)
  # End Add by Bar971.it

  # display it
  $form.Add_Shown({ $form.Activate() })
  if ($btns.Count -gt 0) {
    $form.AcceptButton = $btns[0]
  }
  $form.ShowDialog()
  # Determine if the OK button was clicked on the dialog box.
  if ($form1.DialogResult -eq [System.Windows.Forms.DialogResult]::OK){
    }
    
}

# origin: https://social.technet.microsoft.com/Forums/en-US/4bb0a29a-b923-4320-9f90-1a08fbfb9865/suspend_process-on-remote-machine?forum=winserverpowershell
# stripped remoting functionality discussion.

add-type -Name Threader -namespace '' -Member @'
   [Flags]
   public enum ThreadAccess : int
   {
      Terminate = (0x0001),
      SuspendResume = (0x0002),
      GetContext = (0x0008),
      SetContext = (0x0010),
      SetInformation = (0x0020),
      GetInformation = (0x0040),
      SetThreadToken = (0x0080),
      Impersonate = (0x0100),
      DirectImpersonation = (0x0200)
   }
   [Flags]
   public enum ProcessAccess : uint
   {
      Terminate = 0x00000001,
      CreateThread = 0x00000002,
      VMOperation = 0x00000008,
      VMRead = 0x00000010,
      VMWrite = 0x00000020,
      DupHandle = 0x00000040,
      SetInformation = 0x00000200,
      QueryInformation = 0x00000400,
      SuspendResume = 0x00000800,
      Synchronize = 0x00100000,
      All = 0x001F0FFF
   }

   [DllImport("ntdll.dll", EntryPoint = "NtSuspendProcess", SetLastError = true)]
   public static extern uint SuspendProcess(IntPtr processHandle);

   [DllImport("ntdll.dll", EntryPoint = "NtResumeProcess", SetLastError = true)]
   public static extern uint ResumeProcess(IntPtr processHandle);

   [DllImport("kernel32.dll")]
   public static extern IntPtr OpenProcess(ProcessAccess dwDesiredAccess, bool bInheritHandle, uint dwProcessId);

   [DllImport("kernel32.dll")]
   public static extern IntPtr OpenThread(ThreadAccess dwDesiredAccess, bool bInheritHandle, uint dwThreadId);

   [DllImport("kernel32.dll", SetLastError=true)]
   public static extern bool CloseHandle(IntPtr hObject);

   [DllImport("kernel32.dll")]
   public static extern uint SuspendThread(IntPtr hThread);

   [DllImport("kernel32.dll")]
   public static extern int ResumeThread(IntPtr hThread);
'@
# origin: https://social.technet.microsoft.com/Forums/en-US/4bb0a29a-b923-4320-9f90-1a08fbfb9865/suspend_process-on-remote-machine?forum=winserverpowershell
# stripped remoting functionality discussion.

function suspend_process_example2 {
param(
  #[Parameter(ValueFromPipeline=$true,Mandatory=$true)][System.Diagnostics.Process]$Process
  [Parameter(ValueFromPipeline = $false, Position = 0, Mandatory = $true)]$ProcessID,
  [Parameter(Position = 1)]
  [Switch]$resume,
  [Parameter(Position = 2)]
  [Switch]$verboseRun
  # https://stackoverflow.com/questions/10536282/powershell-defining-the-verbose-switch-in-a-function
  # explaining dangers of choosing a name 'Verbose' for a powershell function argument switch
  # NOTE: suspend_process_example2 : A parameter with the name 'Verbose' was defined multiple times for the command.
)
process {
  if ($verboseRun) {
    $popup = new-object -comobject wscript.shell
  }
  if(($pProc = [Threader]::OpenProcess('SuspendResume', $false, $ProcessID)) -ne [IntPtr]::Zero) {
    write-verbose "Suspending Process: ${pProc}"
    $result = [Threader]::SuspendProcess($pProc)
      switch ($resume) {
        $true  {
          $result = [Threader]::ResumeProcess($pProc)
        }
        $false {
          $result = [Threader]::SuspendProcess($pProc)
        }
      }
     if($result -ne 0) {
      # write-error "Failed to Suspend: $result"
      ## TODO: GetLastError()
      if ($verboseRun) {
        $popup.Popup("Failed to Suspend: ${result}",0,'Error',16)
      }
      # only relevant for console
      # exit
    }
   [Threader]::CloseHandle($pProc)

   } else {
      # write-error "Unable to open Process $($Process.Id), are you running elevated?"
      ## TODO: Check if they're elevated and otherwise GetLastError()
      if ($verboseRun) {
        $popup.Popup("No access to open Process ${ProcessID}, are you local administrator?",0,'Error',16)
      }
      # only relevant for console
      # exit
   }
}
}


function suspend_process {
  <#
    .EXAMPLE
        PS C:\> suspend_process 2008
    .EXAMPLE
        PS C:\> suspend_process 2008 -Resume
    .NOTES
        Author: greg zakharov
  #>
  param(
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
    [Int32]$ProcessId,

    [Parameter(Position = 1)]
    [Switch]$resume
  )
  # http://pinvoke.net/default.aspx/ntdll/NtSuspendProcess.html
  # http://www.developpez.net/forums/d397538/dotnet/langages/vb-net/vb-net-suspendre-process/

  begin {
    if (!(($cd = [AppDomain]::CurrentDomain).GetAssemblies() | ? {
      $_.FullName.Contains('Nt')
    })) {
      $attr = 'AnsiClass, Class, Public, Sealed, BeforeFieldInit'
      $type = (($cd.DefineDynamicAssembly(
        (new-object Reflection.AssemblyName('Nt')), 'Run'
      )).DefineDynamicModule('Nt', $false)).DefineType('Suspend', $attr)
      [void]$type.DefinePInvokeMethod('NtSuspendProcess', 'ntdll.dll',
        'Public, Static, PinvokeImpl', 'Standard', [Int32],
        @([IntPtr]), 'WinApi', 'Auto'
      )
      [void]$type.DefinePInvokeMethod('NtResumeProcess', 'ntdll.dll',
        'Public, Static, PinvokeImpl', 'Standard', [Int32],
        @([IntPtr]), 'WinApi', 'Auto'
      )
      Set-Variable Nt -Value $type.CreateType() -Option ReadOnly -Scope global
    }

    $OpenProcess = [RegEx].Assembly.GetType(
      'Microsoft.Win32.NativeMethods'
    ).GetMethod('OpenProcess') #returns SafeProcessHandle type

    $PROCESS_SUSPEND_RESUME = 0x00000800
  }
  process {
    try {
      $sph = $OpenProcess.Invoke($null, @($PROCESS_SUSPEND_RESUME, $false, $ProcessId))
      if ($sph.IsInvalid) {
        Write-Warning "process with specified ID does not exist: ${ProcessId}"
        return
      }
      $ptr = $sph.DangerousGetHandle()

      switch ($resume) {
        $true {
          [void]$Nt::NtResumeProcess($ptr)
        }
        $false {
          [void]$Nt::NtSuspendProcess($ptr)
        }
      }
    }
    catch { $_.Exception }
    finally {
      if ($sph -ne $null) { $sph.Close() }
    }
  }
  end {
    return 0;
  }
}
$debug = $false
<#
out-form -data (get-process) -columnNames ('Name','ID') -columnProperties ('Name','ID') -columnTag ('Text','Numeric') `
                 -actions @{'Suspend' = {suspend_process_example2 $_.Id}; 'resume' = {suspend_process_example2 $_.Id -resume}; }
#>
### TODO: does not behave like a windows form, quits after action
out-form -data (get-process) -columnNames ('Name','ID') -columnProperties ('Name','ID') -columnTag ('Text','Numeric') `
                 -actions @{'Suspend' = {suspend_process $_.Id; if ($debug ) { write-host 'Done suspend';}}; 'resume' = {suspend_process $_.Id -resume ; if ($debug ) {write-host 'Done resume';}}; }

## TODO: suspend MsMpEng.exe during interactive logon