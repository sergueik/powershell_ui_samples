# origin:  http://stackoverflow.com/questions/27951561/use-invoke-webrequest-with-a-username-and-password-for-basic-authentication-on-t
# http://www.jokecamp.com/blog/invoke-restmethod-powershell-examples/

param(
  [string]$user = 'sergueik',
  [string]$pass = 'D0ss1aXML',
  [string]$url = 'https://api.github.com/user'
)
$headers = @{ Authorization = "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(('{0}:{1}' -f ${user},${pass}))))" }

Invoke-WebRequest -uri $url -Headers $headers