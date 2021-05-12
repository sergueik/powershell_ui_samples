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
/// 
using System;
using System.Timers;
using System.Collections;
using System.Net.NetworkInformation;

namespace SYSInfo
{
	/// <summary>
	/// The NetworkMonitor class monitors network speed for each network adapter on the computer,
    /// using classes for System.Net.NetworkInformation in .NET library.
	/// </summary>
	public class NetworkMonitor
	{
		private Timer timer;						// The timer event to refresh the values in adapters.
		private ArrayList adapters;					// The list of adapters on the computer.
		private ArrayList monitoredAdapters;		// The list of currently monitored adapters.
        private bool bMonitoring = false;

		public NetworkMonitor(string[] name)
		{
			this.adapters	=	new ArrayList();
			this.monitoredAdapters	=	new ArrayList();
			EnumerateNetworkAdapters(name);
			
			//timer	=	new Timer(500);
            timer = new Timer(Properties.Settings.Default.f2TimerNet);
			timer.Elapsed	+=	new ElapsedEventHandler(timer_Elapsed);
		}

		/// <summary>
		/// Enumerates network adapters installed on the computer.
		/// </summary>
		public void EnumerateNetworkAdapters(String[] sName)
		{
            NetworkInterface[] nicArr = NetworkInterface.GetAllNetworkInterfaces();

            foreach (string name in sName)
            {
                NetworkInterface nic = Array.Find(nicArr, element => element.Name == name);
                if (nic != null && nic.OperationalStatus == OperationalStatus.Up)
                {
                    NetworkAdapter adapter = new NetworkAdapter(nic);
                    this.adapters.Add(adapter);
                }
			}
		}

		private void timer_Elapsed(object sender, ElapsedEventArgs e)
		{
            foreach (NetworkAdapter adapter in this.monitoredAdapters)
                if (adapter.nic != null && adapter.nic.OperationalStatus == OperationalStatus.Up)
                    adapter.refresh(timer.Interval / 1000);
                else
                    StopMonitoring(adapter);
        }                                                  

		/// <summary>
		/// Get instances of NetworkAdapter for installed adapters on this computer.
		/// </summary>
		public NetworkAdapter[] Adapters
		{
			get
			{
				return (NetworkAdapter[])this.adapters.ToArray(typeof(NetworkAdapter));
			}
		}

		// Enable the timer and add all adapters to the monitoredAdapters list, unless the adapters list is empty.
		public void StartMonitoring()
		{
			if (this.adapters.Count > 0)
			{
				foreach(NetworkAdapter adapter in this.adapters)
					if (!this.monitoredAdapters.Contains(adapter))
					{
						this.monitoredAdapters.Add(adapter);
						adapter.init();
					}
				
				timer.Enabled	=	true;
                bMonitoring = true;
			}
		}

		// Enable the timer, and add the specified adapter to the monitoredAdapters list
		public void StartMonitoring(NetworkAdapter adapter)
		{
			if (!this.monitoredAdapters.Contains(adapter))
			{
				this.monitoredAdapters.Add(adapter);
				adapter.init();
			}
			timer.Enabled	=	true;
		}

		// Disable the timer, and clear the monitoredAdapters list.
        public void MonitorsClear()
		{
			timer.Enabled	=	false;
            bMonitoring = false;
            if (this.adapters.Count > 0)
            {
                foreach (NetworkAdapter adapter in this.adapters)
                    if (this.monitoredAdapters.Contains(adapter))
                    {
                        this.monitoredAdapters.Remove(adapter);
                    }
             }
			this.monitoredAdapters.Clear();
		}

		// Disable the timer
        public void StopMonitoring()
        {
			timer.Enabled	=	false;
            bMonitoring = false;
        }

		// Remove the specified adapter from the monitoredAdapters list, and disable the timer if the monitoredAdapters list is empty.
		public void StopMonitoring(NetworkAdapter adapter)
		{
			if (this.monitoredAdapters.Contains(adapter))
				this.monitoredAdapters.Remove(adapter);
            if (this.monitoredAdapters.Count == 0)
            {
                timer.Enabled = false;
                bMonitoring = false;
            }
		}

        public bool MonitorActive
        {
            get
            {
                return bMonitoring;
            }
        }
	}
}
