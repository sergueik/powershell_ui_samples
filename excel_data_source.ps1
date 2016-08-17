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


# http://tech.pro/tutorial/803/csharp-tutorial-using-the-built-in-oledb-csv-parser
# http://www.codeproject.com/Articles/27802/Using-OleDb-to-Import-Text-Files-tab-CSV-custom
# http://www.cosmonautdreams.com/2013/09/06/Parse-Excel-Quickly-With-Powershell.html
# for single-column spreadsheets see also
# http://blogs.technet.com/b/heyscriptingguy/archive/2008/09/11/how-can-i-read-from-excel-without-using-excel.aspx

# 32-bit
# NOTE:  Microsoft.Jet.OLEDB.4.0 a.k.a. Deprecated MDAC/WDAC Components has 64Bit compatibility problem
# http://www.codicode.com/art/64_bit_version_of_microsoft_jet.aspx
# https://social.msdn.microsoft.com/Forums/en-US/d5b29496-d6a1-4ecf-b1a4-5550d80b84b6/microsoftjetoledb40-32bit-and-64bit?forum=adodotnetdataproviders

# 32 or 64 bit:
# Microsoft Access Database Engine 2010 Redistributable
# https://www.microsoft.com/en-us/download/details.aspx?id=13255
# choose AccessDatabaseEngine_X64.exe or AccessDatabaseEngine.exe 
# as appropriate for the target architecture
# http://www.codeproject.com/Articles/1118991/Work-with-Excel-Documents-on-the-Server


param(
  [string]$format = 'excel',
  [switch]$pause,
  [switch]$show
)

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
    $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf(''))
  }
}


function initialize_data_reader {
  param(
    [string]$format = 'excel',
    [string]$datafile_filename,
    [string]$sheet_name,
    [string]$query,
    [System.Management.Automation.PSReference]$connection_ref,
    [System.Management.Automation.PSReference]$command_ref,
    [System.Management.Automation.PSReference]$data_table_ref,
    [bool]$debug

  )

  [string]$datafile_directory = (Get-ScriptDirectory)
  [string]$datafile_fullpath = ('{0}\{1}' -f $datafile_directory,$datafile_filename)


  switch ($format)
  {
    'excel' {
      [string]$oledb_provider = 'Provider=Microsoft.ACE.OLEDB.12.0'
      # 32-bit instances only:
      # [string]$oledb_provider = 'Provider=Microsoft.Jet.OLEDB.4.0'
      [string]$data_source = "Data Source = ${datafile_fullpath}"
      [string]$ext_arg = 'Extended Properties=Excel 8.0;IMEX=1;'
      [string]$table = $sheet_name
    }
    'csv' {
      [string]$oledb_provider = 'Provider=Microsoft.ACE.OLEDB.12.0'
      # 32-bit instances only:
      # [string]$oledb_provider = 'Provider=Microsoft.Jet.OLEDB.4.0'
      [string]$ext_arg = 'Extended Properties="Text;IMEX=1;HDR=Yes;FMT=Delimited(,)";'
      [string]$data_source = "Data Source = ${$datafile_directory}"
      [string]$table = $datafile_filename
    }
    default { throw }
  }
  $connection_string = "$oledb_provider;$data_source;$ext_arg"
  [string]$query = "Select * from [${table}] WHERE ISNULL(guid)"

  [System.Data.OleDb.OleDbConnection]$local:connection = New-Object System.Data.OleDb.OleDbConnection ($connection_string)
  [System.Data.OleDb.OleDbCommand]$local:command = New-Object System.Data.OleDb.OleDbCommand ($query)


  [System.Data.DataTable]$local:data_table = New-Object System.Data.DataTable
  [System.Data.OleDb.OleDbDataAdapter]$ole_db_adapter = New-Object System.Data.OleDb.OleDbDataAdapter
  $ole_db_adapter.SelectCommand = $local:command

  $local:command.Connection = $connection

  [void]$ole_db_adapter.Fill($local:data_table)
  $local:connection.open()
  # http://stackoverflow.com/questions/24648081/error-the-type-system-data-oledb-oledbdatareader-has-no-constructors-defined
  $global:data_reader = $local:command.ExecuteReader()
  $data_table_ref.Value = $local:data_table
  $connection_ref.Value = $local:connection
  $command_ref.Value = $local:command
  return $local:data_reader
}

function insert_row_new {
  param(
    [string]$sql,
    # [ref]$connection does not work here
    # [System.Management.Automation.PSReference]$connection_ref,
    [System.Data.OleDb.OleDbConnection]$connection,
    [System.Collections.Hashtable]$new_row_data

  )

  [string[]]$columns = [string[]]($row_data.Keys)

  [System.Data.OleDb.OleDbCommand]$local:command = New-Object System.Data.OleDb.OleDbCommand
  $local:command.Connection = $connection

  $local:insert_name_part = @()
  $local:insert_value_part = @()

  $columns | ForEach-Object {
    $column_name = $_
    $column_data = $new_row_data[$column_name]
    $local:command.Parameters.Add(('@{0}' -f $column_name),$column_data['type']).Value = $column_data['value']
    Write-Output ('@{0} = {1}' -f $column_name,$column_data['value'])
    $local:insert_name_part += ('[{0}]' -f $column_name)
    $local:insert_value_part += ('@{0}' -f $column_name)
  }

  $local:generated_sql = (($sql -replace '@insert_name_part',($local:insert_name_part -join ',')) -replace '@insert_value_part',($local:insert_value_part -join ','))

  Write-Output ('Insert query: {0}' -f $local:generated_sql)

  $new_row_data.Keys | ForEach-Object {
    $column_name = $_
    $column_data = $new_row_data[$column_name]
    Write-Output ('@{0} = {1}' -f $column_name,$column_data['value'])
  }
  $local:command.CommandText = $local:generated_sql

  $local:result = $local:command.ExecuteNonQuery()

  Write-Output ('Insert result: {0}' -f $local:result)

  $local:command.Dispose()

  return $local:result

}


function update_single_field {
  param(
    [string]$sql,
    # [ref]$connection does not seem to work here
    # [System.Management.Automation.PSReference]$connection_ref,
    [System.Data.OleDb.OleDbConnection]$connection,
    [string]$where_column_name,
    [object]$where_column_value,
    [string]$update_column_name,
    [object]$update_column_value,
    [System.Management.Automation.PSReference]$update_column_type_ref = ([ref][System.Data.OleDb.OleDbType]::VarChar),
    [System.Management.Automation.PSReference]$where_column_type_ref = ([ref][System.Data.OleDb.OleDbType]::Decimal)
  )

  [System.Data.OleDb.OleDbCommand]$local:command = New-Object System.Data.OleDb.OleDbCommand
  $local:command.Connection = $connection

  $local:command.Parameters.Add($update_column_name,$update_column_type_ref.Value).Value = $update_column_value
  $local:command.Parameters.Add($where_column_name,$where_column_type_ref.Value).Value = $where_column_value
  $local:command.CommandText = $sql

  # TODO: Exception calling "Prepare" with "0" argument(s): "OleDbCommand.Prepare method requires all variable length parameters to have an explicitly set non-zero Size."
  # $command.Prepare()

  $local:result = $local:command.ExecuteNonQuery()
  Write-Output ('prepare: {0}' -f $sql)
  Write-Output ('where column SQL: {0}' -f $where_column_name)
  Write-Output ('update column: {0}' -f $update_column_name)
  Write-Output ('Update query: {0}' -f (($sql -replace $update_column_name,$update_column_value) -replace $where_column_name,$where_column_value))
  Write-Output ('Update result: {0}' -f $local:result)

  $local:command.Dispose()

  return $local:result

}



$datafile_filename = 'TestConfiguration.xls'

$command = New-Object System.Data.OleDb.OleDbCommand
$connection = New-Object System.Data.OleDb.OleDbConnection

$sheet_name = 'TestConfiguration$'
$data_table = New-Object System.Data.DataTable

initialize_data_reader -datafile_filename $datafile_filename -sheet_name $sheet_name -connection_ref ([ref]$connection) -command_ref ([ref]$command) -data_table_ref ([ref]$data_table)

$row_num = 1
[System.Data.DataRow]$data_record = $null
foreach ($data_record in $data_table) {

  # Reading the columns of the current row
  Write-Host ("row:{0}" -f $row_num)
  $row_data = @{
    'id' = $null;
    'server' = $null;
    'date' = $null;
    'done' = $null;
    'route' = $null;
    'booking_url' = $null;
    'port' = $null;
    'destination' = $null;
    'guid' = $null;
  }

  [string[]]($row_data.Keys) | ForEach-Object {
    $cell_name = $_
    $cell_value = $data_record."${cell_name}"
    $row_data[$cell_name] = $cell_value
  }
  Write-Output ("row:{0}" -f $row)

  $row_data | Format-Table -AutoSize
  Write-Output "`n"
  $row_num++
}

$global:data_reader.close()
$target_record_id = 7

$new_guid = ([guid]::NewGuid()).ToString()
Write-Output ('Setting guild to {0} for id = {1}' -f $new_guid,$target_record_id)

update_single_field `
   -connection $connection `
   -sql "UPDATE [${sheet_name}] SET [guid] = @guid WHERE [id] = @id" `
   -update_column_name '@guid' `
   -update_column_value $new_guid `
   -where_column_name '@id' `
   -where_column_value $target_record_id

update_single_field `
   -connection $connection `
   -sql "UPDATE [${sheet_name}] SET [booking_url] = @booking_url WHERE [guid] = @guid" `
   -update_column_name '@booking_url' `
   -update_column_value 'http://www.carnival.com/itinerary/2-day-baja-mexico-cruise/los-angeles/imagination/2-days/la0/?numGuests=2&destination=all-destinations&dest=any&datFrom=032015&datTo=042017' `
   -where_column_name '@guid' `
   -where_column_type_ref ([ref][System.Data.OleDb.OleDbType]::VarChar) `
   -where_column_value $new_guid

# TODO : multiple columns
# $sql = "Insert into [${sheet_name}] ([id],[server],[status],[result],[date],[guid]) values($new_record_id, 'sergueik9','True',42,'3/8/2015 4:00:00 PM', '${new_guid}')"
# $command.CommandText = $sql
# $result = $command.ExecuteNonQuery()

update_single_field `
   -connection $connection `
   -sql "UPDATE [${sheet_name}] SET [done] = @done WHERE [guid] = @guid" `
   -update_column_name "@done" `
   -update_column_value $true `
   -update_column_type_ref ([ref][System.Data.OleDb.OleDbType]::Boolean) `
   -where_column_name '@guid' `
   -where_column_type_ref ([ref][System.Data.OleDb.OleDbType]::VarChar) `
   -where_column_value $new_guid

$destinations_ports = @{ 'Miami, FL' = @( 'Caribean','Bermuda'); }
return
# cartesian products


$row_num = 14
$new_row_data = @{
  'id' = @{
    'value' = $row_num;
    'type' = [System.Data.OleDb.OleDbType]::Numeric;
  };
  'date' = @{
    'value' = '3/8/2015 4:00:00 PM';
    'type' = [System.Data.OleDb.OleDbType]::VarChar;
  };
  'result' = @{
    'value' = 456;
    'type' = [System.Data.OleDb.OleDbType]::Numeric;
  };
  'status' = @{
    'value' = $true;
    'type' = [System.Data.OleDb.OleDbType]::Boolean;
  };

  'guid' = @{
    'value' = ([guid]::NewGuid()).ToString();
    'type' = [System.Data.OleDb.OleDbType]::VarChar;
  };

  'server' = @{
    'value' = 'sergueik43';
    'type' = [System.Data.OleDb.OleDbType]::VarChar;
  };

}
# Exception calling "ExecuteNonQuery" with "0" argument(s): "Invalid bracketing of name '[]'."
insert_row_new `
   -connection $connection `
   -sql "Insert into [${sheet_name}] (@insert_name_part) values (@insert_value_part)" `
   -new_row_data $new_row_data


$new_row_data['id']['value']++

insert_row_new `
   -connection $connection `
   -sql "Insert into [${sheet_name}] (@insert_name_part) values (@insert_value_part)" `
   -new_row_data $new_row_data

$command.Dispose()

$connection.close()
<#
# If Office is present on the computer the following may be tested.
$com_object=New-Object -ComObject Excel.Application
$com_object.Visible=$false
$workbook=$com_object.Workbooks.Open($datafile_filename)
$sheet_name = 'ServerList$'
$worksheet = $workbook.sheets.item($sheet_name)
$rows_count =  ($worksheet.UsedRange.Rows).count
$col_num = 1

for($row_num = 2 ; $row_num -le $rows_count ; $row_num++)
{
  $worksheet.cells.item($row_num,$col_num).value2 | out-null
   }
$com_object.quit()

#>

<#

using System;
using System.Data;
using System.IO;
using System.Data.OleDb;
public class Excel_Data
{

    public static void Main(string[] args)
    {
        ImportCsvFile(args[0]);
    }

    public static void ImportCsvFile(string filename)
    {
        FileInfo file = new FileInfo(filename);
        String x = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=\"" +
                file.DirectoryName + "\";" +
                "Extended Properties='text;HDR=Yes;FMT=Delimited(,)';";
        Console.WriteLine(x);
        using (OleDbConnection con =
               new OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=\"" +
               file.DirectoryName + "\";" +
               "Extended Properties='text;HDR=Yes;FMT=Delimited(,)';"))
        {
            using (OleDbCommand cmd = new OleDbCommand(string.Format
                                      ("SELECT * FROM [{0}]", file.Name), con))
            {
                con.Open();

                // Using a DataReader to process the data
                using (OleDbDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        // Process the current reader entry...
                    }
                }

                // Using a DataTable to process the data
                using (OleDbDataAdapter adp = new OleDbDataAdapter(cmd))
                {
                    DataTable tbl = new DataTable("MyTable");
                    adp.Fill(tbl);

                    foreach (DataRow row in tbl.Rows)
                    {
                        // Process the current row...
                    }
                }
            }
        }
    }
}
#>
