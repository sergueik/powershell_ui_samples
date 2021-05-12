namespace SYSInfo
{
    partial class Form1
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.contextMenuStrip1 = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.aktualisierenToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.einstellungenToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.SettingsChangeToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.SettingsDelToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.saveToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.spracheToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.englishToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.germanToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.borderTS = new System.Windows.Forms.ToolStripMenuItem();
            this.thinBorderTS = new System.Windows.Forms.ToolStripMenuItem();
            this.thickBorderTS = new System.Windows.Forms.ToolStripMenuItem();
            this.aeroSpecialabVistaToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.hintergrundToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.transparentToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.aeroEffektabVistaToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.gradientToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.textureToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.lockedToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.hideToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.beendenToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.label19 = new System.Windows.Forms.Label();
            this.label18 = new System.Windows.Forms.Label();
            this.label17 = new System.Windows.Forms.Label();
            this.label16 = new System.Windows.Forms.Label();
            this.label15 = new System.Windows.Forms.Label();
            this.label14 = new System.Windows.Forms.Label();
            this.label13 = new System.Windows.Forms.Label();
            this.label12 = new System.Windows.Forms.Label();
            this.label11 = new System.Windows.Forms.Label();
            this.label10 = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.label0 = new System.Windows.Forms.Label();
            this.pPBar = new System.Windows.Forms.Panel();
            this.panel1 = new System.Windows.Forms.Panel();
            this.pCPUPanel = new System.Windows.Forms.Panel();
            this.imageList1 = new System.Windows.Forms.ImageList(this.components);
            this.toolTip1 = new System.Windows.Forms.ToolTip(this.components);
            this.notifyIcon1 = new System.Windows.Forms.NotifyIcon(this.components);
            this.contextMenuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // timer1
            // 
            this.timer1.Interval = 10000;
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // contextMenuStrip1
            // 
            this.contextMenuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.aktualisierenToolStripMenuItem1,
            this.einstellungenToolStripMenuItem1,
            this.spracheToolStripMenuItem,
            this.borderTS,
            this.hintergrundToolStripMenuItem,
            this.lockedToolStripMenuItem,
            this.hideToolStripMenuItem,
            this.beendenToolStripMenuItem});
            this.contextMenuStrip1.Name = "contextMenuStrip1";
            resources.ApplyResources(this.contextMenuStrip1, "contextMenuStrip1");
            this.contextMenuStrip1.Opening += new System.ComponentModel.CancelEventHandler(this.contextMenuStrip1_Opening);
            // 
            // aktualisierenToolStripMenuItem1
            // 
            this.aktualisierenToolStripMenuItem1.Name = "aktualisierenToolStripMenuItem1";
            resources.ApplyResources(this.aktualisierenToolStripMenuItem1, "aktualisierenToolStripMenuItem1");
            this.aktualisierenToolStripMenuItem1.Click += new System.EventHandler(this.updateToolStripMenuItem_Click);
            // 
            // einstellungenToolStripMenuItem1
            // 
            this.einstellungenToolStripMenuItem1.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.SettingsChangeToolStripMenuItem,
            this.SettingsDelToolStripMenuItem,
            this.saveToolStripMenuItem});
            this.einstellungenToolStripMenuItem1.Name = "einstellungenToolStripMenuItem1";
            resources.ApplyResources(this.einstellungenToolStripMenuItem1, "einstellungenToolStripMenuItem1");
            this.einstellungenToolStripMenuItem1.DoubleClick += new System.EventHandler(this.settingsToolStripMenuItem_Click);
            // 
            // SettingsChangeToolStripMenuItem
            // 
            this.SettingsChangeToolStripMenuItem.Name = "SettingsChangeToolStripMenuItem";
            resources.ApplyResources(this.SettingsChangeToolStripMenuItem, "SettingsChangeToolStripMenuItem");
            this.SettingsChangeToolStripMenuItem.Click += new System.EventHandler(this.settingsToolStripMenuItem_Click);
            // 
            // SettingsDelToolStripMenuItem
            // 
            this.SettingsDelToolStripMenuItem.Name = "SettingsDelToolStripMenuItem";
            resources.ApplyResources(this.SettingsDelToolStripMenuItem, "SettingsDelToolStripMenuItem");
            this.SettingsDelToolStripMenuItem.Click += new System.EventHandler(this.SettingsDelToolStripMenuItem_Click);
            // 
            // saveToolStripMenuItem
            // 
            this.saveToolStripMenuItem.Name = "saveToolStripMenuItem";
            resources.ApplyResources(this.saveToolStripMenuItem, "saveToolStripMenuItem");
            this.saveToolStripMenuItem.Click += new System.EventHandler(this.saveToolStripMenuItem_Click);
            // 
            // spracheToolStripMenuItem
            // 
            this.spracheToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.englishToolStripMenuItem,
            this.germanToolStripMenuItem});
            this.spracheToolStripMenuItem.Name = "spracheToolStripMenuItem";
            resources.ApplyResources(this.spracheToolStripMenuItem, "spracheToolStripMenuItem");
            // 
            // englishToolStripMenuItem
            // 
            this.englishToolStripMenuItem.Name = "englishToolStripMenuItem";
            resources.ApplyResources(this.englishToolStripMenuItem, "englishToolStripMenuItem");
            this.englishToolStripMenuItem.Click += new System.EventHandler(this.englishToolStripMenuItem_Click);
            // 
            // germanToolStripMenuItem
            // 
            this.germanToolStripMenuItem.Name = "germanToolStripMenuItem";
            resources.ApplyResources(this.germanToolStripMenuItem, "germanToolStripMenuItem");
            this.germanToolStripMenuItem.Click += new System.EventHandler(this.germanToolStripMenuItem_Click);
            // 
            // borderTS
            // 
            this.borderTS.CheckOnClick = true;
            this.borderTS.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.thinBorderTS,
            this.thickBorderTS,
            this.aeroSpecialabVistaToolStripMenuItem});
            this.borderTS.Name = "borderTS";
            resources.ApplyResources(this.borderTS, "borderTS");
            this.borderTS.Click += new System.EventHandler(this.borderToolStripMenuItem_Click);
            // 
            // thinBorderTS
            // 
            this.thinBorderTS.CheckOnClick = true;
            this.thinBorderTS.Name = "thinBorderTS";
            resources.ApplyResources(this.thinBorderTS, "thinBorderTS");
            this.thinBorderTS.Click += new System.EventHandler(this.thinBorderTS_Click);
            // 
            // thickBorderTS
            // 
            this.thickBorderTS.CheckOnClick = true;
            this.thickBorderTS.Name = "thickBorderTS";
            resources.ApplyResources(this.thickBorderTS, "thickBorderTS");
            this.thickBorderTS.Click += new System.EventHandler(this.thickBorderTS_Click);
            // 
            // aeroSpecialabVistaToolStripMenuItem
            // 
            this.aeroSpecialabVistaToolStripMenuItem.CheckOnClick = true;
            this.aeroSpecialabVistaToolStripMenuItem.Name = "aeroSpecialabVistaToolStripMenuItem";
            resources.ApplyResources(this.aeroSpecialabVistaToolStripMenuItem, "aeroSpecialabVistaToolStripMenuItem");
            this.aeroSpecialabVistaToolStripMenuItem.Click += new System.EventHandler(this.aeroSpecialabVistaToolStripMenuItem_Click);
            // 
            // hintergrundToolStripMenuItem
            // 
            this.hintergrundToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.transparentToolStripMenuItem,
            this.aeroEffektabVistaToolStripMenuItem,
            this.gradientToolStripMenuItem,
            this.textureToolStripMenuItem});
            this.hintergrundToolStripMenuItem.Name = "hintergrundToolStripMenuItem";
            resources.ApplyResources(this.hintergrundToolStripMenuItem, "hintergrundToolStripMenuItem");
            // 
            // transparentToolStripMenuItem
            // 
            this.transparentToolStripMenuItem.CheckOnClick = true;
            this.transparentToolStripMenuItem.Name = "transparentToolStripMenuItem";
            resources.ApplyResources(this.transparentToolStripMenuItem, "transparentToolStripMenuItem");
            this.transparentToolStripMenuItem.Click += new System.EventHandler(this.transparentToolStripMenuItem_Click);
            // 
            // aeroEffektabVistaToolStripMenuItem
            // 
            this.aeroEffektabVistaToolStripMenuItem.CheckOnClick = true;
            this.aeroEffektabVistaToolStripMenuItem.Name = "aeroEffektabVistaToolStripMenuItem";
            resources.ApplyResources(this.aeroEffektabVistaToolStripMenuItem, "aeroEffektabVistaToolStripMenuItem");
            this.aeroEffektabVistaToolStripMenuItem.Click += new System.EventHandler(this.aeroEffektabVistaToolStripMenuItem_Click);
            // 
            // gradientToolStripMenuItem
            // 
            this.gradientToolStripMenuItem.CheckOnClick = true;
            this.gradientToolStripMenuItem.Name = "gradientToolStripMenuItem";
            resources.ApplyResources(this.gradientToolStripMenuItem, "gradientToolStripMenuItem");
            this.gradientToolStripMenuItem.Click += new System.EventHandler(this.gradientToolStripMenuItem_Click);
            // 
            // textureToolStripMenuItem
            // 
            this.textureToolStripMenuItem.CheckOnClick = true;
            this.textureToolStripMenuItem.Name = "textureToolStripMenuItem";
            resources.ApplyResources(this.textureToolStripMenuItem, "textureToolStripMenuItem");
            this.textureToolStripMenuItem.Click += new System.EventHandler(this.textureToolStripMenuItem_Click);
            // 
            // lockedToolStripMenuItem
            // 
            this.lockedToolStripMenuItem.CheckOnClick = true;
            this.lockedToolStripMenuItem.Name = "lockedToolStripMenuItem";
            resources.ApplyResources(this.lockedToolStripMenuItem, "lockedToolStripMenuItem");
            this.lockedToolStripMenuItem.Click += new System.EventHandler(this.lockedToolStripMenuItem_Click);
            // 
            // hideToolStripMenuItem
            // 
            this.hideToolStripMenuItem.Name = "hideToolStripMenuItem";
            resources.ApplyResources(this.hideToolStripMenuItem, "hideToolStripMenuItem");
            this.hideToolStripMenuItem.Click += new System.EventHandler(this.hideToolStripMenuItem_Click);
            // 
            // beendenToolStripMenuItem
            // 
            this.beendenToolStripMenuItem.Name = "beendenToolStripMenuItem";
            resources.ApplyResources(this.beendenToolStripMenuItem, "beendenToolStripMenuItem");
            this.beendenToolStripMenuItem.Click += new System.EventHandler(this.exitToolStripMenuItem_Click);
            // 
            // label19
            // 
            resources.ApplyResources(this.label19, "label19");
            this.label19.BackColor = System.Drawing.Color.Transparent;
            this.label19.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label19.Name = "label19";
            this.label19.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label19.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label19.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label19.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label19.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // label18
            // 
            resources.ApplyResources(this.label18, "label18");
            this.label18.BackColor = System.Drawing.Color.Transparent;
            this.label18.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label18.Name = "label18";
            this.label18.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label18.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label18.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label18.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label18.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // label17
            // 
            resources.ApplyResources(this.label17, "label17");
            this.label17.BackColor = System.Drawing.Color.Transparent;
            this.label17.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label17.Name = "label17";
            this.label17.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label17.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label17.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label17.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label17.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // label16
            // 
            resources.ApplyResources(this.label16, "label16");
            this.label16.BackColor = System.Drawing.Color.Transparent;
            this.label16.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label16.Name = "label16";
            this.label16.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label16.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label16.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label16.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label16.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // label15
            // 
            resources.ApplyResources(this.label15, "label15");
            this.label15.BackColor = System.Drawing.Color.Transparent;
            this.label15.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label15.Name = "label15";
            this.label15.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label15.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label15.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label15.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label15.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // label14
            // 
            resources.ApplyResources(this.label14, "label14");
            this.label14.BackColor = System.Drawing.Color.Transparent;
            this.label14.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label14.Name = "label14";
            this.label14.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label14.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label14.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label14.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label14.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // label13
            // 
            resources.ApplyResources(this.label13, "label13");
            this.label13.BackColor = System.Drawing.Color.Transparent;
            this.label13.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label13.Name = "label13";
            this.label13.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label13.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label13.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label13.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label13.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // label12
            // 
            resources.ApplyResources(this.label12, "label12");
            this.label12.BackColor = System.Drawing.Color.Transparent;
            this.label12.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label12.Name = "label12";
            this.label12.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label12.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label12.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label12.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label12.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // label11
            // 
            resources.ApplyResources(this.label11, "label11");
            this.label11.BackColor = System.Drawing.Color.Transparent;
            this.label11.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label11.Name = "label11";
            this.label11.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label11.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label11.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label11.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label11.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // label10
            // 
            resources.ApplyResources(this.label10, "label10");
            this.label10.BackColor = System.Drawing.Color.Transparent;
            this.label10.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label10.Name = "label10";
            this.label10.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label10.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label10.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label10.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label10.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // label9
            // 
            resources.ApplyResources(this.label9, "label9");
            this.label9.BackColor = System.Drawing.Color.Transparent;
            this.label9.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label9.Name = "label9";
            this.label9.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label9.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label9.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label9.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label9.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // label8
            // 
            resources.ApplyResources(this.label8, "label8");
            this.label8.BackColor = System.Drawing.Color.Transparent;
            this.label8.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label8.Name = "label8";
            this.label8.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label8.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label8.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label8.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label8.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // label7
            // 
            resources.ApplyResources(this.label7, "label7");
            this.label7.BackColor = System.Drawing.Color.Transparent;
            this.label7.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label7.Name = "label7";
            this.label7.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label7.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label7.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label7.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label7.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // label6
            // 
            resources.ApplyResources(this.label6, "label6");
            this.label6.BackColor = System.Drawing.Color.Transparent;
            this.label6.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label6.Name = "label6";
            this.label6.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label6.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label6.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label6.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label6.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // label5
            // 
            resources.ApplyResources(this.label5, "label5");
            this.label5.BackColor = System.Drawing.Color.Transparent;
            this.label5.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label5.Name = "label5";
            this.label5.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label5.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label5.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label5.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label5.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // label4
            // 
            resources.ApplyResources(this.label4, "label4");
            this.label4.BackColor = System.Drawing.Color.Transparent;
            this.label4.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label4.Name = "label4";
            this.label4.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label4.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label4.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label4.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label4.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // label3
            // 
            resources.ApplyResources(this.label3, "label3");
            this.label3.BackColor = System.Drawing.Color.Transparent;
            this.label3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label3.Name = "label3";
            this.label3.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label3.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label3.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label3.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label3.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // label2
            // 
            resources.ApplyResources(this.label2, "label2");
            this.label2.BackColor = System.Drawing.Color.Transparent;
            this.label2.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label2.Name = "label2";
            this.label2.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label2.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label2.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label2.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label2.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // label1
            // 
            resources.ApplyResources(this.label1, "label1");
            this.label1.BackColor = System.Drawing.Color.Transparent;
            this.label1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label1.Name = "label1";
            this.label1.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label1.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label1.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label1.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label1.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // label0
            // 
            resources.ApplyResources(this.label0, "label0");
            this.label0.BackColor = System.Drawing.Color.Transparent;
            this.label0.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(255)))));
            this.label0.Name = "label0";
            this.label0.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            this.label0.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.label0.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.label0.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.label0.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // pPBar
            // 
            resources.ApplyResources(this.pPBar, "pPBar");
            this.pPBar.BackColor = System.Drawing.Color.Transparent;
            this.pPBar.Name = "pPBar";
            this.pPBar.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.pPBar.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.pPBar.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            // 
            // panel1
            // 
            resources.ApplyResources(this.panel1, "panel1");
            this.panel1.BackColor = System.Drawing.Color.Transparent;
            this.panel1.Name = "panel1";
            // 
            // pCPUPanel
            // 
            resources.ApplyResources(this.pCPUPanel, "pCPUPanel");
            this.pCPUPanel.BackColor = System.Drawing.Color.Black;
            this.pCPUPanel.ForeColor = System.Drawing.SystemColors.ButtonHighlight;
            this.pCPUPanel.Name = "pCPUPanel";
            this.toolTip1.SetToolTip(this.pCPUPanel, resources.GetString("pCPUPanel.ToolTip"));
            // 
            // imageList1
            // 
            this.imageList1.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("imageList1.ImageStream")));
            this.imageList1.TransparentColor = System.Drawing.Color.Transparent;
            this.imageList1.Images.SetKeyName(0, "Folder.ico");
            this.imageList1.Images.SetKeyName(1, "file.ico");
            this.imageList1.Images.SetKeyName(2, "zipFolder.png");
            // 
            // notifyIcon1
            // 
            this.notifyIcon1.ContextMenuStrip = this.contextMenuStrip1;
            resources.ApplyResources(this.notifyIcon1, "notifyIcon1");
            // 
            // Form1
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(2)))), ((int)(((byte)(2)))), ((int)(((byte)(2)))));
            this.ContextMenuStrip = this.contextMenuStrip1;
            this.ControlBox = false;
            this.Controls.Add(this.label12);
            this.Controls.Add(this.pPBar);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.pCPUPanel);
            this.Controls.Add(this.label18);
            this.Controls.Add(this.label17);
            this.Controls.Add(this.label19);
            this.Controls.Add(this.label16);
            this.Controls.Add(this.label15);
            this.Controls.Add(this.label14);
            this.Controls.Add(this.label13);
            this.Controls.Add(this.label11);
            this.Controls.Add(this.label10);
            this.Controls.Add(this.label0);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Cursor = System.Windows.Forms.Cursors.SizeAll;
            this.DoubleBuffered = true;
            this.ForeColor = System.Drawing.Color.Black;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "Form1";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.TransparencyKey = System.Drawing.Color.FromArgb(((int)(((byte)(2)))), ((int)(((byte)(2)))), ((int)(((byte)(2)))));
            this.Load += new System.EventHandler(this.Form1_Load);
            this.Paint += new System.Windows.Forms.PaintEventHandler(this.Form1_Paint);
            this.DoubleClick += new System.EventHandler(this.Form1_DoubleClick);
            this.MouseDown += new System.Windows.Forms.MouseEventHandler(this.EM_MouseDown);
            this.MouseEnter += new System.EventHandler(this.label_MouseEnter);
            this.MouseLeave += new System.EventHandler(this.label_MouseLeave);
            this.MouseMove += new System.Windows.Forms.MouseEventHandler(this.EM_MouseMove);
            this.Resize += new System.EventHandler(this.Form1_Resize);
            this.contextMenuStrip1.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }
        #endregion

        public System.Windows.Forms.Timer timer1;
        private System.Windows.Forms.ContextMenuStrip contextMenuStrip1;
        private System.Windows.Forms.ToolStripMenuItem aktualisierenToolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem einstellungenToolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem beendenToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem spracheToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem englishToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem germanToolStripMenuItem;
        public System.Windows.Forms.Label label19;
        public System.Windows.Forms.Label label18;
        public System.Windows.Forms.Label label17;
        public System.Windows.Forms.Label label16;
        public System.Windows.Forms.Label label15;
        public System.Windows.Forms.Label label14;
        public System.Windows.Forms.Label label13;
        public System.Windows.Forms.Label label12;
        public System.Windows.Forms.Label label11;
        public System.Windows.Forms.Label label10;
        public System.Windows.Forms.Label label9;
        public System.Windows.Forms.Label label8;
        public System.Windows.Forms.Label label7;
        public System.Windows.Forms.Label label6;
        public System.Windows.Forms.Label label5;
        public System.Windows.Forms.Label label4;
        public System.Windows.Forms.Label label3;
        public System.Windows.Forms.Label label2;
        public System.Windows.Forms.Label label1;
        public System.Windows.Forms.Label label0;
        private System.Windows.Forms.Panel pPBar;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Panel pCPUPanel;
        private System.Windows.Forms.Panel pMemPanel;
        private System.Windows.Forms.ToolTip toolTip1;
        public System.Windows.Forms.ImageList imageList1;
        private System.Windows.Forms.ToolStripMenuItem borderTS;
        private System.Windows.Forms.ToolStripMenuItem thinBorderTS;
        private System.Windows.Forms.ToolStripMenuItem thickBorderTS;
        private System.Windows.Forms.ToolStripMenuItem hintergrundToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem transparentToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem gradientToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem textureToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem aeroEffektabVistaToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem lockedToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem SettingsChangeToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem SettingsDelToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem aeroSpecialabVistaToolStripMenuItem;
        private System.Windows.Forms.NotifyIcon notifyIcon1;
        private System.Windows.Forms.ToolStripMenuItem saveToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem hideToolStripMenuItem;


    }
}

