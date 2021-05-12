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
/// <summary>
/// displays active tcp & udp connections
/// using classes from http://www.codeproject.com/KB/IP/iphlpapi2.aspx
/// created by Warlib (http://www.codeproject.com/script/Membership/View.aspx?mid=856529)
/// </summary>

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Collections;
using System.Threading;
using System.Net.Sockets;
using System.IO;

namespace SYSInfo
{
    public partial class TcpUdpForm : Form
    {
        DataTable dataTable1;

        public TcpUdpForm()
        {
            tcpUdpConn = new IpHlpApidotnet.TCPUDPConnections();
            InitializeComponent();
            this.Show();

            dataTable1 = new DataTable("Table1");
            dataTable1.Columns.Add("State", typeof(String));
            dataTable1.Columns.Add("Local Address", typeof(String));
            dataTable1.Columns.Add("Remote Address", typeof(String));
            dataTable1.Columns.Add("PID", typeof(String));
            dataTable1.Columns.Add("Process", typeof(String));
            dataTable1.Columns.Add("Protocol", typeof(String));
            
            init();
            dataGrid1.SetDataBinding(dataTable1, "");
        }

        IpHlpApidotnet.TCPUDPConnections tcpUdpConn;

        private void init()
        {
            foreach (IpHlpApidotnet.TCPUDPConnection conn in tcpUdpConn)
            {
                string state = String.Empty;
                if (conn.Protocol == IpHlpApidotnet.Protocol.TCP)
                    state = conn.State;
                string prot = "";
                if (conn.Protocol == IpHlpApidotnet.Protocol.TCP)
                    prot = conn.RemoteAddress;
                dataTable1.Rows.Add(new object[]{ state,
                    conn.LocalAddress,
                    prot,conn.PID.ToString(),
                    conn.ProcessName,
                    conn.Protocol.ToString()});
            }

        }

        private void refreshToolStripMenuItem_Click(object sender, EventArgs e)
        {
            dataTable1.Clear();
            checkBox1.CheckState = CheckState.Unchecked;
            tcpUdpConn.Refresh();
            init();
        }


        private void TcpUdpForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            tcpUdpConn = null;
        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            checkBox1.Enabled = false;
            this.Cursor = System.Windows.Forms.Cursors.WaitCursor;
            foreach (DataRow dr in dataTable1.Rows)
            {
                if (dr[2].ToString() != "" && dr[2].ToString() != "*")
                {
                    if (checkBox1.CheckState == CheckState.Checked)
                    {
                        String[] sSplit;
                        string sIP;
                        sSplit = dr[2].ToString().Split(':');
                        try
                        {
                            sIP = System.Net.Dns.GetHostEntry(System.Net.IPAddress.Parse(sSplit[0])).HostName;
                        }
                        catch
                        {
                            sIP = sSplit[0];
                        }
                        dr[2] = sIP + ":" + sSplit[1];
                    }
                    else
                    {
                        String[] sSplit;
                        string sIP = "";
                        sSplit = dr[2].ToString().Split(':');
                        try
                        {
                            System.Net.IPHostEntry inetServer = System.Net.Dns.GetHostEntry(sSplit[0]);
                            foreach (System.Net.IPAddress ipaddr in inetServer.AddressList)
                            {
                                if (ipaddr.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
                                    sIP = ipaddr.ToString();
                            }
                        }
                        catch
                        {
                            sIP = sSplit[0];
                        }
                        dr[2] = sIP + ":" + sSplit[1];
                    }
                }
            }
            checkBox1.Enabled = true;
            this.Cursor = System.Windows.Forms.Cursors.Default;

        }

        private void dataGrid1_MouseUp(object sender, MouseEventArgs e)
        {
            try
            {
                if (e.Button == MouseButtons.Left && dataGrid1.CurrentCell.ColumnNumber == 2)
                {
                    string sVal = dataTable1.Rows[dataGrid1.CurrentCell.RowNumber][2].ToString();
                    if (sVal != "" &&sVal != "*")
                    {
                        String[] sSplit;
                        sSplit = sVal.Split(':');
                        RemoteIP = sSplit[0];
                        RemotePort = Convert.ToInt16(sSplit[1]);
                        contextMenuStrip1.Show(MousePosition);
                    }
                }
                //if (e.Button == MouseButtons.Left && dataGrid1.CurrentCell.ColumnNumber == 1)
                //{
                //    string sVal = dataTable1.Rows[dataGrid1.CurrentCell.RowNumber][1].ToString();
                //    if (sVal != "" &&sVal != "*")
                //    {
                //        String[] sSplit;
                //        sSplit = sVal.Split(':');
                //        LocalIP = sSplit[0];
                //        LocalPort = Convert.ToInt16(sSplit[1]);
                //        contextMenuStrip3.Show(MousePosition);
                //    }
                //}
                if (e.Button == MouseButtons.Left && (dataGrid1.CurrentCell.ColumnNumber == 4||dataGrid1.CurrentCell.ColumnNumber == 3))
                {
                    string sVal = dataTable1.Rows[dataGrid1.CurrentCell.RowNumber][4].ToString();
                    if (sVal != "")
                    {
                        process = sVal;
                        processID = dataTable1.Rows[dataGrid1.CurrentCell.RowNumber][3].ToString();
                        contextMenuStrip2.Show(MousePosition);
                    }
                }
             }
            catch
            {
                //throw; ;
            }
       }

        string process = "";
        string processID = "";
        string RemoteIP = "";
        int RemotePort = 0;
        string LocalIP = "";
        int LocalPort = 0;
        TcpUdpHelper fHelper;

        private void traceRouteToolStripMenuItem_Click(object sender, EventArgs e)
        {
            traceRoute_thread(false);
        }
        private void traceRouteResolveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            traceRoute_thread(true);
        }
        private void traceRoute_thread(bool bRes)
        {
            fHelper = new TcpUdpHelper();
            fHelper.Show();
            Thread tr = new Thread(new ParameterizedThreadStart(Traceroute));
            tr.Start(bRes);
        }
        //Traceroute inspired by: http://coding.infoconex.com/post/C-Traceroute-using-net-framework.aspx
        public void Traceroute(object bResolve)
        {
            bool bRes = (bool)bResolve;
            try
            {
                string sHostName = "",sFormat = "";
                if(bRes)
                    sFormat = "{0}\t{1} ms\t{2}\t{3}";
                else
                    sFormat = "{0}\t{1} ms\t{2}";

                System.Net.IPAddress ipAddress;
                try
                {
                    ipAddress = System.Net.Dns.GetHostEntry(RemoteIP).AddressList[0];
                }
                catch (Exception)
                {
                    ipAddress = System.Net.IPAddress.Parse(RemoteIP);
                    //throw;
                }
                using (System.Net.NetworkInformation.Ping pingSender = new System.Net.NetworkInformation.Ping())
                {
                    System.Net.NetworkInformation.PingOptions pingOptions = new System.Net.NetworkInformation.PingOptions();
                    System.Diagnostics.Stopwatch stopWatch = new System.Diagnostics.Stopwatch();
                    byte[] bytes = new byte[32];
                    pingOptions.DontFragment = true;
                    pingOptions.Ttl = 1;
                    int maxHops = 30;
                    fHelper.ExecuteThreadSafe(() =>
                    {
                        fHelper.textBox1.Text = string.Format(
                            "Tracing route to {0} over a maximum of {1} hops:",
                            ipAddress,
                            maxHops);
                        fHelper.textBox1.Text += "\r\n";
                    });
                    for (int i = 1; i < maxHops + 1; i++)
                    {
                        stopWatch.Reset();
                        stopWatch.Start();
                        System.Net.NetworkInformation.PingReply pingReply = pingSender.Send(
                            ipAddress,
                            5000,
                            new byte[32], pingOptions);
                        stopWatch.Stop();
                        if (bRes)
                        {
                            try
                            {
                                sHostName = System.Net.Dns.GetHostEntry(pingReply.Address).HostName;
                            }
                            catch (Exception)
                            {
                                sHostName = "unknown";
                            }
                        }
                        fHelper.ExecuteThreadSafe(() =>
                        {
                            fHelper.textBox1.Text += string.Format(sFormat,
                            i,
                            stopWatch.ElapsedMilliseconds,
                            pingReply.Address,
                            sHostName);
                            fHelper.textBox1.Text += "\r\n";
                        });
                        if (pingReply.Status == System.Net.NetworkInformation.IPStatus.Success)
                        {
                            fHelper.ExecuteThreadSafe(() =>
                            {
                                fHelper.textBox1.Text += "Trace complete.";
                            });
                            break;
                        }
                        pingOptions.Ttl++;
                    }
                }
            }
            catch (Exception e)
            {
                MessageBox.Show(e.Message + ": " + RemoteIP);
            }
        }

        /// <summary>
        /// Gets the whois information.
        /// </summary>
        /// <param name="whoisServer">The whois server.</param>
        /// <param name="url">The URL.</param>
        /// <returns></returns>
        private string GetWhoisInformation(string whoisServer, string url)
        {
            try
            {
                StringBuilder stringBuilderResult = new StringBuilder();
                TcpClient tcpClinetWhois = new TcpClient(whoisServer, 43);
                NetworkStream networkStreamWhois = tcpClinetWhois.GetStream();
                BufferedStream bufferedStreamWhois = new BufferedStream(networkStreamWhois);
                StreamWriter streamWriter = new StreamWriter(bufferedStreamWhois);

                streamWriter.WriteLine(url);
                streamWriter.Flush();

                StreamReader streamReaderReceive = new StreamReader(bufferedStreamWhois);

                while (!streamReaderReceive.EndOfStream)
                    stringBuilderResult.AppendLine(streamReaderReceive.ReadLine());

                return stringBuilderResult.ToString();
              }
            catch(Exception e)
            {
                
                return e.ToString();
            }
      }

        private void whoisToolStripMenuItem_Click(object sender, EventArgs e)
        {
            string whoisServer = "whois.ripe.net"; //whois-server(s).net doesn't work any longer...
            fHelper = new TcpUdpHelper();
            fHelper.Show();
            fHelper.textBox1.Text += GetWhoisInformation(whoisServer, RemoteIP);
        }

        private void closeRemoteConnectionToolStripMenuItem_Click(object sender, EventArgs e)
        {
            IpHlpApidotnet.IPHlpAPI32Wrapper.CloseRemoteIP(RemoteIP);
            refreshToolStripMenuItem_Click(null, null);
        }

        private void closeRemotePortToolStripMenuItem_Click(object sender, EventArgs e)
        {
            IpHlpApidotnet.IPHlpAPI32Wrapper.CloseRemotePort(RemotePort, RemoteIP);
            refreshToolStripMenuItem_Click(null, null);
        }
        private void closeLocalConnectionToolStripMenuItem_Click(object sender, EventArgs e)
        {
            IpHlpApidotnet.IPHlpAPI32Wrapper.CloseLocalIP(LocalIP);
            refreshToolStripMenuItem_Click(null, null);
        }

        private void closeLocalPortToolStripMenuItem_Click(object sender, EventArgs e)
        {
            IpHlpApidotnet.IPHlpAPI32Wrapper.CloseLocalPort(LocalPort, RemoteIP);
            refreshToolStripMenuItem_Click(null, null);
        }

        private void killProcessToolStripMenuItem_Click(object sender, EventArgs e)
        {
            foreach (System.Diagnostics.Process p in System.Diagnostics.Process.GetProcesses())
            {
                if (p.ProcessName == process && p.Id.ToString() == processID)
                    p.Kill();
            }

            refreshToolStripMenuItem_Click(null, null);
        }

    }
}
