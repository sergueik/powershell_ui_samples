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
using System.Linq;
using System.Text;
using ZedGraph;
using System.Drawing;
using System.Timers;
using System.Windows.Forms;
using System.Management;
using System.Threading;

namespace SYSInfo
{
    class CPUWorkload
    {
        ZedGraphControl cpuGraphControl = new ZedGraphControl();
        System.Windows.Forms.Label lCPU = new System.Windows.Forms.Label();
        bool bGraph = false, bText = false, bTimerDisposed = false, bTotal=false;
        int iCores;
        static string query;
        ManagementObjectSearcher searcher;
        private System.Timers.Timer timer;
        System.OperatingSystem osInfo = System.Environment.OSVersion;
        private ReaderWriterLockSlim dcLock = new ReaderWriterLockSlim();

        public CPUWorkload(bool bGraph, bool bText, bool bTotal)
        {
            if (osInfo.Version.Major < 6)  //Win32_PerfFormattedData_Counters are only available since Vista
                query = "select Name, PercentProcessorTime from Win32_PerfFormattedData_PerfOS_Processor where not name like '%total%'";
            else
                if(bTotal)
                    query = "select Name, PercentProcessorTime, ProcessorFrequency from Win32_PerfFormattedData_Counters_ProcessorInformation where name like '_total'";
                else
                   query = "select Name, PercentProcessorTime, ProcessorFrequency from Win32_PerfFormattedData_Counters_ProcessorInformation where not name like '%total%'";

          //  searcher.Options.Timeout = TimeSpan.FromSeconds(2);
            searcher = new ManagementObjectSearcher(query);
            cpuMonInit();
            this.bGraph = bGraph;
            this.bText = bText;
            this.bTotal = bTotal;
            if(bText)
                _label_init();
            if(bGraph)
                _cpuGraphInit();
            timer = new System.Timers.Timer(Properties.Settings.Default.f2TimerCPU);    //replace this if You want to use it elsewhere
            timer.Elapsed += new ElapsedEventHandler(Refresh);
            timer.Disposed += new EventHandler(timer_Disposed);
            bTimerDisposed = false;
        }

        void timer_Disposed(object sender, EventArgs e)
        {
            bTimerDisposed = true;
        }

        private void cpuMonInit()
        {
            try
            {
                ManagementObjectCollection oReturnCollection = searcher.Get();
                iCores = oReturnCollection.Count;
                oReturnCollection.Dispose();

            }
            catch (Exception)
            {
                
                throw;
            }
        }

        private void _label_init()
        {
            lCPU.Visible = false;
            lCPU.Margin = new Padding(0);
            lCPU.Padding = new Padding(0);
            lCPU.AutoSize = true;
        }

        private void _cpuGraphInit()
        {
            Color[] cColor = { Color.AliceBlue, Color.Cyan, Color.LightBlue, Color.Aquamarine, Color.Orange, Color.Coral, Color.LightGoldenrodYellow, Color.Gold, Color.Chocolate, Color.CornflowerBlue };
            RollingPointPairList[] rpList = new RollingPointPairList[iCores];
            LineItem[] lCurve = new LineItem[iCores];
            GraphPane myPane = cpuGraphControl.GraphPane;
            //cpuGraphControl.Size = new Size(115, 31);//.Dock = DockStyle.Fill;
            //Rectangle rect = new Rectangle(0, 0, cpuGraphControl.Size.Width, cpuGraphControl.Size.Height);
            myPane.CurveList.Clear();
            myPane.Chart.Fill.Type = FillType.None;
            myPane.Margin.All = 0;
            myPane.Margin.Top = 2f;
            myPane.Title.Text = "";
            myPane.Border.IsVisible = false;
            myPane.Legend.IsVisible = false;
            myPane.XAxis.Title.Text = "";
            myPane.XAxis.Scale.Max = Properties.Settings.Default.f2TimspanCPU;
            myPane.XAxis.Scale.Min = 0;
            myPane.XAxis.Scale.IsVisible = false;
            myPane.XAxis.IsVisible = false;
            myPane.YAxis.Scale.IsVisible = false;
            myPane.YAxis.Title.Text = "";
            myPane.YAxis.IsVisible = false;
            myPane.YAxis.Scale.Max = 105;
            myPane.YAxis.Scale.Min = 0;
            TextureBrush texBrush = new TextureBrush(Properties.Resources.cpuBckgB);
          //  myPane.Fill = new Fill(Properties.Resources.blue);
            myPane.Fill = new Fill(texBrush);
            int tSpan = Properties.Settings.Default.f2TimspanCPU, timer = Properties.Settings.Default.f2TimerCPU, iPL = 1000 / timer * tSpan;


            for (int i = 0; i < iCores; i++)
            {
                rpList[i] = new RollingPointPairList(iPL);
                lCurve[i] = myPane.AddCurve("core" + i.ToString(), rpList[i], cColor[i], SymbolType.None);
                //  lCurve[i].Line.IsSmooth = true;
                //  lCurve[i].Line.SmoothTension = 0.2F;
                lCurve[i].Line.Width = 0.01F;
                lCurve[i].Line.IsAntiAlias = true;
                lCurve[i].IsVisible = false;
            }
            cpuGraphControl.AxisChange();
            cpuGraphControl.Visible = false;
        }

        public ZedGraphControl CPUGraphControl
        {
            get
            {
                return cpuGraphControl;
            }
        }

        public void dispose()
        {
            if (timer != null)
            {
                timer.Close();
                timer.Dispose();
                while (!bTimerDisposed)
                    System.Threading.Thread.Sleep(500);
            }
            if(cpuGraphControl != null)
                cpuGraphControl.Dispose();
        }

        public System.Windows.Forms.Label Label
        {
            get
            {
                return lCPU;
            }
            set
            {
                lCPU = value;
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

       internal void Refresh(object sender, ElapsedEventArgs e)
        {
            int iSpan = Properties.Settings.Default.f2TimspanCPU;
            int iIndex = 0;
            string sText = "";
            if(dcLock.TryEnterWriteLock(50))
                try
                {
                    var query = (from ManagementObject p in searcher.Get()
                                 orderby p.Properties["Name"].Value ascending
                                 select p)
                     .Skip(0)
                     .ToList();
                    foreach (var item in query)
                    {
                        double time = Environment.TickCount / 1000.0; //(Environment.TickCount - tCPU) / 1000.0;
                        double val = Convert.ToDouble(item.Properties["PercentProcessorTime"].Value);

                        if (bGraph && cpuGraphControl.GraphPane != null)
                        {
                            LineItem lCurve = cpuGraphControl.GraphPane.CurveList[iIndex] as LineItem;
                            if (lCurve == null)
                                return;
                            IPointListEdit list = lCurve.Points as IPointListEdit;
                            if (list == null)
                                return;
                            list.Add(time, val);

                            Scale xScale = cpuGraphControl.GraphPane.XAxis.Scale;
                            if (time > xScale.Max)
                            {
                                xScale.Max = time;
                                xScale.Min = xScale.Max - iSpan;
                            }
                            lCurve.IsVisible = true;
                        }
                        if (bText)   //prepare the label string
                        {
                            if (!item.Properties["Name"].Value.ToString().Contains("total") && !bTotal)
                            {
                                string name = item.Properties["Name"].Value.ToString();
                                string sCPU = "";
                                if (osInfo.Version.Major < 6)
                                    sCPU = "0";
                                else
                                    sCPU = name.Substring(0, 1);


                                if (osInfo.Version.Major < 6)
                                {
                                    ManagementObject Mo = new ManagementObject("Win32_Processor.DeviceID='CPU" + sCPU + "'");
                                    uint sp = (uint)(Mo["CurrentClockSpeed"]);
                                    Mo.Dispose();
                                    sText +=
                                        "Core"
                                        + name.ToString()
                                        + "@"
                                        + sp.ToString()
                                        + " "
                                        + val.ToString()
                                        + "%" + "\n";
                                }
                                else
                                {
                                    string freq = item.Properties["ProcessorFrequency"].Value.ToString();
                                    if (freq != "0") //dunno...works fine on my dualcore - but my quadcore says "0" ???
                                        sText +=
                                            name.Substring(0, 1)
                                            + ":Core"
                                            + name.ToString().Substring(2, 1)
                                            + "@"
                                            + freq
                                            + " "
                                            + val.ToString().PadLeft(3, '\u2000')
                                            + "%" + "\n";
                                    else
                                    {
                                        ManagementObject Mo = new ManagementObject("Win32_Processor.DeviceID='CPU" + sCPU + "'");
                                        uint sp = (uint)(Mo["CurrentClockSpeed"]);
                                        Mo.Dispose();
                                        sText +=
                                            name.Substring(0, 1)
                                            + ":Core"
                                            + name.ToString().Substring(2, 1)
                                            + "@"
                                            + sp.ToString()
                                            + " "
                                            + val.ToString().PadLeft(3, '\u2000')
                                            + "%" + "\n";
                                    }
                                }
                            }
                            else
                            {
                                if (item.Properties["Name"].Value.ToString() == "_Total")
                                {
                                    string sCPU = "CPU";
                                    string freq = item.Properties["ProcessorFrequency"].Value.ToString();
                                    sText += sCPU
                                            + "@"
                                            + freq
                                            + " "
                                            + val.ToString().PadLeft(3, '\u2000')
                                            + "%" + "\n";

                                }
                            }
                        }

                        iIndex++;
                    }
                    if (bText)
                        lCPU.ExecuteThreadSafe(() => lCPU.Text = sText);
                    if (bGraph)
                    {
                        cpuGraphControl.AxisChange();
                        //// Force a redraw
                        cpuGraphControl.Invalidate();
                        //cpuGraphControl.Width = 115;
                        //cpuGraphControl.Height = 31;
                    }

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
    }
    public static class ControlExtensions
    {
        public static void ExecuteThreadSafe(this Control control, Action action)
        {
            if (control.InvokeRequired)
            {
                control.BeginInvoke(action);
            }
            else
            {
                action.Invoke();
            }
        }
    }
}
