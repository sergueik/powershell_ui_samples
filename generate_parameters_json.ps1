$filename = 'environment.json'

$data = (Get-Content -Path ([System.IO.Path]::Combine((Get-ScriptDirectory),$filename))) -join "`n"

write-debug $data

$json_obj = convertfrom-json -inputobject $data
# $json_obj is already a PSCustomObject
$result = @{}

# https://stackoverflow.com/questions/18779762/iterating-through-key-names-from-a-pscustomobject?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
# Convert the PSCustomObject back to a hashtable

$json_obj | Get-Member -MemberType NoteProperty | foreach-object {
  $hostname =  $_.Name
  $result[$hostname]  = @{}
  $data = $json_obj."$($_.Name)"
  $data_hash_obj = @{}
    $data |  get-member -MemberType NoteProperty | foreach-object {
    $key = $_.name
    $value = $data."$(${key})"
    $data_hash_obj[$key] = $value
  }

  $result[$hostname] = $data_hash_obj
}

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