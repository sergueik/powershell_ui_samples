namespace CustomWindowsForm
{
    partial class MainForm
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
            this.TopPanel = new System.Windows.Forms.Panel();
            this.WindowTextLabel = new System.Windows.Forms.Label();
            this.panel1 = new System.Windows.Forms.Panel();
            this.panel2 = new System.Windows.Forms.Panel();
            this.panel3 = new System.Windows.Forms.Panel();
            this.buttonZ1 = new CustomWindowsForm.ButtonZ();
            this.shapedButton3 = new CustomWindowsForm.ShapedButton();
            this.shapedButton2 = new CustomWindowsForm.ShapedButton();
            this.shapedButton1 = new CustomWindowsForm.ShapedButton();
            this._MinButton = new CustomWindowsForm.ButtonZ();
            this._CloseButton = new CustomWindowsForm.ButtonZ();
            this.TopPanel.SuspendLayout();
            this.SuspendLayout();
            // 
            // TopPanel
            // 
            this.TopPanel.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(10)))), ((int)(((byte)(100)))), ((int)(((byte)(60)))));
            this.TopPanel.Controls.Add(this.WindowTextLabel);
            this.TopPanel.Controls.Add(this._MinButton);
            this.TopPanel.Controls.Add(this._CloseButton);
            this.TopPanel.Dock = System.Windows.Forms.DockStyle.Top;
            this.TopPanel.Location = new System.Drawing.Point(0, 0);
            this.TopPanel.Name = "TopPanel";
            this.TopPanel.Size = new System.Drawing.Size(355, 52);
            this.TopPanel.TabIndex = 0;
            this.TopPanel.MouseDown += new System.Windows.Forms.MouseEventHandler(this.TopPanel_MouseDown);
            this.TopPanel.MouseMove += new System.Windows.Forms.MouseEventHandler(this.TopPanel_MouseMove);
            this.TopPanel.MouseUp += new System.Windows.Forms.MouseEventHandler(this.TopPanel_MouseUp);
            // 
            // WindowTextLabel
            // 
            this.WindowTextLabel.AutoSize = true;
            this.WindowTextLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.WindowTextLabel.ForeColor = System.Drawing.Color.White;
            this.WindowTextLabel.Location = new System.Drawing.Point(21, 14);
            this.WindowTextLabel.Name = "WindowTextLabel";
            this.WindowTextLabel.Size = new System.Drawing.Size(80, 20);
            this.WindowTextLabel.TabIndex = 4;
            this.WindowTextLabel.Text = "MainForm";
            this.WindowTextLabel.MouseDown += new System.Windows.Forms.MouseEventHandler(this.WindowTextLabel_MouseDown);
            this.WindowTextLabel.MouseMove += new System.Windows.Forms.MouseEventHandler(this.WindowTextLabel_MouseMove);
            this.WindowTextLabel.MouseUp += new System.Windows.Forms.MouseEventHandler(this.WindowTextLabel_MouseUp);
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(10)))), ((int)(((byte)(100)))), ((int)(((byte)(60)))));
            this.panel1.Dock = System.Windows.Forms.DockStyle.Right;
            this.panel1.Location = new System.Drawing.Point(343, 52);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(12, 375);
            this.panel1.TabIndex = 1;
            // 
            // panel2
            // 
            this.panel2.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(10)))), ((int)(((byte)(100)))), ((int)(((byte)(60)))));
            this.panel2.Dock = System.Windows.Forms.DockStyle.Left;
            this.panel2.Location = new System.Drawing.Point(0, 52);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(12, 375);
            this.panel2.TabIndex = 2;
            // 
            // panel3
            // 
            this.panel3.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(10)))), ((int)(((byte)(100)))), ((int)(((byte)(60)))));
            this.panel3.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panel3.Location = new System.Drawing.Point(12, 415);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(331, 12);
            this.panel3.TabIndex = 3;
            // 
            // buttonZ1
            // 
            this.buttonZ1.BZBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(10)))), ((int)(((byte)(100)))), ((int)(((byte)(60)))));
            this.buttonZ1.DisplayText = "Exit";
            this.buttonZ1.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.buttonZ1.Font = new System.Drawing.Font("Microsoft YaHei UI", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonZ1.ForeColor = System.Drawing.Color.White;
            this.buttonZ1.Location = new System.Drawing.Point(227, 367);
            this.buttonZ1.MouseClickColor1 = System.Drawing.Color.FromArgb(((int)(((byte)(100)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))));
            this.buttonZ1.MouseHoverColor = System.Drawing.Color.FromArgb(((int)(((byte)(180)))), ((int)(((byte)(30)))), ((int)(((byte)(40)))));
            this.buttonZ1.Name = "buttonZ1";
            this.buttonZ1.Size = new System.Drawing.Size(93, 29);
            this.buttonZ1.TabIndex = 7;
            this.buttonZ1.Text = "Exit";
            this.buttonZ1.TextLocation_X = 26;
            this.buttonZ1.TextLocation_Y = 3;
            this.buttonZ1.UseVisualStyleBackColor = true;
            this.buttonZ1.Click += new System.EventHandler(this.buttonZ1_Click);
            // 
            // shapedButton3
            // 
            this.shapedButton3.BackColor = System.Drawing.Color.Transparent;
            this.shapedButton3.BorderColor = System.Drawing.Color.Transparent;
            this.shapedButton3.BorderWidth = 2;
            this.shapedButton3.ButtonShape = CustomWindowsForm.ShapedButton.ButtonsShapes.RoundRect;
            this.shapedButton3.ButtonText = "Dashboard UI Form";
            this.shapedButton3.EndColor = System.Drawing.Color.FromArgb(((int)(((byte)(80)))), ((int)(((byte)(20)))), ((int)(((byte)(40)))));
            this.shapedButton3.FlatAppearance.BorderSize = 0;
            this.shapedButton3.FlatAppearance.MouseDownBackColor = System.Drawing.Color.Transparent;
            this.shapedButton3.FlatAppearance.MouseOverBackColor = System.Drawing.Color.Transparent;
            this.shapedButton3.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.shapedButton3.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.shapedButton3.ForeColor = System.Drawing.Color.White;
            this.shapedButton3.GradientAngle = 90;
            this.shapedButton3.Location = new System.Drawing.Point(25, 269);
            this.shapedButton3.MouseClickColor1 = System.Drawing.Color.FromArgb(((int)(((byte)(20)))), ((int)(((byte)(20)))), ((int)(((byte)(40)))));
            this.shapedButton3.MouseClickColor2 = System.Drawing.Color.FromArgb(((int)(((byte)(10)))), ((int)(((byte)(100)))), ((int)(((byte)(60)))));
            this.shapedButton3.MouseHoverColor1 = System.Drawing.Color.FromArgb(((int)(((byte)(250)))), ((int)(((byte)(100)))), ((int)(((byte)(180)))));
            this.shapedButton3.MouseHoverColor2 = System.Drawing.Color.FromArgb(((int)(((byte)(100)))), ((int)(((byte)(40)))), ((int)(((byte)(60)))));
            this.shapedButton3.Name = "shapedButton3";
            this.shapedButton3.ShowButtontext = true;
            this.shapedButton3.Size = new System.Drawing.Size(312, 75);
            this.shapedButton3.StartColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(40)))), ((int)(((byte)(120)))));
            this.shapedButton3.TabIndex = 6;
            this.shapedButton3.Text = "Dashboard UI Form";
            this.shapedButton3.TextLocation_X = 90;
            this.shapedButton3.TextLocation_Y = 25;
            this.shapedButton3.Transparent1 = 250;
            this.shapedButton3.Transparent2 = 250;
            this.shapedButton3.UseVisualStyleBackColor = false;
            this.shapedButton3.Click += new System.EventHandler(this.shapedButton3_Click);
            // 
            // shapedButton2
            // 
            this.shapedButton2.BackColor = System.Drawing.Color.Transparent;
            this.shapedButton2.BorderColor = System.Drawing.Color.Transparent;
            this.shapedButton2.BorderWidth = 2;
            this.shapedButton2.ButtonShape = CustomWindowsForm.ShapedButton.ButtonsShapes.RoundRect;
            this.shapedButton2.ButtonText = "Dark Custom Form";
            this.shapedButton2.EndColor = System.Drawing.Color.FromArgb(((int)(((byte)(10)))), ((int)(((byte)(10)))), ((int)(((byte)(10)))));
            this.shapedButton2.FlatAppearance.BorderSize = 0;
            this.shapedButton2.FlatAppearance.MouseDownBackColor = System.Drawing.Color.Transparent;
            this.shapedButton2.FlatAppearance.MouseOverBackColor = System.Drawing.Color.Transparent;
            this.shapedButton2.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.shapedButton2.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.shapedButton2.ForeColor = System.Drawing.Color.White;
            this.shapedButton2.GradientAngle = 90;
            this.shapedButton2.Location = new System.Drawing.Point(25, 172);
            this.shapedButton2.MouseClickColor1 = System.Drawing.Color.FromArgb(((int)(((byte)(20)))), ((int)(((byte)(20)))), ((int)(((byte)(40)))));
            this.shapedButton2.MouseClickColor2 = System.Drawing.Color.FromArgb(((int)(((byte)(10)))), ((int)(((byte)(100)))), ((int)(((byte)(60)))));
            this.shapedButton2.MouseHoverColor1 = System.Drawing.Color.FromArgb(((int)(((byte)(150)))), ((int)(((byte)(150)))), ((int)(((byte)(150)))));
            this.shapedButton2.MouseHoverColor2 = System.Drawing.Color.FromArgb(((int)(((byte)(50)))), ((int)(((byte)(50)))), ((int)(((byte)(50)))));
            this.shapedButton2.Name = "shapedButton2";
            this.shapedButton2.ShowButtontext = true;
            this.shapedButton2.Size = new System.Drawing.Size(312, 75);
            this.shapedButton2.StartColor = System.Drawing.Color.FromArgb(((int)(((byte)(100)))), ((int)(((byte)(100)))), ((int)(((byte)(100)))));
            this.shapedButton2.TabIndex = 5;
            this.shapedButton2.Text = "shapedButton2";
            this.shapedButton2.TextLocation_X = 90;
            this.shapedButton2.TextLocation_Y = 25;
            this.shapedButton2.Transparent1 = 250;
            this.shapedButton2.Transparent2 = 250;
            this.shapedButton2.UseVisualStyleBackColor = false;
            this.shapedButton2.Click += new System.EventHandler(this.shapedButton2_Click);
            // 
            // shapedButton1
            // 
            this.shapedButton1.BackColor = System.Drawing.Color.Transparent;
            this.shapedButton1.BorderColor = System.Drawing.Color.Transparent;
            this.shapedButton1.BorderWidth = 2;
            this.shapedButton1.ButtonShape = CustomWindowsForm.ShapedButton.ButtonsShapes.RoundRect;
            this.shapedButton1.ButtonText = "Simple Blue Form";
            this.shapedButton1.EndColor = System.Drawing.Color.MidnightBlue;
            this.shapedButton1.FlatAppearance.BorderSize = 0;
            this.shapedButton1.FlatAppearance.MouseDownBackColor = System.Drawing.Color.Transparent;
            this.shapedButton1.FlatAppearance.MouseOverBackColor = System.Drawing.Color.Transparent;
            this.shapedButton1.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.shapedButton1.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.shapedButton1.ForeColor = System.Drawing.Color.White;
            this.shapedButton1.GradientAngle = 90;
            this.shapedButton1.Location = new System.Drawing.Point(25, 77);
            this.shapedButton1.MouseClickColor1 = System.Drawing.Color.FromArgb(((int)(((byte)(20)))), ((int)(((byte)(20)))), ((int)(((byte)(40)))));
            this.shapedButton1.MouseClickColor2 = System.Drawing.Color.FromArgb(((int)(((byte)(10)))), ((int)(((byte)(100)))), ((int)(((byte)(60)))));
            this.shapedButton1.MouseHoverColor1 = System.Drawing.Color.Turquoise;
            this.shapedButton1.MouseHoverColor2 = System.Drawing.Color.DarkSlateGray;
            this.shapedButton1.Name = "shapedButton1";
            this.shapedButton1.ShowButtontext = true;
            this.shapedButton1.Size = new System.Drawing.Size(312, 75);
            this.shapedButton1.StartColor = System.Drawing.Color.DodgerBlue;
            this.shapedButton1.TabIndex = 4;
            this.shapedButton1.Text = "Simple Blue Form";
            this.shapedButton1.TextLocation_X = 90;
            this.shapedButton1.TextLocation_Y = 26;
            this.shapedButton1.Transparent1 = 250;
            this.shapedButton1.Transparent2 = 250;
            this.shapedButton1.UseVisualStyleBackColor = false;
            this.shapedButton1.Click += new System.EventHandler(this.shapedButton1_Click);
            // 
            // _MinButton
            // 
            this._MinButton.BZBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(10)))), ((int)(((byte)(100)))), ((int)(((byte)(60)))));
            this._MinButton.DisplayText = "_";
            this._MinButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this._MinButton.Font = new System.Drawing.Font("Microsoft YaHei UI", 20.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this._MinButton.ForeColor = System.Drawing.Color.White;
            this._MinButton.Location = new System.Drawing.Point(289, 3);
            this._MinButton.MouseClickColor1 = System.Drawing.Color.FromArgb(((int)(((byte)(160)))), ((int)(((byte)(180)))), ((int)(((byte)(200)))));
            this._MinButton.MouseHoverColor = System.Drawing.Color.FromArgb(((int)(((byte)(10)))), ((int)(((byte)(80)))), ((int)(((byte)(40)))));
            this._MinButton.Name = "_MinButton";
            this._MinButton.Size = new System.Drawing.Size(31, 24);
            this._MinButton.TabIndex = 3;
            this._MinButton.Text = "_";
            this._MinButton.TextLocation_X = 6;
            this._MinButton.TextLocation_Y = -20;
            this._MinButton.UseVisualStyleBackColor = true;
            this._MinButton.Click += new System.EventHandler(this._MinButton_Click);
            // 
            // _CloseButton
            // 
            this._CloseButton.BZBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(10)))), ((int)(((byte)(100)))), ((int)(((byte)(60)))));
            this._CloseButton.DisplayText = "X";
            this._CloseButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this._CloseButton.Font = new System.Drawing.Font("Microsoft YaHei UI", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this._CloseButton.ForeColor = System.Drawing.Color.White;
            this._CloseButton.Location = new System.Drawing.Point(320, 3);
            this._CloseButton.MouseClickColor1 = System.Drawing.Color.FromArgb(((int)(((byte)(100)))), ((int)(((byte)(150)))), ((int)(((byte)(220)))));
            this._CloseButton.MouseHoverColor = System.Drawing.Color.FromArgb(((int)(((byte)(10)))), ((int)(((byte)(80)))), ((int)(((byte)(40)))));
            this._CloseButton.Name = "_CloseButton";
            this._CloseButton.Size = new System.Drawing.Size(31, 24);
            this._CloseButton.TabIndex = 2;
            this._CloseButton.Text = "X";
            this._CloseButton.TextLocation_X = 6;
            this._CloseButton.TextLocation_Y = -1;
            this._CloseButton.UseVisualStyleBackColor = true;
            this._CloseButton.Click += new System.EventHandler(this._CloseButton_Click);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(40)))), ((int)(((byte)(180)))), ((int)(((byte)(100)))));
            this.ClientSize = new System.Drawing.Size(355, 427);
            this.Controls.Add(this.buttonZ1);
            this.Controls.Add(this.shapedButton3);
            this.Controls.Add(this.shapedButton2);
            this.Controls.Add(this.shapedButton1);
            this.Controls.Add(this.panel3);
            this.Controls.Add(this.panel2);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.TopPanel);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "MainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "MainForm";
            this.TopPanel.ResumeLayout(false);
            this.TopPanel.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel TopPanel;
        private ButtonZ _MinButton;
        private ButtonZ _CloseButton;
        private System.Windows.Forms.Label WindowTextLabel;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Panel panel3;
        private ShapedButton shapedButton1;
        private ShapedButton shapedButton2;
        private ShapedButton shapedButton3;
        private ButtonZ buttonZ1;
    }
}