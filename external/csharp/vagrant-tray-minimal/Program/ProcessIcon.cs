using System;
using System.Diagnostics;
using System.Windows.Forms;
using System.Data;
using System.Drawing;
using System.IO;
using System.Reflection;
using SeleniumClient.Properties;
using System.Net;
using System.Collections;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Text;
using Utils;

namespace SeleniumClient {
	public class ProcessIcon : IDisposable {
		NotifyIcon notifyIcon;
		public ProcessIcon() {
			notifyIcon = new NotifyIcon();
		}

		public void Display() {
			notifyIcon.Icon = Icon.FromHandle(Properties.Resources.selenium.GetHicon());
			notifyIcon.Text = "System Tray Selenium Grid Status Checker";
			notifyIcon.Visible = true;
			notifyIcon.ContextMenuStrip = new ContextMenus().Create();
		}

		public void Dispose() {
			notifyIcon.Dispose();
		}

		// TODO: the icon does not disappear instantly on exit, only after mouse hover
		// method protection level prevents from calling
		// notifyIcon.Dispose( disposing )

	}

	class ContextMenus {
		// show one dialog at a time
		bool isFormDisplayed = false;
		ContextMenuStrip menu;

		public ContextMenuStrip Create()
		{
			menu = new ContextMenuStrip();
			ToolStripMenuItem item;

			var iniFileNative =  new IniFileNative(AppDomain.CurrentDomain.BaseDirectory+ @"\config.ini");
			var environments = iniFileNative.ReadValue("Environments","values");
			if (environments != null) {
				foreach (String environment in environments.Split(new char[] {','})) {
					String hostname = iniFileNative.ReadValue(environment, "hub");
					item = new ToolStripMenuItem();
					item.Text = String.Format("{0} status", environment);
					var data =  new Dictionary<String, String>();
					data.Add("hub", hostname);
					data.Add("environment", environment);
					item.Tag = data;
					item.Click += new EventHandler(Process_Click);
					item.Image = Resources.search;
					menu.Items.Add(item);
				}

			}
			menu.Items.Add(new ToolStripSeparator());

			item = new ToolStripMenuItem();
			item.Text = "exit";
			item.Click += (object sender, EventArgs e) => Application.Exit();
			item.Image = Resources.exit;
			menu.Items.Add(item);

			return menu;
		}

		void Process_Click(object sender, EventArgs eventArgs) {
			var item = (ToolStripMenuItem)sender;
			var items = item.GetCurrentParent().Items;
			var data = (Dictionary<String, String>)item.Tag;
			String hub = data["hub"];
			String environment = data["environment"];
			if (!isFormDisplayed) {
				var parser = new Parser();
				parser.Hub = hub;
				parser.Environment = environment;
				parser.Start();
				if (parser.Status) {
					// https://stackoverflow.com/questions/13405714/is-versus-try-cast-with-null-check
					foreach (var item1 in items) {
						var item2 = item1 as ToolStripMenuItem;
						if (item2 == null) {
							// must be "separator"
							continue;
						}
						if (item.Equals(item2)) {
							item.BackColor = Color.LightGray;
						}
						item2.Enabled = false;
					}
					isFormDisplayed = true;
					parser.ShowDialog();
					// handle closing
					foreach (var item1 in items) {
						var item2 = item1 as ToolStripMenuItem;
						if (item2 == null) {
							// must be "separator"
							continue;
						}
						if (item.Equals(item2)) {
							item.BackColor = Color.White;
						}
						item2.Enabled = true;
					}
					isFormDisplayed = false;
				}
			}
		}

	}
 }
