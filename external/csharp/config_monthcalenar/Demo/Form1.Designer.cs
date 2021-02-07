namespace Demo
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.txtDateFormat = new System.Windows.Forms.TextBox();
            this.lblDateFormat = new System.Windows.Forms.Label();
            this.btnDateSet = new System.Windows.Forms.Button();
            this.btnTimeFormat = new System.Windows.Forms.Button();
            this.lblTimeFormat = new System.Windows.Forms.Label();
            this.txtTimeFormat = new System.Windows.Forms.TextBox();
            this.txtValidDate = new System.Windows.Forms.TextBox();
            this.lblValidDate = new System.Windows.Forms.Label();
            this.lblValidTime = new System.Windows.Forms.Label();
            this.txtValidTime = new System.Windows.Forms.TextBox();
            this.btnSaveFormat = new System.Windows.Forms.Button();
            this.btnClose = new System.Windows.Forms.Button();
            this.linkReference = new System.Windows.Forms.LinkLabel();
            this.lblLink = new System.Windows.Forms.Label();
            this.ctlDateTimePicker1 = new CompleteDateTimePicker.CompleteDateTimePickerControl();
            this.SuspendLayout();
            // 
            // txtDateFormat
            // 
            this.txtDateFormat.Location = new System.Drawing.Point(112, 12);
            this.txtDateFormat.Name = "txtDateFormat";
            this.txtDateFormat.Size = new System.Drawing.Size(191, 20);
            this.txtDateFormat.TabIndex = 1;
            // 
            // lblDateFormat
            // 
            this.lblDateFormat.AutoSize = true;
            this.lblDateFormat.Location = new System.Drawing.Point(11, 15);
            this.lblDateFormat.Name = "lblDateFormat";
            this.lblDateFormat.Size = new System.Drawing.Size(95, 13);
            this.lblDateFormat.TabIndex = 0;
            this.lblDateFormat.Text = "Date Format String";
            // 
            // btnDateSet
            // 
            this.btnDateSet.Location = new System.Drawing.Point(309, 10);
            this.btnDateSet.Name = "btnDateSet";
            this.btnDateSet.Size = new System.Drawing.Size(75, 23);
            this.btnDateSet.TabIndex = 2;
            this.btnDateSet.Text = "Set Property";
            this.btnDateSet.UseVisualStyleBackColor = true;
            this.btnDateSet.Click += new System.EventHandler(this.btnDateSet_Click);
            // 
            // btnTimeFormat
            // 
            this.btnTimeFormat.Location = new System.Drawing.Point(309, 37);
            this.btnTimeFormat.Name = "btnTimeFormat";
            this.btnTimeFormat.Size = new System.Drawing.Size(75, 23);
            this.btnTimeFormat.TabIndex = 5;
            this.btnTimeFormat.Text = "Set Property";
            this.btnTimeFormat.UseVisualStyleBackColor = true;
            this.btnTimeFormat.Click += new System.EventHandler(this.btnTimeFormat_Click);
            // 
            // lblTimeFormat
            // 
            this.lblTimeFormat.AutoSize = true;
            this.lblTimeFormat.Location = new System.Drawing.Point(11, 42);
            this.lblTimeFormat.Name = "lblTimeFormat";
            this.lblTimeFormat.Size = new System.Drawing.Size(95, 13);
            this.lblTimeFormat.TabIndex = 3;
            this.lblTimeFormat.Text = "Time Format String";
            // 
            // txtTimeFormat
            // 
            this.txtTimeFormat.Location = new System.Drawing.Point(112, 39);
            this.txtTimeFormat.Name = "txtTimeFormat";
            this.txtTimeFormat.Size = new System.Drawing.Size(191, 20);
            this.txtTimeFormat.TabIndex = 4;
            // 
            // txtValidDate
            // 
            this.txtValidDate.Location = new System.Drawing.Point(17, 147);
            this.txtValidDate.Multiline = true;
            this.txtValidDate.Name = "txtValidDate";
            this.txtValidDate.ReadOnly = true;
            this.txtValidDate.Size = new System.Drawing.Size(174, 100);
            this.txtValidDate.TabIndex = 9;
            this.txtValidDate.TabStop = false;
            // 
            // lblValidDate
            // 
            this.lblValidDate.Location = new System.Drawing.Point(14, 106);
            this.lblValidDate.Name = "lblValidDate";
            this.lblValidDate.Size = new System.Drawing.Size(150, 38);
            this.lblValidDate.TabIndex = 7;
            this.lblValidDate.Text = "Valid Date Format Characters (case sensitive)";
            // 
            // lblValidTime
            // 
            this.lblValidTime.Location = new System.Drawing.Point(203, 106);
            this.lblValidTime.Name = "lblValidTime";
            this.lblValidTime.Size = new System.Drawing.Size(151, 38);
            this.lblValidTime.TabIndex = 8;
            this.lblValidTime.Text = "Valid Time Format Characters (case sensitive)";
            // 
            // txtValidTime
            // 
            this.txtValidTime.Location = new System.Drawing.Point(206, 147);
            this.txtValidTime.Multiline = true;
            this.txtValidTime.Name = "txtValidTime";
            this.txtValidTime.ReadOnly = true;
            this.txtValidTime.Size = new System.Drawing.Size(174, 100);
            this.txtValidTime.TabIndex = 10;
            this.txtValidTime.TabStop = false;
            // 
            // btnSaveFormat
            // 
            this.btnSaveFormat.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnSaveFormat.Location = new System.Drawing.Point(152, 307);
            this.btnSaveFormat.Name = "btnSaveFormat";
            this.btnSaveFormat.Size = new System.Drawing.Size(111, 23);
            this.btnSaveFormat.TabIndex = 11;
            this.btnSaveFormat.Text = "Save Format Strings";
            this.btnSaveFormat.UseVisualStyleBackColor = true;
            this.btnSaveFormat.Click += new System.EventHandler(this.btnSaveFormat_Click);
            // 
            // btnClose
            // 
            this.btnClose.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnClose.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.btnClose.Location = new System.Drawing.Point(269, 307);
            this.btnClose.Name = "btnClose";
            this.btnClose.Size = new System.Drawing.Size(111, 23);
            this.btnClose.TabIndex = 12;
            this.btnClose.Text = "Close";
            this.btnClose.UseVisualStyleBackColor = true;
            this.btnClose.Click += new System.EventHandler(this.btnClose_Click);
            // 
            // linkReference
            // 
            this.linkReference.Location = new System.Drawing.Point(14, 281);
            this.linkReference.Name = "linkReference";
            this.linkReference.Size = new System.Drawing.Size(366, 23);
            this.linkReference.TabIndex = 13;
            this.linkReference.TabStop = true;
            this.linkReference.Text = "http://msdn.microsoft.com/en-us/library/vstudio/8kb3ddd4(v=vs.100).aspx";
            // 
            // lblLink
            // 
            this.lblLink.AutoSize = true;
            this.lblLink.Location = new System.Drawing.Point(11, 260);
            this.lblLink.Name = "lblLink";
            this.lblLink.Size = new System.Drawing.Size(179, 13);
            this.lblLink.TabIndex = 14;
            this.lblLink.Text = "Date/Time Format String Reference:";
            // 
            // ctlDateTimePicker1
            // 
            this.ctlDateTimePicker1.DateFormat = "MM/dd/yyyy";
            this.ctlDateTimePicker1.Location = new System.Drawing.Point(64, 66);
            this.ctlDateTimePicker1.Name = "ctlDateTimePicker1";
            this.ctlDateTimePicker1.Size = new System.Drawing.Size(258, 20);
            this.ctlDateTimePicker1.TabIndex = 6;
            this.ctlDateTimePicker1.TimeFormat = "";
            this.ctlDateTimePicker1.Value = new System.DateTime(((long)(0)));
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.CancelButton = this.btnClose;
            this.ClientSize = new System.Drawing.Size(396, 339);
            this.Controls.Add(this.lblLink);
            this.Controls.Add(this.linkReference);
            this.Controls.Add(this.btnClose);
            this.Controls.Add(this.btnSaveFormat);
            this.Controls.Add(this.lblValidTime);
            this.Controls.Add(this.txtValidTime);
            this.Controls.Add(this.lblValidDate);
            this.Controls.Add(this.txtValidDate);
            this.Controls.Add(this.btnTimeFormat);
            this.Controls.Add(this.lblTimeFormat);
            this.Controls.Add(this.txtTimeFormat);
            this.Controls.Add(this.btnDateSet);
            this.Controls.Add(this.lblDateFormat);
            this.Controls.Add(this.txtDateFormat);
            this.Controls.Add(this.ctlDateTimePicker1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Complete Date/Time Picker";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private CompleteDateTimePicker.CompleteDateTimePickerControl ctlDateTimePicker1;
        private System.Windows.Forms.TextBox txtDateFormat;
        private System.Windows.Forms.Label lblDateFormat;
        private System.Windows.Forms.Button btnDateSet;
        private System.Windows.Forms.Button btnTimeFormat;
        private System.Windows.Forms.Label lblTimeFormat;
        private System.Windows.Forms.TextBox txtTimeFormat;
        private System.Windows.Forms.TextBox txtValidDate;
        private System.Windows.Forms.Label lblValidDate;
        private System.Windows.Forms.Label lblValidTime;
        private System.Windows.Forms.TextBox txtValidTime;
        private System.Windows.Forms.Button btnSaveFormat;
        private System.Windows.Forms.Button btnClose;
        private System.Windows.Forms.LinkLabel linkReference;
        private System.Windows.Forms.Label lblLink;
    }
}

