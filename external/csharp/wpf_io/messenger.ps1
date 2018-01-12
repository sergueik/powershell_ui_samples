#requires -version 2
# . .\messenger.ps1 -app App -message "hello, App"
#Copyright (c) 2018 Serguei Kouzmine
param(
  [string]$app = 'App',
  [string]$message = 'message',
  [boolean]$debug = $false
)

Add-Type -TypeDefinition @"

// "
using System;
using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Text;

namespace App {
  public class UnsafeNative {
        public const int WM_COPYDATA = 0x004A;

        public static void SendMessage(IntPtr hwnd, String message) {
            var messageBytes = Encoding.Unicode.GetBytes(message); /* ANSII encoding */
            var data = new UnsafeNative.COPYDATASTRUCT {
                dwData = IntPtr.Zero,
                lpData = message,
                cbData = messageBytes.Length + 1 /* +1 because of \0 string termination */
            };
            Console.Error.WriteLine("Sending message:\nhwnd = {0}\nmessage = \"{1}\"", hwnd, message);
            if (UnsafeNative.SendMessage(hwnd, WM_COPYDATA, IntPtr.Zero, ref data) != 0)
                throw new Win32Exception(Marshal.GetLastWin32Error());
        }
        
        [DllImport("User32.dll", EntryPoint = "SendMessage")]
        private static extern int SendMessage(IntPtr hWnd, int Msg, IntPtr wParam, ref COPYDATASTRUCT lParam);

        [StructLayout(LayoutKind.Sequential)]
        private struct COPYDATASTRUCT {
            public IntPtr dwData;
            public int cbData;

            [MarshalAs(UnmanagedType.LPWStr)]
            public string lpData;
        }
    }
}
"@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Runtime.InteropServices.dll'

$process = Get-Process -ProcessName "${app}" -ErrorAction SilentlyContinue

if ($process -eq $null) {
  Write-Output ('The appplication {0} is not running' -f $app)
  return
}
# Wait for notepad.exe to get Title (main window has handle)
while (($windowhandle = Get-Process -Id $process.Id |
    Where-Object { $_.MainWindowTitle } |
    Select-Object -ExpandProperty MainWindowHandle) -eq $null) {
  Write-Host ('Waiting for {0} to get window Title' -f $app);
  Start-Sleep -Milliseconds 1000
}

Write-Debug $process | Format-List
Write-Output ("Process`nName: `"{0}`"`nid: {1}`nMainWindowHandle: {2}" -f
  $process.Name,$process.Id,(([System.Diagnostics.Process]::GetProcessById($process.Id)).MainWindowHandle))
$o = New-Object -TypeName 'App.UnsafeNative'
$args = @( "Pid: ${pid}",$message)
[App.UnsafeNative]::SendMessage(
  ([System.Diagnostics.Process]::GetProcessById($process.Id)).MainWindowHandle,
  [string]::Join(' ',$args)
)
