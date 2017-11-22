# origin: https://stackoverflow.com/questions/8353581/how-to-handle-close-event-of-powershell-window-if-user-clicks-on-closex-butt

$code = @"

using System;
using System.Runtime.InteropServices;
using System.Management.Automation;
using System.Management.Automation.Runspaces;

namespace MyNamespace {
	public static class MyClass	{
		public static void SetHandler()	{
			SetConsoleCtrlHandler(new HandlerRoutine(ConsoleCtrlCheck), true);
		}

		private static bool ConsoleCtrlCheck(CtrlTypes ctrlType) {
			switch (ctrlType) {
				case CtrlTypes.CTRL_C_EVENT:
					Console.WriteLine("CTRL+C received!");
					return false;

				case CtrlTypes.CTRL_CLOSE_EVENT:
					Console.WriteLine("CTRL_CLOSE_EVENT received!");
					return true;

				case CtrlTypes.CTRL_BREAK_EVENT:
					Console.WriteLine("CTRL+BREAK received!");
					return false;

				case CtrlTypes.CTRL_LOGOFF_EVENT:
					Console.WriteLine("User is logging off!");
					return false;

				case CtrlTypes.CTRL_SHUTDOWN_EVENT:
					Console.WriteLine("User is shutting down!");
					return false;
			}
			return false;
		}

		[DllImport("Kernel32")]
		public static extern bool SetConsoleCtrlHandler(HandlerRoutine Handler, bool Add);
	
		public delegate bool HandlerRoutine(CtrlTypes CtrlType);

		public enum CtrlTypes {
			CTRL_C_EVENT = 0,
			CTRL_BREAK_EVENT,
			CTRL_CLOSE_EVENT,
			CTRL_LOGOFF_EVENT = 5,
			CTRL_SHUTDOWN_EVENT
		}
	}
}
"@

$text = Add-Type  -TypeDefinition $code -Language CSharp
$rs = [System.Management.Automation.Runspaces.Runspace]::DefaultRunspace
[MyNamespace.MyClass]::SetHandler() 
start-sleep 10000     