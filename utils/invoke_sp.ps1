<#
To run 
$env:SQL_USER='jenkins';
$env:SQL_PASSWORD='xxxxxx';
$env:SQL_TIMEOUT = 30;
# ask the TSO WebOps Team for the password 
$DebugPreference = 'Continue'; 
. ./invoke_sp.ps1 domain1\user1 'Affairwhere' ''  "SELECT GETDATE()"
. ./invoke_sp.ps1 domain2\user2 'Affairwhere'  spSelectUserIds  '' 


$env:SQL_USER='SitecoreAdmin';
$env:SQL_PASSWORD='xxxxxx';

# ask the eCOM Team for the password 
$env:DATABASE='Sitecore_analytics'
$DebugPreference = 'Continue'; 
. ./invoke_sp.ps1 ceno1 'Sitecore_analytics' ''  "SELECT GETDATE()"


#>

param(
  [string]$sql_instance = '',
  [string]$sql_database = '',
  [string]$sp_name = '',
  [string]$sql_command = '',
  [string]$sql_timeout = '',
  [string]$str_verbose = $false
)

$SOLVED_UTF16_BUG = $false

function log_message {
  param(
    [Parameter(Position = 0)]
    [string]$message,
    [Parameter(Position = 1)]
    [string]$logfile
  )

  if ($SOLVED_UTF16_BUG -and $host.version.major -gt 2) {

    <# WARNING Tee-Object corrupts files with utf16
    PS D:\java\Jenkins\master\jobs\SQL_RUNNER_2\workspace> 
    Tee-Object  -FilePath 'test.properties' -append -InputObject 'hello world'
    hello world
    type 'test.properties' 
    h e l l o  w o r l d
  #>
    Tee-Object -FilePath $logfile -Encoding ascii -Append -InputObject $message
  } else {
    # on certain machines
    # $host.version  = 2.0 
    # the tee-object does not support -append option.a
    Write-Output -InputObject $message
    Write-Output -InputObject $message | Out-File -FilePath $logfile -Encoding ascii -Force -Append
  }
}

if ($sql_instance -eq '') {
  $sql_instance = $env:SQL_DATABASE_INSTANCE
}

if ($sql_database -eq '') {
  $sql_database = $env:SQL_DATABASE
}


if ($sql_timeout -eq '') {
  $sql_timeout = $env:SQL_TIMEOUT
}

if ($sql_command -eq '') {
  $sql_command = $env:SQL_COMMAND
}

if ($sp_name -eq '') {
  $sp_name = $env:SP_NAME
}

if ((-not ($env:SQL_USER -match 'jenkins')) -and ($sp_name -eq '') -and ($sql_command -ne '')) {

  # raise error - unsupported usage 
  $tool_error = 'Only jenkins user is authorized to compose SQL query directly'
  Write-Output ('SQL Exception: {0}' -f $tool_error)
  $(throw ('SQL Exception: {0}' -f $tool_error))
  log_message "STEP_STATUS=ERROR" $build_status
  exit 1;
}


if ((($sql_command -eq $null) -or ($sql_command -eq '')) -and (($sp_name -eq $null) -or ($sp_name -eq ''))) {
  $(throw "Please specify a query or procedure to run.")
  exit 1
}

if (($sql_command -eq $null) -or ($sql_command -eq '')) {
  $sql_command = ("exec {0} " -f $sp_name)
}

$node_name = ''

if ($node_name -eq '') {
  $node_name = $env:NODE_NAME
}
$build_status = 'test.properties'

log_message "SQL Instance: ${sql_instance}" $build_status
log_message "Initial Database: ${sql_database}" $build_status
log_message "SP Name : ${sp_name}" $build_status


function Invoke-SQL {

  param(
    [string]$dataSource = '',
    [string]$sql_command = '',
    [string]$database = '',# DEFAULT CATALOG : 
    [string]$sql_timeout = '',
    [string]$sql_user = $env:SQL_USER,
    [string]$password = $env:SQL_PASSWORD
  )


  # TODO - support using the credentials of the calling user to help command line debugging 
  #           ... "Integrated Security=SSPI; " ...

  if ($sql_timeout -eq '') {
    # The SQL Server default CommandTimeOut is 30 seconds. 
    # This should be plenty of time for 99.9% of actions 
    $sql_timeout = '1200'
  }

  $connectionString = "Data Source=$dataSource; " +
  "Initial Catalog=$database;User ID=$sql_user;pwd=$password;Timeout=$sql_timeout"


  Write-Debug ('Connection String:`n"{0}"' -f $connectionString)

  $connection = New-Object system.data.SqlClient.SQLConnection ($connectionString)

  Write-Output "SQL Command: ${sql_command}"
  Write-Output "SQL Timeout: ${sql_timeout}"
  $command = New-Object system.data.sqlclient.sqlcommand ($sql_command,$connection)


  try {
    $connection.Open()
  } catch [exception]{
    Write-Output ('SQL Exception: {0}' -f $_.ToString())
    log_message "STEP_STATUS=ERROR" $build_status
    exit
  }


  if ($connection.State -ne 'Open') {
    Write-Output 'SQL connection Error detected '
    log_message "STEP_STATUS=ERROR" $build_status
    exit
  }

  $adapter = New-Object System.Data.sqlclient.sqlDataAdapter $command
  $dataset = New-Object System.Data.DataSet # DataSet

  try {
    $adapter.Fill($dataSet)
  } catch [exception]{
    Write-Output ('SQL Exception: {0}' -f $_.ToString())
    log_message "STEP_STATUS=ERROR" $build_status
    exit
  }
  $adapter.Fill($dataSet) | Out-Null

  $connection.Close()
  $connection.Dispose()
  $dataSet.Tables
  <# 
    # hide domain-specific code 
    foreach ($t in  $dataSet.Tables ){ # DataTableCollection
        foreach ($row in $t.Rows){
     	    $user_id = ($row.USER_ID).ToString()
     	    $user_last_name = ($row.USER_LAST_NAME).ToString() 
     	    $user_first_name = ($row.USER_FIRST_NAME).ToString()
     	    write-output ( "{0,-20}`t{1,-20}{2,-20}" -f $user_id , $user_last_name,  $user_first_name  )
     	    }
    }
    #>

}

$build_status = 'test.properties'
($build_status) | ForEach-Object { Set-Content -Path $_ -Value '' -Encoding ascii -Force }

Write-Debug "Invoke-SQL -sql_instance  ${sql_instance} -sql_command ""${sql_command}"" -sql_database ${sql_database}  -sql_timeout ${sql_timeout}"

Invoke-SQL -sql_instance $sql_instance -sql_command "$sql_command" -sql_database $sql_database -sql_timeout $sql_timeout

log_message "STEP_STATUS=OK" $build_status
<#
KNOWN ERRORS:
SQL Exception: The user does not have permission to perform this action.
SQL Exception: A network-related or instance-specific error occurred while establishing a connection to SQL Server. The server was not found or was not accessible. Verify that the instance name is correct and that SQL Server is configured to allow remote connections. (provider: Named Pipes Provider, error: 40 - Could not open a connection to SQL Server)
SQL Exception: The transaction log for database 'Sitecore_analytics' is full. To find out why space in the log cannot be reused, see the log_reuse_wait_desc column in sys.databases

#>

<#
External links:

http://www.dbascript.com/execute-sql-stored-procedure-from-powershell-with-parameters
https://sqlpsx.codeplex.com/discussions/453639
http://powershell.org/wp/forums/topic/examples-running-sql-stored-procedures-from-powershell-with-output-parameters/
http://stackoverflow.com/questions/8423541/how-do-you-run-a-sql-server-query-from-powershell
http://bpetluri.blogspot.com/2013/06/powershell-executing-sql-stored.html
http://blog.sqlauthority.com/2009/01/07/sql-server-find-currently-running-query-t-sql/
#>

