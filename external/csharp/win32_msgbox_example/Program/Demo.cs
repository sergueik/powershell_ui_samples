using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Globalization;
using System.Runtime.InteropServices;
using System.Threading;

namespace Demo {
	public class Example {
		public static void Main() {
			String text = "Do you want to create a new file?";
			String caption = "Caption";
			FindAndMoveMsgBox(100, 100, true, caption);
			switch (MessageBox.Show(text, caption,
				MessageBoxButtons.OK,
				MessageBoxIcon.Exclamation)) {

				case DialogResult.OK:
					break;
				default:
					break;
			}
		}
		[DllImport("user32.dll")]
		static extern IntPtr FindWindow(IntPtr classname, string title);

		[DllImport("user32.dll")]
		static extern void MoveWindow(IntPtr hwnd, int X, int Y, 
			int nWidth, int nHeight, bool rePaint);

		[DllImport("user32.dll")]
		static extern bool GetWindowRect(IntPtr hwnd, out Rectangle rect);

		public static void FindAndMoveMsgBox(int x, int y, bool repaint, string title) {
			var thread = new Thread(() => {
				IntPtr hwnd = IntPtr.Zero;
				// wait to discover MessageBox window handle through window title
				while ((hwnd = FindWindow(IntPtr.Zero, title)) == IntPtr.Zero)
					;
				Rectangle rectangle = new Rectangle();
				GetWindowRect(hwnd, out rectangle);
				MoveWindow(hwnd, x, y, rectangle.Width - rectangle.X, rectangle.Height - rectangle.Y, repaint);
			});
			thread.Start();
		}				
	}

}
