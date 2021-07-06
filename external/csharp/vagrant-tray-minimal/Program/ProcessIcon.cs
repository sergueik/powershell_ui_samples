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
using Utils;

namespace SeleniumClient
{
	public class ProcessIcon : IDisposable
	{
		NotifyIcon notifyIcon;
		public ProcessIcon()
		{
			notifyIcon = new NotifyIcon();
		}

		public void Display()
		{
			
			// notifyIcon.MouseClick += new MouseEventHandler(notifyIcon_MouseClick);
			notifyIcon.Icon = Icon.FromHandle(Properties.Resources.selenium.GetHicon());
			notifyIcon.Text = "System Tray Selenium Grid Status Checker";
			notifyIcon.Visible = true;
			notifyIcon.ContextMenuStrip = new ContextMenus().Create();
		}

		public void Dispose() {
			notifyIcon.Dispose();
		}

		// TODO: the icon does not disappear instantly on exit, ony after mouse hover
		// method protection level prevents from calling
		// notifyIcon.Dispose( disposing )

		void notifyIcon_MouseClick(object sender, MouseEventArgs e)
		{
			if (e.Button == MouseButtons.Left) {
				Process.Start("explorer", null);
			}
		}
	}

	class ContextMenus
	{
		// show one dialog at a time
		bool isFormDisplayed = false;
	
		public ContextMenuStrip Create()
		{
			ContextMenuStrip menu = new ContextMenuStrip();
			ToolStripMenuItem item;
			
			var iniFileNative =  new IniFileNative(AppDomain.CurrentDomain.BaseDirectory+ @"\config.ini");
			var environments = iniFileNative.ReadValue("Environments","values");
			if (environments != null) { 
				foreach (String environment in environments.Split(new char[] {','})) {
					String hostname = iniFileNative.ReadValue(environment, "hub");
					item = new ToolStripMenuItem();
					item.Text = String.Format("{0} status", environment);
					item.Tag = hostname;
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

		void Process_Click(object sender, EventArgs e)
		{
			var item = (ToolStripMenuItem )sender ;
			String hub = (String) item.Tag;
			if (!isFormDisplayed) {
				isFormDisplayed = true;
				var parser =new Parser();
				parser.Hub = hub;
				parser.Start();
				parser.ShowDialog();
				isFormDisplayed = false;
			}
		}

	}

 
	public class Parser : Form {
		WebBrowser browser = new WebBrowser();
		private DataGrid dataGrid;
		private DataSet dataSet;
		private Boolean DEBUG = true;
		private String hub;
		private System.ComponentModel.IContainer components = null;

		public string Hub {
			get { return hub; }
			set { this.hub = value; 
			}
		}

		public Parser() {
			InitializeComponent();
			SetUp();
		}
		
		private void SetUp() {
			MakeDataSet();
			dataGrid.SetDataBinding(dataSet, "Hosts");
		}

		protected override void Dispose(bool disposing) {
			if (disposing && (components != null)) {
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		private void InitializeComponent()
		{
			this.Size = new Size(400, 200);
			this.Text = String.Format("Grid status");
			this.SuspendLayout();
			dataGrid = new DataGrid();
			dataGrid.Location = new  Point(8, 8);
			dataGrid.Size = new Size(384, 184);
			
			this.Controls.Add(dataGrid);
			var dataGridTableStyle = new DataGridTableStyle();
			dataGridTableStyle.MappingName = "Hosts";
			dataGridTableStyle.AlternatingBackColor = Color.LightGray;
			DataGridColumnStyle TextCol = new DataGridTextBoxColumn();
			TextCol.MappingName = "hostname";
			TextCol.HeaderText = "Customer Name";
			TextCol.Width = 300;
			dataGridTableStyle.GridColumnStyles.Add(TextCol);
			dataGrid.TableStyles.Add(dataGridTableStyle);
			this.ResumeLayout(false);

		}

	public void Start() {
			browser.ScriptErrorsSuppressed = true;
			// browser.DocumentCompleted += new WebBrowserDocumentCompletedEventHandler(docCompleted);
			browser.AllowNavigation = true;
			//  can  only run directly
			// browser.Navigate(String.Format("http://{0}:4444/grid/console/",hub));
			try {
				var url =  String.Format(@"http://{0}:4444/grid/console/",hub);
				var request = WebRequest.Create(url);
				using (var response = request.GetResponse()) {
					using (var content = response.GetResponseStream()) {
						using (var reader = new StreamReader(content)) {
							var strContent = reader.ReadToEnd();
				
							browser.Navigate("about:blank");
							while (browser.ReadyState != WebBrowserReadyState.Complete) {
								Application.DoEvents();
								System.Threading.Thread.Sleep(5);
							}
							dynamic Doc = browser.Document.DomDocument;
							Doc.open();
							Doc.write(strContent);
							Doc.close();
							processDocument();
						}
					}
				}
			} catch (WebException e) {
				Trace.Assert(e != null);

			}
				
		}

		void processDocument()
		{
			var document_html = browser.Document.Body.InnerHtml;
			HtmlDocument doc = browser.Document;
			HtmlElement element = null;
			HtmlElement element2 = null;
			HtmlElementCollection elements = null;
			var nodes = new List<String>();
			var ids = new List<String>();
			int rowNum = 0;

			ids.Add("rightColumn");
			ids.Add("leftColumn");
			ids.Add("right-column");
			ids.Add("left-column");
		
			foreach (String id in ids) {
				element = doc.GetElementById(id);
				if (element == null) { 
					continue;
				}
				var html = element.InnerHtml;

				elements = element.GetElementsByTagName("p");
				for (int cnt = 0; cnt != elements.Count; cnt++) {
					element2 = elements[cnt];
					
					if (element2.GetAttribute("classname") != null && element2.GetAttribute("classname").Contains("proxyid")) {
						String text = element2.InnerText;
						nodes.Add(text);
					}
				}
			}
			
			foreach (String text in nodes) {
				Console.Error.WriteLine(text);
				string columnName = "hostname";  // database table column name
						
				dataSet.Tables["Hosts"].Rows[rowNum][columnName] = text;
				rowNum++;
			}

			if (DEBUG) {
				var Dumper = new DataDumper();
				Dumper.Dump(nodes);
			}
			
		}
		/*
		void docCompleted(object sender, WebBrowserDocumentCompletedEventArgs e) {
			processDocument();
		}
		*/
		private void MakeDataSet()
		{
			dataSet = new DataSet("DataSet");
     
			var dataTable = new DataTable("Hosts");

			// Create two columns, and add them to the first table.
			var cHostId = new DataColumn("HostId", typeof(int));
			var chostname = new DataColumn("hostname");
			dataTable.Columns.Add(cHostId);
			dataTable.Columns.Add(chostname);

			// Add the tables to the DataSet.
			dataSet.Tables.Add(dataTable);

			DataRow newRow1;

			for (int i = 1; i < 10; i++) {
				newRow1 = dataTable.NewRow();
				newRow1["HostId"] = i;
				// Add the row to the Hosts table.
				dataTable.Rows.Add(newRow1);
			}
			dataTable.Rows[0]["hostname"] = "host1";
		}

	}
 }


