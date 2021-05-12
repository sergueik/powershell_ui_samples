//============================================================================
// SYSInfo 1.0
// Copyright © 2010 Stephan Berger
// 
//This file is part of SYSInfo.
//
//SYSInfo is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.
//
//SYSInfo is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.
//
//You should have received a copy of the GNU General Public License
//along with SYSInfo.  If not, see <http://www.gnu.org/licenses/>.
//
//============================================================================
//
//ProgressODoom.ProgressBarEx by BoneSoft http://www.codeproject.com/script/Membership/View.aspx?mid=2989010
//Example http://www.codeproject.com/KB/progress/ProgressODoom.aspx
//
//============================================================================

using System;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Management;
using Microsoft.Win32;
using System.Drawing.Drawing2D;
using System.Threading;
using System.Net.NetworkInformation;
using System.Linq;
using System.Runtime.InteropServices;
using System.Collections.Generic;
using DrawBehindDesktopIcons;

namespace SYSInfo
{

    public partial class Form1 : Form
    {
        #region vars

        private Form2 f2;//reference to form2
        public string []sData = new string[20];
        public int []iFunction = new int[20];
        public bool []iLB = new bool[20];
        public string []sTitle = new string[20];
        public bool []iLBHist = new bool[20];
        public string []sTitleHist = new string[20];
        public Control[] cLabel = new Control[20];
        public Color[] cTitleColor = new Color[20];
        public Font[] fTitleFont = new Font[20];
        public int _iLBr = 1, iGradAngle, _iPBHDDWidth, tCPU = 0,tNet = 0;
        public bool bColorGlobal,bTransparency,bAero,bAeroFrame,bGradient,bTexture,bTextureBlue,bTextureGrey,bHDDPBar = false,bCPU = false,bCPUText = false,bCPUTotal = false;
        public bool bNetTP = false, bNetIP = false, bNetMask = false, bNetMac = false, bNetGW = false,bFixed = false,bMemBar=false,bMemText=false;
        public int _iWidth =110;
        public bool bAeroGradient = false, bAeroTexture = false;
        public float fAeroTransparency = 0f;
        public string[] sNetAdapters = new string[5];
        public List<string> lHDDSys = new List<string>();
        public List<string> lHDDHidden = new List<string>();
        public Color cColorGlobal, cColorB1, cColorB2, cAero = Color.FromArgb(20, 20, 20);
        public Font fFontGlobal;

        public float fRed = 0f, fGreen = 0f, fBlue = 0f, fRedScale = 1f, fGreenScale = 1f, fBlueScale = 1f;
        public Image imageBackG;
        public string sImageBackFilename = "";
        public bool bBGImageFill;

        //HDD bar
        public ProgressODoom.ProgressBarEx[] _hddBar = new ProgressODoom.ProgressBarEx[10];
        public ProgressODoom.PlainProgressPainter[] _pHddProg = new ProgressODoom.PlainProgressPainter[10];
        ProgressODoom.PlainBorderPainter _pHddBorder = new ProgressODoom.PlainBorderPainter(Color.FromArgb(0, 0, 1));
        ProgressODoom.PlainBackgroundPainter _pHddBack = new ProgressODoom.PlainBackgroundPainter(Color.FromArgb(90,90,140));
        ProgressODoom.RoundGlossPainter _pHddGloss = new ProgressODoom.RoundGlossPainter();
        public Color cColorHDDText,cColorHDDBack,cColorHDDBar50,cColorHDDBar75,cColorHDDBar100;
        Label[] lHDD = new Label[10];
        //network
        public System.Windows.Forms.Timer netTimer = new System.Windows.Forms.Timer();
        Panel pNet = new Panel();
        public NetworkAdapter[] adapters;
        public NetworkMonitor monitor;

        NetworkWorkload[] netLoad = new NetworkWorkload[4];
        CPUWorkload cpuLoad;
        System.Collections.ArrayList alDiskUsage;
        Panel pDiskUsage = new Panel();

        processlist processlist;
        Label lProcessName;
        Label lProcessUsage;
        Panel pProcess = new Panel();

        Label lProcessMemName;
        Label lProcessMemUsage;
        Panel pProcessMem = new Panel();

        Panel pBattery;
        ProgressODoom.PlainProgressPainter _BatProg;
        ProgressODoom.ProgressBarEx _BatBar;
        Label lBatLabel;

        Panel pMemory;
        ProgressODoom.PlainProgressPainter _MemProg;
        ProgressODoom.ProgressBarEx _MemBar;
        ProgressODoom.PlainBackgroundPainter _MemBack = new ProgressODoom.PlainBackgroundPainter(Color.FromArgb(90, 90, 140));
        public Color cColorMemBack,cColorMemBar50,cColorMemBar75,cColorMemBar100;
        Label lMemLabel;

        EventQuery eqBootUpDate;

        bool bFrameChecked = false; // form border
        public bool bFrameType = false;    //form bordertype false:thick, true:thin
        bool bNetInit = false;
        DateTime dtNet = new DateTime();
        TimeSpan tsNet = new TimeSpan();
        private ReaderWriterLockSlim dcLock = new ReaderWriterLockSlim();
        #endregion

        public Form1()
        {
            string langID = Properties.Settings.Default.lang;   // Set Language
            System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo(langID);
            NetworkChange.NetworkAddressChanged += new NetworkAddressChangedEventHandler(AddressChangedCallback);
            bFrameChecked = Properties.Settings.Default.f1bFrameChecked;
            bFrameType = Properties.Settings.Default.f1bFrameType;
            InitializeComponent();
        }
        private void Form1_Load(object sender, EventArgs e)
        {
            if (Properties.Settings.Default.CallUpgrade)
            {
                Properties.Settings.Default.Upgrade();
                Properties.Settings.Default.CallUpgrade = false;
                Properties.Settings.Default.Save();
            }
            SetStyle(ControlStyles.SupportsTransparentBackColor, true); //enable background transparency
            int posX = Properties.Settings.Default.pXpos;   //get last position
            int posY = Properties.Settings.Default.pYpos;
            this.SetDesktopLocation(posX, posY);
            netTimer.Tick += new EventHandler(network_update_visuals);
            SystemEvents.PowerModeChanged += SystemEvents_PowerModeChanged;
            _hddBarInit();
            loadSettings();
            //Jan. 2013 - "aero" support for Win8 -> blurred glas background
            if (System.Environment.OSVersion.Version.Major >= 6 && DwmIsCompositionEnabled())
                this.BackColor = bAero ? cAero : System.Drawing.Color.FromArgb(2, 2, 2);

            _Init();
            if (_bDesktopBack) //Aug. 2014 - support for sending form behind desktop icons resulting in a completly locked state
            {
                _bDesktopBack = false;  //awkward... but I'm lazy ^^
                _sendToBack();
            }
            timer1.Enabled = true;
            _update_visuals();
        }

        #region general settings
        //load saved settings from settings file
        public void loadSettings()
        {
            string sVar, sColor, sFont;
            for (int i = 0; i < 20; i++)
            {
                sVar = "f2Titel" + (i + 1).ToString();
                sTitle[i] = Properties.Settings.Default[sVar].ToString();
                sVar = "f2Funktion" + (i + 1).ToString();
                iFunction[i] = Convert.ToInt16(Properties.Settings.Default[sVar]);
                sVar = "f2LB" + (i + 1).ToString();
                iLB[i] = Convert.ToBoolean(Properties.Settings.Default[sVar]);
                sVar = "f2TitelHist" + (i + 1).ToString();
                sTitleHist[i] = Properties.Settings.Default[sVar].ToString();
                sVar = "f2LBHist" + (i + 1).ToString();
                iLBHist[i] = Convert.ToBoolean(Properties.Settings.Default[sVar]);
                sColor = "f2TextColor" + (i + 1).ToString();
                cTitleColor[i] = (Color)Properties.Settings.Default[sColor];
                sFont = "f2TextFont" + (i + 1).ToString();
                fTitleFont[i] = (Font)Properties.Settings.Default[sFont];

            }
            bMemBar = Properties.Settings.Default.f1bMemBar;
            bMemText = Properties.Settings.Default.f1bMemText;
            cColorMemBack = Properties.Settings.Default.f1MemBackCol;
            cColorMemBar100 = Properties.Settings.Default.f1MemBarCol100;
            cColorMemBar75 = Properties.Settings.Default.f1MemBarCol75;
            cColorMemBar50 = Properties.Settings.Default.f1MemBarCol50;
            bHDDPBar = Properties.Settings.Default.f1HDDBarShow;
            timer1.Interval = Properties.Settings.Default.f2Timer * 1000;
            bColorGlobal = Properties.Settings.Default.f2ColorGlobal;
            cColorGlobal = Properties.Settings.Default.f1TextColor;
            fFontGlobal = Properties.Settings.Default.f1Text;
            cColorB1 = Properties.Settings.Default.f2ColorB1;
            cColorB2 = Properties.Settings.Default.f2ColorB2;
            bTransparency = Properties.Settings.Default.f2Transparency;
            bAero = Properties.Settings.Default.f2Aero;
            iGradAngle = Properties.Settings.Default.f2GradAngle;
            cColorHDDText = Properties.Settings.Default.f1HDDTextCol;
            cColorHDDBack = Properties.Settings.Default.f1HDDBackCol;
            cColorHDDBar50 = Properties.Settings.Default.f1HDDBarCol50;
            cColorHDDBar75 = Properties.Settings.Default.f1HDDBarCol75;
            cColorHDDBar100 = Properties.Settings.Default.f1HDDBarCol100;
            bCPU = Properties.Settings.Default.f2CPU;
            bCPUText = Properties.Settings.Default.f2CPUText;
            bCPUTotal = Properties.Settings.Default.f2CPUTotal;
            bNetIP = Properties.Settings.Default.f2NetIP;
            bNetGW = Properties.Settings.Default.f2NetGW;
            bNetMac = Properties.Settings.Default.f2NetMAC;
            bNetMask = Properties.Settings.Default.f2NetSUB;
            bNetTP = Properties.Settings.Default.f2NetTP;
            sNetAdapters[0] = Properties.Settings.Default.f2NetAdap[0];
            sNetAdapters[1] = Properties.Settings.Default.f2NetAdap[1];
            sNetAdapters[2] = Properties.Settings.Default.f2NetAdap[2];
            sNetAdapters[3] = Properties.Settings.Default.f2NetAdap[3];
            bTexture = Properties.Settings.Default.f1bBckgrTex;
            bTextureBlue = Properties.Settings.Default.f1bBckgrTexBlue;
            bTextureGrey = Properties.Settings.Default.f1bBckgrTexGrey;
            bGradient = Properties.Settings.Default.f1bBckgrGrad;
            fRed = Properties.Settings.Default.f1BGImageRed;
            fGreen = Properties.Settings.Default.f1BGImageGreen;
            fBlue = Properties.Settings.Default.f1BGImageBlue;
            fRedScale = Properties.Settings.Default.f1BGImageRedScale;
            fGreenScale = Properties.Settings.Default.f1BGImageGreenScale;
            fBlueScale = Properties.Settings.Default.f1BGImageBlueScale;
            sImageBackFilename = Properties.Settings.Default.f1BGImage;
            bBGImageFill = Properties.Settings.Default.f1BGImageFill;
            cAero = Properties.Settings.Default.f1CAero;
            bAeroFrame = aeroSpecialabVistaToolStripMenuItem.Checked = Properties.Settings.Default.f1bAeroFrame;
            bAeroTexture = Properties.Settings.Default.bAeroTextured;
            bAeroGradient = Properties.Settings.Default.bAeroGrad;
            fAeroTransparency = Properties.Settings.Default.fAeroTrans;
            _bDesktopBack = Properties.Settings.Default.f1bFormFixed;
            lHDDHidden.Clear();
            foreach (string s in Properties.Settings.Default.f2HDDList)
                lHDDHidden.Add(s);

            lHDDSys.Clear();
            string query = "SELECT Name FROM Win32_PerfRawData_PerfDisk_PhysicalDisk WHERE NOT Name like '%_Total%' AND AvgDiskBytesPerRead > 0";
            if(dcLock.TryEnterWriteLock(50))
                try
                {
                    ManagementObjectSearcher seeker = new ManagementObjectSearcher(query);
                    //seeker.Options.Timeout = TimeSpan.FromMilliseconds(100);
                    ManagementObjectCollection oReturnColl = seeker.Get();
                    foreach (ManagementObject m in oReturnColl)
                        lHDDSys.Add(m["Name"].ToString());

                }
                catch (Exception)
                {

                    ; ;
                }
                finally
                {
                    dcLock.ExitWriteLock();
                }

        }
        private void saveSettings()
        {
            Properties.Settings.Default.pXpos = this.Location.X;
            Properties.Settings.Default.pYpos = this.Location.Y;
            Properties.Settings.Default.f1bFormFixed = _bDesktopBack;
            Properties.Settings.Default.Save();
            while (!Properties.Settings.Default.IsSynchronized)
            {
                System.Threading.Thread.Sleep(500);
            }
        }
        private void settingsDialog()
        {
            timer1.Enabled = false;
            if (f2 != null && !f2.IsDisposed)  // check for instance
                f2.Visible = true;
            else // firsttime call - no instance yet
            {
                this.f2 = new Form2(this);
                f2.Show();
            }

        }
        #endregion

        #region language settings
        private void englishToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Properties.Settings.Default.lang = "en-GB";
            System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo("en-GB");
            updateStringRessource("en-GB");
            _hddBar.Initialize();
            pPBar.Controls.Clear();
            _hddBarInit();
            loadSettings();
            _Init();
            _update_visuals();

        }
        private void germanToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Properties.Settings.Default.lang = "de-DE";
            System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo("de-DE");
            updateStringRessource("de-DE");
            _hddBar.Initialize();
            pPBar.Controls.Clear();
            _hddBarInit();
            loadSettings();
            _Init();
            _update_visuals();
        }
        private void updateStringRessource(string langID)
        {
            try
            {
                Point pt = this.Location;// memorize location of form
                Size sz = this.Size;// memorize size of form
                // Set Language
                System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo(langID);               
                this.Controls.Clear();// clear all controls of form
                components.Dispose();// dispose all components and release resources
                // delete all events to avoid double instances when calling  InitializeComponent(); 
                this.Events.Dispose();
                if (netTimer != null)
                {
                    netTimer.Dispose();
                    netTimer = null;
                }
                netTimer = new System.Windows.Forms.Timer();
               // Form1_Load(null, null);
                InitializeComponent(); // reload UI
                this.Size = sz;// set size
                this.Location = pt;// position form
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }


        #endregion

        #region initializers

        #region general

        //init the text labels
        public void _Init()
        {
            _iWidth = DPIScaling(110);
            string sLabel;
            for (int i = 0; i < 20; i++)    //Assign labels to cLabel Array
            {
                sLabel = "label" + i.ToString();
                cLabel[i] = this.Controls.Find(sLabel, true)[0];
                cLabel[i].Visible = false;
            }
            if (iFunction[0] > -1 & bMemBar) //free memory
            {
                _memory_init();
                cLabel[iFunction[0]] = pMemory;
            }
            else
            {
                if (pMemory != null)
                {
                    pMemory.Controls.Clear();
                    pMemory.Dispose();
                    pMemory = null;
                }
            }
            if (iFunction[4] > -1)  //Network
            {
                if (netTimer == null)
                {
                    netTimer = new System.Windows.Forms.Timer();
                    netTimer.Tick += new EventHandler(network_update_visuals);
                }
                netTimer.Interval = Properties.Settings.Default.f2TimerNet;
                tNet = Environment.TickCount;
                cLabel[iFunction[4]] = pNet; //Replace label control with panel - btw. labels may have controls added, but Autosize doesn't work
                pNet.AutoSize = true;
                pNet.AutoSizeMode = AutoSizeMode.GrowAndShrink;
                pNet.BackColor = Color.Transparent;
                Network_init();
                this.Controls.Add(pNet);
                network_update_visuals(null, null);
                netTimer.Enabled = true;
               // Network();
            }
            else
            {
                if (netTimer != null)
                {
                    netTimer.Dispose();
                    netTimer = null;
                }
                pNet.Visible = false;
                pNet.Controls.Clear();
            }
            if (iFunction[3] > -1 && bHDDPBar == true)
            {
                cLabel[iFunction[3]] = pPBar;  //Replace label control with HDD ProgressBar control
                cLabel[iFunction[3]].Visible = false;
                pPBar.Visible = true;
                Disk();
            }
            else
                pPBar.Visible = false;

            if (iFunction[7] > -1 && (System.Environment.OSVersion.Version.Minor >= 2))
            {
                if (eqBootUpDate != null)
                    eqBootUpDate = null;
                eqBootUpDate = new EventQuery();
            }
            
            if (iFunction[10] > -1)
            {
                _cpu_init();
                cpuLoad.Refresh(null,null);
            }
            else
            {
                pCPUPanel.Visible = false;
                if (cpuLoad != null)
                {
                    cpuLoad.dispose();
                    cpuLoad = null;
                }
                pCPUPanel.Controls.Clear();
            }
            if (iFunction[11] > -1)  //top 5 memory
            {
                _processMemory_init();
                top5ProcessMemory();
            }
            else
            {
                if (lProcessMemName != null)
                    lProcessMemName.Dispose();
                if (lProcessMemUsage != null)
                    lProcessMemUsage.Dispose();
                pProcessMem.Controls.Clear();
            }
            if (iFunction[12] > -1)  //top 5 processes
            {
                _processList_init();
                top5ProcessCPUUsage();
            }
            else
            {
                if (processlist != null)
                    processlist.dispose();
                if (lProcessName != null)
                    lProcessName.Dispose();
                if (lProcessUsage != null)
                    lProcessUsage.Dispose();
                pProcess.Controls.Clear();
            }
            if (iFunction[13] > -1)
            {
                _diskusage_init();
                if (alDiskUsage != null)
                {
                    foreach (DiskUsage d in alDiskUsage)
                    {
                        d.update();
                    }
                }
            }
            else
            {
                if (alDiskUsage != null)
                    foreach (DiskUsage d in alDiskUsage)
                        d.dispose();
                pDiskUsage.Controls.Clear();
                pDiskUsage.Visible = false;

            }
            if (iFunction[14] > -1)
            {
                _battery_init();
                cLabel[iFunction[14]] = pBattery;
            }
            else
            {
                if (pBattery != null)
                {
                    pBattery.Controls.Clear();
                    pBattery.Dispose();
                    pBattery = null;
                }
            }
            if (sImageBackFilename != "")
            {
                System.IO.FileInfo image = new System.IO.FileInfo(sImageBackFilename);
                if (image.Exists)
                    imageBackG = Image.FromFile(sImageBackFilename);
                if (imageBackG.Height > 300 && imageBackG.Width > 300)
                {
                    Image ImageBack = imageBackG;
                    ImageBack.RotateFlip(System.Drawing.RotateFlipType.Rotate180FlipNone);
                    ImageBack.RotateFlip(System.Drawing.RotateFlipType.Rotate180FlipNone);
                    int width = ImageBack.Width;
                    int height = ImageBack.Height;
                    width = (width * 300) / height;
                    height = 300;
                    imageBackG = ImageBack.GetThumbnailImage(width, height, null, IntPtr.Zero);
                }

            }
            _update_visuals();
        }
        #endregion

        #region panels - labels

        void panel_init(ref Panel pPanel)
        {
            pPanel.Controls.Clear();
            pPanel.Width = DPIScaling(110);
            pPanel.AutoSize = true;
            pPanel.Visible = true;
            pPanel.Left = 8;
            pPanel.Margin = new Padding(0);
            pPanel.Padding = new Padding(0);
            pPanel.AutoSizeMode = AutoSizeMode.GrowAndShrink;
            pPanel.BackColor = Color.Transparent;
            this.Controls.Add(pPanel);
        }

        void label_init(ref Label lLabel)
        {
            lLabel.BackColor = Color.Transparent;
            lLabel.AutoSize = true;
            lLabel.Margin = new Padding(0);
            lLabel.Padding = new Padding(0);
            lLabel.MouseEnter += new EventHandler(label_MouseEnter);
            lLabel.MouseLeave += new EventHandler(label_MouseLeave);
            lLabel.MouseDown += new MouseEventHandler(EM_MouseDown);
            lLabel.MouseMove += new MouseEventHandler(EM_MouseMove);
            lLabel.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
        }
        #endregion

        void _battery_init()
        {
            if (pBattery == null)
                pBattery = new Panel();
            panel_init(ref pBattery);
            _BatBar = new ProgressODoom.ProgressBarEx();
            _BatProg = new ProgressODoom.PlainProgressPainter();
            ProgressODoom.PlainBorderPainter _BatBorder = new ProgressODoom.PlainBorderPainter(Color.FromArgb(0, 0, 1));
            ProgressODoom.PlainBackgroundPainter _BatBack = new ProgressODoom.PlainBackgroundPainter(Color.FromArgb(90,90,140));
            ProgressODoom.RoundGlossPainter _BatGloss = new ProgressODoom.RoundGlossPainter();
            _BatGloss.Color = Color.WhiteSmoke;
            _BatGloss.TaperHeight = 7;
            _BatGloss.Style = ProgressODoom.GlossStyle.Top;
            _BatProg.GlossPainter = _BatGloss;
            _BatBack.GlossPainter = _BatGloss;
            _BatBar.Width = _iWidth;
            _BatBar.Height = 15;
            _BatBar.Left = 0;
            _BatBar.ProgressPainter = _BatProg;
            _BatBar.BackgroundPainter = _BatBack;
            _BatBar.ForeColor = Color.FromArgb(10, 10, 20);
            _BatBar.Padding = new Padding(0);
            _BatBar.Margin = new Padding(0);
            _BatBar.MouseEnter += new EventHandler(this.pbar_MouseEnter);
            _BatBar.MouseLeave += new EventHandler(this.pbar_MouseLeave);
            _BatBar.MouseDown += new MouseEventHandler(EM_MouseDown);
            _BatBar.MouseMove += new MouseEventHandler(EM_MouseMove);
            _BatBar.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            lBatLabel = new Label();
            label_init(ref lBatLabel);
            lBatLabel.Text = sTitle[14];
            pBattery.Controls.Add(lBatLabel);
            pBattery.Controls.Add(_BatBar);
        }

        void _memory_init()
        {
            if (pMemory == null)
                pMemory = new Panel();
            panel_init(ref pMemory);
            _MemBar = new ProgressODoom.ProgressBarEx();
            _MemProg = new ProgressODoom.PlainProgressPainter();
            ProgressODoom.PlainBorderPainter _MemBorder = new ProgressODoom.PlainBorderPainter(Color.FromArgb(0, 0, 255));
            
            ProgressODoom.RoundGlossPainter _MemGloss = new ProgressODoom.RoundGlossPainter();
            _MemGloss.Color = Color.WhiteSmoke;
            _MemGloss.TaperHeight = 1;
            _MemGloss.Style = ProgressODoom.GlossStyle.Top;
            _MemProg.GlossPainter = _MemGloss;
            _MemBack.GlossPainter = _MemGloss;
            _MemBar.Width = _iWidth;
            _MemBar.Height = 6;
            _MemBar.Left = 0;
            _MemBar.ProgressPainter = _MemProg;
            _MemBar.BackgroundPainter = _MemBack;
            _MemBar.ForeColor = Color.FromArgb(10, 10, 20);
            _MemBar.Padding = new Padding(0);
            _MemBar.Margin = new Padding(0);
            _MemBar.MouseEnter += new EventHandler(this.pbar_MouseEnter);
            _MemBar.MouseLeave += new EventHandler(this.pbar_MouseLeave);
            _MemBar.MouseDown += new MouseEventHandler(EM_MouseDown);
            _MemBar.MouseMove += new MouseEventHandler(EM_MouseMove);
            _MemBar.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
            lMemLabel = new Label();
            label_init(ref lMemLabel);
            lMemLabel.Text = sTitle[0];
            pMemory.Controls.Add(lMemLabel);
            pMemory.Controls.Add(_MemBar);
        }

        void _processList_init()
        {
            if (lProcessName != null)
                lProcessName.Dispose();
            if (lProcessUsage != null)
                lProcessUsage.Dispose();
            pProcess.Controls.Clear();
            processlist = new processlist();
            lProcessName = new Label();
            lProcessUsage = new Label();
            label_init(ref lProcessName);
            label_init(ref lProcessUsage);
            panel_init(ref pProcess);
            pProcess.Controls.Add(lProcessName);
            pProcess.Controls.Add(lProcessUsage);
            pProcess.Padding = new Padding(0, 1, 0, 3);
            cLabel[iFunction[12]] = pProcess;
        }

        void _processMemory_init()
        {
            if (lProcessMemName != null)
                lProcessMemName.Dispose();
            if (lProcessMemUsage != null)
                lProcessMemUsage.Dispose();
            pProcessMem.Controls.Clear();
            lProcessMemName = new Label();
            lProcessMemUsage = new Label();
            label_init(ref lProcessMemName);
            label_init(ref lProcessMemUsage);
            panel_init(ref pProcessMem);
            pProcessMem.Controls.Add(lProcessMemName);
            pProcessMem.Controls.Add(lProcessMemUsage);
            pProcessMem.Padding = new Padding(0, 1, 0, 3);
            cLabel[iFunction[11]] = pProcessMem;
        }
        void _cpu_init()
        {
            cLabel[iFunction[10]] = pCPUPanel; //Replace label control with CPU usage control if selected
            cLabel[iFunction[10]].Visible = false;
            pCPUPanel.Visible = true;
            pCPUPanel.BackColor = Color.Transparent;
            pCPUPanel.Left = 8;
            pCPUPanel.AutoSize = true;

            if (cpuLoad != null)
            {
                cpuLoad.dispose();
                cpuLoad = null;
            }
            pCPUPanel.Controls.Clear();
            cpuLoad = new CPUWorkload(bCPU, bCPUText,bCPUTotal);
            cpuLoad.Timer.Interval = Properties.Settings.Default.f2TimerCPU;
            cpuLoad.Timer.Enabled = true;

            pCPUPanel.Controls.Add(cpuLoad.Label);
            cpuLoad.Label.MouseEnter += new EventHandler(label_MouseEnter);
            cpuLoad.Label.MouseLeave += new EventHandler(label_MouseLeave);
            cpuLoad.Label.MouseDown += new MouseEventHandler(EM_MouseDown);
            cpuLoad.Label.MouseMove += new MouseEventHandler(EM_MouseMove);
            cpuLoad.Label.DoubleClick += new System.EventHandler(this.lable_DoubleClick);

            pCPUPanel.Controls.Add(cpuLoad.CPUGraphControl);
            if (bCPUText)
                cpuLoad.Label.Visible = true;
            else
                cpuLoad.Label.Visible = false;
            if (bCPU)
            {
                cpuLoad.CPUGraphControl.Visible = true;
                cpuLoad.CPUGraphControl.Width = 115;
                cpuLoad.CPUGraphControl.Height = 31;
            }
            else
                cpuLoad.CPUGraphControl.Visible = false;
        }
 
        void _diskusage_init()
        {
            try
            {

                panel_init(ref pDiskUsage);
                cLabel[iFunction[13]] = pDiskUsage; //Replace label control with diskusage control if selected
                cLabel[iFunction[13]].Visible = false;

                if (alDiskUsage != null)
                {
                    foreach (DiskUsage d in alDiskUsage)
                    {
                        d.dispose();
                    }
                }
                else
                {
                    alDiskUsage = new System.Collections.ArrayList();
                }

                string query = "SELECT Name FROM Win32_PerfRawData_PerfDisk_PhysicalDisk WHERE NOT Name like '%_Total%' AND AvgDiskBytesPerRead > 0";
                ManagementObjectSearcher seeker = new ManagementObjectSearcher(query);
                seeker.Options.Timeout = TimeSpan.FromMilliseconds(2000);
                ManagementObjectCollection oReturnColl = seeker.Get();
                int i = 0;
                foreach (ManagementObject m in oReturnColl)
                {
                    if(!lHDDHidden.Contains(m["Name"].ToString()))
                    {
                        DiskUsage dUsage = new DiskUsage(m["Name"].ToString());
                        dUsage.Timer.Interval = Properties.Settings.Default.f2TimerCPU;
                        dUsage.Timer.Enabled = true;
                        dUsage.Label.MouseEnter += new EventHandler(label_MouseEnter);
                        dUsage.Label.MouseLeave += new EventHandler(label_MouseLeave);
                        dUsage.Label.MouseDown += new MouseEventHandler(EM_MouseDown);
                        dUsage.Label.MouseMove += new MouseEventHandler(EM_MouseMove);
                        dUsage.Label.DoubleClick += new System.EventHandler(this.lable_DoubleClick);
                        dUsage.Label.Visible = true;
                        dUsage.DiskGraphControl.Visible = true;

                        pDiskUsage.Controls.Add(dUsage.Label);
                        pDiskUsage.Controls.Add(dUsage.DiskGraphControl);
                        pDiskUsage.Controls.SetChildIndex(dUsage.Label,i); //dunno why, but I've to set it manually...
                        pDiskUsage.Controls.SetChildIndex(dUsage.DiskGraphControl, i + 1);
                        alDiskUsage.Add(dUsage);
                        i+=2;
                    }
                }
                oReturnColl.Dispose();
                seeker.Dispose();
            }
            catch (Exception)
            {
               //throw;
            }
        }

        //init Diskspace progress bar
        void _hddBarInit()
        {
            _pHddGloss.Color = Color.WhiteSmoke;
            _pHddGloss.TaperHeight = 1; //7
            _pHddGloss.Style = ProgressODoom.GlossStyle.Top;
            _pHddBack.GlossPainter = _pHddGloss;
            for (int i = 0; i < 10; i++)
            {
                if (_hddBar[i] != null)
                    _hddBar[i].Dispose();
                _hddBar[i] = new ProgressODoom.ProgressBarEx();
                //_pBar[i].Font = 
                // _pBar[i].BorderPainter = _pBorder;
                if (_pHddProg[i] != null)
                    _pHddProg[i].Dispose();
                _pHddProg[i] = new ProgressODoom.PlainProgressPainter();
                _pHddProg[i].GlossPainter = _pHddGloss;
                //_pProg[i].ProgressBorderPainter = _pBorder;
                _hddBar[i].Visible = false;
                _hddBar[i].Width = _iWidth;
                _hddBar[i].Height = 6; //15;
                _hddBar[i].Left = 0;
                _hddBar[i].ProgressPainter = _pHddProg[i];
                _hddBar[i].BackgroundPainter = _pHddBack;
                _hddBar[i].ForeColor = Color.FromArgb(10, 10, 20);
                _hddBar[i].Padding = new Padding(0);
                _hddBar[i].Margin = new Padding(0);
                _hddBar[i].MouseEnter +=new EventHandler(this.pbar_MouseEnter);
                _hddBar[i].MouseLeave += new EventHandler(this.pbar_MouseLeave);
                this._hddBar[i].DoubleClick += new System.EventHandler(this.lable_DoubleClick);
              //  this._hddBar[i].MouseDown += new System.Windows.Forms.MouseEventHandler(this.PBAR_MOUSE_DOWN);
                this._hddBar[i].Click += new System.EventHandler(PBAR_MOUSE_DOWN); //has higher priority than MouseDown - important for shell context menu

                lHDD[i] = new Label();
                label_init(ref lHDD[i]);
                this.lHDD[i].Click += new System.EventHandler(PBAR_MOUSE_DOWN); //has higher priority than MouseDown - important for shell context menu
                lHDD[i].MouseEnter += new EventHandler(this.pLabel_MouseEnter);
                lHDD[i].MouseLeave += new EventHandler(this.pLabel_MouseLeave);

                pPBar.Controls.Add(lHDD[i]);
                pPBar.Controls.Add(_hddBar[i]);
            }
        }

        //Network_init - wmi query for Win32_NetworkAdapterConfiguration for enabled interfaces
        //gets the name and initializes the monitor
        public void Network_init()
        {
            dtNet = DateTime.Now;
            string[] s = new string[0];
            if (monitor != null) // in case of AddressChanged event
                monitor.MonitorsClear();
            int i = 0;
            //string query = "SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = TRUE";
            //ManagementObjectSearcher seeker = new ManagementObjectSearcher(query);
            //ManagementObjectCollection oReturnCollection = seeker.Get();
            //foreach (ManagementObject m in oReturnCollection)
            //{
            //    try
            //    {
            //        //if (bNetAdapters[i])
            //        //{
            //            Array.Resize(ref s, i + 1);
            //            s[i] = Networkadapter(m);//get name of adapter from registry
            //            i++;
            //        //}
            //    }
            //    catch
            //    { //throw; 
            //    }
            //}
            //   oReturnCollection.Dispose();
            //   seeker.Dispose();

            //jul 2012: Changed query to support modem connections
            NetworkInterface[] nicArr = NetworkInterface.GetAllNetworkInterfaces();
            for (int iNet = 0; iNet < nicArr.Length; iNet++)
            {
                if (nicArr[iNet].NetworkInterfaceType != NetworkInterfaceType.Tunnel
                    && nicArr[i].NetworkInterfaceType != NetworkInterfaceType.Loopback
                    && nicArr[iNet].OperationalStatus == OperationalStatus.Up
                    && !nicArr[iNet].Name.Contains("Loopback"))
                {
                    Array.Resize(ref s, i + 1);
                    s[i] = nicArr[iNet].Name;
                    i++;
                }
            }


            if (monitor != null) // in case of AddressChanged event
                monitor.MonitorsClear();
            monitor = new NetworkMonitor(s); 
            pNet.Controls.Clear();
            for (int k = 0; k < monitor.Adapters.Length; k++)
            {
                if (!sNetAdapters.Contains(monitor.Adapters[k].Name) & k < 4)
                {
                    if (netLoad[k] != null)
                        netLoad[k]._dispose();
                    netLoad[k] = new NetworkWorkload(s[k], monitor.Adapters[k]);
                    monitor.Adapters[k].init();
                    netLoad[k].Label.MouseEnter += new EventHandler(label_MouseEnter);
                    netLoad[k].Label.MouseLeave += new EventHandler(label_MouseLeave);
                    netLoad[k].Label.MouseDown += new MouseEventHandler(EM_MouseDown);
                    netLoad[k].Label.MouseMove += new MouseEventHandler(EM_MouseMove);
                    netLoad[k].Label.DoubleClick += new System.EventHandler(NetLabel_DoubleClick);
                    pNet.Controls.Add(netLoad[k].Label);
                    if (bNetTP)
                        pNet.Controls.Add(netLoad[k].NetGraphControl);
                }
            }
            bNetInit = false;
        }
        //opens a new form displaying active tcp and udp connections
        void NetLabel_DoubleClick(object sender, EventArgs e)
        {
            this.Cursor = System.Windows.Forms.Cursors.WaitCursor;
            TcpUdpForm NetStat = new TcpUdpForm();
            this.Cursor = System.Windows.Forms.Cursors.SizeAll;
        }


        #endregion

        #region processing

        //net usage and info: periodically update label and graph position, text values by nettimer event
        void network_update_visuals(object sender, EventArgs e)
        {
            if (iFunction[4] > -1)
            {
                    Network();
                if (pNet.Controls.Count > 0)
                {
                    for (int i = 1; i < pNet.Controls.Count; i++)
                    {
                       // if (bNetAdapters[i] & i < 4)
                        pNet.Controls[i].Top = 
                            pNet.Controls[i - 1].Height + 
                            pNet.Controls[i - 1].Top + 2; //align controls
                    }
                }
            }
        }

        //periodically update label text by timer event
        public void _update_visuals()
        {
            _iWidth = DPIScaling(110);
            Array.Clear(sData, 0, 20);
            for (int i = 0; i < 20; i++)
            {
                if (iFunction[i] > -1)
                {
                    _Title(i);
                    switch (i)
                    {
                        case 0:
                            if(!bMemBar)
                                sData[iFunction[i]] += Sysdata(2);  // Free memory
                            break;
                        case 1:
                            sData[iFunction[i]] += Sysdata(7);  // Free virt. mem
                            break;
                        case 2:
                            sData[iFunction[i]] += Sysdata(8);  // Free paging mem
                            break;
                        case 3:
                            sData[iFunction[i]] += Disk();      //Free disk space
                            break;
                        case 5:
                            sData[iFunction[i]] += Sysdata(3);  // Computername
                            break;
                        case 6:
                            sData[iFunction[i]] += Sysdata(4);  // Username
                            break;
                        case 7:
                            if (System.Environment.OSVersion.Version.Minor >= 2)
                                sData[iFunction[i]] += eqBootUpDate.BootUpDate;
                            else
                                sData[iFunction[i]] += Sysdata(1);  // Bootup Time
                            break;
                        case 8:
                            sData[iFunction[i]] += Sysdata(5);  // OS
                            break;
                        case 9:
                            sData[iFunction[i]] += Sysdata(6);  // SP
                            break;
                        case 11:
                            //sData[iFunction[i]] += top5ProcessMemory();
                            top5ProcessMemory();
                            break;
                        case 12:
                            //sData[iFunction[i]] += top5ProcessCPUUsage();
                            top5ProcessCPUUsage();
                            break;
                    }
                    if ((i != 3 || bHDDPBar == false) & (i != 0 || bMemBar == false))  //exclude HDD ProgressBar
                    {
                        cLabel[iFunction[i]].Text = sData[iFunction[i]];
                        if (bColorGlobal)
                        {
                            cLabel[iFunction[i]].ForeColor = cColorGlobal;
                            cLabel[iFunction[i]].Font = fFontGlobal;
                        }
                        else
                        {
                            cLabel[iFunction[i]].ForeColor = cTitleColor[i];
                            cLabel[iFunction[i]].Font = fTitleFont[i];
                        }
                    }
                    if(i != 11 & i != 12)
                        _iWidth = cLabel[iFunction[i]].Width > _iWidth ? cLabel[iFunction[i]].Width : _iWidth;
                   cLabel[iFunction[i]].Visible = true;
                 }
            }
            string sText = String.Concat(sData);
            int iIndex = 0;
            if (sText == "" && iFunction[0] == -1 && iFunction[4] == -1 && iFunction[3] == -1 && iFunction[10] == -1 && iFunction[11] == -1 && iFunction[12] == -1 && iFunction[14] == -1)
                settingsDialog();
            else
            {
                if (pCPUPanel.Visible && bCPU)
                {
                    if (bCPUText)
                    {
                        cpuLoad.CPUGraphControl.Top = cpuLoad.Label.Height;
                    }
                    else
                        cpuLoad.CPUGraphControl.Top = 0;

                    cpuLoad.CPUGraphControl.Width =  DPIScaling(115);
                    cpuLoad.CPUGraphControl.Height =  DPIScaling(31);
                    //toolTip1.SetToolTip(cpuLoad.Label, cpuLoad.CPUGraphControl.Width.ToString());
                }

                if (pDiskUsage.Visible)
                {
                 //   diskUsage.DiskGraphControl.Top = diskUsage.Label.Height;
                    if (alDiskUsage != null)
                        for (int i = 1; i < pDiskUsage.Controls.Count; i++)
                        {
                            pDiskUsage.Controls[i].Top =
                                pDiskUsage.Controls[i - 1].Height +
                                pDiskUsage.Controls[i - 1].Top + 2; //align controls

                            pDiskUsage.Controls[i].Width = DPIScaling(115);
                            pDiskUsage.Controls[i].Height = DPIScaling(31);
                        }
                }
                if (iFunction[14] > -1)
                {
                    if(pBattery!=null)
                        BatteryStatus();
                }
                if (iFunction[0] > -1 & bMemBar)
                {
                    if(pMemory!=null)
                        MemoryStatus();
                }

                for (int i = 1; i < 20; i++)    //position labels
                {
                    int x, y;
                    if (cLabel[i].Visible == true)
                    {
                        x = cLabel[i - 1].Left;
                        y = cLabel[i - 1].Top + cLabel[i - 1].Height + _iLBr;
                        Point p = new Point(x, y);
                        cLabel[i].Location = p;
                        iIndex = i;
                    }
                }
            }
            borderTS.Checked = bFrameChecked;
            thickBorderTS.Checked = !bFrameType;
            thinBorderTS.Checked = bFrameType;
            gradientToolStripMenuItem.Checked = bGradient;
            transparentToolStripMenuItem.Checked = bTransparency;
            aeroEffektabVistaToolStripMenuItem.Checked = bAero;
            textureToolStripMenuItem.Checked = bTexture;
    
            string langID = Properties.Settings.Default.lang;
            if (langID == "de-DE")
            {
                germanToolStripMenuItem.Checked = true;
                englishToolStripMenuItem.Checked = false;
            }
            else if (langID == "en-GB")
            {
                englishToolStripMenuItem.Checked = true;
                germanToolStripMenuItem.Checked = false;
            }
        }
        
        #endregion

        #region SYSTEMDATA
        //wmi query for Win32_OperatingSystem
        public string Sysdata(int iQuery)
        {
            string s = "";
            string query = "SELECT * FROM Win32_OperatingSystem";
            if(dcLock.TryEnterWriteLock(50))
                try
                {
                    ManagementObjectSearcher seeker = new ManagementObjectSearcher(query);
                   // seeker.Options.Timeout = TimeSpan.FromMilliseconds(100);
                    ManagementObjectCollection oReturnCollection = seeker.Get();
                    foreach (ManagementObject m in oReturnCollection)
                    {
                        switch (iQuery)
                        {
                            case 1:
                                DateTime lastBootUp = ParseCIMDateTime(m["LastBootUpTime"].ToString());
                                s += lastBootUp.ToString("dd.MM.yyyy HH:mm") + "\n";
                                break;
                            case 2:
                                if (bMemBar)
                                    s += m["FreePhysicalMemory"].ToString() + "/"
                                        + m["TotalVisibleMemorySize"].ToString();
                                else
                                    s += CalcSize(m["FreePhysicalMemory"].ToString(),2) + "/"
                                        + CalcSize(m["TotalVisibleMemorySize"].ToString(),2);
                                break;
                            case 3:
                                s += m["CSName"].ToString() + "\n";
                                break;
                            case 4:
                                s += m["RegisteredUser"].ToString() + "\n";
                                break;
                            case 5:
                                s += m["Caption"].ToString() + "\n";
                                break;
                            case 6:
                                if (m["CSDVersion"] != null)
                                    s += m["CSDVersion"].ToString() + "\n";
                                else
                                    s += "N/A" + "\n";
                                break;
                            case 7:
                                s += CalcSize(m["FreeVirtualMemory"].ToString(), 2)
                                    + "/ " + CalcSize(m["TotalVirtualMemorySize"].ToString(), 2) + "\n";
                                break;
                            case 8:
                                s += CalcSize(m["FreeSpaceInPagingFiles"].ToString(), 2) + "\n";
                                break;
                        }
                    }
                    oReturnCollection.Dispose();
                    seeker.Dispose();

                }
                catch (Exception)
                {

                    ; ;
                }
                finally
                {
                    dcLock.ExitWriteLock();
                }
           return s;
       }
        

        public void MemoryStatus()
        {
            string[] s = Sysdata(2).Split('/');
            string sFreeMem = CalcSize(s[0], 2);
            string sTotalMem = CalcSize(s[1], 2);
            int iFreeMem = Convert.ToInt32(s[0]);
            int iTotalMem = Convert.ToInt32(s[1]);
            Label lTemp = new Label();


            _MemBar.Value = ((iTotalMem-iFreeMem) * 100) / iTotalMem;

            if (_MemBar.Value <= 50 )
                _MemProg.Color = cColorMemBar50;
            if (_MemBar.Value > 50 & _MemBar.Value <= 75)
                _MemProg.Color = cColorMemBar75;
            if (_MemBar.Value > 75)
                _MemProg.Color = cColorMemBar100;

           // _MemBar.Text = sFreeMem + " / " + sTotalMem; // + " (" +_MemBar.Value.ToString() + "%)";

            if (iLBHist[0])
                lMemLabel.Text = sTitle[0] + "\n" + sFreeMem + " / " + sTotalMem;
            else
                lMemLabel.Text = sTitle[0] + " " + sFreeMem + " / " + sTotalMem;

            //lTemp.Text = _MemBar.Text;
            lTemp.Text = lMemLabel.Text;
            if (bColorGlobal)
            {
                _MemBar.Font = fFontGlobal;
                lTemp.Font = fFontGlobal;
                lMemLabel.ForeColor = cColorGlobal;
                lMemLabel.Font = fFontGlobal;
            }
            else
            {
                _MemBar.Font = fTitleFont[0];
                lTemp.Font = fTitleFont[0];
                lMemLabel.ForeColor = cTitleColor[0];
                lMemLabel.Font = fTitleFont[0];
            }

            //if (lMemLabel.PreferredWidth > lTemp.PreferredWidth)
            //    _MemBar.Width = lMemLabel.PreferredWidth + 10 > 110 ? lMemLabel.PreferredWidth + 10 : 110;
            //else
            //    _MemBar.Width = lTemp.PreferredWidth + 10 > 110 ? lTemp.PreferredWidth + 10 : 110;

            _MemBar.Width = _iWidth;

            //_MemBar.Height = 4;//Convert.ToInt16(_MemBar.Font.GetHeight()) + 3;
            
            _MemBack.Color = cColorMemBack;
            _MemBar.BringToFront();
            //lMemLabel.BringToFront();
            _MemBar.Top = lMemLabel.Height +1;
            _MemBar.Update();

        }



        public void BatteryStatus()
        {
            PowerStatus power = SystemInformation.PowerStatus;
            int iPLine = -1;
            Label lTemp = new Label();
            switch (power.PowerLineStatus)
            {
                case PowerLineStatus.Online:
                    iPLine = 1;
                    break;

                case PowerLineStatus.Offline:
                    iPLine = 0;
                    break;

                case PowerLineStatus.Unknown:
                    iPLine = -1;
                    break;
            }
            if (iPLine > -1)
            {
                int powerPercent = (int)(power.BatteryLifePercent * 100);
                int secondsRemaining = power.BatteryLifeRemaining;
                string sRemaining = "";
                if (secondsRemaining >= 0)
                {
                    TimeSpan t = TimeSpan.FromSeconds(secondsRemaining);
                    sRemaining = " - " + t.Hours.ToString() + " h " + t.Minutes.ToString() + " m";
                   // sRemaining = " - " + string.Format("{0} min", secondsRemaining / 60);
                }
                string sStatus = power.BatteryChargeStatus.ToString();
                _BatBar.Value = powerPercent;
                _BatBar.Text = sStatus + sRemaining;
                if (sStatus.Contains("Charging"))
                    _BatProg.Color = Color.LightSkyBlue;
                else
                {
                    if (sStatus.Contains("High"))
                        _BatProg.Color = Color.LightGreen;
                    if (sStatus.Contains("Low"))
                        _BatProg.Color = Color.Yellow;
                    if (sStatus.Contains("Critical"))
                        _BatProg.Color = Color.LightSalmon;
                    if (sStatus.Contains("NoSystem"))
                        _BatProg.Color = Color.LightSlateGray;
                }

            }
            else
            {
                _BatBar.Value = 100;
                _BatBar.Text = "unknown";
                _BatProg.Color = Color.LightSlateGray;
            }
            lTemp.Text = _BatBar.Text;
            if (bColorGlobal)
            {
                _BatBar.Font = fFontGlobal;
                lTemp.Font = fFontGlobal;
            }
            else
            {
                _BatBar.Font = fTitleFont[14];
                lTemp.Font = fTitleFont[14];
            }
            lBatLabel.Text = sTitle[14] + " " + power.PowerLineStatus.ToString() + " " + _BatBar.Value.ToString() + "%";
            //if (lBatLabel.PreferredWidth > lTemp.PreferredWidth)
            //    _BatBar.Width = lBatLabel.PreferredWidth + 10 > 110 ? lBatLabel.PreferredWidth + 10 : 110;
            //else
            //    _BatBar.Width = lTemp.PreferredWidth + 10 > 110 ? lTemp.PreferredWidth + 10 : 110;

            _BatBar.Width = _iWidth;
            _BatBar.Height = Convert.ToInt16(_BatBar.Font.GetHeight()) + 4;
            _BatBar.BringToFront();
            _BatBar.Update();
            _BatBar.Top = lBatLabel.Height;
        }

        public string top5ProcessMemory()
        {
            if (lProcessMemName == null)
                return "";
            
            var query = (from p in System.Diagnostics.Process.GetProcesses()
                         orderby p.PrivateMemorySize64 descending
                         select p)
            .Skip(0)
            .Take(5)
            .ToList();

            string s = "",t = "";
            foreach (var item in query)
            {
                s += item.ProcessName  + "\r\n";
                t += CalcSize(item.PrivateMemorySize64.ToString(), 1)  + "\r\n";
            }
            lProcessMemName.Text = s;
            lProcessMemUsage.Text = t;
            lProcessMemUsage.Left = lProcessMemName.Width + 2;

            return "";

        }
 
        public string top5ProcessCPUUsage()
        {
            System.Collections.IList plist =  processlist.top5_list;
            string s="",t="";
            if (plist != null)
            {
                foreach (ProcessData item in plist)
                {   
                    string sItemName="";
                    int iLength = item.Name.IndexOf(".exe", 0);
                    if (iLength < 1)
                        sItemName = item.Name;
                    else
                        sItemName = item.Name.Substring(0, item.Name.IndexOf(".exe", 0));
                    if (sItemName.Length > 12)
                    {
                        sItemName = sItemName.Substring(0, 11) + "...";
                        iLength = 14;
                    }
                    else
                        iLength = sItemName.Length > 12 ? 13 : sItemName.Length;
                    s += sItemName.Substring(0, iLength) + "\r\n"; //+ "(" + item.ID.ToString() + ")\r\n";
                    t += item.CpuUsage.ToString() + "%\r\n";
                }
                Label lTemp = new Label();
                lTemp.Font = lProcessName.Font;
                lTemp.Padding = new Padding(0);
                lTemp.Margin = new Padding(0);
                lTemp.AutoSize = true;
                lTemp.Text = "ABCDEFGHIJKLMN";
                lProcessName.Text = s;
                lProcessUsage.Text = t;
                lProcessUsage.Left = lTemp.PreferredWidth-25;
            }

            return "";//processlist.top5_list;
        }

        //Network
        public string Network()
        {
            if (monitor == null)
                Network_init();
            this.adapters = monitor.Adapters;

            if (adapters.Length == 0)
            {
               // MessageBox.Show("No network adapters found on this computer.");
               // iFunction[4] = -1;
                return "";
            }
                
            string s = "";
            for (int i = 0; i < adapters.Length; i++)
            {

                try
                {
                    if (!sNetAdapters.Contains(adapters[i].Name))
                    {
                        s += adapters[i].Name + "@" + adapters[i].Speed + "\r\n";
                        if (bNetIP)
                            s += "IP: " + adapters[i].IP + "\r\n";
                        if (bNetMac)
                            s += "MAC: " + adapters[i].MAC + "\r\n";
                        if (bNetMask)
                            s += "SUB: " + adapters[i].MASK + "\r\n";
                        if (bNetGW)
                            s += "GW: " + adapters[i].gateway + "\r\n";

                     }
                    if (bNetTP && !sNetAdapters.Contains(adapters[i].Name))
                    {
                        if (!monitor.MonitorActive)
                            for (int k = 0; k < adapters.Length; k++)
                                monitor.StartMonitoring(adapters[k]);
                        s += adapters[i].DownloadSpeedConv + "\r\n" +
                                adapters[i].UploadSpeedConv + "\r\n";
                        netLoad[i]._net_graph_update();
                    }
                    else
                    {
                        if (monitor.MonitorActive)
                            monitor.StopMonitoring();
                        if(netLoad[i] != null)
                            netLoad[i].NetGraphControl.Visible = false;
                    }
                    if (netLoad[i] != null)
                    {
                       // s = s.Replace("&", "&&");
                        netLoad[i]._net_label_update(s);
                        netLoad[i].NetGraphControl.Width = DPIScaling(115);
                        netLoad[i].NetGraphControl.Height = DPIScaling(31);
                    }                   
                    s = "";
                }
                catch
                { //throw;
                }
            }
            return s;
        }
        //Disk - wmi query for Win32_LogicalDisk
        public string Disk()
        {
            string s = "";
            string sLetter = "";
            string sFSType = "";
            string query = "SELECT * FROM Win32_LogicalDisk WHERE FileSystem IS NOT NULL";
            if(dcLock.TryEnterWriteLock(50))
                try
                {
                    ManagementObjectSearcher seeker = new ManagementObjectSearcher(query);
                    //seeker.Options.Timeout = TimeSpan.FromMilliseconds(100);
                    ManagementObjectCollection oReturnCollection = seeker.Get();
                    int i = 0;
                    System.Windows.Forms.Label lTemp = new System.Windows.Forms.Label(); //temporary lable for getting the necessary max size of pbar
                    lTemp.AutoSize = true;
                    foreach (ManagementObject m in oReturnCollection)
                    {
                        sLetter = m["DeviceID"].ToString();
                        sFSType = m["FileSystem"].ToString();

                        s += sLetter + " " + CalcSize(m["FreeSpace"].ToString(), 1) + " " + sFSType + "\n";

                        if (bHDDPBar == true)
                        {
                            long iFS = Convert.ToInt64(m["FreeSpace"]);
                            long iSize = Convert.ToInt64(m["Size"]);
                            if (iSize > 0)
                                _hddBar[i].Value = Convert.ToInt16((100 * (iSize - iFS) / iSize));  //percent used space: 100* (size - free space) / size
                            //if you want display free space: 100* freespace / size
                            else
                                _hddBar[i].Value = 100;

                            if (_hddBar[i].Value <= 50)
                                _pHddProg[i].Color = cColorHDDBar50;

                            if (_hddBar[i].Value > 50 && _hddBar[i].Value <= 75)
                                _pHddProg[i].Color = cColorHDDBar75;

                            if (_hddBar[i].Value > 75)
                                _pHddProg[i].Color = cColorHDDBar100;

                            lHDD[i].Text  = sLetter + " " + CalcSize(iFS.ToString(), 1) + " " + sFSType;
                            lHDD[i].Name = lHDD[i].Text + "\r\n" + "Size: " + CalcSize(iSize.ToString(), 1);  //used for tooltip text
                          //  _hddBar[i].Text = sLetter + " " + CalcSize(iFS.ToString(), 1) + " " + sFSType;
                            _hddBar[i].Name = lHDD[i].Text +"\r\n" + "Size: " + CalcSize(iSize.ToString(), 1);  //used for tooltip text

                            i++;
                        }
                    }
                    oReturnCollection.Dispose();
                    seeker.Dispose();
                    lTemp.Text = s;
                    _pHddBack.Color = cColorHDDBack;
                    for (int k = 0; k < 10; k++)
                    {
                        if (k < i)
                        {
                            if (bColorGlobal)
                            {
                                //_hddBar[k].Font = fFontGlobal;
                                lHDD[k].Font = fFontGlobal;
                                lHDD[k].ForeColor = cColorGlobal;
                                lTemp.Font = fFontGlobal;
                            }
                            else
                            {
                               // _hddBar[k].Font = fTitleFont[3];
                                lHDD[k].ForeColor = cTitleColor[3];
                                lHDD[k].Font = fTitleFont[3];
                                lTemp.Font = fTitleFont[3];
                            }
                            //_hddBar[k].Height = Convert.ToInt16(_hddBar[k].Font.GetHeight()) + 2;
                        //    _hddBar[k].Width = lTemp.PreferredWidth; //size all bars to max necessary size
                            _hddBar[k].Width = _iWidth;
                            lHDD[k].Top = (_hddBar[k].Height + lHDD[k].Height + 3) * k;
                         //   _hddBar[k].Top = _hddBar[k].Height * k;   //position the bar
                            _hddBar[k].Top = lHDD[k].Bottom;   //position the bar
                            _hddBar[k].ForeColor = cColorHDDText;
                            _hddBar[k].Visible = true;
                            _hddBar[k].BringToFront();
                            _hddBar[k].Update();
                        }
                        else
                            _hddBar[k].Visible = false;

                    }
                    lTemp.Dispose();
                    lTemp = null;

                }
                catch (Exception)
                {

                    ; ;
                }
                finally
                {
                    dcLock.ExitWriteLock();
                }
            return s;
        }

        #endregion

        #region little helpers  
    
        private static DateTime ParseCIMDateTime(string wmiDate)
        {
             //datetime object to store the return value
             DateTime date = DateTime.MinValue;
             
             //check date integrity
             if (wmiDate != null && wmiDate.IndexOf('.') != -1)
             {
                 //obtain the date with miliseconds
                 string tempDate = wmiDate.Substring(0, wmiDate.IndexOf('.') + 4);
         
                 //check the lenght
                 if (tempDate.Length == 18)
                 {
                     //extract each date component
                     int year = Convert.ToInt32(tempDate.Substring(0, 4));
                     int month = Convert.ToInt32(tempDate.Substring(4, 2));
                     int day = Convert.ToInt32(tempDate.Substring(6, 2));
                     int hour = Convert.ToInt32(tempDate.Substring(8, 2));
                     int minute = Convert.ToInt32(tempDate.Substring(10, 2));
                     int second = Convert.ToInt32(tempDate.Substring(12, 2));
                     int milisecond = Convert.ToInt32(tempDate.Substring(15, 3));
         
                     //compose the new datetime object
                     date = new DateTime(year, month, day, hour, minute, second, milisecond);        
                 }
             }
         
             //return datetime
             return date;
         }

        private int DPIScaling(int iPixel)
        {
            Graphics graphics;
            graphics = Graphics.FromHwnd(this.Handle);
            var dpiX = graphics.DpiX;
            var dpiY = graphics.DpiY;

            if (dpiX > 0)
                return (int)((float)iPixel * (dpiX / 96.0));
            else
                return iPixel;

        }

        private static string CalcSize(string sVal, int iType)
        {
            string sCalc = "";
            float Mbytes = 0;
            switch (iType)
            {
                case 1: //value is bytes
                    Mbytes = (float)(((float)Convert.ToInt64(sVal) / 1024) / 1024);
                    break;
                case 2: //value is kbytes
                    Mbytes = (float)(Convert.ToInt64(sVal) / 1024);
                    break;
            }
            if (Mbytes > 1024) 
            {
                Mbytes = Mbytes / 1024;
                sCalc = Mbytes.ToString("N2") + " GB ";
            }
            else
                sCalc = Mbytes.ToString("N2") + " MB ";
            return sCalc;
        }

        private void _Title(int iPos)
        {
            sData[iFunction[iPos]] = sTitle[iPos];
            if (sTitle[iPos] != "" && iLB[iPos])
                sData[iFunction[iPos]] += " \n";
        }

        //Networkadapter - query registry for network device name
        public string Networkadapter(ManagementObject m)
        {
            RegistryKey rK = Registry.LocalMachine;
            string s = "";

            s = m["SettingID"].ToString();
            RegistryKey rSub = rK.OpenSubKey("SYSTEM\\CurrentControlSet\\Control\\Network\\{4D36E972-E325-11CE-BFC1-08002BE10318}\\" + s + "\\Connection");
            s = rSub.GetValue("Name").ToString();
            return s;
        }

        #endregion

        #region events
        
        //moving the form
        private Point m_offset;
        private Point m_Pos;
        private void EM_MouseMove(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                m_Pos = Control.MousePosition;
                m_Pos.Offset(m_offset.X, m_offset.Y);
                Location = m_Pos;
            }
        }
        private void EM_MouseDown(object sender, MouseEventArgs e)
        {
            int x1, x2, y1, y2, dx, dy;
            x1 = Location.X;
            y1 = Location.Y;
            x2 = -MousePosition.X;
            y2 = -MousePosition.Y;
            dx = x1 + x2;
            dy = y1 + y2;
            m_offset = new Point(dx, dy);
        }

        //Show folder contents when clicking on drive progressbar
        private void PBAR_MOUSE_DOWN(object sender, EventArgs e)
        {
            string sDrive;
            int iWidth;
            if (sender is Label)
            {
                sDrive = ((Label)sender).Text;
                iWidth = ((Label)sender).Width;
            }
            else
            {
               // pBar = (ProgressODoom.ProgressBarEx)sender;
                sDrive = ((ProgressODoom.ProgressBarEx)sender).Name;
                iWidth = ((ProgressODoom.ProgressBarEx)sender).Width;
            }

            sDrive = sDrive.Remove(sDrive.IndexOf(":") + 1) + "\\";
            MouseEventArgs me = (MouseEventArgs)e;
            if (me.Button == MouseButtons.Right)
            // ShellExtensions.ShowFileProperties(sDrive);
            {
                IShellContextMenu cMenu = new IShellContextMenu();
                cMenu.iContextMenu("", sDrive, true);
            }
            else
            {
                FileBrowser fb = new FileBrowser(this, iWidth, cLabel[iFunction[3]].Top);
                fb.populateList(sDrive);
            }
        }

        //change background of form for moving when transparent
        public void label_MouseEnter(object sender, System.EventArgs e)
        {
            this.BackColor = System.Drawing.Color.FromArgb(190,5,10,40);
            timer1.Enabled = false; //disable update of controls for smooth moving of form
            contextMenuStrip1.Enabled = true;
        }
        public void label_MouseLeave(object sender, System.EventArgs e)
        {
            //Jan. 2013 - "aero" support for Win8 -> blured glas background
         //   if (System.Environment.OSVersion.Version.Major >= 6 && System.Environment.OSVersion.Version.Minor >= 2 && DwmIsCompositionEnabled() && bAero)
            if (System.Environment.OSVersion.Version.Major >= 6 && DwmIsCompositionEnabled() && bAero)
                this.BackColor = cAero;
            else
                this.BackColor = System.Drawing.Color.FromArgb(2, 2,2);
            timer1.Enabled = true;
       }
 
        //update events
        private void timer1_Tick(object sender, EventArgs e)
        {
            _update_visuals();
        }
        private void updateToolStripMenuItem_Click(object sender, EventArgs e)
        {
            _Init();
            _update_visuals();
        }

        //show settings
        void Form1_DoubleClick(object sender, System.EventArgs e)
        {
            settingsDialog();
        }
        private void settingsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            settingsDialog();
        }
        private void lable_DoubleClick(object sender, EventArgs e)
        {
            settingsDialog();
        }

        private void SettingsDelToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Properties.Settings.Default.Reset();
            System.Threading.Thread.CurrentThread.CurrentUICulture = new System.Globalization.CultureInfo(Properties.Settings.Default.lang);
            updateStringRessource(Properties.Settings.Default.lang);
            _hddBar.Initialize();
            pPBar.Controls.Clear();
            _hddBarInit();
            loadSettings();
            _Init();
            _update_visuals();
        }

        private void saveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            saveSettings();
        }

        private void hideToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (Visible)
            {
                Visible = false;
                if (System.Threading.Thread.CurrentThread.CurrentUICulture.ToString() == "de-DE")
                    hideToolStripMenuItem.Text = "Anzeigen";
                else
                    hideToolStripMenuItem.Text = "show";
            }
            else
            {
                Visible = true;
                if (System.Threading.Thread.CurrentThread.CurrentUICulture.ToString() == "de-DE")
                    hideToolStripMenuItem.Text = "Ausblenden";
                else
                    hideToolStripMenuItem.Text = "hide";
            }

        }


        #region pBar context & toolstrip
        void pbar_MouseEnter(object sender, System.EventArgs e)
        {
            ProgressODoom.ProgressBarEx pBar = (ProgressODoom.ProgressBarEx)sender;
            toolTip1.Show(pBar.Name.ToString(), (ProgressODoom.ProgressBarEx)sender);
            contextMenuStrip1.Enabled = false;  //Workaround to get the drive properties displayed instead of general context menu
        }
        void pbar_MouseLeave(object sender, System.EventArgs e)
        {
            toolTip1.Hide((ProgressODoom.ProgressBarEx)sender);
        }
        void pLabel_MouseEnter(object sender, System.EventArgs e)
        {
            Label pBar = (Label)sender;
            toolTip1.Show(pBar.Name.ToString(), (Label)sender);
            contextMenuStrip1.Enabled = false;  //Workaround to get the drive properties displayed instead of general context menu
        }
        void pLabel_MouseLeave(object sender, System.EventArgs e)
        {
            toolTip1.Hide((Label)sender);
        }
        private void contextMenuStrip1_Opening(object sender, System.ComponentModel.CancelEventArgs e)
        {
            if(contextMenuStrip1.Enabled == false)
            {
                e.Cancel = true; 
            }
            return;


        }
        #endregion

        private void lockedToolStripMenuItem_Click(object sender, EventArgs e)
        {
            _sendToBack();
        }

        private void exitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (monitor != null)
                monitor.MonitorsClear();
            if (netTimer != null)
                netTimer.Dispose();
            if (alDiskUsage != null)
                foreach (DiskUsage d in alDiskUsage)
                    d.dispose();
            if (lProcessMemName != null)
                lProcessMemName.Dispose();
            if (lProcessMemUsage != null)
                lProcessMemUsage.Dispose();
            if (processlist != null)
                processlist.dispose();
            if (lProcessName != null)
                lProcessName.Dispose();
            if (lProcessUsage != null)
                lProcessUsage.Dispose();
            if (cpuLoad != null)
            {
                cpuLoad.dispose();
                cpuLoad = null;
            }

            saveSettings();
            Dispose(true);
            Close();
        }

        //in case of network address change or new adapter -> reinits the monitors
        void AddressChangedCallback(object sender, EventArgs e) 
        {
            tsNet = DateTime.Now.Subtract(dtNet);
            if (iFunction[4] > -1 && tsNet.TotalSeconds > 4) //still testing: on some systems it's called too often on others too little
               this.ExecuteThreadSafe(Network_init); //needs invoking as this seems to be running on a different thread...? 
        }

        //try to catch the 'real' boot date... hybernate and hybrid standby make this a bit difficult
        public void SystemEvents_PowerModeChanged(object sender, PowerModeChangedEventArgs e) 
        {
            if (e.Mode == PowerModes.Resume)
                if (eqBootUpDate != null)
                    eqBootUpDate.Refresh();
           // MessageBox.Show(e.Mode.ToString());
        }


        #region background
        //Paint background if selected
        private void Form1_Paint(object sender, PaintEventArgs e)
        {
            if ((!bTransparency & !bAero) | (bAero & (bAeroTexture|bAeroGradient)))
            {
                Rectangle BaseRectangle =
                    new Rectangle(0, 0, this.Width, this.Height);
                if (bGradient | (bAero&bAeroGradient))
                {

                    Color c1 = cColorB1, c2 = cColorB2;
                        
                    if (bAero & bAeroGradient)
                    {
                        c1 = Color.FromArgb((byte)(fAeroTransparency * (float)255),c1);
                        c2 = Color.FromArgb((byte)(fAeroTransparency * (float)255),c2);
                    }
                    Brush Gradient_Brush =
                        new LinearGradientBrush(
                        BaseRectangle,
                        c1,
                        c2,
                        iGradAngle);

                    e.Graphics.FillRectangle(Gradient_Brush, BaseRectangle);
                }
                else
                {
                    Image ImageBack = null;

                        if (imageBackG != null)
                            ImageBack = imageBackG;
                        else
                            ImageBack = Properties.Resources.grey;

                        System.Drawing.Imaging.ImageAttributes imageAttributes = new System.Drawing.Imaging.ImageAttributes();
                        float[][] colorMatrixElements = { 
                           new float[] {fRedScale,  0,  0,  0, 0},        // red scaling factor
                           new float[] {0,  fGreenScale,  0,  0, 0},        // green scaling factor
                           new float[] {0,  0,  fBlueScale,  0, 0},        // blue scaling factor
                           new float[] {0,  0,  0,  1f, 0},        // alpha scaling factor of 1
                           new float[] {fRed, fGreen, fBlue, 0, 0}};    // three translations

                        System.Drawing.Imaging.ColorMatrix colorMatrix = new System.Drawing.Imaging.ColorMatrix(colorMatrixElements);

                        imageAttributes.SetColorMatrix(
                           colorMatrix,
                           System.Drawing.Imaging.ColorMatrixFlag.Default,
                           System.Drawing.Imaging.ColorAdjustType.Bitmap);
                        
                        if(bAero & bAeroTexture)
                            ImageBack = ChangeImageOpacity(ImageBack, fAeroTransparency);

                        int width = ImageBack.Width;
                        int height = ImageBack.Height;

                        if (width > this.Width)
                        {
                            ImageBack.RotateFlip(System.Drawing.RotateFlipType.Rotate180FlipNone);
                            ImageBack.RotateFlip(System.Drawing.RotateFlipType.Rotate180FlipNone);
                            height = (height * this.Width) / width;
                            width = this.Width;
                            ImageBack = ImageBack.GetThumbnailImage(width, height, null, IntPtr.Zero);

                        }
                         if (bBGImageFill)
                            e.Graphics.DrawImage(
                               ImageBack,
                               BaseRectangle,
                               0, 0,        // upper-left corner of source rectangle 
                               width,       // width of source rectangle
                               height,      // height of source rectangle
                               GraphicsUnit.Pixel,
                               imageAttributes);
                        else
                        {
                            imageAttributes.SetWrapMode(System.Drawing.Drawing2D.WrapMode.Tile);
                            Rectangle brushRect = new Rectangle(0, 0, width, height);
                            TextureBrush tBrush = new TextureBrush(ImageBack, brushRect, imageAttributes);
                            e.Graphics.FillRectangle(tBrush, BaseRectangle);
                            tBrush.Dispose();
                        }
                        ImageBack = null;
                    //}
                   // e.Graphics.DrawImage(ImageBack, BaseRectangle);
                }
            }

            //else
            //{
            //    Image ImageBack = null;
            //    Rectangle BaseRectangle =
            //        new Rectangle(0, 0, this.Width, this.Height);

            //    if (imageBackG != null)
            //        ImageBack = imageBackG;
            //    else
            //        ImageBack = Properties.Resources.grey;

            //    ImageBack = ChangeImageOpacity(ImageBack, fAeroTransparency);

            //    int width = ImageBack.Width;
            //    int height = ImageBack.Height;

            //    if (width > this.Width)
            //    {
            //        ImageBack.RotateFlip(System.Drawing.RotateFlipType.Rotate180FlipNone);
            //        ImageBack.RotateFlip(System.Drawing.RotateFlipType.Rotate180FlipNone);
            //        height = (height * this.Width) / width;
            //        width = this.Width;
            //        ImageBack = ImageBack.GetThumbnailImage(width, height, null, IntPtr.Zero);

            //    }
            //    System.Drawing.Imaging.ImageAttributes imageAttributes = new System.Drawing.Imaging.ImageAttributes();
            //    if (bBGImageFill)
            //        e.Graphics.DrawImage(
            //           ImageBack,
            //           BaseRectangle,
            //           0, 0,        // upper-left corner of source rectangle 
            //           width,       // width of source rectangle
            //           height,      // height of source rectangle
            //           GraphicsUnit.Pixel,
            //           imageAttributes);
            //    else
            //    {
            //        imageAttributes.SetWrapMode(System.Drawing.Drawing2D.WrapMode.Tile);
            //        Rectangle brushRect = new Rectangle(0, 0, width, height);
            //        TextureBrush tBrush = new TextureBrush(ImageBack, brushRect, imageAttributes);
            //        e.Graphics.FillRectangle(tBrush, BaseRectangle);
            //        tBrush.Dispose();
            //    }

            //    ImageBack = null;
            //    //}
            //    // e.Graphics.DrawImage(ImageBack, BaseRectangle);
            //}
        }

        private const int bytesPerPixel = 4;

        /// <summary>
        /// Change the opacity of an image
        /// </summary>
        /// <param name="originalImage">The original image</param>
        /// <param name="opacity">Opacity, where 1.0 is no opacity, 0.0 is full transparency</param>
        /// <returns>The changed image</returns>
        public static Image ChangeImageOpacity(Image originalImage, double opacity)
        {
            if ((originalImage.PixelFormat & System.Drawing.Imaging.PixelFormat.Indexed) == System.Drawing.Imaging.PixelFormat.Indexed)
            {
                // Cannot modify an image with indexed colors
                return originalImage;
            }

            Bitmap bmp = (Bitmap)originalImage.Clone();

            // Specify a pixel format.
            System.Drawing.Imaging.PixelFormat pxf = System.Drawing.Imaging.PixelFormat.Format32bppArgb;

            // Lock the bitmap's bits.
            Rectangle rect = new Rectangle(0, 0, bmp.Width, bmp.Height);
            System.Drawing.Imaging.BitmapData bmpData = bmp.LockBits(rect, System.Drawing.Imaging.ImageLockMode.ReadWrite, pxf);

            // Get the address of the first line.
            IntPtr ptr = bmpData.Scan0;

            // Declare an array to hold the bytes of the bitmap.
            // This code is specific to a bitmap with 32 bits per pixels 
            // (32 bits = 4 bytes, 3 for RGB and 1 byte for alpha).
            int numBytes = bmp.Width * bmp.Height * bytesPerPixel;
            byte[] argbValues = new byte[numBytes];

            // Copy the ARGB values into the array.
            System.Runtime.InteropServices.Marshal.Copy(ptr, argbValues, 0, numBytes);

            // Manipulate the bitmap, such as changing the
            // RGB values for all pixels in the the bitmap.
            for (int counter = 0; counter < argbValues.Length; counter += bytesPerPixel)
            {
                // argbValues is in format BGRA (Blue, Green, Red, Alpha)

                // If 100% transparent, skip pixel
                if (argbValues[counter + bytesPerPixel - 1] == 0)
                    continue;

                int pos = 0;
                pos++; // B value
                pos++; // G value
                pos++; // R value

                argbValues[counter + pos] = (byte)(argbValues[counter + pos] * opacity);
            }

            // Copy the ARGB values back to the bitmap
            System.Runtime.InteropServices.Marshal.Copy(argbValues, 0, ptr, numBytes);

            // Unlock the bits.
            bmp.UnlockBits(bmpData);

            return bmp;
        }


        private void Form1_Resize(object sender, EventArgs e)
        {
            // Check to see if composition is Enabled / enable background blurring if selected
            if (System.Environment.OSVersion.Version.Major >= 6 && DwmIsCompositionEnabled())
            {
                IntPtr hr = IntPtr.Zero; //CreateRectRgn(0, 0, this.Width, this.Height);
                DWM_BLURBEHIND dbb;
                dbb.fEnable = bAero;
                dbb.dwFlags = 1;// | 2;
                dbb.hRgnBlur = hr;
                dbb.fTransitionOnMaximized = true;
                DwmEnableBlurBehindWindow(this.Handle, ref dbb);
                //------Jan. 2013 - "aero" support for Win8----------------
                if ((System.Environment.OSVersion.Version.Minor >= 2)|(bFrameChecked&&!bFrameType&&bAeroFrame))
                    DwmExtendFrameIntoClientArea(Handle, new Margins { cxLeftWidth = -1, cxRightWidth = -1, cyTopHeight = -1, cyBottomHeight = -1 });

              //  this.Invalidate();
             //   System.Runtime.InteropServices.Marshal.Release(dbb.hRgnBlur);
            }
           // else
           // {
                this.Invalidate();
          //  }

        }   
        private void transparentToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (transparentToolStripMenuItem.Checked)
            {
                bTransparency = true;
                gradientToolStripMenuItem.Checked =
                    bGradient =
                    aeroEffektabVistaToolStripMenuItem.Checked =
                    bAero =
                    bTexture = 
                    bTextureBlue = 
                    bTextureGrey = 
                    //textureBlueToolStripMenuItem.Checked = 
                    //textureGreyToolStripMenuItem.Checked = 
                    textureToolStripMenuItem.Checked = false;
                backgroundsettings_save();
                this.RecreateHandle();
            }
            else
                transparentToolStripMenuItem.Checked = true;
        }
        private void aeroEffektabVistaToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (aeroEffektabVistaToolStripMenuItem.Checked)
            {
                bAero = true;
                gradientToolStripMenuItem.Checked =
                    transparentToolStripMenuItem.Checked =
                    bTransparency =
                    bGradient =
                    bTexture = 
                    bTextureBlue = 
                    bTextureGrey = 
                    //textureBlueToolStripMenuItem.Checked = 
                    //textureGreyToolStripMenuItem.Checked = 
                    textureToolStripMenuItem.Checked = false;
                backgroundsettings_save();
                this.RecreateHandle();
            }
            else
                aeroEffektabVistaToolStripMenuItem.Checked = true;

        }
        private void gradientToolStripMenuItem_Click(object sender, EventArgs e)
        {
            
            if (gradientToolStripMenuItem.Checked)
            {
                bGradient = true;
                bTransparency = 
                    transparentToolStripMenuItem.Checked =
                    aeroEffektabVistaToolStripMenuItem.Checked =
                    bAero =
                    bTexture = 
                    bTextureBlue = 
                    bTextureGrey = 
                    //textureBlueToolStripMenuItem.Checked = 
                    //textureGreyToolStripMenuItem.Checked = 
                    textureToolStripMenuItem.Checked = 
                    false;
                backgroundsettings_save();
                this.RecreateHandle();
            }
            else
                gradientToolStripMenuItem.Checked = true;
        }
        //private void textureBlueToolStripMenuItem_Click(object sender, EventArgs e)
        //{
        //    if (textureBlueToolStripMenuItem.Checked)
        //    {
        //        bTextureBlue = 
        //            bTexture = 
        //            textureToolStripMenuItem.Checked = 
        //            true;
        //        bTransparency = 
        //            transparentToolStripMenuItem.Checked =
        //            aeroEffektabVistaToolStripMenuItem.Checked =
        //            bAero =
        //            bTextureGrey = 
        //            textureGreyToolStripMenuItem.Checked = 
        //            gradientToolStripMenuItem.Checked = 
        //            bGradient = 
        //            false;
        //        backgroundsettings_save();
        //        this.RecreateHandle();
        //    }
        //    else
        //        textureBlueToolStripMenuItem.Checked = true;

        //}
        //private void textureGreyToolStripMenuItem_Click(object sender, EventArgs e)
        //{
        //    if(textureGreyToolStripMenuItem.Checked)
        //    {
        //        bTextureGrey = 
        //            bTexture = 
        //            textureToolStripMenuItem.Checked = 
        //            textureGreyToolStripMenuItem.Checked = 
        //            true;
        //        bTransparency = 
        //            transparentToolStripMenuItem.Checked =
        //            aeroEffektabVistaToolStripMenuItem.Checked =
        //            bAero =
        //            bTextureBlue = 
        //            textureBlueToolStripMenuItem.Checked = 
        //            gradientToolStripMenuItem.Checked = 
        //            bGradient = 
        //            false;
        //        backgroundsettings_save();
        //        this.RecreateHandle();
        //    }
        //    else
        //        textureGreyToolStripMenuItem.Checked = true;

        //}
        private void textureToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (textureToolStripMenuItem.Checked)
            {
                    bTexture =
                    textureToolStripMenuItem.Checked =
                    true;
                bTransparency =
                    transparentToolStripMenuItem.Checked =
                    aeroEffektabVistaToolStripMenuItem.Checked =
                    bAero =
                    gradientToolStripMenuItem.Checked =
                    bGradient =
                    false;
                backgroundsettings_save();
                this.RecreateHandle();
            }
        }

        private void backgroundsettings_save()
        {
            Properties.Settings.Default.f1bBckgrTex = bTexture;
            Properties.Settings.Default.f1bBckgrTexBlue = bTextureBlue;
            Properties.Settings.Default.f1bBckgrTexGrey = bTextureGrey;
            Properties.Settings.Default.f1bBckgrGrad = bGradient;
            Properties.Settings.Default.f2Transparency = bTransparency;
            Properties.Settings.Default.f2Aero = bAero;
            Properties.Settings.Default.f1bAeroFrame = bAeroFrame;
        }
        #endregion

        #endregion

        #region Form border

        public const int WS_EX_TOOLWINDOW = 0x00000080; //Window with a thin caption. Does not appear in the taskbar or in the Alt-Tab palette --as "WS_CAPTION" is not defined NO border is drawn BUT app is removed from ALT-TAB ;-)
        public const int WS_THICKFRAME = 0x800000; //window with a "sizing" border
        public const int WS_BORDER = 0x00040000; //window with a thin-line border

        //Displaying a frame if selected - uses gui api
        protected override CreateParams CreateParams
        {
            get
            {
                new System.Security.Permissions.SecurityPermission(System.Security.Permissions.SecurityPermissionFlag.UnmanagedCode).Demand();
                CreateParams cp = base.CreateParams;
                if (bFrameChecked)
                {
                    cp.Style |= bFrameType ? WS_THICKFRAME : WS_BORDER; 
                }
                cp.ExStyle |= WS_EX_TOOLWINDOW; 

                return cp;
            }
        }

        private void borderToolStripMenuItem_Click(object sender, EventArgs e)
        {
            bFrameChecked = borderTS.Checked;
            this.RecreateHandle();
            borderTS.Checked = bFrameChecked;
            Properties.Settings.Default.f1bFrameChecked = bFrameChecked;
            Properties.Settings.Default.Save();
        }
        private void thinBorderTS_Click(object sender, EventArgs e)
        {
            thickBorderTS.Checked = thinBorderTS.Checked ? false:true;
            bFrameType = thinBorderTS.Checked;
            if (bFrameType)
            {
                bAeroFrame = false;
                aeroSpecialabVistaToolStripMenuItem.Checked = false;
            }
            this.RecreateHandle();
            Properties.Settings.Default.f1bFrameType = bFrameType;
            Properties.Settings.Default.Save();
        }
        private void thickBorderTS_Click(object sender, EventArgs e)
        {
            thinBorderTS.Checked = thickBorderTS.Checked ? false:true; 
            bFrameType = thinBorderTS.Checked;
            this.RecreateHandle();
            Properties.Settings.Default.f1bFrameType = bFrameType;
            Properties.Settings.Default.Save();
        }
        private void aeroSpecialabVistaToolStripMenuItem_Click(object sender, EventArgs e)
        {
            bAeroFrame = aeroSpecialabVistaToolStripMenuItem.Checked;
            if(bAeroFrame)
                thickBorderTS.Checked = true;
            thickBorderTS_Click(null, null);
        }
        #endregion

        #region windowapi

        //Override windowmessages to receive hardware events
        //triggers un/docking of removable devices etc.
        //reinits diskusage (when activated)
        private const UInt32 WM_DEVICECHANGE = 0x0219;
        private const UInt32 DBT_DEVICEARRIVAL = 0x8000;
        private const UInt32 DBT_DEVICEREMOVECOMPLETE = 0x8004;
        protected override void WndProc(ref Message m)
        {
            if (iFunction[13] > -1 && m.Msg == WM_DEVICECHANGE) 
            {
                if (m.WParam.ToInt32() == DBT_DEVICEARRIVAL || m.WParam.ToInt32() == DBT_DEVICEREMOVECOMPLETE)
                {
                    Action action = _diskusage_init;
                    this.BeginInvoke(action);
                }
            }
            base.WndProc(ref m);
        }
        
        #region DesktopWindowManager (DWM)

//------Jan. 2013 - "aero" support for Win8----------------

        [DllImport("dwmapi.dll")]
        public static extern void DwmExtendFrameIntoClientArea(IntPtr hWnd, Margins pMargins);
        
        [StructLayout(LayoutKind.Sequential)]
        public class Margins
        { public int cxLeftWidth, cxRightWidth, cyTopHeight, cyBottomHeight;}

//--------------------------------------------------------        

        [System.Runtime.InteropServices.DllImport("dwmapi.dll", PreserveSig = false)]
        public static extern bool DwmIsCompositionEnabled();

        [System.Runtime.InteropServices.DllImport("dwmapi")]
        private static extern int DwmEnableBlurBehindWindow(
                    System.IntPtr hWnd, ref DWM_BLURBEHIND pBlurBehind);

        [System.Runtime.InteropServices.DllImport("gdi32.dll")]
        static extern IntPtr CreateRectRgn(int x1, int y1, int x2, int y2);

        public struct DWM_BLURBEHIND
        {
            public int dwFlags;
            public bool fEnable;
            public System.IntPtr hRgnBlur;//HRGN
            public bool fTransitionOnMaximized;
        }
        #endregion


        bool _bDesktopBack = false;
        Point _pLastLocation;
        void _sendToBack()  //Aug. 2015 - support for sending form behind desktop icons resulting in a completly locked state
        {
            if (!_bDesktopBack)
            {
                _pLastLocation = Location; //remember last position - necessary when using multiple screens 

                // * Following code is taken from "Draw Behind Desktop Icons in Windows 8"
                // * http://www.codeproject.com/Articles/856020/Draw-behind-Desktop-Icons-in-Windows
                // * 
                // * by Gerald Degeneve (http://www.codeproject.com/script/Membership/View.aspx?mid=8529137)
                // * 
                // * Thanks a lot Gerald! Really awsome cool ;)
                // * 

                // Fetch the Progman window
                IntPtr progman = W32.FindWindow("Progman", null);

                IntPtr result = IntPtr.Zero;

                // Send 0x052C to Progman. This message directs Progman to spawn a 
                // WorkerW behind the desktop icons. If it is already there, nothing 
                // happens.
                W32.SendMessageTimeout(progman,
                                        0x052C,
                                        new IntPtr(0),
                                        IntPtr.Zero,
                                        W32.SendMessageTimeoutFlags.SMTO_NORMAL,
                                        1000,
                                        out result);

                IntPtr workerw = IntPtr.Zero;

                // We enumerate all Windows, until we find one, that has the SHELLDLL_DefView 
                // as a child. 
                // If we found that window, we take its next sibling and assign it to workerw.
                W32.EnumWindows(new W32.EnumWindowsProc((tophandle, topparamhandle) =>
                {
                    IntPtr p = W32.FindWindowEx(tophandle,
                                                IntPtr.Zero,
                                                "SHELLDLL_DefView",
                                                IntPtr.Zero);

                    if (p != IntPtr.Zero)
                    {
                        // Gets the WorkerW Window after the current one.
                        workerw = W32.FindWindowEx(IntPtr.Zero,
                                                    tophandle,
                                                    "WorkerW",
                                                    IntPtr.Zero);
                    }

                    return true;
                }), IntPtr.Zero);
                // We now have the handle of the WorkerW behind the desktop icons.
                // We can use it to create a directx device to render 3d output to it, 
                // we can use the System.Drawing classes to directly draw onto it, 
                // and of course we can set it as the parent of a windows form.
                //
                // There is only one restriction. The window behind the desktop icons does
                // NOT receive any user input. So if you want to capture mouse movement, 
                // it has to be done the LowLevel way (WH_MOUSE_LL, WH_KEYBOARD_LL).

                // ************************************************************************************************

                W32.SetParent(Handle, workerw);
                MoveWindow(Handle, _pLastLocation.X + (_pLastLocation.X - Location.X), _pLastLocation.Y + (_pLastLocation.Y - Location.Y), Width, Height, true); //necessary when using multiple screens
                _bDesktopBack = true;
                lockedToolStripMenuItem.Checked = true;
                _Init();
                _update_visuals();
            }
            else
            {
                W32.SetParent(Handle, IntPtr.Zero);
                //restore wallpaper
              //  W32.SystemParametersInfo(W32.SPI_SETDESKWALLPAPER, 0, null, W32.SPIF_UPDATEINIFILE);
                MoveWindow(Handle, _pLastLocation.X, _pLastLocation.Y, Width, Height, true);
                _bDesktopBack = false;
                lockedToolStripMenuItem.Checked = false;
                _Init();
                _update_visuals();

            }
        }

        [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall, ExactSpelling = true, SetLastError = true)]
        internal static extern void MoveWindow(IntPtr hwnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);


        #endregion

/*
        private void hideToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (Visible)
            {
                Visible = false;
                if(System.Threading.Thread.CurrentThread.CurrentUICulture.ToString() == "de-DE")
                    hideToolStripMenuItem.Text = "Anzeigen";
                else
                    hideToolStripMenuItem.Text = "show";
            }
            else
            {
                Visible = true;
                if(System.Threading.Thread.CurrentThread.CurrentUICulture.ToString() == "de-DE")
                    hideToolStripMenuItem.Text = "Ausblenden";
                else
                    hideToolStripMenuItem.Text = "hide";
            }

        }
*/

    }
}