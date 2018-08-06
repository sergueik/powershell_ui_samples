namespace TestNotifier
{
    partial class MainForm
    {
        /// <summary>
        /// Variabile di progettazione necessaria.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Pulire le risorse in uso.
        /// </summary>
        /// <param name="disposing">ha valore true se le risorse gestite devono essere eliminate, false in caso contrario.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Codice generato da Progettazione Windows Form

        /// <summary>
        /// Metodo necessario per il supporto della finestra di progettazione. Non modificare
        /// il contenuto del metodo con l'editor di codice.
        /// </summary>
        private void InitializeComponent()
        {
            this.textNote = new System.Windows.Forms.TextBox();
            this.notifyButton = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.radioButtonInfo = new System.Windows.Forms.RadioButton();
            this.radioButtonError = new System.Windows.Forms.RadioButton();
            this.radioButtonWarning = new System.Windows.Forms.RadioButton();
            this.radioButtonOk = new System.Windows.Forms.RadioButton();
            this.label2 = new System.Windows.Forms.Label();
            this.textTitle = new System.Windows.Forms.TextBox();
            this.buttonUpdate = new System.Windows.Forms.Button();
            this.numericNote = new System.Windows.Forms.NumericUpDown();
            this.notifyDiagButton = new System.Windows.Forms.Button();
            this.label3 = new System.Windows.Forms.Label();
            this.timeout = new System.Windows.Forms.NumericUpDown();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.backNone = new System.Windows.Forms.RadioButton();
            this.backApp = new System.Windows.Forms.RadioButton();
            this.backFull = new System.Windows.Forms.RadioButton();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.inApp = new System.Windows.Forms.CheckBox();
            ((System.ComponentModel.ISupportInitialize)(this.numericNote)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.timeout)).BeginInit();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // textNote
            // 
            this.textNote.Location = new System.Drawing.Point(11, 82);
            this.textNote.Name = "textNote";
            this.textNote.Size = new System.Drawing.Size(196, 20);
            this.textNote.TabIndex = 0;
            this.textNote.Text = "Hello World";
            // 
            // notifyButton
            // 
            this.notifyButton.Location = new System.Drawing.Point(19, 204);
            this.notifyButton.Name = "notifyButton";
            this.notifyButton.Size = new System.Drawing.Size(186, 29);
            this.notifyButton.TabIndex = 1;
            this.notifyButton.Text = "Notify Me";
            this.notifyButton.UseVisualStyleBackColor = true;
            this.notifyButton.Click += new System.EventHandler(this.onNotifyButtonClick);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 63);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(55, 13);
            this.label1.TabIndex = 2;
            this.label1.Text = "Text note:";
            // 
            // radioButtonInfo
            // 
            this.radioButtonInfo.AutoSize = true;
            this.radioButtonInfo.Checked = true;
            this.radioButtonInfo.Location = new System.Drawing.Point(15, 109);
            this.radioButtonInfo.Name = "radioButtonInfo";
            this.radioButtonInfo.Size = new System.Drawing.Size(43, 17);
            this.radioButtonInfo.TabIndex = 3;
            this.radioButtonInfo.TabStop = true;
            this.radioButtonInfo.Text = "Info";
            this.radioButtonInfo.UseVisualStyleBackColor = true;
            // 
            // radioButtonError
            // 
            this.radioButtonError.AutoSize = true;
            this.radioButtonError.Location = new System.Drawing.Point(15, 132);
            this.radioButtonError.Name = "radioButtonError";
            this.radioButtonError.Size = new System.Drawing.Size(47, 17);
            this.radioButtonError.TabIndex = 4;
            this.radioButtonError.TabStop = true;
            this.radioButtonError.Text = "Error";
            this.radioButtonError.UseVisualStyleBackColor = true;
            // 
            // radioButtonWarning
            // 
            this.radioButtonWarning.AutoSize = true;
            this.radioButtonWarning.Location = new System.Drawing.Point(89, 132);
            this.radioButtonWarning.Name = "radioButtonWarning";
            this.radioButtonWarning.Size = new System.Drawing.Size(65, 17);
            this.radioButtonWarning.TabIndex = 6;
            this.radioButtonWarning.TabStop = true;
            this.radioButtonWarning.Text = "Warning";
            this.radioButtonWarning.UseVisualStyleBackColor = true;
            // 
            // radioButtonOk
            // 
            this.radioButtonOk.AutoSize = true;
            this.radioButtonOk.Location = new System.Drawing.Point(89, 109);
            this.radioButtonOk.Name = "radioButtonOk";
            this.radioButtonOk.Size = new System.Drawing.Size(40, 17);
            this.radioButtonOk.TabIndex = 5;
            this.radioButtonOk.TabStop = true;
            this.radioButtonOk.Text = "OK";
            this.radioButtonOk.UseVisualStyleBackColor = true;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(12, 6);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(49, 13);
            this.label2.TabIndex = 8;
            this.label2.Text = "Bar Title:";
            // 
            // textTitle
            // 
            this.textTitle.Location = new System.Drawing.Point(11, 25);
            this.textTitle.Name = "textTitle";
            this.textTitle.Size = new System.Drawing.Size(196, 20);
            this.textTitle.TabIndex = 7;
            this.textTitle.Text = "Note";
            // 
            // buttonUpdate
            // 
            this.buttonUpdate.Location = new System.Drawing.Point(12, 324);
            this.buttonUpdate.Name = "buttonUpdate";
            this.buttonUpdate.Size = new System.Drawing.Size(100, 29);
            this.buttonUpdate.TabIndex = 9;
            this.buttonUpdate.Text = "Update Note";
            this.buttonUpdate.UseVisualStyleBackColor = true;
            this.buttonUpdate.Click += new System.EventHandler(this.onUpdateButtonClick);
            // 
            // numericNote
            // 
            this.numericNote.Location = new System.Drawing.Point(143, 330);
            this.numericNote.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.numericNote.Name = "numericNote";
            this.numericNote.Size = new System.Drawing.Size(64, 20);
            this.numericNote.TabIndex = 10;
            this.numericNote.Value = new decimal(new int[] {
            1,
            0,
            0,
            0});
            // 
            // notifyDiagButton
            // 
            this.notifyDiagButton.Location = new System.Drawing.Point(7, 16);
            this.notifyDiagButton.Name = "notifyDiagButton";
            this.notifyDiagButton.Size = new System.Drawing.Size(187, 29);
            this.notifyDiagButton.TabIndex = 11;
            this.notifyDiagButton.Text = "Notify Dialog";
            this.notifyDiagButton.UseVisualStyleBackColor = true;
            this.notifyDiagButton.Click += new System.EventHandler(this.oNotifyDialogButtonClick);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(12, 158);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(48, 13);
            this.label3.TabIndex = 12;
            this.label3.Text = "Timeout:";
            // 
            // timeout
            // 
            this.timeout.Increment = new decimal(new int[] {
            500,
            0,
            0,
            0});
            this.timeout.Location = new System.Drawing.Point(11, 174);
            this.timeout.Maximum = new decimal(new int[] {
            5000,
            0,
            0,
            0});
            this.timeout.Name = "timeout";
            this.timeout.Size = new System.Drawing.Size(75, 20);
            this.timeout.TabIndex = 13;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(92, 176);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(20, 13);
            this.label4.TabIndex = 14;
            this.label4.Text = "ms";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(119, 332);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(18, 13);
            this.label5.TabIndex = 15;
            this.label5.Text = "ID";
            // 
            // backNone
            // 
            this.backNone.AutoSize = true;
            this.backNone.Location = new System.Drawing.Point(8, 52);
            this.backNone.Name = "backNone";
            this.backNone.Size = new System.Drawing.Size(51, 17);
            this.backNone.TabIndex = 16;
            this.backNone.Text = "None";
            this.backNone.UseVisualStyleBackColor = true;
            // 
            // backApp
            // 
            this.backApp.AutoSize = true;
            this.backApp.Checked = true;
            this.backApp.Location = new System.Drawing.Point(67, 52);
            this.backApp.Name = "backApp";
            this.backApp.Size = new System.Drawing.Size(44, 17);
            this.backApp.TabIndex = 17;
            this.backApp.TabStop = true;
            this.backApp.Text = "App";
            this.backApp.UseVisualStyleBackColor = true;
            // 
            // backFull
            // 
            this.backFull.AutoSize = true;
            this.backFull.Location = new System.Drawing.Point(121, 52);
            this.backFull.Name = "backFull";
            this.backFull.Size = new System.Drawing.Size(73, 17);
            this.backFull.TabIndex = 18;
            this.backFull.Text = "Fullscreen";
            this.backFull.UseVisualStyleBackColor = true;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.backFull);
            this.groupBox1.Controls.Add(this.notifyDiagButton);
            this.groupBox1.Controls.Add(this.backApp);
            this.groupBox1.Controls.Add(this.backNone);
            this.groupBox1.Location = new System.Drawing.Point(11, 239);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(200, 79);
            this.groupBox1.TabIndex = 19;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Dialog Note";
            // 
            // inApp
            // 
            this.inApp.AutoSize = true;
            this.inApp.Checked = true;
            this.inApp.CheckState = System.Windows.Forms.CheckState.Checked;
            this.inApp.Location = new System.Drawing.Point(132, 174);
            this.inApp.Name = "inApp";
            this.inApp.Size = new System.Drawing.Size(53, 17);
            this.inApp.TabIndex = 20;
            this.inApp.Text = "inApp";
            this.inApp.UseVisualStyleBackColor = true;
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(747, 418);
            this.Controls.Add(this.inApp);
            this.Controls.Add(this.notifyButton);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.timeout);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.numericNote);
            this.Controls.Add(this.buttonUpdate);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.textTitle);
            this.Controls.Add(this.radioButtonWarning);
            this.Controls.Add(this.radioButtonOk);
            this.Controls.Add(this.radioButtonError);
            this.Controls.Add(this.radioButtonInfo);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.textNote);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.SizableToolWindow;
            this.Name = "MainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Test Notifier";
            ((System.ComponentModel.ISupportInitialize)(this.numericNote)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.timeout)).EndInit();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox textNote;
        private System.Windows.Forms.Button notifyButton;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.RadioButton radioButtonInfo;
        private System.Windows.Forms.RadioButton radioButtonError;
        private System.Windows.Forms.RadioButton radioButtonWarning;
        private System.Windows.Forms.RadioButton radioButtonOk;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox textTitle;
        private System.Windows.Forms.Button buttonUpdate;
        private System.Windows.Forms.NumericUpDown numericNote;
        private System.Windows.Forms.Button notifyDiagButton;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.NumericUpDown timeout;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.RadioButton backNone;
        private System.Windows.Forms.RadioButton backApp;
        private System.Windows.Forms.RadioButton backFull;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.CheckBox inApp;
    }
}

