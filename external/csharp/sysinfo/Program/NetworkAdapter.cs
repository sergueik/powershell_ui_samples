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
/// <summary>
    /// This code was adapted from Echevil (http://www.codeproject.com/script/Membership/View.aspx?mid=887221)
    /// http://www.codeproject.com/KB/system/networkmonitorl.aspx
    /// I used the structure of his classes which I think he made very nice
    /// but switched from the performance counters to the NetworkInterface class
    /// inspired by Mohamed Mansour (http://www.m0interactive.com/archives/2008/02/06/how_to_calculate_network_bandwidth_speed_in_c_/)
    /// as it is more suitable/flexible and provides more infos.
    /// Also there's no problem with the different naming of the nics in wmi and system
	/// </summary>



using System;
using System.Diagnostics;
using System.Net.NetworkInformation;

namespace SYSInfo
{
	/// <summary>
	/// Represents a network adapter installed on the machine.
	/// Properties of this class can be used to obtain current network speed.
	/// </summary>
	public class NetworkAdapter
	{
		/// <summary>
		/// Instances of this class are supposed to be created only in an NetworkMonitor.
		/// </summary>
        internal NetworkAdapter(NetworkInterface nic)
		{
			this.nic	=	nic;
		}

		private long dlSpeed, ulSpeed;				// Download\Upload speed in bytes per second.
		private long dlValue, ulValue;				// Download\Upload counter value in bytes.
		private long dlValueOld, ulValueOld;		// Download\Upload counter value one second earlier, in bytes.

        internal NetworkInterface nic;
        internal IPv4InterfaceStatistics interfaceStats;
        internal IPInterfaceProperties props;
        internal UnicastIPAddressInformationCollection uniCast;
        internal string uniIP;
        internal string uniIPMask;
        internal string gateway;
		/// <summary>
		/// Preparations for monitoring.
		/// </summary>
		internal void init()
		{
            interfaceStats = nic.GetIPv4Statistics();
            props = nic.GetIPProperties();
            gateway = props.GatewayAddresses.Count > 0 ? props.GatewayAddresses[props.GatewayAddresses.Count - 1].Address.ToString() : " N/A ";
            uniCast = props.UnicastAddresses;
            uniIP = uniCast.Count > 0 ? uniCast[uniCast.Count - 1].Address.ToString() : " N/A "; //the last address in array should be IPv4...but not always...
            uniIPMask = uniCast.Count > 0 ? uniCast[uniCast.Count - 1].IPv4Mask.ToString() : " N/A "; 
			// Since dlValueOld and ulValueOld are used in method refresh() to calculate network speed, they must have be initialized.
            this.dlValueOld = interfaceStats.BytesReceived;
            this.ulValueOld = interfaceStats.BytesSent;
		}

		/// <summary>
		/// Obtain new sample from interface stats, and refresh the values saved in dlSpeed, ulSpeed, etc.
		/// This method is supposed to be called only in NetworkMonitor, one time every second.
		/// </summary>
		internal void refresh(double iIntervall)
		{
            try
            {
                if (this.Nic.OperationalStatus == OperationalStatus.Up)
                {
                    
                    interfaceStats = nic.GetIPv4Statistics();
                    this.dlValue = (long)(interfaceStats.BytesReceived / iIntervall);
                    this.ulValue = (long)(interfaceStats.BytesSent / iIntervall);

                    // Calculates download and upload speed.
                    this.dlSpeed = this.dlValue - this.dlValueOld;
                    this.ulSpeed = this.ulValue - this.ulValueOld;

                    this.dlValueOld = this.dlValue;
                    this.ulValueOld = this.ulValue;
                }
            }
            catch (Exception)
            {
                //throw;
			    this.dlSpeed	=	-1;
			    this.ulSpeed	=	-1;

			    this.dlValueOld	=	-1;
			    this.ulValueOld	=	-1;
            }
		}

		/// <summary>
		/// Overrides method to return the name of the adapter.
		/// </summary>
		/// <returns>The name of the adapter.</returns>
		public override string ToString()
		{
            return this.nic.Name;
		}
        /// <summary>
        /// The name of the network adapter.
        /// </summary>
        public string Name
        {
            get
            {
                return this.nic.Name.Replace("&","&&");
            }
        }
        /// <summary>
        /// The actual speed of the network adapter.
        /// </summary>
        public string Speed
        {
            get
            {
                string sSpeed = "";
                int iSpeed = Convert.ToInt32(this.nic.Speed / 1000);    //not sure if it is new convention??? --> http://en.wikipedia.org/wiki/Binary_prefix
                if (iSpeed >= 1000)                                      //otherwise it would be 95Mbit instead of 100...
                {
                    iSpeed /= 1000;
                    if (iSpeed >= 1000)
                    {
                        iSpeed /= 1000;
                        sSpeed = iSpeed.ToString() + "Gbit/s";
                    }                        
                    else
                        sSpeed = iSpeed.ToString() + "Mbit/s";
                }
                else
                    sSpeed = iSpeed.ToString() + "kbit/s";
                return sSpeed;
            }
        }
        /// <summary>
        /// The ip-address of the network adapter.
        /// </summary>
        public string IP
        {
            get
            {
                return this.uniIP;
            }
        }
        /// <summary>
        /// The ip-mask of the network adapter.
        /// </summary>
        public string MASK
        {
            get
            {
                return this.uniIPMask;
            }
        }
        /// <summary>
        /// The mac-address of the network adapter.
        /// </summary>
        public string MAC
        {
            get
            {
                string mac = this.nic.GetPhysicalAddress().ToString();

                if (mac.Length == 12)
                {
                    for (int i = 2; i < mac.Length; i += 3)
                        mac = mac.Insert(i, ":");

                    return mac;
                }
                else
                    return " N/A ";
            }
        }

		/// <summary>
		/// The network adapter.
		/// </summary>
        public NetworkInterface Nic
		{
			get
			{
				return this.nic;
			}
		}
		/// <summary>
		/// Current download speed in bytes per second.
		/// </summary>
		public long DownloadSpeed
		{
			get
			{
				return this.dlSpeed;
			}
		}
		/// <summary>
		/// Current upload speed in bytes per second.
		/// </summary>
		public long UploadSpeed
		{
			get
			{
				return this.ulSpeed;
			}
		}
		/// <summary>
		/// Current download speed in kbytes per second.
		/// </summary>
		public double DownloadSpeedKbps
		{
			get
			{
				return this.dlSpeed/1024.0;
			}
		}
		/// <summary>
		/// Current upload speed in kbytes per second.
		/// </summary>
		public double UploadSpeedKbps
		{
			get
			{
				return this.ulSpeed/1024.0;
			}
		}
		/// <summary>
		/// Current download speed per second converted to be suitable for reading.
		/// </summary>
		public string DownloadSpeedConv
		{
			get
			{   
                double speed = this.dlSpeed/1024.0;
                if(speed > 1024)
                {
                    speed /= 1024;
                    return "R:"+ speed.ToString("F2", System.Globalization.CultureInfo.InvariantCulture).PadLeft(6, ' ') +" MBytes/s";
				}
                else
                    return "R:"+ speed.ToString("F2", System.Globalization.CultureInfo.InvariantCulture).PadLeft(6, ' ') +" KBytes/s";
			}
		}
		/// <summary>
        /// Current upload speed per second converted to be suitable for reading.
		/// </summary>
		public string UploadSpeedConv
		{
			get
			{
                double speed = this.ulSpeed / 1024.0;
                if (speed > 1024)
                {
                    speed /= 1024;
                    return "S:" + speed.ToString("F2", System.Globalization.CultureInfo.InvariantCulture).PadLeft(6, ' ') + " MBytes/s";
                }
                else
                    return "S:" + speed.ToString("F2", System.Globalization.CultureInfo.InvariantCulture).PadLeft(6, ' ') + " KBytes/s";
            }
		}
	}
}
