using System;
using System.Diagnostics;
using System.Windows.Forms;
using System.Data;
using System.Drawing;
using System.Resources;
using System.Reflection;
using SeleniumClient.Properties;
using System.Collections;
using System.Text.RegularExpressions;
using System.Collections.Generic;

namespace SeleniumClient {
	public class ProcessIcon : IDisposable {
		NotifyIcon notifyIcon;
		public ProcessIcon() {
			notifyIcon = new NotifyIcon();
		}

		public void Display() {
			
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

		void notifyIcon_MouseClick(object sender, MouseEventArgs e) {
			if (e.Button == MouseButtons.Left) {
				Process.Start("explorer", null);
			}
		}
	}

	class ContextMenus {
		// show one dialog at a time
		bool isFormDisplayed = false;
	
		public ContextMenuStrip Create() {
			ContextMenuStrip menu = new ContextMenuStrip();
			ToolStripMenuItem item;
			ToolStripSeparator sep;

			item = new ToolStripMenuItem();
			item.Text = "status";
			item.Click += new EventHandler(Process_Click);
			menu.Items.Add(item);

			item = new ToolStripMenuItem();
			item.Text = "about";
			item.Click += new EventHandler(About_Click);
			item.Image = Resources.about;
			menu.Items.Add(item);

			sep = new ToolStripSeparator();
			menu.Items.Add(sep);

			item = new ToolStripMenuItem();
			item.Text = "exit";
			item.Click += (object sender, EventArgs e) => Application.Exit(); 
			item.Image = Resources.exit;
			menu.Items.Add(item);

			return menu;
		}

		void Process_Click(object sender, EventArgs e) {
			if (!isFormDisplayed) {
				isFormDisplayed = true;
				new Parser().ShowDialog();
				isFormDisplayed = false;
			}
		}

		void About_Click(object sender, EventArgs e) {
			if (!isFormDisplayed) {
				isFormDisplayed = true;
				new AboutBox().ShowDialog();
				isFormDisplayed = false;
			}
		}
	}

 
	public class Parser : Form {
		WebBrowser request = new WebBrowser();
		private DataGrid myDataGrid;
		private DataSet myDataSet;
		private System.ComponentModel.IContainer components = null;

		public Parser() {
			InitializeComponent();
			SetUp();
			Start();
		}
		
		private void SetUp() {
			MakeDataSet();
			myDataGrid.SetDataBinding(myDataSet, "Customers");
		}

		protected override void Dispose(bool disposing) {
			if (disposing && (components != null)) {
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		private void InitializeComponent() {
			this.Size = new Size(400, 200);
			var resources = new System.ComponentModel.ComponentResourceManager(typeof(Parser));
			this.Text = String.Format("Grid status");
			this.SuspendLayout();
			this.myDataGrid = new DataGrid();
			myDataGrid.Location = new  Point(8, 8);
			myDataGrid.Size = new Size(384, 184);
			
			this.Controls.Add(myDataGrid);
			var ts1 = new DataGridTableStyle();
			ts1.MappingName = "Customers";
			ts1.AlternatingBackColor = Color.LightGray;
			DataGridColumnStyle TextCol = new DataGridTextBoxColumn();
			TextCol.MappingName = "custName";
			TextCol.HeaderText = "Customer Name";
			TextCol.Width = 300;
			ts1.GridColumnStyles.Add(TextCol);
			myDataGrid.TableStyles.Add(ts1);
			this.ResumeLayout(false);

		}

		public void Start() {
			request.DocumentCompleted += new WebBrowserDocumentCompletedEventHandler(docCompleted);
			request.Navigate("http://localhost:4444/grid/console/");
		}
 
		void docCompleted(object sender, WebBrowserDocumentCompletedEventArgs e) {
			var document_html= request.Document.Body.InnerHtml;
			HtmlDocument doc = request.Document;
			HtmlElement element = null;
			HtmlElement element2 = null;
			HtmlElementCollection elements = null;
			var nodes = new List<String>();
			var ids = new List<String>();
							int rowNum = 0;

			ids.Add("rightColumn");
			ids.Add("leftColumn");
		
			// TODO: System.Windows.Forms.WebBrowser does not find "#rightColumn" and only 
			// sees one $("#leftColumn p"), the innerHTML of $("#leftColumn") appears truncated
			foreach (String id in ids) {
				element = doc.GetElementById(id);
				var html = element.InnerHtml;

				elements = element.GetElementsByTagName("p");
				for (int cnt = 0; cnt != elements.Count; cnt++) {
					element2 = elements[cnt];
					if (element2.GetAttribute("classname").Contains("proxyid")) {
						String text = element2.InnerText;
						nodes.Add(text);
					}
				}
			}
			
			elements = doc.GetElementsByTagName("p");
			for (int cnt = 0; cnt != elements.Count; cnt++) {
				element = elements[cnt];
				if (element.GetAttribute("classname").Contains("proxyid")) {
					String text = element.InnerText;
					nodes.Add(text);
				}
			}
			foreach (String text in nodes) {
				Console.Error.WriteLine(text);
				string columnName = "CustName";  // database table column name
						
				myDataSet.Tables["Customers"].Rows[rowNum][columnName] = text;
				rowNum ++;;
			}
		}
		
		private void MakeDataSet()
		{
			myDataSet = new DataSet("myDataSet");
      
			DataTable tCust = new DataTable("Customers");

			// Create two columns, and add them to the first table.
			DataColumn cCustID = new DataColumn("CustID", typeof(int));
			DataColumn cCustName = new DataColumn("CustName");
			// DataColumn cCurrent = new DataColumn("Current", typeof(bool));
			tCust.Columns.Add(cCustID);
			tCust.Columns.Add(cCustName);
			// tCust.Columns.Add(cCurrent);

			// Add the tables to the DataSet.
			myDataSet.Tables.Add(tCust);

			DataRow newRow1;

			for (int i = 1; i < 4; i++) {
				newRow1 = tCust.NewRow();
				newRow1["custID"] = i;
				// Add the row to the Customers table.
				tCust.Rows.Add(newRow1);
			}
			tCust.Rows[0]["custName"] = "Customer1";
			tCust.Rows[1]["custName"] = "Customer2";
			tCust.Rows[2]["custName"] = "Customer3";
		}
	}
 
	class AboutBox: Form
	{

		public AboutBox()
		{
			InitializeComponent();
			// Virtual member call in constructor?
			this.labelProductName.Text = AssemblyProduct;
			this.labelVersion.Text = String.Format("Version {0}", AssemblyVersion);
			this.labelCopyright.Text = AssemblyCopyright;
			this.labelCompanyName.Text = AssemblyCompany;
			this.textBoxDescription.Text = AssemblyDescription;
		}

		private System.ComponentModel.IContainer components = null;

		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null)) {
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		private void InitializeComponent()
		{
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(AboutBox));
			this.Text = String.Format("About {0}", AssemblyTitle);
			this.tableLayoutPanel = new System.Windows.Forms.TableLayoutPanel();
			this.logoPictureBox = new System.Windows.Forms.PictureBox();
			this.labelProductName = new System.Windows.Forms.Label();
			this.labelVersion = new System.Windows.Forms.Label();
			this.labelCopyright = new System.Windows.Forms.Label();
			this.labelCompanyName = new System.Windows.Forms.Label();
			this.textBoxDescription = new System.Windows.Forms.TextBox();
			this.okButton = new System.Windows.Forms.Button();
			this.tableLayoutPanel.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.logoPictureBox)).BeginInit();
			this.SuspendLayout();
			// 
			// tableLayoutPanel
			// 
			this.tableLayoutPanel.ColumnCount = 2;
			this.tableLayoutPanel.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 33F));
			this.tableLayoutPanel.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 67F));
			this.tableLayoutPanel.Controls.Add(this.logoPictureBox, 0, 0);
			this.tableLayoutPanel.Controls.Add(this.labelProductName, 1, 0);
			this.tableLayoutPanel.Controls.Add(this.labelVersion, 1, 1);
			this.tableLayoutPanel.Controls.Add(this.labelCopyright, 1, 2);
			this.tableLayoutPanel.Controls.Add(this.labelCompanyName, 1, 3);
			this.tableLayoutPanel.Controls.Add(this.textBoxDescription, 1, 4);
			this.tableLayoutPanel.Controls.Add(this.okButton, 1, 5);
			this.tableLayoutPanel.Dock = System.Windows.Forms.DockStyle.Fill;
			this.tableLayoutPanel.Location = new System.Drawing.Point(9, 9);
			this.tableLayoutPanel.Name = "tableLayoutPanel";
			this.tableLayoutPanel.RowCount = 6;
			this.tableLayoutPanel.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 10F));
			this.tableLayoutPanel.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 10F));
			this.tableLayoutPanel.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 10F));
			this.tableLayoutPanel.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 10F));
			this.tableLayoutPanel.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
			this.tableLayoutPanel.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 10F));
			this.tableLayoutPanel.Size = new System.Drawing.Size(417, 265);
			this.tableLayoutPanel.TabIndex = 0;
			// 
			// logoPictureBox
			// 
			this.logoPictureBox.Dock = System.Windows.Forms.DockStyle.Fill;
			// this.logoPictureBox.Image = ((System.Drawing.Image)(resources.GetObject("logoPictureBox.Image")));
			this.logoPictureBox.Location = new System.Drawing.Point(3, 3);
			this.logoPictureBox.Name = "logoPictureBox";
			this.tableLayoutPanel.SetRowSpan(this.logoPictureBox, 6);
			this.logoPictureBox.Size = new System.Drawing.Size(131, 259);
			this.logoPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
			this.logoPictureBox.TabIndex = 12;
			this.logoPictureBox.TabStop = false;
			// 
			// labelProductName
			// 
			this.labelProductName.Dock = System.Windows.Forms.DockStyle.Fill;
			this.labelProductName.Location = new System.Drawing.Point(143, 0);
			this.labelProductName.Margin = new System.Windows.Forms.Padding(6, 0, 3, 0);
			this.labelProductName.MaximumSize = new System.Drawing.Size(0, 17);
			this.labelProductName.Name = "labelProductName";
			this.labelProductName.Size = new System.Drawing.Size(271, 17);
			this.labelProductName.TabIndex = 19;
			this.labelProductName.Text = "Product Name";
			this.labelProductName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			// 
			// labelVersion
			// 
			this.labelVersion.Dock = System.Windows.Forms.DockStyle.Fill;
			this.labelVersion.Location = new System.Drawing.Point(143, 26);
			this.labelVersion.Margin = new System.Windows.Forms.Padding(6, 0, 3, 0);
			this.labelVersion.MaximumSize = new System.Drawing.Size(0, 17);
			this.labelVersion.Name = "labelVersion";
			this.labelVersion.Size = new System.Drawing.Size(271, 17);
			this.labelVersion.TabIndex = 0;
			this.labelVersion.Text = "Version";
			this.labelVersion.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			// 
			// labelCopyright
			// 
			this.labelCopyright.Dock = System.Windows.Forms.DockStyle.Fill;
			this.labelCopyright.Location = new System.Drawing.Point(143, 52);
			this.labelCopyright.Margin = new System.Windows.Forms.Padding(6, 0, 3, 0);
			this.labelCopyright.MaximumSize = new System.Drawing.Size(0, 17);
			this.labelCopyright.Name = "labelCopyright";
			this.labelCopyright.Size = new System.Drawing.Size(271, 17);
			this.labelCopyright.TabIndex = 21;
			this.labelCopyright.Text = "Copyright";
			this.labelCopyright.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			// 
			// labelCompanyName
			// 
			this.labelCompanyName.Dock = System.Windows.Forms.DockStyle.Fill;
			this.labelCompanyName.Location = new System.Drawing.Point(143, 78);
			this.labelCompanyName.Margin = new System.Windows.Forms.Padding(6, 0, 3, 0);
			this.labelCompanyName.MaximumSize = new System.Drawing.Size(0, 17);
			this.labelCompanyName.Name = "labelCompanyName";
			this.labelCompanyName.Size = new System.Drawing.Size(271, 17);
			this.labelCompanyName.TabIndex = 22;
			this.labelCompanyName.Text = "Company Name";
			this.labelCompanyName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			// 
			// textBoxDescription
			// 
			this.textBoxDescription.Dock = System.Windows.Forms.DockStyle.Fill;
			this.textBoxDescription.Location = new System.Drawing.Point(143, 107);
			this.textBoxDescription.Margin = new System.Windows.Forms.Padding(6, 3, 3, 3);
			this.textBoxDescription.Multiline = true;
			this.textBoxDescription.Name = "textBoxDescription";
			this.textBoxDescription.ReadOnly = true;
			this.textBoxDescription.ScrollBars = System.Windows.Forms.ScrollBars.Both;
			this.textBoxDescription.Size = new System.Drawing.Size(271, 126);
			this.textBoxDescription.TabIndex = 23;
			this.textBoxDescription.TabStop = false;
			this.textBoxDescription.Text = "Description";
			// 
			// okButton
			// 
			this.okButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
			this.okButton.DialogResult = System.Windows.Forms.DialogResult.Cancel;
			this.okButton.Location = new System.Drawing.Point(339, 239);
			this.okButton.Name = "okButton";
			this.okButton.Size = new System.Drawing.Size(75, 23);
			this.okButton.TabIndex = 24;
			this.okButton.Text = "&OK";
			// 
			// AboutBox
			// 
			this.AcceptButton = this.okButton;
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(435, 283);
			this.Controls.Add(this.tableLayoutPanel);
			this.Font = new System.Drawing.Font("Segoe UI", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			// this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "AboutBox";
			this.Padding = new System.Windows.Forms.Padding(9);
			this.ShowIcon = false;
			this.ShowInTaskbar = false;
			this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
			this.Text = "About SystemTrayApp";
			this.tableLayoutPanel.ResumeLayout(false);
			this.tableLayoutPanel.PerformLayout();
			((System.ComponentModel.ISupportInitialize)(this.logoPictureBox)).EndInit();
			this.ResumeLayout(false);

		}


		private System.Windows.Forms.TableLayoutPanel tableLayoutPanel;
		private System.Windows.Forms.PictureBox logoPictureBox;
		private System.Windows.Forms.Label labelProductName;
		private System.Windows.Forms.Label labelVersion;
		private System.Windows.Forms.Label labelCopyright;
		private System.Windows.Forms.Label labelCompanyName;
		private System.Windows.Forms.TextBox textBoxDescription;
		private System.Windows.Forms.Button okButton;

		public string AssemblyTitle {
			get {
				object[] attributes = Assembly.GetExecutingAssembly().GetCustomAttributes(typeof(AssemblyTitleAttribute), false);
				if (attributes.Length > 0) {
					AssemblyTitleAttribute titleAttribute = (AssemblyTitleAttribute)attributes[0];
					if (titleAttribute.Title != "") {
						return titleAttribute.Title;
					}
				}
				return System.IO.Path.GetFileNameWithoutExtension(Assembly.GetExecutingAssembly().CodeBase);
			}
		}

		public string AssemblyVersion {
			get {
				return Assembly.GetExecutingAssembly().GetName().Version.ToString();
			}
		}

		public string AssemblyDescription {
			get {
				object[] attributes = Assembly.GetExecutingAssembly().GetCustomAttributes(typeof(AssemblyDescriptionAttribute), false);
				if (attributes.Length == 0) {
					return "";
				}
				return ((AssemblyDescriptionAttribute)attributes[0]).Description;
			}
		}

		public string AssemblyProduct {
			get {
				object[] attributes = Assembly.GetExecutingAssembly().GetCustomAttributes(typeof(AssemblyProductAttribute), false);
				if (attributes.Length == 0) {
					return "";
				}
				return ((AssemblyProductAttribute)attributes[0]).Product;
			}
		}

		public string AssemblyCopyright {
			get {
				object[] attributes = Assembly.GetExecutingAssembly().GetCustomAttributes(typeof(AssemblyCopyrightAttribute), false);
				if (attributes.Length == 0) {
					return "";
				}
				return ((AssemblyCopyrightAttribute)attributes[0]).Copyright;
			}
		}

		public string AssemblyCompany {
			get {
				object[] attributes = Assembly.GetExecutingAssembly().GetCustomAttributes(typeof(AssemblyCompanyAttribute), false);
				if (attributes.Length == 0) {
					return "";
				}
				return ((AssemblyCompanyAttribute)attributes[0]).Company;
			}
		}
	}
}