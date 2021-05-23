# origin http://poshcode.org/6368

param(
  $BaseURI = 'https://your.jira.server/jira',
  $Issue,
  [switch]$permissions,
  # password prompt
  $Credentials = $(Get-Credential)
)

function ConvertTo-UnsecureString  {
  param(
    [System.Security.SecureString][Parameter(Mandatory = $true)] $SecurePassword
  )
  $unmanagedString = [System.IntPtr]::Zero
  try {
    $unmanagedString = [Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($SecurePassword)
    return [Runtime.InteropServices.Marshal]::PtrToStringUni($unmanagedString)
  } finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeGlobalAllocUnicode($unmanagedString)
  }
}

function ConvertTo-Base64{
  param( $string )
  $bytes = [System.Text.Encoding]::UTF8.GetBytes($string)
  $encoded = [System.Convert]::ToBase64String($bytes)
  return $encoded
}

function ConvertFrom-Base64 {
  param( $string )
  $bytes = [System.Convert]::FromBase64String($string)
  $decoded = [System.Text.Encoding]::UTF8.GetString($bytes)

  return $decoded
}

function Get-HttpBasicHeader  {
  param(
    $Credentials,
    $Headers = @{}
  )
  $credentials_bas64 = ConvertTo-Base64 "$($Credentials.UserName):$(ConvertTo-UnsecureString $Credentials.Password)"
  $Headers['Authorization'] = "Basic ${credentials_bas64}"
  return $Headers
}

if ($Issue) {
  $uri = "$BaseURI/rest/api/2/issue/$Issue"
} elseif ($pesmissions) {
  $uri = "$BaseURI/rest/api/2/mypermissions"
} else { 
  $uri = $BaseURI
}

$headers = Get-HttpBasicHeader $Credentials
write-output $uri
Invoke-RestMethod -Uri $uri -Headers $headers -ContentType 'application/json'


