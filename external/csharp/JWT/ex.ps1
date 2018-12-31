# origin: http://codingstill.com/2018/02/create-and-sign-jwt-token-with-rs256-using-the-private-key/
# http://codingstill.com/2018/02/create-and-sign-jwt-token-with-rs256-using-the-private-key/
$private_key_filename = 'static-chiller-226718-6c546581a05c.json'
$private_key = Get-Content -path "${env:USERPROFILE}\Downloads\${private_key_filename}" | ConvertFrom-Json

add-type -path 'C:\Users\Serguei\Downloads\BouncyCastle.Crypto.dll'
$dll  = 'BouncyCastle.Crypto.dll'
# http://www.bouncycastle.org/csharp/download/bccrypto-csharp-1.8.3-bin.zip
# see also: http://codingstill.com/2018/12/jwt-manager/
# dependency is http://www.bouncycastle.org/csharp/
add-type -path 'C:\Users\Serguei\Downloads\Newtonsoft.Json.dll'
$dll2  = 'Newtonsoft.Json.dll'
<#
based:
https://www.upwork.com/o/jobs/browse/details/~01b825aa466a183581/?page=2&q=powershell&sort=renew_time_int%2Bdesc&user_location_match=2
Google Identity Platform: Using OAuth 2.0 in Powershell using Firebase Admin SDK private key
https://developers.google.com/identity/protocols/OAuth2ServiceAccount
https://blog.lextudio.com/simple-public-private-key-signing-sample-code-6f95d19fdbc (not read yet)
https://vosseburchttechblog.azurewebsites.net/index.php/2015/09/19/generating-and-consuming-json-web-tokens-with-net/
https://stackoverflow.com/questions/8437288/signing-and-verifying-signatures-with-rsa-c-sharp  - not very helpful
https://stackoverflow.com/questions/10055158/is-there-any-json-web-token-jwt-example-in-c -  not tested yet.
https://foxdeploy.com/2015/11/02/using-powershell-and-oauth/
https://marckean.com/2015/09/21/use-powershell-to-make-rest-api-calls-using-json-oauth/
http://codingstill.com/2018/02/create-and-sign-jwt-token-with-rs256-using-the-private-key/
 #>

# Newtonsoft.Json

add-type -assemblyname 'System.IdentityModel'
add-type -assemblyname 'System.Security'

add-type -TypeDefinition @'

using System;
using System.Collections.Generic;
using System.Text;
using Org.BouncyCastle.Crypto;
using Org.BouncyCastle.Crypto.Parameters;
using Org.BouncyCastle.Security;
using Newtonsoft.Json;
using Org.BouncyCastle.Asn1;
// is a class not namespace
// using Org.BouncyCastle.Asn1.ASN1Object;
using Org.BouncyCastle.Asn1.Pkcs;
public class Helper {

  public string Sign(string payload, string privateKey)
  {
      List<String> segments = new List<String>();
      var header = new { alg = "RS256", typ = "JWT" };
   
      DateTime issued = DateTime.Now;
      DateTime expire = DateTime.Now.AddHours(10);
   
      byte[] headerBytes = Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(header, Formatting.None));
      byte[] payloadBytes = Encoding.UTF8.GetBytes(payload);
   
      segments.Add(Base64UrlEncode(headerBytes));
      segments.Add(Base64UrlEncode(payloadBytes));
   
      string stringToSign = string.Join(".", segments.ToArray());
         byte[] bytesToSign = new byte[] {};
      bytesToSign = Encoding.UTF8.GetBytes(stringToSign);
    byte[] keyBytes = new byte[] {};
try{  
     keyBytes = Convert.FromBase64String(privateKey);
	Console.Error.WriteLine(String.Format("Extrated key from: {0}..."  , privateKey.Substring(0,10)));
   } catch (Exception e ) {
	Console.Error.WriteLine("Exception: "  + e.ToString());
        return "";
   }   

// https://people.eecs.berkeley.edu/~jonah/bc/org/bouncycastle/asn1/ASN1Object.html 
// var  privKeyObj = new Org.BouncyCastle.Asn1.ASN1Object();
try{  
   var  privKeyObj = Asn1Object.FromByteArray(keyBytes);
      var privStruct = RsaPrivateKeyStructure.GetInstance((Asn1Sequence)privKeyObj);
      ISigner sig = SignerUtilities.GetSigner("SHA256withRSA");   
      sig.Init(true, new RsaKeyParameters(true, privStruct.Modulus, privStruct.PrivateExponent));
   
      sig.BlockUpdate(bytesToSign, 0, bytesToSign.Length);
      byte[] signature = sig.GenerateSignature();
   
      segments.Add(Base64UrlEncode(signature));
      return string.Join(".", segments.ToArray());
   } catch (Exception e ) {
	Console.Error.WriteLine("Exception: "  + e.ToString());
// Exception: System.IO.IOException: unknown tag 13 encountered   at Org.BouncyCastle.Asn1.Asn1InputStream.BuildObject(Int32 tag, Int32 tagNo,Int32 length)
//https://stackoverflow.com/questions/44440974/bouncy-castle-decode-csr-c-sharp
        return "";
   }   
  }
  
    // from JWT spec
  private static string Base64UrlEncode(byte[] input)
  {
      var output = Convert.ToBase64String(input);
      output = output.Split('=')[0]; // Remove any trailing '='s
      output = output.Replace('+', '-'); // 62nd char of encoding
      output = output.Replace('/', '_'); // 63rd char of encoding
      return output;
  }
 
  private static byte[] Base64UrlDecode(string input)
  {
      var output = input;
      output = output.Replace('-', '+'); // 62nd char of encoding
      output = output.Replace('_', '/'); // 63rd char of encoding
      switch (output.Length % 4) // Pad with trailing '='s
      {
          case 0: break; // No pad chars in this case
          case 1: output += "==="; break; // Three pad chars
          case 2: output += "=="; break; // Two pad chars
          case 3: output += "="; break; // One pad char
          default: throw new System.Exception("Illegal base64url string!");
      }
      var converted = Convert.FromBase64String(output); // Standard base64 decoder
      return converted;
  }
}  

'@ -ReferencedAssemblies 'System.Security.dll','System.IdentityModel.dll','System.Data.dll','System.Xml.dll','System.ComponentModel.dll', "${env:USERPROFILE}\Downloads\${dll}", "${env:USERPROFILE}\Downloads\${dll2}"
$o = new-object -typeName  'Helper'
$privateKey = "-----BEGIN PRIVATE KEY-----`nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCvOV/3NFiwRht8`nI7itoihCCfbh21j6frN0VyZS3I948TQCYdjQSR4vP6wSToOXwFLyEuWhs+2PpUbF`nxnBYCRE2fbS1OfP7lzw+OxOB7xyhNdIMKSfAGTv9Ff+ZeqoVRPMlxpLj9UvXQ1pF`nPhZEPvLOAiTeNL64r46saSTJWSelvc59nnDhrF+CFVVyYOT4E5jqcdk9DoI7SLqw`nctyHmGiWVu3Tg90yZQawDtXiboVqpoDxzNsC6rR83htQaVYfKzalmLQmDrdNhXJD`nzcFZZH33fWu7+YeeGEWiS2x0j7xF7gK3IsH6Gp821XAteO24rhV+OLmLU+88cw9a`nXHgunHjdAgMBAAECggEAF/fUqSdXZFFKrCnktpeCQzpCs3VCEA2ptWXAX8A8vdHc`nh+Dje+Ysg1EF1AE6XdUYY3VzRLGscqQscJwqvNgMqzP5tnplZcozmt2Q1wqik2id`nwT0V62BoRL+wFUninwMt8UJe0GC6zYiwfd02xYIIy2YerehwGConbWz6c7JGypRY`nOM/ehsjwWy+mJolpmHB+CyuRZNuTz1caE6QSDybibF30K8iZVysd9UCZMOakvlty`nYRJ2ZKWK4j5JMtAkLawL2d34PqoaIHEQgPKX8EGklgc+PX1+37idwetsmvBi6V/4`nRoSf9qokVyT2DM5KHeg8WUpIQivHx/fLBpnXvCBWnwKBgQDra0PPikwuM7D0iUPE`npfH+Sne6SK5G8opCJFz7fvfxQPluFJigAdsHnXoV0qTSKtTlj+WvdTNnV5lXsov5`npntEu8KD2g58atJP73r743ryvz6Lz6QNFVaoRe+uDP6wYno0XxpAo+b/vhAWBbCn`nW7Tg0y16jEaHyEw3TGEuDW5FZwKBgQC+iu8IIM3csCDqx2Z8UltyZcnt0wH9CDUg`nwXummXv30aKI4JR6owaPC/89wXXlMhPPUB3QquOQYAUcrvJHjwbbmTmisVcQVZCu`neRLSLDuQdH3dLM8fFpXaAC9ofpV2eGjV+A5Cj1sLvN72WuPKtJOXocmmKPzBty/3`n13hJ40RBGwKBgCauKSYggwPUWm7TXt8gpPIzKhjheEEP+MeFUgHAityI4HLFz436`nwBIwPa74PTyK7RAK5KI/j4KbUgamv3j1cauJbhxb56Vpp8SahIp+heT8pzoxk7LS`nnrpnQ0pFuFMi2xFfzuBwDbRXdi0oIi5dUwrdp8tK4QvOTTeIxS7b5hJhAoGBAIcg`npmXARd4lNiLqKF8wVNPrJeo4Q2e7w1mofVVn8ceM7tRdWE8kgEk/+9JC+aYB/pR+`nP7a1Ck9gGR//Xair4PQpVPtxAsp9s+5XxKYyYkeOpZgN6BEnBjyk9voHE14CBG8B`nzLMdUTcgyYoyaOtfZnAZd5UT6jRDAoykTRUxTD1TAoGAONxAPe+WF/bPx88kLSZE`n6DODbQoSaj64/37v25iXVKKpsCsBsM1otvHWvw14CXlbdsLSHXGcFkUt1iM8N9o/`nwW9DwZIkbUprVBsrsJNEa5spVgJ/kJj2pej1dGdoDYWzoPq/IPYr8MPR5/Lch8u6`nA1baA8GhuRCTIjS4VcJjTsA=`n-----END PRIVATE KEY-----`n"

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

$inputdata = 'test data test data test data'
$data = to_base64_url_encoded -inputdata  $inputdata 
write-output $data

[byte[]]$rawdata = [System.Text.Encoding]::UTF8.GetBytes($private_key.private_key)
[String]$base64encoded_private_key = [System.Convert]::ToBase64String($rawdata)
# $key_encoded = to_base64_url_encoded -inputdata  
# write-output $key_encoded

# Exception calling "Sign" with "2" argument(s): "unknown tag 13 encountered"
$o.Sign($inputdata, $base64encoded_private_key)

<#

Exception calling "Sign" with "2" argument(s): "The input is not a valid
Base-64 string as it contains a non-base 64 character, more than two padding
characters, or an illegal character among the padding characters. "
At C:\developer\sergueik\powershell_ui_samples\external\csharp\JWT\ex.ps1:94
char:1

#>

# https://github.com/jwt-dotnet/jwt
#

<#

# https://serverfault.com/questions/455163/how-to-properly-add-net-assemblies-to-powershell-session
# https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.rsacryptoserviceprovider.signdata?view=netframework-4.7.2
<#
add-type : Unable to load one or more of the requested types. Retrieve theLoaderExceptions property for more information.
#>

# https://www.codeproject.com/Tips/1208535/Create-and-Consume-JWT-Tokens-in-Csharp
$securityKey = new-object Microsoft.IdentityModel.Tokens.SymmetricSecurityKey( [System.Text.Encoding]::UTF8.GetBytes($private_key.private_key))

# https://docs.microsoft.com/en-us/dotnet/api/system.identitymodel.tokens.securityalgorithms?view=netframework-4.7.2
$credentials = new-object Microsoft.IdentityModel.Tokens.SigningCredentials($securityKey, [System.IdentityModel.Tokens.SecurityAlgorithms]::HmacSha256Signature)
# https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.rsacryptoserviceprovider.signdata?view=netframework-4.5
# https://docs.microsoft.com/en-us/dotnet/api/system.identitymodel.tokens.securityalgorithms?view=netframework-4.5
$rsa = [System.Security.Cryptography.RSACryptoServiceProvider]::Create()

$encodedjws = [System.Text.Encoding]::UTF8.GetBytes($jws)

# https://www.nuget.org/packages/System.IdentityModel.Tokens.Jwt/



#>
<#
python script

This program verifies a Signed JWT created by Google Service Account P12 credentials
First a JWT is signed with the P12 Private Key.
The certificate is extracted from the P12 file and used to verify the signature

import json
import time
import base64
import jwt
import OpenSSL.crypto

# Google Endpoint for creating OAuth 2.0 Access Tokens from Signed-JWT
auth_url = "https://www.googleapis.com/oauth2/v4/token"

# Set how long this token will be valid in seconds
expires_in = 3600   # Expires in 1 hour

#scopes = "https://www.googleapis.com/auth/cloud-platform"
scopes = "https://www.googleapis.com/auth/devstorage.read_only"

# Details on the Google Service Account. The email must match the Google Console.
sa_filename = 'compute-engine.p12'
sa_password = 'notasecret'
sa_email = 'developer-123456@developer.gserviceaccount.com'

# You can control what is verified in the JWT. For example to allow expired JWTs
# set 'verify_exp' to False
options = {
    'verify_signature': True,
    'verify_exp': True,
    'verify_nbf': True,
    'verify_iat': True,
    'verify_aud': True,
    'require_exp': False,
    'require_iat': False,
    'require_nbf': False
}

aud = 'https://www.googleapis.com/oauth2/v4/token'

def load_private_key(p12_path, p12_password):
    ''' Read the private key and return as base64 encoded '''

    # print('Opening:', p12_path)
    with open(p12_path, 'rb') as f:
        data = f.read()

    # print('Loading P12 (PFX) contents:')
    p12 = OpenSSL.crypto.load_pkcs12(data, p12_password)

    # Dump the Private Key in PKCS#1 PEM format
    pkey = OpenSSL.crypto.dump_privatekey(
            OpenSSL.crypto.FILETYPE_PEM,
            p12.get_privatekey())

    # return the private key
    return pkey

def load_public_key(p12_path, p12_password):
    ''' Read the public key and return as base64 encoded '''

    # print('Opening:', p12_path)
    with open(p12_path, 'rb') as f:
        p12_data = f.read()

    # print('Loading P12 (PFX) contents:')
    p12 = OpenSSL.crypto.load_pkcs12(p12_data, p12_password)

    public_key = OpenSSL.crypto.dump_publickey(
                    OpenSSL.crypto.FILETYPE_PEM,
                    p12.get_certificate().get_pubkey())

    # print(public_key)

    return public_key

def create_signed_jwt(p12_path, p12_password, p12_email, scope):
    ''' Create an AccessToken from a service account p12 credentials file '''

    pkey = load_private_key(p12_path, p12_password)

    issued = int(time.time())
    expires = issued + expires_in   # expires_in is in seconds

    # Note: this token expires and cannot be refreshed. The token must be recreated

    # JWT Headers
    additional_headers = {
            "alg": "RS256",
            "typ": "JWT"    # Google uses SHA256withRSA
    }

    # JWT Payload
    payload = {
        "iss": p12_email,   # Issuer claim
        "sub": p12_email,   # Issuer claim
        "aud": auth_url,    # Audience claim
        "iat": issued,      # Issued At claim
        "exp": expires,     # Expire time
        "scope": scope      # Permissions
    }

    # Encode the headers and payload and sign creating a Signed JWT (JWS)
    sig = jwt.encode(payload, pkey, algorithm="RS256", headers=additional_headers)

    # print(sig)

    return sig

def pad(data):
    """ pad base64 string """

    missing_padding = len(data) % 4
    data += '=' * (4 - missing_padding)
    return data

def print_jwt(signed_jwt):
    """ Print a JWT Header and Payload """

    s = signed_jwt.decode('utf-8').split('.')

    print('Header:')
    h = base64.urlsafe_b64decode(pad(s[0])).decode('utf-8')
    print(json.dumps(json.loads(h), indent=4))

    print('Payload:')
    p = base64.urlsafe_b64decode(pad(s[1])).decode('utf-8')
    print(json.dumps(json.loads(p), indent=4))

def verify_signed_jwt(signed_jwt):
    '''
    This function takes a Signed JWT and verifies it using a Google P12 service account.
    '''

    # Get the Public Key
    public_key = load_public_key(sa_filename, sa_password)

    # Verify the Signed JWT
    r = jwt.decode(signed_jwt, public_key, algorithms=["RS256"], audience=aud, options=options)

    print('Decoded JWT:')
    print(json.dumps(r, indent=4))

if __name__ == '__main__':
    s_jwt = create_signed_jwt(sa_filename, sa_password, sa_email, scopes)

    print_jwt(s_jwt)

    verify_signed_jwt(s_jwt)

#>

