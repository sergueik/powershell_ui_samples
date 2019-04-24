param([string]$master_server = 'xxxxxx',[string]$verbose = $false)
# puppet module also uses appcmd.exe
# https://github.com/simondean/puppet-iis/tree/master/lib/puppet/type
# puppet module uses WebAdministration 
# https://github.com/puppet-community/puppet-iis/blob/master/manifests/manage_app_pool.pp
# get-ItemProperty "IIS:\AppPools\DefaultAppPool"
# Load the entries from remote 
function gather {

  [xml]$raw_data = Invoke-Expression -Command 'C:\Windows\system32\inetsrv\appcmd.exe list apppool /xml';

  $raw_data.SelectNodes("/appcmd//*[@state = 'Started']") | Out-Null
  # TODO : Assertion

  $cnt = 0
  $grid = @()

  $raw_data.SelectNodes("/appcmd//*[@state = 'Started']") | ForEach-Object {
    $name = $_.'APPPOOL.NAME';
    if ((-not ($name -match 'DefaultAppPool')) `
         -and `
         (-not ($name -match 'Classic .NET AppPool')) `
         -and `
         (-not ($name -match 'ASP.NET v4.0 Classic')) `
         -and `
         (-not ($name -match 'ASP.NET v4.0')) `
      ) {
      $row = New-Object PSObject
      $row | Add-Member Noteproperty Name ('{0}' -f $name)
      $row | Add-Member Noteproperty PipelineMode ('{0}' -f $_.PipelineMode)
      $row | Add-Member Noteproperty RuntimeVersion ('{0}' -f $_.RuntimeVersion)
      $row | Add-Member Noteproperty Row ('{0}' -f $cnt)
      $cnt++
      $grid += $row
      $row = $null
    }
  }
  # $grid | format-table -autosize
  return $grid
}
<# 
TODO: compare two objects 
write-output "Run locally."
$grid = gather  ;
$grid | format-table -autosize
#>

Write-Host -ForegroundColor 'green' ('Run remotey on {0}' -f $master_server)
$step1 = Invoke-Command -computer $master_server -ScriptBlock ${function:gather}
$generate_cmd_file = 'generate_appools.cmd'
if ($verbose -ne '') {
  $step1 | Format-Table -AutoSize
}
if ((Get-ChildItem -Path $generate_cmd_file -ErrorAction silentlycontinue)) {
  Remove-Item $generate_cmd_file -Force
}
# compose the commands

$command1_template = 'C:\Windows\system32\inetsrv\appcmd.exe add apppool /name:"{0}" /managedRuntimeVersion:"{1}" /managedPipelineMode:"{2}"'
# reference : http://programming4.us/website/6446.aspx
$command2_template = "C:\Windows\system32\inetsrv\appcmd.exe set apppool /apppool.name:{0} /processModel.identityType:NetworkService"
$command3_template = "C:\Windows\system32\inetsrv\appcmd.exe set config /section:applicationPools /[name='{0}'].processModel.identityType:NetworkService"
# NOTE: command3_template does not work
# ERROR ( message:Cannot find SITE object with identifier "name=files].processModel.identityType:NetworkService". )
# origin: http://technet.microsoft.com/en-us/library/cc771170(v=ws.10).aspx
# ERROR ( message:Unknown attribute "*[@name=Files].processModel.identityType".  Replace with -? for help. )

$step1 | ForEach-Object {
  $command = ($command1_template -f $_.name,$_.RuntimeVersion,$_.PipelineMode)
  Write-Output $command | Out-File $generate_cmd_file -Encoding Ascii -Force -Append
  $command = ($command2_template -f $_.name)
  Write-Output $command | Out-File $generate_cmd_file -Encoding Ascii -Force -Append


  # The possible response would be:
  # APPPOOL object "DownloadableFiles" added
  # ERROR ( message:Failed to add duplicate collection element "DownloadableFiles". )
}
Write-Host -ForegroundColor 'green' ("Please run the command file `n{0}`nto install and condigure app pools" -f $generate_cmd_file)
return

