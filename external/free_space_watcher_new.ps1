param(
  [Parameter(Position = 0)]
  [string]$environment

)


function get_wmi_data {
  param(

    [Parameter(Position = 0)]
    [string]$remotecomputer,
    [Parameter(Position = 1)]
    [string]$remotedomain,
    [string]$drivename = 'c:',
    [System.Management.Automation.PSReference]$data_ref


  )

  if (($remotecomputer -eq $null) -or ($remotecomputer -eq '')) {
    Write-Debug 'Invalid call: remotecomputer is blank'
    return
  }
  if (-not ($remotecomputer -match $remotedomain)) {
    Write-Debug 'Invalid call: remotecomputer  need to match remotedomain  (LEGACY)'
    return
  }

  # Write-Output "get_wmi_data ${remotecomputer}  ${remotedomain}"
  $drive = $drivename
  # need another  iteration or query 
  $has_data = $true
  try {
    $w = ([wmi]"\\${remotecomputer}\root\cimv2:Win32_logicalDisk.DeviceID='${drive}'")


  } catch [System.Management.Automation.PSInvalidCastException]{
    $has_data = $false
    Write-Output 'Got and slurped exception'
    # ignore
  } catch [exception]{
    $has_data = $false
    Write-Host $_.Exception.GetType().fullname;
    Write-Host $_.Exception.Message;
  }

  Write-Output ('check 1: {0}' -f $has_data)
  if ($has_data) {
    $o = New-Object PSObject
    $o | Add-Member -NotePropertyName 'Size' -NotePropertyValue $w.size
    $o | Add-Member -NotePropertyName 'Drive' -NotePropertyValue $drive
    $o | Add-Member -NotePropertyName 'FreeSpace' -NotePropertyValue $w.freespace
    $o | Add-Member -NotePropertyName 'Server' -NotePropertyValue $remotecomputer


    @( $o) |
    ForEach-Object { $BlockSize = (($_.freespace) / ($_.size)) * 100; $_.freespace = ($_.freespace / 1GB); $_.size = ($_.size / 1GB); $_ } |
    Format-Table `
       @{ n = 'Server  '; e = { $_.Server } },
    @{ n = 'Free, Gb'; e = { '{0:N2}' -f $_.freespace } },
    @{ n = 'Free,%'; e = { '{0:N2}' -f $BlockSize } },
    @{ n = 'Capacity ,Gb'; e = { '{0:N3}' -f $_.size } } -AutoSize



    <#
     Rely on capturing the STD OUT with Powewrshell is hopeless: 
     get_wmi_data server.com   ->
     the result is :
     True 
     Microsoft.PowerShell.Commands.Internal.Format.FormatStartData 
     Microsoft.PowerShell.Commands.Internal.Format.GroupStartData 
     Microsoft.PowerShell.Commands.Internal.Format.FormatEntryData 
     Microsoft.PowerShell.Commands.Internal.Format.GroupEndData 
     Microsoft.PowerShell.Commands.Internal.Format.FormatEndData
   #>


  }
  $data_ref.Value = $o
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


function collect_inventory {
  param(
    [Parameter(Mandatory = $true,Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true)]
    #    [ValidateNotNull()]
    [string[]]$computerName, # TODO  rename parameter
    [System.Management.Automation.PSReference]$data_ref
  )
  begin {
    $local:result = @()
  }
  process {

    foreach ($node in $ComputerName) {
      if (-not $node) {
        continue
      }

      $ping_status_res = host_wmi_ping -target_host $node
      if (-not $ping_status_res) {
        continue
      }


      Write-Debug $node
      $local:drivespace_data = @{}
      $local:disks = @{}
      @( 'c:','d:','e:') | ForEach-Object {
        $drivename = $_
        Write-Host ('processing {0}' -f $drivename)

        $drivespace_data_ref = ([ref]$local:drivespace_data)
        get_wmi_data ${node} $DomainName -data_ref $drivespace_data_ref -drivename $drivename
        Write-Host '->'
        Write-Host $local:drivespace_data
        $local:flat_data = @{ 'Size' = $null;
          'FreeSpace' = $null;
          'Server' = $null;
          'Drive' = $null;
        }

        # $flat_data['Size'] = Get-Member -Name 'Size' -InputObject $local:drivespace_data  -MemberType NoteProperty
        # $flat_data['Size'] is 
        #   Microsoft.PowerShell.Commands.MemberDefinition
        #   System.Double Size=135.999996185303
        #    is unclear how to extract it    
        $local:flat_data['Size'] = ($local:drivespace_data).size
        $local:flat_data['FreeSpace'] = ($local:drivespace_data).freespace
        $local:flat_data['Server'] = ($local:drivespace_data).Server
        $local:flat_data['Drive'] = ($local:drivespace_data).Drive

        # Write-Host 'flat_data-> '
        # write-host $local:flat_data
        # System.Collections.DictionaryEntry System.Collections.DictionaryEntry System.Collections.DictionaryEntry System.Collections.DictionaryEntry 

        $local:disks[$drivename] = @{
          'Drive' = $local:flat_data['Drive'];
          'Size' = $local:flat_data['Size'];
          'FreeSpace' = $local:flat_data['FreeSpace'];
          'Server' = $local:flat_data['Server'];

        }
      }

      # write-host ( $local:disks | get-member )
      ($local:disks).Keys | ForEach-Object { $k = $_;
        Write-Host ('Key={0}' -f $k)
        Write-Host ('Drive={0}' -f $local:disks.Item($k)['Drive'])
        Write-Host ('Size={0}' -f $local:disks[$k]['Size'])
        Write-Host ('FreeSpace={0}' -f $local:disks[$k]['FreeSpace'])
        Write-Host ('Server={0}' -f $local:disks[$k]['Server'])

      $local:result += @{

        'Drive' = $local:disks.Item($k)['Drive']
        'Size' = $local:disks[$k]['Size']
        'FreeSpace' = $local:disks[$k]['FreeSpace']
        'Server' = $local:disks[$k]['Server']


      }
      }
    }
    return $local:result
    $data_ref.Value = $local:result
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
  'UAT' = @{
    'SCRIPT' = $EXAMPLE;
    'EXPRESSION' = '^xxxxx.*n1\.';
    'DOMAIN' = '(?:xxxxxxxxx)';
  };
  'DEBUG' = @{
    'SCRIPT' = [scriptblock]{

      param(
        [System.Management.Automation.PSReference]$object_ref,
        [System.Management.Automation.PSReference]$result_ref,
        [System.Management.Automation.PSReference]$caller_ref,
        [string]$key = $null
      )


      $result_ref.Value = 'xxx.xnet.com'

    };
    'EXPRESSION' = '^xxxx.*n6\.';
    'DOMAIN' = 'xxxxxxx';
  };

};

$ENVIRONMENTS_STRUCTURED = @{
  'CMS' = @{
    'COMMENT' = 'Servers';
    'DOMAIN' = 'xxxxxxx';
    'SERVERS' =
    @(
      'xxxxxxxxxxxxx',
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
  $ENVIRONMENTS_STRUCTURED.Keys | Format-Table
  foreach ($role in $ENVIRONMENTS_STRUCTURED.Keys) {

    $configuration = $ENVIRONMENTS_STRUCTURED.Item($role)
    # skip unreachable domain results , 
    Write-Debug ('Logon Server "{0}"' -f $configuration['LOGONSERVER'])
    if (($configuration['DOMAIN'] -eq $env:USERDOMAIN) -and (($configuration['LOGONSERVER'] -eq $null) -or ($env:LOGONSERVER -match $configuration['LOGONSERVER']))) {
      Write-Output ('Starting {0}' -f $configuration['COMMENT'])
      if ($configuration.ContainsKey('SERVERS')) {
        $servers = $configuration['SERVERS']
        if ($servers.Count -gt 0) {

          $local:data_ref  = ([ref]$configuration['RESULTS'])
          collect_inventory $servers -data_ref $local:data_ref
          $configuration['RESULTS']  
          $configuration['RESULTS'] | ConvertTo-Json
          # examine_json -results $configuration['RESULTS'] -FileName ('{0}-BAD.json' -f $role)
          # $raw_results = ConvertTo-Json -InputObject $configuration['RESULTS']
          # Out-File -FilePath ('{0}-RAW.json' -f $role) -Encoding ASCII -InputObject $raw_results
          #           squash_json -results $configuration['RESULTS'] -FileName ('{0}.json' -f $role)
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
  @( $scope) | ForEach-Object {
    $role = $_
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
    Write-Debug $nodes
    # TODO - reenable
    $DebugPreference = 'Continue';
    Write-Debug $scope
    $results = collect_inventory $nodes

    $raw_results = ConvertTo-Json -InputObject $results
    Out-File -FilePath ('{0}-RAW.json' -f $role) -Encoding ASCII -InputObject $raw_results

    examine_json -results $results -FileName ('{0}-BAD.json' -f $role)
    # squash_json -results $results -FileName ('{0}.json' -f $role)


  }
}
# Out-File -FilePath 'result2.json' -Encoding ASCII -InputObject $raw_rowset_data
# 
return


<#

[
    # ... garbage
    "check 1: True",
    {
        "pageHeaderEntry":  null,
        "pageFooterEntry":  null,
        "autosizeInfo":  {
                             "objectCount":  0,
                             "ClassId2e4f51ef21dd47e99d3c952918aff9cd":  "a27f094f0eec4d64845801a4c06a32ae"
                         },
        "shapeInfo":  {
                          "hideHeader":  false,
                          "tableColumnInfoList":  "Microsoft.PowerShell.Commands.Internal.Format.TableColumnInfo Microsoft.PowerShell.Commands.Internal.Format.TableColumnInfo Microsoft.PowerShell.Commands.Internal.Format.TableColumnInfo Microsoft.PowerShell.Commands.Internal.Format.TableColumnInfo",
                          "ClassId2e4f51ef21dd47e99d3c952918aff9cd":  "e3b7a39c089845d388b2e84c5d38f5dd"
                      },
        "groupingEntry":  null,
        "ClassId2e4f51ef21dd47e99d3c952918aff9cd":  "033ecb2bc07a4d43b5ef94ed5a35d280"
    },
    {
        "shapeInfo":  null,
        "groupingEntry":  null,
        "ClassId2e4f51ef21dd47e99d3c952918aff9cd":  "9e210fe47d09416682b841769c78b8a3"
    },
    {
        "formatEntryInfo":  {
                                "formatPropertyFieldList":  "Microsoft.PowerShell.Commands.Internal.Format.FormatPropertyField Microsoft.PowerShell.Commands.Internal.Format.FormatPropertyField Microsoft.PowerShell.Commands.Internal.Format.FormatPropertyField Microsoft.PowerShell.Commands.Internal.Format.FormatPropertyField",
                                "multiLine":  false,
                                "ClassId2e4f51ef21dd47e99d3c952918aff9cd":  "0e59526e2dd441aa91e7fc952caf4a36"
                            },
        "outOfBand":  false,
        "writeStream":  0,
        "ClassId2e4f51ef21dd47e99d3c952918aff9cd":  "27c87ef9bbda4f709f6b4002fa4af63c"
    },
    {
        "groupingEntry":  null,
        "ClassId2e4f51ef21dd47e99d3c952918aff9cd":  "4ec4f0187cb04f4cb6973460dfe252df"
    },
    {
        "groupingEntry":  null,
        "ClassId2e4f51ef21dd47e99d3c952918aff9cd":  "cf522b78d86c486691226b40aa69e95c"
    },
    # ...  expected data
    {
        "FreeSpace":  121.64391708374023,
        "Drive":  "e:",
        "Server":  "Cserver.com",
        "Size":  136.02343368530273
    },

]

#>
