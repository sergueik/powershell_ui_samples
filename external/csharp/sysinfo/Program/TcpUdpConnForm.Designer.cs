namespace SYSInfo
{
    partial class TcpUdpForm
    {
        /// <summary>
        /// Erforderliche Designervariable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Verwendete Ressourcen bereinigen.
        /// </summary>
        /// <param name="disposing">True, wenn verwaltete Ressourcen gelöscht werden sollen; andernfalls False.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Vom Windows Form-Designer generierter Code

        /// <summary>
        /// Erforderliche Methode für die Designerunterstützung.
        /// Der Inhalt der Methode darf nicht mit dem Code-Editor geändert werden.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.refreshToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.checkBox1 = new System.Windows.Forms.CheckBox();
            this.dataGrid1 = new System.Windows.Forms.DataGrid();
            this.contextMenuStrip1 = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.traceRouteToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.whoisToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.terminateToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.closeRemotePortToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.closeRemoteConnectionToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.contextMenuStrip2 = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.killProcessToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.contextMenuStrip3 = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.terminateToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.closeLocalPortToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.closeLocalConnectionToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.traceRouteresolveIPSlowToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.menuStrip1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGrid1)).BeginInit();
            this.contextMenuStrip1.SuspendLayout();
            this.contextMenuStrip2.SuspendLayout();
            this.contextMenuStrip3.SuspendLayout();
            this.SuspendLayout();
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.refreshToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(606, 24);
            this.menuStrip1.TabIndex = 3;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // refreshToolStripMenuItem
            // 
            this.refreshToolStripMenuItem.Name = "refreshToolStripMenuItem";
            this.refreshToolStripMenuItem.Size = new System.Drawing.Size(55, 20);
            this.refreshToolStripMenuItem.Text = "refresh";
            this.refreshToolStripMenuItem.Click += new System.EventHandler(this.refreshToolStripMenuItem_Click);
            // 
            // checkBox1
            // 
            this.checkBox1.AutoSize = true;
            this.checkBox1.Location = new System.Drawing.Point(71, 4);
            this.checkBox1.Name = "checkBox1";
            this.checkBox1.Size = new System.Drawing.Size(239, 17);
            this.checkBox1.TabIndex = 4;
            this.checkBox1.Text = "resolve remote-addresses (may be very slow!)";
            this.checkBox1.UseVisualStyleBackColor = true;
            this.checkBox1.CheckedChanged += new System.EventHandler(this.checkBox1_CheckedChanged);
            // 
            // dataGrid1
            // 
            this.dataGrid1.CaptionVisible = false;
            this.dataGrid1.DataMember = "";
            this.dataGrid1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dataGrid1.HeaderForeColor = System.Drawing.SystemColors.ControlText;
            this.dataGrid1.Location = new System.Drawing.Point(0, 24);
            this.dataGrid1.Name = "dataGrid1";
            this.dataGrid1.ParentRowsVisible = false;
            this.dataGrid1.PreferredColumnWidth = 90;
            this.dataGrid1.RowHeadersVisible = false;
            this.dataGrid1.RowHeaderWidth = 30;
            this.dataGrid1.Size = new System.Drawing.Size(606, 455);
            this.dataGrid1.TabIndex = 5;
            this.dataGrid1.MouseUp += new System.Windows.Forms.MouseEventHandler(this.dataGrid1_MouseUp);
            // 
            // contextMenuStrip1
            // 
            this.contextMenuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.traceRouteToolStripMenuItem,
            this.traceRouteresolveIPSlowToolStripMenuItem,
            this.whoisToolStripMenuItem,
            this.terminateToolStripMenuItem});
            this.contextMenuStrip1.Name = "contextMenuStrip1";
            this.contextMenuStrip1.Size = new System.Drawing.Size(236, 114);
            // 
            // traceRouteToolStripMenuItem
            // 
            this.traceRouteToolStripMenuItem.Name = "traceRouteToolStripMenuItem";
            this.traceRouteToolStripMenuItem.Size = new System.Drawing.Size(235, 22);
            this.traceRouteToolStripMenuItem.Text = "trace route";
            this.traceRouteToolStripMenuItem.Click += new System.EventHandler(this.traceRouteToolStripMenuItem_Click);
            // 
            // whoisToolStripMenuItem
            // 
            this.whoisToolStripMenuItem.Name = "whoisToolStripMenuItem";
            this.whoisToolStripMenuItem.Size = new System.Drawing.Size(235, 22);
            this.whoisToolStripMenuItem.Text = "whois";
            this.whoisToolStripMenuItem.Click += new System.EventHandler(this.whoisToolStripMenuItem_Click);
            // 
            // terminateToolStripMenuItem
            // 
            this.terminateToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.closeRemotePortToolStripMenuItem1,
            this.closeRemoteConnectionToolStripMenuItem});
            this.terminateToolStripMenuItem.Name = "terminateToolStripMenuItem";
            this.terminateToolStripMenuItem.Size = new System.Drawing.Size(235, 22);
            this.terminateToolStripMenuItem.Text = "terminate";
            // 
            // closeRemotePortToolStripMenuItem1
            // 
            this.closeRemotePortToolStripMenuItem1.Name = "closeRemotePortToolStripMenuItem1";
            this.closeRemotePortToolStripMenuItem1.Size = new System.Drawing.Size(205, 22);
            this.closeRemotePortToolStripMenuItem1.Text = "close remote port";
            this.closeRemotePortToolStripMenuItem1.Click += new System.EventHandler(this.closeRemotePortToolStripMenuItem_Click);
            // 
            // closeRemoteConnectionToolStripMenuItem
            // 
            this.closeRemoteConnectionToolStripMenuItem.Name = "closeRemoteConnectionToolStripMenuItem";
            this.closeRemoteConnectionToolStripMenuItem.Size = new System.Drawing.Size(205, 22);
            this.closeRemoteConnectionToolStripMenuItem.Text = "close remote connection";
            this.closeRemoteConnectionToolStripMenuItem.Click += new System.EventHandler(this.closeRemoteConnectionToolStripMenuItem_Click);
            // 
            // contextMenuStrip2
            // 
            this.contextMenuStrip2.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.killProcessToolStripMenuItem});
            this.contextMenuStrip2.Name = "contextMenuStrip2";
            this.contextMenuStrip2.Size = new System.Drawing.Size(133, 26);
            // 
            // killProcessToolStripMenuItem
            // 
            this.killProcessToolStripMenuItem.Name = "killProcessToolStripMenuItem";
            this.killProcessToolStripMenuItem.Size = new System.Drawing.Size(132, 22);
            this.killProcessToolStripMenuItem.Text = "kill process";
            this.killProcessToolStripMenuItem.Click += new System.EventHandler(this.killProcessToolStripMenuItem_Click);
            // 
            // contextMenuStrip3
            // 
            this.contextMenuStrip3.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.terminateToolStripMenuItem1});
            this.contextMenuStrip3.Name = "contextMenuStrip1";
            this.contextMenuStrip3.Size = new System.Drawing.Size(126, 26);
            // 
            // terminateToolStripMenuItem1
            // 
            this.terminateToolStripMenuItem1.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.closeLocalPortToolStripMenuItem,
            this.closeLocalConnectionToolStripMenuItem});
            this.terminateToolStripMenuItem1.Name = "terminateToolStripMenuItem1";
            this.terminateToolStripMenuItem1.Size = new System.Drawing.Size(125, 22);
            this.terminateToolStripMenuItem1.Text = "terminate";
            // 
            // closeLocalPortToolStripMenuItem
            // 
            this.closeLocalPortToolStripMenuItem.Name = "closeLocalPortToolStripMenuItem";
            this.closeLocalPortToolStripMenuItem.Size = new System.Drawing.Size(192, 22);
            this.closeLocalPortToolStripMenuItem.Text = "close local port";
            this.closeLocalPortToolStripMenuItem.Click += new System.EventHandler(this.closeLocalPortToolStripMenuItem_Click);
            // 
            // closeLocalConnectionToolStripMenuItem
            // 
            this.closeLocalConnectionToolStripMenuItem.Name = "closeLocalConnectionToolStripMenuItem";
            this.closeLocalConnectionToolStripMenuItem.Size = new System.Drawing.Size(192, 22);
            this.closeLocalConnectionToolStripMenuItem.Text = "close local connection";
            this.closeLocalConnectionToolStripMenuItem.Click += new System.EventHandler(this.closeLocalConnectionToolStripMenuItem_Click);
            // 
            // traceRouteresolveIPSlowToolStripMenuItem
            // 
            this.traceRouteresolveIPSlowToolStripMenuItem.Name = "traceRouteresolveIPSlowToolStripMenuItem";
            this.traceRouteresolveIPSlowToolStripMenuItem.Size = new System.Drawing.Size(235, 22);
            this.traceRouteresolveIPSlowToolStripMenuItem.Text = "trace route (resolve IP -- slow!)";
            this.traceRouteresolveIPSlowToolStripMenuItem.Click += new System.EventHandler(this.traceRouteResolveToolStripMenuItem_Click);
            // 
            // TcpUdpForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.ClientSize = new System.Drawing.Size(606, 479);
            this.Controls.Add(this.dataGrid1);
            this.Controls.Add(this.checkBox1);
            this.Controls.Add(this.menuStrip1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.SizableToolWindow;
            this.MainMenuStrip = this.menuStrip1;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "TcpUdpForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Text = "TCP UDP Connections";
            this.TopMost = true;
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.TcpUdpForm_FormClosing);
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGrid1)).EndInit();
            this.contextMenuStrip1.ResumeLayout(false);
            this.contextMenuStrip2.ResumeLayout(false);
            this.contextMenuStrip3.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem refreshToolStripMenuItem;
        private System.Windows.Forms.CheckBox checkBox1;
        private System.Windows.Forms.DataGrid dataGrid1;
        private System.Windows.Forms.ContextMenuStrip contextMenuStrip1;
        private System.Windows.Forms.ToolStripMenuItem traceRouteToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem whoisToolStripMenuItem;
        private System.Windows.Forms.ContextMenuStrip contextMenuStrip2;
        private System.Windows.Forms.ToolStripMenuItem killProcessToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem terminateToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem closeRemotePortToolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem closeRemoteConnectionToolStripMenuItem;
        private System.Windows.Forms.ContextMenuStrip contextMenuStrip3;
        private System.Windows.Forms.ToolStripMenuItem terminateToolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem closeLocalPortToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem closeLocalConnectionToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem traceRouteresolveIPSlowToolStripMenuItem;
    }
}