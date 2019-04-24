<#
$env:ENVIRONMENT='DEV'
$env:build_log = 'test.properties'
$DebugPreference = 'Continue';

#>
param (

  [string] $EnvName = '',
  [String] $build_log = '' 
  # use no-colliding $build_log name
)

if ($build_log -eq '') {
  $build_log = $env:BUILD_LOG
}

if ($EnvName -eq '') {
  $EnvName = $env:ENVIRONMENT
}

write-output "Setting the environment ${EnvName}."

# This script generates parameters based on the environment 
# and makes it svailable to the fest of the project 

function write_variable  {

param (
       [string] $variable_name, 
       [System.Management.Automation.PSReference] $variable_ref, 
       [string] $build_log 
 )

try {
  $data = ''
  write-debug ( 'variable type = {0}' -f ( $variable_ref.Value.GetType() ) )
if ($variable_ref.Value.GetType() -match 'Object\[\]') {
  $data = ($variable_ref.Value -join ',')
} else  {
  $data = $variable_ref.Value
}

write-output ('{0}={1}' -f $variable_name,  $data) | out-file -FilePath $build_log -Encoding ascii -Force -append
} catch [InvalidArgumentExcdption] {

}

}

write-debug "Truncate the build log: ${build_log}"
# truncate the build log 
( $build_log ) | foreach-object {set-content -Path $_ -value '' -Encoding ascii -Force}
# ( $build_log ) | foreach-object {set-content -LiteralPath $_ -value '' -Encoding ascii -Force}

# $TARGET_HOST='xxxxxx'
$TARGET_PATH='keepalive.aspx'
$ACTION='Activate'
$LOCAL_FILE_PATH='E:\Portals\CarnivalDMS\Website'
$EMAIL_RECIPIENTS=@('skouzmine@carnival.com','HMudireddy@carnival.com')
$SITE_CODE=42
$DEPLOY_HOSTS=@('xxxxxx')
# no need to explicitly 
$STEP_STATUS='SUCCESS'

# write_variable 'TARGET_HOST'                      ( [ref]$TARGET_HOST )                      $build_log
write_variable 'TARGET_PATH'                      ( [ref]$TARGET_PATH)                      $build_log
write_variable 'ACTION'                           ( [ref]$ACTION )                      $build_log
write_variable 'LOCAL_FILE_PATH'                  ( [ref]$LOCAL_FILE_PATH)                      $build_log
write_variable 'SITE_CODE'                        ( [ref]$SITE_CODE)                      $build_log
write_variable 'DEPLOY_HOSTS'                     ( [ref]$DEPLOY_HOSTS)                      $build_log


# Additional properties
write-output 'Additional properties....'
$guid = [guid]::NewGuid() 
$variable_name ='SQL_QUERY_SCRIPT'
$data = ('{0}\{1}.sql' -f $env:WORKSPACE, $guid )

write-output ('{0}={1}' -f $variable_name,  $data) | out-file -FilePath $build_log -Encoding ascii -Force -append
return


#the below needs to merge with 


write_variable 'CDSPathUS'                      ( [ref]$CDSPathUS )                      $build_log
write_variable 'CDSPathUK'                      ( [ref]$CDSPathUK )                      $build_log
write_variable 'SQLServerSitecoreCoreMasterWeb' ( [ref]$SQLServerSitecoreCoreMasterWeb ) $build_log
write_variable 'SQLServerSitecorePub'           ( [ref]$SQLServerSitecorePub )           $build_log
write_variable 'serverfarmA'                    ( [ref]$serverfarmA  )                   $build_log
write_variable 'serverfarmB'                    ( [ref]$serverfarmB )                    $build_log
write_variable 'phantom_js_environmnent_index'  ( [ref]$phantom_js_environmnent_index )  $build_log
write_variable 'EnvName'                        ( [ref]$EnvName )                        $build_log
#--------------------

write_variable 'connectionStrings'              ( [ref]$connectionStrings )              $build_log
write_variable 'connectionStringsParallel'      ( [ref]$connectionStringsParallel )      $build_log
write_variable 'connectionStringsPROD'          ( [ref]$connectionStringsPROD )          $build_log
write_variable 'phantom_js_environmnent_index'  ( [ref]$phantom_js_environmnent_index )  $build_log
write_variable 'keepAliveName'                  ( [ref]$keepAliveName )                  $build_log
write_variable 'keepAliveNameOff'               ( [ref]$keepAliveNameOff )               $build_log
write_variable 'apphealthON'                    ( [ref]$apphealthON )                    $build_log
write_variable 'apphealhtOFF'                   ( [ref]$apphealhtOFF )                   $build_log



write-debug ( 'Reading the file {0}' -f $build_log ) 
get-content $build_log | out-string
# now sure what purpose ...


exit 0  


<#
function load_environment_definitions{

param (
       [string] $EnvName, 
       [System.Management.Automation.PSReference]   $SitecoreCMSPath, 
       [System.Management.Automation.PSReference]   $CDSPathUS , 
       [System.Management.Automation.PSReference]   $CDSPathUK, 
       [System.Management.Automation.PSReference]   $SQLServerSitecoreCoreMasterWeb, 
       [System.Management.Automation.PSReference]   $SQLServerSitecorePub, 
       [System.Management.Automation.PSReference]   $sitecorehostnames, 
       [System.Management.Automation.PSReference]   $serverfarmA, 
       [System.Management.Automation.PSReference]   $serverfarmB 
 )

# ...
}
#>
