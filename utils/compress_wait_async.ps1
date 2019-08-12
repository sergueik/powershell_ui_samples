#Copyright (c) 2019 Serguei Kouzmine
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

# based on: https://stackoverflow.com/questions/47835738/powershell-zip-copyhere-counteracting-asynchronous-behavior
# https://social.technet.microsoft.com/Forums/SECURITY/en-US/6988d856-09ae-41c5-aa79-3d78a9e4d03a/powershell-use-shellapplication-to-zip-files?forum=ITCG
# see also: https://blog.danskingdom.com/module-to-synchronously-zip-and-unzip-using-powershell-2-0/
# $debugpreference='continue'
param (

[Parameter (Mandatory = $true, Position = 0)]
  [String]$source_path = "${env:USERNAME}\Music\Folder with A lot of Music",
  [Switch]$debug_me
)

$debug_arg = $false
if ([bool]$PSBoundParameters['debug_me'].IsPresent) {
  $debug_arg = $true
}

$destination_path = $env:TEMP
$zip_filename = 'result'

$zip_path = "${destination_path}\${zip_filename}.zip"
if (test-path -path $zip_path) {
  remove-item -force -path $zip_path -erroraction stop
  start-sleep -second 3
}
$shell = new-object -com 'Shell.Application'
[Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') | out-null
# create empty zip
try{
  set-content $zip_path ( [byte[]] @( 80, 75, 5, 6 + (, 0 * 18 ) ) ) -encoding byte -erroraction stop
} catch [Exception] {
 exit 1
}

$source_folder = $shell.NameSpace( $source_path )
$zip_folder = $shell.NameSpace( $zip_path )

# https://docs.microsoft.com/en-us/windows/win32/shell/folder-copyhere
# launch with visual progress bar, do not wait for completion

# SHFILEOPSTRUCTA structure
# based on: https://msdn.microsoft.com/en-us/library/windows/desktop/bb759795%28v=vs.85%29.aspx
$FOF_SILENT = 0x0004
$FOF_NOCONFIRMATION = 0x0010
$FOF_NOERRORUI = 0x0400
$FOF_NOCOPYSECURITYATTRIBS = 0x0800
$copyFlags = $FOF_SILENT -bor $FOF_NOCONFIRMATION -bor $FOF_NOERRORUI -bor $FOF_NOCOPYSECURITYATTRIBS

# NOTE: file not found or no read permission error

$zip_folder.CopyHere( $source_folder, $copyFlags )

# Remarks
# No notification is given to the calling program to indicate that the copy has completed.

$check_count = (get-childitem -path $source_path ).count
$done = $false

# start wait for completion
while ($done -eq $false){
  try{
    $check_zip = [IO.Compression.ZipFile]::OpenRead($zip_path)
    write-debug ('Counting items: {0}' -f ($check_zip.Entries).count )
    if( ($check_zip.Entries).count -eq $check_count){
      $check_zip.Dispose()
      $done = $true
      break
    }
  } catch [Exception] {
  }
  start-sleep -seconds 1
  write-host '.' -nonewline
}

[System.Runtime.Interopservices.Marshal]::ReleaseComObject($zip_folder) | out-null
remove-variable zip_folder

[System.Runtime.Interopservices.Marshal]::ReleaseComObject($source_folder) | out-null
remove-variable source_folder


[System.Runtime.Interopservices.Marshal]::ReleaseComObject($shell) | out-null
remove-variable shell

