#Copyright (c) 2020 Serguei Kouzmine
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

# origin: https://www.codeproject.com/Articles/5264831/How-to-Send-mouseInputs-using-Csharp
# NOTE: no githib  repository of the original article author is available


param(
  [switch]$debug
)
$code = 
Add-Type -Language CSharp -TypeDefinition @"

using System;
using System.Windows.Forms;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using System.Management.Automation;
using System.Management.Automation.Runspaces;

public class Win32Window : IWin32Window
{
    private IntPtr _hWnd;
    private int _data;
    private string _txtUser;
    private string _txtPassword;

    public int Data
    {
        get { return _data; }
        set { _data = value; }
    }


    public string TxtUser
    {
        get { return _txtUser; }
        set { _txtUser = value; }
    }
    public string TxtPassword
    {
        get { return _txtPassword; }
        set { _txtPassword = value; }
    }

    public Win32Window(IntPtr handle)
    {
        _hWnd = handle;
    }

    public IntPtr Handle
    {
        get { return _hWnd; }
    }
    

[StructLayout(LayoutKind.Sequential)]
public struct KeyboardInput
{
    public ushort wVk;
    public ushort wScan;
    public uint dwFlags;
    public uint time;
    public IntPtr dwExtraInfo;
}

[StructLayout(LayoutKind.Sequential)]
public struct MouseInput {
    public int dx;
    public int dy;
    public uint mouseData;
    public uint dwFlags;
    public uint time;
    public IntPtr dwExtraInfo;
}

[StructLayout(LayoutKind.Sequential)]
public struct HardwareInput {
    public uint uMsg;
    public ushort wParamL;
    public ushort wParamH;
}

[StructLayout(LayoutKind.Explicit)]
public struct InputUnion {
    [FieldOffset(0)] public MouseInput mi;
    [FieldOffset(0)] public KeyboardInput ki;
    [FieldOffset(0)] public HardwareInput hi;
}  

public struct Input {
    public int type;
    public InputUnion u;
}

[Flags]
public enum InputType {
    Mouse = 0,
    Keyboard = 1,
    Hardware = 2
}

    
[Flags]
public enum KeyEventF {
    KeyDown = 0x0000,
    ExtendedKey = 0x0001,
    KeyUp = 0x0002,
    Unicode = 0x0004,
    Scancode = 0x0008
}

[Flags]
public enum MouseEventF {
    Absolute = 0x8000,
    HWheel = 0x01000,
    Move = 0x0001,
    MoveNoCoalesce = 0x2000,
    LeftDown = 0x0002,
    LeftUp = 0x0004,
    RightDown = 0x0008,
    RightUp = 0x0010,
    MiddleDown = 0x0020,
    MiddleUp = 0x0040,
    VirtualDesk = 0x4000,
    Wheel = 0x0800,
    XDown = 0x0080,
    XUp = 0x0100
}

[DllImport("user32.dll", SetLastError = true)]
private static extern uint SendInput(uint nInputs, Input[] pInputs, int cbSize);

[DllImport("user32.dll")]
private static extern IntPtr GetMessageExtraInfo();

[DllImport("User32.dll")]
public static extern bool SetCursorPos(int x, int y);

    public void Do() {
Console.Error.WriteLine("Do");
Input[] mouseInputs = new Input[] {
    new Input {
        type = (int) InputType.Mouse,
        u = new InputUnion {
            mi = new MouseInput {
                dx = 100,
                dy = 100,
                dwFlags = (uint)(MouseEventF.Move | MouseEventF.LeftDown),
                dwExtraInfo = GetMessageExtraInfo()
            }
        }
    },
    new Input {
        type = (int) InputType.Mouse,
        u = new InputUnion {
            mi = new MouseInput {
                dwFlags = (uint)MouseEventF.LeftUp,
                dwExtraInfo = GetMessageExtraInfo()
            }
        }
    }
};

SendInput((uint)mouseInputs.Length, mouseInputs, Marshal.SizeOf(typeof(Input)));
Console.Error.WriteLine("Done");
/*
Input[] kbdInputs = new Input[] {
    new Input {
        type = (int)InputType.Keyboard,
        u = new InputUnion {
            ki = new KeyboardInput {
                wVk = 0,
                wScan = 0x11, // W
                dwFlags = (uint)(KeyEventF.KeyDown | KeyEventF.Scancode),
                dwExtraInfo = GetMessageExtraInfo()
            }
        }
    },
    new Input {
        type = (int)InputType.Keyboard,
        u = new {
            ki = new KeyboardInput{
                wVk = 0,
                wScan = 0x11, // W
                dwFlags = (uint)(KeyEventF.KeyUp | KeyEventF.Scancode),
                dwExtraInfo = GetMessageExtraInfo()
            }
        }
    }
};

SendInput((uint)kbdInputs.Length, kbdInputs, Marshal.SizeOf(typeof(Input)));
*/
// Add-Type : Cannot implicitly convert type 'AnonymousType#1' to 'Win32Window.InputUnion'
    }
}

"@ -ReferencedAssemblies 'System.Windows.Forms.dll',      'System.Data.dll', 'System.Xml.dll'

$caller = New-Object Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)

$caller.Do()

$result = $caller.Data
Write-Debug ("Result is : {0}" -f $result)

start-sleep -millisecond 1000