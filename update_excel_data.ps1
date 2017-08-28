# See also: 
# https://www.codeproject.com/Articles/670082/Use-Excel-in-PowerShell-without-a-full-version-of
# http://sqlmag.com/powershell/update-excel-spreadsheets-powershell
# http://csharp.net-informations.com/excel/csharp-excel-oledb-update.htm
# https://www.codeproject.com/Questions/263951/How-to-Add-RowNumber-as-a-column-while-reading-dat
# https://msdn.microsoft.com/en-us/library/system.data.oledb.oledbcommand(v=vs.110).aspx

# Prerequisite: 
# Microsoft Access Database Engine 2010 Redistributable
# download: https://www.microsoft.com/en-us/download/details.aspx?id=13255
# 2007 Office System Driver: Data Connectivity Components
# Download: https://www.microsoft.com/en-us/download/confirmation.aspx?id=23734

$data_file_fullpath = "${env:USERPROFILE}\Downloads\TestCase.xslx"
$oledb_provider = 'Provider=Microsoft.ACE.OLEDB.12.0'
# 32-bit instances only, included with core image for Windows XP, Server 2013
# $oledb_provider = 'Provider=Microsoft.Jet.OLEDB.4.0'
$data_source = "Data Source = ${data_file_fullpath};"
$ext_arg = 'Extended Properties=Excel 8.0;HDR=NO;IMEX=1;'
# $ext_arg = 'Extended Properties=Excel 12.0 Xml;HDR=YES'
$sheet_name = 'KeywordFramework$'

$connection_string = "$oledb_provider;$data_source;$ext_arg"
$connection = New-Object System.Data.OleDb.OleDbConnection ($connection_string)
$colum = 'Object'
$value = 'none'
$ref_column = 'Keyword'
$ref_value = 'GOTOURL'
$query = "Update [${sheet_name}] set ${column} = '${value}' where ${ref_column}='${ref_value}'"
# https://social.technet.microsoft.com/Forums/office/en-US/b7d56e33-fc34-4982-82aa-b780b8c84d57/powershell-oledb-and-excel?forum=winserverpowershell
# $query = "INSERT INTO [Sheet3$A2:A2] VALUES ('TestValue1'); "
# $query = "UPDATE [MBS$A2:A3] SET F1='Answer', F2='42'"
# automatic naming of columns (F1, F2, F3,...) has nothing to do with the Excel cells F1, F2, F3. 
# F1 is just the first cell in the query destination range
$command = New-Object System.Data.OleDb.OleDbCommand ($query)
try {
  $connection.open()
} catch [exception]{
  # https://social.technet.microsoft.com/Forums/windowsserver/en-US/267d9dd2-e1c7-41e3-84ba-8a9146560df6/reading-an-xlsx-file?forum=winserverpowershell
  Write-Output ("Exception: {0}" -f $_.Exception.Message)
  # Exception calling "Open" with "0" argument(s): "Could not find installableISAM."
}

$command.Connection = $connection

$command.CommandText = $query
$command.ExecuteNonQuery()
$command.Dispose()
$connection.Close()
