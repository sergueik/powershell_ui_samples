# origin: http://www.cyberforum.ru/powershell/thread1719005.html
function Invoke-Sudo {
  begin {
    function private:ConvertTo-RegularString([Security.SecureString]$s) {
      return [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($s)
      )
    }
    
    function private:Get-Win32Error([Int32]$e) {
      [PSObject].Assembly.GetType(
        'Microsoft.PowerShell.Commands.Internal.Win32Native'
      ).GetMethod(
        'GetMessage', [Reflection.BindingFlags]40
      ).Invoke($null, @($e))
    }
    
    if ((New-Object Security.Principal.WindowsPrincipal(
      [Security.Principal.WindowsIdentity]::GetCurrent()
    )).IsInRole(
      [Security.Principal.WindowsBuiltInRole]::Administrator
    )) {
      Get-Win32Error 12
      break
    }
  }
  process {
    $usr = Read-Host 'Domain\User' -AsSecureString
    if (($$ = ConvertTo-RegularString $usr) -notmatch '\\') {
      Get-Win32Error 10
      break
    }
    
    $dom, $usr = $$.Split('\\')
    try {
      $p = New-Object Diagnostics.Process
      $p.StartInfo.Domain = $dom
      $p.StartInfo.FileName = 'powershell'
      $p.StartInfo.LoadUserProfile = $false
      $p.StartInfo.Password = $(Read-Host 'Password' -AsSecureString)
      $p.StartInfo.UserName = $usr
      $p.StartInfo.UseShellExecute = $false
      $p.StartInfo.WorkingDirectory = $HOME
      [void]$p.Start()
      
      Start-Sleep -Miliseconds 100
      Stop-Process -Id $PID 
    }
    catch [Management.Automation.MethodInvocationException] {
      $_.Exception.InnerException
    }
  }
  end {}
}