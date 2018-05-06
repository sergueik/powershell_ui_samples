$filename = 'environment.json'
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


$data = (Get-Content -Path ([System.IO.Path]::Combine((Get-ScriptDirectory),$filename))) -join "`n"

Write-Debug $data

$json_obj = ConvertFrom-Json -InputObject $data
# $json_obj is already a PSCustomObject
$result = @{}

# https://stackoverflow.com/questions/18779762/iterating-through-key-names-from-a-pscustomobject?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
# Convert the PSCustomObject back to a hashtable

$json_obj | Get-Member -MemberType NoteProperty | ForEach-Object {
  $hostname = $_.Name
  $result[$hostname] = @{}
  $data = $json_obj."$($_.Name)"
  $data_hash_obj = @{}
  $data | Get-Member -MemberType NoteProperty | ForEach-Object {
    $key = $_.Name
    $value = $data."$(${key})"
    $data_hash_obj[$key] = $value
  }

  $result[$hostname] = $data_hash_obj
}

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
