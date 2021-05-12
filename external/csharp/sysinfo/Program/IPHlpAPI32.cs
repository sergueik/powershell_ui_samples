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
/// This code was taken from http://www.codeproject.com/KB/IP/iphlpapi2.aspx
/// created by Warlib (http://www.codeproject.com/script/Membership/View.aspx?mid=856529)
/// </summary>

using System;
using System.Net;
using System.Collections;
using System.Runtime.InteropServices;
using System.Text;

namespace IpHlpApidotnet
{
	#region UDP

    [StructLayout(LayoutKind.Sequential)]
    public struct MIB_UDPROW_OWNER_PID
    {
        public IPEndPoint Local;
        public int dwOwningPid;
        public string ProcessName;
    }

    public struct MIB_UDPROW_OWNER_MODULE
    {
        public IPEndPoint Local;
        public uint dwOwningPid;
        public long liCreateTimestamp; //LARGE_INTEGER
        /*union {
            struct {
                DWORD   SpecificPortBind : 1;
            };
            DWORD       dwFlags;
        };*/
        public ulong[] OwningModuleInfo; //size TCPIP_OWNING_MODULE_SIZE
    }

    public struct MIB_UDPTABLE_OWNER_PID
    {
        public int dwNumEntries;
        public MIB_UDPROW_OWNER_PID[] table;
    }

    public struct _MIB_UDPTABLE_OWNER_MODULE
    {
        public uint dwNumEntries;
        public MIB_UDPROW_OWNER_MODULE[] table;
    }

    public enum UDP_TABLE_CLASS
    {
        UDP_TABLE_BASIC, //A MIB_UDPTABLE table that contains all UDP endpoints on the machine is returned to the caller.
        UDP_TABLE_OWNER_PID, //A MIB_UDPTABLE_OWNER_PID or MIB_UDP6TABLE_OWNER_PID that contains all UDP endpoints on the machine is returned to the caller.
        UDP_TABLE_OWNER_MODULE //A MIB_UDPTABLE_OWNER_MODULE or MIB_UDP6TABLE_OWNER_MODULE that contains all UDP endpoints on the machine is returned to the caller.
    }

	public struct MIB_UDPSTATS
	{
		public int dwInDatagrams ;
		public int dwNoPorts ;
		public int dwInErrors ;
		public int dwOutDatagrams ;
		public int dwNumAddrs;
	}

	public struct MIB_UDPTABLE 
	{
		public int dwNumEntries;  
		public MIB_UDPROW[] table;
	}

	public struct MIB_UDPROW 
	{
		public IPEndPoint Local;
	}

	public struct MIB_EXUDPTABLE
	{
		public int dwNumEntries;  
		public MIB_EXUDPROW[] table;

	}

	public struct MIB_EXUDPROW
	{
		public IPEndPoint Local;  
		public int dwProcessId;
		public string ProcessName;
	}

	#endregion

	#region TCP
    [StructLayout(LayoutKind.Sequential)]
    public struct MIB_TCPTABLE_OWNER_MODULE
    {
        public uint dwNumEntries;
        public MIB_TCPROW_OWNER_MODULE[] table;
    }

    public struct MIB_TCPROW_OWNER_MODULE
    {
        public const int TCPIP_OWNING_MODULE_SIZE = 16;
        public uint dwState;
        public IPEndPoint Local; //LocalAddress
        public IPEndPoint Remote; //RemoteAddress
        public uint dwOwningPid;
        public uint liCreateTimestamp; //LARGE_INTEGER
        public ulong[] OwningModuleInfo; //Look how to define array size in structure ULONGLONG   = new ulong[TCPIP_OWNING_MODULE_SIZE]     
    }

    public struct MIB_TCPTABLE_OWNER_PID
    {
        public int dwNumEntries;
        public MIB_TCPROW_OWNER_PID[] table;
    }

    public struct MIB_TCPROW_OWNER_PID
    {
        public int dwState;
        public IPEndPoint Local; //LocalAddress
        public IPEndPoint Remote; //RemoteAddress
        public int dwOwningPid;
        public string State;
        public string ProcessName;
    }

    public enum TCP_TABLE_CLASS
    {
        TCP_TABLE_BASIC_LISTENER,
        TCP_TABLE_BASIC_CONNECTIONS,
        TCP_TABLE_BASIC_ALL,
        TCP_TABLE_OWNER_PID_LISTENER,
        TCP_TABLE_OWNER_PID_CONNECTIONS,
        TCP_TABLE_OWNER_PID_ALL,
        TCP_TABLE_OWNER_MODULE_LISTENER,
        TCP_TABLE_OWNER_MODULE_CONNECTIONS,
        TCP_TABLE_OWNER_MODULE_ALL,
    }

	public struct MIB_TCPSTATS
	{
		public int dwRtoAlgorithm ;
		public int dwRtoMin ;
		public int dwRtoMax ;
		public int dwMaxConn ;
		public int dwActiveOpens ;
		public int dwPassiveOpens ;
		public int dwAttemptFails ;
		public int dwEstabResets ;
		public int dwCurrEstab ;
		public int dwInSegs ;
		public int dwOutSegs ;
		public int dwRetransSegs ;
		public int dwInErrs ;
		public int dwOutRsts ;
		public int dwNumConns ;
	}

	public struct MIB_TCPTABLE 
	{
		public int dwNumEntries;  
		public MIB_TCPROW[] table;
	}

	public struct MIB_TCPROW 
	{
        //public string StrgState; 
        //public int iState;
        //public IPEndPoint Local;  
        //public IPEndPoint Remote;
        public int dwState;
        public int dwLocalAddr;
        public int dwLocalPort;
        public int dwRemoteAddr;
        public int dwRemotePort;
    }

	public struct MIB_EXTCPTABLE
	{
		public int dwNumEntries;  
		public MIB_EXTCPROW[] table;

	}

	public struct MIB_EXTCPROW
	{
		public string StrgState;
		public int iState;
		public IPEndPoint Local;  
		public IPEndPoint Remote;
		public int dwProcessId;
		public string ProcessName;
	}
	#endregion

	
	public class IPHlpAPI32Wrapper
	{
		public const byte NO_ERROR  = 0;
		public const int FORMAT_MESSAGE_ALLOCATE_BUFFER = 0x00000100;
		public const int FORMAT_MESSAGE_IGNORE_INSERTS = 0x00000200;
		public const int FORMAT_MESSAGE_FROM_SYSTEM  = 0x00001000;
		public int dwFlags = FORMAT_MESSAGE_ALLOCATE_BUFFER | 
			FORMAT_MESSAGE_FROM_SYSTEM | 
			FORMAT_MESSAGE_IGNORE_INSERTS;

		[DllImport("iphlpapi.dll",SetLastError=true)]
		public extern static int GetUdpStatistics (ref MIB_UDPSTATS pStats );

		[DllImport("iphlpapi.dll",SetLastError=true)]
		public static extern int GetUdpTable(byte[] UcpTable, out int pdwSize, bool bOrder);

		[DllImport("iphlpapi.dll",SetLastError=true)]
		public extern static int GetTcpStatistics (ref MIB_TCPSTATS pStats );

		[DllImport("iphlpapi.dll",SetLastError=true)]
		public static extern int GetTcpTable(byte[] pTcpTable, out int pdwSize, bool bOrder);

		[DllImport("iphlpapi.dll",SetLastError=true)]
        private static extern int GetTcpTable(IntPtr pTcpTable, ref int pdwSize, bool bOrder); 

		[ DllImport( "kernel32" ,SetLastError=true)]
		private static extern int FormatMessage( int flags, IntPtr source, int messageId,
			int languageId, StringBuilder buffer, int size, IntPtr arguments ); 

		[DllImport("iphlpapi.dll", SetLastError=true)]
        public static extern int GetExtendedTcpTable(byte[] pTcpTable, out int dwOutBufLen, bool sort, 
            int ipVersion, TCP_TABLE_CLASS tblClass, int reserved);

		[DllImport("iphlpapi.dll", SetLastError=true)]
        public static extern int GetExtendedUdpTable(byte[] pUdpTable, out int dwOutBufLen, bool sort, 
            int ipVersion, UDP_TABLE_CLASS tblClass, int reserved);

        //API to change status of connection  
        [DllImport("iphlpapi.dll", SetLastError=true)]
        //private static extern int SetTcpEntry(MIB_TCPROW tcprow);  
        private static extern int SetTcpEntry(IntPtr pTcprow); 


        public static string GetAPIErrorMessageDescription(int ApiErrNumber ) 
		{
			System.Text.StringBuilder sError = new System.Text.StringBuilder(512); 
			int lErrorMessageLength; 
			lErrorMessageLength = FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM,(IntPtr)0, ApiErrNumber, 0, sError, sError.Capacity, (IntPtr)0) ;
			
			if(lErrorMessageLength > 0)
			{ 
				string strgError = sError.ToString();
				strgError=strgError.Substring(0,strgError.Length-2);
				return strgError+" ("+ApiErrNumber.ToString()+")";
			}
			return "none";
		}

        
        ///<Summary>
        ///close an TCP-connection
        ///Code found @ http://stackoverflow.com/questions/1672062/how-to-close-a-tcp-connection-by-port
        /// </summary>  

        /// <summary>  
        /// Close all connection to the remote IP  
        /// </summary>  
        /// <param name="IP">IP remote PC</param>  
        public static void CloseRemoteIP(string IP)
        {
            MIB_TCPROW[] rows = getTcpTable();
            for (int i = 0; i < rows.Length; i++)
            {
                if (rows[i].dwRemoteAddr == IPStringToInt(IP))
                {
                    rows[i].dwState = 12;
                    IntPtr ptr = GetPtrToNewObject(rows[i]);
                    int ret = SetTcpEntry(ptr);
                }
            }
        }
        /// <summary>  
        /// Close all connections at current local IP  
        /// </summary>  
        /// <param name="IP"></param>  
        public static void CloseLocalIP(string IP)
        {
            MIB_TCPROW[] rows = getTcpTable();
            for (int i = 0; i < rows.Length; i++)
            {
                if (rows[i].dwLocalAddr == IPStringToInt(IP))
                {
                    rows[i].dwState = 12;
                    IntPtr ptr = GetPtrToNewObject(rows[i]);
                    int ret = SetTcpEntry(ptr);
                }
            }
        }
        /// <summary>  
        /// Closes all connections to the local port  
        /// </summary>  
        /// <param name="port"></param>  
        public static void CloseLocalPort(int port, string IP)
        {
            MIB_TCPROW[] rows = getTcpTable();
            for (int i = 0; i < rows.Length; i++)
            {
                if (port == ntohs(rows[i].dwLocalPort) && rows[i].dwLocalAddr == IPStringToInt(IP))
                {
                    rows[i].dwState = 12;
                    IntPtr ptr = GetPtrToNewObject(rows[i]);
                    int ret = SetTcpEntry(ptr);
                }
            }
        } 

        //Convert 16-bit value from network to host byte order  
        [DllImport("wsock32.dll")]
        private static extern int ntohs(int netshort);

        //Convert 16-bit value back again  
        [DllImport("wsock32.dll")]
        private static extern int htons(int netshort); 

        /// <summary>  
        /// Closes all connections to the remote port  
        /// </summary>  
        /// <param name="port"></param>  
        public static void CloseRemotePort(int port, string IP)
        {
            MIB_TCPROW[] rows = getTcpTable();
            for (int i = 0; i < rows.Length; i++)
            {
                if (port == ntohs(rows[i].dwRemotePort) && rows[i].dwRemoteAddr == IPStringToInt(IP))
                {
                    rows[i].dwState = 12;
                    IntPtr ptr = GetPtrToNewObject(rows[i]);
                    int ret = SetTcpEntry(ptr);
                }
            }
        } 

        //The function that fills the MIB_TCPROW array with connectioninfos  
        private static MIB_TCPROW[] getTcpTable()
        {
            IntPtr buffer = IntPtr.Zero; bool allocated = false;
            try
            {
                int iBytes = 0;
                GetTcpTable(IntPtr.Zero, ref iBytes, false); //Getting size of return data  
                buffer = Marshal.AllocCoTaskMem(iBytes); //allocating the datasize  

                allocated = true;

                GetTcpTable(buffer, ref iBytes, false); //Run it again to fill the memory with the data  

                int structCount = Marshal.ReadInt32(buffer); // Get the number of structures  

                IntPtr buffSubPointer = buffer; //Making a pointer that will point into the buffer  
                buffSubPointer = (IntPtr)((int)buffer + 4); //Move to the first data (ignoring dwNumEntries from the original MIB_TCPTABLE struct)  

                MIB_TCPROW[] tcpRows = new MIB_TCPROW[structCount]; //Declaring the array  

                //Get the struct size  
                MIB_TCPROW tmp = new MIB_TCPROW();
                int sizeOfTCPROW = Marshal.SizeOf(tmp);

                //Fill the array 1 by 1  
                for (int i = 0; i < structCount; i++)
                {
                    tcpRows[i] = (MIB_TCPROW)Marshal.PtrToStructure(buffSubPointer, typeof(MIB_TCPROW)); //copy struct data  
                    buffSubPointer = (IntPtr)((int)buffSubPointer + sizeOfTCPROW); //move to next structdata  
                }

                return tcpRows;

            }
            catch (Exception ex)
            {
                throw new Exception("getTcpTable failed! [" + ex.GetType().ToString() + "," + ex.Message + "]");
            }
            finally
            {
                if (allocated) Marshal.FreeCoTaskMem(buffer); //Free the allocated memory  
            }

        }
        static IntPtr GetPtrToNewObject(object obj)
        {
            IntPtr ptr = Marshal.AllocCoTaskMem(Marshal.SizeOf(obj));
            Marshal.StructureToPtr(obj, ptr, false);
            return ptr;
        }
        //Convert an IP string to the INT value  
        private static int IPStringToInt(string IP)
        {
            if (IP.IndexOf(".") < 0) throw new Exception("Invalid IP address");
            string[] addr = IP.Split('.');
            if (addr.Length != 4) throw new Exception("Invalid IP address");
            byte[] bytes = new byte[] { byte.Parse(addr[0]), byte.Parse(addr[1]), byte.Parse(addr[2]), byte.Parse(addr[3]) };
            return BitConverter.ToInt32(bytes, 0);
        }
        //Convert an IP integer to IP string  
        private static string IPIntToString(int IP)
        {
            byte[] addr = System.BitConverter.GetBytes(IP);
            return addr[0] + "." + addr[1] + "." + addr[2] + "." + addr[3];
        }

	}
}

