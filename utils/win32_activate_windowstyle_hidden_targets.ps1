#Copyright (c) 2015,2020 Serguei Kouzmine
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the 'Software'), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.


#
# Activate a console window of already running command started earlier with -windowstyle hidden options
#
# NOTE: Shell can not manage window that is minimized to become a tray item:
#  poor thing no longer has a main window title
#
# http://www.cyberforum.ru/powershell/thread2553302.html
#
# see also: https://www.cyberforum.ru/powershell/thread2587244.html (in Russian
# same topic discussed for spying for the window handle
# of the already launched process with -windowstyle hidden
# TODO: extract into standlone script

param (
  [int]$copies = 4,
  [int]$delay = 4,
  [switch]$debug
)
$savedDebugpreference = $debugpreference
if ([bool]$PSBoundParameters['debug'].IsPresent) {
  $debugpreference = 'continue'
}
# origins:
# https://www.pinvoke.net/default.aspx/user32.enumwindows
# with few typo fixes made
# https://www.pinvoke.net/default.aspx/user32.getwindowthreadprocessid
# https://www.pinvoke.net/default.aspx/coredll/GetClassName.html
# https://www.pinvoke.net/default.aspx/user32.getwindowlong
# https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getwindowlonga
# http://pinvoke.net/default.aspx/Constants/Window%20styles.html
add-type -typedefinition @'

using System;
using System.Runtime.InteropServices;
using System.IO;
using System.Threading;
using System.Diagnostics;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Globalization;

public class EnumReport {

	public delegate bool CallBackPtr(IntPtr hwnd, int lParam);
	private StringBuilder reports = new StringBuilder();
	private Results results = new Results();
	public Results Results {
		get {
			return results;
		}
	}
	private Boolean debug;
	public Boolean Debug {
		set {
			debug = value;
		}
	}
	protected string filterClassName;
	public string FilterClassName {
		set {
			filterClassName = value;
		}
	}
	protected String report = null;

	public string Report {
		get { return report; }
	}
	[DllImport("user32.dll")]
	private static extern int EnumWindows(CallBackPtr callPtr, int lPar);

	[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
	static extern int GetClassName(IntPtr hWnd, StringBuilder lpClassName, int nMaxCount);

	[DllImport("user32.dll", SetLastError = true)]
	public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out IntPtr lpdwProcessId);

	[DllImport("user32.dll", EntryPoint = "GetWindowLong")]
	private static extern IntPtr GetWindowLongPtr32(IntPtr hWnd, int nIndex);

	[DllImport("user32.dll", EntryPoint = "GetWindowLongPtr")]
	private static extern IntPtr GetWindowLongPtr64(IntPtr hWnd, int nIndex);

	// detect CPU through size of pointer hack to make code work on both 32 and 64 window 
	public static IntPtr GetWindowLongPtr(IntPtr hWnd, int nIndex) {
		return (IntPtr.Size == 8) ? GetWindowLongPtr64(hWnd, nIndex) : GetWindowLongPtr32(hWnd, nIndex);
	}
	public enum GWL {
		GWL_WNDPROC = (-4),
		GWL_HINSTANCE = (-6),
		GWL_HWNDPARENT = (-8),
		GWL_STYLE = (-16),
		GWL_EXSTYLE = (-20),
		GWL_USERDATA = (-21),
		GWL_ID = (-12)
	}
	public bool ReportGenerator(IntPtr hwnd, int lParam) {
		String windowClassName = GetWindowClassName(hwnd);
		// testing the window style
		int style = (int)GetWindowLongPtr(hwnd, (int)GWL.GWL_STYLE);
		if (string.Compare(windowClassName, filterClassName, true, CultureInfo.InvariantCulture) == 0) {
			IntPtr lngPid = System.IntPtr.Zero;
			GetWindowThreadProcessId(hwnd, out lngPid);
			int processId = Convert.ToInt32(/* Marshal.ReadInt32 */ lngPid.ToString());
			String report = "window handle: " + hwnd + " pid: " + processId + "\n";
			bool visible = (( style & WindowStyles.WS_VISIBLE ) == WindowStyles.WS_VISIBLE  );
			results.addResult(windowClassName, Convert.ToInt32(hwnd.ToString())/* , processId */, visible);
			reports.Append(report);
			if (debug) {
				Console.Error.WriteLine(report + "style: " + (style & WindowStyles.WS_VISIBLE));
			}
		}
		return true;   // continue
	}
	private static string GetWindowClassName(IntPtr hWnd) {
		StringBuilder ClassName = new StringBuilder(256);
		int nRet = GetClassName(hWnd, ClassName, ClassName.Capacity);
		return (nRet != 0) ? ClassName.ToString() : null;
	}
	public void Collect() {
		reports.Clear();
		EnumWindows(new CallBackPtr(ReportGenerator), 0);
		report = reports.ToString();
		if (debug) {
			Console.Error.WriteLine(report);
		}
		return;
	}
}
public abstract class WindowStyles
{
	public const uint WS_OVERLAPPED = 0x00000000;
	public const uint WS_POPUP = 0x80000000;
	public const uint WS_CHILD = 0x40000000;
	public const uint WS_MINIMIZE = 0x20000000;
	public const uint WS_VISIBLE = 0x10000000;
	public const uint WS_DISABLED = 0x08000000;
	public const uint WS_CLIPSIBLINGS = 0x04000000;
	public const uint WS_CLIPCHILDREN = 0x02000000;
	public const uint WS_MAXIMIZE = 0x01000000;
	public const uint WS_CAPTION = 0x00C00000;
	/* WS_BORDER | WS_DLGFRAME  */
	public const uint WS_BORDER = 0x00800000;
	public const uint WS_DLGFRAME = 0x00400000;
	public const uint WS_VSCROLL = 0x00200000;
	public const uint WS_HSCROLL = 0x00100000;
	public const uint WS_SYSMENU = 0x00080000;
	public const uint WS_THICKFRAME = 0x00040000;
	public const uint WS_GROUP = 0x00020000;
	public const uint WS_TABSTOP = 0x00010000;

	public const uint WS_MINIMIZEBOX = 0x00020000;
	public const uint WS_MAXIMIZEBOX = 0x00010000;
	// rest is truncated
}

// TODO: introduce namespace, wrap it up
public class Results {
  private List<Result> data = new List<Result>();
  public List<Result> Data {
    get {
      return data;
    }
  }
  public Results() {
    this.data = new List<Result>();
  }

  public void addResult(String className, int handle) {
    this.data.Add(new Result(className, handle));
  }
  public void addResult(String className, int handle, bool active) {
    this.data.Add(new Result(className, handle, active));
  }
  public void addResult(String className, String title, int handle, bool active) {
    this.data.Add(new Result(className, title, handle, active));
  }
  public void addResult(String className, String title, int handle, bool active, bool topmost) {
    this.data.Add(new Result(className, title, handle, active,topmost));
  }
}
public class Result {
  private String className;
  public string ClassName { 
    get { return className; }
    set { 
      className = value; 
    }
  }
  private String title;
  public string Title { 
    get { return title; }
    set { 
      title = value; 
    }
  }
  private bool active;
  public bool Active { 
    get { return active; }
    set { 
      active = value; 
    }
  }
  private bool topmost;
  public bool Topmost { 
    get { return topmost; }
    set { 
      topmost = value; 
    }
  }
  private int handle;
  public int Handle { 
    get { return handle; }
    set { 
      handle = value; 
    }
  }
  private int processid;
  public int Processid { 
    get { return processid; }
    set { 
      processid = value; 
    }
  }
  public Result() { }
  public Result(String className, int handle) {
    this.className = className;
    this.handle = handle;
    this.active = false;
    this.topmost = false;
  }
  public Result(String className, int handle, bool active) {
    this.className = className;
    this.title = null;
    this.handle = handle;
    this.active = active;
    this.topmost = false;
  }
  public Result(String className, String title, int handle, bool active) {
    this.className = className;
    this.title = title;
    this.handle = handle;
    this.active = active;
    this.topmost = false;
  }
  public Result(String className, String title, int handle, bool active, bool topmost) {
    this.className = className;
    this.title = title;
    this.handle = handle;
    this.active = active;
    this.topmost = topmost;
  }
}

'@

write-debug ('Launch and hide {0} dummies' -f $copies )

$demoScript = "${env:TEMP}\example.cmd"

out-File -FilePath $demoScript -Encoding ASCII -InputObject 'powershell.exe -windowstyle hidden -Command "&{write-output \"wait\"; start-sleep 10; write-output \"Done\"}"'

1..$copies | foreach-object {
  start-process -FilePath 'C:\Windows\System32\cmd.exe' -argumentList "start cmd.exe /c ${demoScript}"
}

# a different pid may be chosen
$ownProcessid = (get-process -id $pid).id

Add-Type -MemberDefinition @'
private const int SW_SHOWMINIMIZED  = 2;
private const int SW_SHOWNOACTIVATE = 4;
private const int SW_RESTORE    = 9;

[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
'@ -namespace win32 -name 'helper'

start-sleep $delay

write-debug ('Ignore own process: {0}' -f $ownProcessid )

$helper = new-object -typeName 'EnumReport'
$helper.Debug = $debug
$helper.FilterClassName = 'ConsoleWindowClass'
$helper.Collect()
$results = $helper.Results
$results | foreach-object { 
  format-list -inputObject $_.Data	
}


$reports = $helper.Report -split '\n'
$reportsLog = "${env:TEMP}\reports.txt"
if ($debug) {
  # save a copy of the reports to enable testing the following code quickly
  out-File -FilePath $reportsLog -Encoding ASCII -InputObject  $reports
  $reports = (get-content -path $reportsLog )  -split '\n'
}
$reports | where-object { -not ($_ -match ('pid: {0}' -f $ownProcessid) ) }|
  foreach-object {
  $line = $_
  if ($line -eq '' ) { return }
  write-debug ('Line: "{0}"' -f $line)
  $matcher = 'window handle: (\d+) pid: (\d+) *$'
  $handle = $line -replace $matcher, '$1'
  $processid = $line -replace $matcher, '$2'
  # $handle = $line -replace 'window handle: (\d+) pid: (\d+) *$' , '$1'
  # $processid = $line -replace 'window handle: (\d+) pid: (\d+) *$' , '$2'
  if ($processid -ne $null) {
    if ($debug) {
      write-debug ('Process id: {0}' -f $processid)
      $processName = get-process -id $processid | select-object -expandproperty processName
      $commandLine = get-WmiObject Win32_Process -Filter "processid = ${processid}" | select-Object -expandproperty CommandLine
      write-debug ('Process name: {0}' -f $processName)
      write-debug ('Commandline: {0}' -f $commandLine)
    }
    write-debug ('Raise the window {0}' -f $handle)
    [win32.helper]::ShowWindowAsync(0 + $handle, 4) | out-null
  }

}
$debugpreference = $savedDebugpreference
exit 0



