param(
  [Parameter(Position = 0)]
  [string]$environment

)

function host_wmi_ping
{

  param(
    [string]$target_host = 'xxxxxx',
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


function squash_json {
  param(
    [Parameter(Position = 0)]
    [object]$results,
    [string]$filename

  )

  $row_data = @()
  # temporary solutuon 
  $results.Keys | ForEach-Object { $k = $_

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
      'IIS_INFORMATION' = $additional_data_array;
     }

    $row_data += $col_data
  }

  $raw_rowset_data = ConvertTo-Json -InputObject $row_data
  Out-File -FilePath $filename -Encoding ASCII -InputObject $raw_rowset_data
}

# need to be embedded in the caller function which itsels is called  remotely 
function extract_site_internal_order {
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

function get_remote_appcmd_order {
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

  $command_outputs = Invoke-Command -computer $remotecomputer -ScriptBlock ${function:get_appcmd_order}

  $data_ref.Value = $command_outputs
}

function get_appcmd_order {

  # need to be embedded in the caller function which itsels is called  remotely 
  function extract_site_internal_order {
    param([string]$line)

    $res = @()
    $ip_addresses_bound = @{}
    $site_alias = $null
    $site_configuration = $null
    if ($line -match 'SITE\s+"(\w+)"\s+\((.+)\)$') { 
 
        #  e.g. 
        # SITE "Carnival"  (id:2,bindings:http/10.246.144.101:80:,https/10.246.144.101:443:,http/10.246.144.101:80:www.carnival.com,state:Started)

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

      if ($site_configuration -match 'id:([0-9]+),') {

        $site_id = $matches[1]
        if ($DebugPreference -eq 'Continue') {
          Write-Host -ForegroundColor 'yellow' ("Site ID: {0}" -f $site_id)

        }

      }

    }

    return $site_id

  }


  $iis_bound_addresses = @{}
  $command_output = Invoke-Expression -Command 'C:\Windows\System32\inetsrv\appcmd.exe list site'
  $nic_addresses_found = @{}
  if ($command_output -ne $null) {
    ($command_output -split "`n") | ForEach-Object {
      $line = $_
      $continue_flag = $false
      Write-Host ('Inspecting {0}' -f $line)
      # $DebugPreference = 'Continue'
      # possible result :
      # SITE "SITE_5" (id:5,bindings:,state:Unknown)
      # Stopped sites are OK  
      #   if ($line -match 'state:(?:Unknown|Stopped)') {

      if (($line -match 'state:Unknown') -or ($line -match 'Default Web Site')) {
        Write-Host ('About to Skip {0}' -f $line)
        $continue_flag = $true
        # TODO: debug
        # continue
      }

      if (-not $continue_flag) {
        if ($line -match 'SITE\s+"(\w+)"\s+\((.+)\)$') {
          Write-Host 'Extract Site ID information'
          $site_alias = $matches[1]
          $site_configuration = $matches[2]
          $site_bound_ip_address = extract_site_internal_order -Line $line

          $iis_bound_addresses[$site_alias] = $site_bound_ip_address
        }
      }
    }
  }
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
      $data3_ref = ([ref]$local:data3)
      get_remote_appcmd_order -remotecomputer $node -data_ref $data3_ref
      # flatten the data
      <#

   {
   "value":  "192.168.0.1",
   "PSComputerName":  "node.domain.com",
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
    'EXPRESSION' = '^node.*n1\.';
    'DOMAIN' = '(?:DOMAIN1|DOMAIN2)';
  };
};

$ENVIRONMENTS_STRUCTURED = @{

  'PROD_HQ' = @{
    'COMMENT' = 'Web Servers';
    'DOMAIN' = 'domain';
    'LOGONSERVER' = '(?:server4|server3)';
    'SERVERS' =
    @(

      'xxxxxx',
    );
  };

}


$scope = $environment
if ($scope -eq '') {
  $scope = 'debug'
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
  $ENVIRONMENTS_CUSTOM.Keys | ForEach-Object {
    $role = $_

    ## TODO select 
    if ($scope -ne $null -and $scope -ne '' -and $role -ne $scope) {
     return 
    }

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

    # TODO - reenable
    $DebugPreference = 'Continue';
    Write-Debug $scope
    $results = collect_inventory $nodes
    squash_json -results $results -FileName ('{0}.json' -f $role)


  }
}
# Out-File -FilePath 'result2.json' -Encoding ASCII -InputObject $raw_rowset_data
# 
return

