param(
  [string]$remotecomputer = $env:COMPUTERNAME
)

function get_computer_network_interfaces {
  <#
  param(
    [ValidateNotNull()]
#
#    [string[]]$remotecomputer,
# BUG
#    [string]$remotecomputer,

  )
#>
  try {

    $wmi_query = "Select Index,IPAddress,MACAddress From Win32_NetworkAdapterConfiguration Where IPEnabled = True"
    # NOTE: this is not returning
    # $wmi_query ="Select Name,MACAddress,Index from Win32_NetworkAdapter Where NetConnectionStatus = 2"
    Write-Host $remotecomputer
    $data = $null
    # is it a bug. The  $remotecomputer argument is ignored when run from the script .
    # bug used properly when in the console 
    $remotecomputer = '.'
    $data = Get-WmiObject -ComputerName $remotecomputer -Query $wmi_query
  }
  catch [System.Management.Automation.PSInvalidCastException]{
    $has_data = $false
    # ignore this exception 
  } catch [exception]{
    $has_data = $false
    Write-Host -foreground 'white' -background 'Red' $_.Exception.GetType().FullName;
    Write-Host -foreground 'white' -background 'Red' $_.Exception.Message;
    # rethrow other exceptions 
    throw
  }
  # regarding primary IP address extraction
  if ($data -eq $null -or $data -eq '') {

    throw
  }


  # $data.IPAddress 
  # https://groups.google.com/forum/#!topic/microsoft.public.scripting.vbscript/S5z36zo74UU
  # Note that item.IPAddress(0) is the first record of the array and is the
  # primary IP Address of the NIC where the NIC may have more than one IP Address assigned to it.
  # this is actually wrong: The order is opposite..

  $wmi_query = "Select Index,IPAddress,MACAddress From Win32_NetworkAdapterConfiguration Where IPEnabled = True"
  $data = Get-WmiObject -Query $wmi_query

  # Exclude the IPV6  addresses (The tail entry(ies) in the array)
  #  this is the same as returned by the console tool as 'Link-local IPv6 Address'

  $ipv4_addresses = $data.IPAddress | Where-Object { $_ -match '^[\d+\.]+$' }
  return $ipv4_addresses
}



function get_remote_computer_network_interfaces {

  param(
    [ValidateNotNull()]
    [string]$remotecomputer,
    [System.Management.Automation.PSReference]$data_ref

  )


  $command_outputs = Invoke-Command -computer $remotecomputer -ScriptBlock ${function:get_computer_network_interfaces}



  $local:ipv4_addresses = $command_outputs

  <#
NOTE:
sometimes redundant 
Primary IP address:
        1
IP addresses:
        192.168.0.1

#>
  $local:primary = $null
  if ($ipv4_addresses.Count -gt 1) {
    $local:primary = $ipv4_addresses[($ipv4_addresses.Count - 1)]
  } else {
    $local:primary = $ipv4_addresses
  }
  $local:res = @{ 'primary' = $local:primary;
    'addresses' = $ipv4_addresses
  }

  Write-Host -foreground 'Cyan' $remotecomputer
  Write-Host -foreground 'Yellow' ("Primary IP address:")
  Write-Host -foreground 'Green' ("`t{0}" -f $local:res['primary'])

  Write-Host -foreground 'Yellow' ('IP addresses:')
  $local:res['addresses'] | ForEach-Object { Write-Host -foreground 'Green' ("`t{0}" -f $_) }
  $data_ref.Value = $local:res
}

$res = @{}
get_remote_computer_network_interfaces -remotecomputer $remotecomputer -data_ref ([ref]$res)

# Verify 
# ping.exe $remotecomputer
