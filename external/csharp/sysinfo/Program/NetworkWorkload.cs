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

namespace SYSInfo
{
    class NetworkWorkload
    {
        ZedGraphControl netGraphControl = new ZedGraphControl();
        public System.Windows.Forms.Label lNet = new System.Windows.Forms.Label();
        int tSpan = 60;
        NetworkAdapter Adapter;

        public NetworkWorkload(string sName, NetworkAdapter Adapter)
        {
            _netGraphInit(sName);
            _label_init();
            this.Adapter = Adapter;
        }

        private void _label_init()
        {
            lNet.Margin = new Padding(0);
            lNet.Padding = new Padding(0);
            lNet.AutoSize = true;
        }

        public ZedGraphControl NetGraphControl
        {
            get
            {
                return netGraphControl;
            }
        }


        public System.Windows.Forms.Label Label
        {
            get
            {
                return lNet;
            }
        }

        private void _netGraphInit(string name)
        {
            Color[] cColor = { Color.AliceBlue, Color.Cyan, Color.LightBlue, Color.Aquamarine, Color.Orange, Color.Coral, Color.LightGoldenrodYellow, Color.Gold };
            RollingPointPairList[] rpList = new RollingPointPairList[8];
            LineItem[] lCurve = new LineItem[8];
            netGraphControl = new ZedGraphControl();
            GraphPane myPane = netGraphControl.GraphPane;
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
            myPane.YAxis.Scale.Max = 2000;
            myPane.YAxis.Scale.MaxAuto = true;
            myPane.YAxis.Scale.Min = 0;
            TextureBrush texBrush = new TextureBrush(Properties.Resources.cpuBckgB);
            myPane.Fill = new Fill(texBrush, true);
            netGraphControl.Size = new Size(115, 31);//.Dock = DockStyle.Fill;
            tSpan = Properties.Settings.Default.f2TimespanNet;
            int timer = Properties.Settings.Default.f2TimerNet, iPL = 1000/timer * tSpan;

            for (int i = 0; i < 2; i++)
            {
                rpList[i] = new RollingPointPairList(iPL);
                lCurve[i] = myPane.AddCurve(name + i.ToString(), rpList[i], cColor[i], SymbolType.None);
                lCurve[i].Line.Width = 0.01F;
                lCurve[i].Line.IsAntiAlias = true;
                lCurve[i].IsVisible = false;
            }
            netGraphControl.AxisChange();
            netGraphControl.Visible = false;
        }

        public void _net_graph_update()
        {
            // Make sure that the curvelist has at least one curve
            if (netGraphControl.GraphPane.CurveList.Count <= 0)
                return;
            LineItem lCurveDL = netGraphControl.GraphPane.CurveList[0] as LineItem;
            LineItem lCurveUL = netGraphControl.GraphPane.CurveList[1] as LineItem;
            if (lCurveDL == null || lCurveUL == null)
                return;
            // Get the PointPairList
            IPointListEdit listDL = lCurveDL.Points as IPointListEdit;
            IPointListEdit listUL = lCurveUL.Points as IPointListEdit;
            // If this is null, it means the reference at curve.Points does not
            // support IPointListEdit, so we won't be able to modify it
            if (listDL == null || listUL == null)
                return;
            // Time is measured in seconds
            double time = Environment.TickCount / 1000.0;
            listDL.Add(time, Convert.ToDouble(Adapter.DownloadSpeedKbps));
            listUL.Add(time, Convert.ToDouble(Adapter.UploadSpeedKbps));

            // Keep the X scale at a rolling interval of defined seconds
            Scale xScale = netGraphControl.GraphPane.XAxis.Scale;
            if (time > xScale.Max)
            {
                xScale.Max = time;
                xScale.Min = xScale.Max - tSpan;
            }
            lCurveDL.IsVisible = true;
            lCurveUL.IsVisible = true;
            netGraphControl.AxisChange();
            netGraphControl.Invalidate(); // Force a redraw
            netGraphControl.Visible = true;
        }

        public void _net_label_update(string sLabelText)
        {
            lNet.Text = sLabelText;
            lNet.Visible = true;
         }

        public int Span
        {
            set
            {
                tSpan = value;
            }
        }

        public void _dispose()
        {
            netGraphControl.Controls.Clear();
            netGraphControl.Dispose();
            netGraphControl = null;
            lNet.Dispose();
            lNet = null;
            Adapter = null;
        }

    }
}
