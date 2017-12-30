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


# based on: https://www.codeproject.com/Articles/223002/Reboot-and-Resume-PowerShell-Script
# -------------------------------------
# Function Globals
# -------------------------------------
$global:started = $false
$global:startingStep = $Step
$global:restartKey = 'Restart-And-Resume'
$global:RegRunKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
$global:powershell = (Join-Path $env:windir 'system32\WindowsPowerShell\v1.0\powershell.exe')


# -------------------------------------
# Collection of Utility functions.
# -------------------------------------
function Should-Run-Step {
  param(
    [string]$prospectStep
  )
  if ($global:debug) {
    Write-Host ("`$global:started: {0}" -f $global:started)
    Write-Host ("`$global:startingStep: {0}" -f $global:startingStep)
    Write-Host ("`$prospectStep: {0}" -f $prospectStep)
  }
  if ($global:startingStep -eq $prospectStep -or $global:started) {
    $global:started = $true
  }
  return $global:started
}

function Wait-For-Keypress {
  param(
    [string]$message = 'Press any key to reboot...',
    [bool]$shouldExit = $false
  )
  Write-Host $message -ForegroundColor yellow
  $key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
  if ($shouldExit) {
    exit
  }
}

function Test-Key {
  param(
    [string]$path,
    [string]$key
  )

  return ((Test-Path $path) -and ((Get-Key $path $key) -ne $null))
}

function Remove-Key
{
  param(
    [string]$path,
    [string]$key)
  Remove-ItemProperty -Path $path -Name $key
}

function Set-Key {
  param(
    [string]$path,
    [string]$key,
    [string]$value
  )
  Set-ItemProperty -Path $path -Name $key -Value $value
}

function Get-Key {
  param(
    [string]$path,
    [string]$key)
  return (Get-ItemProperty $path).$key
}

function Restart-And-Run {
  param(
    [string]$key,
    [string]$run)
  Set-Key $global:RegRunKey $key $run
  Restart-Computer
  exit
}

function Clear-Any-Restart {
  param(
    [string]$key = $global:restartKey
  )
  if (Test-Key $global:RegRunKey $key) {
    Remove-Key $global:RegRunKey $key
  }
}

function Restart-And-Resume {
  param(
    [string]$script,
    [string]$step
  )

  Restart-And-Run $global:restartKey "$global:powershell $script -Step ""$step"""
}

# registry access requires Administrator Privileges
function Confirm-AdminPrivileges {
  $user = [Security.Principal.WindowsIdentity]::GetCurrent()
  return ((New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator));
}

