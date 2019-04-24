param(
  [Parameter(Position = 0)]
  [string]$environment

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


function examine_json {
  param(
    [Parameter(Position = 0)]
    [object]$results,
    [string]$filename

  )
   $bad_ip_addresses = ${ } 

  $results.Keys | ForEach-Object { $k = $_
  $row_data = @()    
    $hosts_array = @()
    $h = $results[$k]['addresses']
    $v = $results[$k]['hosts']
    $a = $results[$k]['additional_data']
    $h | ForEach-Object {
      $final = $_

      if ((-not $a.ContainsKey($final)) -and (-not $v.ContainsKey($final))) {
        Write-Host -foreground 'Blue' ('{0} => {1}', $k,  $final)
$row_data  += $final
      }
# $bad_ip_addresses[$k] = $row_data 
    }
  }
}
function squash_json {
  param(
    [Parameter(Position = 0)]
    [object]$results,
    [string]$filename

  )

  $row_data = @()
  # temporary solutuon 
  $results.Keys | ForEach-Object { $k = $_

    $hosts_array = @()

    $v = $results[$k]['hosts']
    $v.Keys | ForEach-Object {

      $k2 = $_
      if ($k2 -ne $null) {
        $hosts_array += ('{0}|{1}' -f $k2,$v[$k2])
      }
    }

    $col_data = @{
      'name' = $k;

      'hosts' = $hosts_array
      'addresses' = $results[$k]['addresses'];
    }

    $additional_data_array = @()

    $v = $results[$k]['additional_data']


    $v.Keys | ForEach-Object {

      $k2 = $_
      if ($k2 -ne $null) {
        $additional_data_array += ('{0}|{1}' -f $k2,$v[$k2])
      }
    }

    $col_data = @{
      'name' = $k;

      'hosts' = $hosts_array;
      'IIS_INFORMATION' = $additional_data_array;
      'addresses' = $results[$k]['addresses'];
    }

    $row_data += $col_data
  }

  $raw_rowset_data = ConvertTo-Json -InputObject $row_data
  Out-File -FilePath $filename -Encoding ASCII -InputObject $raw_rowset_data
}

function get_remote_nic_data {
  param(
    [Parameter(Position = 0)]
    [string]$remotecomputer,
    [System.Management.Automation.PSReference]$data_ref
  )
  if (($remotecomputer -eq $null) -or ($remotecomputer -eq '')) {
    return
  }
  if (-not ($remotecomputer -match $env:USERDOMAIN)) {
    return
  }

  Write-Debug $remotecomputer
  $addresses = @()
  $command_outputs = Invoke-Command -computer $remotecomputer -ScriptBlock ${function:get_nic_data}
  $data_ref.Value = $addresses;

  $data_ref.Value = $command_outputs
}

function get_nic_data {
  $addresses = @()
  $command_output = Invoke-Expression -Command 'C:\Windows\System32\ipconfig.exe'
  $nic_addresses_found = @{}
  if ($command_output -ne $null) {
    ($command_output -split "`n") | ForEach-Object {
      $line = $_
      if ($line -match 'IPv4 Address') {
        if ($DebugPreference -eq 'Continue') {
          Write-Host -ForegroundColor 'yellow' Write-Host $line
        }
        if ($line -match ":\s*(\d+\.\d+\.\d+\.\d+)\s*$") {
          $ipaddress = $matches[1]
          if ($DebugPreference -eq 'Continue') {

            Write-Host -ForegroundColor 'yellow' ("--> {0} " -f $ipaddress)
          }
          $addresses += $ipaddress
        }
      }

    }
  }
  return $addresses
}



function get_hosts_data {
  param(
    [Parameter(Position = 0)]
    [string]$remotecomputer,
    [System.Management.Automation.PSReference]$data_ref
  )

  if (($remotecomputer -eq $null) -or ($remotecomputer -eq '')) {
    return
  }
  if (-not ($remotecomputer -match $env:USERDOMAIN)) {
    return
  }

  $has_data = $true
  # note the order is opposite to what is written in hosts file
  $hostnames_known = @{

    'host.domain.com' = $null;
  }


  $server_data = @"

  www5.domain.com  
  www4.domain.com  

"@

  $server_data -split "`r?`n" | ForEach-Object {
    $raw = $_
    $final = $raw -replace "\s",""
    if (-not $final) {
      return
    }
    if (-not $hostnames_known.ContainsKey($final)) {
      $hostnames_known.Add($final,$null)
    }
  }

  $hostname_keys = @()
  $hostnames_found = @{}

  $hostname_keys = @()
  $hostnames_found = @{}
  # subset  
  $hostnames_known.Keys | ForEach-Object { $hostname_keys += $_ }

  $current_file_content = ''
  try {
    $current_file_content = Get-Content -Path "\\${remotecomputer}\c$\Windows\system32\drivers\etc\hosts"
  } catch [exception]{
    $has_data = $false
    Write-Host $_.Exception.GetType().FullName;
    Write-Host $_.Exception.Message;
  }
  if ($has_data) {
    ($current_file_content -split "`n") | ForEach-Object {
      $line = $_
      $keep = $true
      $hostname_keys | ForEach-Object {
        $host_name = $_;

        if ($line -match $host_name) {
          if ($DebugPreference -eq 'Continue') {
            Write-Host -ForegroundColor 'yellow' ("Collecting {0}" -f $line)
          }
          # capture 
          if ($line -match "^\s*(\d+\.\d+\.\d+\.\d+)\s+${host_name}\s*$") {
            $ip_address = $matches[1]
            if ($DebugPreference -eq 'Continue') {
              Write-Host -ForegroundColor 'Gray' ("Match: '{0}'" -f $ip_address)
            }
            $hostnames_found[$host_name] = $ip_address
          }
        }
      }

    }

  }
  # need to reverse 

# need the other way around
$reverse_hash = @{}
$hostnames_found.Keys |  foreach-object {  
$k = $_
$reverse_hash[$hostnames_found[$k]] = $_
}
  $data_ref.Value = $reverse_hash
#  $data_ref.Value = $hostnames_found

}

<# $disk = Get-WmiObject Win32_LogicalDisk -ComputerName remotecomputer -Filter "DeviceID='C:'" |
Select-Object Size,FreeSpace

$disk.Size
$disk.FreeSpace

#>

# need to be embedded in the caller function which itsels is called  remotely 
function extract_bound_ip_address {
  param([string]$line)

  $res = @()
  $ip_addresses_bound = @{}
  $site_alias = $null
  $site_configuration = $null
  if ($line -match 'SITE\s+"(\w+)"\s+\((.+)\)$') {

    $site_alias = $matches[1]
    $site_configuration = $matches[2]
    if ($DebugPreference -eq 'Continue') {
      Write-Host -ForegroundColor 'yellow' ('site configuration: {0}' -f $site_configuration)
    }
  }

  if ($site_configuration) {
    # somewhat poorly formatted. 
    # note the incoherent usage of colons and commas.,
    # id:6,bindings:http/10.244.160.64:80:,https/10.244.160.64:443:,state:Started

    if ($site_configuration -match 'bindings:(.+),state:') {

      $bound_to_ipaddress = $matches[1]
      if ($DebugPreference -eq 'Continue') {
        Write-Host -ForegroundColor 'yellow' ("bound_to_ipaddresses: {0} " -f $bound_to_ipaddress)

      }

      $items = $bound_to_ipaddress -split ','
      # note non-standard format  
      $items | ForEach-Object { $entry = $_
        if ($entry -match 'https?/([\d.]+):') {
          $res += $matches[1]

        }

      }
      if ($DebugPreference -eq 'Continue') {
        Write-Host -ForegroundColor 'yellow' $res

      }
    }
  }

  $res | ForEach-Object { $k = $_; if (-not $ip_addresses_bound.ContainsKey($k)) { $ip_addresses_bound.Add($k,$null) } }
  return $ip_addresses_bound.Keys

}

function get_remote_appcmd_data {
  param(
    [Parameter(Position = 0)]
    [string]$remotecomputer,
    [System.Management.Automation.PSReference]$data_ref
  )
  if (($remotecomputer -eq $null) -or ($remotecomputer -eq '')) {
    return
  }
  if (-not ($remotecomputer -match $env:USERDOMAIN)) {
    return
  }

  Write-Debug $remotecomputer
  $addresses = @()

  $command_outputs = Invoke-Command -computer $remotecomputer -ScriptBlock ${function:get_appcmd_data}

  $data_ref.Value = $command_outputs
}

function get_appcmd_data {

  # need to be embedded in the caller function which itsels is called  remotely 
  function extract_bound_ip_address {
    param([string]$line)

    $res = @()
    $ip_addresses_bound = @{}
    $site_alias = $null
    $site_configuration = $null
    if ($line -match 'SITE\s+"(\w+)"\s+\((.+)\)$') {

      $site_alias = $matches[1]
      $site_configuration = $matches[2]
      if ($DebugPreference -eq 'Continue') {
        Write-Host -ForegroundColor 'yellow' ('site configuration: {0}' -f $site_configuration)
      }
    }

    if ($site_configuration) {
      # somewhat poorly formatted. 
      # note the incoherent usage of colons and commas.,
      # id:6,bindings:http/10.244.160.64:80:,https/10.244.160.64:443:,state:Started

      if ($site_configuration -match 'bindings:(.+),state:') {

        $bound_to_ipaddress = $matches[1]
        if ($DebugPreference -eq 'Continue') {
          Write-Host -ForegroundColor 'yellow' ("bound_to_ipaddresses: {0} " -f $bound_to_ipaddress)

        }

        $items = $bound_to_ipaddress -split ','
        # note non-standard format  
        $items | ForEach-Object { $entry = $_
          if ($entry -match 'https?/([\d.]+):') {
            $res += $matches[1]

          }

        }
        if ($DebugPreference -eq 'Continue') {
          Write-Host -ForegroundColor 'yellow' ('-->'  + $res)

        }

      }

    }

    $res | ForEach-Object { $k = $_; if (-not $ip_addresses_bound.ContainsKey($k)) { $ip_addresses_bound.Add($k,$null) } }

    return $ip_addresses_bound.Keys

  }


  $iis_bound_addresses = @{}
  $command_output = Invoke-Expression -Command 'C:\Windows\System32\inetsrv\appcmd.exe list site'
  $nic_addresses_found = @{}
  if ($command_output -ne $null) {
    ($command_output -split "`n") | ForEach-Object {
      $line = $_
      $continue_flag = $false 
      write-host ('Inspecting {0}' -f $line ) 
      # $DebugPreference = 'Continue'
      # possible result :
      # SITE "SITE_5" (id:5,bindings:,state:Unknown)
      # Stopped sites are OK  
      #   if ($line -match 'state:(?:Unknown|Stopped)') {
       
      if (($line -match 'state:Unknown' ) -or ($line -match 'Default Web Site') ) {
        write-host ('About to Skip {0}' -f $line ) 
         $continue_flag = $true 
       # TODO: debug
       # continue
      }

      if (-not $continue_flag ) {
      if ($line -match 'SITE\s+"(\w+)"\s+\((.+)\)$') {
        write-host 'Extract IP information'
        $site_alias = $matches[1]
        $site_configuration = $matches[2]
        $site_bound_ip_address = extract_bound_ip_address -Line $line

        $iis_bound_addresses[$site_alias] = $site_bound_ip_address
      }
}
    }
  }
# need the other way around
$reverse_hash = @{}
$iis_bound_addresses.Keys |  foreach-object {  
$k = $_
$reverse_hash[$iis_bound_addresses[$k]] = $_
}
return $reverse_hash
  return $iis_bound_addresses
}


function collect_inventory {
  param(
    [Parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
    #    [ValidateNotNull()]
    [string[]]$computerName
  )


  process {

    $local:result = @{
    }

    foreach ($node in $ComputerName) {
      if (-not $node) {
        continue
      }

      $ping_status_res = host_wmi_ping -target_host $node
      if (-not $ping_status_res) {
        continue
      }


      Write-Debug $node
      $local:hosts_data = @{}
      $local:data2 = @()
      $local:data3 = @()
      $hosts_data_ref = ([ref]$local:hosts_data)
      $data2_ref = ([ref]$local:data2)
      $data3_ref = ([ref]$local:data3)
      get_hosts_data -remotecomputer $node -data_ref $hosts_data_ref
      get_remote_nic_data -remotecomputer $node -data_ref $data2_ref

      get_remote_appcmd_data -remotecomputer $node -data_ref $data3_ref
      # flatten the data
      <#

   {
   "value":  "192.168.0.1",
   "PSComputerName":  "computer",
   "RunspaceId":  "868b942b-ab4f-40b3-b1cb-b71c35a0704f",                                                               
   "PSShowComputerName":  true
 },
                                                           },
#>
      $addresses = @()
      $data2 | ForEach-Object {
        $data2_row = $_;
        Write-Host -ForegroundColor 'green' $data2_row
        $addresses += ("{0}" -f $data2_row)
      }


      $local:result[$node] = @{ 'hosts' = $local:hosts_data;
        'addresses' = $addresses;
        'additional_data' = $data3;
      }
    }

    return $local:result
  }

}

<#
TODO - filter by FQDN in the runner 
#>


# custom_environment =
# label => code block 
[scriptblock]$EXAMPLE = {
  param(
    [System.Management.Automation.PSReference]$object_ref,
    [System.Management.Automation.PSReference]$result_ref,
    [System.Management.Automation.PSReference]$caller_ref,
    [string]$key = $null
  )


  $data = @{}
  $debug = $false
  if ($DebugPreference -eq 'Continue') {
    $debug = $true
  }

  if ($debug) {
    Write-Host 'Object keys'
    Write-Host $object_ref.Value.Keys
    Write-Host 'Caller  keys'
    $caller_ref.Value[$key].Keys

  }

  $nodes = $object_ref.Value.Keys
  $data = @{ $key = @(); }
  $nodes | ForEach-Object {
    $k = $_
    $servers = $object_ref.Value[$k]['SERVERS'] | Where-Object {
      ($_ -match $caller_ref.Value[$key]['EXPRESSION']) -and ($_ -match $caller_ref.Value[$key]['DOMAIN'])
    }
    $data[$key] += $servers
  }


  $result_ref.Value = $data[$key]
}

$ENVIRONMENTS_CUSTOM = @{
  'UAT1' = @{
    'SCRIPT' = $EXAMPLE;
    'EXPRESSION' = '^xxxxx.*n1\.';
    'DOMAIN' = '(?:DOMAIN|DOMAIN)';
  };
  'UAT2' = @{
    'SCRIPT' = $EXAMPLE;
    'EXPRESSION' = '^xxx.*n2\.';
    'DOMAIN' = '(?:DOMAIN|DOMAIN)';
  };

$ENVIRONMENTS_STRUCTURED = @{

  'PROD' = @{
    'COMMENT' = 'Web Servers';
    'DOMAIN' = 'INTERNET';
    'LOGONSERVER' = '(?:server4|server3)';
    'SERVERS' =
    @(
      'xxxxxx',
    );
  };
}


$scope = $environment
if ($scope -eq '' -or $scope -eq $null) {
  $scope = 'DEBUG'
}
Write-Output $scope
if ($scope -eq '-') {
  Write-Output 'Processing all environment '
  foreach ($role in $ENVIRONMENTS_STRUCTURED.Keys) {
    Write-Host ('Probing {0}' -f $role)
    $configuration = $ENVIRONMENTS_STRUCTURED.Item($role)
    # skip unreachable domain results , 
    Write-Debug ('Logon Server "{0}"' -f $configuration['LOGONSERVER'])
    if (($configuration['DOMAIN'] -eq $env:USERDOMAIN) -and (($configuration['LOGONSERVER'] -eq $null) -or ($env:LOGONSERVER -match $configuration['LOGONSERVER']))) {
      Write-Output ('Starting {0}' -f $configuration['COMMENT'])
      if ($configuration.ContainsKey('SERVERS')) {
        $servers = $configuration['SERVERS']
        if ($servers.count -gt 0) {
          $configuration['RESULTS'] = collect_inventory $servers
          # $configuration['RESULTS'] | convertto-Json
          squash_json -results $configuration['RESULTS'] -FileName ('{0}.json' -f $role)
        }
      }
    }
  }
} else {

  $object_ref = ([ref]$ENVIRONMENTS_STRUCTURED)
  $caller_ref = ([ref]$ENVIRONMENTS_CUSTOM)

  #
  # TODO: This always iterates over all ..

  # $ENVIRONMENTS_CUSTOM.Keys | ForEach-Object {
  # $role = $_
  @( $scope ) | ForEach-Object {
    $role =  $_ 
    # $v = $ENVIRONMENTS_CUSTOM[$role] 
    # todo nesting 
    [scriptblock]$s = $ENVIRONMENTS_CUSTOM[$role]['SCRIPT']
    if ($s -ne $null) {
      $local:result = $null
      $result_ref = ([ref]$local:result)
      Invoke-Command $s -ArgumentList $object_ref,$result_ref,$caller_ref,$role
      Write-Host ('{0}  = {1}' -f $role,$result_ref.Value)
      $result_ref.Value | Format-Table
    } else {
      Write-Host ('extract function not defined for {0}' -f $role)
      # TODO: throw
    }

    $nodes = $result_ref.Value
    write-debug $nodes
    # TODO - reenable
    $DebugPreference = 'Continue';
    Write-Debug $scope
    $results = collect_inventory $nodes
 
  $raw_results = ConvertTo-Json -InputObject $results
  Out-File -FilePath ('{0}-RAW.json' -f $role ) -Encoding ASCII -InputObject $raw_results

    examine_json -results $results -FileName ('{0}-BAD.json' -f $role)
    # squash_json -results $results -FileName ('{0}.json' -f $role)


  }
}
# Out-File -FilePath 'result2.json' -Encoding ASCII -InputObject $raw_rowset_data
# 
return

