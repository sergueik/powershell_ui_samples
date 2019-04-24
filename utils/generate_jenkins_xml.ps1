#Copyright (c) 2015 Serguei Kouzmine
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

<#
-jenkins_master 'xxxxxx'
#>
param(
    [Parameter(Position=0)]
    [string]$jenkins_master,
    [Parameter(Position=1)]
    [string]$http_port,
    [Parameter(Position=2)]
    [string]$agent_name,
    [Parameter(Position=3)]
    [string]$secret

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

<#

TODO: rip the info from the page with a reasonable locator 
//*[@id="main-panel"]/ul/li[2]/pre

#>
if ($secret -eq '') {
	$secret = $env:SECRET
}

if ($agent_name -eq '') {
	$agent_name = $env:COMPUTERNAME
}

if ($jenkins_master -eq '') {
	$secret = $env:JENKINS_MASTER
}

if ($http_port -eq '') {
	$agent_name = '80'
}



# load the XML  template
$script_path = Get-ScriptDirectory
copy-item -destination 'jenkins.xml' -path 'jenkins.xml.template'  -force 
[xml]$jenkins_xml = get-content -path '.\jenkins.xml'
# replace text
$agent_name = $env:COMPUTERNAME
$jenkins_master = 'xxxxxx'
$http_port = '8000'
$java_home = 'D:/java/jdk1.6.0_45'
$jenkins_xml.service.executable = ('{0}/bin/java.exe' -f $java_home)
# need to collect the secret 
$jenkins_xml.service.arguments =  ( '-Xrs -Xmx256m -jar "%BASE%\slave.jar" -jnlpUrl http://{0}:{1}/computer/{2}/slave-agent.jnlp -secret {3}' -f $jenkins_master,  $http_port, $agent_name , $secret) 

$jenkins_xml.save(('{0}\jenkins.xml' -f $script_path) )
