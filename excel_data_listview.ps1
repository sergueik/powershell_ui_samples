#Copyright (c) 2014, 2015, 2016 Serguei Kouzmine
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
  [switch]$show,
  [switch]$debug
)

# http://ideone.com/HFiIa7
# http://www.cosmonautdreams.com/2013/09/06/Parse-Excel-Quickly-With-Powershell.html
# for singlee column spreadsheets see also
# http://blogs.technet.com/b/heyscriptingguy/archive/2008/09/11/how-can-i-read-from-excel-without-using-excel.aspx
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

function PromptListView
{
  param(
    [System.Collections.IList]$data_rows,
    [string[]]$column_names = $null,
    [string[]]$column_tags,
    [bool]$debug
  )
  @( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }

  $numCols = $column_names.Count

  # figure out form width
  $width = $numCols * 120

  $title = 'Select process'
  $f = New-Object System.Windows.Forms.Form
  $f.Text = $title
  $f.Size = New-Object System.Drawing.Size ($width,400)
  $f.StartPosition = 'CenterScreen'

  $f.KeyPreview = $true

  $select_button = New-Object System.Windows.Forms.Button
  $select_button.Location = New-Object System.Drawing.Size (10,10)
  $select_button.Size = New-Object System.Drawing.Size (70,23)
  $select_button.Text = 'Select'
  $select_button.add_click({
      # TODO: implementation
      # select_sailing ($script:Item)
    })

  $button_panel = New-Object System.Windows.Forms.Panel
  $button_panel.Height = 40
  $button_panel.Dock = 'Bottom'
  $button_panel.Controls.AddRange(@( $select_button))


  $panel = New-Object System.Windows.Forms.Panel
  $panel.Dock = 'Fill'
  $f.Controls.Add($panel)
  $list_view = New-Object windows.forms.ListView
  $panel.Controls.AddRange(@( $list_view,$button_panel))


  # create the columns
  $list_view.View = [System.Windows.Forms.View]'Details'
  $list_view.Size = New-Object System.Drawing.Size ($width,350)
  $list_view.FullRowSelect = $true
  $list_view.GridLines = $true
  $list_view.Dock = 'Fill'
  foreach ($col in $column_names) {
    [void]$list_view.Columns.Add($col,100)
  }

  # populate the view
  foreach ($data_row in $data_rows) {
    # NOTE: special processing of first column
    $cell = (Invoke-Expression (('$data_row.{0}' -f $column_names[0]))).ToString()
    $item = New-Object System.Windows.Forms.ListViewItem ($cell)
    for ($i = 1; $i -lt $column_names.Count; $i++) {
      $cell = (Invoke-Expression ('$data_row.{0}' -f $column_names[$i]))

      if ($cell -eq $null) {
        $cell = ''
      }
      [void]$item.SubItems.Add($cell.ToString())
    }
    $item.Tag = $data_row
    [void]$list_view.Items.Add($item)
  }
  <#
  $list_view.add_ItemActivate({
      param(
        [object]$sender,[System.EventArgs]$e)

      [System.Windows.Forms.ListView]$lw = [System.Windows.Forms.ListView]$sender
      [string]$filename = $lw.SelectedItems[0].Tag.ToString()
    })
  #>

  # store the selected item id
  $list_view.add_ItemSelectionChanged({
      param(
        [object]$sender,[System.Windows.Forms.ListViewItemSelectionChangedEventArgs]$e)

      [System.Windows.Forms.ListView]$lw = [System.Windows.Forms.ListView]$sender
      [int]$process_id = 0
      [int32]::TryParse(($e.Item.SubItems[0]).Text,([ref]$process_id))
      $script:Item = $process_id
      # write-host ( '-> {0}' -f $script:Item )
    })

  # tags for sorting
  for ($i = 0; $i -lt $column_tags.Count; $i++) {
    $list_view.Columns[$i].Tag = $column_tags[$i]
  }

  # http://poshcode.org/5635
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
        }
        else
        {
            string str1 = l1.SubItems[col].Text;
            string str2 = l2.SubItems[col].Text;
            return (Order == SortOrder.Ascending) ? str1.CompareTo(str2) : str2.CompareTo(str1);
        }

    }
}
"@ -ReferencedAssemblies 'System.Windows.Forms','System.Drawing'
  $list_view.Add_ColumnClick({
      $list_view.ListViewItemSorter = New-Object ListViewItemComparer ($_.Column,$script:IsAscending)
      $script:IsAscending = !$script:IsAscending
    })
  $script:Item = 0
  $script:IsAscending = $false
  $f.Topmost = $True
  $script:IsAscending = $false
  $f.Add_Shown({ $f.Activate() })
  $x = $f.ShowDialog()
}

function display_result {
  param([object[]]$result)
  $column_names = @(
    'id',
    'dest',
    'port',
    'state',
    'title',
    'link'
  )
  $column_tags = @(
    'Numeric',
    'Text',
    'Text',
    'Text',
    'Text',
    'Text'

  )
  $data_rows = New-Object System.Collections.ArrayList
  foreach ($row_data in $result) {
    $o = New-Object PSObject
    foreach ($row_data_key in $column_names) {
      $row_data_value = $row_data[$row_data_key]
      $o | Add-Member Noteproperty $row_data_key $row_data_value
    }
    [void]$data_rows.Add($o)
  }

  [void](PromptListView -data_rows $data_rows -column_names $column_names -column_tags $column_tags)
}


$data_name = 'Sailings.xls'
[string]$filename = ('{0}\{1}' -f (Get-ScriptDirectory),$data_name)

$sheet_name = 'Sailings$'
[string]$oledb_provider = 'Provider=Microsoft.ACE.OLEDB.12.0'
# 32-bit instances only, included with core image for Windows XP, Server 2013
# [string]$oledb_provider = 'Provider=Microsoft.Jet.OLEDB.4.0'

$data_source = ('Data Source = {0}' -f $filename)
$ext_arg = 'Extended Properties=Excel 8.0'
# TODO: sample queries
[string]$query = "Select * from [${sheet_name}] where [id] <> 0"
[System.Data.OleDb.OleDbConnection]$connection = New-Object System.Data.OleDb.OleDbConnection ("$oledb_provider;$data_source;$ext_arg")
[System.Data.OleDb.OleDbCommand]$command = New-Object System.Data.OleDb.OleDbCommand ($query)


[System.Data.DataTable]$data_table = New-Object System.Data.DataTable
[System.Data.OleDb.OleDbDataAdapter]$ole_db_adapter = New-Object System.Data.OleDb.OleDbDataAdapter
$ole_db_adapter.SelectCommand = $command

$command.Connection = $connection
($rows = $ole_db_adapter.Fill($data_table)) | Out-Null
$connection.open()
$data_reader = $command.ExecuteReader()
$plain_data = @()
$row_num = 1
[System.Data.DataRow]$data_record = $null
if ($data_table -eq $null) {}
else {

  foreach ($data_record in $data_table) {
    $data_record | Out-Null
    # Reading the columns of the current row

    $row_data = @{
      'id' = $null;
      'dest' = $null;
      'state' = $null;
      'port' = $null;
      'title' = $null;
      'link' = $null;
    }

    [string[]]($row_data.Keys) | ForEach-Object {
      $cell_name = $_
      $row_data[$cell_name] = $data_record."${cell_name}"
    }
    if (-not [bool]$PSBoundParameters['show'].IsPresent) {
      Write-Output ("row[{0}]" -f $row_num)
      $row_data | Format-Table -AutoSize
      Write-Output "`n"
    }
    $plain_data += $row_data
    $row_num++
  }
}

$data_reader.Close()
$command.Dispose()
$connection.Close()
if ([bool]$PSBoundParameters['show'].IsPresent) {
  # $plain_data | Sort-Object -Property 'Id' | Out-GridView
  # $plain_data does not have the correct schema for Out-GridView

  $DebugPreference = 'Continue'
  display_result $plain_data

}
