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

namespace SeleniumClient
{
	public class Parser : Form
	{

		private static string result = null;
		private Boolean  browserReady = false;
		private static Regex regex;
		private static MatchCollection matches;
		WebBrowser browser = new WebBrowser();
		private DataGrid dataGrid;
		private DataSet dataSet;
		private const String columnName = "hostname";
		private String hub;
		private System.ComponentModel.IContainer components = null;
		private String environment;
		private Boolean status;
		public Boolean Status {
			get { return status; }
		}

		public string Hub {
			get { return hub; }
			set {
				hub = value;
			}
		}
		public string Environment {
			get { return environment; }
			set {
				environment = value;
				if (this.Visible) {
					this.SuspendLayout();
				}
				this.Text = String.Format("{0} status", environment);
				if (this.Visible) {
					this.ResumeLayout();
				}
			}
		}

		public Parser() {
			this.status = true;

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

		// based on: https://github.com/sergueik/powershell_selenium/blob/master/csharp/protractor-net/Extensions/Extensions.cs
		private static string FindMatch(string text, string matchPattern, string matchTag) {
			result = null;
			regex = new Regex(matchPattern, RegexOptions.IgnoreCase | RegexOptions.Compiled);
			matches = regex.Matches(text);
			foreach (Match match in matches) {
				if (match.Length != 0) {
					foreach (Capture capture in match.Groups[matchTag].Captures) {
						if (result == null) {
							result = capture.ToString();
						}
					}
				}
			}
			return result;
		}

		private void InitializeComponent() {
			this.Size = new Size(400, 350);
			this.Text = String.Format("{0} status", environment);
			this.SuspendLayout();
			dataGrid = new DataGrid();
			dataGrid.Location = new  Point(8, 8);
			dataGrid.Size = new Size(384, 254);
			// TODO: determine dynamically

			this.Controls.Add(dataGrid);
			var dataGridTableStyle = new DataGridTableStyle();
			dataGridTableStyle.MappingName = "Hosts";
			dataGridTableStyle.AlternatingBackColor = Color.LightGray;
			DataGridColumnStyle TextCol = new DataGridTextBoxColumn();
			TextCol.MappingName = "hostname";
			TextCol.HeaderText = "hostname";
			TextCol.Width = 300;
			dataGridTableStyle.GridColumnStyles.Add(TextCol);
			dataGrid.TableStyles.Add(dataGridTableStyle);
			var button = new System.Windows.Forms.Button();
			button.Text = "Refresh";
			button.Name = "refresh_button";
			button.Location = new System.Drawing.Point(8, 292);
			button.Click += (object sender, EventArgs e) => {
				dataSet.Tables["Hosts"].Rows.Clear();
				Start() ;
			};
			this.Controls.Add(button);
			this.ResumeLayout(false);

		}

		public void Start() {
			browser.ScriptErrorsSuppressed = true;
			// browser.DocumentCompleted += new WebBrowserDocumentCompletedEventHandler(docCompleted);
			browser.AllowNavigation = true;
			//  can  only run directly
			// browser.Navigate(String.Format("http://{0}:4444/grid/console/",hub));
			try {
				var url = String.Format(@"http://{0}:4444/grid/console/", hub);
				var request = WebRequest.Create(url);
				using (var response = request.GetResponse()) {
					using (var content = response.GetResponseStream()) {
						using (var reader = new StreamReader(content)) {
							var strContent = reader.ReadToEnd();
							if (!browserReady) {
							browser.Navigate("about:blank");
							while (browser.ReadyState != WebBrowserReadyState.Complete) {
								Application.DoEvents();
								System.Threading.Thread.Sleep(5);
							}
							browserReady = true;
							}
							processDocument(strContent);
						}
					}
				}
			} catch (WebException e) {
				Trace.Assert(e != null);
				// show message box
				String text = String.Format("The host {0} appears down", hub);
				String caption = String.Format("{0} status", environment);
				Mover.FindAndMoveMsgBox(100, 100, true, caption);
				switch (MessageBox.Show(text, caption,
					MessageBoxButtons.OK,
					MessageBoxIcon.Exclamation)) {

					case DialogResult.OK:
						this.Close();
						this.status = false;
						break;
					default:
						break;
				}
			}
		}

		void processDocument(String content ) {
			dynamic Doc = browser.Document.DomDocument;
			Doc.open();
			Doc.write(content);
			Doc.close();

			// var document_html = browser.Document.Body.InnerHtml;
			System.Windows.Forms.HtmlDocument doc = browser.Document;
			HtmlElement element = null;
			HtmlElement element2 = null;
			HtmlElementCollection elements = null;
			var nodes = new List<String>();
			var ids = new List<String>();
			int rowNum = 0;

			ids.Add("rightColumn"); // for older Selenium grid
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
						var hostname = FindMatch(text, @"^\s*id\s*:\s*http://(?<hostname>[A-Z0-9-._]+):\d+,.*$", "hostname");
						nodes.Add(hostname == null ? text : hostname);
					}
				}
			}
			nodes.Sort();
			int datarows = 0;
			foreach (String text in nodes) {
				datarows++;
				Console.Error.WriteLine(text);
				// database table column name
				if (dataSet.Tables["Hosts"].Rows.Count < datarows) {
					dataSet.Tables["Hosts"].Rows.Add(new Object[]{ rowNum, text });
				} else {
					dataSet.Tables["Hosts"].Rows[rowNum][columnName] = text;
				}
				rowNum++;
			}
		}
		
		private void MakeDataSet() {
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

			for (int i = 1; i < 5; i++) {
				newRow1 = dataTable.NewRow();
				newRow1["HostId"] = i;
				// Add the row to the Hosts table.
				dataTable.Rows.Add(newRow1);
			}
			dataTable.Rows[0]["hostname"] = "host1";
		}

	}
}
