#Copyright (c) 2014 Serguei Kouzmine
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

param([string] $master_server = '', 
  [string]$servers_file = '',
  [string]$use_servers_file = '', 
  [bool] $bool_verbose  = $false 
  )


# Load the entries from remote 
if ($master_server -eq '') {
	$master_server = $env:MASTER_NODE
}


function make_screenshot  {
param([string] $string_value = '', 
  [bool] $bool_value  = $false 
  )

# embed everything 

# http://www.codeproject.com/Tips/816113/Console-Monitor
Add-Type -TypeDefinition @"

// "
// intend to call from a Form or from a timer 

using System;
using System.Drawing;
using System.Windows.Forms; // for IWin32Window
using System.IO;
using System.Drawing.Imaging;
public class Win32Window : IWin32Window
{
    private IntPtr _hWnd;
    public IntPtr Handle
    {
        get { return _hWnd; }
    }
    private int _count = 0;
    public int Count
    {
        get { return _count; }
        set { _count = value; }
    }
    public String Screenshot()
    {
        Bitmap bmp = new Bitmap(Screen.PrimaryScreen.Bounds.Width, Screen.PrimaryScreen.Bounds.Height);
        Graphics gr = Graphics.FromImage(bmp);
        gr.CopyFromScreen(0, 0, 0, 0, bmp.Size);
        string str = string.Format(@"C:\temp\Snap[{0}].jpeg", _count);
        bmp.Save(str, ImageFormat.Jpeg);
        return str;
    }
    public Win32Window(IntPtr handle)
    {
        _hWnd = handle;
    }
}

"@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Drawing.dll','System.Data.dll'


write-output "Run on ${env:COMPUTERNAME} as ${env:CLIENTNAME}"
# The screenshot will be taken and saved locally on the callers node
#   $owner = New-Object Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)
}

<#
$step_remote =  invoke-command -computer $master_server  -ScriptBlock ${function:make_screenshot} -Authentication Credssp -ArgumentList 'test', $true 
invoke-command : The WinRM client cannot process the request. Requests must
include user name and password when CredSSP authentication mechanism is used.
Add the user name and password or change the authentication mechanism and try
the request again.
#>
write-output "Run on ${master_server}"
$step_remote =  invoke-command -computer $master_server  -ScriptBlock ${function:make_screenshot} -ArgumentList 'test', $true 
write-output $step_remote
<#  Metadata file 'System.ComponentModel.dll' may not be found on certain boxes

    Directory: C:\Windows\Microsoft.NET\assembly\GAC_MSIL\System.ComponentModel\v4.0_4.0.0.0__b03f5f7f11d50a3a


Mode                LastWriteTime     Length Name
----                -------------     ------ ----
-a---          7/9/2012  12:40 AM      21976 System.ComponentModel.dll

    Directory: C:\Windows\Microsoft.NET\Framework\v4.0.30319


Mode                LastWriteTime     Length Name
----                -------------     ------ ----
-a---          7/9/2012  12:40 AM      21976 System.ComponentModel.dll
#>

  $owner.count = $iteration
  $owner.Screenshot()
 
# PowerShell Invoke-Command -FilePath example
# Invoke-Command -ComputerName 'computer.com'  -FilePath "C:\Users\user\console_snapshot_local.ps1"
# The handle is invalid
