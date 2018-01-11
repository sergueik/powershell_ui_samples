#requires -version 2
#Copyright (c) 2018 Serguei Kouzmine
param(
  [string]$message = 'hello',
  [boolean]$debug = $false
)

Add-Type -TypeDefinition @"

// "using System;using System.ComponentModel;using System.Runtime.InteropServices;using System.Text;
using System;
using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Text;

namespace App {
   /* internal static */ public class UnsafeNative {
        public const int WM_COPYDATA = 0x004A;

        public static string GetMessage(int message, IntPtr lParam)  {
            if (message == UnsafeNative.WM_COPYDATA) {
                try {
        			// NOTE: requires .net 4.5.1 to compile
    			    var data = Marshal.PtrToStructure<UnsafeNative.COPYDATASTRUCT>(lParam);
                    var result = string.Copy(data.lpData);
                    return result;
                    
                } catch {
                    return null;
                }
            }
            return null;
        }

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

        [DllImport("user32.dll")]
        public static extern bool SetForegroundWindow(IntPtr hWnd);

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
"@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Net.dll','System.Runtime.InteropServices.dll'
$debug = $false
if ($debug) {
  $p = Start-Process -FilePath "app" -Passthru
  # Wait for child process to launch.
  $filter = "Name = 'notepad.exe' AND ParentProcessID = '$($pid)'"
  while (($p = Get-WmiObject -Class win32_process -Filter $filter) -eq $null) {
    Write-Host ('Waiting for notepad.exe to launch:`n{0}' -f $filter);
    Start-Sleep -Milliseconds 1000
  }
  # Wait for notepad.exe to get Title (main window has handle)
  while (($windowhandle = Get-Process -Id $p.ProcessId |
      Where-Object { $_.MainWindowTitle } |
      Select-Object -ExpandProperty MainWindowHandle) -eq $null) {
    Write-Host 'waiting for notepad.exe to get window Title';
    Start-Sleep -Milliseconds 100
  }
  Write-Output $p
} else {
  $p = (Get-Process -ProcessName 'app')[0]
  Write-Debug $p | Format-List
  Write-Output ("Process`nName: `"{0}`"id: {1}`nMainWindowHandle: {2}MainWindowHandle: {3}" -f $p.Name,$p.Id,$p.handle,(([System.Diagnostics.Process]::GetProcessById($p[0].Id)).MainWindowHandle))
}
$o = New-Object -TypeName 'App.UnsafeNative'
$args = @( "Pid: ${pid}" , $message )
# Cannot convert argument "hwnd", with value: "18120", for "SendMessage" to type "System.IntPtr": 
# "Cannot convert the "18120" value of type "System.String" to type "System.IntPtr"."
# [App.UnsafeNative]::SendMessage($p[0].handle, [String]::Join(" ", $args))
[App.UnsafeNative]::SendMessage(([System.Diagnostics.Process]::GetProcessById($p.Id)).MainWindowHandle,[string]::Join(" ",$args))
