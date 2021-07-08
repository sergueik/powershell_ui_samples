using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Globalization;
using System.Runtime.InteropServices;
using System.Threading;

using MessageBoxExLib;

namespace MessageBoxExDemo {
	public class MessageBoxExDemoForm : Form
	{

		private Button btnShowCustom;
		private GroupBox grpBoxIcon;
		private RadioButton radioButton4;
		private RadioButton radioButton3;
		private RadioButton radioButton2;
		private RadioButton radioButton1;
		private ListView listViewButtons;
		private ColumnHeader columnHeader1;
		private TextBox txtMessage;
		private Label label2;
		private TextBox txtCaption;
		private Label label1;
		private RadioButton radioButton5;
		private TextBox txtSaveResponse;
		private CheckBox chbAllowSaveResponse;
		private TextBox txtResult;
		private Label label3;
		private ListView listViewMessageBoxes;
		private ColumnHeader columnHeader2;
		private Button btnAddMessageBox;
		private TextBox txtName;
		private Label label4;
		private GroupBox groupBox1;
		private TextBox txtButtonText;
		private Label ButtonText;
		private TextBox txtButtonVal;
		private Label label5;
		private CheckBox chbIsCancel;
		private Label label6;
		private Button btnAddButton;
		private TextBox txtButtonHelp;
		private CheckBox chbUseSavedResponse;
		private CheckBox chbPlayAlert;
		private ToolTip toolTip1;
		private Label label7;
		private Label label8;
		private TextBox txtTimeout;
		private Label label9;
		private ComboBox cmbTimeoutResult;
		private Button button1;
		private IContainer components;
		private CheckBox chbAllowReposition;
        
		public MessageBoxExDemoForm() {
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
			this.components = new System.ComponentModel.Container();
			ListViewItem listViewItem1 = new ListViewItem("Ok");
			ListViewItem listViewItem2 = new ListViewItem("Cancel");
			ListViewItem listViewItem3 = new ListViewItem("Yes");
			ListViewItem listViewItem4 = new ListViewItem("No");
			ListViewItem listViewItem5 = new ListViewItem("Abort");
			ListViewItem listViewItem6 = new ListViewItem("Retry");
			ListViewItem listViewItem7 = new ListViewItem("Ignore");
			this.btnShowCustom = new Button();
			this.grpBoxIcon = new GroupBox();
			this.radioButton5 = new RadioButton();
			this.radioButton4 = new RadioButton();
			this.radioButton3 = new RadioButton();
			this.radioButton2 = new RadioButton();
			this.radioButton1 = new RadioButton();
			this.listViewButtons = new ListView();
			this.columnHeader1 = new ColumnHeader();
			this.txtMessage = new TextBox();
			this.label2 = new Label();
			this.txtCaption = new TextBox();
			this.label1 = new Label();
			this.chbAllowSaveResponse = new CheckBox();
			this.txtSaveResponse = new TextBox();
			this.txtResult = new TextBox();
			this.label3 = new Label();
			this.listViewMessageBoxes = new ListView();
			this.columnHeader2 = new ColumnHeader();
			this.btnAddMessageBox = new Button();
			this.txtName = new TextBox();
			this.label4 = new Label();
			this.groupBox1 = new GroupBox();
			this.chbAllowReposition = new CheckBox();
			this.txtButtonHelp = new TextBox();
			this.label6 = new Label();
			this.chbIsCancel = new CheckBox();
			this.txtButtonVal = new TextBox();
			this.label5 = new Label();
			this.txtButtonText = new TextBox();
			this.ButtonText = new Label();
			this.btnAddButton = new Button();
			this.chbUseSavedResponse = new CheckBox();
			this.chbPlayAlert = new CheckBox();
			this.toolTip1 = new ToolTip(this.components);
			this.txtTimeout = new TextBox();
			this.label7 = new Label();
			this.label8 = new Label();
			this.cmbTimeoutResult = new ComboBox();
			this.label9 = new Label();
			this.button1 = new Button();
			this.grpBoxIcon.SuspendLayout();
			this.groupBox1.SuspendLayout();
			this.SuspendLayout();
			// 
			// btnShowCustom
			// 
			this.btnShowCustom.Location = new System.Drawing.Point(1053, 398);
			this.btnShowCustom.Name = "btnShowCustom";
			this.btnShowCustom.Size = new System.Drawing.Size(224, 28);
			this.btnShowCustom.TabIndex = 3;
			this.btnShowCustom.Text = "Show Custom MessageBox";
			this.toolTip1.SetToolTip(this.btnShowCustom, "Show the currently selected message box from the list");
			this.btnShowCustom.Click += new System.EventHandler(this.btnShowCustom_Click);
			// 
			// grpBoxIcon
			// 
			this.grpBoxIcon.Controls.Add(this.radioButton5);
			this.grpBoxIcon.Controls.Add(this.radioButton4);
			this.grpBoxIcon.Controls.Add(this.radioButton3);
			this.grpBoxIcon.Controls.Add(this.radioButton2);
			this.grpBoxIcon.Controls.Add(this.radioButton1);
			this.grpBoxIcon.Location = new System.Drawing.Point(627, 262);
			this.grpBoxIcon.Name = "grpBoxIcon";
			this.grpBoxIcon.Size = new System.Drawing.Size(191, 224);
			this.grpBoxIcon.TabIndex = 15;
			this.grpBoxIcon.TabStop = false;
			this.grpBoxIcon.Text = "Icon";
			// 
			// radioButton5
			// 
			this.radioButton5.Location = new System.Drawing.Point(22, 185);
			this.radioButton5.Name = "radioButton5";
			this.radioButton5.Size = new System.Drawing.Size(146, 29);
			this.radioButton5.TabIndex = 4;
			this.radioButton5.Text = "None";
			// 
			// radioButton4
			// 
			this.radioButton4.Location = new System.Drawing.Point(22, 146);
			this.radioButton4.Name = "radioButton4";
			this.radioButton4.Size = new System.Drawing.Size(146, 29);
			this.radioButton4.TabIndex = 2;
			this.radioButton4.Text = "Question";
			// 
			// radioButton3
			// 
			this.radioButton3.Location = new System.Drawing.Point(22, 68);
			this.radioButton3.Name = "radioButton3";
			this.radioButton3.Size = new System.Drawing.Size(146, 29);
			this.radioButton3.TabIndex = 1;
			this.radioButton3.Text = "Exclamation";
			// 
			// radioButton2
			// 
			this.radioButton2.Location = new System.Drawing.Point(22, 107);
			this.radioButton2.Name = "radioButton2";
			this.radioButton2.Size = new System.Drawing.Size(146, 29);
			this.radioButton2.TabIndex = 3;
			this.radioButton2.Text = "Hand";
			// 
			// radioButton1
			// 
			this.radioButton1.Checked = true;
			this.radioButton1.Location = new System.Drawing.Point(22, 29);
			this.radioButton1.Name = "radioButton1";
			this.radioButton1.Size = new System.Drawing.Size(146, 29);
			this.radioButton1.TabIndex = 0;
			this.radioButton1.TabStop = true;
			this.radioButton1.Text = "Asterisk";
			// 
			// listViewButtons
			// 
			this.listViewButtons.CheckBoxes = true;
			this.listViewButtons.Columns.AddRange(new ColumnHeader[] {
				this.columnHeader1
			});
			listViewItem1.StateImageIndex = 0;
			listViewItem2.StateImageIndex = 0;
			listViewItem3.StateImageIndex = 0;
			listViewItem4.StateImageIndex = 0;
			listViewItem5.StateImageIndex = 0;
			listViewItem6.StateImageIndex = 0;
			listViewItem7.StateImageIndex = 0;
			this.listViewButtons.Items.AddRange(new ListViewItem[] {
				listViewItem1,
				listViewItem2,
				listViewItem3,
				listViewItem4,
				listViewItem5,
				listViewItem6,
				listViewItem7
			});
			this.listViewButtons.Location = new System.Drawing.Point(414, 262);
			this.listViewButtons.Name = "listViewButtons";
			this.listViewButtons.Size = new System.Drawing.Size(191, 224);
			this.listViewButtons.TabIndex = 14;
			this.listViewButtons.UseCompatibleStateImageBehavior = false;
			this.listViewButtons.View = View.Details;
			// 
			// columnHeader1
			// 
			this.columnHeader1.Text = "Buttons";
			this.columnHeader1.Width = 130;
			// 
			// txtMessage
			// 
			this.txtMessage.Location = new System.Drawing.Point(101, 136);
			this.txtMessage.Multiline = true;
			this.txtMessage.Name = "txtMessage";
			this.txtMessage.Size = new System.Drawing.Size(392, 97);
			this.txtMessage.TabIndex = 5;
			this.txtMessage.Text = "<Message>";
			// 
			// label2
			// 
			this.label2.AutoSize = true;
			this.label2.Location = new System.Drawing.Point(22, 136);
			this.label2.Name = "label2";
			this.label2.Size = new System.Drawing.Size(59, 17);
			this.label2.TabIndex = 4;
			this.label2.Text = "Message";
			// 
			// txtCaption
			// 
			this.txtCaption.Location = new System.Drawing.Point(101, 87);
			this.txtCaption.Name = "txtCaption";
			this.txtCaption.Size = new System.Drawing.Size(392, 24);
			this.txtCaption.TabIndex = 3;
			this.txtCaption.Text = "<Caption>";
			// 
			// label1
			// 
			this.label1.AutoSize = true;
			this.label1.Location = new System.Drawing.Point(22, 87);
			this.label1.Name = "label1";
			this.label1.Size = new System.Drawing.Size(55, 17);
			this.label1.TabIndex = 2;
			this.label1.Text = "Caption";
			// 
			// chbAllowSaveResponse
			// 
			this.chbAllowSaveResponse.Location = new System.Drawing.Point(112, 495);
			this.chbAllowSaveResponse.Name = "chbAllowSaveResponse";
			this.chbAllowSaveResponse.Size = new System.Drawing.Size(202, 30);
			this.chbAllowSaveResponse.TabIndex = 16;
			this.chbAllowSaveResponse.Text = "Allow Save Response";
			// 
			// txtSaveResponse
			// 
			this.txtSaveResponse.Location = new System.Drawing.Point(115, 525);
			this.txtSaveResponse.Multiline = true;
			this.txtSaveResponse.Name = "txtSaveResponse";
			this.txtSaveResponse.Size = new System.Drawing.Size(381, 97);
			this.txtSaveResponse.TabIndex = 17;
			this.txtSaveResponse.Text = "<Save Response Text>";
			// 
			// txtResult
			// 
			this.txtResult.Location = new System.Drawing.Point(1053, 622);
			this.txtResult.Name = "txtResult";
			this.txtResult.Size = new System.Drawing.Size(224, 24);
			this.txtResult.TabIndex = 7;
			this.txtResult.Text = "<Result>";
			// 
			// label3
			// 
			this.label3.AutoSize = true;
			this.label3.Location = new System.Drawing.Point(997, 622);
			this.label3.Name = "label3";
			this.label3.Size = new System.Drawing.Size(45, 17);
			this.label3.TabIndex = 6;
			this.label3.Text = "Result";
			this.label3.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			// 
			// listViewMessageBoxes
			// 
			this.listViewMessageBoxes.Activation = ItemActivation.TwoClick;
			this.listViewMessageBoxes.Columns.AddRange(new ColumnHeader[] {
				this.columnHeader2
			});
			this.listViewMessageBoxes.Location = new System.Drawing.Point(1053, 117);
			this.listViewMessageBoxes.MultiSelect = false;
			this.listViewMessageBoxes.Name = "listViewMessageBoxes";
			this.listViewMessageBoxes.Size = new System.Drawing.Size(269, 272);
			this.listViewMessageBoxes.TabIndex = 2;
			this.listViewMessageBoxes.UseCompatibleStateImageBehavior = false;
			this.listViewMessageBoxes.View = View.Details;
			this.listViewMessageBoxes.ItemActivate += new System.EventHandler(this.listViewMessageBoxes_ItemActivate);
			// 
			// columnHeader2
			// 
			this.columnHeader2.Text = "MessageBoxes";
			this.columnHeader2.Width = 183;
			// 
			// btnAddMessageBox
			// 
			this.btnAddMessageBox.Location = new System.Drawing.Point(851, 233);
			this.btnAddMessageBox.Name = "btnAddMessageBox";
			this.btnAddMessageBox.Size = new System.Drawing.Size(179, 28);
			this.btnAddMessageBox.TabIndex = 1;
			this.btnAddMessageBox.Text = "Add MessageBox >>";
			this.toolTip1.SetToolTip(this.btnAddMessageBox, "Create a message box with the specified information and add it to the list");
			this.btnAddMessageBox.Click += new System.EventHandler(this.btnAddMessageBox_Click);
			// 
			// txtName
			// 
			this.txtName.Location = new System.Drawing.Point(101, 39);
			this.txtName.Name = "txtName";
			this.txtName.Size = new System.Drawing.Size(392, 24);
			this.txtName.TabIndex = 1;
			this.txtName.Text = "<Name>";
			// 
			// label4
			// 
			this.label4.AutoSize = true;
			this.label4.Location = new System.Drawing.Point(34, 39);
			this.label4.Name = "label4";
			this.label4.Size = new System.Drawing.Size(43, 17);
			this.label4.TabIndex = 0;
			this.label4.Text = "Name";
			// 
			// groupBox1
			// 
			this.groupBox1.Controls.Add(this.chbAllowReposition);
			this.groupBox1.Controls.Add(this.txtButtonHelp);
			this.groupBox1.Controls.Add(this.label6);
			this.groupBox1.Controls.Add(this.chbIsCancel);
			this.groupBox1.Controls.Add(this.txtButtonVal);
			this.groupBox1.Controls.Add(this.label5);
			this.groupBox1.Controls.Add(this.txtButtonText);
			this.groupBox1.Controls.Add(this.ButtonText);
			this.groupBox1.Controls.Add(this.grpBoxIcon);
			this.groupBox1.Controls.Add(this.listViewButtons);
			this.groupBox1.Controls.Add(this.txtMessage);
			this.groupBox1.Controls.Add(this.label2);
			this.groupBox1.Controls.Add(this.txtCaption);
			this.groupBox1.Controls.Add(this.label1);
			this.groupBox1.Controls.Add(this.chbAllowSaveResponse);
			this.groupBox1.Controls.Add(this.txtSaveResponse);
			this.groupBox1.Controls.Add(this.btnAddButton);
			this.groupBox1.Controls.Add(this.txtName);
			this.groupBox1.Controls.Add(this.label4);
			this.groupBox1.Location = new System.Drawing.Point(11, 10);
			this.groupBox1.Name = "groupBox1";
			this.groupBox1.Size = new System.Drawing.Size(829, 641);
			this.groupBox1.TabIndex = 0;
			this.groupBox1.TabStop = false;
			this.groupBox1.Text = "MessageBox";
			// 
			// chbAllowReposition
			// 
			this.chbAllowReposition.Location = new System.Drawing.Point(112, 447);
			this.chbAllowReposition.Name = "chbAllowReposition";
			this.chbAllowReposition.Size = new System.Drawing.Size(202, 30);
			this.chbAllowReposition.TabIndex = 18;
			this.chbAllowReposition.Text = "Allow Reposition";
			this.chbAllowReposition.CheckedChanged += new System.EventHandler(this.CheckBox1CheckedChanged);
			// 
			// txtButtonHelp
			// 
			this.txtButtonHelp.Location = new System.Drawing.Point(123, 340);
			this.txtButtonHelp.Name = "txtButtonHelp";
			this.txtButtonHelp.Size = new System.Drawing.Size(135, 24);
			this.txtButtonHelp.TabIndex = 11;
			this.txtButtonHelp.Text = "<Help Text>";
			// 
			// label6
			// 
			this.label6.AutoSize = true;
			this.label6.Location = new System.Drawing.Point(22, 340);
			this.label6.Name = "label6";
			this.label6.Size = new System.Drawing.Size(66, 17);
			this.label6.TabIndex = 10;
			this.label6.Text = "Help Text";
			// 
			// chbIsCancel
			// 
			this.chbIsCancel.Location = new System.Drawing.Point(123, 379);
			this.chbIsCancel.Name = "chbIsCancel";
			this.chbIsCancel.Size = new System.Drawing.Size(101, 29);
			this.chbIsCancel.TabIndex = 12;
			this.chbIsCancel.Text = "Is Cancel";
			// 
			// txtButtonVal
			// 
			this.txtButtonVal.Location = new System.Drawing.Point(123, 301);
			this.txtButtonVal.Name = "txtButtonVal";
			this.txtButtonVal.Size = new System.Drawing.Size(135, 24);
			this.txtButtonVal.TabIndex = 9;
			this.txtButtonVal.Text = "<Button Value>";
			// 
			// label5
			// 
			this.label5.AutoSize = true;
			this.label5.Location = new System.Drawing.Point(22, 301);
			this.label5.Name = "label5";
			this.label5.Size = new System.Drawing.Size(86, 17);
			this.label5.TabIndex = 8;
			this.label5.Text = "Button Value";
			// 
			// txtButtonText
			// 
			this.txtButtonText.Location = new System.Drawing.Point(123, 262);
			this.txtButtonText.Name = "txtButtonText";
			this.txtButtonText.Size = new System.Drawing.Size(135, 24);
			this.txtButtonText.TabIndex = 7;
			this.txtButtonText.Text = "<Button Text>";
			// 
			// ButtonText
			// 
			this.ButtonText.AutoSize = true;
			this.ButtonText.Location = new System.Drawing.Point(22, 262);
			this.ButtonText.Name = "ButtonText";
			this.ButtonText.Size = new System.Drawing.Size(78, 17);
			this.ButtonText.TabIndex = 6;
			this.ButtonText.Text = "ButtonText";
			// 
			// btnAddButton
			// 
			this.btnAddButton.Location = new System.Drawing.Point(269, 262);
			this.btnAddButton.Name = "btnAddButton";
			this.btnAddButton.Size = new System.Drawing.Size(123, 28);
			this.btnAddButton.TabIndex = 13;
			this.btnAddButton.Text = "Add Button >>";
			this.toolTip1.SetToolTip(this.btnAddButton, "Create a button using the specified information and add it to the list");
			this.btnAddButton.Click += new System.EventHandler(this.btnAddButton_Click);
			// 
			// chbUseSavedResponse
			// 
			this.chbUseSavedResponse.Checked = true;
			this.chbUseSavedResponse.CheckState = CheckState.Checked;
			this.chbUseSavedResponse.Location = new System.Drawing.Point(1053, 427);
			this.chbUseSavedResponse.Name = "chbUseSavedResponse";
			this.chbUseSavedResponse.Size = new System.Drawing.Size(224, 30);
			this.chbUseSavedResponse.TabIndex = 4;
			this.chbUseSavedResponse.Text = "Use Saved Response";
			// 
			// chbPlayAlert
			// 
			this.chbPlayAlert.Checked = true;
			this.chbPlayAlert.CheckState = CheckState.Checked;
			this.chbPlayAlert.Location = new System.Drawing.Point(1053, 466);
			this.chbPlayAlert.Name = "chbPlayAlert";
			this.chbPlayAlert.Size = new System.Drawing.Size(224, 29);
			this.chbPlayAlert.TabIndex = 5;
			this.chbPlayAlert.Text = "Play Alert Sound";
			// 
			// txtTimeout
			// 
			this.txtTimeout.Location = new System.Drawing.Point(1053, 505);
			this.txtTimeout.Name = "txtTimeout";
			this.txtTimeout.Size = new System.Drawing.Size(224, 24);
			this.txtTimeout.TabIndex = 9;
			this.txtTimeout.Text = "0";
			// 
			// label7
			// 
			this.label7.AutoSize = true;
			this.label7.Location = new System.Drawing.Point(986, 505);
			this.label7.Name = "label7";
			this.label7.Size = new System.Drawing.Size(58, 17);
			this.label7.TabIndex = 8;
			this.label7.Text = "Timeout";
			// 
			// label8
			// 
			this.label8.AutoSize = true;
			this.label8.Location = new System.Drawing.Point(1277, 505);
			this.label8.Name = "label8";
			this.label8.Size = new System.Drawing.Size(26, 17);
			this.label8.TabIndex = 10;
			this.label8.Text = "ms";
			// 
			// cmbTimeoutResult
			// 
			this.cmbTimeoutResult.DropDownStyle = ComboBoxStyle.DropDownList;
			this.cmbTimeoutResult.Items.AddRange(new object[] {
				"Default",
				"Cancel",
				"Timeout"
			});
			this.cmbTimeoutResult.Location = new System.Drawing.Point(1053, 544);
			this.cmbTimeoutResult.Name = "cmbTimeoutResult";
			this.cmbTimeoutResult.Size = new System.Drawing.Size(224, 25);
			this.cmbTimeoutResult.TabIndex = 11;
			// 
			// label9
			// 
			this.label9.AutoSize = true;
			this.label9.Location = new System.Drawing.Point(938, 544);
			this.label9.Name = "label9";
			this.label9.Size = new System.Drawing.Size(99, 17);
			this.label9.TabIndex = 12;
			this.label9.Text = "Timeout Result";
			// 
			// button1
			// 
			this.button1.Location = new System.Drawing.Point(1221, 10);
			this.button1.Name = "button1";
			this.button1.Size = new System.Drawing.Size(105, 28);
			this.button1.TabIndex = 13;
			this.button1.Text = "Run Tests";
			this.button1.Visible = false;
			this.button1.Click += new System.EventHandler(this.button1_Click);
			// 
			// MessageBoxExDemoForm
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(7, 17);
			this.ClientSize = new System.Drawing.Size(960, 550);
			this.Controls.Add(this.button1);
			this.Controls.Add(this.label9);
			this.Controls.Add(this.label8);
			this.Controls.Add(this.txtTimeout);
			this.Controls.Add(this.label7);
			this.Controls.Add(this.chbPlayAlert);
			this.Controls.Add(this.txtResult);
			this.Controls.Add(this.label3);
			this.Controls.Add(this.chbUseSavedResponse);
			this.Controls.Add(this.cmbTimeoutResult);
			this.Controls.Add(this.groupBox1);
			this.Controls.Add(this.btnAddMessageBox);
			this.Controls.Add(this.listViewMessageBoxes);
			this.Controls.Add(this.btnShowCustom);
			this.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.Name = "MessageBoxExDemoForm";
			this.StartPosition = FormStartPosition.CenterScreen;
			this.Text = "MessageBoxEx Demo";
			this.Load += new System.EventHandler(this.MessageBoxExDemoForm_Load);
			this.grpBoxIcon.ResumeLayout(false);
			this.groupBox1.ResumeLayout(false);
			this.groupBox1.PerformLayout();
			this.ResumeLayout(false);
			this.PerformLayout();

		}

		[STAThread]
		static void Main()  {
            //Thread.CurrentThread.CurrentUICulture = CultureInfo.CreateSpecificCulture("fr");
			Application.Run(new MessageBoxExDemoForm());
		}

		private void btnShowCustom_Click(object sender, System.EventArgs e) {
			if(listViewMessageBoxes.SelectedItems.Count == 0) {
				MessageBox.Show(this,"Select a message box to show","Select message box",MessageBoxButtons.OK,MessageBoxIcon.Information);
				return;
			}

			MessageBoxEx msgBox = listViewMessageBoxes.SelectedItems[0].Tag as MessageBoxEx;
			if(msgBox == null)
				return;

			msgBox.UseSavedResponse = chbUseSavedResponse.Checked;
			msgBox.PlayAlsertSound = chbPlayAlert.Checked;
            msgBox.Timeout = Convert.ToInt32(txtTimeout.Text);
            msgBox.TimeoutResult = (TimeoutResult)Enum.Parse(typeof(TimeoutResult),cmbTimeoutResult.SelectedItem.ToString());

            if (chbAllowReposition.Checked) {
              FindAndMoveMsgBox(100, 100, true, msgBox.Caption);
            }
            txtResult.Text = msgBox.Show(this);
		}

		[DllImport("user32.dll")]
		static extern IntPtr FindWindow(IntPtr classname, string title);

		[DllImport("user32.dll")]
		static extern void MoveWindow(IntPtr hwnd, int X, int Y, 
			int nWidth, int nHeight, bool rePaint);

		[DllImport("user32.dll")]
		static extern bool GetWindowRect(IntPtr hwnd, out Rectangle rect);

		void FindAndMoveMsgBox(int x, int y, bool repaint, string title) {
			var thread = new Thread(() => {
				IntPtr hwnd = IntPtr.Zero;
				// wait to discover MessageBox window handle through window title
				while ((hwnd = FindWindow(IntPtr.Zero, title)) == IntPtr.Zero)
					;
				Rectangle rectangle = new Rectangle();
				GetWindowRect(hwnd, out rectangle);
				// https://www.pinvoke.net/default.aspx/user32.movewindow
				// interesting how width and height are calculated
				// not using rectangle.Right - rectangle.Left, rectangle.Bottom - rectangle.Top
				MoveWindow(hwnd, x, y, rectangle.Width - rectangle.X, rectangle.Height - rectangle.Y, repaint);
			});
			thread.Start();
		}

		private void btnAddButton_Click(object sender, System.EventArgs e) {
			MessageBoxExButton button = new MessageBoxExButton();
			button.Text = txtButtonText.Text;
			button.Value = txtButtonVal.Text;
			button.HelpText = txtButtonHelp.Text;
			button.IsCancelButton = chbIsCancel.Checked;

			ListViewItem item = new ListViewItem();
			item.Text = button.Text;
			item.Tag = button;

			listViewButtons.Items.Add(item);
		}

		private void btnAddMessageBox_Click(object sender, System.EventArgs e) {
			MessageBoxEx msgBox = null;
			try {
				msgBox = CreateMessageBox(txtName.Text);
			} catch(Exception ex) {
				MessageBox.Show(this,"Error occured while creating message box. "+ex.Message,"Error",MessageBoxButtons.OK,MessageBoxIcon.Error);
			}

			if(msgBox == null)
				return;

			ListViewItem item = new ListViewItem(txtName.Text);
			item.Tag = msgBox;

			listViewMessageBoxes.Items.Add(item);
		}

		private void listViewMessageBoxes_ItemActivate(object sender, System.EventArgs e) {
			btnShowCustom.PerformClick();
		}

        private void MessageBoxExDemoForm_Load(object sender, System.EventArgs e) {
            cmbTimeoutResult.SelectedIndex = 0;
        }
		
		private MessageBoxExButton[] GetButtons() {
			ArrayList buttons = new ArrayList();
			foreach(ListViewItem item in listViewButtons.Items) {
				if(item.Checked) {
					if(item.Tag == null) {
						//Standard buttons
						MessageBoxExButton button = new MessageBoxExButton();
						button.Text = item.Text;
						button.Value = item.Text;
						buttons.Add(button);
					} else {
						//Custom buttons
						MessageBoxExButton button = item.Tag as MessageBoxExButton;
						if(button != null)
							buttons.Add(button);
					}
				}
			}

			return (MessageBoxExButton[])buttons.ToArray(typeof(MessageBoxExButton));
		}

		private MessageBoxExIcon GetIcon() {
			RadioButton selIcon = null;
			foreach(Control ctrl in grpBoxIcon.Controls) {
				if(ctrl is RadioButton) {
					if( ((RadioButton)ctrl).Checked ) {
						selIcon = ctrl as RadioButton;
						break;
					}
				}
			}
			return (MessageBoxExIcon)Enum.Parse(typeof(MessageBoxExIcon), selIcon.Text);
		}

		private MessageBoxEx CreateMessageBox(string name) {
			MessageBoxEx mbox = MessageBoxExManager.CreateMessageBox(name);
			mbox.Caption = txtCaption.Text;
			mbox.Text = txtMessage.Text;
			mbox.AllowSaveResponse = chbAllowSaveResponse.Checked;
			
			// mbox.chbAllowReposition = chbAllowReposition.Checked;
				
			mbox.SaveResponseText = txtSaveResponse.Text;

			foreach(MessageBoxExButton button in GetButtons()) {
				mbox.AddButton(button);
			}

			mbox.Icon = GetIcon();
			return mbox;
		}

		#region Ignore
		private void Test() {
			MessageBoxEx msgBox = MessageBoxExManager.CreateMessageBox("Test");
			msgBox.Caption = "Question";
			msgBox.Text = "Do you want to save the data?";
			
			msgBox.AddButtons(MessageBoxButtons.YesNo);
			msgBox.Icon = MessageBoxExIcon.Question;

			msgBox.SaveResponseText = "Don't ask me again";
			msgBox.AllowSaveResponse = true;

			msgBox.Font = new Font("Tahoma",8);
			
            string result = msgBox.Show();
		}

		private void Test2() {
			MessageBoxEx msgBox = MessageBoxExManager.CreateMessageBox("Test2");
			msgBox.Caption = "Question";
			msgBox.Text = "Do you want to save the data?";
			
			MessageBoxExButton btnYes = new MessageBoxExButton();
			btnYes.Text = "Yes";
			btnYes.Value = "Yes";
			btnYes.HelpText = "Save the data";

			MessageBoxExButton btnNo = new MessageBoxExButton();
			btnNo.Text = "No";
			btnNo.Value = "No";
			btnNo.HelpText = "Do not save the data";

			msgBox.AddButton(btnYes);
			msgBox.AddButton(btnNo);

			msgBox.Icon = MessageBoxExIcon.Question;

			msgBox.SaveResponseText = "Don't ask me again";
			msgBox.AllowSaveResponse = true;

			msgBox.Font = new Font("Tahoma",8);
			
			string result = msgBox.Show();
		}

        private void Test3() {
            // as an experiment, I moved these from class members to local members
            // to see if it helps -- it didn't -- but it helps show you nothing else
            // is going on!

            MessageBoxEx       m_msgBoxSummary1 = null;
            MessageBoxExButton m_btnYes = null;

            // Tahoma 8.25 in Ex originally

            m_msgBoxSummary1 = MessageBoxExManager.CreateMessageBox("Summary1");
            m_btnYes = new MessageBoxExButton();
            string m_sPROGRAM_NAME = "Possrv.Debug Merchant Parser";
            string m_sVersion = "1.00A";;
            m_msgBoxSummary1.Caption = m_sPROGRAM_NAME + " " + m_sVersion;

            // fyi: m_sPROGRAM_NAME = "Possrv.Debug Merchant Parser";

            // and m_sVersion = "1.00A";

            m_msgBoxSummary1.Icon = MessageBoxExIcon.Information;

            m_btnYes.Text = "Okay";

            m_btnYes.Value = "OK";

            m_msgBoxSummary1.AddButton(m_btnYes);

            String sResultM =

                "Hello this is a reasonably long message with 1234 56789";

            m_msgBoxSummary1.Font = new Font("Lucida Console", 8);

            m_msgBoxSummary1.Text = sResultM;

            String sResult3 = m_msgBoxSummary1.Show();  // first call

            sResult3 = m_msgBoxSummary1.Show();         // second call

            if(sResult3=="" || (1 + 1 == 2))return; // quiet the compiler
        }

        private void Test4() {
            MessageBoxEx msgBox = MessageBoxExManager.CreateMessageBox(null);
            msgBox.Caption = "Question";
            msgBox.Text = "Do you want to save the data?";
			
            msgBox.AddButtons(MessageBoxButtons.YesNo);
            msgBox.Icon = MessageBoxExIcon.Question;

            //Wait for 30 seconds for the user to respond
            msgBox.Timeout = 30000;
			msgBox.TimeoutResult = TimeoutResult.Timeout;

            string result = msgBox.Show();
            if(result == MessageBoxExResult.Timeout)
            {
                //Take action to handle the case of timeouts
            }
        }

        public void Test5() {
            MessageBoxEx msgBox = MessageBoxExManager.CreateMessageBox(null);
            msgBox.Caption = "Question";
            msgBox.Text = "Voulez-vous sauver les données ?";
            msgBox.AddButtons(MessageBoxButtons.YesNoCancel);
            msgBox.Icon = MessageBoxExIcon.Question;

            msgBox.Show();
        }

        public void Test6() {
            MessageBoxEx msgBox = MessageBoxExManager.CreateMessageBox("test");
            msgBox.Caption = "Information";
            msgBox.AddButtons(MessageBoxButtons.OK);

            msgBox.Text = "The following items are defined:\nItem 1\nItem 2\nItem 3\nItem 4\nItem 5\nItem 6\nItem 7\nItem 8\nItem 9\nItem10\n";
            msgBox.Show();

            msgBox.Text = "Items:\nItem 1\nItem 2\nItem 3\nItem 4\nItem 5\nItem 6\nItem 7\nItem 8\nItem 9\nItem10\n";
            msgBox.Show();
        }
        private void button1_Click(object sender, System.EventArgs e) {
            Test();
            Test2();
            Test3();
            Test4();
            Test5();
            Test6();
        }
		void CheckBox1CheckedChanged(object sender, EventArgs e)
		{
	
		}
		#endregion
	}
}
