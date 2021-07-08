using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Globalization;
using System.Runtime.InteropServices;
using System.Threading;

namespace Utils
{
	/// <summary>
	/// Description of Mover.
	/// </summary>
	public class Mover
	{
		[DllImport("user32.dll")]
		static extern IntPtr FindWindow(IntPtr classname, string title);

		[DllImport("user32.dll")]
		static extern void MoveWindow(IntPtr hwnd, int X, int Y, 
			int nWidth, int nHeight, bool rePaint);

		[DllImport("user32.dll")]
		static extern bool GetWindowRect(IntPtr hwnd, out Rectangle rect);

		// based on: https://www.codeproject.com/Tips/472294/Position-a-Windows-Forms-MessageBox-in-Csharp
		// see also: https://www.pinvoke.net/default.aspx/user32.movewindow
		// interesting how width and height are calculated
		// not using rectangle.Right - rectangle.Left, rectangle.Bottom - rectangle.Top
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
