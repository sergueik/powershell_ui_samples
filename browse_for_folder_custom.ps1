#Copyright (c) 2014,2019 Serguei Kouzmine
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

# http://msdn.microsoft.com/en-us/library/windows/desktop/bb774065%28v=vs.85%29.aspx
# http://msdn.microsoft.com/en-us/library/windows/desktop/bb774096%28v=vs.85%29.aspx
# http://msdn.microsoft.com/en-us/library/windows/desktop/bb773205%28v=vs.85%29.aspx

$BIF_NONEWFOLDERBUTTON = 0x00000200
$BIF_BROWSEINCLUDEFILES  = 0x00004000

$BIF_NEWDIALOGSTYLE = 0x00000040 
$BIF_EDITBOX = 0x00000010

$shell_obj = new-object -com 'Shell.Application'


$file_obj = $null
try{ 
  [System.__ComObject]$file_obj = ($shell_obj.BrowseForFolder( [System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle, 'Choose File',
  $BIF_BROWSEINCLUDEFILES,
  0)) 
} catch [Exception] { 
write-output $_.Exception.Message
# System.Reflection.TargetInvocationException
# $_.Exception | get-member
# Exception has been thrown by the target of an invocation. ???
}

$file_obj.GetType() | format-list 
$file_obj.Self | get-member
# Exception from HRESULT: 0x80004005 (E_FAIL)
# $folder_obj.GetType() | format-list
$file_path = $file_obj.Self.Path
write-output $file_path


# see also 
# OpenFileDialog Class https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.openfiledialog?view=netframework-4.5
# FileDialog Class https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.filedialog?view=netframework-4.5

Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = new-object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('MyDocuments')
    Filter = 'Documents (*.docx)|*.docx|SpreadSheet (*.xlsx)|*.xlsx'
}
[void]$FileBrowser.ShowDialog()
$FileBrowser.FileNames

Add-Type -AssemblyName System.Windows.Forms
 
$FileBrowser = new-object System.Windows.Forms.OpenFileDialog -Property @{
    Multiselect = $true
}
 
[void]$FileBrowser.ShowDialog()
$FileBrowser.FileNames

# shttp://www.powershellmagazine.com/2013/07/01/pstip-using-the-system-windows-forms-openfiledialog-class/

