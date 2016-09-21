@@ echo off
@@ echo.
@@ echo Invoking a Powershell script...
@@ echo.
@@REM origin: https://github.com/gamineshi/Polyglots/commits/master
@@ setlocal
@@ set PS_WRAPPER_ARGS=%*
@@ set PS_WRAPPER_PATH=%~f0
@@ if defined PS_WRAPPER_ARGS set PS_WRAPPER_ARGS=%PS_WRAPPER_ARGS:"=\"%
@@ PowerShell -sta -Command Invoke-Expression $('$args=@(^&{$args} %PS_WRAPPER_ARGS%);'+[String]::Join([Environment]::NewLine,$((Get-Content '%PS_WRAPPER_PATH%') -notmatch '^^@@^|^^:^|^^cls'))) & endlocal & goto :EOF
{
######################################## POWERSHELL CODE BLOCK ########################################

<#
  This is a generic batch file wrapper for a Powershell script
  and enables the PowerShell script to be executed even if the ExecutionPolicy is configured as "Restricted".

  This wrapper is a modified version of Dave Amenta's code.
  For the original source code, refer his post. [*1]

  [*1] "Embed PowerShell inside a batch file"
  http://www.daveamenta.com/2013-03/embed-powershell-inside-a-batch-file/
#>

#Requires -version 2.0
Set-StrictMode -version 2.0
$ErrorActionPreference = "stop"

Add-Type -AssemblyName System.Windows.Forms


function main
{
  $script:selfPath = [environment]::GetEnvironmentVariable("PS_WRAPPER_PATH")
  $script:cmdPid = (gwmi win32_process -Filter "processid='$pid'").parentprocessid

  hideWindow $script:cmdPid   # Prevent user from closing command prompt

### WRITE YOUR CODE HERE ###

  $message = ""
  if ($script:args.Count -gt 0) {
    $message = "Command line parameters (or dropped files) :`n`n" + $script:args
  } else {
    $message = "You can specify command line parameters as follows :`n`n> " + $script:selfPath + " This is a test"
  }
  msgboxInfo "Generic batch file wrapper for a Powershell script" $message
}


function hideWindow
{
  param (
    [Parameter(Mandatory=$true)]
    [UInt32]
    $process_id
  )
  $windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);' 
  $asyncwindow = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru 
  [void]$asyncwindow::ShowWindowAsync((Get-Process -PID $process_id).MainWindowHandle, 0) 
}


function msgboxInfo
{
  param (
    [Parameter(Mandatory=$true)]
    [string]
    $title,
    [Parameter(Mandatory=$true)]
    [string]
    $message
  )
  [void][System.Windows.Forms.Messagebox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)
}


main


}.Invoke($args)
