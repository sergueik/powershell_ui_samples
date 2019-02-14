param(
 [switch]$noop
)

$noop_mode = [bool]$PSBoundParameters['noop'].IsPresent

<#
  get-help Restart-Computer
  # https://mcpmag.com/articles/2012/04/10/how-to-restart-computers-remotely-via-powershell.aspx
  get-help Get-Process
  #  may require too late PS psversion.
  import-module ActiveDirectory
  # https://blogs.technet.microsoft.com/askds/2010/02/04/inventorying-computers-with-ad-powershell/
  $targets = Get-ADComputer -expandproperty Name
  # https://blogs.technet.microsoft.com/askds/2010/02/04/inventorying-computers-with-ad-powershell/
#>

$debugpreference='continue'

# based on http://forum.oszone.net/thread-193204.html

function checkProcessOnHost{
  param (
    $computer = '.',
    $processname = 'javaw.exe'
  )
  $status = $false
  if ((test-connection -quiet -delay 1 -count 2 -erroraction SilentlyContinue  -computername $computer) -or  ($computer -eq '.')) {
    $processList = get-wmiobject -class 'Win32_Process' -computername $computer | where-Object {$_.Name -match $processname } |select-object -expandproperty 'name'
    # can be [String[]] or [String]
    $processCount = 0
    if ($processList -is [array]){
      $processCount = $processList.Length
    } else {
      $processCount = 1
    }
    write-debug ("On Node ${computer} is running {0} copies of ${processname}" -f $processCount  )
    $status = $true
  }
  else {
    write-debug "Node ${computer} is down"
  }
  # true for OK to reboot
  return $status
}

$processname = 'java.exe'
$targetdomain = 'mydomain'
$ou = [ADSI]"LDAP://CN=Computers,DC=${targetdomain}DC=com"

$ou.children | where-object {$_.objectCategory -match 'Computer'} | foreach-object {
  $targetcomputer  = $_
  $status = checkProcessOnHost -computer $targetcomputer -processname $processname
  if ($status) {
    if ($noop_mode) {
      restart-Computer -ComputerName $targetcomputer -whatif
    }
    else {
      restart-Computer -ComputerName $targetcomputer
    }
  }
}