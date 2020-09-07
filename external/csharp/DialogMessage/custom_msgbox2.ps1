#Copyright (c) 2020 Serguei Kouzmine
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

# $DebugPreference = 'Continue'
# Dialog Message in C# for .NET Framework
# https://www.codeproject.com/Articles/5264875/Dialog-Message-in-Csharp-for-NET-Framework-4-5
# https://github.com/chris-mackay/DialogMessage/tree/master/DialogMessage

$shared_assemblies = @(
  'DialogMessage.dll',
  'nunit.core.dll',
  'nunit.framework.dll'
)


$shared_assemblies_path = 'c:\java\selenium\csharp\SharedAssemblies'

if (($env:SHARED_ASSEMBLIES_PATH -ne $null) -and ($env:SHARED_ASSEMBLIES_PATH -ne '')) {

  Write-Debug ('Using environment: {0}' -f $env:SHARED_ASSEMBLIES_PATH)
  $shared_assemblies_path = $env:SHARED_ASSEMBLIES_PATH
}

try {
  pushd $shared_assemblies_path -erroraction  'Stop' 
} catch [System.Management.Automation.ItemNotFoundException] {

# no shared assemblies 
throw
return

} catch [Exception]  {
# possibly System.Management.Automation.ItemNotFoundException
write-output ("Unexpected exception {0}`n{1}" -f  ( $_.Exception.GetType() ) , ( $_.Exception.Message) ) 

}

$shared_assemblies | ForEach-Object {
  $assembly = $_

  if ($host.Version.Major -gt 2) {
    Unblock-File -Path $assembly
  }
  Add-Type -Path $assembly
  Write-Debug $assembly
}
popd


# http://poshcode.org/2887
# http://stackoverflow.com/questions/8343767/how-to-get-the-current-directory-of-the-cmdlet-being-executed
# https://msdn.microsoft.com/en-us/library/system.management.automation.invocationinfo.pscommandpath%28v=vs.85%29.aspx
function Get-ScriptDirectory
{
  [string]$scriptDirectory = $null

  if ($host.Version.Major -gt 2) {
    $scriptDirectory = (Get-Variable PSScriptRoot).Value
    Write-Debug ('$PSScriptRoot: {0}' -f $scriptDirectory)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }
    $scriptDirectory = [System.IO.Path]::GetDirectoryName($MyInvocation.PSCommandPath)
    Write-Debug ('$MyInvocation.PSCommandPath: {0}' -f $scriptDirectory)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }

    $scriptDirectory = Split-Path -Parent $PSCommandPath
    Write-Debug ('$PSCommandPath: {0}' -f $scriptDirectory)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }
  } else {
    $scriptDirectory = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value
    if ($Invocation.PSScriptRoot) {
      $scriptDirectory = $Invocation.PSScriptRoot
    } elseif ($Invocation.MyCommand.Path) {
      $scriptDirectory = Split-Path $Invocation.MyCommand.Path
    } else {
      $scriptDirectory = $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf('\'))
    }
    return $scriptDirectory
  }
}

# Cannot convert argument "_msgButtons", with value: "", for "ShowMessage" to type "DialogMessage.DMessage+MsgButtons": "Cannot convert null to type "DialogMessage.DMessage+MsgButtons" due to enumeration values that are not valid. Specify one of the following enumeration values and try again. The possible enumeration values are "OK,OKCancel,YesNo"."
# [DialogMessage.DMessage]::ShowMessage("Window Title","Want to learn how to write your own message box?",[DialogMessage.DMessage]::MsgButtons.YesNo,[DialogMessage.DMessage]::MsgIcons.Question, ("In this project we will learn the logic necessary " + "to write your own dialog message box in Windows" ))
# TODO: see how to access enum
# $o  = new-object -typeName 'DialogMessage.DMessage'
#  new-object : A constructor was not found. Cannot find an appropriate constructor for type DialogMessage.DMessage.
# $o | get-member
# [Enum]::GetNames([DialogMessage.DMessage.MsgIcons])
# https://latkin.org/blog/2012/07/08/using-enums-in-powershell/
$o = [DialogMessage.DMessage]::MsgButtons.YesNo
if ($o -ne $null) { 
  write-output ('[DialogMessage.DMessage]::MsgButtons.YesNo={0}' -f $o)
} else { 
  write-output 'Cannot access [DialogMessage.DMessage]::MsgButtons enum'
}
[DialogMessage.DMessage]::ShowMessage("Window Title","Want to learn how to write your own message box?",2,1, ("In this project we will learn the logic necessary " + "to write your own dialog message box in Windows" ))
