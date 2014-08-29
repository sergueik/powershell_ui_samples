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


$shared_assemblies =  @(
  'WebDriver.dll',  
  'WebDriver.Support.dll', 
  'Selenium.WebDriverBackedSelenium.dll',
  'nunit.core.dll',
  'nunit.framework.dll'
)

$env:SHARED_ASSEMBLIES_PATH =  'c:\developer\sergueik\csharp\SharedAssemblies'

$shared_assemblies_path = $env:SHARED_ASSEMBLIES_PATH

pushd $shared_assemblies_path
$shared_assemblies | foreach-object { Unblock-File -Path $_ ; Add-Type -Path  $_ } 
popd

# http://stackoverflow.com/questions/15767066/get-session-id-for-a-selenium-remotewebdriver-in-c-sharp
Add-Type -TypeDefinition @"
using System;
using OpenQA.Selenium;
using OpenQA.Selenium.Remote;
using OpenQA.Selenium.Support.UI;
public class CustomeRemoteDriver : RemoteWebDriver
{
    // OpenQA.Selenium.WebDriver  ?
    public CustomeRemoteDriver(ICapabilities desiredCapabilities)
        : base(desiredCapabilities)
    {
    }

    public CustomeRemoteDriver(ICommandExecutor commandExecutor, ICapabilities desiredCapabilities)
        : base(commandExecutor, desiredCapabilities)
    {
    }

    public CustomeRemoteDriver(Uri remoteAddress, ICapabilities desiredCapabilities)
        : base(remoteAddress, desiredCapabilities)
    {
    }

    public CustomeRemoteDriver(Uri remoteAddress, ICapabilities desiredCapabilities, TimeSpan commandTimeout)
        : base(remoteAddress, desiredCapabilities, commandTimeout)
    {
    }

    public string GetSessionId()
    {
        return base.SessionId.ToString();
    }
} 
"@ -ReferencedAssemblies 'System.dll', "${shared_assemblies_path}\WebDriver.dll", "${shared_assemblies_path}\WebDriver.Support.dll"



  Try { 
    $connection = (New-Object Net.Sockets.TcpClient)
    $connection.Connect('127.0.0.1',4444)
    $connection.Close()
    }
  catch {
    $selemium_driver_folder = 'c:\java\selenium'
    start-process -filepath 'C:\Windows\System32\cmd.exe' -argumentlist "start cmd.exe /c ${selemium_driver_folder}\hub.cmd"
    start-process -filepath 'C:\Windows\System32\cmd.exe' -argumentlist "start cmd.exe /c ${selemium_driver_folder}\node.cmd"
    start-sleep 10
  }

  $capability = [OpenQA.Selenium.Remote.DesiredCapabilities]::Firefox()
  $uri = [System.Uri]('http://127.0.0.1:4444/wd/hub')
  $driver = new-object CustomeRemoteDriver($uri , $capability)

[void]$driver.Manage().Timeouts().ImplicitlyWait( [System.TimeSpan]::FromSeconds(10 )) 
[string]$baseURL = $driver.Url = 'http://www.wikipedia.org';
$driver.Navigate().GoToUrl($baseURL)
$sessionid =  $driver.GetSessionId()
[NUnit.Framework.Assert]::IsTrue($sessionid -ne $null)

# https://github.com/davglass/selenium-grid-status/blob/master/lib/index.js
$sessionURL = ("http://127.0.0.1:4444/grid/api/testsession?session={0}" -f $sessionid)
$req = [System.Net.WebRequest]::Create($sessionURL)
$resp = $req.GetResponse()
$reqstream = $resp.GetResponseStream()
$sr = new-object System.IO.StreamReader $reqstream
$result = $sr.ReadToEnd()

# Convertfrom-JSON applies To: Windows PowerShell 3.0 and above
[NUnit.Framework.Assert]::IsTrue($host.Version.Major -gt 2)
$json_object = Convertfrom-JSON -InputObject $result
<#
internalKey    : 908cbce8-31cd-4ee9-a154-271c4ff4c22c
session        : 6f689139-39a2-473a-be2d-34312e37b6d4
inactivityTime : 1
proxyId        : http://192.168.0.7:5555
msg            : slot found !
success        : True
#>
$proxyId = $json_object.proxyId
$proxyUri = new-object System.Uri($proxyId)
$proxyUri.Port
$proxyUri.Host
try {
  $driver.Quit()
} catch [Exception] {
  # Ignore errors if unable to close the browser
}
<#
a simpler alternative:
//Assume Wed Driver is initiated properly 
Cookie cookie= driver.manage().getCookieNamed("JSESSIONID")
cookie.getValue()
http://autumnator.wordpress.com/2011/12/22/autoit-sikuli-and-other-tools-with-selenium-grid/
#>
return 