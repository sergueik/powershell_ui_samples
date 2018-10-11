<# :
  @echo off
    REM origin: http://forum.oszone.net/thread-313736-2.html
    setlocal
      set "self=%~f0" % rem : full scriptpath 
       2>nul powershell /noprofile /executionpolicy bypass^
      "&{[ScriptBlock]::Create((gc '%self%') -join [Char]10).Invoke(@(&{$args}'%self%'))}"||(
        echo:PowerShell has not been found.
      )
    endlocal
  exit /b
#>
if (!(New-Object Security.Principal.WindowsPrincipal(
  [Security.Principal.WindowsIdentity]::GetCurrent()
)).IsInRole(
  [Security.Principal.WindowsBuiltInRole]::Administrator
)) {
  $proc = New-Object Diagnostics.Process
  $proc.StartInfo.FileName = $args[0]
  $proc.StartInfo.LoadUserProfile = $false
  $proc.StartInfo.Domain = [Environment]::UserDomainName
  $proc.StartInfo.UserName = $(Read-Host 'Username')
  $proc.StartInfo.Password = $(Read-Host 'Password' -as)
  $proc.StartInfo.UseShellExecute = $false
  $proc.Start()
}
else {
  Write-Host Placeholder for your code -forergound green
  Write-Host Press any key... -NoNewline
  $host.UI.RawUI.ReadKey('NoEcho, IncludeKeyDown') | Out-Null
  ''
}
