# based on:
# https://stackoverflow.com/questions/4998173/how-do-i-write-to-standard-error-in-powershell

function Write-StdErr {
  param (
   [PSObject] $InputObject
  )
  $outFunc = if ($Host.Name -eq 'ConsoleHost') {
    [Console]::Error.WriteLine
  } else {
    $host.ui.WriteErrorLine
  }
  if ($InputObject) {
    [void] $outFunc.Invoke($InputObject.ToString())
  } else {
    [string[]] $lines = @()
    $Input | % { $lines += $_.ToString() }
    [void] $outFunc.Invoke($lines -join "`r`n")
  }
}
# execution in CMD console
<#

powershell.exe -noprofile  -file check_redirect.ps1 *>combined.log
only redirects STDOUT
powershell.exe -noprofile  -file check_redirect.ps1 2>error.log
powershell.exe -noprofile  -file check_redirect.ps1  1>combined.log 2>&1
work as expected

NOTE: argument order matters
powershell.exe -noprofile  -file check_redirect.ps1 2>&1 1>combined.log
does not work
powershell -noprofile  -file check_redirect.ps1 2>err.log 1>out.log
works but with two different files
#>
1..3 | foreach-object {
  write-output ('output message ' + $_ )
}
# note the convoluted debate abot differences of that happen *Inside* PowerShell, *Outside* PowerShell,
# and constructs like "there is no such thing as stdout and stderr, in PowerShell"
1..3 | foreach-object {
  # none of the below is being redirected when Powershell Console window is used. is it because PowerShell is object-oriented ?
  $error_message =  ('error message ' + $_ )
  [Console]::Error.WriteLine($error_message)
  # none of the more exotic method calls achieve redirection within Powershell console.

  Write-StdErr $error_message
  write-error $error_message -ErrorAction SilentlyContinue -ErrorVariable ev 2>$null
  Write-StdErr $ev[0].exception.Message

Add-Type -TypeDefinition @'
using System;
public class Helper
{
public static void Message(String message) {
Console.Error.WriteLine(message);
}
}
'@
  [void](new-object -typeName Helper)
  [Helper]::Message($error_message)
}


