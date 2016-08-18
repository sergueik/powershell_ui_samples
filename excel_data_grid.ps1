#Copyright (c) 2015,2016 Serguei Kouzmine
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

# 
# http://www.codeproject.com/Articles/37055/Working-with-MS-Excel-xls-xlsx-Using-MDAC-and-Oled
# dependency: Microsoft Access Database Engine 2010 Redistributable
# https://www.microsoft.com/en-us/download/details.aspx?id=13255
# install AccessDatabaseEngine_X64.exe or AccessDatabaseEngine.exe 

param(
  [switch]$show,
  [switch]$debug
)


$RESULT_OK = 0
$RESULT_CANCEL = 2
$Readable = @{
  $RESULT_OK = 'OK'
  $RESULT_CANCEL = 'CANCEL'
}


# http://www.cosmonautdreams.com/2013/09/06/Parse-Excel-Quickly-With-Powershell.html
# for singlee column spreadsheets see also
# http://blogs.technet.com/b/heyscriptingguy/archive/2008/09/11/how-can-i-read-from-excel-without-using-excel.aspx

# http://stackoverflow.com/questions/8343767/how-to-get-the-current-directory-of-the-cmdlet-being-executed
function Get-ScriptDirectory
{
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  if ($Invocation.PSScriptRoot) {
    $Invocation.PSScriptRoot
  }
  elseif ($Invocation.MyCommand.Path) {
    Split-Path $Invocation.MyCommand.Path
  } else {
    $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf(""))
  }
}


function PromptGrid (
  [System.Collections.IList]$data,
  [object]$caller = $null
) {

  @( 'System.Drawing','System.Windows.Forms','System.ComponentModel','System.Data') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }
  
  $f = New-Object System.Windows.Forms.Form
  $f.Text = 'Test suite'
  $f.AutoSize = $true
  $grid = New-Object System.Windows.Forms.DataGrid
  $grid.PreferredColumnWidth = 100

  $System_Drawing_Size = New-Object System.Drawing.Size
  $grid.DataBindings.DefaultDataSourceUpdateMode = 0
  $grid.HeaderForeColor = [System.Drawing.Color]::FromArgb(255,0,0,0)

  $grid.Name = 'dataGrid1'
  $grid.DataMember = ''
  $grid.TabIndex = 0
  $System_Drawing_Point = New-Object System.Drawing.Point
  $System_Drawing_Point.X = 13;
  $System_Drawing_Point.Y = 48;
  $grid.Location = $System_Drawing_Point
  $grid.Dock = [System.Windows.Forms.DockStyle]::Fill

  # TODO : To sort items in a DataGrid https://msdn.microsoft.com/en-us/library/dd833072%28v=vs.95%29.aspx
  $button = New-Object System.Windows.Forms.Button
  $button.Text = 'Open'
  $button.Dock = [System.Windows.Forms.DockStyle]::Bottom

  $f.Controls.Add($button)
  $f.Controls.Add($grid)
  $button.add_click({
      param(
        [object]$sender,
        [System.EventArgs]$eventargs
      )
      # http://msdn.microsoft.com/en-us/library/system.windows.forms.datagridviewrow.cells%28v=vs.110%29.aspx
      # TODO:
      # [System.Windows.Forms.DataGridViewSelectedRowCollection]$rows = $grid.SelectedRows
      # [System.Windows.Forms.DataGridViewRow]$row = $null 
      # [System.Windows.Forms.DataGridViewSelectedCellCollection] $selected_cells = $grid.SelectedCells; 
      $script:Data = 0
      $script:Status = $RESULT_CANCEL
      # $last_row = ($grid.Rows.Count)
      $last_row = $data.Count
      for ($counter = 0; $counter -lt $last_row; $counter++) {
        if ($grid.IsSelected($counter)) {
          $row = $data[$counter]
          $script:Data = $row.Guid
          $script:Status = $RESULT_OK
        }
      }
      $f.Close()

    })

  $grid.DataSource = $data
  $f.ShowDialog() | Out-Null
  $f.Topmost = $True
  $f.Refresh()

}

function display_result {
  param([object[]]$result)
  $script:Data = 0
  $array = New-Object System.Collections.ArrayList
  foreach ($row_data in $result) {
    $o = New-Object PSObject
    foreach ($row_data_key in $row_data.Keys) {
      $row_data_value = $row_data[$row_data_key]

      $o | Add-Member Noteproperty $row_data_key $row_data_value
    }
    [void]$array.Add($o)
  }

  [void](PromptGrid $array $process_window)
  if ($script:Status -eq $RESULT_OK) {
    Write-Output @( 'Rerun ->',$script:Data)
  }
}


$data_name = 'Servers.xls'
[string]$filename = ('{0}\{1}' -f (Get-ScriptDirectory),$data_name)

$sheet_name = 'ServerList$'


[string]$oledb_provider = 'Provider=Microsoft.ACE.OLEDB.12.0'
# 32-bit instances only, included with core image for Windows XP, Server 2013
# [string]$oledb_provider = 'Provider=Microsoft.Jet.OLEDB.4.0'

$data_source = ('Data Source = {0}' -f $filename )
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
      'baseUrl' = $null;
      'status' = $null;
      'date' = $null;
      'result' = $null;
      'guid' = $null;
      'environment' = $null;
      'testName' = $null;

    }

    [string[]]($row_data.Keys) | ForEach-Object {
      # An error occurred while enumerating through a collection: Collection was
      # modified; enumeration operation may not execute..
      $cell_name = $_
      $cell_value = $data_record."${cell_name}"
      $row_data[$cell_name] = $cell_value

<#    foreach ($myPsObject in $psObject) {
      $myPsObject | Get-Member -MemberType *Property | % {
        $output.($_.Name) = $myPsObject.($_.Name);
      }
      $output;
    }

#>
    }
    if (-not [bool]$PSBoundParameters["show"].IsPresent) {
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
if ([bool]$PSBoundParameters["show"].IsPresent) {
  # $plain_data | Sort-Object -Property 'Id' | Out-GridView
  # $plain_data does not have the correct schema for Out-GridView

  $DebugPreference = 'Continue'
  display_result $plain_data

}
