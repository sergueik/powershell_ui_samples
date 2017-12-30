#Copyright (c) 2017 Serguei Kouzmine
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
  $Step = 'First'
)

# http://blogs.msdn.com/b/virtual_pc_guy/archive/2010/09/23/a-self-elevating-powershell-script.aspx
$global:debug = $false
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal ($myWindowsID)
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

# Check if script is already running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole)) {
  # set the console window title and background color to indicate that We are running "as Administrator"
  $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + '(Elevated)'
  $Host.UI.RawUI.BackgroundColor = 'DarkBlue'
  Clear-Host
} else {
  # relaunch as administrator
  $newProcess = New-Object System.Diagnostics.ProcessStartInfo 'PowerShell';
  # Specify the current script path and name as a parameter

  $arguments = @() ;
  $arguments += $myInvocation.MyCommand.Definition;

  # https://stackoverflow.com/questions/21559724/getting-all-named-parameters-from-powershell-including-empty-and-set-ones
  # https://github.com/sergueik/powershell_ui_samples/blob/master/external/csharp/ShowUI/Write-Program.ps1
  # Pass named arguments of the original script separated by spaces.
  $myInvocation.MyCommand.Parameters.keys | foreach-object {
    $key = $_
    $var = Get-Variable -Name $key -ErrorAction SilentlyContinue;
    if($var) {
      if ($global:debug) {
        write-host "Adding argument: -$($var.name) ""$($var.value)"""
      }
      $arguments += "-$($var.name)  ""$($var.value)"""
    } else {
      $arguments += "-$($var.name)"
    }
  }
  if ($global:debug) {
    write-host ( 'Passing the parameters : {0}' -f ($arguments -join ' ') )
  }
  $newProcess.Arguments = ($arguments -join ' ')

  #
  # Indicate that the process should be elevated
  $newProcess.Verb = 'runas';
  # Start the new process
  [System.Diagnostics.Process]::Start($newProcess);
  # Exit from the current, unelevated, process
  exit
}

# http://stackoverflow.com/questions/8343767/how-to-get-the-current-directory-of-the-cmdlet-being-executed
function Get-ScriptDirectory {
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  if ($Invocation.PSScriptRoot) {
    $Invocation.PSScriptRoot
  }
  elseif ($Invocation.MyCommand.Path) {
    Split-Path $Invocation.MyCommand.Path
  } else {
    $Invocation.InvocationName.Substring(0, $Invocation.InvocationName.LastIndexOf(''))
  }
}

# Run your code that needs to be elevated here

$script = $myInvocation.MyCommand.Definition
$scriptPath = Split-Path -Parent $script
# load functions
. (Join-Path $scriptpath functions.ps1)
if ( -not(Confirm-AdminPrivileges)) {
  write-host 'Test script requires admin privileges' 
  Wait-For-Keypress 'Press any key to exit script...'
  exit 0
}


if (Should-Run-Step 'First'){
  Clear-Any-Restart
  write-host 'Running step: "First"'
  write-host 'The test script will continue with "Second" step after a reboot'
  Wait-For-Keypress
  Restart-And-Resume $script 'Second'
}

if (Should-Run-Step 'Second') {
  Clear-Any-Restart
  write-host 'Running step: "Second"'
  write-host 'The test script will continue with "Third" step after a reboot'
  Wait-For-Keypress
  Restart-And-Resume $script 'Third'
}

if (Should-Run-Step 'Third') {
  Clear-Any-Restart
  write-host 'Running step: "Third"'
}

Wait-For-Keypress "Test script Complete`n Press any key to exit."
