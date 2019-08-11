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

$source_path = "${env:USERNAME}\Music\Folder with A lot of Music"
$destination_path = $env:TEMP
$zip_filename = 'result'
$zip_path = "${destination_path}\${zip_filename}.zip"

[Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') | out-null
# create empty zip
set-content $zip_path ( [byte[]] @( 80, 75, 5, 6 + (, 0 * 18 ) ) ) -encoding byte
$source_folder = ( new-object -com 'Shell.Application' ).NameSpace( $source_path )
$zip_folder = ( new-object -com 'Shell.Application' ).NameSpace( $zip_path )

# https://docs.microsoft.com/en-us/windows/win32/shell/folder-copyhere
# launch with visual progress bar, do not wait for completion
$zip_folder.CopyHere( $source_folder, 16 )

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
