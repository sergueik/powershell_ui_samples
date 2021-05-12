//============================================================================
// SYSInfo 2.0
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

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace SYSInfo
{
    public partial class Form2 : Form
    {
        private Form1 f1;
        int[] _functionOrder = new int[20];
        string[] sTitle = new string[20];
        Color[] cTitleColor = new Color[20];
        Font[] fTitleFont = new Font[20];
        bool[] bLBr = new bool[20];
        bool bColorGlobal, bBGIFill;
        float fRed = 0f, fGreen = 0f, fBlue = 0f, fRedScale = 1f, fGreenScale = 1f, fBlueScale = 1f;
        Image imageBackG = null;
        string sImageBackFilename = "";
        int iTBarScaleAll = 0,iTBarAll = 0;
        //public bool[] iLBHist = new bool[20];
        //public string[] sTitleHist = new string[20];

        public Form2(Form1 _ref)
        {
            InitializeComponent();
            this.f1 = _ref; // der Form2 eine referenz auf Form1 uebergeben

        }

        private void Form2_Load(object sender, EventArgs e)
        {
            //_setLocation();
            settingsLoad();
        }

        private void _setLocation()
        {
            Size sScreen = Screen.PrimaryScreen.Bounds.Size;
            Size iLSize = f1.Size;
            Size iFSize = this.Size;
            Point pPos = f1.DesktopLocation;

            if (pPos.X < sScreen.Width / 2) //left half of screen
            {
                if (pPos.Y < sScreen.Height / 2)    //top
                    this.SetDesktopLocation((sScreen.Width / 2) - iFSize.Width, (sScreen.Height / 2) - iFSize.Height);  //
                else
                    this.SetDesktopLocation((sScreen.Width / 2) - iFSize.Width, (sScreen.Height / 2));
            }
            else    //right half of screen
            {
                if (pPos.Y < sScreen.Height / 2)    //top
                    this.SetDesktopLocation((sScreen.Width / 2), (sScreen.Height / 2) - iFSize.Height);
                else
                    this.SetDesktopLocation((sScreen.Width / 2), (sScreen.Height / 2));
            }

        }

        private void settingsLoad()
        {
            _LBFill();
            _initArrays();
            bColorGlobal = Properties.Settings.Default.f2ColorGlobal;
            cbColorGlobal.Checked = bColorGlobal;
            colorbox.BackColor = Properties.Settings.Default.f1TextColor;
            label4.Text = Properties.Settings.Default.f1Text.Name;
            label4.Font = Properties.Settings.Default.f1Text;
            timerIntervall.Value = Properties.Settings.Default.f2Timer;
            colorB1.BackColor = Properties.Settings.Default.f2ColorB1;
            colorB2.BackColor = Properties.Settings.Default.f2ColorB2;
            colorAero.BackColor = Properties.Settings.Default.f1CAero;
            tbAeroTransparency.Value = (int)(Properties.Settings.Default.fAeroTrans * 10);
            cbAeroGradient.Checked=Properties.Settings.Default.bAeroGrad;
            cbAeroTexture.Checked= Properties.Settings.Default.bAeroTextured;
            numericUpDownAngel.Value = Properties.Settings.Default.f2GradAngle;
            cBoxHDDText.BackColor = Properties.Settings.Default.f1HDDTextCol;
            cBoxHDDBack.BackColor = Properties.Settings.Default.f1HDDBackCol;
            cBoxHddBar50.BackColor = Properties.Settings.Default.f1HDDBarCol50;
            cBoxHddBar75.BackColor = Properties.Settings.Default.f1HDDBarCol75;
            cBoxHddBar100.BackColor = Properties.Settings.Default.f1HDDBarCol100;
            cbHDDBar.Checked = Properties.Settings.Default.f1HDDBarShow;
            cbNetTP.Checked = Properties.Settings.Default.f2NetTP;
            cbNetIP.Checked = Properties.Settings.Default.f2NetIP;
            cbNetGW.Checked = Properties.Settings.Default.f2NetGW;
            cbNetMask.Checked = Properties.Settings.Default.f2NetSUB;
            cbNetMAC.Checked = Properties.Settings.Default.f2NetMAC;
            timerNet.Value = Properties.Settings.Default.f2TimerNet;
            timespanNet.Value = Properties.Settings.Default.f2TimespanNet;
            cbCPUGraph.Checked = Properties.Settings.Default.f2CPU;
            cbCPUText.Checked = Properties.Settings.Default.f2CPUText;
            cbCPUTotal.Checked = Properties.Settings.Default.f2CPUTotal;
            timerCPU.Value = Properties.Settings.Default.f2TimerCPU;
            timespanCPU.Value = Properties.Settings.Default.f2TimspanCPU;
            timerDiskUsage.Value = Properties.Settings.Default.f2TimerDiskUsage;
            timespanDiskUsage.Value = Properties.Settings.Default.f2TimespanDiskUsage;
            fRed = Properties.Settings.Default.f1BGImageRed;
            fGreen = Properties.Settings.Default.f1BGImageGreen;
            fBlue = Properties.Settings.Default.f1BGImageBlue;
            fRedScale = Properties.Settings.Default.f1BGImageRedScale;
            fGreenScale = Properties.Settings.Default.f1BGImageGreenScale;
            fBlueScale = Properties.Settings.Default.f1BGImageBlueScale;
            tBarR.Value = (int)(fRed * 100);
            tBarG.Value=  (int)(fGreen * 100);
            tBarB.Value=  (int)(fBlue * 100);
            tBarRScale.Value = (int)(fRedScale * 100);
            tBarGScale.Value=  (int)(fGreenScale * 100);
            tBarBScale.Value=  (int)(fBlueScale * 100);
            sImageBackFilename = Properties.Settings.Default.f1BGImage;
            bBGIFill = Properties.Settings.Default.f1BGImageFill;
            cbMemBar.Checked = Properties.Settings.Default.f1bMemBar;
            cBoxMemBack.BackColor = Properties.Settings.Default.f1MemBackCol;
            cBoxMemBar100.BackColor = Properties.Settings.Default.f1MemBarCol100;
            cBoxMemBar75.BackColor = Properties.Settings.Default.f1MemBarCol75;
            cBoxMemBar50.BackColor = Properties.Settings.Default.f1MemBarCol50;

            cbNetAdap1.Text = f1.adapters != null && f1.adapters.Length > 0 ? f1.adapters[0].Name : "Adapter1";
            cbNetAdap2.Text = f1.adapters != null && f1.adapters.Length > 1 ? f1.adapters[1].Name : "Adapter2";
            cbNetAdap3.Text = f1.adapters != null && f1.adapters.Length > 2 ? f1.adapters[2].Name : "Adapter3";
            cbNetAdap4.Text = f1.adapters != null && f1.adapters.Length > 3 ? f1.adapters[3].Name : "Adapter4";
            cbNetAdap1.Checked = Properties.Settings.Default.f2NetAdap.Contains(cbNetAdap1.Text);
            cbNetAdap2.Checked = Properties.Settings.Default.f2NetAdap.Contains(cbNetAdap2.Text);
            cbNetAdap3.Checked = Properties.Settings.Default.f2NetAdap.Contains(cbNetAdap3.Text);
            cbNetAdap4.Checked = Properties.Settings.Default.f2NetAdap.Contains(cbNetAdap4.Text);

            foreach (string s in f1.lHDDHidden)
                lbHDDHidden.Items.Add(s);

            foreach (string s in f1.lHDDSys)
                lbHDDSys.Items.Add(s);


             if (sImageBackFilename != "")
            {
                System.IO.FileInfo image = new System.IO.FileInfo(sImageBackFilename);
                if (image.Exists)
                {
                    imageBackG = Image.FromFile(sImageBackFilename);
                    pBox.BackgroundImage = imageBackG;
                }
            }
        }

        private void _LBFill()
        {
            string sText;
            string [] sDelim = { "\r\n" };
            string[] sComboArr;

            if(Properties.Settings.Default.lang == "de-DE")
                sText = Properties.Settings.Default["f2LBAvailable"].ToString();
            else
                sText = Properties.Settings.Default["f2LBAvailable_GB"].ToString();
            sComboArr = sText.Split(sDelim, StringSplitOptions.RemoveEmptyEntries);
            lbAvailable.Items.AddRange(sComboArr);
        }



        private void _initArrays()
        {
            for (int i = 0; i < 20; i++)
            {
                int iFind = Array.IndexOf(f1.iFunction, i);
                if (iFind > -1)
                {
                    _functionOrder[i] = iFind;
                    sTitle[i] = f1.sTitle[iFind];
                    lbTitle.Items.Add(sTitle[i]);
                    bLBr[i] = f1.iLB[iFind];
                    cTitleColor[i] = f1.cTitleColor[iFind];
                    fTitleFont[i] = f1.fTitleFont[iFind];
                    lbActive.Items.Add(lbAvailable.Items[iFind]);   //2010.09.09 language change fix

                    //sTitleHist[i] = f1.sTitleHist[iFind]; //idea of saving former set titles...
                    //iLBHist[i] = f1.iLBHist[iFind];
                }
                else
                {
                    _functionOrder[i] = -1;
                    sTitle[i] = "";
                    bLBr[i] = false;
                }
            }
        }
        
        private void bCancel_Click(object sender, EventArgs e)
        {
            _user_save();
            f1.loadSettings();
            f1._Init();
            f1._update_visuals();

            Close();
            Dispose();
        }

        private void bTest_Click(object sender, EventArgs e)  //Test
        {

            _TestSettings();
            f1._Init();
            f1._update_visuals();
            bReset.Enabled = true;

        }

        private void _TestSettings()
        {
            for (int i = 0; i < 20; i++)
            {
                f1.iFunction[i] = Array.IndexOf(_functionOrder, i);
                if (f1.iFunction[i] > -1)
                {
                    f1.sTitle[i] = sTitle[f1.iFunction[i]];
                    f1.iLB[i] = bLBr[f1.iFunction[i]];
                    //else
                    //{
                    f1.cTitleColor[i] = cTitleColor[f1.iFunction[i]];
                    f1.fTitleFont[i] = fTitleFont[f1.iFunction[i]];
                    //}
                    //f1.sTitleHist[i] = sTitleHist[f1.iFunction[i]];
                    //f1.iLBHist[i] = iLBHist[f1.iFunction[i]];
                }
                else
                {
                    f1.sTitle[i] = "";
                    f1.iLB[i] = false;
                }
            }
            if (bColorGlobal)
            {
                f1.cColorGlobal = colorbox.BackColor;
                f1.fFontGlobal = label4.Font;
            }
            f1.bColorGlobal = bColorGlobal;
            f1.cColorHDDBack = cBoxHDDBack.BackColor;
            f1.cColorHDDText = cBoxHDDText.BackColor;
            f1.cColorHDDBar50 = cBoxHddBar50.BackColor;
            f1.cColorHDDBar75 = cBoxHddBar75.BackColor;
            f1.cColorHDDBar100 = cBoxHddBar100.BackColor;
            f1.cColorMemBack = cBoxMemBack.BackColor;
            f1.cColorMemBar100 = cBoxMemBar100.BackColor;
            f1.cColorMemBar75 = cBoxMemBar75.BackColor;
            f1.cColorMemBar50 = cBoxMemBar50.BackColor;
            f1.fRed = fRed;
            f1.fGreen = fGreen;
            f1.fBlue = fBlue;
            f1.fRedScale = fRedScale;
            f1.fGreenScale = fGreenScale;
            f1.fBlueScale = fBlueScale;
            f1.imageBackG = imageBackG;
            f1.sImageBackFilename = sImageBackFilename;
            f1.bBGImageFill = bBGIFill;
        }

        private void bReset_Click(object sender, EventArgs e)  //Reset
        {
            bReset.Enabled = false;
            _resetSettings();
        }

        private void _resetSettings()
        {
            _user_save(); 
            lbActive.Items.Clear();
            lbAvailable.Items.Clear();
            lbTitle.Items.Clear();
            f1.loadSettings();
            f1._Init();
            settingsLoad();
         //   _TestSettings();
            //f1.label0.ForeColor = Properties.Settings.Default.f1TextColor;
            colorbox.BackColor = Properties.Settings.Default.f1TextColor;//f1.label0.ForeColor;
            label4.Text = Properties.Settings.Default.f1Text.Name;
            label4.Font = Properties.Settings.Default.f1Text;
            numericUpDownAngel.Value = Properties.Settings.Default.f2GradAngle;
 //           f1.label0.Font = Properties.Settings.Default.f1Text;
            f1._update_visuals();
        }

        private void bApply_Click(object sender, EventArgs e)    //Apply
        {
            string sVar;
            _TestSettings();
            for (int i = 0; i < 20; i++)
            {
                sVar = "f2Titel" + (i + 1).ToString();
                Properties.Settings.Default[sVar] = f1.sTitle[i];
                sVar = "f2Funktion" + (i + 1).ToString();
                Properties.Settings.Default[sVar] = f1.iFunction[i];
                sVar = "f2LB" + (i + 1).ToString();
                Properties.Settings.Default[sVar] = f1.iLB[i];
                sVar = "f2TitelHist" + (i + 1).ToString();
                Properties.Settings.Default[sVar] = f1.sTitleHist[i];
                sVar = "f2LBHist" + (i + 1).ToString();
                Properties.Settings.Default[sVar] = f1.iLBHist[i];
                sVar = "f2TextColor" + (i + 1).ToString();
                Properties.Settings.Default[sVar] = f1.cTitleColor[i];
                sVar = "f2TextFont" + (i + 1).ToString();
                Properties.Settings.Default[sVar] = f1.fTitleFont[i];

            }
           // _LBSave();    //2010.09.09 no more needed -->language change fix 
            if (bColorGlobal)
            {
                Properties.Settings.Default.f1TextColor = colorbox.BackColor;
                Properties.Settings.Default.f1Text = label4.Font;
                f1.cColorGlobal = colorbox.BackColor;
                f1.fFontGlobal  = label4.Font;
            }
            Properties.Settings.Default.f2GradAngle = Convert.ToInt16(numericUpDownAngel.Value);
            Properties.Settings.Default.f2ColorB1 = colorB1.BackColor;
            Properties.Settings.Default.f2ColorB2 = colorB2.BackColor;
            Properties.Settings.Default.f1CAero = colorAero.BackColor;
            Properties.Settings.Default.fAeroTrans = (float)tbAeroTransparency.Value / 10;
            Properties.Settings.Default.bAeroGrad = cbAeroGradient.Checked;
            Properties.Settings.Default.bAeroTextured = cbAeroTexture.Checked;
            Properties.Settings.Default.f2ColorGlobal = bColorGlobal;
            f1.bColorGlobal = bColorGlobal;
            Properties.Settings.Default.f2Timer = Convert.ToInt16(timerIntervall.Value);
            Properties.Settings.Default.pXpos = f1.Location.X;
            Properties.Settings.Default.pYpos = f1.Location.Y;
            Properties.Settings.Default.f1HDDTextCol=cBoxHDDText.BackColor;
            Properties.Settings.Default.f1HDDBackCol=cBoxHDDBack.BackColor;
            Properties.Settings.Default.f1HDDBarCol50 = cBoxHddBar50.BackColor;
            Properties.Settings.Default.f1HDDBarCol75 = cBoxHddBar75.BackColor;
            Properties.Settings.Default.f1HDDBarCol100 = cBoxHddBar100.BackColor;
            Properties.Settings.Default.f1HDDBarShow = cbHDDBar.Checked;
            Properties.Settings.Default.f2HDDList.Clear();
            Properties.Settings.Default.f2HDDList.AddRange(f1.lHDDHidden.ToArray());
            Properties.Settings.Default.f2NetTP = cbNetTP.Checked;
            Properties.Settings.Default.f2NetAdap[0] = cbNetAdap1.Checked?cbNetAdap1.Text:"";
            Properties.Settings.Default.f2NetAdap[1] = cbNetAdap2.Checked ? cbNetAdap2.Text : "";
            Properties.Settings.Default.f2NetAdap[2] = cbNetAdap3.Checked ? cbNetAdap3.Text : "";
            Properties.Settings.Default.f2NetAdap[3] = cbNetAdap4.Checked ? cbNetAdap4.Text : "";
            Properties.Settings.Default.f2NetIP = cbNetIP.Checked;
            Properties.Settings.Default.f2NetGW = cbNetGW.Checked;
            Properties.Settings.Default.f2NetMAC = cbNetMAC.Checked;
            Properties.Settings.Default.f2NetSUB = cbNetMask.Checked;
            Properties.Settings.Default.f2CPU = cbCPUGraph.Checked;
            Properties.Settings.Default.f2CPUText = cbCPUText.Checked;
            Properties.Settings.Default.f2CPUTotal = cbCPUTotal.Checked;
            Properties.Settings.Default.f2TimerCPU = Convert.ToInt16(timerCPU.Value);
            Properties.Settings.Default.f2TimspanCPU = Convert.ToInt16(timespanCPU.Value);
            Properties.Settings.Default.f2TimerNet = Convert.ToInt16(timerNet.Value);
            Properties.Settings.Default.f2TimespanNet = Convert.ToInt16(timespanNet.Value);
            Properties.Settings.Default.f2TimerDiskUsage = Convert.ToInt16(timerDiskUsage.Value);
            Properties.Settings.Default.f2TimespanDiskUsage = Convert.ToInt16(timespanDiskUsage.Value);
            Properties.Settings.Default.f1BGImageRed = fRed;
            Properties.Settings.Default.f1BGImageGreen = fGreen;
            Properties.Settings.Default.f1BGImageBlue = fBlue;
            Properties.Settings.Default.f1BGImageRedScale = fRedScale;
            Properties.Settings.Default.f1BGImageGreenScale = fGreenScale;
            Properties.Settings.Default.f1BGImageBlueScale = fBlueScale;
            Properties.Settings.Default.f1BGImage = sImageBackFilename;
            Properties.Settings.Default.f1BGImageFill = bBGIFill;
            Properties.Settings.Default.f1bMemBar = cbMemBar.Checked;
            Properties.Settings.Default.f1MemBackCol=cBoxMemBack.BackColor;
            Properties.Settings.Default.f1MemBarCol100 = cBoxMemBar100.BackColor;
            Properties.Settings.Default.f1MemBarCol75 = cBoxMemBar75.BackColor;
            Properties.Settings.Default.f1MemBarCol50 = cBoxMemBar50.BackColor;
            Properties.Settings.Default.Save();
            while (!Properties.Settings.Default.IsSynchronized)
            {
                System.Threading.Thread.Sleep(500);
            }
            Close();
            f1.timer1.Interval = Convert.ToInt16(timerIntervall.Value) * 1000;
            if(f1.netTimer != null)
                f1.netTimer.Interval = Convert.ToInt16(timerNet.Value) * 1000;
            f1._Init();
            System.Threading.Thread.Sleep(100);
            f1._update_visuals();
            f1.timer1.Enabled = true;
            Dispose();

        }

        void Form2_FormClosed(object sender, System.Windows.Forms.FormClosedEventArgs e)
        {
          }

        //private void _LBSave()    //2010.09.09 no more needed -->language change fix 
        //{
        //    string sText;
        //    string[] sDelim = { "\r\n" };
        //    string[] sComboArr = new string [20];

        //    lbActive.Items.CopyTo(sComboArr,0);
        //    sText = String.Join("\r\n",sComboArr);
        //    Properties.Settings.Default.f2LBActive = sText;

        //}

        private void colorbox_Click(object sender, EventArgs e)
        {
            _ColorSet();
        }
        private void button3_Click(object sender, EventArgs e)
        {
            _ColorSet();
        }
        private void _ColorSet()
        {
            colorDialog1.ShowDialog();
            colorbox.BackColor = colorDialog1.Color;
        }
        private void button4_Click(object sender, EventArgs e)
        {
            _FontSet();
        }
        private void label4_Click(object sender, EventArgs e)
        {
            _FontSet();
        }
        private void _FontSet()
        {
             fontDialog1.ShowDialog();
            Font lFont = fontDialog1.Font;
            label4.Text = lFont.Name;
            label4.Font = lFont;
       }

        private void lbAvailable_SelectedIndexChanged(object sender, EventArgs e)
        {
        }
        
        void lbAvailable_DoubleClick(object sender, System.EventArgs e)
        {
            if (!lbActive.Items.Contains(lbAvailable.SelectedItem))
            {
                lbActive.Items.Add(lbAvailable.SelectedItem);
                lbTitle.Items.Add("");
                _functionOrder[lbActive.Items.Count - 1] = lbAvailable.SelectedIndex;
            }
        }

        void lbActive_DoubleClick(object sender, System.EventArgs e)    //remove function from active list
        {
            if (lbActive.SelectedIndex == lbActive.Items.Count-1)
            {
                sTitle[lbActive.SelectedIndex] = "";
                bLBr[lbActive.SelectedIndex] = false;
                _functionOrder[lbActive.SelectedIndex] = -1;
            }
            else
            {
                for (int i = lbActive.SelectedIndex; i < 19; i++)
                {
                    sTitle[i] = sTitle[i+1];
                    bLBr[i] = bLBr[i+1];
                    _functionOrder[i] = _functionOrder[i+1];
                }
                sTitle[19] = "";
                bLBr[19] = false;
                _functionOrder[19] = -1;
            }
            if (lbTitle.Items.Count > lbActive.SelectedIndex)
                lbTitle.Items.RemoveAt(lbActive.SelectedIndex);
            lbActive.Items.Remove(lbActive.SelectedItem);
        }

        void lbTitle_DoubleClick(object sender, System.EventArgs e)    //remove titletext
        {
            if (lbTitle.SelectedIndex > -1)
            {
                sTitle[lbTitle.SelectedIndex] = "";
                lbTitle.Items.Insert(lbTitle.SelectedIndex, "");
                if(lbTitle.Items.Count > lbTitle.SelectedIndex)
                    lbTitle.Items.RemoveAt(lbTitle.SelectedIndex);
                textBox1.Text = "";
            }
        }
        
        private void button5_Click(object sender, EventArgs e) //apply title to function
        {
            if (lbActive.SelectedIndex > -1)
            {
                sTitle[lbActive.SelectedIndex] = textBox1.Text;
                f1.sTitleHist[_functionOrder[lbActive.SelectedIndex]] = textBox1.Text;
                if (lbTitle.Items.Count > lbActive.SelectedIndex)
                    lbTitle.Items.Insert(lbActive.SelectedIndex, textBox1.Text);
                else
                {
                    for (int i = lbTitle.Items.Count; i <= lbActive.SelectedIndex + 1; i++)
                    {
                        lbTitle.Items.Insert(i, "");
                    }
                    lbTitle.Items.Insert(lbActive.SelectedIndex, textBox1.Text);
                }

                if (lbTitle.Items.Count > lbActive.SelectedIndex + 1)
                    lbTitle.Items.RemoveAt(lbActive.SelectedIndex + 1);

            }
            else if (lbTitle.SelectedIndex > -1)
            {
                sTitle[lbTitle.SelectedIndex] = textBox1.Text;
                f1.sTitleHist[_functionOrder[lbTitle.SelectedIndex]] = textBox1.Text;
                lbTitle.Items.Insert(lbTitle.SelectedIndex, textBox1.Text);
                if (lbTitle.Items.Count > lbTitle.SelectedIndex)
                    lbTitle.Items.RemoveAt(lbTitle.SelectedIndex);
            }
            else
                MessageBox.Show("Nothing selected!");

        }

        private void lbActive_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (lbActive.SelectedIndex > -1)
            {
                if (sTitle[lbActive.SelectedIndex] != "")
                {
                    textBox1.Text = sTitle[lbActive.SelectedIndex];
                    checkLBr.Checked = bLBr[lbActive.SelectedIndex];
                    if (bColorGlobal == false)
                    {
                        colorbox.BackColor = cTitleColor[lbActive.SelectedIndex];
                        label4.Text = fTitleFont[lbActive.SelectedIndex].Name;
                        label4.Font = fTitleFont[lbActive.SelectedIndex];
                    }                  
                }
                else
                {
                    try
                    {
                        textBox1.Text = f1.sTitleHist[_functionOrder[lbActive.SelectedIndex]];
                        checkLBr.Checked = f1.iLBHist[_functionOrder[lbActive.SelectedIndex]];
                        if (bColorGlobal == false)
                        {
                            colorbox.BackColor = f1.cTitleColor[_functionOrder[lbActive.SelectedIndex]];
                            label4.Text = f1.fTitleFont[_functionOrder[lbActive.SelectedIndex]].Name;
                            label4.Font = f1.fTitleFont[_functionOrder[lbActive.SelectedIndex]];
                        }
                    }
                    catch (Exception)
                    {
                    }
                }
                lbTitle.SelectedIndex = lbActive.SelectedIndex;
            }
            else
            {
                textBox1.Text = "";
                checkLBr.Checked = false;
            }
        }

        private void lbTitle_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (lbTitle.SelectedIndex > -1)
            {
                if (sTitle[lbTitle.SelectedIndex] != "")
                {
                    textBox1.Text = sTitle[lbTitle.SelectedIndex];
                    checkLBr.Checked = bLBr[lbTitle.SelectedIndex];
                    if (bColorGlobal == false)
                    {
                        colorbox.BackColor = cTitleColor[lbTitle.SelectedIndex];
                        label4.Text = fTitleFont[lbTitle.SelectedIndex].Name;
                        label4.Font = fTitleFont[lbTitle.SelectedIndex];
                    }
                }
                else
                {
                    try
                    {
                        textBox1.Text = f1.sTitleHist[_functionOrder[lbTitle.SelectedIndex]];
                        checkLBr.Checked = f1.iLBHist[_functionOrder[lbTitle.SelectedIndex]];
                        if (bColorGlobal == false)
                        {
                            colorbox.BackColor = f1.cTitleColor[_functionOrder[lbTitle.SelectedIndex]];
                            label4.Text = f1.fTitleFont[_functionOrder[lbTitle.SelectedIndex]].Name;
                            label4.Font = f1.fTitleFont[_functionOrder[lbTitle.SelectedIndex]];
                        }
                    }
                    catch (Exception)
                    {
                    }
                }
                lbActive.SelectedIndex=lbTitle.SelectedIndex;
            }
            else
            {
                textBox1.Text = "";
                checkLBr.Checked = false;
            }
        }

        void checkLBr_MouseClick(object sender, System.Windows.Forms.MouseEventArgs e)
        {

            if (lbActive.SelectedIndex > -1)
            {
                bLBr[lbActive.SelectedIndex] = checkLBr.Checked;
                f1.iLBHist[_functionOrder[lbActive.SelectedIndex]] = checkLBr.Checked;
            }
            else if (lbTitle.SelectedIndex > -1)
            {
                bLBr[lbTitle.SelectedIndex] = checkLBr.Checked;
                f1.iLBHist[_functionOrder[lbTitle.SelectedIndex]] = checkLBr.Checked;
            }
        }


        
        private void checkLBr_CheckedChanged(object sender, EventArgs e)
        {
        }
        private void _user_save()
        {
            string sVar;
            for (int i = 0; i < 20; i++)        //save titles and linebreaks
            {
                sVar = "f2TitelHist" + (i + 1).ToString();
                Properties.Settings.Default[sVar] = f1.sTitleHist[i];
                sVar = "f2LBHist" + (i + 1).ToString();
                Properties.Settings.Default[sVar] = f1.iLBHist[i];
            }
        }


        private void bUp_Click(object sender, EventArgs e) //change order of active list - move up
        {
            if(lbActive.SelectedIndex > 0)
            {
                string sBuffer = "",sTi_Sel,sTi_Next;
                int iBuffer,iF_Sel,iF_Next;
                bool bLBr_Sel, bLBr_Next;

                sBuffer = lbActive.SelectedItem.ToString();
                iBuffer = lbActive.SelectedIndex;
                lbActive.Items.RemoveAt(iBuffer);
                lbActive.Items.Insert(iBuffer - 1, sBuffer);
                lbActive.SelectedIndex = iBuffer - 1;

                sBuffer = lbTitle.Items[iBuffer].ToString();
                lbTitle.Items.RemoveAt(iBuffer);
                lbTitle.Items.Insert(iBuffer - 1,sBuffer);
                lbTitle.SelectedIndex = iBuffer - 1;

                iF_Sel = _functionOrder[iBuffer];
                iF_Next = _functionOrder[iBuffer-1];
                _functionOrder[iBuffer-1] = iF_Sel;
                _functionOrder[iBuffer] = iF_Next;

                sTi_Sel = sTitle[iBuffer];
                sTi_Next = sTitle[iBuffer-1];
                sTitle[iBuffer-1] = sTi_Sel;
                sTitle[iBuffer] = sTi_Next;

                bLBr_Sel = bLBr[iBuffer];
                bLBr_Next = bLBr[iBuffer-1];
                bLBr[iBuffer-1] = bLBr_Sel;
                bLBr[iBuffer] = bLBr_Next;
            }
        }

        private void bDown_Click(object sender, EventArgs e) //change order of active list - move down
        {
            if(lbActive.SelectedIndex < lbActive.Items.Count-1)
            {
                string sBuffer = "",sTi_Sel,sTi_Next;
                int iBuffer,iF_Sel,iF_Next;
                bool bLBr_Sel, bLBr_Next;

                sBuffer = lbActive.SelectedItem.ToString();
                iBuffer = lbActive.SelectedIndex;
                lbActive.Items.RemoveAt(iBuffer);
                lbActive.Items.Insert(iBuffer + 1, sBuffer);
                lbActive.SelectedIndex = iBuffer + 1;

                sBuffer = lbTitle.Items[iBuffer].ToString();
                lbTitle.Items.RemoveAt(iBuffer);
                lbTitle.Items.Insert(iBuffer + 1,sBuffer);
                lbTitle.SelectedIndex = iBuffer + 1;

                iF_Sel = _functionOrder[iBuffer];
                iF_Next = _functionOrder[iBuffer+1];
                _functionOrder[iBuffer+1] = iF_Sel;
                _functionOrder[iBuffer] = iF_Next;

                sTi_Sel = sTitle[iBuffer];
                sTi_Next = sTitle[iBuffer+1];
                sTitle[iBuffer+1] = sTi_Sel;
                sTitle[iBuffer] = sTi_Next;

                bLBr_Sel = bLBr[iBuffer];
                bLBr_Next = bLBr[iBuffer+1];
                bLBr[iBuffer+1] = bLBr_Sel;
                bLBr[iBuffer] = bLBr_Next;
            }

        }

        private void toolTip1_Popup(object sender, PopupEventArgs e)
        {

        }

        private void fontDialog1_Apply(object sender, EventArgs e)
        {

        }

        private void cbColorGlobal_MouseClick(object sender, MouseEventArgs e)
        {
            bColorGlobal = cbColorGlobal.Checked;
            if (bColorGlobal)
            {
                colorbox.BackColor = Properties.Settings.Default.f1TextColor;
                label4.Text = Properties.Settings.Default.f1Text.Name;
                label4.Font = Properties.Settings.Default.f1Text;
            }
        }

        private void bTextCol_Click(object sender, EventArgs e)
        {
            if (lbActive.SelectedIndex > -1)
            {
                cTitleColor[lbActive.SelectedIndex] = colorbox.BackColor;
                f1.cTitleColor[_functionOrder[lbActive.SelectedIndex]] = colorbox.BackColor;
                fTitleFont[lbActive.SelectedIndex] = label4.Font;
                f1.fTitleFont[_functionOrder[lbActive.SelectedIndex]] = label4.Font;
            }
            else if (lbTitle.SelectedIndex > -1)
            {
                cTitleColor[lbTitle.SelectedIndex] = colorbox.BackColor;
                f1.cTitleColor[_functionOrder[lbTitle.SelectedIndex]] = colorbox.BackColor;
                fTitleFont[lbTitle.SelectedIndex] = label4.Font;
                f1.fTitleFont[_functionOrder[lbTitle.SelectedIndex]] = label4.Font;
            }
            else
                MessageBox.Show("Nothing selected!");

        }

        private void cbColorGlobal_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void colorB1_Click(object sender, EventArgs e)
        {
                colorDialog1.Color = colorB1.BackColor;
                colorDialog1.ShowDialog();
                colorB1.BackColor = f1.cColorB1 = colorDialog1.Color;
                f1.label_MouseEnter(null, null);
                f1.label_MouseLeave(null, null);

       }
        private void colorB2_Click(object sender, EventArgs e)
        {
                colorDialog1.Color = colorB2.BackColor;
                colorDialog1.ShowDialog();
                colorB2.BackColor = f1.cColorB2 = colorDialog1.Color;
                f1.label_MouseEnter(null, null);
                f1.label_MouseLeave(null, null);

        }
        private void colorAero_Click(object sender, EventArgs e)
        {
                colorDialog1.Color = colorAero.BackColor;
                colorDialog1.ShowDialog();
                colorAero.BackColor = f1.cAero = colorDialog1.Color;
                f1.label_MouseEnter(null, null);
                f1.label_MouseLeave(null, null);

       }

        private void bAeroTrans_Click(object sender, EventArgs e)
        {
            colorAero.BackColor = f1.cAero = Color.FromArgb(2, 2, 2);
            f1.label_MouseEnter(null, null);
            f1.label_MouseLeave(null, null);

        }

        private void numericUpDownAngel_ValueChanged(object sender, EventArgs e)
        {
            f1.iGradAngle = Convert.ToInt16(numericUpDownAngel.Value);
            f1.label_MouseEnter(null, null);
            f1.label_MouseLeave(null, null);

        }

        private void cBoxHDDText_Click(object sender, EventArgs e)
        {
            colorDialog1.Color = cBoxHDDText.BackColor;
            colorDialog1.ShowDialog();
            cBoxHDDText.BackColor = colorDialog1.Color;
        }

        private void cBoxHDDBack_Click(object sender, EventArgs e)
        {
            colorDialog1.Color = cBoxHDDBack.BackColor;
            colorDialog1.ShowDialog();
            cBoxHDDBack.BackColor = colorDialog1.Color;
        }

        private void cbHDDBar_MouseClick(object sender, MouseEventArgs e)
        {
            f1.bHDDPBar = cbHDDBar.Checked;
        }

        private void cbNetTP_Click(object sender, EventArgs e)
        {
            f1.bNetTP = cbNetTP.Checked;
        }

        private void cbNetAdap1_Click(object sender, EventArgs e)
        {
            f1.sNetAdapters[0] = cbNetAdap1.Checked?cbNetAdap1.Text : "";
            f1.Network_init();
        }

        private void cbNetAdap2_Click(object sender, EventArgs e)
        {
            f1.sNetAdapters[1] = cbNetAdap2.Checked ? cbNetAdap2.Text : "";
            f1.Network_init();
        }
        private void cbNetAdap3_Click(object sender, EventArgs e)
        {
            f1.sNetAdapters[2] = cbNetAdap3.Checked ? cbNetAdap3.Text : "";
            f1.Network_init();
        }

        private void cbNetAdap4_Click(object sender, EventArgs e)
        {
            f1.sNetAdapters[3] = cbNetAdap4.Checked ? cbNetAdap4.Text : "";
            f1.Network_init();
        }

        private void cbCPU_Click(object sender, EventArgs e)
        {
            f1.bCPU = cbCPUGraph.Checked;
        }

        private void cbCPUText_Click(object sender, EventArgs e)
        {
            f1.bCPUText = cbCPUText.Checked;
        }

        private void cbCPUTotal_Click(object sender, EventArgs e)
        {
            f1.bCPUTotal = cbCPUTotal.Checked;
        }

        private void cbNetIP_Click(object sender, EventArgs e)
        {
            f1.bNetIP = cbNetIP.Checked;
        }

        private void cbNetMAC_Click(object sender, EventArgs e)
        {
            f1.bNetMac = cbNetMAC.Checked;
        }

        private void cbNetMask_Click(object sender, EventArgs e)
        {
            f1.bNetMask = cbNetMask.Checked;
        }

        private void cbNetGW_Click(object sender, EventArgs e)
        {
            f1.bNetGW = cbNetGW.Checked;
        }

        private void bHddBar50_Click(object sender, EventArgs e)
        {
            colorDialog1.Color = cBoxHddBar50.BackColor;
            colorDialog1.ShowDialog();
            cBoxHddBar50.BackColor = colorDialog1.Color;
        }

        private void bHddBar75_Click(object sender, EventArgs e)
        {
            colorDialog1.Color = cBoxHddBar75.BackColor;
            colorDialog1.ShowDialog();
            cBoxHddBar75.BackColor = colorDialog1.Color;
        }

        private void bHddBar100_Click(object sender, EventArgs e)
        {
            colorDialog1.Color = cBoxHddBar100.BackColor;
            colorDialog1.ShowDialog();
            cBoxHddBar100.BackColor = colorDialog1.Color;
        }

        private void bMemBar50_Click(object sender, EventArgs e)
        {
            colorDialog1.Color = cBoxMemBar50.BackColor;
            colorDialog1.ShowDialog();
            cBoxMemBar50.BackColor = colorDialog1.Color;
        }

        private void bMemBar75_Click(object sender, EventArgs e)
        {
            colorDialog1.Color = cBoxMemBar75.BackColor;
            colorDialog1.ShowDialog();
            cBoxMemBar75.BackColor = colorDialog1.Color;
        }

        private void bMemBar100_Click(object sender, EventArgs e)
        {
            colorDialog1.Color = cBoxMemBar100.BackColor;
            colorDialog1.ShowDialog();
            cBoxMemBar100.BackColor = colorDialog1.Color;
        }

        private void cBoxMemBack_Click(object sender, EventArgs e)
        {
            colorDialog1.Color = cBoxMemBack.BackColor;
            colorDialog1.ShowDialog();
            cBoxMemBack.BackColor = colorDialog1.Color;
        }


        private void tBar_Scroll(object sender, EventArgs e)
        {
            fRed = (float)tBarR.Value / 100;
            fGreen = (float)tBarG.Value / 100;
            fBlue = (float)tBarB.Value / 100;
            pBox.Refresh();
        }
        private void tBarAll_Scroll(object sender, EventArgs e)
        {
            int iVal = tBarI.Value - iTBarAll;
            try
            {
                tBarR.Value += iVal;
                tBarG.Value += iVal;
                tBarB.Value += iVal;
            }
            catch (Exception)
            {

            }
            finally
            {
                iTBarAll = tBarI.Value;
                tBar_Scroll(null, null);
            }
        }

        private void pBox_Paint(object sender, PaintEventArgs e)
        {
            lRed.Text = fRed.ToString();
            lGreen.Text = fGreen.ToString();
            lBlue.Text = fBlue.ToString();
            lRedScale.Text = fRedScale.ToString();
            lGreenScale.Text = fGreenScale.ToString();
            lBlueScale.Text = fBlueScale.ToString();

            Rectangle BaseRectangle =
                new Rectangle(0, 0, pBox.Width, pBox.Height);
            Image ImageBack = null;
            if (imageBackG == null)
            {
                ImageBack = Properties.Resources.grey;

            }
            else
            {
                ImageBack = imageBackG;
            }
            System.Drawing.Imaging.ImageAttributes imageAttributes = new System.Drawing.Imaging.ImageAttributes();
            float[][] colorMatrixElements = { 
                           new float[] {fRedScale,  0,  0,  0, 0},        // red scaling factor
                           new float[] {0,  fGreenScale,  0,  0, 0},        // green scaling factor
                           new float[] {0,  0,  fBlueScale,  0, 0},        // blue scaling factor
                           new float[] {0,  0,  0,  1, 0},        // alpha scaling factor of 1
                           new float[] {fRed, fGreen, fBlue, 0, 1}};    //translations

            System.Drawing.Imaging.ColorMatrix colorMatrix = new System.Drawing.Imaging.ColorMatrix(colorMatrixElements);

            imageAttributes.SetColorMatrix(
               colorMatrix,
               System.Drawing.Imaging.ColorMatrixFlag.Default,
               System.Drawing.Imaging.ColorAdjustType.Bitmap);

            int width = ImageBack.Width;
            int height = ImageBack.Height;

            // what to do when pic is larger than picture box...? I decided to scale it down to picbox width

            //if (height > pBox.Height)
            //{
            //    ImageBack.RotateFlip(System.Drawing.RotateFlipType.Rotate180FlipNone);
            //    ImageBack.RotateFlip(System.Drawing.RotateFlipType.Rotate180FlipNone);
            //    width = (width * pBox.Height) / height;
            //    height = pBox.Height;
            //    ImageBack = ImageBack.GetThumbnailImage(width, height, null, IntPtr.Zero);

            //}
            if (width > pBox.Width)
            {
                ImageBack.RotateFlip(System.Drawing.RotateFlipType.Rotate180FlipNone);
                ImageBack.RotateFlip(System.Drawing.RotateFlipType.Rotate180FlipNone);
                height = (height * pBox.Width) / width;
                width = pBox.Width;
                ImageBack = ImageBack.GetThumbnailImage(width, height, null, IntPtr.Zero);

            }
            if (bBGIFill)
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
           // ImageBack.Dispose();
        }

        private void tBarScale_Scroll(object sender, EventArgs e)
        {
            fRedScale = (float)tBarRScale.Value / 100;
            fGreenScale = (float)tBarGScale.Value / 100;
            fBlueScale = (float)tBarBScale.Value / 100;
            pBox.Refresh();
        }
        private void tBarAllScale_Scroll(object sender, EventArgs e)
        {
            int iVal = tBarScale.Value - iTBarScaleAll;
            try
            {
                tBarRScale.Value += iVal;
                tBarGScale.Value += iVal;
                tBarBScale.Value += iVal;
            }
            catch (Exception)
            {

            }
            finally
            {
                iTBarScaleAll = tBarScale.Value;
                tBarScale_Scroll(null, null);
            }
        }

        private void bBPicValDef_Click(object sender, EventArgs e)
        {
            tBarR.Value =
            tBarG.Value =
            tBarB.Value =
            tBarScale.Value = 
            tBarI.Value = 0;
            tBarRScale.Value =
            tBarGScale.Value =
            tBarBScale.Value = 100;
            fRed =
            fGreen =
            fBlue = 0f;
            fRedScale =
            fGreenScale =
            fBlueScale = 1f;
            pBox.Refresh();
        }

        private void openFileDialog1_FileOk(object sender, CancelEventArgs e)
        {
            imageBackG = Image.FromFile(openFileDialog1.FileName);
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
            sImageBackFilename = openFileDialog1.FileName;
            pBox.Refresh();
        }

        private void bBGPicOpen_Click(object sender, EventArgs e)
        {
            openFileDialog1.Filter = "Image Files(*.jpg; *.jpeg; *.gif; *.bmp; *.png)|*.jpg; *.jpeg; *.gif; *.bmp; *.png";
            openFileDialog1.ShowDialog();
        }

        private void bBPicDef_Click(object sender, EventArgs e)
        {
            imageBackG.Dispose();
            sImageBackFilename = "";
            pBox.Refresh();
        }
        private void cbRGBIntLink_CheckedChanged(object sender, EventArgs e)
        {

        }
        private void cbBGIFill_CheckedChanged(object sender, EventArgs e)
        {
            bBGIFill = cbBGIFill.Checked;
            pBox.Refresh();
        }

        private void groupBox11_Enter(object sender, EventArgs e)
        {

        }

        private void lbHDDHidden_DoubleClick(object sender, EventArgs e)
        {
            if (lbHDDHidden.SelectedItem != null)
            {
                f1.lHDDHidden.Remove(lbHDDHidden.SelectedItem.ToString());
                lbHDDHidden.Items.Remove(lbHDDHidden.SelectedItem);
            }
        }

        private void lbHDDSys_DoubleClick(object sender, EventArgs e)
        {
            if (lbHDDSys.SelectedItem != null && lbHDDHidden.Items.IndexOf(lbHDDSys.SelectedItem) == -1)
            {
                lbHDDHidden.Items.Add(lbHDDSys.SelectedItem);
                f1.lHDDHidden.Add(lbHDDSys.SelectedItem.ToString());
            }
        }

        private void lbHDDSys_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

 
        private void cbAeroTexture_CheckedChanged(object sender, EventArgs e)
        {
            if (cbAeroTexture.Checked)
            {
                cbAeroGradient.Checked = f1.bAeroGradient = false;
            }
            f1.bAeroTexture = cbAeroTexture.Checked;
            f1.label_MouseEnter(null, null);
            f1.label_MouseLeave(null, null);

                
        }

        private void cbAeroGradient_CheckedChanged(object sender, EventArgs e)
        {
            if (cbAeroGradient.Checked)
            {
                cbAeroTexture.Checked = f1.bAeroTexture = false;
            }
            f1.bAeroGradient = cbAeroGradient.Checked;
            f1.label_MouseEnter(null, null);
            f1.label_MouseLeave(null, null);


        }

        private void tbAeroTransparency_Scroll(object sender, EventArgs e)
        {
            f1.fAeroTransparency = ((float)tbAeroTransparency.Value / 10);
            f1.label_MouseEnter(null, null);
            f1.label_MouseLeave(null, null);
        }

        private void cbMemBar_Click(object sender, EventArgs e)
        {
            f1.bMemBar = cbMemBar.Checked;
        }


     }
}