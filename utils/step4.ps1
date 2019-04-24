# Update certain elements within the web.config of prod-preview (web.config)
# descendant  of 

# go_nogo_validators.ps1
# update_prod_preview.ps1

param(
  [Parameter(Position = 0)]
  [string]$environment,
  [string]$domain = $env:USERDOMAIN
  # need $host.Version.major ~> 3
)

function convert_to_unc2 {
  param(
    [string]$mixed_path
  )
  $unc_file_path = $mixed_path -replace ':','$'
  return $unc_file_path
}



$attributes_preview = @{
  'imagesCdnHostToPrepend' = 'http://prodpreview.carnival.com';
  'SecureLoginUrl' = 'https://prodpreview.carnival.com/SignInTopSSL.aspx';
  'CarnivalHeaderHtmlUrl' = 'http://prodpreview.carnival.com/service/header.aspx';
  'CarnivalFooterHtmlUrl' = 'http://prodpreview.carnival.com/service/footer.aspx';
  'SecureUrl' = 'https://prodpreview.carnival.com/';
  'DefaultRobotsDomain' = 'prodpreview.carnival.com';
  'DeckPlanServiceDomain' = 'prodpreview.carnival.com';
  'USDomain' = 'prodpreview.carnival.com, prodpreview.carnival.com';
  'UKDomain' = 'prodpreviewuk.carnival.com, prodpreviewuk.carnival.com';
  'UKDomains' = 'prodpreviewuk.carnival.com, prodpreviewuk.carnival.com';
  'FullSiteURL' = 'http://prodpreview.carnival.com';
  'RESTProxyDomain' = 'http://prodpreview.carnival.com';
  'PersonalizationDomain' = 'prodpreview.carnival.com';

}

[scriptblock]$Extract_appSettings = {
  param(
    [System.Management.Automation.PSReference]$object_ref,
    [System.Management.Automation.PSReference]$result_ref,
    # Position must be last
    [string]$key = $null
  )


  $data = @{}
  $debug = $false
  if ($false -and $debug) {
    Write-Host $object_ref.Value
    Write-Host $object_ref.Value.Configuration
    Write-Host $object_ref.Value.Configuration.location.appSettings.add
  }
  $nodes = $object_ref.Value.Configuration.location.appSettings.add
  if ($debug) {
    Write-Host $nodes.count
  }
  for ($cnt = 0; $cnt -ne $nodes.count; $cnt++) {
    # $data += $Value.configuration.location.appSettings.add[$cnt].value
    # extract and  keep the data source  throw away the rest

    $k = $object_ref.Value.Configuration.location.appSettings.add[$cnt].Getattribute('key')
    $v = $object_ref.Value.Configuration.location.appSettings.add[$cnt].Getattribute('value')


    if ($k -match $key) {

      if ($debug) {
        Write-Host $k
        Write-Host $key

        Write-Output '!'
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


[scriptblock]$Extract_SpecificApSetting = {
  param(
    [System.Management.Automation.PSReference]$object_ref,
    [System.Management.Automation.PSReference]$result_ref,
    [string]$key = $null
  )

  if ($key -eq $null -or $key -eq '') {
    throw 'Key cannot be null'

  }
  [scriptblock]$s = $Extract_appSettings
  $local:result = $null
  Invoke-Command $s -ArgumentList $object_ref,([ref]$local:result),$key
  $result_ref.Value = $local:result
}


[scriptblock]$Extract_SpecificRuleActionurl = {
  param(
    [System.Management.Automation.PSReference]$object_ref,
    [System.Management.Automation.PSReference]$result_ref,
    [string]$key = $null
  )

  if ($key -eq $null -or $key -eq '') {
    throw 'Key cannot be null'

  }
  [scriptblock]$s = $Extract_RuleActionurls
  $local:result = $null
  Invoke-Command $s -ArgumentList $object_ref,([ref]$local:result),$key
  $result_ref.Value = $local:result
}


$attributes_extraction_code = @{
   'Exit SSL cms targetted offers' = ;
  'SecureLoginUrl' = $Extract_SpecificRuleActionurl;
}

# 
# 
# configuration/location/system.webServer/rewrite/rules/rule

[scriptblock]$Extract_RuleActionurls = {
  param(
    [System.Management.Automation.PSReference]$object_ref,
    [System.Management.Automation.PSReference]$result_ref,
    # Position must be last
    [string]$key = $null
  )


  $data = @{}
  $debug = $false
  $nodes = $object_ref.Value.Configuration.location.'system.webServer'.rewrite.rules.rule
  if ($debug) {
    Write-Host $nodes.count
  }
  for ($cnt = 0; $cnt -ne $nodes.count; $cnt++) {

    $k = $nodes[$cnt].Getattribute('name')
    $v = $nodes[$cnt].action.Getattribute('url')
    if ($k -match $key) {  # !!
     # e.g.
     # if ($k -match 'Exit SSL cms targetted offers' ) {
      $data[$k] += $v
     # write-output $k; write-output $v

    }

  }

  $result_ref.Value = $data[$key]
}


[scriptblock]$Update_appSettings = {
  param(
    [System.Management.Automation.PSReference]$object_ref,
    # Position must be last
    [string]$key = $null,
    [string]$value = $null
  )


  $data = @{}
  $debug = $false
  if ($false -and $debug) {
    Write-Host $object_ref.Value
    Write-Host $object_ref.Value.Configuration
    Write-Host $object_ref.Value.Configuration.location.appSettings.add
  }
  $nodes = $object_ref.Value.Configuration.location.appSettings.add
  if ($debug) {
    Write-Host $nodes.count
  }
  for ($cnt = 0; $cnt -ne $nodes.count; $cnt++) {

    $k = $object_ref.Value.Configuration.location.appSettings.add[$cnt].Getattribute('key')

    if ($k -match $key) {
      Write-Output ('Updating {0} with {1}' -f $k,$value)
      $object_ref.Value.Configuration.location.appSettings.add[$cnt].Setattribute('value',$value)
    }

  }

}


[scriptblock]$Update_SpecificApSetting = {
  param(
    [System.Management.Automation.PSReference]$object_ref,
    [string]$key = $null 
  )

  if ($key -eq $null -or $key -eq '') {
    throw 'Key cannot be null'
  }
  $local:value = $attributes_modified[$key]
  if ($local:value -eq $null) {
    [string] $error_msg  =  ('Key not fully specified. Need to know $attributes_modified[{0}]' -f $key )
    throw $error_msg
   } 

  [scriptblock]$s = $Update_appSettings
  Invoke-Command $s -ArgumentList $object_ref,$key,$local:value
}


[scriptblock]$Update_imagesCdnHostToPrepend = {
  param(
    [System.Management.Automation.PSReference]$object_ref,
    [string]$key = 'imagesCdnHostToPrepend' 
  )
  $local:value = $attributes_modified[$key]
  if ($local:value -eq $null) {
    [string] $error_msg  =  ('Key not fully specified. Need to know $attributes_modified[{0}]' -f $key )
    throw $error_msg
  }

  $k = $object_ref.Value.Configuration.JACombinerAndOptimizerGroup.combinerSettings.Getattribute($key)
    if ($k -ne $null) {
      Write-Output ('Updating {0} with {1}' -f $k, $value)
      $object_ref.Value.Configuration.JACombinerAndOptimizerGroup.combinerSettings.Setattribute($key,$value)
    }
}

$attributes_setter_code = @{
'imagesCdnHostToPrepend' = $Update_imagesCdnHostToPrepend;
'USDomain' = $Update_SpecificApSetting;

'UKDomains' = $Update_SpecificApSetting;

'UKDomain' = $Update_SpecificApSetting;

'RESTProxyDomain' = $Update_SpecificApSetting;

'PersonalizationDomain' = $Update_SpecificApSetting;

'CarnivalHeaderHtmlUrl' = $Update_SpecificApSetting;

'DeckPlanServiceDomain' = $Update_SpecificApSetting;

'SecureUrl' = $Update_SpecificApSetting;

'FullSiteURL' = $Update_SpecificApSetting;

'CarnivalFooterHtmlUrl' = $Update_SpecificApSetting;

'DefaultRobotsDomain' = $Update_SpecificApSetting;

'SecureLoginUrl' = $Update_SpecificApSetting;


}


$attributes_modified = @{

'UKDomains' = 'https://aaa';

'DefaultRobotsDomain' = 'https://bb';

'UKDomain' = 'https://ccc';

'RESTProxyDomain' = 'https://ddd';

'USDomain' = 'https://eee';

'DeckPlanServiceDomain' = 'https://fff';

'SecureUrl' = 'https://ggg';

'FullSiteURL' = 'https://yyy';

'PersonalizationDomain' = 'https://hhh';

'CarnivalHeaderHtmlUrl' = 'https://iii';

'CarnivalFooterHtmlUrl' = 'https://jjj';

'SecureLoginUrl' = 'https://kkk';

'imagesCdnHostToPrepend' = 'https://zzz';

}



function report_config_data {
  param(
    [System.Management.Automation.PSReference]$object_ref,
    [bool]$debug
  )
  $debug = $true
  if ($debug) {
    Write-Host 'report_config_data'
  }
  $local:data = $object_ref.Value

  $local:data.Keys | ForEach-Object {
    $unc_path = $_
    if ($debug) {
      Write-Host ('Probing configurations from: "{0}"' -f $unc_path)
    }
    $local:data[$unc_path] | ForEach-Object {
        Write-Host $_
    }
  }
}


function collect_config_data {

  param(
    [ValidateNotNull()]
    [string]$target_domain,
    [string]$target_unc_path,
    [scriptblock]$script_block,
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
  if ($verbose) {
    Write-output ('Probing "{0}"' -f $target_unc_path) | out-file 'data.log' -append -encoding ascii
  }

  [xml]$xml_config = Get-Content -Path $target_unc_path
  $object_ref = ([ref]$xml_config)

#----------- print the result 


$attributes_preview.Keys | ForEach-Object {
  $k = $_
  $v = $attributes_preview[$k]
  [scriptblock]$s = $attributes_extraction_code[$k]
  if ($s -ne $null) {
    $local:result = $null
    $result_ref = ([ref]$local:result)
    Invoke-Command $s -ArgumentList $object_ref,$result_ref,$k
    Write-Output ('{0}  = {1}' -f $k,$result_ref.Value)
  } else {
    Write-Output ('extract function not defined for {0}' -f $k)
  }
}
#-----------

#----------- update w/o saving 


$attributes_setter_code.Keys | ForEach-Object {
  $k = $_
  $v = $attributes_preview[$k]
  [scriptblock]$s = $attributes_setter_code[$k]
  if ($s -ne $null) {
    $local:result = $null
    $result_ref = ([ref]$local:result)
    Invoke-Command $s -ArgumentList $object_ref,$k

  } else {
  }
}

#-----------
  $result_ref = ([ref]$local:result)

  return $local:result


}


[scriptblock]$CONFIGURATION_DISCOVERY = {
  param(
    [System.Management.Automation.PSReference]$object_ref,
    [System.Management.Automation.PSReference]$result_ref)
  $data = @()

  $result_ref.Value = $data
}

$configuration_paths = @{
  'Preview' =
  @{
    'COMMENT' = 'Production Preview Servers ConnectionStrings.config';
    'PATH' = 'E:\Projects\prod.carnival.com\Carnival\Web.config';
    'DOMAIN' = 'CARNIVAL';
    'SERVERS' = @(
      'xxxxxx',
      $null
    );
  };

};

foreach ($role in $configuration_paths.Keys) {
  $configuration = $configuration_paths.Item($role)
  Write-Output ('Starting {0}' -f $configuration['COMMENT'])
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
    [scriptblock]$script_block = $CONFIGURATION_DISCOVERY
    Write-Output ("Inspecfing nodes in the domain {0}" -f $configuration['DOMAIN'])
    $unc_paths | ForEach-Object { $target_unc_path = $_; if ($target_unc_path -eq $null) { return }
      $configuration_results[$target_unc_path] = @()
      $configuration_results[$target_unc_path] = collect_config_data -target_domain $configuration['DOMAIN'] `
         -target_unc_path $target_unc_path `
         -powerless $true `
         -script_block $script_block
    }

    $configuration['RESULTS'] = $configuration_results
    # in this  scope it is better con collapse the results - nesting is too deep
    # don't care that many settings are redundant: about to offer interactive 
    # Print the miss(es) to console 
    report_config_data -object_ref ([ref]$configuration_results)
  }
}


