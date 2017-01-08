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
#THE SOFTWARE.using System;

# based on http://poshcode.org/?show=1276
# http://monket.net/blog/articles/autotest-growl-for-windows/
# http://lifehacker.com/5350422/battle-of-the-windows-notification-apps-growl-for-windows-vs-snarl
param(
  [switch]$show_buttons
)

Set-StrictMode -Version 2

$shared_assemblies = @{
  'nunit.core.dll' = $null;
  'nunit.framework.dll' = $null;
  'Growl.Connector.dll' = $null;
	'Growl.CoreLibrary.dll'  = $null;
}


if (($env:SHARED_ASSEMBLIES_PATH -ne $null) -and ($env:SHARED_ASSEMBLIES_PATH -ne '')) {
  $shared_assemblies_path = $env:SHARED_ASSEMBLIES_PATH
} else {
  $shared_assemblies_path = 'c:\developer\sergueik\csharp\SharedAssemblies'
}

pushd $shared_assemblies_path
$shared_assemblies.Keys | ForEach-Object {
  # http://all-things-pure.blogspot.com/2009/09/assembly-version-file-version-product.html
  $assembly = $_
  $assembly_path = [System.IO.Path]::Combine($shared_assemblies_path,$assembly)
  $assembly_version = [Reflection.AssemblyName]::GetAssemblyName($assembly_path).Version
  $assembly_version_string = ('{0}.{1}' -f $assembly_version.Major,$assembly_version.Minor)
  # reg add hklm\software\microsoft\.netframework /v OnlyUseLatestCLR /t REG_DWORD /d 1
  # reg add hklm\software\wow6432node\microsoft\.netframework /v OnlyUseLatestCLR /t REG_DWORD /d 1
  if ($shared_assemblies[$assembly] -ne $null) {
    if (-not ($shared_assemblies[$assembly] -match $assembly_version_string)) {
      Write-Output ('Need {0} {1}, got {2}' -f $assembly,$shared_assemblies[$assembly],$assembly_path)
      Write-Output $assembly_version
      throw ('invalid version :{0}' -f $assembly)
    }
  }

  if ($host.Version.Major -gt 2) {
    Unblock-File -Path $_;
  }
  Write-Debug $_
  [Reflection.Assembly]::LoadFrom($assembly_path) | Out-Null
  Add-Type -Path $_
}
popd

Add-Type -TypeDefinition @"

using System.Collections.Generic;
using System.Text;
using Growl.Connector;
using System;

public class Test
{
	private GrowlConnector growl;
	private NotificationType notificationType;
	private Growl.Connector.Application application;
	private string sampleNotificationType = "SAMPLE_NOTIFICATION";
  private string Text;

	public void Run()
	{
		this.growl = new GrowlConnector();
		this.Text = "Notification Test";
		application = new Growl.Connector.Application("Application Name");
		this.notificationType = new NotificationType(sampleNotificationType, "Sample Notification");
		Notification notification = new Notification(this.application.Name, this.notificationType.Name, DateTime.Now.Ticks.ToString(), this.Text, this.Text);
		CallbackContext callbackContext = new CallbackContext("some fake information", "fake data");

		this.growl.Notify(notification, callbackContext);
	}
}
"@ -ReferencedAssemblies @( 'System.dll','System.Security.dll','System.Core.dll',([System.IO.Path]::Combine($shared_assemblies_path,'Growl.Connector.dll')),([System.IO.Path]::Combine($shared_assemblies_path,'Growl.CoreLibrary.dll')))

$appPath = get-ItemProperty -path 'HKCU:\Software\Growl' -name '(default)' |select-object -expandproperty '(default)'

[Reflection.Assembly]::LoadFrom([System.IO.Path]::Combine((split-path -path $appPath -Parent),'Growl.Connector.dll')) | Out-Null

$script:appName = 'PowerGrowler'

if (!(Test-Path Variable:Global:PowerGrowlerNotices)) {
  $global:PowerGrowlerNotices = @{}
}

$script:PowerGrowler = New-Object 'Growl.Connector.GrowlConnector'

function Register-GrowlType {
  param(
    [string]$AppName,
    [string]$Name,
	  [Parameter(Mandatory = $false)]
		# [ValidateScript( {($Icon -eq $null ) -or (test-path -path $Icon) } )]
    [string]$Icon = $null,
    [string]$DisplayName = $Name,
    [string]$MachineName,
	  [Parameter(Mandatory = $true)]
		# [ValidateScript( {($AppIcon -eq $null ) -or (test-path -path $AppIcon) } )]
    [string]$AppIcon
  )

  [Growl.Connector.NotificationType]$Notice = $Name
  $Notice.DisplayName = $DisplayName
	if ($icon) {
    $Notice.Icon = Convert-Path (Resolve-Path $Icon)
  }
  if ($MachineName) {
    $Notice.MachineName = $MachineName
  }
  if (!$global:PowerGrowlerNotices.Contains($AppName)) {
    $global:PowerGrowlerNotices.Add($AppName,([Growl.Connector.Application]$AppName))

    $global:PowerGrowlerNotices.$AppName = Add-Member -input $global:PowerGrowlerNotices.$AppName -Name Notices -Type NoteProperty -Value (New-Object hashtable) -PassThru
    $global:PowerGrowlerNotices.$AppName.Icon = Convert-Path (Resolve-Path $AppIcon)
  }
  if ($global:PowerGrowlerNotices.$AppName.Notices.ContainsKey($Name)){
    $global:PowerGrowlerNotices.$AppName.Notices.Add($Name,$Notice)
  }
	
  $script:PowerGrowler.Register($global:PowerGrowlerNotices.$AppName,[Growl.Connector.NotificationType[]]@( $global:PowerGrowlerNotices.$AppName.Notices.Values))
}

function Set-GrowlPassword {
  param(
    [string]$Password,
    [ValidateSet('AES','DES','RC2','TripleDES','PlainText')]
    [string]$Encryption = 'AES',
    [ValidateSet('MD5','SHA1','SHA256','SHA384','SHA512')]
    [string]$KeyHash = 'SHA1'
  )
  $script:PowerGrowler.EncryptionAlgorithm = [Growl.Connector.Cryptography+SymmetricAlgorithmType]::"$Encryption"
  $script:PowerGrowler.KeyHashAlgorithm = [Growl.Connector.Cryptography+SymmetricAlgorithmType]::"$KeyHash"
  $script:PowerGrowler.Password = $Password
}


function Register-GrowlCallback {
  param(
    [Parameter(Mandatory = $true)]
    [scriptblock]$Handler
  )
  Register-ObjectEvent $script:PowerGrowler NotificationCallback -Action $Handler
}
function Send-Growl {
  [CmdletBinding(DefaultParameterSetName = 'DataCallback')]
  param(
    [ValidateScript({ $global:PowerGrowlerNotices.Contains($AppName) })]
    [string]$AppName,
    [ValidateScript({ $global:PowerGrowlerNotices.$AppName.Notices.ContainsKey($_) })]
    [string]$NoticeType = 'Default',
    [string]$Caption,
    [string]$Message,
    [Parameter(ParameterSetName = 'UrlCallback')]
    [uri]$Url = $null,
    [Parameter(ParameterSetName = 'DataCallback')]
    [string]$CallbackData = $null,
    [Parameter(ParameterSetName = 'DataCallback')]
    [string]$CallbackType = $null,
    [string]$Icon,
    [Growl.Connector.Priority]$Priority = 'Normal'
  )

  $notice = New-Object Growl.Connector.Notification $appName,$NoticeType,(Get-Date).Ticks.ToString(),$caption,$Message

  if ($Icon) { $notice.Icon = Convert-Path (Resolve-Path $Icon) }
  if ($Priority) { $notice.Priority = $Priority }

  if ($DebugPreference -gt "SilentlyContinue") { Write-Output $notice }
  if ($Url) {
	# does not seem to work correctly
  # if (Test-Path Variable:Local:Url) {
    $context = New-Object Growl.Connector.CallbackContext
    ## These two things aren't used? Probably shouldn't so all this work :)
    $context.Data = $(if (Test-Path Variable:Local:CallbackData) { $CallbackData } else { $Url.ToString() })
    $context.Type = $(if (Test-Path Variable:Local:CallbackType) { $CallbackType } else { "$NoticeType+Url" })
    $urlCb = New-Object Growl.Connector.UrlCallbackTarget
    Write-Host $Url -Fore Cyan
    $urlCb.Url = $Url
    $context.SetUrlCallbackTarget($urlcb)
    $script:PowerGrowler.Notify($notice,$context)
		} elseif (($CallbackData ) -and ($CallbackType)) {
    # } elseif ((Test-Path Variable:Local:CallbackData) -and (Test-Path Variable:Local:CallbackType)) {
    $context = New-Object Growl.Connector.CallbackContext
    $context.Data = $CallbackData
    $context.Type = $CallbackType
    Write-Host $context.GetUrlCallbackTarget() -Fore Magenta
    $script:PowerGrowler.Notify($notice,$context)
  } else {
    $script:PowerGrowler.Notify($notice)
  }
}

$DefaultNoticeType = 'Default'
Register-GrowlType -AppName $script:AppName -Name $DefaultNoticeType -AppIcon "$PsScriptRoot\sample.ico"
Send-Growl -AppName $script:AppName -Caption 'Powershell Notification' -Message 'This is a test'
