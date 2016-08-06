# origin http://poshcode.org/2049
if (-not ('user32.helper' -as [type])) {
  Add-Type -name 'helper' -namespace 'user32' -MemberDefinition @"
  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
  public static extern IntPtr SendMessageTimeout(IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam, uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
"@
}
$HWND_BROADCAST = [intptr]0xFFFF
# message constants https://msdn.microsoft.com/en-us/library/windows/desktop/ms644927%28v=vs.85%29.aspx#system_defined
$WM_SETTINGCHANGE = 0x1A

# https://msdn.microsoft.com/en-us/library/windows/desktop/ms644952%28v=vs.85%29.aspx
# message is sent to all top-level windows in the system without waiting
[user32.helper]::SendMessageTimeout($HWND_BROADCAST, $WM_SETTINGCHANGE, [uintptr]::Zero, 'Environment', 2, 5000, [ref]([uintptr]::Zero)) | out-null
