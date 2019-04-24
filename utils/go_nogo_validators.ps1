param(
  [Parameter(Position = 0)]
  [string]$environment

)

function convert_to_unc2 {
  param(
    [string]$mixed_path
  )
  $unc_file_path = $mixed_path -replace ':','$'
  return $unc_file_path
}

#######
function assert_config_data {
  param(
    [ValidateNotNull()]
    [string]$target_domain,
    [string]$target_unc_path,
    [scriptblock]$script_block,
    [bool]$powerless,
    [bool]$debug

  )

  if (($target_domain -eq $null) -or ($target_domain -eq '')) {
    Write-Output 'unspecified DOMAIN'
    if ($powerless) {
      return
    } else {
      throw
    }
  }
  if (-not ($target_domain -match $env:USERDOMAIN)) {
    # mock up can be passed the domain. 
    Write-Output 'Unreachable DOMAIN'
    # real run swill about
    if ($powerless) {
      return
    } else {
      throw
    }
  }

  Write-Host ('Probing "{0}"' -f $target_unc_path)
  [xml]$xml_config = Get-Content -Path $target_unc_path
  $object_ref = ([ref]$xml_config)
  $result = @()
  $result_ref = ([ref]$result)

  Invoke-Command $script_block -ArgumentList $object_ref,$result_ref

  Write-Host ("Result:`n---`n{0}`n---`n" -f ($result -join "`n" ))
  # B {Write-Host 2; &$block}.GetNewClosure()
}


[scriptblock]$CONFIGURATION_DISCOVERY = {
  param(
    [System.Management.Automation.PSReference]$object_ref,
    [System.Management.Automation.PSReference]$result_ref)
  $data = @()
  if ($debug) {
    Write-Host $object_ref.Value
    Write-Host $object_ref.Value.connectionStrings
    Write-Host $object_ref.Value.connectionStrings.add
  }
  $nodes = $object_ref.Value.connectionStrings.add
  if ($debug) {
    Write-Host $nodes.count
  }
  for ($cnt = 0; $cnt -ne $nodes.count; $cnt++) {
    $data += $object_ref.Value.connectionStrings.add[$cnt].connectionString
  }
  if ($debug) {
    Write-Host 'Data:'
    Write-Host $data
  }
  $result_ref.Value = $data
}


$configuration_paths = @{
  'Sitecore' =
  @{
    'COMMENT' = 'Servers';
    'PATH' = 'c:\Website\App_Config\ConnectionStrings.config';
    'DOMAIN' = 'domain';
    'SERVERS' = @(
      'server1',
      'server2',
      $null
    );
  };
};


foreach ($role in $configuration_paths.Keys) {
  $configuration = $configuration_paths.Item($role)
  Write-Output ('Starting {0}' -f $configuration['COMMENT'])
  if ($configuration.Containskey('SERVERS')) {
    $servers = $configuration['SERVERS']
    $unc_paths = @()
    $configuration['RESULTS'] = @{}  # keyed by server
    $configuration_details = @{ }
    $servers | ForEach-Object { $server = $_; if ($server -eq $null) { return } $unc_paths += convert_to_unc2 (('\\{0}\{1}' -f $server,$configuration['PATH'])) 
    }
  }
  elseif ($configuration.Containskey('UNC_PATHS')) {
    $unc_paths = $configuration['UNC_PATHS']

  }
  [scriptblock]$script_block = $CONFIGURATION_DISCOVERY
  Write-Output ( "Inspecfing nodes in the domain {0}" -f $configuration['DOMAIN'] )
  $unc_paths | ForEach-Object { $target_unc_path = $_; if ($target_unc_path -eq $null) { return } 
  $configuration_details[$target_unc_path] = @() 
  assert_config_data -target_domain $configuration['DOMAIN'] `
                     -target_unc_path $target_unc_path `
                     -powerless $true `
                     -script_block $script_block }

}


<# Business logic 
# 2.	On the webservers (web21, ... web31) should point to NON _parallel databases

 1.	Look at connection strings config file 
# proceed or skip based on domain
#>
