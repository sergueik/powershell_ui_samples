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
# see also: https://stackoverflow.com/questions/28538234/sending-a-keyboard-input-with-java-jna-and-sendinput

param(
  [switch]$debug
)
# original author's demo project code with few modifications to  make work

add-type -language CSharp -typedefinition @"

using System;
using System.Threading;
using System.Runtime.InteropServices;

namespace SendInputsDemo {
    public class Program {
        public static void Main()  {
            // If we want to click a special (extended) key like Volume up
            // We need to send to inputs with ExtendedKey and Scancode flags
            // First is 0xe0 and the second is the special key scancode we want
            // You can read more on that here -> https://www.win.tue.nl/~aeb/linux/kbd/scancodes-6.html#microsoft
            InputSender.SendKeyboardInput(new InputSender.KeyboardInput[]  {
                new InputSender.KeyboardInput {
                    wScan = 0xe0,
                    dwFlags = (uint)(InputSender.KeyEventF.ExtendedKey | InputSender.KeyEventF.Scancode),
                },
                new InputSender.KeyboardInput {
                    wScan = 0x30,
                    dwFlags = (uint)(InputSender.KeyEventF.ExtendedKey | InputSender.KeyEventF.Scancode)
                }
            });  // Volume +

            // Using our ClickKey wrapper to press W
            // To see more scancodes see this site -> https://www.win.tue.nl/~aeb/linux/kbd/scancodes-1.html
            InputSender.ClickKey(0x11); // W

            Thread.Sleep(1000);

            // Setting the cursor position
            InputSender.SetCursorPosition(100, 100);

            Thread.Sleep(1000);

            // Getting the cursor position
            var point = InputSender.GetCursorPosition();
            Console.WriteLine(String.Format("Cursor position is: x={0}, y={1}", point.X, point.Y));

            Thread.Sleep(1000);

            // Setting the cursor position RELATIVE to the current position
            InputSender.SendMouseInput(new InputSender.MouseInput[] {
                new InputSender.MouseInput {
                    dx = 100,
                    dy = 100,
                    dwFlags = (uint)InputSender.MouseEventF.Move
                }
            });
        }
    }
    public class InputSender {
        #region Imports/Structs/Enums
        [StructLayout(LayoutKind.Sequential)]
        public struct KeyboardInput {
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
        static extern uint SendInput(uint nInputs, Input[] pInputs, int cbSize);

        [DllImport("user32.dll")]
        static extern IntPtr GetMessageExtraInfo();

        [DllImport("user32.dll", SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        static extern bool GetCursorPos(out POINT lpPoint);
        // https://www.pinvoke.net/default.aspx/user32.getcursorpos

        [StructLayout(LayoutKind.Sequential)]
        public struct POINT {
            public int X;
            public int Y;
        }

        [DllImport("User32.dll")]
        private static extern bool SetCursorPos(int x, int y);
        #endregion

        #region Wrapper Methods
        public static POINT GetCursorPosition() {
        	// feature 'declaration expression cannot be used ?
        	POINT point;
            GetCursorPos(out point);
            return point;
        }

        public static void SetCursorPosition(int x, int y) {
            SetCursorPos(x, y);
        }

        public static void SendKeyboardInput(KeyboardInput[] kbInputs) {
            Input[] inputs = new Input[kbInputs.Length];

            for (int i = 0; i < kbInputs.Length; i++) {
                inputs[i] = new Input {
                    type = (int)InputType.Keyboard,
                    u = new InputUnion {
                        ki = kbInputs[i]
                    }
                };
            }

            SendInput((uint)inputs.Length, inputs, Marshal.SizeOf(typeof(Input)));
        }

        public static void ClickKey(ushort scanCode) {
            var inputs = new KeyboardInput[] {
                new KeyboardInput {
                    wScan = scanCode,
                    dwFlags = (uint)(KeyEventF.KeyDown | KeyEventF.Scancode),
                    dwExtraInfo = GetMessageExtraInfo()
                },
                new KeyboardInput {
                    wScan = scanCode,
                    dwFlags = (uint)(KeyEventF.KeyUp | KeyEventF.Scancode),
                    dwExtraInfo = GetMessageExtraInfo()
                }
            };
            SendKeyboardInput(inputs);
        }

        public static void SendMouseInput(MouseInput[] mInputs) {
            Input[] inputs = new Input[mInputs.Length];

            for (int i = 0; i < mInputs.Length; i++) {
                inputs[i] = new Input {
                    type = (int)InputType.Mouse,
                    u = new InputUnion {
                        mi = mInputs[i]
                    }
                };
            }

            SendInput((uint)inputs.Length, inputs, Marshal.SizeOf(typeof(Input)));
        }
        #endregion
    }

}

"@
[SendInputsDemo.Program]::Main()
start-sleep -millisecond 1000

$code = add-type -language CSharp -typedefinition @"
using System;
using System.Windows.Forms;
using System.Drawing;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using System.Management.Automation;
using System.Management.Automation.Runspaces;

// connect to the caller window
public class Win32Window : IWin32Window {

	private IntPtr _hWnd;
	private int _data;
	private string _txtUser;
	private string _txtPassword;

	// https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.iwin32window
	public Win32Window(IntPtr handle) {
		_hWnd = handle;
	}

	public IntPtr Handle {
		get { return _hWnd; }
	}

	public int Data {
		get { return _data; }
		set { _data = value; }
	}

	public string TxtUser {
		get { return _txtUser; }
		set { _txtUser = value; }
	}
	public string TxtPassword {
		get { return _txtPassword; }
		set { _txtPassword = value; }
	}

[StructLayout(LayoutKind.Sequential)]
public struct RECT{
     public int Left;
     public int Top;
     public int Right;
     public int Bottom;
}

  [DllImport("user32.dll", CharSet = CharSet.Auto, ExactSpelling = true)]
  public static extern IntPtr GetForegroundWindow();

[DllImport("user32.dll")]
[return: MarshalAs(UnmanagedType.Bool)]
static extern bool GetWindowRect(HandleRef hWnd, out RECT lpRect);


   [StructLayout(LayoutKind.Sequential)]
   public struct KeyboardInput {
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
				type = (int)InputType.Mouse,
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
				type = (int)InputType.Mouse,
				u = new InputUnion {
					mi = new MouseInput {
						dwFlags = (uint)MouseEventF.LeftUp,
						dwExtraInfo = GetMessageExtraInfo()
					}
				}
			}
		};

    RECT rectangle;

    GetWindowRect(new HandleRef(this, _hWnd), out rectangle);
    Console.Error.WriteLine(String.Format("Settimg cursor position to x={0} y={1} of the specific window {2}", (rectangle.Right + rectangle.Left)/2, (rectangle.Bottom + rectangle.Top)/2, _hWnd));

    SetCursorPos((rectangle.Right + rectangle.Left)/2, (rectangle.Bottom + rectangle.Top)/2);

    Console.Error.WriteLine(String.Format("Sending {0} mouse inputs", mouseInputs.Length.ToString()));
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
"@ -referencedassemblies 'System.Windows.Forms.dll', 'System.Drawing.dll', 'System.Data.dll', 'System.Xml.dll'

# TODO: choose another handle than console window, or second mouse event is not delivered
$title = 'Untitled'
$window_handle = Get-Process -name 'notepad' -errorAction SilentlyContinue| Where-Object { $_.MainWindowTitle -match $title } | select-object -first 1 | select-object -expandproperty MainWindowHandle
write-output ('Dealing with window handle "{0}"' -f $window_handle)

if ($window_handle -eq $null -or $window_handle -eq '') {
  $window_handle = [System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle
  write-output ('Using current process handle "{0}"' -f $window_handle)
}
write-output ('Dealing with window handle {0}' -f $window_handle)
$demo = new-object Win32Window -ArgumentList ($window_handle)

$demo.Do()

$result = $caller.Data
write-output ('Result is : {0}' -f $result)

start-sleep -millisecond 1000
