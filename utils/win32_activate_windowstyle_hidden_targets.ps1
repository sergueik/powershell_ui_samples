#Copyright (c) 2015,2020 Serguei Kouzmine
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the 'Software'), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in`
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

param (
  [int]$copies = 4,
  [int]$delay = 4,
  [switch]$showall,
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
# https://www.pinvoke.net/default.aspx/user32.iswindowvisible

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

	public delegate bool CallBackPtr(IntPtr hwnd, int lParam);	private Results results = new Results();
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

	// https://blogs.msdn.microsoft.com/jaredpar/2008/10/14/pinvoke-and-bool-or-should-i-say-bool/
	[DllImport("user32.dll")]
	private static extern int IsWindowVisible(IntPtr hWnd);

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
	public bool Report(IntPtr hwnd, int lParam) {
		String windowClassName = GetWindowClassName(hwnd);
		// testing the window style
		int style = (int)GetWindowLongPtr(hwnd, (int)GWL.GWL_STYLE);
		if (filterClassName == null || string.Compare(windowClassName, filterClassName, true, CultureInfo.InvariantCulture) == 0) {
			IntPtr lngPid = System.IntPtr.Zero;
			GetWindowThreadProcessId(hwnd, out lngPid);
			int processId = Convert.ToInt32(/* Marshal.ReadInt32 */ lngPid.ToString());
			bool visible = (IsWindowVisible(hwnd) == 1);
			// bool visible = (( style & WindowStyles.WS_VISIBLE ) == WindowStyles.WS_VISIBLE  );
			bool topmost = (( style & WindowStyles.WS_EX_TOPMOST   ) == WindowStyles.WS_EX_TOPMOST   );
			results.addResult(windowClassName, null, Convert.ToInt32(hwnd.ToString()), processId, visible, topmost);
			if (debug) {
				Console.Error.WriteLine( "window handle: " + hwnd + " pid: " + processId + " visible: "  + visible + " " + (style & WindowStyles.WS_VISIBLE).ToString("x") );
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
		EnumWindows(new CallBackPtr(Report), 0);
		return;
	}
}
public abstract class WindowStyles {
	public const uint WS_VISIBLE = 0x10000000;
	public const uint WS_DISABLED = 0x08000000;
	public const uint WS_SYSMENU = 0x00080000;

	//Extended Window Styles
	public const uint WS_EX_DLGMODALFRAME     = 0x00000001;
	public const uint WS_EX_TOPMOST       = 0x00000008;
	// most of the class is truncated
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
  public void addResult(String className, int handle, bool visible) {
    this.data.Add(new Result(className, handle, visible));
  }
  public void addResult(String className, String title, int handle, bool visible) {
    this.data.Add(new Result(className, title, handle, visible));
  }
  public void addResult(String className, String title, int handle, int processid, bool visible) {
    this.data.Add(new Result(className, title, handle, processid, visible));
  }
  public void addResult(String className, String title, int handle, bool visible, bool topmost) {
    this.data.Add(new Result(className, title, handle, visible,topmost));
  }
  public void addResult(String className, String title, int handle, int processid, bool visible, bool topmost) {
    this.data.Add(new Result(className, title, handle, processid, visible, topmost));
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
  private bool visible;
  public bool Visible {
    get { return visible; }
    set {
      visible = value;
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
    this.visible = false;
    this.topmost = false;
  }
  public Result(String className, int handle, int processid) {
    this.className = className;
    this.handle = handle;
		this.processid = processid;
    this.visible = false;
    this.topmost = false;
  }
  public Result(String className, int handle, bool visible) {
    this.className = className;
    this.title = null;
    this.handle = handle;
    this.visible = visible;
    this.topmost = false;
  }
  public Result(String className, int handle, int processid, bool visible) {
    this.className = className;
    this.title = null;
    this.handle = handle;
		this.processid = processid;
    this.visible = visible;
    this.topmost = false;
  }
  public Result(String className, String title, int handle, bool visible) {
    this.className = className;
    this.title = title;
    this.handle = handle;
    this.visible = visible;
    this.topmost = false;
  }
  public Result(String className, String title, int handle, int processid, bool visible) {
    this.className = className;
    this.title = title;
    this.handle = handle;
		this.processid = processid;
    this.visible = visible;
    this.topmost = false;
  }
  public Result(String className, String title, int handle, bool visible, bool topmost) {
    this.className = className;
    this.title = title;
    this.handle = handle;
    this.visible = visible;
    this.topmost = topmost;
  }
  public Result(String className, String title, int handle, int processid, bool visible, bool topmost) {
    this.className = className;
    this.title = title;
    this.handle = handle;
		this.processid = processid;
    this.visible = visible;
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
if ($showall){
  # commenting next line to list every found windows: Note: verbose
  write-output 'Show all windows'
} else {
  $helper.FilterClassName = 'ConsoleWindowClass'
  write-output 'Show all console windows'
}
$helper.Collect()
$results = $helper.Results

if ($debug) {
  $results.Data | format-list
}

$results.Data | foreach-object {
  $result =  $_
	$handle = $result.Handle
	$processid = $result.Processid
	$visible = $result.Visible
	$className = $result.ClassName
  if ($debug) {
    write-debug ('Process id: {0}' -f $processid)
    write-debug ('window handle: {0}' -f $handle)
    write-debug ('Visible: {0}' -f $visible)
  }	
  if (($className -eq 'ConsoleWindowClass') -and ($processid -ne $null) -and  (-not $visible )) {
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

