# http://stackoverflow.com/questions/8343767/how-to-get-the-current-directory-of-the-cmdlet-being-executed
function Get-ScriptDirectory
{
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
$shared_assemblies = @(
  "WebDriver.dll",
  "WebDriver.Support.dll",
  "Selenium.WebDriverBackedSelenium.dll",
  # for octopus 
"Sprache.dll",
 "Newtonsoft.Json.dll",
"Octopus.Client.dll",
"Octopus.Platform.dll"
)

$env:SHARED_ASSEMBLIES_PATH = "c:\users\sergueik\code\csharp\SharedAssemblies2"

$shared_assemblies_path = $env:SHARED_ASSEMBLIES_PATH
pushd $shared_assemblies_path
$shared_assemblies | ForEach-Object { Unblock-File -Path $_; Add-Type -Path $_ }
popd


$environment = "Production"
$deployment = "deployments-204";
$octopusServer = "http://server2:8112" # NOTE HTTPS is default but may not be set up properly.
$octopusAPIKey = "..."


$endpoint = new-object Octopus.Client.OctopusServerEndpoint "$octopusServer","$octopusAPIKey"
$repository = new-object Octopus.Client.OctopusRepository $endpoint

# http://www.nudoq.org/#!/Packages/Octopus.Client/Octopus.Client/ArtifactResource/P/Source 

$deployments = $repository.Deployments.FindAll()

write-output $artifacts.Count
$artifacts = $repository.Artifacts
$new_artifact = new-object Octopus.Client.Model.ArtifactResource
$new_artifact.Filename = "c:\windows\winsxs"
$new_artifact.Created = new-object System.DateTimeOffset
$new_artifact.RelatedDocumentIds =  new-object Octopus.Platform.Model.ReferenceCollection
$new_artifact.RelatedDocumentIds.Add("desddployments-260")

<#
Exception calling "Create" with "1" argument(s): "There was a problem with
your request.
 - One or more referenced resources do not exist: "dummy" provided for RelatedDocumentIds
#>
$new_artifact.Source  = 'sergueik'
$artifacts.Create($new_artifact)

return 
$machines = $repository.Machines.FindAll()

<#
$deployments = $repository.Deployments
$artifacts  = $repository.Artifacts

# $artifacts   | get-member
# $artifacts   | format-list
write-output ($artifacts[0]).Name
$repository.Environments.GetMachines
# $machines = $repository.Environments.GetMachines('SysTest2.UK')
# $machines
# $machines| foreach-object {write-output $_ }
exit 0
$deployment_id = $repository.Deployments.FindByName($deployment )


#
# $envId = $repository.Environments.FindByName($environment)
$envId = $repository.Environments.FindByName($environment)
$machines = $repository.Environments.GetMachines($envId)

$machines | %{
  $instanceId = $_.Name
  $instance = Get-EC2Instance -instance $instanceId
  if (!$instance -or $instance.Instances.State.Name.Value -ne "running") {
    write-Host "Removing EC2 instance $instanceId from $environment"
    $repository.Client.Delete($_.Links["Self"])
  }
}
#>
