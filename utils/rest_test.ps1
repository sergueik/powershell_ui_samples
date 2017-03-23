# origin:  http://stackoverflow.com/questions/27951561/use-invoke-webrequest-with-a-username-and-password-for-basic-authentication-on-t
# http://www.jokecamp.com/blog/invoke-restmethod-powershell-examples/

param(
[string]
[string]$user = "sergueik",
[string]$pass = "D0ss1aXML"
)

[string]$pair = "${user}:${pass}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$basicAuthValue = "Basic $base64"

$headers = @{ Authorization = $basicAuthValue }

Invoke-WebRequest -uri "https://api.github.com/user" -Headers $headers