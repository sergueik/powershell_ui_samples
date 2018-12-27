<#
based:
https://www.upwork.com/o/jobs/browse/details/~01b825aa466a183581/?page=2&q=powershell&sort=renew_time_int%2Bdesc&user_location_match=2
Google Identity Platform: Using OAuth 2.0 in Powershell using Firebase Admin SDK private key
https://developers.google.com/identity/protocols/OAuth2ServiceAccount

 #>
# key id 6c546581a05cb303271db2dcb8ab071f1184ed88
$private_key_filename = 'static-chiller-226718-6c546581a05c.json'
$private_key = Get-Content -path "${env:USERPROFILE}\Downloads\${private_key_filename}" | ConvertFrom-Json

# https://stackoverflow.com/questions/4192971/in-powershell-how-do-i-convert-datetime-to-unix-time
$issuetime = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime() -uformat '%s'))
$endtime = [Math]::Floor([decimal](Get-Date((get-Date).AddMinutes(30)).ToUniversalTime() -uformat '%s'))

function to_base64_url_encoded {
  param (
    [String]$inputdata
  )
  #  write-error ('input: {0}' -f $inputdata)
  # base64encode input string then convert  from base64 to base64url
  # https://brockallen.com/2014/10/17/base64url-encoding/
  [byte[]]$rawdata = [System.Text.Encoding]::UTF8.GetBytes($inputdata)
  [String]$base64encoded_data = [System.Convert]::ToBase64String($rawdata)
  # NOTRE: currently not chaining
  $result = $base64encoded_data.Split('=')[0]
  $result = $result.replace('+', '-')
  $result = $result.replace('/', '_')
  return $result
}

$headerhash = [ordered]@{
  'alg' = 'RS256';
  'typ' = 'JWT';
}
$headerjson = ( convertTo-Json -inputObject $headerhash ) -replace '\r?\n' , ''
write-output ('Header: {0}' -f $headerjson )
$encodedheader = to_base64_url_encoded -inputdata $headerjson
write-output ( 'encodedheader: {0}' -f  $encodedheader )

$scope = 'https://www.googleapis.com/auth/firebase.messaging'
# $scope = 'https://www.googleapis.com/auth/firebase'
# $scope = 'https://www.googleapis.com/auth/prediction'
$claimhash = [ordered]@{
  'iss' = $private_key.client_email ;
  'sub'= $private_key.client_email ;
  'scope' = $scope ;
  'aud' = 'https://www.googleapis.com/oauth2/v4/token'
    <#
    {
      "error": "invalid_grant",
      "error_description": "Invalid JWT: Failed audience check. The right audience is https://www.googleapis.com/oauth2/v4/token"
    }
    # When making an access token request this value is always
    # https://www.googleapis.com/oauth2/v4/token.
    # $private_key.token_uri
    #>
  'exp' = [math]::Round($endtime,0 );
  'iat' = [math]::Round($issuetime,0);
}
$claimjson = ($claimhash | ConvertTo-Json ) -replace '\r?\n' , ''
write-output ('Claim: {0}' -f $claimjson)
$encodedclaim = to_base64_url_encoded -inputdata $claimjson

write-Output ('encoded claim: {0}' -f $encodedclaim )

$jws = "${encodedheader}.${encodedclaim}";

# https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.rsacryptoserviceprovider.signdata?view=netframework-4.5
$rsa = [System.Security.Cryptography.RSACryptoServiceProvider]::Create()

$encodedjws = [System.Text.Encoding]::Unicode.GetBytes($jws)
<#
[System.Security.Cryptography.SHA256CryptoServiceProvider]$p = new-object -typename 'System.Security.Cryptography.SHA256CryptoServiceProvider'
[Byte[]]$signature = $rsa.SignData($encodedjws,$p)

if (-not $rsa.VerifyData($encodedjws, $p, $signature)) {
  throw [Exception] 'Cannot Verify data'
}
#>

# This is the key -- need to convert PEM to proper format
$rsa.FromXmlString($rsa.ToXmlString($private_key.private_key))

$signature = $rsa.SignData($encodedjws, [System.Security.Cryptography.CryptoConfig]::MapNameToOID('SHA256'))

$signature_string = [System.Text.Encoding]::UTF8.GetString($signature)
write-output $signature_string

$encodedsignature = to_base64_url_encoded -inputdata ( [System.Text.Encoding]::UTF8.GetString($signature))
write-output ('encodedsignature: {0}' -f  $encodedsignature )

$jwt = "${encodedheader}.${encodedclaim}.${encodedsignature}"

# Load lib for HttpUtility
Add-Type -AssemblyName 'System.Web'

$requestUri = 'https://www.googleapis.com/oauth2/v4/token'
$method = 'POST'

$grant_type = [System.Web.HttpUtility]::UrlEncode('urn:ietf:params:oauth:grant-type:jwt-bearer')
$body = ('grant_type=' + $grant_type + '&' +  'assertion=' + $jwt)
write-output ("POST body:`r`n{0}" -f $body )
write-output "C:\tools\curl.exe -k -X POST https://www.googleapis.com/oauth2/v4/token -d '${body}'"

# quotes around post data not really necesary
$response = & C:\tools\curl.exe -k -X POST https://www.googleapis.com/oauth2/v4/token -d ${body}
$response | convertFrom-Json

Invoke-webrequest -Uri $requestUri -Method $method -Body $body -ContentType application/x-www-form-urlencoded
<#
  "error": "invalid_grant",
  "error_description": "Invalid JWT Signature."
}
#>
