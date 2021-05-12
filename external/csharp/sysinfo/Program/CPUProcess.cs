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
//This code was adapted from Gil.Schmidt:
//http://www.codeproject.com/script/Membership/View.aspx?mid=1283625
//Example:
//http://www.codeproject.com/KB/system/processescpuusage.aspx
//
//made some changes and corrections to fit my needs 
//
//============================================================================



using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using ComType = System.Runtime.InteropServices.ComTypes;
using System.Threading;
using System.Windows.Forms;
using System.Collections;
using System.Linq;
using System.Timers;

namespace SYSInfo
{
    class ProcessCPU
    {
        // gets a process list pointer
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern IntPtr CreateToolhelp32Snapshot(uint Flags, uint ProcessID);

        // gets the first process in the process list
        [DllImport("KERNEL32.DLL")]
        public static extern bool Process32First(IntPtr Handle, ref ProcessEntry32 ProcessInfo);

        // gets the next process in the process list
        [DllImport("KERNEL32.DLL")]
        public static extern bool Process32Next(IntPtr Handle, ref ProcessEntry32 ProcessInfo);

        // closes handles
        [DllImport("KERNEL32.DLL")]
        public static extern bool CloseHandle(IntPtr Handle);

        // gets the process handle
        [DllImport("kernel32.dll")]
        public static extern IntPtr OpenProcess(
            uint DesiredAccess, 
            bool InheritHandle,
            uint ProcessId);

        // gets the process creation, exit, kernel and user time 
        [DllImport("kernel32.dll")]
        public static extern bool GetProcessTimes(
            IntPtr ProcessHandle,
            out ComType.FILETIME CreationTime,
            out ComType.FILETIME ExitTime,
            out ComType.FILETIME KernelTime,
            out ComType.FILETIME UserTime);

        // some consts will need later
        public const int PROCESS_ENTRY_32_SIZE = 304; //296;
        public const uint TH32CS_SNAPPROCESS = 0x00000002;
        public const uint PROCESS_ALL_ACCESS = 0x1F0FFF;

        public static readonly IntPtr PROCESS_LIST_ERROR = new IntPtr(-1);
        public static readonly IntPtr PROCESS_HANDLE_ERROR = new IntPtr(-1);
    }

    // holds the process data
    public class ProcessData
    {
        public uint ID;
        public string Name;
        long OldUserTime;
        long OldKernelTime;
        DateTime OldUpdate;
        public float CpuUsage;
        public int Index;
        
        public ProcessData(uint ID,string Name, long OldUserTime, long OldKernelTime)
        {
            this.ID = ID;
            this.Name = Name;
            this.OldUserTime = OldUserTime;
            this.OldKernelTime = OldKernelTime;
            OldUpdate = DateTime.Now;
        }

        public float UpdateCpuUsage(long NewUserTime, long NewKernelTime, long dtNowTicks)
        {
            // updates the cpu usage (cpu usage = UserTime + KernelTime)
            long UpdateDelay;
            long UserTime = NewUserTime - OldUserTime;
            long KernelTime = NewKernelTime - OldKernelTime;
            float RawUsage;

            // eliminates "divided by zero"
            if (dtNowTicks == OldUpdate.Ticks)
            {
                Thread.Sleep(100);
                UpdateDelay = DateTime.Now.Ticks - OldUpdate.Ticks;
            }
            else
                UpdateDelay = dtNowTicks - OldUpdate.Ticks;


            RawUsage =  (float)Math.Round(((float)((UserTime + KernelTime) * 100) / UpdateDelay) / Environment.ProcessorCount,1); //divide by processor count added
            CpuUsage = RawUsage;
            OldUserTime = NewUserTime;
            OldKernelTime = NewKernelTime;
            OldUpdate = DateTime.Now;

            return RawUsage;
        }
    
    }

    public class processlist
    {
        const ProcessData PROCESS_DATA_NOT_FOUND = null;
        const ListViewItem PROCESS_ITEM_NOT_FOUND = null;

        ArrayList ProcessDataList = new ArrayList();
        ArrayList IDList = new ArrayList();
        IList top5_label;
        private System.Timers.Timer timer;
        bool bTimerDisposed = false;


        public processlist()
        {
            timer = new System.Timers.Timer(1000);
            timer.Elapsed += new ElapsedEventHandler(Refresh);
            timer.Disposed += new EventHandler(timer_Disposed);
            timer.Enabled = true;
            timer.Start();
            bTimerDisposed = false;
            Refresh(null,null);
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
            ProcessDataList = null;
            IDList = null;
        }
        void timer_Disposed(object sender, EventArgs e)
        {
            bTimerDisposed = true;
        }

        private void GetUsage()
        {

            ProcessEntry32 ProcessInfo = new ProcessEntry32();
            ProcessTimes ProcessTimes = new ProcessTimes();
            IntPtr ProcessList, ProcessHandle = ProcessCPU.PROCESS_HANDLE_ERROR;
            ProcessData CurrentProcessData;
            int Index;
            float Total = 0;
            bool NoError;

            // this creates a pointer to the current process list
            ProcessList = ProcessCPU.CreateToolhelp32Snapshot(ProcessCPU.TH32CS_SNAPPROCESS, 0);

            if (ProcessList == ProcessCPU.PROCESS_LIST_ERROR) { return; }

            // we use Process32First, Process32Next to loop through the processes
            ProcessInfo.Size = ProcessCPU.PROCESS_ENTRY_32_SIZE;
            NoError = ProcessCPU.Process32First(ProcessList, ref ProcessInfo);
            IDList.Clear();

            while (NoError)
                try
                {
                    // we need a process handle to pass it to GetProcessTimes function
                    // the OpenProcess function will provide us the handle by the id
                    ProcessHandle = ProcessCPU.OpenProcess(ProcessCPU.PROCESS_ALL_ACCESS, false, ProcessInfo.ID);

                    // here's what we are looking for, this gets the kernel and user time
                    ProcessCPU.GetProcessTimes(
                        ProcessHandle,
                        out ProcessTimes.RawCreationTime,
                        out ProcessTimes.RawExitTime,
                        out ProcessTimes.RawKernelTime,
                        out ProcessTimes.RawUserTime);

                    // convert the values to DateTime values
                    ProcessTimes.ConvertTime();
                    long dtNowTicks = DateTime.Now.Ticks;

                    //from here is just managing the gui for the process list
                    CurrentProcessData = ProcessExists(ProcessInfo.ID);
                    IDList.Add(ProcessInfo.ID);

                    if (CurrentProcessData == PROCESS_DATA_NOT_FOUND)
                    {
                        Index = ProcessDataList.Add(new ProcessData(
                            ProcessInfo.ID,
                            ProcessInfo.ExeFilename,
                            ProcessTimes.UserTime.Ticks,
                            ProcessTimes.KernelTime.Ticks));
                    }
                    else
                        Total += CurrentProcessData.UpdateCpuUsage(
                                    ProcessTimes.UserTime.Ticks,
                                    ProcessTimes.KernelTime.Ticks,
                                    dtNowTicks);
                }
                finally
                {
                    if (ProcessHandle != ProcessCPU.PROCESS_HANDLE_ERROR)
                        ProcessCPU.CloseHandle(ProcessHandle);

                    NoError = ProcessCPU.Process32Next(ProcessList, ref ProcessInfo);
                }

            ProcessCPU.CloseHandle(ProcessList);

            Index = 0;

            while (Index < ProcessDataList.Count)
            {
                ProcessData TempProcess = (ProcessData)ProcessDataList[Index];

                if (IDList.Contains(TempProcess.ID))
                    Index++;
                else
                {
                    ProcessDataList.RemoveAt(Index);
                }
            }
        }

        //picking the top 5 processes from processlist and putting them in an IList
        private IList top_5()
        {
            var query = (from ProcessData p in ProcessDataList
                         where p.Name != "[System Process]"
                         orderby p.CpuUsage descending
                         select p)
            .Skip(0)
            .Take(5)
            .ToList();
            return query;
        }

        private ProcessData ProcessExists(uint ID)
        {
            //foreach (ProcessData TempProcess in ProcessDataList)
            //    if (TempProcess.ID == ID) return TempProcess;
            for (int i = 0; i < ProcessDataList.Count; i++)
                if (((ProcessData)ProcessDataList[i]).ID == ID)
                    return (ProcessData)ProcessDataList[i];

            return PROCESS_DATA_NOT_FOUND;
        }

        private void Refresh(object sender, EventArgs e)
        {
            GetUsage();
            top5_label = top_5();
        }
        //not in use, yet...possibility for adjusting the refresh intervall
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

        public IList top5_list
        {
            get
            {
                return top5_label;
            }
        }

    }



    //holds the time data
    [StructLayout(LayoutKind.Sequential)]
    public struct SYSTEMTIME
    {
        [MarshalAs(UnmanagedType.U2)]
        public short Year;
        [MarshalAs(UnmanagedType.U2)]
        public short Month;
        [MarshalAs(UnmanagedType.U2)]
        public short DayOfWeek;
        [MarshalAs(UnmanagedType.U2)]
        public short Day;
        [MarshalAs(UnmanagedType.U2)]
        public short Hour;
        [MarshalAs(UnmanagedType.U2)]
        public short Minute;
        [MarshalAs(UnmanagedType.U2)]
        public short Second;
        [MarshalAs(UnmanagedType.U2)]
        public short Milliseconds;
    }

    // holds the process info.
    [StructLayout(LayoutKind.Sequential)]
    public struct ProcessEntry32
    {
        public uint Size;
        public uint Usage;
        public uint ID;
        public IntPtr DefaultHeapID;
        public uint ModuleID;
        public uint Threads;
        public uint ParentProcessID;
        public int PriorityClassBase;
        public uint Flags;

        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 256)]
        public string ExeFilename;
    };

    // holds the process time data.
    public struct ProcessTimes
    {
        public DateTime CreationTime, ExitTime, KernelTime, UserTime;
        public ComType.FILETIME RawCreationTime, RawExitTime, RawKernelTime, RawUserTime;

        public void ConvertTime()
        {
            CreationTime = FiletimeToDateTime(RawCreationTime);
            ExitTime = FiletimeToDateTime(RawExitTime);
            KernelTime = FiletimeToDateTime(RawKernelTime);
            UserTime = FiletimeToDateTime(RawUserTime);
        }

        private DateTime FiletimeToDateTime(ComType.FILETIME FileTime)
        {
            try
            {
                if (FileTime.dwLowDateTime < 0) FileTime.dwLowDateTime = 0;
                if (FileTime.dwHighDateTime < 0) FileTime.dwHighDateTime = 0;

                long RawFileTime = (((long)FileTime.dwHighDateTime) << 32) + FileTime.dwLowDateTime;
                return DateTime.FromFileTimeUtc(RawFileTime);
            }
            catch { return new DateTime(); }
        }
    };

}
