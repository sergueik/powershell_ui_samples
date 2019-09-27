using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace PasswordGeneration
{

	// https://stackoverflow.com/questions/2914004/
	//     rich-text-box-padding-between-text-and-border

	// *********************************** class RichTextBoxExtensions

	public static class RichTextBoxExtensions
	{

		private const int EMGETRECT = 0xB2;
		private const int EMSETRECT = 0xB3;

		// *********************************************** struct RECT

		[StructLayout(LayoutKind.Sequential)]
		private struct RECT
		{
			public readonly int Left;
			public readonly int Top;
			public readonly int Right;
			public readonly int Bottom;

			private RECT(int left, 
				int top, 
				int right, 
				int bottom)
			{
				Left = left;
				Top = top;
				Right = right;
				Bottom = bottom;    
			}

			public RECT(Rectangle r)
				: this(r.Left, 
					r.Top, 
					r.Right, 
					r.Bottom)
			{

			}
		}
		// struct RECT

		[DllImport(@"User32.dll", EntryPoint = @"SendMessage", CharSet = CharSet.Auto)]
		private static extern int SendMessageRefRect(
			IntPtr  hWnd, 
			uint    msg, 
			int     wParam, 
			ref RECT    rect);

		[DllImport(@"user32.dll", EntryPoint = @"SendMessage", CharSet = CharSet.Auto)]
		private static extern int SendMessage(
			IntPtr      hwnd, 
			int         wMsg, 
			IntPtr      wParam, 
			ref Rectangle   lParam);

		private static void SetFormattingRect(this TextBoxBase textbox, Rectangle rect)
		{
			var rectangle = new RECT(rect);

			SendMessageRefRect(textbox.Handle, 
				EMSETRECT, 
				0, 
				ref rectangle);

		}
		
		private static Rectangle GetFormattingRect(this TextBoxBase textbox)
		{
			var rect = new Rectangle();

			SendMessage(textbox.Handle, 
				EMGETRECT, 
				(IntPtr)0, 
				ref rect);
			return (rect);

		}
		// GetFormattingRect

		// *********************************************** set_margins

		public static void set_margins(this TextBoxBase textbox, 
			int         left, 
			int         top, 
			int         right, 
			int         bottom)
		{
			Rectangle rect = textbox.GetFormattingRect();
			Rectangle rectangle = new Rectangle(
				                      left, 
				                      top, 
				                      (rect.Width - left - right), 
				                      (rect.Height - top - bottom));

			textbox.SetFormattingRect(rectangle);

		}
		// set_margins

		// *********************************************** set_margins

		public static void set_margins(this TextBoxBase textbox, 
			int         margin)
		{

			set_margins(textbox, 
				margin,
				margin,
				margin,
				margin);

		}
		// set_margins

	}
	// class RichTextBoxExtensions

}
// namespace PasswordGeneration
