////////////////////////////////////////////////////////////////////////////////////
// MessageBoxIndirect.cs
//
// By Scott McMaster (smcmaste@hotmail.com)
// 01/10/2003
//
// THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, 
// EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES 
// OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
////////////////////////////////////////////////////////////////////////////////////
using System;
using System.Text;
using System.Drawing;
using System.Diagnostics;
using System.Windows.Forms;
using System.Runtime.InteropServices;

namespace Utils {
	public class MessageBoxIndirect {
		// From winuser.h
		private const uint MB_OK = 0x00000000;
		private const uint MB_OKCANCEL = 0x00000001;
		private const uint MB_ABORTRETRYIGNORE = 0x00000002;
		private const uint MB_YESNOCANCEL = 0x00000003;
		private const uint MB_YESNO = 0x00000004;
		private const uint MB_RETRYCANCEL = 0x00000005;
		private const uint MB_HELP = 0x00004000;

		private const uint MB_USERICON = 0x00000080;

		private const uint MB_ICONHAND = 0x00000010;
		private const uint MB_ICONQUESTION = 0x00000020;
		private const uint MB_ICONEXCLAMATION = 0x00000030;
		private const uint MB_ICONASTERISK = 0x00000040;
		private const uint MB_ICONWARNING = MB_ICONEXCLAMATION;
		private const uint MB_ICONERROR = MB_ICONHAND;
		private const uint MB_ICONINFORMATION = MB_ICONASTERISK;
		private const uint MB_ICONSTOP = MB_ICONHAND;

		private const uint MB_DEFBUTTON1 = 0x00000000;
		private const uint MB_DEFBUTTON2 = 0x00000100;
		private const uint MB_DEFBUTTON3 = 0x00000200;

		private const uint MB_RTLREADING = 0x00100000;
		private const uint MB_DEFAULT_DESKTOP_ONLY = 0x00020000;
		private const uint MB_SERVICE_NOTIFICATION = 0x00200000;  // assumes WNT >= 4
		private const uint MB_RIGHT = 0x00080000;

		private const uint MB_APPLMODAL = 0x00000000;
		private const uint MB_SYSTEMMODAL = 0x00001000;
		private const uint MB_TASKMODAL = 0x00002000;

		// For setting window icon.
		private const uint WM_SETICON = 0x00000080;
		private const uint ICON_SMALL = 0;
		private const uint ICON_BIG = 1;

		private const int WH_CBT = 5;

		private const int HCBT_CREATEWND = 3;

		public enum MessageBoxExModality : uint {
			AppModal = MB_APPLMODAL,
			SystemModal = MB_SYSTEMMODAL,
			TaskModal = MB_TASKMODAL
		}

		[StructLayout(LayoutKind.Sequential)]
		public struct POINT { 
			public long x; 
			public long y; 
		};
			
		[StructLayout(LayoutKind.Sequential)]
		public struct HELPINFO { 
			public uint cbSize; 
			public int iContextType;
			public int iCtrlId; 
			public IntPtr hItemHandle; 
			public IntPtr dwContextId; 
			public POINT MousePos;

			public static HELPINFO UnmarshalFrom( IntPtr lParam ){
				return (HELPINFO) Marshal.PtrToStructure( lParam, typeof( HELPINFO ) );
			}
		};

		[StructLayout(LayoutKind.Sequential)]
		public struct MSGBOXPARAMS { 
			public uint cbSize; 
			public IntPtr hwndOwner; 
			public IntPtr hInstance;
			public String lpszText; 
			public String lpszCaption; 
			public uint dwStyle;
			public IntPtr lpszIcon;
			public IntPtr dwContextHelpId; 
			public MsgBoxCallback lpfnMsgBoxCallback; 
			public uint dwLanguageId; 
		};
		public delegate void MsgBoxCallback( HELPINFO lpHelpInfo );
		public delegate int HookProc(int nCode, IntPtr wParam, IntPtr lParam);

		[DllImport("user32", EntryPoint="MessageBoxIndirect")]
		private static extern int _MessageBoxIndirect( ref MSGBOXPARAMS msgboxParams );

		[DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
		public static extern int SetWindowsHookEx(int idHook, HookProc lpfn, IntPtr hInstance, int threadId);

		[DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
		public static extern bool UnhookWindowsHookEx(int idHook);

		[DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
		public static extern int CallNextHookEx(int idHook, int nCode, IntPtr wParam, IntPtr lParam);

		[DllImport("user32.dll")]
		public static extern int GetClassName(IntPtr hwnd, StringBuilder lpClassName, int nMaxCount);

		[DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = false)]
		public static extern IntPtr SendMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);

		[DllImport("User32.dll", CharSet=CharSet.Auto)]
		public static extern IntPtr LoadIcon(IntPtr hInstance, IntPtr lpIconName);

		private string _text;
		private string _caption;
		private IWin32Window _owner;
		private IntPtr _instance;
		private IntPtr _sysSmallIcon;
		private int _contextID = 0;
		private uint _languageID;
		private MsgBoxCallback _callback;
		private MessageBoxButtons _buttons = MessageBoxButtons.OK;
		private bool _showHelp = false;
		private IntPtr _userIcon = IntPtr.Zero;
		private MessageBoxIcon _icon = MessageBoxIcon.None;
		private MessageBoxDefaultButton _defaultButton = MessageBoxDefaultButton.Button1;
		private MessageBoxOptions _options = 0;
		private MessageBoxExModality _modality = MessageBoxExModality.AppModal;
		private int hHook;

		public string Text {
			get { return _text; }
			set { _text = value; }
		}

		public string Caption {
			get { return _caption; }
			set { _caption = value; }
		}

		public IntPtr UserIcon {
			get { return _userIcon; }
			set { _userIcon = value; }
		}

		public IntPtr SysSmallIcon {
			get { return _sysSmallIcon; }
			set { _sysSmallIcon = value; }
		}

		public IWin32Window Owner {
			get { return _owner; }
			set { _owner = value; }
		}

		public IntPtr Instance {
			get { return _instance; }
			set { _instance = value; }
		}

		public uint LanguageID {
			get { return _languageID; }
			set { _languageID = value; }
		}

		public int ContextHelpID {
			get { return _contextID; }
			set { _contextID = value; }
		}

		public MsgBoxCallback Callback {
			get { return _callback; }
			set { _callback = value; }
		}

		public MessageBoxButtons Buttons {
			get { return _buttons; }
			set { _buttons = value; }
		}

		public bool ShowHelp {
			get { return _showHelp; }
			set { _showHelp = value; }
		}

		public MessageBoxIcon Icon {
			get { return _icon; }
			set { _icon = value; }
		}

		public MessageBoxDefaultButton DefaultButton {
			get { return _defaultButton; }
			set { _defaultButton = value; }
		}

		public MessageBoxOptions Options {
			get { return _options; }
			set { _options = value; }
		}

		public MessageBoxExModality Modality {
			get { return _modality; }
			set { _modality = value; }
		}


		private void EnsureInstance() {
			if( Instance == IntPtr.Zero )
			{
				// The user did not specify an instance to load from, so default to the currently executing
				// module.
				Instance = Marshal.GetHINSTANCE( System.Reflection.Assembly.GetExecutingAssembly().GetModules()[0] );
			}
		}

		private uint BuildStyle() {
			uint result = 0;

			if( Buttons == MessageBoxButtons.OK ) {
				result |= MB_OK;
			} else if( Buttons == MessageBoxButtons.OKCancel ) {
				result |= MB_OKCANCEL;
			} else if( Buttons == MessageBoxButtons.AbortRetryIgnore ) {
				result |= MB_ABORTRETRYIGNORE;
			} else if( Buttons == MessageBoxButtons.RetryCancel ) {
				result |= MB_RETRYCANCEL;
			} else if( Buttons == MessageBoxButtons.YesNo ) {
				result |= MB_YESNO;
			} else if( Buttons == MessageBoxButtons.YesNoCancel ) {
				result |= MB_YESNOCANCEL;
			}

			// HELP
			if( ShowHelp ) {
				result |= MB_HELP;
			}

			// USER ICON
			if( UserIcon != IntPtr.Zero ) {
				result |= MB_USERICON;
				EnsureInstance();
			}

			// ICON
			if( Icon == MessageBoxIcon.Asterisk ) {
				result |= MB_ICONASTERISK;
			} else if( Icon == MessageBoxIcon.Error ) {
				result |= MB_ICONERROR;
			} else if( Icon == MessageBoxIcon.Exclamation ) {
				result |= MB_ICONEXCLAMATION;
			} else if( Icon == MessageBoxIcon.Hand ) {
				result |= MB_ICONHAND;
			} else if( Icon == MessageBoxIcon.Information ) {
				result |= MB_ICONINFORMATION;
			} else if( Icon == MessageBoxIcon.Question ) {
				result |= MB_ICONQUESTION;
			} else if( Icon == MessageBoxIcon.Stop ) {
				result |= MB_ICONSTOP;
			} else if( Icon == MessageBoxIcon.Warning ) {
				result |= MB_ICONWARNING;
			}

			// DEFAULT BUTTON
			if( DefaultButton == MessageBoxDefaultButton.Button1 ) {
				result |= MB_DEFBUTTON1;
			} else if( DefaultButton == MessageBoxDefaultButton.Button2 ) {
				result |= MB_DEFBUTTON2;
			} else if( DefaultButton == MessageBoxDefaultButton.Button3 ) {
				result |= MB_DEFBUTTON3;
			}

			// OPTIONS
			result |= (uint) Options;

			// MODALITY
			result |= (uint) Modality;
			return result;
		}

		private int CbtHookProc(int nCode, IntPtr wParam, IntPtr lParam) {
			if( nCode == HCBT_CREATEWND ) {
				// Make sure this is really a dialog.
				StringBuilder sb = new StringBuilder();
				sb.Capacity = 100;
				GetClassName( wParam, sb, sb.Capacity );
				string className = sb.ToString();
				if( className == "#32770" ) {
					// Found it, look to set the icon if necessary.
					if( _sysSmallIcon != IntPtr.Zero ) {
						EnsureInstance();
						IntPtr hSmallSysIcon = LoadIcon( Instance, new IntPtr( (long) ( (short) _sysSmallIcon.ToInt32() ) ) );
						if( hSmallSysIcon != IntPtr.Zero ) {
							SendMessage( wParam, WM_SETICON, new IntPtr(ICON_SMALL), hSmallSysIcon );
						}
					}
				}
			}

			return CallNextHookEx(hHook, nCode, wParam, lParam);
		}

		public DialogResult Show() {
			MSGBOXPARAMS parms = new MSGBOXPARAMS();
			parms.dwStyle = BuildStyle();
			parms.lpszText = Text;
			parms.lpszCaption = Caption;
			if( Owner != null ) {
				parms.hwndOwner = Owner.Handle;
			}
			parms.hInstance = Instance;
			parms.cbSize = (uint) Marshal.SizeOf(typeof(MSGBOXPARAMS));
			parms.lpfnMsgBoxCallback = Callback;
			parms.lpszIcon = UserIcon;
			parms.dwLanguageId = LanguageID;
			parms.dwContextHelpId = new IntPtr(_contextID);

			DialogResult retval = DialogResult.Cancel;
			try {
				// Only hook if we have a reason to, namely, to set the custom icon.
				if( _sysSmallIcon != IntPtr.Zero ) {
					HookProc CbtHookProcedure = new HookProc(CbtHookProc);
					hHook = SetWindowsHookEx(WH_CBT, CbtHookProcedure, (IntPtr) 0, AppDomain.GetCurrentThreadId());
				}

				retval = (DialogResult) _MessageBoxIndirect( ref parms );
			} finally {
				if( hHook > 0 ) {
					UnhookWindowsHookEx(hHook);
					hHook = 0;
				}
			}

			return retval;
		}

		public MessageBoxIndirect(string text) {
			Text = text;
		}

		public MessageBoxIndirect(IWin32Window owner, string text) {
			Owner = owner;
			Text = text;
		}

		public MessageBoxIndirect(string text, string caption) {
			Text = text;
			Caption = caption;
		}

		public MessageBoxIndirect(IWin32Window owner, string text, string caption) {
			Owner = owner;
			Text = text;
			Caption = caption;
		}

		public MessageBoxIndirect(string text, string caption, MessageBoxButtons buttons) {
			Text = text;
			Caption = caption;
			Buttons = buttons;
		}

		public MessageBoxIndirect(IWin32Window owner, string text, string caption, MessageBoxButtons buttons) {
			Owner = owner;
			Text = text;
			Caption = caption;
			Buttons = buttons;
		}

		public MessageBoxIndirect(string text, string caption, MessageBoxButtons buttons, MessageBoxIcon icon) {
			Text = text;
			Caption = caption;
			Buttons = buttons;
			Icon = icon;
		}

		public MessageBoxIndirect(IWin32Window owner, string text, string caption, MessageBoxButtons buttons, MessageBoxIcon icon) {
			Owner = owner;
			Text = text;
			Caption = caption;
			Buttons = buttons;
			Icon = icon;
		}

		public MessageBoxIndirect(string text, string caption, MessageBoxButtons buttons, MessageBoxIcon icon, MessageBoxDefaultButton defaultButton) {
			Text = text;
			Caption = caption;
			Buttons = buttons;
			Icon = icon;
			DefaultButton = defaultButton;
		}

		public MessageBoxIndirect(IWin32Window owner, string text, string caption, MessageBoxButtons buttons, MessageBoxIcon icon, MessageBoxDefaultButton defaultButton) {
			Owner = owner;
			Text = text;
			Caption = caption;
			Buttons = buttons;
			Icon = icon;
			DefaultButton = defaultButton;
		}
		public MessageBoxIndirect(string text, string caption, MessageBoxButtons buttons, MessageBoxIcon icon, MessageBoxDefaultButton defaultButton, MessageBoxOptions options) {
			Text = text;
			Caption = caption;
			Buttons = buttons;
			Icon = icon;
			DefaultButton = defaultButton;
			Options = options;
		}

		public MessageBoxIndirect(IWin32Window owner, string text, string caption, MessageBoxButtons buttons, MessageBoxIcon icon, MessageBoxDefaultButton defaultButton, MessageBoxOptions options) {
			Owner = owner;
			Text = text;
			Caption = caption;
			Buttons = buttons;
			Icon = icon;
			DefaultButton = defaultButton;
			Options = options;
		}

	}

}
