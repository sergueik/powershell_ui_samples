# http://www.powertheshell.com/pinging-with-wmi/
param(
  [Parameter(Position = 0)]
  [object]$target_host = ''
)

function host_wmi_ping
{

  param(
    [string]$target_host = '',
    [bool]$debug
  )

  [bool]$status = $false
  [int]$timeout = 3000
  $filter = ("Address = '{0}' and Timeout = {1}" -f $target_host,$timeout)
  try {
    $result = Get-WmiObject -Class 'Win32_PingStatus' -Amended -DirectRead -Filter "${filter}" | Where-Object { $_.ResponseTime -ne $null }
  }
  catch [exception]{
    Write-Debug $_.Exception.Message

  }
  if ($result -ne $null) {
    $status = $true;

  }
  return $status
}


$res = host_wmi_ping -target_host $target_host

$res
