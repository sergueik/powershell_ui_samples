# origin : https://guynaftaly.wordpress.com/2015/03/05/how-to-find-process-owner-with-powershell/
filter Get-ProcessOwner
{
  $id = $_.ID
  $info = (Get-WmiObject -Class Win32_Process -Filter "Handle=$id").GetOwner()
  if ($info.ReturnValue -eq 2)
  {
    $owner = '[Access Denied]'
  }
  else
  {
    $owner = '{0}\{1}' -f $info.Domain, $info.User
  }
  $_ | Add-Member -MemberType NoteProperty -Name Owner -Value $owner -PassThru
}

# example use
#  Get-Process -Id $pid | Get-ProcessOwner | Select-Object -Property Name, ID, Owner

# Get-Process | Where-Object MainWindowTitle | Get-ProcessOwner | Select-Object -Property Name, ID, Owner
