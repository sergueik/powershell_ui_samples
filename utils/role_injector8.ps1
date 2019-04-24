param([string] $master_server = 'xxxxxx', [bool] $verbose = $false  )


# Load the entries from remote 
function gather{

[Xml]$raw_data = invoke-expression -command 'C:\Windows\system32\inetsrv\appcmd.exe list apppool /xml';

$raw_data.SelectNodes("/appcmd//*[@state = 'Started']") | out-null
# TODO : Assertion

$cnt  = 0 
$grid = @() 

$raw_data.SelectNodes("/appcmd//*[@state = 'Started']")|foreach-object { 
$name = $_.'APPPOOL.NAME';
if ((-not ( $name -match 'DefaultAppPool' )) `
    -and  `
   (-not ($name -match 'Classic .NET AppPool')) `
    -and  `
   (-not ($name -match 'ASP.NET v4.0 Classic')) `
    -and  `
   (-not ($name -match 'ASP.NET v4.0')) `
  ) {
	$row = New-Object PSObject   
	$row | add-member Noteproperty Name            ('{0}' -f   $name             )
	$row | add-member Noteproperty PipelineMode    ('{0}' -f   $_.PipelineMode   )
	$row | add-member Noteproperty RuntimeVersion  ('{0}' -f   $_.RuntimeVersion )
	$row | add-member Noteproperty Row             ('{0}' -f   $cnt              )
$cnt ++
$grid  += $row
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

write-host -ForegroundColor 'green'  ('Run remotey on {0}' -f $master_server )
$step1 = invoke-command -computer $master_server -ScriptBlock ${function:gather} 
$generate_cmd_file = 'generate_appools.cmd'
if ( $verbose  ) {
  $step1  | format-table -autosize
}
if ((get-childitem -Path $generate_cmd_file  -erroraction silentlycontinue )){
remove-item $generate_cmd_file -force 
}
# compose the commands

$command1_template = 'C:\Windows\system32\inetsrv\appcmd.exe add apppool /name:"{0}" /managedRuntimeVersion:"{1}" /managedPipelineMode:"{2}"'
# reference : http://programming4.us/website/6446.aspx
$command2_template = "C:\Windows\system32\inetsrv\appcmd.exe set apppool /apppool.name:{0} /processModel.identityType:NetworkService"
$command3_template = "C:\Windows\system32\inetsrv\appcmd.exeset config /section:applicationPools /[name='{0}'].processModel.identityType:NetworkService"
# NOTE: command3_template does not work
# ERROR ( message:Cannot find SITE object with identifier "name=DownloadableFiles].processModel.identityType:NetworkService". )
# origin: http://technet.microsoft.com/en-us/library/cc771170(v=ws.10).aspx
# ERROR ( message:Unknown attribute "*[@name=DownloadableFiles].processModel.identityType".  Replace with -? for help. )

$step1  | foreach-object {
$command = ( $command1_template -f $_.name , $_.RuntimeVersion, $_.PipelineMode  )
write-output $command |out-file $generate_cmd_file -encoding Ascii -force -append
$command = ( $command2_template -f $_.name )
write-output $command |out-file $generate_cmd_file -encoding Ascii -force -append


# The possible response would be:
# APPPOOL object "DownloadableFiles" added
# ERROR ( message:Failed to add duplicate collection element "DownloadableFiles". )
} 
write-host -ForegroundColor 'green' ("Please run the command file `n{0}`nto install and condigure app pools" -f $generate_cmd_file )
return

