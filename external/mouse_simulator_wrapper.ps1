
# origin: http://www.codeproject.com/Articles/28064/Global-Mouse-and-Keyboard-Library
# origin: http://poshcode.org/6251
# unfinished by the originL AUTRHOR
# review the original documents
# http://msdn.microsoft.com/en-us/library/windows/desktop/ms646302(v=vs.85).aspx
# https://msdn.microsoft.com/en-us/library/windows/desktop/ms646272%28v=vs.85%29.aspx
Add-Type -TypeDefinition @" 

using System;
using System.Drawing;
using System.Reflection;
using System.Windows.Forms;
using System.Runtime.InteropServices;

[assembly: AssemblyTitle("Idle Time")]
[assembly: AssemblyVersion("2.0.0.0")]

namespace IdleTime {
  internal sealed class AssemblyInfo {
    internal Type t;
    internal AssemblyInfo() { t = typeof(frmMain); }
    
    internal string Title {
      get {
        Object[] a = t.Assembly.GetCustomAttributes(typeof(AssemblyTitleAttribute), false);
        return ((AssemblyTitleAttribute)a[0]).Title;
      }
    }
  }
  
  internal static class WinAPI {
    [StructLayout(LayoutKind.Sequential)]
    internal struct PLASTINPUTINFO {
      public uint cbSize;
      public uint dwTime;
    }
    
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    internal static extern bool GetLastInputInfo(ref PLASTINPUTINFO plii);
    
    internal static DateTime LastInput {
      get {
        PLASTINPUTINFO lii = new PLASTINPUTINFO();
        lii.cbSize = (uint)Marshal.SizeOf(typeof(PLASTINPUTINFO));
        GetLastInputInfo(ref lii);
        DateTime bTime = DateTime.Now.AddMilliseconds(-Environment.TickCount);
        DateTime lTime = bTime.AddMilliseconds(lii.dwTime);
        
        return lTime;
      }
    }
    
    internal static TimeSpan IdleTime {
      get {
        return DateTime.Now.Subtract(LastInput);
      }
    }
  }
  
  internal sealed class frmMain : Form {
    public frmMain() {
      InitializeComponent();
      this.Text = (new AssemblyInfo()).Title;
    }

    private Label lblLabel1;
    private Label lblLabel2;
    private Timer tmrUpdate;
    
    private void InitializeComponent() {
      this.lblLabel1 = new Label();
      this.lblLabel2 = new Label();
      this.tmrUpdate = new Timer();
      //
      //lblLabel1
      //
      this.lblLabel1.Location = new Point(13, 13);
      this.lblLabel1.Size = new Size(200, 19);
      this.lblLabel1.Text = "Idle Time: " + WinAPI.IdleTime.ToString();
      //
      //lblLabel2
      //
      this.lblLabel2.Location = new Point(13, 33);
      this.lblLabel2.Size = new Size(200, 19);
      this.lblLabel2.Text = "Last Input: " + WinAPI.LastInput.ToString();
      //
      //tmrUpdate
      //
      this.tmrUpdate.Enabled = true;
      this.tmrUpdate.Interval = 1000;
      this.tmrUpdate.Tick += new EventHandler(tmrUpdate_Tick);
      //
      //frmMain
      //
      this.ClientSize = new Size(300, 70);
      this.Controls.AddRange(new Control[] {this.lblLabel1, this.lblLabel2});
      this.FormBorderStyle = FormBorderStyle.FixedSingle;
      this.MaximizeBox = false;
      this.StartPosition = FormStartPosition.CenterScreen;
    }
    
    private void tmrUpdate_Tick(object sender, EventArgs e) {
      lblLabel1.Text = lblLabel2.Text = String.Empty;
      lblLabel1.Text = "Idle Time: " + WinAPI.IdleTime.ToString();
      lblLabel2.Text = "Last Input: " + WinAPI.LastInput.ToString();
    }
  }
  
  internal sealed class Program {
    [STAThread]
    static void Main() {
      Application.EnableVisualStyles();
      Application.Run(new frmMain());
    }
  }
}
"@ -ReferencedAssemblies 'System.Windows.Forms.dll', 'System.Drawing.dll'

Add-Type -TypeDefinition @" 
// Mouse Simulators

using System;
using System.Text;
using System.Runtime.InteropServices;
using System.Drawing;
using System.Windows.Forms;
using  System.Reflection;
namespace MouseKeyboardLibrary
{


    /// <summary>
    /// Mouse buttons that can be pressed
    /// </summary>
    public enum MouseButton
    {
        // Left = 0x2,
        Left = System.Windows.Forms.MouseButtons.Left,  
        Right = 0x8,
        Middle = 0x20
    }

    /// <summary>
    /// Operations that simulate mouse events
    /// </summary>
    public static class MouseSimulator
    {

        #region Windows API Code
public static MouseButton SelectMouseButton(int button) { 
if (button  == 2 ) {
  return MouseButton.Left;
}

return 0;
}

        [DllImport("user32.dll")]
        static extern int ShowCursor(bool show);

        [DllImport("user32.dll")]
        static extern void mouse_event(int flags, int dX, int dY, int buttons, int extraInfo);

        const int MOUSEEVENTF_MOVE = 0x1;
        const int MOUSEEVENTF_LEFTDOWN = 0x2;
        const int MOUSEEVENTF_LEFTUP = 0x4;
        const int MOUSEEVENTF_RIGHTDOWN = 0x8;
        const int MOUSEEVENTF_RIGHTUP = 0x10;
        const int MOUSEEVENTF_MIDDLEDOWN = 0x20;
        const int MOUSEEVENTF_MIDDLEUP = 0x40;
        const int MOUSEEVENTF_WHEEL = 0x800;
        const int MOUSEEVENTF_ABSOLUTE = 0x8000; 

        #endregion

        #region Properties

        /// <summary>
        /// Gets or sets a structure that represents both X and Y mouse coordinates
        /// </summary>
        public static Point Position
        {
            get
            {
                return new Point(Cursor.Position.X, Cursor.Position.Y);
            }
            set
            {
                Cursor.Position = value;
            }
        }

        /// <summary>
        /// Gets or sets only the mouse's x coordinate
        /// </summary>
        public static int X
        {
            get
            {
                return Cursor.Position.X;
            }
            set
            {
                Cursor.Position = new Point(value, Y);
            }
        }

        /// <summary>
        /// Gets or sets only the mouse's y coordinate
        /// </summary>
        public static int Y
        {
            get
            {
                return Cursor.Position.Y;
            }
            set
            {
                Cursor.Position = new Point(X, value);
            }
        } 

        #endregion

        #region Methods

        /// <summary>
        /// Press a mouse button down
        /// </summary>
        /// <param name="button"></param>
        public static void MouseDown(MouseButton button)
        {
            mouse_event(((int)button), 0, 0, 0, 0);
        }

        /// <summary>
        /// Press a mouse button down
        /// </summary>
        /// <param name="button"></param>
        public static void MouseDown(MouseButtons button)
        {
            switch (button)
            {
                case MouseButtons.Left:
                    MouseDown(MouseButton.Left);
                    break;
                case MouseButtons.Middle:
                    MouseDown(MouseButton.Middle);
                    break;
                case MouseButtons.Right:
                    MouseDown(MouseButton.Right);
                    break;
            }
        }

        /// <summary>
        /// Let a mouse button up
        /// </summary>
        /// <param name="button"></param>
        public static void MouseUp(MouseButton button)
        {
            mouse_event(((int)button) * 2, 0, 0, 0, 0);
        }

        /// <summary>
        /// Let a mouse button up
        /// </summary>
        /// <param name="button"></param>
        public static void MouseUp(MouseButtons button)
        {
            switch (button)
            {
                case MouseButtons.Left:
                    MouseUp(MouseButton.Left);
                    break;
                case MouseButtons.Middle:
                    MouseUp(MouseButton.Middle);
                    break;
                case MouseButtons.Right:
                    MouseUp(MouseButton.Right);
                    break;
            }
        }

        /// <summary>
        /// Click a mouse button (down then up)
        /// </summary>
        /// <param name="button"></param>
        public static void Click(MouseButton button)
        {
            MouseDown(button);
            MouseUp(button);
        }

        /// <summary>
        /// Click a mouse button (down then up)
        /// </summary>
        /// <param name="button"></param>
        public static void Click(MouseButtons button)
        {
            switch (button)
            {
                case MouseButtons.Left:
                    Click(MouseButton.Left);
                    break;
                case MouseButtons.Middle:
                    Click(MouseButton.Middle);
                    break;
                case MouseButtons.Right:
                    Click(MouseButton.Right);
                    break;
            }
        }

        /// <summary>
        /// Double click a mouse button (down then up twice)
        /// </summary>
        /// <param name="button"></param>
        public static void DoubleClick(MouseButton button)
        {
            Click(button);
            Click(button);
        }

        /// <summary>
        /// Double click a mouse button (down then up twice)
        /// </summary>
        /// <param name="button"></param>
        public static void DoubleClick(MouseButtons button)
        {
            switch (button)
            {
                case MouseButtons.Left:
                    DoubleClick(MouseButton.Left);
                    break;
                case MouseButtons.Middle:
                    DoubleClick(MouseButton.Middle);
                    break;
                case MouseButtons.Right:
                    DoubleClick(MouseButton.Right);
                    break;
            }
        }

        /// <summary>
        /// Roll the mouse wheel. Delta of 120 wheels up once normally, -120 wheels down once normally
        /// </summary>
        /// <param name="delta"></param>
        public static void MouseWheel(int delta)
        {

            mouse_event(MOUSEEVENTF_WHEEL, 0, 0, delta, 0);

        }

        /// <summary>
        /// Show a hidden current on currently application
        /// </summary>
        public static void Show()
        {
            ShowCursor(true);
        }

        /// <summary>
        /// Hide mouse cursor only on current application's forms
        /// </summary>
        public static void Hide()
        {
            ShowCursor(false);
        } 

        #endregion

    }

// Mouse Hooks 

    /// <summary>
    /// Captures global mouse events
    /// </summary>
    public class MouseHook : GlobalHook
    {

        #region MouseEventType Enum

        private enum MouseEventType
        {
            None,
            MouseDown,
            MouseUp,
            DoubleClick,
            MouseWheel,
            MouseMove
        }

        #endregion

        #region Events

        public event MouseEventHandler MouseDown;
        public event MouseEventHandler MouseUp;
        public event MouseEventHandler MouseMove;
        public event MouseEventHandler MouseWheel;

        public event EventHandler Click;
        public event EventHandler DoubleClick;

        #endregion

        #region Constructor

        public MouseHook()
        {

            _hookType = WH_MOUSE_LL;

        }

        #endregion

        #region Methods

        protected override int HookCallbackProcedure(int nCode, int wParam, IntPtr lParam)
        {
            
            if (nCode > -1 && (MouseDown != null || MouseUp != null || MouseMove != null))
            {

                MouseLLHookStruct mouseHookStruct =
                    (MouseLLHookStruct)Marshal.PtrToStructure(lParam, typeof(MouseLLHookStruct));

                MouseButtons button = GetButton(wParam);
                MouseEventType eventType = GetEventType(wParam);

                MouseEventArgs e = new MouseEventArgs(
                    button,
                    (eventType == MouseEventType.DoubleClick ? 2 : 1),
                    mouseHookStruct.pt.x,
                    mouseHookStruct.pt.y,
                    (eventType == MouseEventType.MouseWheel ? (int)((mouseHookStruct.mouseData >> 16) & 0xffff) : 0));

                // Prevent multiple Right Click events (this probably happens for popup menus)
                if (button == MouseButtons.Right && mouseHookStruct.flags != 0)
                {
                    eventType = MouseEventType.None;
                }

                switch (eventType)
                {
                    case MouseEventType.MouseDown:
                        if (MouseDown != null)
                        {
                            MouseDown(this, e);
                        }
                        break;
                    case MouseEventType.MouseUp:
                        if (Click != null)
                        {
                            Click(this, new EventArgs());
                        }
                        if (MouseUp != null)
                        {
                            MouseUp(this, e);
                        }
                        break;
                    case MouseEventType.DoubleClick:
                        if (DoubleClick != null)
                        {
                            DoubleClick(this, new EventArgs());
                        }
                        break;
                    case MouseEventType.MouseWheel:
                        if (MouseWheel != null)
                        {
                            MouseWheel(this, e);
                        }
                        break;
                    case MouseEventType.MouseMove:
                        if (MouseMove != null)
                        {
                            MouseMove(this, e);
                        }
                        break;
                    default:
                        break;
                }

            }

            return CallNextHookEx(_handleToHook, nCode, wParam, lParam);

        }

        private MouseButtons GetButton(Int32 wParam)
        {

            switch (wParam)
            {

                case WM_LBUTTONDOWN:
                case WM_LBUTTONUP:
                case WM_LBUTTONDBLCLK:
                    return MouseButtons.Left;
                case WM_RBUTTONDOWN:
                case WM_RBUTTONUP:
                case WM_RBUTTONDBLCLK:
                    return MouseButtons.Right;
                case WM_MBUTTONDOWN:
                case WM_MBUTTONUP:
                case WM_MBUTTONDBLCLK:
                    return MouseButtons.Middle;
                default:
                    return MouseButtons.None;

            }

        }

        private MouseEventType GetEventType(Int32 wParam)
        {

            switch (wParam)
            {

                case WM_LBUTTONDOWN:
                case WM_RBUTTONDOWN:
                case WM_MBUTTONDOWN:
                    return MouseEventType.MouseDown;
                case WM_LBUTTONUP:
                case WM_RBUTTONUP:
                case WM_MBUTTONUP:
                    return MouseEventType.MouseUp;
                case WM_LBUTTONDBLCLK:
                case WM_RBUTTONDBLCLK:
                case WM_MBUTTONDBLCLK:
                    return MouseEventType.DoubleClick;
                case WM_MOUSEWHEEL:
                    return MouseEventType.MouseWheel;
                case WM_MOUSEMOVE:
                    return MouseEventType.MouseMove;
                default:
                    return MouseEventType.None;

            }
        }

        #endregion
        
    }
    /// <summary>
    /// Abstract base class for Mouse and Keyboard hooks
    /// </summary>
    public abstract class GlobalHook
    {

        #region Windows API Code

        [StructLayout(LayoutKind.Sequential)]
        protected class POINT
        {
            public int x;
            public int y;
        }

        [StructLayout(LayoutKind.Sequential)]
        protected class MouseHookStruct
        {
            public POINT pt;
            public int hwnd;
            public int wHitTestCode;
            public int dwExtraInfo;
        }

        [StructLayout(LayoutKind.Sequential)]
        protected class MouseLLHookStruct
        {
            public POINT pt;
            public int mouseData;
            public int flags;
            public int time;
            public int dwExtraInfo;
        }

        [StructLayout(LayoutKind.Sequential)]
        protected class KeyboardHookStruct
        {
            public int vkCode;
            public int scanCode;
            public int flags;
            public int time;
            public int dwExtraInfo;
        }

        [DllImport("user32.dll", CharSet = CharSet.Auto,
           CallingConvention = CallingConvention.StdCall, SetLastError = true)]
        protected static extern int SetWindowsHookEx(
            int idHook,
            HookProc lpfn,
            IntPtr hMod,
            int dwThreadId);

        [DllImport("user32.dll", CharSet = CharSet.Auto,
            CallingConvention = CallingConvention.StdCall, SetLastError = true)]
        protected static extern int UnhookWindowsHookEx(int idHook);


        [DllImport("user32.dll", CharSet = CharSet.Auto,
             CallingConvention = CallingConvention.StdCall)]
        protected static extern int CallNextHookEx(
            int idHook,
            int nCode,
            int wParam,
            IntPtr lParam);

        [DllImport("user32")]
        protected static extern int ToAscii(
            int uVirtKey,
            int uScanCode,
            byte[] lpbKeyState,
            byte[] lpwTransKey,
            int fuState);

        [DllImport("user32")]
        protected static extern int GetKeyboardState(byte[] pbKeyState);

        [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall)]
        protected static extern short GetKeyState(int vKey);

        protected delegate int HookProc(int nCode, int wParam, IntPtr lParam);

        protected const int WH_MOUSE_LL = 14;
        protected const int WH_KEYBOARD_LL = 13;

        protected const int WH_MOUSE = 7;
        protected const int WH_KEYBOARD = 2;
        protected const int WM_MOUSEMOVE = 0x200;
        protected const int WM_LBUTTONDOWN = 0x201;
        protected const int WM_RBUTTONDOWN = 0x204;
        protected const int WM_MBUTTONDOWN = 0x207;
        protected const int WM_LBUTTONUP = 0x202;
        protected const int WM_RBUTTONUP = 0x205;
        protected const int WM_MBUTTONUP = 0x208;
        protected const int WM_LBUTTONDBLCLK = 0x203;
        protected const int WM_RBUTTONDBLCLK = 0x206;
        protected const int WM_MBUTTONDBLCLK = 0x209;
        protected const int WM_MOUSEWHEEL = 0x020A;
        protected const int WM_KEYDOWN = 0x100;
        protected const int WM_KEYUP = 0x101;
        protected const int WM_SYSKEYDOWN = 0x104;
        protected const int WM_SYSKEYUP = 0x105;

        protected const byte VK_SHIFT = 0x10;
        protected const byte VK_CAPITAL = 0x14;
        protected const byte VK_NUMLOCK = 0x90;

        protected const byte VK_LSHIFT = 0xA0;
        protected const byte VK_RSHIFT = 0xA1;
        protected const byte VK_LCONTROL = 0xA2;
        protected const byte VK_RCONTROL = 0x3;
        protected const byte VK_LALT = 0xA4;
        protected const byte VK_RALT = 0xA5;

        protected const byte LLKHF_ALTDOWN = 0x20;

        #endregion

        #region Private Variables

        protected int _hookType;
        protected int _handleToHook;
        protected bool _isStarted;
        protected HookProc _hookCallback;

        #endregion

        #region Properties

        public bool IsStarted
        {
            get
            {
                return _isStarted;
            }
        }

        #endregion

        #region Constructor

        public GlobalHook()
        {

            Application.ApplicationExit += new EventHandler(Application_ApplicationExit);

        }

        #endregion

        #region Methods

        public void Start()
        {

            if (!_isStarted &&
                _hookType != 0)
            {

                // Make sure we keep a reference to this delegate!
                // If not, GC randomly collects it, and a NullReference exception is thrown
                _hookCallback = new HookProc(HookCallbackProcedure);

                _handleToHook = SetWindowsHookEx(
                    _hookType,
                    _hookCallback,
                    Marshal.GetHINSTANCE(Assembly.GetExecutingAssembly().GetModules()[0]),
                    0);

                // Were we able to sucessfully start hook?
                if (_handleToHook != 0)
                {
                    _isStarted = true;
                }

            }

        }

        public void Stop()
        {

            if (_isStarted)
            {

                UnhookWindowsHookEx(_handleToHook);

                _isStarted = false;

            }

        }

        protected virtual int HookCallbackProcedure(int nCode, Int32 wParam, IntPtr lParam)
        {
           
            // This method must be overriden by each extending hook
            return 0;

        }

        protected void Application_ApplicationExit(object sender, EventArgs e)
        {

            if (_isStarted)
            {
                Stop();
            }

        }

        #endregion

    }


}

"@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Drawing.dll','mscorlib.dll'



# Move mouse cursor to Top Left of screen
[MouseKeyboardLibrary.MouseSimulator]::X = 0
[MouseKeyboardLibrary.MouseSimulator]::Y = 0
write-output '.'
0..10 | foreach-object {
# Multiple ambiguous overloads found for "MouseDown" and the argument count: "1" ?
[MouseKeyboardLibrary.MouseSimulator]::MouseDown([System.Windows.Forms.MouseButtons]::Left)
# Move the mouse cursor to the right by 20 pixels
[MouseKeyboardLibrary.MouseSimulator]::X += 100
[MouseKeyboardLibrary.MouseSimulator]::Y += 100
[MouseKeyboardLibrary.MouseSimulator]::MouseUp([System.Windows.Forms.MouseButtons]::Left)
write-output '.'
# Move the mouse cursor to the right by 20 pixels
[MouseKeyboardLibrary.MouseSimulator]::X += 100
[MouseKeyboardLibrary.MouseSimulator]::Y += 100
write-output '.'
}


#[MouseKeyboardLibrary.MouseSimulator]::MouseDown([MouseKeyboardLibrary.MouseSimulator]::SelectMouseButton(2))
#[MouseKeyboardLibrary.MouseSimulator]::MouseUp([MouseKeyboardLibrary.MouseSimulator]::SelectMouseButton(2))

<#
# cannot access struct from Powershell
# Press Left Mouse Button Down
[MouseKeyboardLibrary.MouseSimulator]::MouseDown([System.Windows.Forms.MouseButtons]::Left)

# Let Left Mouse Button Up
[MouseKeyboardLibrary.MouseSimulator]::MouseUp([System.Windows.Forms.MouseButton]::Left)

# Press down and Let up Left Mouse Button
# (equivalent to two lines above)
[MouseKeyboardLibrary.MouseSimulator]::Click([System.Windows.Forms.MouseButton]::Left)

# Double click Left Mouse button
# (equivalent to two Click()s above)
[MouseKeyboardLibrary.MouseSimulator]::DoubleClick([System.Windows.Forms.MouseButton]::Left)
#>