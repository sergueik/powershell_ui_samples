# export Excel data as CSV in the environment 
# where the Microsoft Office 12.0 Access Database Engine OLE DB Provider from Microsoft fails to register 
# but the Office is available
$excel = New-Object -ComObject Excel.Application
$filePath = "${env:USERPROFILE}\Downloads"
$dataFile = 'data.xlsx'
$outputFile = 'data.csv'
# https://gallery.technet.microsoft.com/office/bdb59b6d-3368-4c06-bf77-900a68706c5b
# ----------------------------------------------------- 
function Release-Ref ($ref) {
([System.Runtime.InteropServices.Marshal]::ReleaseComObject( 
[System.__ComObject]$ref) -gt 0) 
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers() 
} 
# ----------------------------------------------------- 
# See also: https://powershell.org/forums/topic/using-powershell-and-excel/
# http://www.itprotoday.com/microsoft-sql-server/update-excel-spreadsheets-powershell
# See also: https://github.com/dfinke/ImportExcel and https://github.com/JanKallman/EPPlus
# https://www.codeproject.com/Articles/1194712/Advanced-Excels-With-EPPlus
$workbook = $excel.Workbooks.Open("${filePath}\${Datafile}",  $null, $true) 
$worksheet = $workbook.worksheets.Item(1)
 
# XlFileFormat is an enumeration
# https://msdn.microsoft.com/en-us/vba/excel-vba/articles/xlfileformat-enumeration-excel
$worksheet.saveAs("${filePath}\${outputFile}", 6 )
# https://msdn.microsoft.com/en-us/library/microsoft.office.tools.excel.worksheet.exportasfixedformat.aspx 
# Worksheet.ExportAsFixedFormat is for PDF / XPS
# $excel.quit()
Release-Ref($workbook) |out-null
Release-Ref($excel)  |out-null
Stop-Process -Name 'excel'
