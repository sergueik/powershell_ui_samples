
$shared_assemblies = @(
  "WebDriver.dll",
  "WebDriver.Support.dll",
  'nunit.framework.dll',
  'nunit.core.dll'
)


$shared_assemblies_path = 'c:\developer\sergueik\csharp\SharedAssemblies'

if (($env:SHARED_ASSEMBLIES_PATH -ne $null) -and ($env:SHARED_ASSEMBLIES_PATH -ne '')) {
  $shared_assemblies_path = $env:SHARED_ASSEMBLIES_PATH
}

pushd $shared_assemblies_path
$shared_assemblies | ForEach-Object {

  if ($host.Version.Major -gt 2) {
    Unblock-File -Path $_;
  }
  Write-Debug $_
  Add-Type -Path $_
}
popd


[string]$json_template = 'transfer.json'
# http://stackoverflow.com/questions/8343767/how-to-get-the-current-directory-of-the-cmdlet-being-executed
function Get-ScriptDirectory {
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  if ($Invocation.PSScriptRoot) {
    $Invocation.PSScriptRoot
  }
  elseif ($Invocation.MyCommand.Path) {
    Split-Path $Invocation.MyCommand.Path
  } else {
    $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf(""))
  }
}


$result = (Get-Content -Path ([System.IO.Path]::Combine((Get-ScriptDirectory),$json_template))) -join "`n"

$result_default = @"
[{
	"serverName": "xxxxxx",
	"iisStatus": "started",
	"sites": [{
		"siteName": "Carnival",
		"siteStatus": "started",
		"applications": [{
			"applicationName": "\\",
			"applicationPool": "Carnival",
			"dotNet": 4,
			"mode": "classic",
			"status": "started"
		}, {
			"applicationName": "OnlineCheckIn",
			"applicationPool": "OnlineCheckIn",
			"dotNet": 4,
			"mode": "classic",
			"status": "stopped"
		}]
	}, {
		"siteName": "CarnivalUK",
		"siteStatus": "stopped",
		"applications": [{
			"applicationName": "\\",
			"applicationPool": "CarnivalUK",
			"dotNet": 4,
			"mode": "classic",
			"status": "started"
		}]
	}]
}]
"@

# need to update  ConvertFrom-Json ?


# 3.0 still does no recognized 
# http://stackoverflow.com/questions/28077854/powershell-2-0-convertfrom-json-and-convertto-json-implementation
function ConvertTo-Json20 {
  param([object]$InputObject)
  Add-Type -Assembly system.web.extensions
  $ps_js = New-Object system.web.script.serialization.javascriptSerializer
  return $ps_js.Serialize($InputObject)
}


$json_object = ConvertFrom-Json -InputObject $result -Depth 10
Write-Host $json_object.'serverName'
Write-Host $json_object.'iisStatus'
[System.Object[]]$sites = $json_object.'sites'

[System.Object]$site = $sites[0]
Write-Host $site.'siteName'
Write-Host $site.'siteStatus'
[System.Object[]]$applications = $site.'applications'
[System.Object]$application = $applications[0]

Write-Host $application.'applicationName'
Write-Host $application.'applicationPool'
Write-Host $application.'dotNet'
Write-Host $application.'mode'
Write-Host $application.'status'
[NUnit.Framework.Assert]::IsNotEmpty($application.'status','cannot be emty')


# NOTE  $site['siteName'] does not exist! and neither the rest of hash addressing. However the other way around it will!

# to ensure absence of stuff 
# [NUnit.Framework.StringAssert]::Contains('artwork',$element.GetAttribute('class'),{})


function generate_result_mockup () {
  param([string]$json_result = 'out.json'
  ) # this function will  emit the  json in specific schema

  $mockup_result =
  @(
    @{
      "serverName" = "xxxxxx";
      "iisStatus" = "started";
      "sites" = @(
        @{
          "siteName" = "Carnival";
          "siteStatus" = "started";
          "applications" = @(
            @{
              "applicationName" = "\\";
              "applicationPool" = "Carnival";
              "dotNet" = 4;
              "mode" = "classic";
              "status" = "started";
            },@{
              "applicationName" = "OnlineCheckIn";
              "applicationPool" = "OnlineCheckIn";
              "dotNet" = 4;
              "mode" = "classic";
              "status" = "stopped";
            });
        },@{
          "siteName" = "CarnivalUK";
          "siteStatus" = "stopped";
          "applications" = @(
            @{
              "applicationName" = "\\";
              "applicationPool" = "CarnivalUK";
              "dotNet" = 4;
              "mode" = "classic";
              "status" = "started";
            });
        });
    });

  $json_object = $mockup_result
  ConvertTo-Json -InputObject $json_object
  #  the structure is  corrupt 
  ConvertTo-Json20 -InputObject $json_object
  #  truncate the file 

  '' | Out-File -FilePath $json_result -Encoding ascii -Force
  Write-Output ('Saving new contents to the file "{0}"' -f $json_result)
  #   ConvertTo-Json -InputObject $json_object | Out-File -FilePath ([System.IO.Path]::Combine((Get-ScriptDirectory),$json_result)) -Encoding ascii -Force -Append
  ConvertTo-Json20 -InputObject $json_object | Out-File -FilePath ([System.IO.Path]::Combine((Get-ScriptDirectory),$json_result)) -Encoding ascii -Force -Append

}

generate_result_mockup
