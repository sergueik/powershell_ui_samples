### Info

This directory contains a full replica of [Toast Notification](https://github.com/Windos/BurntToast)
project, with a custom assembly installer, and a collection of Powershell cmdlets proxying the API. 

BurntToast Powershell module for producing Toast Notification application is offering similar functonality
to [Growl](http://www.growlforwindows.com/) or [Mac](growl.info/downloads) (that is hard to find download for recent versions of Windows due to its  .Net 2.0 framework depenedency) 
and [Snarl](https://snarl.fullphat.net/). 
Both these are somewhat lagging behind the .Net framework race.


BurntToast is available currently for Windows only platform, separate installs specifically
Microsoft Windows 10,
both ow which have some trouble installing specicially on Windows 10 
https://lifehacker.com/battle-of-the-windows-notification-apps-growl-for-wind-5350422
https://growl.en.softonic.com/

https://snarl.fullphat.net/
https://sourceforge.net/projects/snarlwin/files/latest/download
It uses
By defaul it installs into `Documents\WindowsPowerShell\Modules` under user home directory



NuGet provider is required to continue
PowerShellGet requires NuGet provider version '2.8.5.201' or newer to interact with NuGet-based repositories. The NuGet
 provider must be available in 'C:\Program Files\PackageManagement\ProviderAssemblies' or
'C:\Users\IEUser\AppData\Local\PackageManagement\ProviderAssemblies'. You can also install the NuGet provider by
running 'Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force'. Do you want PowerShellGet to install
and import the NuGet provider now?
[Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"):


Untrusted repository
You are installing the modules from an untrusted repository. If you trust this repository, change its
InstallationPolicy value by running the Set-PSRepository cmdlet. Are you sure you want to install the modules from
'PSGallery'?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"):

[Universal Windows Platform (UWP) notification namepace asseblies](https://docs.microsoft.com/en-us/dotnet/api/microsoft.toolkit.uwp.notifications?view=win-comm-toolkit-dotnet-stable)

a.k.a. [UAP](https://social.msdn.microsoft.com/Forums/windowsapps/en-US/ac968e19-7a6a-472d-890e-a6ce4d8bdc19/uwp-vs-uap?forum=wpdevelop)
that breaks with backward compatibility with pre-10 versions.

https://en.wikipedia.org/wiki/Universal_Windows_Platform


The CmdLet appears a somwhat thin wrapper around the [Microsoft.Toolkit.Uwp.Notifications.dll](https://www.nuget.org/packages/Microsoft.Toolkit.Uwp.Notifications/)

from ['Microsoft Toolkit'](https://www.nuget.org/profiles/Microsoft.Toolkit).

It can be configured through cmdline arguments, no web interface (like Snarl) or 'Mac-ish' configurator applet, like Growl.