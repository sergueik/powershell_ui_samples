# Copyright (c) 2019,2020 Serguei Kouzmine
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# http://www.cyberforum.ru/powershell/thread2530957.html
# https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.combobox.selectedindexchanged?view=netframework-4.5
# see also: http://www.cyberforum.ru/powershell/thread2538578.html
# for custom C# FileBrowser see
# https://www.codeproject.com/Articles/10399/Explorer-ComboBox-and-ListView-in-VB-NET
# https://www.codeproject.com/Articles/2316/Windows-Explorer-in-C
# https://www.codeproject.com/Articles/2672/My-Explorer-In-C

# NOTE: when passing multiple itmes need quotes around the value:
# -preselected 'C:\Users\sergueik\Documents\b.csv,C:\Users\sergueik\Desktop\a.csv'
param(
  [String]$preselected = 'data.csv,dummy.csv',
  [switch]$debug
)

function select_file {
  param(
    [String]$title,
    [String]$preselected = '',
    [object]$caller
  )

  @( 'System.Drawing','System.Windows.Forms') | foreach-object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }
  $f = new-object System.Windows.Forms.Form
  $f.AutoScaleBaseSize = new-object System.Drawing.Size (5,13)
  $f.ClientSize = new-object System.Drawing.Size (538,158)
  $f.SuspendLayout()
  $l = new-object System.Windows.Forms.Label

  $f.SuspendLayout()
  $components = new-object System.ComponentModel.Container
  $l.Font = new-object System.Drawing.Font ('Verdana', 10.25, [System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,[System.Byte]0);
  $l.ForeColor = [System.Drawing.SystemColors]::Highlight
  $l.Location = new-object System.Drawing.Point (24,60)
  $l.Name = 'combobox_label'
  $l.Size = new-object System.Drawing.Size (120,16)
  $l.TabIndex = 0
  $l.Text = 'Select file'
  $l.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter


  $c = new-object System.Windows.Forms.ComboBox
  $c.DataSource = @()

  if ($preselected -ne '') {
    $c.DropDownStyle = 'DropDownList'
    $c.DataSource = ($preselected -split ',')
    $c.Text = $c.DataSource.item(0)
  }

  $c.Location = new-object System.Drawing.Point (145,60)
  $c.Name = 'comboBox'
  $c.Size = new-object System.Drawing.Size (320,20)
  $c.TabIndex = 0
  $c.Font = new-object System.Drawing.Font('Verdana',10.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)

  $c.Add_TextChanged({
    param(
      [object]$s,
      [System.EventArgs]$e
    )
    $result = $s.Text
    if ($debug) {
      write-host ('text changed {0}' -f $result )
    }
  })

  $c.Add_KeyPress({
    param(
      [object]$s,
      [System.Windows.Forms.KeyPressEventArgs]$e
    )
    if ($debug) {
      write-host ('key pressed {0}' -f $s.Text )
    } 
  })
  $c.Add_DropDown({
    param(
      [object]$s,
      [System.EventArgs]$e
    )
    # https://4sysops.com/archives/how-to-create-an-open-file-folder-dialog-box-with-powershell/

    # NOTE: a typo in Filter constructor property leads to nasty error with invalid line number
    # Filter = 'CSV (*.csv)|*.csv|SpreadSheet (*.xlsx)|*.xlsx|*.csv)'
    # new-object : The value supplied is not valid, or the property is read-only.
    # Change the value, and then try again.
    $FileBrowser = new-object System.Windows.Forms.OpenFileDialog -Property @{ 
      InitialDirectory = [Environment]::GetFolderPath('Desktop') 
      Filter = 'CSV Documents (*.csv)|*.csv|SpreadSheet (*.xlsx)|*.xlsx'
    }
    $null = $FileBrowser.ShowDialog()
    $selected_file = $FileBrowser.FileName 
    if ($selected_file -ne '') {
      if ($debug) {
        write-host ('Selected {0}' -f $selected_file )
      } 
      $c.DataSource += ($selected_file)
      $s.SelectedIndex = $c.DataSource.Count - 1
    }
  })
  $c.Add_SelectedIndexChanged({
    param(
      [object]$s,
      [System.EventArgs]$e
    )
    if ($c.DataSource.count -eq 0) {
    } else {
      if ($debug) {
        write-host ('index changed {0} {1}' -f $s.SelectedIndex, $s.Text )
      }
    }
  }) 

  $f.Controls.AddRange(@($l, $c))
  $f.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
  $f.MaximizeBox = $false
  $f.MinimizeBox = $false
  $f.Name = 'comboBoxDialog'
  $f.ResumeLayout($false)
  $f.Topmost = $true

  $f.Add_Shown({ 
    $caller.Data = $null
    $f.Activate()
  })
  # Clean up the control events
  $form_closed_handler = [System.Windows.Forms.FormClosedEventHandler]{
    # borrowed from snippet generated by SAPIEN Technologies, Inc., PowerShell Studio
    param(
      [Object]$sender,
      [EventArgs]$eventargs
    )
    try {
      $caller.Data = $c.SelectedItem
      # https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.combobox.selecteditem
      write-host ('Selected: {0}' -f $c.SelectedItem)
      if ($debug) {
        write-host 'remove all event handlers from the controls'
      }
      # Does one really need to fully specify the event handler code for the second time here? Appears so:
      # System.Management.Automation.PSInvalidCastException Cannot convert the 'System.EventHandler' value of type 'System.EventHandler' to type 'System.Windows.Forms.KeyPressEventHandler'.
      # NOTE: can not specidy a no arg constructor: $c.remove_TextChanged( (new-object -typename 'System.EventHandler') )
      # System.Management.Automation.PSArgumentException: A constructor was not found. Cannot find an appropriate constructor for type System.EventHandler.
      $c.Remove_TextChanged( [System.EventHandler]{})
      $c.Remove_KeyPress( [System.Windows.Forms.KeyPressEventHandler]{})
      $c.Remove_SelectedIndexChanged( [System.EventHandler]{} )
      if ($debug) {
        write-host 'remove self'
      }
      $f.remove_FormClosed($form_closed_handler)
      if ($debug) {
        write-host 'done.'
      }
    } catch [exception]{
      # slurp the exception - debug code omitted
      $message = "EXCEPTION: $($_.Exception.GetType().FullName)"
      write-host $message
      write-host (($_.Exception.Message) -split "`n")[0]
    }
  }
  $f.add_FormClosed($form_closed_handler)

  [void]$f.ShowDialog($null)
}

Add-Type -TypeDefinition @"
using System;
using System.Windows.Forms;
public class Win32Window : IWin32Window {
    private IntPtr _hWnd;
    private String _data;

    public String Data {
        get { return _data; }
        set { _data = value; }
    }

    public Win32Window(IntPtr handle) {
        _hWnd = handle;
    }

    public IntPtr Handle {
        get { return _hWnd; }
    }
}

"@ -ReferencedAssemblies 'System.Windows.Forms.dll'
$window_handle = [System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle
$caller = new-object Win32Window -ArgumentList ($window_handle)
select_file -title $title -preselected $preselected -caller $caller
[String]$datafile = $caller.Data
write-output  ('selected file: {0}' -f $datafile )
$rows = import-csv -header 'rows' -path $datafile 
$rows | select-object -expandproperty rows | format-list