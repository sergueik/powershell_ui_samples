# origin : http://poshcode.org/6369
# https://habrahabr.ru/post/276059/
# Removes windows 10 apps for current user.

Get-AppxPackage -Name '*3dbuilder*' | Remove-AppxPackage
Get-AppxPackage -Name '*Appconnector*' | Remove-AppxPackage
Get-AppxPackage -Name '*BingFinance*' | Remove-AppxPackage
Get-AppxPackage -Name '*BingNews*' | Remove-AppxPackage
Get-AppxPackage -Name '*BingSports*' | Remove-AppxPackage
Get-AppxPackage -Name '*BingWeather*' | Remove-AppxPackage
Get-AppxPackage -Name '*CommsPhone*' | Remove-AppxPackage
Get-AppxPackage -Name '*ConnectivityStore*' | Remove-AppxPackage
Get-AppxPackage -Name '*Getstarted*' | Remove-AppxPackage
Get-AppxPackage -Name '*Messaging*' | Remove-AppxPackage
Get-AppxPackage -Name '*MicrosoftOfficeHub*' | Remove-AppxPackage
Get-AppxPackage -Name '*MicrosoftSolitaireCollection*' | Remove-AppxPackage
Get-AppxPackage -Name '*OneNote*' | Remove-AppxPackage
Get-AppxPackage -Name '*Sway*' | Remove-AppxPackage
Get-AppxPackage -Name '*people*' | Remove-AppxPackage
Get-AppxPackage -Name '*SkypeApp*' | Remove-AppxPackage
Get-AppxPackage -Name '*WindowsAlarms*' | Remove-AppxPackage
Get-AppxPackage -Name '*WindowsCamera*' | Remove-AppxPackage
Get-AppxPackage -Name '*windowscommunicationsapps*' | Remove-AppxPackage
Get-AppxPackage -Name '*WindowsDVDplayer*' | Remove-AppxPackage
Get-AppxPackage -Name '*WindowsMaps*' | Remove-AppxPackage
Get-AppxPackage -Name '*WindowsPhone*' | Remove-AppxPackage
Get-AppxPackage -Name '*WindowsSoundRecorder*' | Remove-AppxPackage
Get-AppxPackage -Name '*commsphone*' | Remove-AppxPackage
Get-AppxPackage -Name '*WindowsStore*' | Remove-AppxPackage
Get-AppxPackage -Name '*XboxApp*' | Remove-AppxPackage
Get-AppxPackage -Name '*ZuneMusic*' | Remove-AppxPackage
Get-AppxPackage -Name '*ZuneVideo*' | Remove-AppxPackage
Get-AppxPackage -Name '*xbox*' | Remove-AppxPackage
Get-AppxPackage -Name '*contactsupport*' | Remove-AppxPackage

# Prevents the wndows 10 apps from being installed onto new user accounts.

$Applist = Get-AppxProvisionedPackage -Online

$Applist | Where-Object { $_.packagename -like '3DBuilder*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'Appconnector*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'BingFinance*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'BingNews*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'BingSports*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'BingWeather*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'CommsPhone*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'ConnectivityStore*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'Getstarted*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'Messaging*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'MicrosoftOfficeHub*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'MicrosoftSolitaireCollection*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'OneNote*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'Sway*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'People*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'SkypeApp*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'WindowsAlarms*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'WindowsCamera*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'windowscommunicationsapps*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'WindowsDVDplayer*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'WindowsMaps*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'WindowsPhone*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'WindowsSoundRecorder*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'WindowsStore*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'XboxApp*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'ZuneMusic*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'ZuneVideo*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'xbox*' } | Remove-AppxProvisionedPackage -Online
$Applist | Where-Object { $_.packagename -like 'contact support*' } | Remove-AppxProvisionedPackage -Online

# Blocks Windows 10 from auto downloading new apps to users by adding a line into the registry.

$RegKey = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent'
if (-not (Test-Path $RegKey)) {
  New-Item -Path "$($RegKey.TrimEnd($RegKey.Split('\')[-1]))" -Name "$($RegKey.Split('\')[-1])" -Force | Out-Null
}
New-ItemProperty -Path $RegKey -Name 'DisableWindowsConsumerFeatures' -Value '1' -PropertyType 'Dword'
