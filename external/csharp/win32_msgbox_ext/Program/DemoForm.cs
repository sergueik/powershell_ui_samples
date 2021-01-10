////////////////////////////////////////////////////////////////////////////////////
// DemoForm.cs
//
// By Scott McMaster (smcmaste@hotmail.com)
// 01/10/2003
//
// THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, 
// EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES 
// OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
////////////////////////////////////////////////////////////////////////////////////

using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Threading;
using Utils;
using System.Diagnostics;
using System.Runtime.InteropServices;

namespace MessageBoxIndirectApp {
	public class DemoForm : System.Windows.Forms.Form {
		private System.Windows.Forms.StatusBar statusBar1;
		private System.Windows.Forms.Button cmdPassLangID;
		private System.Windows.Forms.Button cmdCustomIcon;
		private System.Windows.Forms.Button cmdAppModal;
		private System.Windows.Forms.Button cmdSysModal;
		private System.Windows.Forms.Button cmdTaskModal;
		private System.Windows.Forms.Button cmdHelpButton;
		private System.Windows.Forms.Button cmdHelpMsg;

		private System.ComponentModel.Container components = null;
		private System.Windows.Forms.Button cmdCustomIconAuxDll;
	
		// From winuser.h
		private const int WM_HELP = 0x0053;

		private IntPtr hWin32Resources = IntPtr.Zero;

		public DemoForm() {
			InitializeComponent();
		}

		protected override void Dispose(bool disposing) {
			if (disposing) {
				if (components != null) {
					components.Dispose();
				}
			}
			base.Dispose(disposing);
		}
		private void InitializeComponent() {
			this.cmdPassLangID = new System.Windows.Forms.Button();
			this.cmdCustomIcon = new System.Windows.Forms.Button();
			this.statusBar1 = new System.Windows.Forms.StatusBar();
			this.cmdAppModal = new System.Windows.Forms.Button();
			this.cmdSysModal = new System.Windows.Forms.Button();
			this.cmdTaskModal = new System.Windows.Forms.Button();
			this.cmdHelpButton = new System.Windows.Forms.Button();
			this.cmdHelpMsg = new System.Windows.Forms.Button();
			this.cmdCustomIconAuxDll = new System.Windows.Forms.Button();
			this.SuspendLayout();
			// 
			// cmdPassLangID
			// 
			this.cmdPassLangID.Location = new System.Drawing.Point(8, 8);
			this.cmdPassLangID.Name = "cmdPassLangID";
			this.cmdPassLangID.Size = new System.Drawing.Size(280, 24);
			this.cmdPassLangID.TabIndex = 0;
			this.cmdPassLangID.Text = "Pass a LangID";
			this.cmdPassLangID.Click += new System.EventHandler(this.cmdPassLangID_Click);
			// 
			// cmdCustomIcon
			// 
			this.cmdCustomIcon.Location = new System.Drawing.Point(8, 32);
			this.cmdCustomIcon.Name = "cmdCustomIcon";
			this.cmdCustomIcon.Size = new System.Drawing.Size(280, 24);
			this.cmdCustomIcon.TabIndex = 1;
			this.cmdCustomIcon.Text = "Custom Icon (This Exe, Needs CmdLine Build)";
			this.cmdCustomIcon.Click += new System.EventHandler(this.cmdCustomIcon_Click);
			// 
			// statusBar1
			// 
			this.statusBar1.Location = new System.Drawing.Point(0, 244);
			this.statusBar1.Name = "statusBar1";
			this.statusBar1.Size = new System.Drawing.Size(292, 22);
			this.statusBar1.TabIndex = 2;
			// 
			// cmdAppModal
			// 
			this.cmdAppModal.Location = new System.Drawing.Point(8, 56);
			this.cmdAppModal.Name = "cmdAppModal";
			this.cmdAppModal.Size = new System.Drawing.Size(280, 24);
			this.cmdAppModal.TabIndex = 3;
			this.cmdAppModal.Text = "App Modal";
			this.cmdAppModal.Click += new System.EventHandler(this.cmdAppModal_Click);
			// 
			// cmdSysModal
			// 
			this.cmdSysModal.Location = new System.Drawing.Point(8, 80);
			this.cmdSysModal.Name = "cmdSysModal";
			this.cmdSysModal.Size = new System.Drawing.Size(280, 24);
			this.cmdSysModal.TabIndex = 4;
			this.cmdSysModal.Text = "Sys Modal";
			this.cmdSysModal.Click += new System.EventHandler(this.cmdSysModal_Click);
			// 
			// cmdTaskModal
			// 
			this.cmdTaskModal.Location = new System.Drawing.Point(8, 104);
			this.cmdTaskModal.Name = "cmdTaskModal";
			this.cmdTaskModal.Size = new System.Drawing.Size(280, 24);
			this.cmdTaskModal.TabIndex = 5;
			this.cmdTaskModal.Text = "Task Modal";
			this.cmdTaskModal.Click += new System.EventHandler(this.cmdTaskModal_Click);
			// 
			// cmdHelpButton
			// 
			this.cmdHelpButton.Location = new System.Drawing.Point(8, 128);
			this.cmdHelpButton.Name = "cmdHelpButton";
			this.cmdHelpButton.Size = new System.Drawing.Size(280, 24);
			this.cmdHelpButton.TabIndex = 6;
			this.cmdHelpButton.Text = "Help Button (Callback)";
			this.cmdHelpButton.Click += new System.EventHandler(this.cmdHelpButton_Click);
			// 
			// cmdHelpMsg
			// 
			this.cmdHelpMsg.Location = new System.Drawing.Point(8, 152);
			this.cmdHelpMsg.Name = "cmdHelpMsg";
			this.cmdHelpMsg.Size = new System.Drawing.Size(280, 24);
			this.cmdHelpMsg.TabIndex = 7;
			this.cmdHelpMsg.Text = "Help Button (WM_HELP)";
			this.cmdHelpMsg.Click += new System.EventHandler(this.cmdHelpMsg_Click);
			// 
			// cmdCustomIconAuxDll
			// 
			this.cmdCustomIconAuxDll.Location = new System.Drawing.Point(8, 176);
			this.cmdCustomIconAuxDll.Name = "cmdCustomIconAuxDll";
			this.cmdCustomIconAuxDll.Size = new System.Drawing.Size(280, 24);
			this.cmdCustomIconAuxDll.TabIndex = 8;
			this.cmdCustomIconAuxDll.Text = "Custom Icon (Separate DLL)";
			this.cmdCustomIconAuxDll.Click += new System.EventHandler(this.cmdCustomIconAuxDll_Click);
			// 
			// DemoForm
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(292, 266);
			this.Controls.Add(this.cmdCustomIconAuxDll);
			this.Controls.Add(this.cmdHelpMsg);
			this.Controls.Add(this.cmdHelpButton);
			this.Controls.Add(this.cmdTaskModal);
			this.Controls.Add(this.cmdSysModal);
			this.Controls.Add(this.cmdAppModal);
			this.Controls.Add(this.statusBar1);
			this.Controls.Add(this.cmdCustomIcon);
			this.Controls.Add(this.cmdPassLangID);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.Name = "DemoForm";
			this.Text = "MessageBoxIndirect Demo";
			this.ResumeLayout(false);

		}
		[STAThread]
		static void Main() {
			Application.Run(new DemoForm());
		}

		protected override void WndProc(ref Message m) {
			switch (m.Msg) {
				case WM_HELP:
					MessageBoxIndirect.HELPINFO helpInfo = MessageBoxIndirect.HELPINFO.UnmarshalFrom(m.LParam);
					MessageBox.Show("Help WM_HELP, context id = " + helpInfo.dwContextId.ToString());
					break;
			}
			base.WndProc(ref m);
		}

		private void SetResult(DialogResult r) {
			statusBar1.Text = "Result:  " + r.ToString();
		}

		private void cmdPassLangID_Click(object sender, System.EventArgs e) {
			MessageBoxIndirect mb = new MessageBoxIndirect("Pass a LangID: " + Thread.CurrentThread.CurrentUICulture.LCID.ToString(), "Test");
			mb.LanguageID = (uint)Thread.CurrentThread.CurrentUICulture.LCID;
			SetResult(mb.Show());
		}

		private void cmdAppModal_Click(object sender, System.EventArgs e) {
			MessageBoxIndirect mb = new MessageBoxIndirect(this, "App Modal", "Test");
			mb.Modality = MessageBoxIndirect.MessageBoxExModality.AppModal;
			SetResult(mb.Show());		
		}

		private void cmdSysModal_Click(object sender, System.EventArgs e) {
			MessageBoxIndirect mb = new MessageBoxIndirect(this, "System Modal", "Test");
			mb.Modality = MessageBoxIndirect.MessageBoxExModality.SystemModal;
			SetResult(mb.Show());		
		}

		private void cmdTaskModal_Click(object sender, System.EventArgs e) {
			MessageBoxIndirect mb = new MessageBoxIndirect("Task Modal", "Test");
			mb.Modality = MessageBoxIndirect.MessageBoxExModality.TaskModal;
			SetResult(mb.Show());		
		}

		private void ShowHelp(MessageBoxIndirect.HELPINFO helpInfo) {
			MessageBox.Show("Help Callback, context id = " + helpInfo.dwContextId.ToString());
		}

		private void cmdHelpButton_Click(object sender, System.EventArgs e) {
			MessageBoxIndirect mb = new MessageBoxIndirect("Help Button", "Test", MessageBoxButtons.YesNoCancel);
			mb.ShowHelp = true;
			mb.ContextHelpID = 555;
			mb.Callback = new MessageBoxIndirect.MsgBoxCallback(this.ShowHelp);
			SetResult(mb.Show());		
		}

		private void cmdCustomIcon_Click(object sender, System.EventArgs e) {
			// Win32 Resource ID of the custom icon we want to put in the message box.
			const int Smiley = 102;

			MessageBoxIndirect mb = new MessageBoxIndirect("Custom Icon", "Test");
			// You can explicitly specify the instance handle of the module to load the icon from using
			// a line like this:
			//		mb.Instance = Marshal.GetHINSTANCE( System.Reflection.Assembly.GetExecutingAssembly().GetModules()[0] );
			// If you don't specify anything, the MessageBoxIndirect wrapper (NOT the underlying API) defaults
			// to the currently executing assembly.
			
			mb.UserIcon = new IntPtr(Smiley);		// pass the icon ID as an IntPtr -- same ultimate result as MAKEINTRESOURCE macro in C++
			SetResult(mb.Show());
		}

		private void cmdHelpMsg_Click(object sender, System.EventArgs e) {
			MessageBoxIndirect mb = new MessageBoxIndirect(this, "Help Button", "Test", MessageBoxButtons.YesNoCancel);
			mb.ContextHelpID = 444;
			mb.ShowHelp = true;
			SetResult(mb.Show());		
		}

		[DllImport("kernel32.dll")]
		public static extern IntPtr LoadLibraryEx(string fileName, IntPtr hFile, long dwFlags);

		private void cmdCustomIconAuxDll_Click(object sender, System.EventArgs e) {
			if (hWin32Resources == IntPtr.Zero) {
				hWin32Resources = LoadLibraryEx("C:\\Windows\\System32\\shell32.dll" /*  Application.StartupPath + "\\Win32Resources.dll" */, IntPtr.Zero, 0);
				Debug.Assert(hWin32Resources != IntPtr.Zero);
			}

			// Win32 Resource ID of the icon we want to put in the message box.
			const int Smiley = 102;

			MessageBoxIndirect mb = new MessageBoxIndirect(this, "Custom Icon", "Test");

			// Load the icon from the resource DLL that we loaded.
			mb.Instance = hWin32Resources;
			// pass the icon ID as an IntPtr
			// has same ultimate result as MAKEINTRESOURCE macro in C++
			mb.UserIcon = new IntPtr(Smiley);		
			mb.SysSmallIcon = new IntPtr(Smiley);

			mb.Modality = MessageBoxIndirect.MessageBoxExModality.SystemModal;

			SetResult(mb.Show());
		}
	}
}
