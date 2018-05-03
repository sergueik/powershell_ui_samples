
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
    Write-output $_
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
    $scriptDirectory = (Get-Variable PSScriptRoot).Value
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
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value
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

$filename = 'environment.yaml'
$data = (Get-Content -Path ([System.IO.Path]::Combine((Get-ScriptDirectory),$filename))) -join "`n"

write-debug $data
$stringReader = New-Object System.IO.StringReader ($data)

$deserializer = New-Object -TypeName 'YamlDotNet.Serialization.Deserializer' -ArgumentList $null, $null, $false
$yaml_obj = $deserializer.Deserialize([System.IO.TextReader]$stringReader)
# $yaml_obj | get-member
# $yaml_obj.Keys |  format-list


# convert hash into PSCustomObject

# http://stackoverflow.com/questions/3740128/pscustomobject-to-hashtable
$result = @{}
$yaml_obj.Keys | foreach-object { 
  $hostname = $_; 
  $data = $yaml_obj[$_]
  $pscustom_obj = new-object -typeName 'PSObject' -Property $data
  # $pscustom_obj
  # Convert the PSCustomObject back to a hashtable
  $hash2_obj = @{}
  $pscustom_obj.psobject.properties | where-object { $_ -match '(?:datacenter|branch_name|consul_node_name|environment)' } | foreach-Object { 
    $hash2_obj[$_.Name] = $_.Value 
  } 
  $result[$hostname] = $hash2_obj
}


$json_obj = $result | convertto-json
$data = $json_obj | convertfrom-json

$data

# map exact names to short names
$short_names = @{
  'iam-identity-manager-initial'   = 'identity';
  'apim-content-delivery-0'        = 'content';
  'apim-api-manager-store-0'       = 'store';
  'apim-api-manager-store-1'       = 'store';
  'apim-ap-manager-publisher-0'    = 'publisher';
  'apim-api-manager-key-manager-0' = 'keymanager';
  'apim-api-manager-key-manager-1' = 'keymanager';
  'service-discovery-server-0'     = 'discovery';
  'service-discovery-server-1'     = 'discovery';
}
# TCP ports 
$ports = @{
  'content'   = 8443;
  'identity'  = 8443;
  'discovery' = 8500;
  'publisher' = 9443;
  'gateway'   = 9443;
}
$protocols = @{
  'identity'  = 'https';
  'discovery' = 'http';
  'publisher' = 'https';
  'gateway'   = 'https';
}
$landing_pages = @{
  'identity'  =  '#';
  'discovery' = 'ui';
  'publisher' = 'publisher';
  'gateway'   = 'carbon';
}

$reverse_result = @{}
# only collect what we can process
$match_exporession = ('(?:{0})' -f ([String]::join('|', ($short_names.keys | foreach-object { $_ = $_ -replace '\-', '\-'; write-output $_ ;} ))))
$environments = @{}
$branch_names = @{}
$datacenters = @{}
$roles = @{}
$result.keys | foreach-object {
 
  $hostname = $_;
  if ($result[$hostname]['consul_node_name'] -ne $null) {
    if ($result[$hostname]['consul_node_name'] -match $match_exporession ) {
      $node_name = $result[$hostname]['consul_node_name']
      $short_node_name = $short_names[$result[$hostname]['consul_node_name']]
      $environment = $result[$hostname]['environment']
      $datacenter = $result[$hostname]['datacenter']
      $branch_name = $result[$hostname]['branch_name']
      $key = ('{0}|{1}|{2}|{3}' -f $environment, $branch_name, $result[$hostname]['consul_node_name'], $datacnter );
      try { 
        $protocol = $protocols[$short_node_name] 
        $landing_page = $landing_pages[$short_node_name] 
        $port = $ports[$short_node_name]  
        $reverse_result[$key] = ('{0}://{1}:{2}/{3}'-f $protocol, $hostname,$port,$landing_page)       
        $roles[$node_name] = 1 
      } catch [Exception] { 
        write-output ('Failed to process "{0}"|"{1}"' -f $node_name, $short_node_name)
      }
        $environments[$environment] = 1
        $datacenters[$datacenter] = 1 
        $branch_names[$branch_name] = 1
    }
  }
}
write-output 'Results for lookup:'
$reverse_result | format-list

write-output 'Datacenters:'
$datacenters.keys | format-list

write-output 'Environments:'
$environments.keys | format-table

write-output 'Roles:'
$roles.keys | format-table