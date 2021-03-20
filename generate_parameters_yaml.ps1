param(
  [String]$filename = 'environment.yaml'

)

$debugpreference='continue'
# https://github.com/aaubry/YamlDotNet
# see also https://www.codeproject.com/Articles/28720/YAML-Parser-in-C
# https://github.com/scottmuc/PowerYaml
function load_shared_assemblies {

  param(
    [string]$shared_assemblies_path = "${env:USERPROFILE}\Downloads",

    [string[]]$shared_assemblies = @(
      'YamlDotNet.dll' # https://www.nuget.org/packages/YamlDotNet
    )
  )
  pushd $shared_assemblies_path

  $shared_assemblies | ForEach-Object {
    Unblock-File -Path $_
    Write-Output $_
    Add-Type -Path $_
  }
  popd
}

# http://poshcode.org/2887
# http://stackoverflow.com/questions/8343767/how-to-get-the-current-directory-of-the-cmdlet-being-executed
# https://msdn.microsoft.com/en-us/library/system.management.automation.invocationinfo.pscommandpath%28v=vs.85%29.aspx
function Get-ScriptDirectory
{
  [string]$scriptDirectory = $null

  if ($host.Version.Major -gt 2) {
    $scriptDirectory = (Get-Variable PSScriptRoot).value
    Write-Debug ('$PSScriptRoot: {0}' -f $scriptDirectory)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }
    $scriptDirectory = [System.IO.Path]::GetDirectoryName($MyInvocation.PSCommandPath)
    Write-Debug ('$MyInvocation.PSCommandPath: {0}' -f $scriptDirectory)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }

    $scriptDirectory = Split-Path -Parent $PSCommandPath
    Write-Debug ('$PSCommandPath: {0}' -f $scriptDirectory)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }
  } else {
    $scriptDirectory = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }
    $Invocation = (Get-Variable MyInvocation -Scope 1).value
    if ($Invocation.PSScriptRoot) {
      $scriptDirectory = $Invocation.PSScriptRoot
    } elseif ($Invocation.MyCommand.Path) {
      $scriptDirectory = Split-Path $Invocation.MyCommand.Path
    } else {
      $scriptDirectory = $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf('\'))
    }
    return $scriptDirectory
  }
}

load_shared_assemblies  
write-output ('YAML file: {0}' -f ([System.IO.Path]::Combine((Get-location),$filename)))  
$data = (Get-Content -Path ([System.IO.Path]::Combine((Get-location),$filename))) -join "`n"

write-output ("YAML data:`n{0}" -f $data)
	
$stringReader = new-object System.IO.StringReader($data)

$deserializer = new-object -TypeName 'YamlDotNet.Serialization.Deserializer' -ArgumentList $null,$null,$false


$yaml_obj = $deserializer.Deserialize([System.IO.TextReader]$stringReader)

# https://github.com/cloudbase/powershell-yaml/blob/master/powershell-yaml.psm1

$builder = new-object -TypeName 'YamlDotNet.Serialization.SerializerBuilder'

$builder.Build()
	

# trouble accessing the
#    $serializer.WithNamingConvention([YamlDotNet.Serialization.NamingConvention]::CamelCaseNamingConvention.Instance)
#     $serializer.Build()
# $yaml = $serializer.Serialize($yaml_obj)
write-output $yaml

# $yaml_obj | get-member
write-output 'YAML Keys: '
$yaml_obj.Keys |  format-list

# convert hash into PSCustomObject

# http://stackoverflow.com/questions/3740128/pscustomobject-to-hashtable
$result = @{}
$yaml_obj.Keys | ForEach-Object {
  $hostname = $_;
  write-output ( 'key:{0}' -f $hostname)
  $data = $yaml_obj[$hostname]
  # Powershel sort of makes a boundary between arrays and hashes poor
  write-output 'Data:'
  $data_count = $data.Count
  write-output ('data by key {0} count: {1}' -f $hostname, $data_count)
  0..($data_count-1) | foreach-object {
  $cnt = $_
  write-output ('row {0}' -f $cnt)
  $row =  $data[$cnt]
  # $data | get-member

  write-output 'Row Keys:'
  $row.Keys | format-list
  <#
  $pscustom_obj = new-object -TypeName 'PSObject' -Property $row
  # $pscustom_obj
  # Convert the PSCustomObject back to a hashtable
  $data_hash_obj = @{}
  $pscustom_obj.psobject.properties | Where-Object { $_ -match '(?:datacenter|branch_name|consul_node_name|environment)' } | ForEach-Object {
    $data_hash_obj[$_.Name] = $_.value
  }
  $result[$hostname] = $data_hash_obj
  #>
  }
}

<#
$json_obj = $result | convertto-json
$data = $json_obj | convertfrom-json

$data
#>

# map exact names to short names
$short_names = @{
  'iam-identity-manager-initial' = 'identity';
  'apim-content-delivery-0' = 'content';
  'apim-api-manager-store-0' = 'store';
  'apim-api-manager-store-1' = 'store';
  'apim-ap-manager-publisher-0' = 'publisher';
  'apim-api-manager-key-manager-0' = 'keymanager';
  'apim-api-manager-key-manager-1' = 'keymanager';
  'service-discovery-server-0' = 'discovery';
  'service-discovery-server-1' = 'discovery';
}
# TCP ports 
$ports = @{
  'content' = 8443;
  'identity' = 8443;
  'discovery' = 8500;
  'publisher' = 9443;
  'gateway' = 9443;
}
$protocols = @{
  'identity' = 'https';
  'discovery' = 'http';
  'publisher' = 'https';
  'gateway' = 'https';
}
$landing_pages = @{
  'identity' = '#';
  'discovery' = 'ui';
  'publisher' = 'publisher';
  'gateway' = 'carbon';
}

$reverse_result = @{}
# only collect what we can process
$match_exporession = ('(?:{0})' -f ([string]::join('|',($short_names.Keys | ForEach-Object { $_ = $_ -replace '\-','\-'; Write-Output $_; }))))
$environments = @{}
$branch_names = @{}
$datacenters = @{}
$roles = @{}
$result.Keys | ForEach-Object {

  $hostname = $_;
  if ($result[$hostname]['consul_node_name'] -ne $null) {
    if ($result[$hostname]['consul_node_name'] -match $match_exporession) {
      $node_name = $result[$hostname]['consul_node_name']
      $short_node_name = $short_names[$result[$hostname]['consul_node_name']]
      $environment = $result[$hostname]['environment']
      $datacenter = $result[$hostname]['datacenter']
      $branch_name = $result[$hostname]['branch_name']
      $key = ('{0}|{1}|{2}|{3}' -f $environment,$branch_name,$result[$hostname]['consul_node_name'],$datacnter);
      try {
        $protocol = $protocols[$short_node_name]
        $landing_page = $landing_pages[$short_node_name]
        $port = $ports[$short_node_name]
        $reverse_result[$key] = ('{0}://{1}:{2}/{3}' -f $protocol,$hostname,$port,$landing_page)
        $roles[$node_name] = 1
      } catch [exception]{
        Write-Output ('Failed to process "{0}"|"{1}"' -f $node_name,$short_node_name)
      }
      $environments[$environment] = 1
      $datacenters[$datacenter] = 1
      $branch_names[$branch_name] = 1
    }
  }
}
Write-Output 'Results for lookup:'
$reverse_result | Format-List

Write-Output 'Datacenters:'
$datacenters.Keys | Format-List

Write-Output 'Environments:'
$environments.Keys | Format-Table

Write-Output 'Roles:'
$roles.Keys | Format-Table
