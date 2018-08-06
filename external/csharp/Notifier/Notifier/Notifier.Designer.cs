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
                if (timerResetEvent != null)
                    timerResetEvent.Close();
                
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
            this.noteContent = new System.Windows.Forms.Label();
            this.noteDate = new System.Windows.Forms.Label();
            this.icon = new System.Windows.Forms.PictureBox();
            this.buttonClose = new System.Windows.Forms.PictureBox();
            this.buttonMenu = new System.Windows.Forms.PictureBox();
            this.menu = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.closeAllToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.noteTitle = new System.Windows.Forms.Label();
            this.idLabel = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.icon)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.buttonClose)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.buttonMenu)).BeginInit();
            this.menu.SuspendLayout();
            this.SuspendLayout();
            // 
            // labelDesc
            // 
            this.noteContent.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.noteContent.Image = global::Notify.Properties.Resources.notifier;
            this.noteContent.Location = new System.Drawing.Point(43, 30);
            this.noteContent.Name = "labelDesc";
            this.noteContent.Size = new System.Drawing.Size(270, 73);
            this.noteContent.TabIndex = 3;
            this.noteContent.Text = "Description";
            this.noteContent.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // date
            // 
            this.noteDate.AutoSize = true;
            this.noteDate.Font = new System.Drawing.Font("Microsoft Sans Serif", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.noteDate.Image = global::Notify.Properties.Resources.notifier;
            this.noteDate.Location = new System.Drawing.Point(11, 103);
            this.noteDate.Name = "date";
            this.noteDate.Size = new System.Drawing.Size(13, 9);
            this.noteDate.TabIndex = 4;
            this.noteDate.Text = "- -";
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
            this.buttonClose.Location = new System.Drawing.Point(256, 2);
            this.buttonClose.Name = "buttonClose";
            this.buttonClose.Size = new System.Drawing.Size(66, 24);
            this.buttonClose.TabIndex = 1;
            this.buttonClose.TabStop = false;
            this.buttonClose.Text = " Calibrator";
            this.buttonClose.Click += new System.EventHandler(this.onCloseClick);
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
            this.buttonMenu.Click += new System.EventHandler(this.onMenuClick);
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
            this.closeAllToolStripMenuItem.Click += new System.EventHandler(this.onMenuCloseAllClick);
            // 
            // titleText
            // 
            this.noteTitle.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(90)))), ((int)(((byte)(140)))), ((int)(((byte)(230)))));
            this.noteTitle.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.noteTitle.ForeColor = System.Drawing.Color.White;
            this.noteTitle.Location = new System.Drawing.Point(2, 2);
            this.noteTitle.Name = "titleText";
            this.noteTitle.Size = new System.Drawing.Size(270, 24);
            this.noteTitle.TabIndex = 6;
            this.noteTitle.Text = "Note";
            this.noteTitle.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // idLabel
            // 
            this.idLabel.AutoSize = true;
            this.idLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 6F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.idLabel.Image = global::Notify.Properties.Resources.notifier;
            this.idLabel.Location = new System.Drawing.Point(296, 103);
            this.idLabel.Name = "idLabel";
            this.idLabel.Size = new System.Drawing.Size(21, 9);
            this.idLabel.TabIndex = 7;
            this.idLabel.Text = "0000";
            this.idLabel.Visible = false;
            // 
            // Notifier
            // 
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.None;
            this.BackColor = System.Drawing.Color.White;
            this.BackgroundImage = global::Notify.Properties.Resources.notifier;
            this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.ClientSize = new System.Drawing.Size(324, 117);
            this.Controls.Add(this.idLabel);
            this.Controls.Add(this.buttonMenu);
            this.Controls.Add(this.noteTitle);
            this.Controls.Add(this.noteDate);
            this.Controls.Add(this.noteContent);
            this.Controls.Add(this.icon);
            this.Controls.Add(this.buttonClose);
            this.DoubleBuffered = true;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "Notifier";
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Toast";
            this.TopMost = true;
            this.Load += new System.EventHandler(this.OnLoad);
            this.MouseDown += new System.Windows.Forms.MouseEventHandler(this.OnMouseDown);
            this.MouseMove += new System.Windows.Forms.MouseEventHandler(this.OnMouseMove);
            this.MouseUp += new System.Windows.Forms.MouseEventHandler(this.OnMouseUp);
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
        private System.Windows.Forms.Label noteContent;
        private System.Windows.Forms.Label noteDate;
        private System.Windows.Forms.ContextMenuStrip menu;
        private System.Windows.Forms.ToolStripMenuItem closeAllToolStripMenuItem;
        private System.Windows.Forms.Label noteTitle;
        private System.Windows.Forms.Label idLabel;
    }
}