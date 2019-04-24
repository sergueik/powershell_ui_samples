
param(
  [Parameter(Position = 0)]
  [switch]$prod,# UNUSED 
  [string]$domain = $env:USERDOMAIN
  # need $host.Version.major ~> 3
)

$global:timestamp = (Get-Date).ToString("yy_MM_dd_HH_MM")

[bool]$to_prod = $false

if ($PSBoundParameters["prod"]) {
  $to_prod = $true
} else
{
  $to_prod = $false
}


$global:debug = $false;

function backup_file {
  param([string]$filename,[bool]$whatif = $true)

  # This is not really a basename
  if ($filename -match '(.+)\.([^\.]+)$') {
    $extension = $matches[2]
    $basename = $matches[1]
  }
  if ($whatif) {
    Copy-Item $filename -Destination ('{0}-{1}.{2}' -f $basename,$global:timestamp,$extension) -WhatIf
  } else {
    Copy-Item $filename -Destination ('{0}-{1}.{2}' -f $basename,$global:timestamp,$extension) -WhatIf
  }  return
}

function convert_to_unc2 {
  param(
    [string]$mixed_path
  )
  $unc_file_path = $mixed_path -replace ':','$'
  return $unc_file_path
}



$attributes_prod = @{
  'RESTProxyDomain' = 'http://www.server.com';
}


$attributes_preview = @{
  'RESTProxyDomain' = 'http://preview.server.com';
}

[scriptblock]$Extract_appSetting = {
  param(
    [System.Management.Automation.PSReference]$object_ref,
    [System.Management.Automation.PSReference]$result_ref,
    [string]$key = $null
  )

  if ($key -eq $null -or $key -eq '') {
    throw 'Key cannot be null'

  }

  $data = @{}
  $nodes = $object_ref.Value.Configuration.location.appSettings.add
  for ($cnt = 0; $cnt -ne $nodes.count; $cnt++) {
    # FIXME
    $k = $nodes[$cnt].Getattribute('key')
    $v = $nodes[$cnt].Getattribute('value')


    if ($k -match $key) {

      if ($global:debug) {
        Write-Host $k
        Write-Host $key
        Write-Host $v
      }
      $data[$k] += $v

    }

  }

  $result_ref.Value = $data[$key]
}


[scriptblock]$Extract_imagesCdnHostToPrepend = {
  param(
    [System.Management.Automation.PSReference]$object_ref,
    [System.Management.Automation.PSReference]$result_ref,
    [string]$key = $null # ignored
  )
  $result_ref.Value = $object_ref.Value.Configuration.JACombinerAndOptimizerGroup.combinerSettings.Getattribute("imagesCdnHostToPrepend")
}



[scriptblock]$Extract_RuleActionurl = {
  param(
    [System.Management.Automation.PSReference]$object_ref,
    [System.Management.Automation.PSReference]$result_ref,
    [string]$key = $null
  )

  if ($key -eq $null -or $key -eq '') {
    throw 'Key cannot be null'

  }

  $data = @{}
  $nodes = $object_ref.Value.Configuration.location.'system.webServer'.rewrite.rules.rule
  if ($global:debug) {
    Write-Host $nodes.count
  }
  for ($cnt = 0; $cnt -ne $nodes.count; $cnt++) {

    $k = $nodes[$cnt].Getattribute('name')
    $v = $nodes[$cnt].action.Getattribute('url')
    if ($k -match $key) {
      $data[$k] += $v
      if ($global:debug) {
        # write-output $k; write-output $v
      }
    }

  }

  $result_ref.Value = $data[$key]
}



$attributes_extraction_code = @{
  'RESTProxyDomain' = $Extract_AppSetting;
}


[scriptblock]$Update_appSetting = {
  param(
    [System.Management.Automation.PSReference]$object_ref,
    [string]$key = $null,
    [string]$value = $null
  )

  if ($key -eq $null -or $key -eq '') {
    throw 'Key cannot be null'
  }
  $local:value = $attributes_modified[$key]
  if ($local:value -eq $null) {
    [string]$error_msg = ('Key not fully specified. Need to know $attributes_modified[{0}]' -f $key)
    throw $error_msg
  }


  $data = @{}

  $nodes = $object_ref.Value.Configuration.location.appSettings.add
  for ($cnt = 0; $cnt -ne $nodes.count; $cnt++) {

    $k = $object_ref.Value.Configuration.location.appSettings.add[$cnt].Getattribute('key')

    if ($k -match $key) {
      Write-Host ('Updating [{0}] with [{1}]' -f $k,$value)
      $object_ref.Value.Configuration.location.appSettings.add[$cnt].Setattribute('value',$value)
    }

  }

}

[scriptblock]$Update_imagesCdnHostToPrepend = {
  param(
    [System.Management.Automation.PSReference]$object_ref,
    [string]$key = 'imagesCdnHostToPrepend'
  )
  $local:value = $attributes_modified[$key]
  if ($local:value -eq $null) {
    [string]$error_msg = ('Key not fully specified. Need to know $attributes_modified[{0}]' -f $key)
    throw $error_msg
  }

  $k = $object_ref.Value.Configuration.JACombinerAndOptimizerGroup.combinerSettings.Getattribute($key)
  if ($k -ne $null) {
    Write-Host ('Updating [{0}] with [{1}]' -f $k,$value)
    $object_ref.Value.Configuration.JACombinerAndOptimizerGroup.combinerSettings.Setattribute($key,$value)
  }
}


[scriptblock]$Update_RuleActionurl = {
  param(
    [System.Management.Automation.PSReference]$object_ref,
    [string]$key = $null,
    [string]$value = $null
  )



  if ($key -eq $null -or $key -eq '') {
    throw 'Key cannot be null'
  }
  $local:value = $attributes_modified[$key]
  if ($local:value -eq $null) {
    [string]$error_msg = ('Key not fully specified. Need to know $attributes_modified[{0}]' -f $key)
    throw $error_msg
  }

  $data = @{}

  $nodes = $object_ref.Value.Configuration.location.'system.webServer'.rewrite.rules.rule

  for ($cnt = 0; $cnt -ne $nodes.count; $cnt++) {

    $k = $nodes[$cnt].Getattribute('name')
    $v = $nodes[$cnt].action.Getattribute('url')

    if ($k -match $key) {
      Write-Host ('Updating {0}[{1}] with [{2}]' -f $k,$v,$value)

      # only one  
      $object_ref.Value.Configuration.location.'system.webServer'.rewrite.rules.rule[$cnt].action.Setattribute('url',$value)

    }

  }

}


$attributes_setter_code = @{
  'RESTProxyDomain' = $Update_appSetting;
}

function collect_config_data {

  param(
    [ValidateNotNull()]
    [string]$target_domain,
    [string]$target_unc_path,
    [bool]$powerless,
    [bool]$verbose,
    [bool]$debug
  )

  $local:result = @()
  $verbose = $true
  if (($target_domain -eq $null) -or ($target_domain -eq '')) {
    # Write-Output 'unspecified DOMAIN'
    if ($powerless) {
      return $local:result
    } else {
      throw
    }
  }
  if (-not ($target_domain -match $env:USERDOMAIN)) {
    # mock up can be passed the domain. 

    # gets into the result...
    # Write-Output 'Unreachable DOMAIN'
    # real run swill about
    if ($powerless) {
      return $local:result
    } else {
      throw
    }
  }

  backup_file -File $target_unc_path
  if ($verbose) {
    Write-Output ('Probing "{0}"' -f $target_unc_path) | Out-File 'data.log' -Append -Encoding ascii
  }

  [xml]$xml_config = Get-Content -Path $target_unc_path
  $object_ref = ([ref]$xml_config)

  #----------- print the 

  Write-Host 'Current settings'

  $attributes_preview.Keys | ForEach-Object {
    $k = $_
    $v = $attributes_preview[$k]
    [scriptblock]$s = $attributes_extraction_code[$k]
    if ($s -ne $null) {
      $local:result = $null
      $result_ref = ([ref]$local:result)
      Invoke-Command $s -ArgumentList $object_ref,$result_ref,$k
      Write-Host ('{0}  = {1}' -f $k,$result_ref.Value)
    } else {
      Write-Host ('extract function not defined for {0}' -f $k)
      # TODO: throw
    }
  }

  #----------- update w/o saving 
  Write-Host 'Update settings'

  if ($to_prod) {
    $attributes_modified = $attributes_prod;
  } else {
    $attributes_modified = $attributes_preview;
  }
  $attributes_setter_code.Keys | ForEach-Object {
    $k = $_
    $v = $attributes_preview[$k]
    [scriptblock]$s = $attributes_setter_code[$k]
    if ($s -ne $null) {
      $local:result = $null
      $result_ref = ([ref]$local:result)
      Invoke-Command $s -ArgumentList $object_ref,$k

    } else {
      # FIXME  
    }
  }
  # OPTIONAL -  write to alt name, read alt. name 
  # TODO: save



  $filename = $target_unc_path
  # This is not really a basename
  if ($filename -match '(.+)\.([^\.]+)$') {
    $extension = $matches[2]
    $basename = $matches[1]
  }

  $tempname = ('{0}-{1}.{2}' -f $basename,$global:timestamp,$extension)
  $new_config_file_path = $tempname

  Write-Host ('Saving to "{0}" ' -f $new_config_file_path)
  $object_ref.Value.Save($new_config_file_path)

  Start-Sleep 3

  [xml]$xml_config = Get-Content -Path $new_config_file_path
  $object_ref = ([ref]$xml_config)
  # ---

  #----------- print the modified  settings
  Write-Host 'Modified  settings'
  $attributes_preview.Keys | ForEach-Object {
    $k = $_
    $v = $attributes_preview[$k]
    [scriptblock]$s = $attributes_extraction_code[$k]
    if ($s -ne $null) {
      $local:result = $null
      $result_ref = ([ref]$local:result)
      Invoke-Command $s -ArgumentList $object_ref,$result_ref,$k
      Write-Host ('{0}  = {1}' -f $k,$result_ref.Value)

    } else {
      Write-Host ('extract function not defined for {0}' -f $k)
    }
  }



  # FIXME 
  #-----------
  $result_ref = ([ref]$local:result)

  return $local:result


}

$configuration_paths = @{
  'Preview' =
  @{
    'COMMENT' = 'ConnectionStrings.config';
    'PATH' = 'E:\Project\Web.config';
    'DOMAIN' = 'domain';
    'SERVERS' = @(
      'xxxxxx',
      $null
    );
  };

};

foreach ($role in $configuration_paths.Keys) {
  $configuration = $configuration_paths.Item($role)
  Write-Host ('Starting {0}' -f $configuration['COMMENT'])
  # check if we can skip unreachable domain results , 
  # by returning the status from collect_config_data
  # for simplicity skip if not current domain  
  if ($configuration['DOMAIN'] -eq $domain) {
    if ($configuration.Containskey('SERVERS')) {
      $servers = $configuration['SERVERS']
      $unc_paths = @()
      $configuration['RESULTS'] = @{} # keyed by server
      $configuration_results = @{}
      $servers | ForEach-Object { $server = $_; if ($server -eq $null) { return } $unc_paths += convert_to_unc2 (('\\{0}\{1}' -f $server,$configuration['PATH']))
      }
    }
    elseif ($configuration.Containskey('UNC_PATHS')) {
      $unc_paths = $configuration['UNC_PATHS']

    } else {
      # TODO handle malformed configurations 
    }
    Write-Output ("Inspecfing nodes in the domain {0}" -f $configuration['DOMAIN'])
    $unc_paths | ForEach-Object { $target_unc_path = $_; if ($target_unc_path -eq $null) { return }
      $configuration_results[$target_unc_path] = @()
      $configuration_results[$target_unc_path] = collect_config_data -target_domain $configuration['DOMAIN'] `
         -target_unc_path $target_unc_path `
         -powerless $true

      # 'powerless'  is currently unused 
    }

  }
}



