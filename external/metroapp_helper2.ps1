# origin: http://poshcode.org/6479


Add-Type -TypeDefinition @'
using System;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

namespace StartMetroApp {
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
    [ComImport]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    [Guid("43826d1e-e718-42ee-bc55-a1e261c37bfe")]
    public interface IShellItem
    {
    }

    [ComImport]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    [Guid("b63ea76d-1f85-456f-a19c-48159efa858b")]
    public interface IShellItemArray
    {
    }

    public static class MainProgram
    {
        [DllImport("shell32.dll", CharSet = CharSet.Unicode, PreserveSig = false)]
        private static extern void SHCreateItemFromParsingName(
            [In] [MarshalAs(UnmanagedType.LPWStr)] string pszPath,
            [In] IntPtr pbc,
            [In] [MarshalAs(UnmanagedType.LPStruct)] Guid iIdIShellItem,
            [Out] [MarshalAs(UnmanagedType.Interface, IidParameterIndex = 2)] out IShellItem iShellItem);

        [DllImport("shell32.dll", CharSet = CharSet.Unicode, PreserveSig = false)]
        private static extern void SHCreateShellItemArrayFromShellItem(
            [In] [MarshalAs(UnmanagedType.Interface, IidParameterIndex = 2)] IShellItem psi,
            [In] [MarshalAs(UnmanagedType.LPStruct)] Guid iIdIShellItem,
            [Out] [MarshalAs(UnmanagedType.Interface, IidParameterIndex = 2)] out IShellItemArray iShellItemArray);


        public static IShellItemArray GetShellItemArray(string sourceFile)
        {
            IShellItem item = GetShellItem(sourceFile);
            IShellItemArray array = GetShellItemArray2(item);

            return array;
        }

        public static IShellItem GetShellItem(string sourceFile)
        {
            IShellItem iShellItem = null;
            Guid iIdIShellItem = new Guid("43826d1e-e718-42ee-bc55-a1e261c37bfe");
            SHCreateItemFromParsingName(sourceFile, IntPtr.Zero, iIdIShellItem, out iShellItem);

            return iShellItem;
        }

        public static IShellItemArray GetShellItemArray2(IShellItem shellItem)
        {
            IShellItemArray iShellItemArray = null;
            Guid iIdIShellItemArray = new Guid("b63ea76d-1f85-456f-a19c-48159efa858b");
            SHCreateShellItemArrayFromShellItem(shellItem, iIdIShellItemArray, out iShellItemArray);

            return iShellItemArray;
        }

        public static void LaunchMetroProgram(string progID, string filePath) {
            ApplicationActivationManager appActiveManager = new ApplicationActivationManager(); 
            uint pid;
            IShellItemArray array = GetShellItemArray(filePath);
   
            appActiveManager.ActivateForFile(progID, array, "Open", out pid);

        }
    }
}
'@

[StartMetroApp.MainProgram]::LaunchMetroProgram( $args[0] , $args[1] )

<#
This script file is used to run a metro app from a command line (e.g. CMD)

Usage: 
PowerShell.exe -ExecutionPolicy Bypass -Command "& '_path_to_this_file'" _execution_string _filename_

For example, if you:
* Save this file as c:\utils\Run4.ps1
* Want to launch Movies and TV
* Want that program to display a file at c:\users\user1\MyMovie.mp4, you would have this command line:
PowerShell.exe -ExecutionPolicy Bypass -Command "& 'c:\utils\Run4.ps1'" Microsoft.ZuneVideo_8wekyb3d8bbwe!Microsoft.ZuneVideo c:\users\user1\MyMovie.mp4

Here is a batch file that will launch Movies & TV:
---- Start LaunchMovies.cmd
@echo off
if *%1*==** goto badArg
for %%F in (%1) do set Q='%%~fF'
PowerShell.exe -ExecutionPolicy Bypass -Command "& 'c:\utils\run4.ps1'" Microsoft.ZuneVideo_8wekyb3d8bbwe!Microsoft.ZuneVideo %Q%
goto done

:badArg
echo Usage: %0 File-to-Play
goto done

:done
---- End LaunchMovies.cmd
#>
