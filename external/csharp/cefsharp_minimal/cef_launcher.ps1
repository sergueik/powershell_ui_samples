# needs to be run in 
# 32-bit Windows PowerShell
# c:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe

function Get-ScriptDirectory {

  if ($global:scriptDirectory -eq $null) {
    [string]$global:scriptDirectory = $null

    if ($host.Version.Major -gt 2) {
      $global:scriptDirectory = (Get-Variable PSScriptRoot).Value
      write-debug ('$PSScriptRoot: {0}' -f $global:scriptDirectory)
      if ($global:scriptDirectory -ne $null) {
        return $global:scriptDirectory;
      }
      $global:scriptDirectory = [System.IO.Path]::GetDirectoryName($MyInvocation.PSCommandPath)
      write-debug ('$MyInvocation.PSCommandPath: {0}' -f $global:scriptDirectory)
      if ($global:scriptDirectory -ne $null) {
        return $global:scriptDirectory;
      }

      $global:scriptDirectory = Split-Path -Parent $PSCommandPath
      write-debug ('$PSCommandPath: {0}' -f $global:scriptDirectory)
      if ($global:scriptDirectory -ne $null) {
        return $global:scriptDirectory;
      }
    } else {
      $global:scriptDirectory = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
      if ($global:scriptDirectory -ne $null) {
        return $global:scriptDirectory;
      }
      $Invocation = (Get-Variable MyInvocation -Scope 1).Value
      if ($Invocation.PSScriptRoot) {
        $global:scriptDirectory = $Invocation.PSScriptRoot
      } elseif ($Invocation.MyCommand.Path) {
        $global:scriptDirectory = Split-Path $Invocation.MyCommand.Path
      } else {
        $global:scriptDirectory = $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf('\'))
      }
      return $global:scriptDirectory
    }
  } else {
      write-debug ('Returned cached value: {0}' -f $global:scriptDirectory)
      return $global:scriptDirectory
  }
}



function load_shared_assemblies {

  param(
    [string]$shared_assemblies_path = 'C:\java\selenium\csharp\sharedassemblies',
    [string[]]$shared_assemblies = @(
      'WebDriver.dll',
      'WebDriver.Support.dll',
      'Newtonsoft.Json.dll',
      'nunit.core.dll',
      'nunit.framework.dll'
      )
  )

  write-debug ('Loading "{0}" from ' -f ($shared_assemblies -join ',' ), $shared_assemblies_path)
  pushd $shared_assemblies_path

  $shared_assemblies | ForEach-Object {
    $shared_assembly_filename = $_
    write-debug ('Loading assembly "{0}" ' -f $shared_assembly_filename)
    Unblock-File -Path $shared_assembly_filename;
    Add-Type -Path $shared_assembly_filename
  }
  popd
}

load_shared_assemblies -shared_assemblies_path ('{0}\{1}' -f (Get-ScriptDirectory) , 'WinForms\bin\x86\Release') -shared_assemblies @('CefSharp.WinForms.dll', 'CefSharp.BrowserSubprocess.Core.dll','CefSharp.dll','CefSharp.Core.dll')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
$browser = new-object CefSharp.WinForms.ChromiumWebBrowser('www.google.com')

$browser.Show()
# does not show anything yet