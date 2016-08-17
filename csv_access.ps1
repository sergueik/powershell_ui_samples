#Copyright (c) 2016 Serguei Kouzmine
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


# http://www.codeproject.com/Articles/1118991/Work-with-Excel-Documents-on-the-Server
# http://poshcode.org/2887
# http://stackoverflow.com/questions/8343767/how-to-get-the-current-directory-of-the-cmdlet-being-executed
# https://msdn.microsoft.com/en-us/library/system.management.automation.invocationinfo.pscommandpath%28v=vs.85%29.aspx
# https://gist.github.com/glombard/1ae65c7c6dfd0a19848c
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


function initialize_data_reader {
  param(
    [string]$format = 'csv',
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

  Write-Output $datafile_directory
  switch ($format)
  {
    'excel' {
      [string]$oledb_provider = 'Provider=Microsoft.ACE.OLEDB.12.0'
      [string]$data_source = "Data Source = ${datafile_fullpath}"
      [string]$ext_arg = 'Extended Properties=Excel 8.0;IMEX=1;'
      [string]$table = $sheet_name
    }
    'csv' {
      [string]$oledb_provider = 'Provider=Microsoft.ACE.OLEDB.12.0'
      [string]$ext_arg = 'Extended Properties="Text;IMEX=2;HDR=Yes;FMT=Delimited(,)";'
      [string]$data_source = "Data Source = '${datafile_directory}'"
      [string]$table = $datafile_filename
    }
    default { throw }
  }
  $connection_string = "$oledb_provider;$data_source;$ext_arg"
  Write-Output $connection_string
  [string]$query = 'SELECT * FROM [' + $datafile_filename + ']'
  Write-Output $query

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


# https://msdn.microsoft.com/en-us/library/system.data.dataset%28v=vs.110%29.aspx

$datafile_filename = 'TestConfiguration.csv'
@"
x,y
1,2
3,4
"@ | Out-File ('{0}\{1}' -f (Get-ScriptDirectory),$datafile_filename) -Append -Encoding 'ASCII'

$command = New-Object System.Data.OleDb.OleDbCommand
$connection = New-Object System.Data.OleDb.OleDbConnection

$data_table = New-Object System.Data.DataTable

initialize_data_reader -datafile_filename $datafile_filename -connection_ref ([ref]$connection) -command_ref ([ref]$command) -data_table_ref ([ref]$data_table)

$SQL = 'SELECT * FROM [' + $datafile_filename + ']'
[System.Data.OleDb.OleDbCommand]$command = New-Object System.Data.OleDb.OleDbCommand ($SQL,$connection)
[System.Data.DataSet]$ds = New-Object System.Data.DataSet

[System.Data.DataTable]$local:data_table = New-Object System.Data.DataTable
[System.Data.OleDb.OleDbDataAdapter]$ole_db_adapter = New-Object System.Data.OleDb.OleDbDataAdapter ($command)

$ole_db_adapter.Fill($ds,'MyData') | Out-Null


Write-Output $ds.Tables.'x'[0]
Write-Output $ds.Tables.'x'[1]
