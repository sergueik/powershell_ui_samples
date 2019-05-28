# origin: http://www.cyberforum.ru/powershell/thread2455339.html

function Set-WindowStyle {
param(
  [Parameter()]
  [ValidateSet('SW_FORCEMINIMIZE', 'SW_HIDE', 'SW_MAXIMIZE', 'SW_MINIMIZE', 'SW_RESTORE', 'SW_SHOW', 'SW_SHOWDEFAULT', 'SW_SHOWMAXIMIZED', 'SW_SHOWMINIMIZED', 'SW_SHOWMINNOACTIVE', 'SW_SHOWNA', 'SW_SHOWNOACTIVATE', 'SW_SHOWNORMAL')] $Style = 'SW_SHOW',
  [Parameter()]
  $MainWindowHandle = (Get-Process -Id $pid).MainWindowHandle
)
  # converted from https://docs.microsoft.com/en-us/windows/desktop/api/winuser/nf-winuser-showwindow 
  $WindowStates = @{
    SW_FORCEMINIMIZE   = 11;
    SW_HIDE            = 0;
    SW_MAXIMIZE        = 3;
    SW_MINIMIZE        = 6
    SW_RESTORE         = 9;
    SW_SHOW            = 5;
    SW_SHOWDEFAULT     = 10;
    SW_SHOWMAXIMIZED   = 3;
    SW_SHOWMINIMIZED   = 2;
    SW_SHOWMINNOACTIVE = 7;
    SW_SHOWNA          = 8;
    SW_SHOWNOACTIVATE  = 4;
    SW_SHOWNORMAL      = 1;
  }
  Write-Verbose ('Set Window Style {1} on handle {0}' -f $MainWindowHandle, $($WindowStates[$style]))

  $Win32ShowWindowAsync = Add-Type -memberDefinition @'
  [DllImport("user32.dll")]
  public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
'@ -name "Win32ShowWindowAsync" -namespace Win32Functions -passThru

  $Win32ShowWindowAsync::ShowWindowAsync($MainWindowHandle, $WindowStates[$Style]) | Out-Null
}

(Get-Process -Name notepad).MainWindowHandle | foreach { Set-WindowStyle SW_MAXIMIZE $_ }
