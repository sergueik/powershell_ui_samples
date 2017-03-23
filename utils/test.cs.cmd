/* 2> NUL|| goto :COMPILE
:COMPILE
@REM origin: /media/sergueik/a35562e4-5c34-4d37-a18b-b474323221cf/sergueik/KASRM/cmd
@REM Polyglot script
@REM Embedded C# Script
@REM Usage: queryrss.cmd  500o 502o 503o 504o 507o 510o 512o 514o 516o 532o
@REM queryrss.cmd  900o 901o 902o 903o 904o
@REM queryrss.cmd  600o 602o 603o 604o 607o 510o 512o 514o 516o 532o
@REM For Powerdhell polyglot script see
@REM http://stackoverflow.com/questions/2609985/how-to-run-a-powershell-script-within-a-windows-batch-file
@REM http://blogs.msdn.com/jaybaz_ms/archive/2007/04/26/powershell-polyglot.aspx@for /f "tokens=3" %%. in ('echo') do @set IS_ECHO=%%.
echo OFF
setlocal
rem if %1. == . goto :USAGE
set COMPLUSVERSION=v2.0.50727
PATH=%PATH%;%SYSTEMROOT%\Microsoft.NET\Framework\%COMPLUSVERSION%
csc.exe /NOLOGO  -r:%SYSTEMROOT%\Microsoft.NET\Framework\%COMPLUSVERSION%\system.dll -platform:x86 -r:AutoItX3Lib.dll /out:%TEMP%\%~n0.exe %~dpf0
if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto :UNSUPPORTED
if %errorlevel% == 9009 echo You do not have Managed Tools in your PATH&goto :UNSUPPORTED
for /F "tokens=*" %%. in ('where System.dll') do copy /y "%%." %TEMP% >NUL
copy AutoItX3Lib.dll  %TEMP% >NUL
%TEMP%\%~n0.exe %*
endlocal
if %DEBUG%. == .  del /q %TEMP%\%~n0.exe
if /i %IS_ECHO% == "on." echo on
goto :EOF
:USAGE
echo. Sample Usage:
echo.
echo. %~nx0 /job:^<JOBNUMBER^> /command:^<COMMAND^> /interop:^<LEGACY^>
REM WINDIFF  %INPUT% %OUTPUT%
goto :EOF
*/
using System;
using System.ComponentModel;
using System.Collections;
using AutoItX3Lib;
// Base name of the file
// produced by tlbimp.exe

using System.Reflection;

using System;
using System.Text;
using System.Runtime.InteropServices;
using System.Collections;
using System.ComponentModel;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Windows.Forms;
using System.IO;
using System.ComponentModel;
using System.Runtime.InteropServices;
using System.Text;
using System.Collections;
using System.Collections.Specialized;
using System.Text.RegularExpressions;

namespace LegacyCOMInterops {
	public class Runner{
		public static void Main(string[] args) {
			ParseArgs p = new ParseArgs(System.Environment.CommandLine);
			string sCommand = p.GetMacro("command");
			string sTargetFilename = p.GetMacro("target");

			AutoItX3Class task = new AutoItX3Class();
			Console.WriteLine(task.ToString());
			task.Run(sCommand, ".", 1);
		}
	}
	
	public class ParseArgs {
		private StringDictionary _MACROS;
		private StringDictionary AllMacros {
			get { return _MACROS; }
		}

		private bool DefinedMacro(string sMacro){
			return (_MACROS.ContainsKey(sMacro));
		}

		public string GetMacro(string sMacro) {
			if (DefinedMacro(sMacro)) {
				return _MACROS[sMacro];
			} else {
				return String.Empty;
				// not null
			}
		}

		public string SetMacro(string sMacro, string sValue) {
			_MACROS[sMacro] = sValue;
			return _MACROS[sMacro];
		}

		public ParseArgs(string sLine) {
			_MACROS = new StringDictionary();
			string s = @"(\s|^)(?<token>(/|-{1,2})(\S+))";
			Regex r = new Regex(s,
				          RegexOptions.ExplicitCapture | RegexOptions.IgnoreCase);
			MatchCollection m = r.Matches(sLine);
			if (m != null) {
				for (int i = 0; i < m.Count; i++) {
					string sToken = m[i].Groups["token"].Value.ToString();
					// Console.WriteLine("{0}", sToken);
					ParseSwithExpression(sToken);
				}
			}
			return;
		}

		private void ParseSwithExpression(string sToken) {
			string w = @"[^\=\:]+";
			string s = @"(/|\-{1,2})(?<macro>" + w + @")([\=\:](?<value>" + w + @"))*";
			// will get System.ArgumentException
			//  _message=(0x04a795bc) "parsing "(?<macro>[a-z0-9_-\@]+)([\=\:](?<value>[a-z0-9_-\@]+))*" - [x-y] range in reverse order."
			Regex r = new Regex(s,
				          RegexOptions.ExplicitCapture | RegexOptions.IgnoreCase);
			MatchCollection m = r.Matches(sToken);
			if (m != null) {
				for (int i = 0; i < m.Count; i++) {
					string sMacro = m[i].Groups["macro"].Value.ToString();
					string sValue = m[i].Groups["value"].Value;
					if (sValue == "") {
						sValue = "true";
					}
					SetMacro(sMacro, sValue);
					Console.WriteLine("{0} = \"{1}\"", sMacro, GetMacro(sMacro));
				}
			}
			return;
		}
	}
}
