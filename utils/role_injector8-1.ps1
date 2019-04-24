param(
  [string]$master_server = 'xxxxxx',
  [bool]$verbose = $false)

# Run the servermanager remotely providing output file  in a known location
# this relies on the fact the same user is present on both hosts
$step1 = Invoke-Command { Invoke-Expression "c:/windows/system32/servermanagercmd.exe -query $env:userprofile\appdata\local\temp\result.xml" } -computer $master_server
# Transmit remote servermanager output file into a local file
$step2 = Invoke-Command { Get-Content "$env:userprofile\appdata\local\temp\result.xml" } -computer $master_server | Out-File 'test.xml' -Encoding ascii -Force


[xml]$servermaneger_report = Get-Content -Path 'test.xml'
Remove-Item 'Result.xml' -Force
Write-Output @"
<ServerManagerConfiguration
Action='Install'
xmlns='http://schemas.microsoft.com/sdm/Windows/ServerManager/Configuration/2007/1'>
"@ | Out-File -Append -Encoding ascii -FilePath 'result.xml'

foreach ($role in $servermaneger_report.ServerManagerConfigurationQuery.Role) {
  if ($role.Installed -eq 'true') {
    if ($role.Id -ne $null) {
      Write-Output ("      <Role Id='{0}'/>" -f $role.Id) | Out-File -Append -Encoding ascii -FilePath 'result.xml'
    }
    foreach ($roleService in $role.RoleService) {
      if ($roleService.Installed -eq 'true') {
        Write-Output ("      <RoleService Id='{0}' />" -f $roleService.Id) | Out-File -Append -Encoding ascii -FilePath 'result.xml'
      }
    }
    foreach ($roleService2 in $role.RoleService.RoleService) {
      if ($roleService2.Installed -eq 'true') {
        Write-Output ("         <RoleService Id='{0}' />" -f $roleService2.Id) | Out-File -Append -Encoding ascii -FilePath 'result.xml'
      }
    }
    foreach ($roleService3 in $role.RoleService.RoleService.RoleService) {
      if ($roleService3.Installed -eq 'true') {
        Write-Output ("            <RoleService Id='{0}' />" -f $roleService3.Id) | Out-File -Append -Encoding ascii -FilePath 'result.xml'
      }
    }
  }
}

foreach ($feature in $servermaneger_report.ServerManagerConfigurationQuery.Feature) {
  if ($feature.Installed -eq 'true') {
    Write-Output ("   <Feature Id='{0}'/>" -f $feature.Id) | Out-File -Append -Encoding ascii -FilePath 'result.xml'
    foreach ($subfeature in $feature.Feature) {
      if ($subfeature.Installed -eq 'true') {
        Write-Output ("      <Feature Id='{0}'/>" -f $subfeature.Id) | Out-File -Append -Encoding ascii -FilePath 'result.xml'
      }
    }

    foreach ($subfeature2 in $feature.Feature.Feature) {
      if ($subfeature2.Installed -eq 'true') {
        Write-Output ("         <Feature Id='{0}'/>" -f $subfeature2.Id) | Out-File -Append -Encoding ascii -FilePath 'result.xml'
      }
    }

  }
}


Write-Output @"
</ServerManagerConfiguration>
"@ | Out-File -Append -Encoding ascii -FilePath 'result.xml'


<# 
need to run 
servermanagercmd -inputpath .\result.xml
#>
