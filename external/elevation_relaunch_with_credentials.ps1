param(
    $password = ''
)
 
# http://blogs.msdn.com/b/virtual_pc_guy/archive/2010/09/23/a-self-elevating-powershell-script.aspx

# Get the ID and security principal of the current user account
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal = new-object System.Security.Principal.WindowsPrincipal($myWindowsID)

# Get the security principal for the Administrator role
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator 

# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole))
   {
   # We are running "as Administrator" - so change the title and background color to indicate this
   $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
   $Host.UI.RawUI.BackgroundColor = "DarkBlue"
   clear-host
   }
else
   {
   # We are not running "as Administrator" - so relaunch as administrator
   # Create a new process object that starts PowerShell
   # https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.process.startinfo?view=netframework-4.0
       $password_obj = convertto-securestring $password -aspl -force
       $user = $env:USERNAME 
    $cred = new-object system.management.automation.pscredential ($user, $password_obj)
if ($cred) {
#   $cred | get-member
write-output $cred.Password
write-output $cred.UserName
write-output $cred.ToString()
# write-output $cred.GetObjectData()
} else {
write-output 'failed to create system.management.automation.pscredential' 
}
Write-Host -NoNewLine "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   # Specify the current script path and name as a parameter
   $newProcess.Arguments = $myInvocation.MyCommand.Definition + (' -cred {0}'   + $cred );
   # Indicate that the process should be elevated
   $newProcess.Verb = "runas";
   # Start the new process
   [System.Diagnostics.Process]::Start($newProcess);
   # Exit from the current, unelevated, process
   exit
   }
# Run your code that needs to be elevated here
$code = Add-Type -TypeDefinition @"
// https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.processstartinfo.arguments?view=netframework-4.0#System_Diagnostics_ProcessStartInfo_Arguments
// Place this code into a console project called ArgsEcho to build the argsecho.exe target

using System;

namespace StartArgs
{
    public class ArgsEcho
    {
        static void Show(string[] args)
        {
            Console.WriteLine("Received the following arguments:\n");
            for (var i = 0; i < args.Length; i++)
            {
                Console.WriteLine("[" + i + "] = " + args[i]);
            }
           
            Console.WriteLine("\nPress any key to exit");
            Console.ReadLine();
        }
    }
}
"@
for($i=0;$i -lt $args.length;$i++)
    {
        "Arg $i is <$($args[$i])>"
    }
Write-Host -NoNewLine "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

