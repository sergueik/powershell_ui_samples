using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Globalization;
using System.Threading;

using MessageBoxExLib;

namespace MessageBoxExDemo
{
	/// <summary>
	/// 
	/// </summary>
	public class MessageBoxExDemoForm : System.Windows.Forms.Form
	{
		#region Fields

		private System.Windows.Forms.Button btnShowCustom;
		private System.Windows.Forms.GroupBox grpBoxIcon;
		private System.Windows.Forms.RadioButton radioButton4;
		private System.Windows.Forms.RadioButton radioButton3;
		private System.Windows.Forms.RadioButton radioButton2;
		private System.Windows.Forms.RadioButton radioButton1;
		private System.Windows.Forms.ListView listViewButtons;
		private System.Windows.Forms.ColumnHeader columnHeader1;
		private System.Windows.Forms.TextBox txtMessage;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.TextBox txtCaption;
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.RadioButton radioButton5;
		private System.Windows.Forms.TextBox txtSaveResponse;
		private System.Windows.Forms.CheckBox chbAllowSaveResponse;
		private System.Windows.Forms.TextBox txtResult;
		private System.Windows.Forms.Label label3;
		private System.Windows.Forms.ListView listViewMessageBoxes;
		private System.Windows.Forms.ColumnHeader columnHeader2;
		private System.Windows.Forms.Button btnAddMessageBox;
		private System.Windows.Forms.TextBox txtName;
		private System.Windows.Forms.Label label4;
		private System.Windows.Forms.GroupBox groupBox1;
		private System.Windows.Forms.TextBox txtButtonText;
		private System.Windows.Forms.Label ButtonText;
		private System.Windows.Forms.TextBox txtButtonVal;
		private System.Windows.Forms.Label label5;
		private System.Windows.Forms.CheckBox chbIsCancel;
		private System.Windows.Forms.Label label6;
		private System.Windows.Forms.Button btnAddButton;
		private System.Windows.Forms.TextBox txtButtonHelp;
		private System.Windows.Forms.CheckBox chbUseSavedResponse;
		private System.Windows.Forms.CheckBox chbPlayAlert;
        private System.Windows.Forms.ToolTip toolTip1;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.TextBox txtTimeout;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.ComboBox cmbTimeoutResult;
        private System.Windows.Forms.Button button1;
        private System.ComponentModel.IContainer components;
		#endregion
		
		#region Ctor/Dtor
		public MessageBoxExDemoForm()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if (components != null) 
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}
		#endregion

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
            this.components = new System.ComponentModel.Container();
            System.Windows.Forms.ListViewItem listViewItem1 = new System.Windows.Forms.ListViewItem("Ok");
            System.Windows.Forms.ListViewItem listViewItem2 = new System.Windows.Forms.ListViewItem("Cancel");
            System.Windows.Forms.ListViewItem listViewItem3 = new System.Windows.Forms.ListViewItem("Yes");
            System.Windows.Forms.ListViewItem listViewItem4 = new System.Windows.Forms.ListViewItem("No");
            System.Windows.Forms.ListViewItem listViewItem5 = new System.Windows.Forms.ListViewItem("Abort");
            System.Windows.Forms.ListViewItem listViewItem6 = new System.Windows.Forms.ListViewItem("Retry");
            System.Windows.Forms.ListViewItem listViewItem7 = new System.Windows.Forms.ListViewItem("Ignore");
            this.btnShowCustom = new System.Windows.Forms.Button();
            this.grpBoxIcon = new System.Windows.Forms.GroupBox();
            this.radioButton5 = new System.Windows.Forms.RadioButton();
            this.radioButton4 = new System.Windows.Forms.RadioButton();
            this.radioButton3 = new System.Windows.Forms.RadioButton();
            this.radioButton2 = new System.Windows.Forms.RadioButton();
            this.radioButton1 = new System.Windows.Forms.RadioButton();
            this.listViewButtons = new System.Windows.Forms.ListView();
            this.columnHeader1 = new System.Windows.Forms.ColumnHeader();
            this.txtMessage = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.txtCaption = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.chbAllowSaveResponse = new System.Windows.Forms.CheckBox();
            this.txtSaveResponse = new System.Windows.Forms.TextBox();
            this.txtResult = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.listViewMessageBoxes = new System.Windows.Forms.ListView();
            this.columnHeader2 = new System.Windows.Forms.ColumnHeader();
            this.btnAddMessageBox = new System.Windows.Forms.Button();
            this.txtName = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.txtButtonHelp = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.chbIsCancel = new System.Windows.Forms.CheckBox();
            this.txtButtonVal = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.txtButtonText = new System.Windows.Forms.TextBox();
            this.ButtonText = new System.Windows.Forms.Label();
            this.btnAddButton = new System.Windows.Forms.Button();
            this.chbUseSavedResponse = new System.Windows.Forms.CheckBox();
            this.chbPlayAlert = new System.Windows.Forms.CheckBox();
            this.toolTip1 = new System.Windows.Forms.ToolTip(this.components);
            this.txtTimeout = new System.Windows.Forms.TextBox();
            this.label7 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.cmbTimeoutResult = new System.Windows.Forms.ComboBox();
            this.label9 = new System.Windows.Forms.Label();
            this.button1 = new System.Windows.Forms.Button();
            this.grpBoxIcon.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // btnShowCustom
            // 
            this.btnShowCustom.Location = new System.Drawing.Point(752, 328);
            this.btnShowCustom.Name = "btnShowCustom";
            this.btnShowCustom.Size = new System.Drawing.Size(160, 23);
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
            this.grpBoxIcon.Location = new System.Drawing.Point(448, 216);
            this.grpBoxIcon.Name = "grpBoxIcon";
            this.grpBoxIcon.Size = new System.Drawing.Size(136, 184);
            this.grpBoxIcon.TabIndex = 15;
            this.grpBoxIcon.TabStop = false;
            this.grpBoxIcon.Text = "Icon";
            // 
            // radioButton5
            // 
            this.radioButton5.Location = new System.Drawing.Point(16, 152);
            this.radioButton5.Name = "radioButton5";
            this.radioButton5.TabIndex = 4;
            this.radioButton5.Text = "None";
            // 
            // radioButton4
            // 
            this.radioButton4.Location = new System.Drawing.Point(16, 120);
            this.radioButton4.Name = "radioButton4";
            this.radioButton4.TabIndex = 2;
            this.radioButton4.Text = "Question";
            // 
            // radioButton3
            // 
            this.radioButton3.Location = new System.Drawing.Point(16, 56);
            this.radioButton3.Name = "radioButton3";
            this.radioButton3.TabIndex = 1;
            this.radioButton3.Text = "Exclamation";
            // 
            // radioButton2
            // 
            this.radioButton2.Location = new System.Drawing.Point(16, 88);
            this.radioButton2.Name = "radioButton2";
            this.radioButton2.TabIndex = 3;
            this.radioButton2.Text = "Hand";
            // 
            // radioButton1
            // 
            this.radioButton1.Checked = true;
            this.radioButton1.Location = new System.Drawing.Point(16, 24);
            this.radioButton1.Name = "radioButton1";
            this.radioButton1.TabIndex = 0;
            this.radioButton1.TabStop = true;
            this.radioButton1.Text = "Asterisk";
            // 
            // listViewButtons
            // 
            this.listViewButtons.CheckBoxes = true;
            this.listViewButtons.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
                                                                                              this.columnHeader1});
            listViewItem1.StateImageIndex = 0;
            listViewItem2.StateImageIndex = 0;
            listViewItem3.StateImageIndex = 0;
            listViewItem4.StateImageIndex = 0;
            listViewItem5.StateImageIndex = 0;
            listViewItem6.StateImageIndex = 0;
            listViewItem7.StateImageIndex = 0;
            this.listViewButtons.Items.AddRange(new System.Windows.Forms.ListViewItem[] {
                                                                                            listViewItem1,
                                                                                            listViewItem2,
                                                                                            listViewItem3,
                                                                                            listViewItem4,
                                                                                            listViewItem5,
                                                                                            listViewItem6,
                                                                                            listViewItem7});
            this.listViewButtons.Location = new System.Drawing.Point(296, 216);
            this.listViewButtons.Name = "listViewButtons";
            this.listViewButtons.Size = new System.Drawing.Size(136, 184);
            this.listViewButtons.TabIndex = 14;
            this.listViewButtons.View = System.Windows.Forms.View.Details;
            // 
            // columnHeader1
            // 
            this.columnHeader1.Text = "Buttons";
            this.columnHeader1.Width = 130;
            // 
            // txtMessage
            // 
            this.txtMessage.Location = new System.Drawing.Point(72, 112);
            this.txtMessage.Multiline = true;
            this.txtMessage.Name = "txtMessage";
            this.txtMessage.Size = new System.Drawing.Size(280, 80);
            this.txtMessage.TabIndex = 5;
            this.txtMessage.Text = "<Message>";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(16, 112);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(47, 17);
            this.label2.TabIndex = 4;
            this.label2.Text = "Message";
            // 
            // txtCaption
            // 
            this.txtCaption.Location = new System.Drawing.Point(72, 72);
            this.txtCaption.Name = "txtCaption";
            this.txtCaption.Size = new System.Drawing.Size(280, 21);
            this.txtCaption.TabIndex = 3;
            this.txtCaption.Text = "<Caption>";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(16, 72);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(42, 17);
            this.label1.TabIndex = 2;
            this.label1.Text = "Caption";
            // 
            // chbAllowSaveResponse
            // 
            this.chbAllowSaveResponse.Location = new System.Drawing.Point(80, 408);
            this.chbAllowSaveResponse.Name = "chbAllowSaveResponse";
            this.chbAllowSaveResponse.Size = new System.Drawing.Size(144, 24);
            this.chbAllowSaveResponse.TabIndex = 16;
            this.chbAllowSaveResponse.Text = "Allow Save Response";
            // 
            // txtSaveResponse
            // 
            this.txtSaveResponse.Location = new System.Drawing.Point(82, 432);
            this.txtSaveResponse.Multiline = true;
            this.txtSaveResponse.Name = "txtSaveResponse";
            this.txtSaveResponse.Size = new System.Drawing.Size(272, 80);
            this.txtSaveResponse.TabIndex = 17;
            this.txtSaveResponse.Text = "<Save Response Text>";
            // 
            // txtResult
            // 
            this.txtResult.Location = new System.Drawing.Point(752, 512);
            this.txtResult.Name = "txtResult";
            this.txtResult.Size = new System.Drawing.Size(160, 21);
            this.txtResult.TabIndex = 7;
            this.txtResult.Text = "<Result>";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(712, 512);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(35, 17);
            this.label3.TabIndex = 6;
            this.label3.Text = "Result";
            this.label3.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // listViewMessageBoxes
            // 
            this.listViewMessageBoxes.Activation = System.Windows.Forms.ItemActivation.TwoClick;
            this.listViewMessageBoxes.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
                                                                                                   this.columnHeader2});
            this.listViewMessageBoxes.Location = new System.Drawing.Point(752, 96);
            this.listViewMessageBoxes.MultiSelect = false;
            this.listViewMessageBoxes.Name = "listViewMessageBoxes";
            this.listViewMessageBoxes.Size = new System.Drawing.Size(192, 224);
            this.listViewMessageBoxes.TabIndex = 2;
            this.listViewMessageBoxes.View = System.Windows.Forms.View.Details;
            this.listViewMessageBoxes.ItemActivate += new System.EventHandler(this.listViewMessageBoxes_ItemActivate);
            // 
            // columnHeader2
            // 
            this.columnHeader2.Text = "MessageBoxes";
            this.columnHeader2.Width = 183;
            // 
            // btnAddMessageBox
            // 
            this.btnAddMessageBox.Location = new System.Drawing.Point(608, 192);
            this.btnAddMessageBox.Name = "btnAddMessageBox";
            this.btnAddMessageBox.Size = new System.Drawing.Size(128, 23);
            this.btnAddMessageBox.TabIndex = 1;
            this.btnAddMessageBox.Text = "Add MessageBox >>";
            this.toolTip1.SetToolTip(this.btnAddMessageBox, "Create a message box with the specified information and add it to the list");
            this.btnAddMessageBox.Click += new System.EventHandler(this.btnAddMessageBox_Click);
            // 
            // txtName
            // 
            this.txtName.Location = new System.Drawing.Point(72, 32);
            this.txtName.Name = "txtName";
            this.txtName.Size = new System.Drawing.Size(280, 21);
            this.txtName.TabIndex = 1;
            this.txtName.Text = "<Name>";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(24, 32);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(33, 17);
            this.label4.TabIndex = 0;
            this.label4.Text = "Name";
            // 
            // groupBox1
            // 
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
            this.groupBox1.Location = new System.Drawing.Point(8, 8);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(592, 528);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "MessageBox";
            // 
            // txtButtonHelp
            // 
            this.txtButtonHelp.Location = new System.Drawing.Point(88, 280);
            this.txtButtonHelp.Name = "txtButtonHelp";
            this.txtButtonHelp.Size = new System.Drawing.Size(96, 21);
            this.txtButtonHelp.TabIndex = 11;
            this.txtButtonHelp.Text = "<Help Text>";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(16, 280);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(52, 17);
            this.label6.TabIndex = 10;
            this.label6.Text = "Help Text";
            // 
            // chbIsCancel
            // 
            this.chbIsCancel.Location = new System.Drawing.Point(88, 312);
            this.chbIsCancel.Name = "chbIsCancel";
            this.chbIsCancel.Size = new System.Drawing.Size(72, 24);
            this.chbIsCancel.TabIndex = 12;
            this.chbIsCancel.Text = "Is Cancel";
            // 
            // txtButtonVal
            // 
            this.txtButtonVal.Location = new System.Drawing.Point(88, 248);
            this.txtButtonVal.Name = "txtButtonVal";
            this.txtButtonVal.Size = new System.Drawing.Size(96, 21);
            this.txtButtonVal.TabIndex = 9;
            this.txtButtonVal.Text = "<Button Value>";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(16, 248);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(68, 17);
            this.label5.TabIndex = 8;
            this.label5.Text = "Button Value";
            // 
            // txtButtonText
            // 
            this.txtButtonText.Location = new System.Drawing.Point(88, 216);
            this.txtButtonText.Name = "txtButtonText";
            this.txtButtonText.Size = new System.Drawing.Size(96, 21);
            this.txtButtonText.TabIndex = 7;
            this.txtButtonText.Text = "<Button Text>";
            // 
            // ButtonText
            // 
            this.ButtonText.AutoSize = true;
            this.ButtonText.Location = new System.Drawing.Point(16, 216);
            this.ButtonText.Name = "ButtonText";
            this.ButtonText.Size = new System.Drawing.Size(59, 17);
            this.ButtonText.TabIndex = 6;
            this.ButtonText.Text = "ButtonText";
            // 
            // btnAddButton
            // 
            this.btnAddButton.Location = new System.Drawing.Point(192, 216);
            this.btnAddButton.Name = "btnAddButton";
            this.btnAddButton.Size = new System.Drawing.Size(88, 23);
            this.btnAddButton.TabIndex = 13;
            this.btnAddButton.Text = "Add Button >>";
            this.toolTip1.SetToolTip(this.btnAddButton, "Create a button using the specified information and add it to the list");
            this.btnAddButton.Click += new System.EventHandler(this.btnAddButton_Click);
            // 
            // chbUseSavedResponse
            // 
            this.chbUseSavedResponse.Checked = true;
            this.chbUseSavedResponse.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chbUseSavedResponse.Location = new System.Drawing.Point(752, 352);
            this.chbUseSavedResponse.Name = "chbUseSavedResponse";
            this.chbUseSavedResponse.Size = new System.Drawing.Size(160, 24);
            this.chbUseSavedResponse.TabIndex = 4;
            this.chbUseSavedResponse.Text = "Use Saved Response";
            // 
            // chbPlayAlert
            // 
            this.chbPlayAlert.Checked = true;
            this.chbPlayAlert.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chbPlayAlert.Location = new System.Drawing.Point(752, 384);
            this.chbPlayAlert.Name = "chbPlayAlert";
            this.chbPlayAlert.Size = new System.Drawing.Size(160, 24);
            this.chbPlayAlert.TabIndex = 5;
            this.chbPlayAlert.Text = "Play Alert Sound";
            // 
            // txtTimeout
            // 
            this.txtTimeout.Location = new System.Drawing.Point(752, 416);
            this.txtTimeout.Name = "txtTimeout";
            this.txtTimeout.Size = new System.Drawing.Size(160, 21);
            this.txtTimeout.TabIndex = 9;
            this.txtTimeout.Text = "0";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(704, 416);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(45, 17);
            this.label7.TabIndex = 8;
            this.label7.Text = "Timeout";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(912, 416);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(19, 17);
            this.label8.TabIndex = 10;
            this.label8.Text = "ms";
            // 
            // cmbTimeoutResult
            // 
            this.cmbTimeoutResult.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cmbTimeoutResult.Items.AddRange(new object[] {
                                                                  "Default",
                                                                  "Cancel",
                                                                  "Timeout"});
            this.cmbTimeoutResult.Location = new System.Drawing.Point(752, 448);
            this.cmbTimeoutResult.Name = "cmbTimeoutResult";
            this.cmbTimeoutResult.Size = new System.Drawing.Size(160, 21);
            this.cmbTimeoutResult.TabIndex = 11;
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(670, 448);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(79, 17);
            this.label9.TabIndex = 12;
            this.label9.Text = "Timeout Result";
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(872, 8);
            this.button1.Name = "button1";
            this.button1.TabIndex = 13;
            this.button1.Text = "Run Tests";
            this.button1.Visible = false;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // MessageBoxExDemoForm
            // 
            this.AutoScaleBaseSize = new System.Drawing.Size(5, 14);
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
            this.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
            this.Name = "MessageBoxExDemoForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "MessageBoxEx Demo";
            this.Load += new System.EventHandler(this.MessageBoxExDemoForm_Load);
            this.grpBoxIcon.ResumeLayout(false);
            this.groupBox1.ResumeLayout(false);
            this.ResumeLayout(false);

        }
		#endregion

		#region Main
		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() 
		{
            //Thread.CurrentThread.CurrentUICulture = CultureInfo.CreateSpecificCulture("fr");
			Application.Run(new MessageBoxExDemoForm());
		}
		#endregion

        #region Event Handlers
		private void btnShowCustom_Click(object sender, System.EventArgs e)
		{
			if(listViewMessageBoxes.SelectedItems.Count == 0)
			{
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
            txtResult.Text = msgBox.Show(this);
		}

		private void btnAddButton_Click(object sender, System.EventArgs e)
		{
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

		private void btnAddMessageBox_Click(object sender, System.EventArgs e)
		{
			MessageBoxEx msgBox = null;
			try
			{
				msgBox = CreateMessageBox(txtName.Text);
			}
			catch(Exception ex)
			{
				MessageBox.Show(this,"Error occured while creating message box. "+ex.Message,"Error",MessageBoxButtons.OK,MessageBoxIcon.Error);
			}

			if(msgBox == null)
				return;

			ListViewItem item = new ListViewItem(txtName.Text);
			item.Tag = msgBox;

			listViewMessageBoxes.Items.Add(item);
		}

		private void listViewMessageBoxes_ItemActivate(object sender, System.EventArgs e)
		{
			btnShowCustom.PerformClick();
		}

        private void MessageBoxExDemoForm_Load(object sender, System.EventArgs e)
        {
            cmbTimeoutResult.SelectedIndex = 0;
        }
		#endregion

		#region Methods
		private MessageBoxExButton[] GetButtons()
		{
			ArrayList buttons = new ArrayList();
			foreach(ListViewItem item in listViewButtons.Items)
			{
				if(item.Checked)
				{
					if(item.Tag == null)
					{
						//Standard buttons
						MessageBoxExButton button = new MessageBoxExButton();
						button.Text = item.Text;
						button.Value = item.Text;
						buttons.Add(button);
					}
					else
					{
						//Custom buttons
						MessageBoxExButton button = item.Tag as MessageBoxExButton;
						if(button != null)
							buttons.Add(button);
					}
				}
			}

			return (MessageBoxExButton[])buttons.ToArray(typeof(MessageBoxExButton));
		}

		private MessageBoxExIcon GetIcon()
		{
			RadioButton selIcon = null;
			foreach(Control ctrl in grpBoxIcon.Controls)
			{
				if(ctrl is RadioButton)
				{
					if( ((RadioButton)ctrl).Checked )
					{
						selIcon = ctrl as RadioButton;
						break;
					}
				}
			}

			return (MessageBoxExIcon)Enum.Parse(typeof(MessageBoxExIcon), selIcon.Text);
		}

		private MessageBoxEx CreateMessageBox(string name)
		{
			MessageBoxEx mbox = MessageBoxExManager.CreateMessageBox(name);
			mbox.Caption = txtCaption.Text;
			mbox.Text = txtMessage.Text;
			mbox.AllowSaveResponse = chbAllowSaveResponse.Checked;
			mbox.SaveResponseText = txtSaveResponse.Text;

			foreach(MessageBoxExButton button in GetButtons())
			{
				mbox.AddButton(button);
			}

			mbox.Icon = GetIcon();
			return mbox;
		}

		#region Ignore
		private void Test()
		{
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

		private void Test2()
		{
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

        /// <summary>
        /// Test case which exposed the AutoScale bug, this was submitted by Harry Stein
        /// </summary>
        private void Test3()
        {
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

        private void Test4()
        {
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

        public void Test5()
        {
            MessageBoxEx msgBox = MessageBoxExManager.CreateMessageBox(null);
            msgBox.Caption = "Question";
            msgBox.Text = "Voulez-vous sauver les données ?";
            msgBox.AddButtons(MessageBoxButtons.YesNoCancel);
            msgBox.Icon = MessageBoxExIcon.Question;

            msgBox.Show();
        }

        public void Test6()
        {
            MessageBoxEx msgBox = MessageBoxExManager.CreateMessageBox("test");
            msgBox.Caption = "Information";
            msgBox.AddButtons(MessageBoxButtons.OK);

            msgBox.Text = "The following items are defined:\nItem 1\nItem 2\nItem 3\nItem 4\nItem 5\nItem 6\nItem 7\nItem 8\nItem 9\nItem10\n";
            msgBox.Show();

            msgBox.Text = "Items:\nItem 1\nItem 2\nItem 3\nItem 4\nItem 5\nItem 6\nItem 7\nItem 8\nItem 9\nItem10\n";
            msgBox.Show();
        }
        private void button1_Click(object sender, System.EventArgs e)
        {
            Test();
            Test2();
            Test3();
            Test4();
            Test5();
            Test6();
        }
        #endregion
		#endregion
	}
}
