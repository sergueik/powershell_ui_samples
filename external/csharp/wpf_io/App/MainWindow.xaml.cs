using System;
using System.Diagnostics;
using System.Web;
using System.Windows;
using System.Windows.Interop;

namespace App {
	public partial class MainWindow : Window {
		public MainWindow() {
			InitializeComponent();
			this.Loaded += (s, e) =>  {
				MainWindow.WindowHandle = new WindowInteropHelper(Application.Current.MainWindow).Handle;
				HwndSource.FromHwnd(MainWindow.WindowHandle).AddHook(new HwndSourceHook(HandleMessages));
			};
			this.Title = String.Format("Parameter passing example - Process Id: {0}", Process.GetCurrentProcess().Id);
		}

		public static IntPtr WindowHandle { get; private set; }

		internal static void HandleParameter(string[] args) {
			if (Application.Current!= null )  {
				var mainWindow = (MainWindow) Application.Current.MainWindow;
				if (args != null && args.Length > 0 && args[0] != null && args[0].IndexOf("codeprojectsample", StringComparison.CurrentCultureIgnoreCase) >= 0 && Uri.IsWellFormedUriString(args[0], UriKind.RelativeOrAbsolute)) {
					var url = new Uri(args[0]);
					var parsedUrl = HttpUtility.ParseQueryString(url.Query);
					mainWindow.textBlock.Text = String.Format("Article Id: {0}\r\nName: {1}",parsedUrl.Get("artid"),parsedUrl.Get("name") );
				} else {
					mainWindow.textBlock.Text = String.Format("{0}\n{1}", mainWindow.textBlock.Text, String.Join(" ", args));
				}
			}
		}

		private static IntPtr HandleMessages(IntPtr handle, int message, IntPtr wParameter, IntPtr lParameter, ref Boolean handled) {
			if (handle != MainWindow.WindowHandle)
				return IntPtr.Zero;

			var data = UnsafeNative.GetMessage(message, lParameter);

			if (data != null) {
				if (Application.Current.MainWindow == null)
					return IntPtr.Zero;

				if (Application.Current.MainWindow.WindowState == WindowState.Minimized)
					Application.Current.MainWindow.WindowState = WindowState.Normal;

				UnsafeNative.SetForegroundWindow(new WindowInteropHelper(Application.Current.MainWindow).Handle);

				var args = data.Split(' ');
				HandleParameter(args);
				handled = true;
			}

			return IntPtr.Zero;
		}
	}
}