#Copyright (c) 2020 Serguei Kouzmine
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

# based on:
# https://docs.microsoft.com/en-us/dotnet/framework/winforms/controls/selected-cells-rows-and-columns-datagridview
# effectively just converted to Powershell
param(
  [switch]$debug
)
function PromptGrid {
  param(
    [System.Collections.IList]$data,
    [System.Data.DataSet]$dataset,
    [System.Data.Datatable]$datatable
  )

  # https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.datagrid?view=netframework-4.5
  $f = new-object System.Windows.Forms.Form
  $f.Text = 'Action on GridView Selections'
  $f.AutoSize = $true
  $grid = new-object System.Windows.Forms.DataGridView
  # NOTE: `PreferredColumnWidth` is not a property of `DataGridView` type
  # $grid.PreferredColumnWidth = 100

  $System_Drawing_Size = new-object System.Drawing.Size
  $grid.DataBindings.DefaultDataSourceUpdateMode = 0
  # NOTE: `HeaderForeColor` not a property of `DataGridView` type
  # $grid.HeaderForeColor = [System.Drawing.Color]::FromArgb(255,0,0,0)

  $grid.Name = 'dataGridView'
  # two common selection modes for by cell and by-row
  # $grid.SelectionMode = [System.Windows.Forms.DataGridViewSelectionMode]::RowHeaderSelect
  $grid.SelectionMode = [System.Windows.Forms.DataGridViewSelectionMode]::FullRowSelect
  $grid.DataMember = ''
  $grid.TabIndex = 0
  $System_Drawing_Point = new-object System.Drawing.Point
  $System_Drawing_Point.X = 13;
  $System_Drawing_Point.Y = 48;
  $grid.Location = $System_Drawing_Point
  $grid.Dock = [System.Windows.Forms.DockStyle]::Fill

  $button = new-object System.Windows.Forms.Button
  $button.Text = 'Deal'
  $button.Dock = [System.Windows.Forms.DockStyle]::Bottom

  $f.Controls.Add($button)
  $f.Controls.Add($grid)

  # http://msdn.microsoft.com/en-us/library/system.windows.forms.datagridviewrow.cells%28v=vs.110%29.aspx
  # https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.datagrid.datasource?view=netframework-4.5
  $button.add_click({
    $cells = @()
    $rows = @()
    # walk over selected cells
    $selected_cells_count = $grid.GetCellCount([System.Windows.Forms.DataGridViewElementStates]::Selected)

    #  https://docs.microsoft.com/en-us/dotnet/framework/winforms/controls/selected-cells-rows-and-columns-datagridview
    if ($selected_cells_count -gt 0) {
      if ($grid.AreAllCellsSelected($true)){
        write-host 'All cells are selected'
        # to simplify extraction
      } else  {
        0..($selected_cells_count - 1) | foreach-object {
          $cell_num = $_
          if ($debug) {
            write-host ('Selected cell {0} row: {1} col: {2}' -f $cell_num, ($grid.SelectedCells[$cell_num].RowIndex.ToString()), ($grid.SelectedCells[$cell_num].ColumnIndex.ToString()))
          }
        }
      }
      if ($debug) {
        write-host ('Total selected cells: {0}' -f $selected_cells_count.ToString())
      }
    } else {
      if ($debug) {
        write-host 'Nothing selected'
      }
    }

    # iterate over selected rows
    [int]$selected_rows_count = $grid.Rows.GetRowCount([System.Windows.Forms.DataGridViewElementStates]::Selected)
    if ($selected_rows_count -gt 0) {
      0..($selected_rows_count -1) | foreach-object {
        $row_num = $_
        $row_index = 0 + $grid.SelectedRows[$row_num].Index.ToString()
        if ($debug) {
          write-host ('Row: {0} Index: {0} ' -f $row_num, $row_index)
        }
        $rows += $row_index
      }
      if ($debug) {
        write-host ('Total selected rows: {0} ' -f $selected_rows_count.ToString())
      }
    } else {
      if ($debug) {
        write-host 'Nothing selected'
      }
    }
    # https://docs.microsoft.com/en-us/dotnet/framework/winforms/controls/selected-cells-rows-and-columns-datagridview
    if ($rows.count -gt 0) {
      $caller.Data = $rows.count;
      $caller.Message = ''
      $rows | foreach-object {
        $row_num = $_
        $row = $datatable.Rows[$row_num]
        if ($debug) {
          write-host $value | format-list
        }
        $caller.Message += ("{0} {1}`n" -f $row['First'], $row['Second'] )
      }
      }
      $f.Close()
    })
  $grid.DataSource = $datatable
  $f.ShowDialog([win32window]($caller)) | Out-Null

  $f.Topmost = $True


  $f.Refresh()

}

# collect stuff down from callbacks

Add-Type -TypeDefinition @"
using System;
using System.Windows.Forms;
public class Win32Window : IWin32Window
{
  private IntPtr _hWnd;
  private int _data;
  private string _message;

  public int Data{
    get { return _data; }
    set { _data = value; }
  }
  public string Message {
    get { return _message; }
    set { _message = value; }
  }

  public Win32Window(IntPtr handle){
    _hWnd = handle;
  }

  public IntPtr Handle {
    get { return _hWnd; }
  }
}

"@ -ReferencedAssemblies 'System.Windows.Forms.dll'

$DebugPreference = 'Continue'
@( 'System.Windows.Forms', 'System.ComponentModel', 'System.Data', 'System.Drawing') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }
$caller = new-object Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)

$datatable = New-Object System.Data.Datatable
[void]$datatable.Columns.Add('First')
[void]$datatable.Columns.Add('Second')
[void]$datatable.Columns.Add('Third')

# Add a row manually
[void]$datatable.Rows.Add('wind','blows','...')
[void]$datatable.Rows.Add('fire','burns','...')
[void]$datatable.Rows.Add('rain','falls','...')
[void]$datatable.Rows.Add('thunder','strucks','...')

$ret = PromptGrid -datatable $datatable
# -data $array

write-output $caller.Message
