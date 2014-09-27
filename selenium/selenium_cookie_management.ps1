#Copyright (c) 2014 Serguei Kouzmine
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

param(
  [string]$browser
)
# http://stackoverflow.com/questions/8343767/how-to-get-the-current-directory-of-the-cmdlet-being-executed
function Get-ScriptDirectory
{
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  if ($Invocation.PSScriptRoot) {
    $Invocation.PSScriptRoot
  }
  elseif ($Invocation.MyCommand.Path) {
    Split-Path $Invocation.MyCommand.Path
  } else {
    $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf(""))
  }
}

$shared_assemblies = @(
  "WebDriver.dll",
  "WebDriver.Support.dll",
  "Selenium.WebDriverBackedSelenium.dll",
  'nunit.core.dll',
  'nunit.framework.dll'
)

$env:SHARED_ASSEMBLIES_PATH = "c:\developer\sergueik\csharp\SharedAssemblies"

$shared_assemblies_path = $env:SHARED_ASSEMBLIES_PATH
pushd $shared_assemblies_path
$shared_assemblies | ForEach-Object { Unblock-File -Path $_; Add-Type -Path $_ }
popd

$verificationErrors = New-Object System.Text.StringBuilder
$baseURL = 'http://www.wikipedia.org'
$uri = [System.Uri]('http://127.0.0.1:4444/wd/hub')
if ($browser -ne $null -and $browser -ne '') {
  try {
    $connection = (New-Object Net.Sockets.TcpClient)
    $connection.Connect("127.0.0.1",4444)
    $connection.Close()
  } catch {
    Start-Process -FilePath "C:\Windows\System32\cmd.exe" -ArgumentList "start cmd.exe /c c:\java\selenium\hub.cmd"
    Start-Process -FilePath "C:\Windows\System32\cmd.exe" -ArgumentList "start cmd.exe /c c:\java\selenium\node.cmd"
    Start-Sleep -Seconds 10
  }
  Write-Host "Running on ${browser}"
  if ($browser -match 'firefox') {
    $capability = [OpenQA.Selenium.Remote.DesiredCapabilities]::Firefox()
  }
  elseif ($browser -match 'chrome') {
    $capability = [OpenQA.Selenium.Remote.DesiredCapabilities]::Chrome()
  }
  elseif ($browser -match 'ie') {
    $capability = [OpenQA.Selenium.Remote.DesiredCapabilities]::InternetExplorer()
  }
  elseif ($browser -match 'safari') {
    $capability = [OpenQA.Selenium.Remote.DesiredCapabilities]::Safari()
  }
  else {
    throw ( 'Unknown browser choice: ' + $browser )
  }
  
  try {
    # TODO:
    # OpenQA.Selenium.Remote.CapabilityType.ForSeleniumServer possibly not available for C# port
    $capability.setCapability([OpenQA.Selenium.Remote.CapabilityType.ForSeleniumServer]::ENSURING_CLEAN_SESSION,$true)
  } catch [exception]{
  }

  try {
    $selenium = New-Object OpenQA.Selenium.Remote.RemoteWebDriver ($uri,$capability)
  } catch [exception]{
    throw
  }
} else {
  $phantomjs_executable_folder = 'C:\tools\phantomjs'
  $selenium = New-Object OpenQA.Selenium.PhantomJS.PhantomJSDriver ($phantomjs_executable_folder)
  $selenium.Capabilities.setCapability('ssl-protocol','any')
  $selenium.Capabilities.setCapability('ignore-ssl-errors',$true)
  $selenium.Capabilities.setCapability('takesScreenshot',$true)
  $selenium.Capabilities.setCapability('userAgent','Mozilla/5.0 (Windows NT 6.1) AppleWebKit/534.34 (KHTML, like Gecko) PhantomJS/1.9.7 Safari/534.34')
  $options = New-Object OpenQA.Selenium.PhantomJS.PhantomJSOptions
  $options.AddAdditionalCapability('phantomjs.executable.path',$phantomjs_executable_folder)
}

$selenium.Navigate().GoToUrl($baseURL)
try { 

  [OpenQA.Selenium.Remote.HttpCommandExecutor]$executor = new-object OpenQA.Selenium.Remote.HttpCommandExecutor($uri, [System.TimeSpan]::FromSeconds(10))
   $executor.Execute([OpenQA.Selenium.Remote.DriverCommand]::DeleteAllCookies)
   write-host -ForegroundColor 'Green' "Deleted cookies"
} catch [Exception]{
<#
 Cannot convert value of type
"OpenQA.Selenium.Remote.RemoteWebDriver" to type
"OpenQA.Selenium.Remote.ICommandExecutor".

 new-object : Cannot find type [OpenQA.Selenium.Remote.HttpCommandExecutor]:
 verify that the assembly containing this type is loaded.
#>
# commenting the exception leads to the "Unable to get browser" error in the following code 
# throw
}
# write-host -ForegroundColor 'Green' "Continue with the browser"

$selenium.Navigate().Refresh()

# http://stackoverflow.com/questions/7413966/delete-cookies-in-webdriver 

# http://stackoverflow.com/questions/595228/how-can-i-delete-all-cookies-with-javascript
# http://stackoverflow.com/questions/2144386/javascript-delete-cookie

$script = @"

function createCookie(name,value,days) {
    if (days) {
        var date = new Date();
        date.setTime(date.getTime()+(days*24*60*60*1000));
        var expires = "; expires="+date.toGMTString();
    }
    else var expires = "";
    document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return null;
}

function eraseCookie(name) {
    createCookie(name,"",-1);
}

var cookies = document.cookie.split(";");
for (var i = 0; i < cookies.length; i++) {
  eraseCookie(cookies[i].split("=")[0]);
}
"@

# executeScript works fine with Chrome or Firefox 31, ie 10, but not IE 11.
# Exception calling "ExecuteScript" with "1" argument(s): "Unable to get browser
# https://code.google.com/p/selenium/issues/detail?id=6511  

[void]([OpenQA.Selenium.IJavaScriptExecutor]$selenium).executeScript($script);

try {
  $selenium.Quit()
} catch [exception]{
  # Ignore errors if unable to close the browser
}

