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
//
//zedGraph library by jchampion, kooseefoo, rjosulli  http://sourceforge.net/projects/zedgraph/
//Examples http://www.codeproject.com/KB/graphics/zedgraph.aspx
//
//============================================================================
using System;
using System.Collections.Generic;
using System.Text;
using ZedGraph;
using System.Drawing;
using System.Timers;
using System.Windows.Forms;
using System.Management;
using System.Threading;


namespace SYSInfo
{
    class DiskUsage
    {
        ZedGraphControl diskGraphControl = new ZedGraphControl();
        public System.Windows.Forms.Label lDisk = new System.Windows.Forms.Label();
        int tSpan = 60;
        private System.Timers.Timer timer;
        private bool bTimerDisposed = false;
        private string sName = "", query = "";
        private string sReadBytes, sWriteBytes;
        ManagementObjectSearcher seeker;
        private ReaderWriterLockSlim dcLock = new ReaderWriterLockSlim();

        public DiskUsage(string sName)
        {
            try
            {
                this.sName = sName;
                _diskGraphInit(sName);
                _label_init();
                query = "SELECT DiskReadBytesPersec, DiskWriteBytesPersec FROM Win32_PerfFormattedData_PerfDisk_PhysicalDisk WHERE Name like '%" + sName + "%'";
             //   seeker.Options.Timeout = TimeSpan.FromSeconds(2);
                seeker = new ManagementObjectSearcher(query);

                timer = new System.Timers.Timer(Properties.Settings.Default.f2TimerDiskUsage);
                timer.Disposed += new EventHandler(timer_Disposed);
			    timer.Elapsed += new ElapsedEventHandler(timer_Elapsed);

            }
            catch (Exception)
            {
                
                throw;
            }
        }

        void timer_Disposed(object sender, EventArgs e)
        {
            bTimerDisposed = true;
        }


        private void _label_init()
        {
            lDisk.Margin = new Padding(0);
            lDisk.Padding = new Padding(0);
            lDisk.AutoSize = true;
            lDisk.BackColor = Color.Transparent;
        }


        private void _diskGraphInit(string name)
        {
            Color[] cColor = { Color.AliceBlue, Color.Cyan, Color.Gold };
            RollingPointPairList[] rpList = new RollingPointPairList[2];
            LineItem[] lCurve = new LineItem[3];
            diskGraphControl = new ZedGraphControl();
            GraphPane myPane = diskGraphControl.GraphPane;
            myPane.Chart.Fill.Type = FillType.None;
            myPane.Margin.All = 0;
            myPane.Margin.Top = 2f;
            myPane.Title.Text = "";
            myPane.XAxis.Title.Text = "";
            myPane.YAxis.Title.Text = "";
            myPane.Border.IsVisible = false;
            myPane.Legend.IsVisible = false;
            myPane.XAxis.Scale.IsVisible = false;
            myPane.YAxis.Scale.IsVisible = false;
            myPane.XAxis.IsVisible = false;
            myPane.YAxis.IsVisible = false;
            myPane.YAxis.Scale.Max = 104857600; //~100MBytes/sec
            myPane.YAxis.Scale.MaxAuto = true;
            myPane.YAxis.Scale.Min = 0;
            TextureBrush texBrush = new TextureBrush(Properties.Resources.cpuBckgB);
            myPane.Fill = new Fill(texBrush, true);
            diskGraphControl.Size = new Size(115, 31);//.Dock = DockStyle.Fill;

            tSpan = Properties.Settings.Default.f2TimespanDiskUsage;
            int timer = Properties.Settings.Default.f2TimerDiskUsage, iPL = 1000/timer * tSpan;

            for (int i = 0; i < 2; i++)
            {
                rpList[i] = new RollingPointPairList(iPL);
                lCurve[i] = myPane.AddCurve(name + i.ToString(), rpList[i], cColor[i], SymbolType.None);
                lCurve[i].Line.Width = 0.01F;
                lCurve[i].Line.IsAntiAlias = true;
                lCurve[i].IsVisible = false;
            }
            diskGraphControl.AxisChange();
            diskGraphControl.Visible = false;
        }

        void  timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            update();
        }

        public void update()
        {
            if(dcLock.TryEnterWriteLock(50))
                try
                {
                    ManagementObjectCollection oReturnColl = seeker.Get();
                    foreach (ManagementObject m in oReturnColl)
                    {
                        sReadBytes = m.GetPropertyValue("DiskReadBytesPersec").ToString();
                        sWriteBytes = m.GetPropertyValue("DiskWriteBytesPersec").ToString();
                    }
                    _disk_graph_update();
                    _disk_label_update();
                    oReturnColl.Dispose();
                }
                catch (Exception)
                {

                    throw;
                }
                finally
                {
                    dcLock.ExitWriteLock();
                }
     
        }

        private void _disk_graph_update()
        {
            if (diskGraphControl.GraphPane == null)
                return;
            // Make sure that the curvelist has at least one curve
            if (diskGraphControl.GraphPane.CurveList.Count <= 0)
                return;
            LineItem lCurveReadBytes = diskGraphControl.GraphPane.CurveList[0] as LineItem;
            LineItem lCurveWriteBytes = diskGraphControl.GraphPane.CurveList[1] as LineItem;
            if (lCurveReadBytes == null || lCurveWriteBytes == null)
                return;
            // Get the PointPairList
            IPointListEdit listReadBytes = lCurveReadBytes.Points as IPointListEdit;
            IPointListEdit listWriteBytes = lCurveWriteBytes.Points as IPointListEdit;
            if (listReadBytes == null || listWriteBytes == null)
                return;
            // Time is measured in seconds
            double time = Environment.TickCount / 1000.0;
            listReadBytes.Add(time, Convert.ToDouble(sReadBytes));
            listWriteBytes.Add(time, Convert.ToDouble(sWriteBytes));

            Scale xScale = diskGraphControl.GraphPane.XAxis.Scale;
            if (time > xScale.Max)
            {
                xScale.Max = time;
                xScale.Min = xScale.Max - tSpan;
            }
            lCurveReadBytes.IsVisible = true;
            lCurveWriteBytes.IsVisible = true;
            diskGraphControl.AxisChange();
            diskGraphControl.Invalidate(); // Force a redraw
        }

        private void _disk_label_update()
        {
            string sText =
                "HDD" + sName + "\r\n" +
                "R: " + CalcSize(sReadBytes) + " MB/s" + "\r\n" +
                "W: " + CalcSize(sWriteBytes) + " MB/s" + "\r\n";
            lDisk.ExecuteThreadSafe(() =>
                {
                    lDisk.Visible = true;
                    lDisk.Text = sText;
                });
         }

        private static string CalcSize(string sVal)
        {
            string sCalc = "";
            float Mbytes = 0;
            Mbytes = (float)((float)(Convert.ToUInt32(sVal) / 1024) / 1024);
            sCalc = Mbytes.ToString("N2");
            return sCalc;
        }

        public int Span
        {
            set
            {
                tSpan = value;
            }
        }
        public ZedGraphControl DiskGraphControl
        {
            get
            {
                return diskGraphControl;
            }
        }

        public System.Windows.Forms.Label Label
        {
            get
            {
                return lDisk;
            }
        }

        public System.Timers.Timer Timer
        {
            get
            {
                return timer;
            }
            set
            {
                timer = value;
            }
        }


        internal void dispose()
        {
            if (timer != null)
            {
                timer.Close();
                timer.Dispose();
                while (!bTimerDisposed)
                    System.Threading.Thread.Sleep(500);
            }
            if (diskGraphControl != null)
                diskGraphControl.Dispose();
            if(seeker != null)
                seeker.Dispose();
            if(lDisk != null)
                lDisk.Dispose();
        }
    }
}
