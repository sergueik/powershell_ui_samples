namespace Notify
{
    partial class Notifier
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
            this.components = new System.ComponentModel.Container();
            this.labelDesc = new System.Windows.Forms.Label();
            this.date = new System.Windows.Forms.Label();
            this.icon = new System.Windows.Forms.PictureBox();
            this.buttonClose = new System.Windows.Forms.PictureBox();
            this.buttonMenu = new System.Windows.Forms.PictureBox();
            this.menu = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.closeAllToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.titleText = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.icon)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.buttonClose)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.buttonMenu)).BeginInit();
            this.menu.SuspendLayout();
            this.SuspendLayout();
            // 
            // labelDesc
            // 
            this.labelDesc.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelDesc.Image = global::Notify.Properties.Resources.notifier;
            this.labelDesc.Location = new System.Drawing.Point(42, 30);
            this.labelDesc.Name = "labelDesc";
            this.labelDesc.Size = new System.Drawing.Size(270, 73);
            this.labelDesc.TabIndex = 3;
            this.labelDesc.Text = "Description";
            this.labelDesc.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // date
            // 
            this.date.AutoSize = true;
            this.date.Font = new System.Drawing.Font("Microsoft Sans Serif", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.date.Image = global::Notify.Properties.Resources.notifier;
            this.date.Location = new System.Drawing.Point(43, 103);
            this.date.Name = "date";
            this.date.Size = new System.Drawing.Size(19, 9);
            this.date.TabIndex = 4;
            this.date.Text = "date";
            // 
            // icon
            // 
            this.icon.BackgroundImage = global::Notify.Properties.Resources.img_notifier;
            this.icon.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.icon.Image = global::Notify.Properties.Resources.info;
            this.icon.Location = new System.Drawing.Point(12, 54);
            this.icon.Name = "icon";
            this.icon.Size = new System.Drawing.Size(24, 24);
            this.icon.TabIndex = 2;
            this.icon.TabStop = false;
            // 
            // buttonClose
            // 
            this.buttonClose.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(90)))), ((int)(((byte)(140)))), ((int)(((byte)(230)))));
            this.buttonClose.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Center;
            this.buttonClose.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonClose.ForeColor = System.Drawing.Color.White;
            this.buttonClose.Location = new System.Drawing.Point(2, 2);
            this.buttonClose.Name = "buttonClose";
            this.buttonClose.Size = new System.Drawing.Size(320, 24);
            this.buttonClose.TabIndex = 1;
            this.buttonClose.TabStop = false;
            this.buttonClose.Text = " Calibrator";
            this.buttonClose.Click += new System.EventHandler(this.buttonClose_Click);
            this.buttonClose.Paint += new System.Windows.Forms.PaintEventHandler(this.OnPaint);
            // 
            // buttonMenu
            // 
            this.buttonMenu.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(90)))), ((int)(((byte)(140)))), ((int)(((byte)(230)))));
            this.buttonMenu.BackgroundImage = global::Notify.Properties.Resources.menu;
            this.buttonMenu.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Center;
            this.buttonMenu.ContextMenuStrip = this.menu;
            this.buttonMenu.Location = new System.Drawing.Point(275, 2);
            this.buttonMenu.Name = "buttonMenu";
            this.buttonMenu.Size = new System.Drawing.Size(24, 24);
            this.buttonMenu.TabIndex = 5;
            this.buttonMenu.TabStop = false;
            this.buttonMenu.Click += new System.EventHandler(this.buttonMenu_Click);
            // 
            // menu
            // 
            this.menu.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.closeAllToolStripMenuItem});
            this.menu.Name = "menu";
            this.menu.Size = new System.Drawing.Size(119, 26);
            // 
            // closeAllToolStripMenuItem
            // 
            this.closeAllToolStripMenuItem.Font = new System.Drawing.Font("Segoe UI", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.closeAllToolStripMenuItem.Name = "closeAllToolStripMenuItem";
            this.closeAllToolStripMenuItem.Size = new System.Drawing.Size(118, 22);
            this.closeAllToolStripMenuItem.Text = "Close All";
            this.closeAllToolStripMenuItem.Click += new System.EventHandler(this.closeAllToolStripMenuItem_Click);
            // 
            // titleText
            // 
            this.titleText.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(90)))), ((int)(((byte)(140)))), ((int)(((byte)(230)))));
            this.titleText.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.titleText.ForeColor = System.Drawing.Color.White;
            this.titleText.Location = new System.Drawing.Point(2, 2);
            this.titleText.Name = "titleText";
            this.titleText.Size = new System.Drawing.Size(297, 24);
            this.titleText.TabIndex = 6;
            this.titleText.Text = "Toast";
            this.titleText.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.titleText.MouseDown += new System.Windows.Forms.MouseEventHandler(this.OnMouseDown);
            this.titleText.MouseMove += new System.Windows.Forms.MouseEventHandler(this.OnMouseMove);
            this.titleText.MouseUp += new System.Windows.Forms.MouseEventHandler(this.OnMouseUp);
            // 
            // Toast
            // 
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.None;
            this.BackColor = System.Drawing.Color.White;
            this.BackgroundImage = global::Notify.Properties.Resources.notifier;
            this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.ClientSize = new System.Drawing.Size(324, 117);
            this.Controls.Add(this.buttonMenu);
            this.Controls.Add(this.titleText);
            this.Controls.Add(this.date);
            this.Controls.Add(this.labelDesc);
            this.Controls.Add(this.icon);
            this.Controls.Add(this.buttonClose);
            this.DoubleBuffered = true;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "Toast";
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Toast";
            this.TopMost = true;
            this.Load += new System.EventHandler(this.OnLoad);
            ((System.ComponentModel.ISupportInitialize)(this.icon)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.buttonClose)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.buttonMenu)).EndInit();
            this.menu.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.PictureBox buttonClose;
        private System.Windows.Forms.PictureBox buttonMenu;
        private System.Windows.Forms.PictureBox icon;
        private System.Windows.Forms.Label labelDesc;
        private System.Windows.Forms.Label date;
        private System.Windows.Forms.ContextMenuStrip menu;
        private System.Windows.Forms.ToolStripMenuItem closeAllToolStripMenuItem;
        private System.Windows.Forms.Label titleText;
    }
}