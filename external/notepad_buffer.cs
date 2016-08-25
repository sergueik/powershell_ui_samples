// origin: https://blogs.msdn.microsoft.com/oldnewthing/20140908-00/?p=53

using System;
using System.Diagnostics;
using System.Windows.Automation;
using System.Runtime.InteropServices;

class Program
{
  static void Main(string[] args)
  {
    // Slurp stdin into a string.
    var everything = Console.In.ReadToEnd();

    // Fire up a brand new Notepad.
    var process = new Process();
    process.StartInfo.UseShellExecute = false;
    process.StartInfo.FileName = @"C:\Windows\System32\notepad.exe";
    process.Start();
    process.WaitForInputIdle();

    // Find the Notepad edit control.
    var edit = AutomationElement.FromHandle(process.MainWindowHandle)
        .FindFirst(TreeScope.Subtree,
                   new PropertyCondition(
                       AutomationElement.ControlTypeProperty,
                       ControlType.Document));

    // Shove the text into that window.
    var nativeHandle = new IntPtr((int)edit.GetCurrentPropertyValue(
                      AutomationElement.NativeWindowHandleProperty));
    SendMessage(nativeHandle, WM_SETTEXT, IntPtr.Zero, everything);
  }

  [DllImport("user32.dll", EntryPoint="SendMessage", CharSet=CharSet.Unicode)]
  static extern IntPtr SendMessage(
    IntPtr windowHandle, int message, IntPtr wParam, string text);
  const int WM_SETTEXT = 0x000C;
}