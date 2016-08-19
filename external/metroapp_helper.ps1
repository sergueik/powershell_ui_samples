# origin: http://poshcode.org/3740
# http://poshcode.org/6479
# http://powertoe.wordpress.com
# http://stackoverflow.com/questions/12925748/iapplicationactivationmanageractivateapplication-in-c

Add-Type -TypeDefinition @"
using System;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
namespace Win8
{
    public enum ActivateOptions
    {
        None = 0x00000000,  // No flags set
        DesignMode = 0x00000001,  // The application is being activated for design mode, and can't create its normal window
        NoErrorUI = 0x00000002,  // Suppress an error dialog if the app fails to activate.
        NoSplashScreen = 0x00000004,  // Do not show the splash screen when the app is activated. NOTE: additional flags may be required
    }

    [ComImport, Guid("2e941141-7f97-4756-ba1d-9decde894a3d"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IApplicationActivationManager
    {
        // Activates the specified immersive application for the "Launch" contract, passing the provided arguments
        // string into the application.  Callers can obtain the process Id of the application instance fulfilling this contract.
        IntPtr ActivateApplication([In] String appUserModelId, [In] String arguments, [In] ActivateOptions options, [Out] out UInt32 processId);
        IntPtr ActivateForFile([In] String appUserModelId, [In] IntPtr /*IShellItemArray* */ itemArray, [In] String verb, [Out] out UInt32 processId);
        IntPtr ActivateForProtocol([In] String appUserModelId, [In] IntPtr /* IShellItemArray* */itemArray, [Out] out UInt32 processId);
    }

    // https://msdn.microsoft.com/en-us/library/windows/desktop/hh706903%28v=vs.85%29.aspx
    [ComImport, Guid("45BA127D-10A8-46EA-8AB7-56EA9078943C")]//Application Activation Manager
    public class ApplicationActivationManager : IApplicationActivationManager
    {
        [MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)/*, PreserveSig*/]
        public extern IntPtr ActivateApplication([In] String appUserModelId, [In] String arguments, [In] ActivateOptions options, [Out] out UInt32 processId);
        [MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
        public extern IntPtr ActivateForFile([In] String appUserModelId, [In] IntPtr /*IShellItemArray* */ itemArray, [In] String verb, [Out] out UInt32 processId);
        [MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
        public extern IntPtr ActivateForProtocol([In] String appUserModelId, [In] IntPtr /* IShellItemArray* */itemArray, [Out] out UInt32 processId);
    }
}
"@

$appman = New-Object Win8.ApplicationActivationManager

function Get-MetroApp {
  [string]$entry = 'HKCU:\Software\Classes\ActivatableClasses\Package'
  foreach ($appkey in (Get-ChildItem -Path $entry | Select-Object -ExpandProperty 'PSPath')) {
    $id = $null
    try {
      if (Test-Path (Join-Path $appkey 'Server')) {
        $id = (Get-ChildItem -Path (Join-Path $appkey 'Server') | Where-Object { $_.pspath -notmatch 'BackgroundTransferHost.1' } | Get-ItemProperty -Name 'AppUserModelId').'AppUserModelId'
      }
    } catch {
    }
    if ($id) {
      $possibleclassidkeys = Get-ChildItem (Join-Path $appkey 'ActivatableClassID') | Select-Object -ExpandProperty 'PSPath'
      # we look for the app key first, then app.wwa, and then any other key if neither returns an entrypoint
      $key = $possibleclassidkeys | ? { $_ -match 'app$' }
      $entrypoint = $null
      if ($key) {
        if (Test-Path (Join-Path $key CustomAttributes)) {
          $entrypoint = (Get-ItemProperty (Join-Path $key CustomAttributes)).('appobject.entrypoint')
        }
      }
      if (!$entrypoint) {
        $key = $possibleclassidkeys | ? { $_ -match 'app.wwa$' }
        if ($key) {
          if (Test-Path (Join-Path $key CustomAttributes)) {
            $entrypoint = (Get-ItemProperty (Join-Path $key CustomAttributes)).('appobject.entrypoint')
          }
        }
      }
      if (!$entrypoint) {
        foreach ($key in $possibleclassidkeys) {
          if (Test-Path (Join-Path $key CustomAttributes)) {
            $entrypoint = (Get-ItemProperty (Join-Path $key CustomAttributes)).('appobject.entrypoint')
            break
          }
        }
      }
      New-Object psobject -Property ([ordered]@{
          EntryPoint = $entrypoint
          ID = $id
        })
    }
  }
}

function Start-MetroApp {
  param(
    [Parameter(Mandatory = $true,Position = 0,ValueFromPipelineByPropertyName = $true)]
    [string]$ID
  )
  $appman.ActivateApplication($ID,$null,[Win8.ActivateOptions]::None,[ref]0)
}
