// -------------------------------------------------------
//         Logger.cs
//      Use this project for free
// -------------------------------------------------------

using Microsoft.Win32.SafeHandles;

using System;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;

namespace SimpleLogger
{
    public enum LEVEL { CRITICAL, ERROR, WARNING, INFO, VERBOSE }                  // Message LEVEL
    public enum LOGTO { FILE, CONSOLE, DISABLE, CMD }

    /// <summary>-------
    /// <para>Simply Logger object</para>
    /// </summary>
    public class Logger
    {

#region Dll Import - GetStdHandle - AllocConsole
        [DllImport("kernel32.dll",
            EntryPoint = "GetStdHandle",
            SetLastError = true,
            CharSet = CharSet.Auto,
            CallingConvention = CallingConvention.StdCall)]
        private static extern IntPtr GetStdHandle(int nStdHandle);
        [DllImport("kernel32.dll",
            EntryPoint = "AllocConsole",
            SetLastError = true,
            CharSet = CharSet.Auto,
            CallingConvention = CallingConvention.StdCall)]
        private static extern int AllocConsole();
        private const int STD_OUTPUT_HANDLE = -11;
        private const int MY_CODE_PAGE = 437;
#endregion

#region GLOBALS
        private static TraceSource mySource = new TraceSource("LOG");              // For console logging
        LOGTO logType                    = LOGTO.FILE;                          // No file Text log
        LEVEL level                         = LEVEL.VERBOSE;
        String fileName                     = "log.log";
        int LOG_ID                          = 0;                                   // Message ID
        private bool log_enable             = true;
        private object m_lock               = new object();
#endregion

#region LOG METHODS
        /// <summary>-------
        /// <para>Simply Logger object</para>
        /// </summary>
        /// <param name="fileName">Filename to be used as log, optional: default name is "log.log"</param>
        /// <param name="logType">Indicates the type of log - FILE, CONSOLE, CMD, DISABLE</param>
        public Logger(String fileName = null, LOGTO logType = LOGTO.FILE)
        {
            if (fileName != null)
                this.fileName = fileName;

            if (!fileName.Contains("\\"))
                fileName = AppDomain.CurrentDomain.BaseDirectory + fileName;        // Create the file in the exe dir if not specified

            String path = Path.GetDirectoryName(fileName);
            if (!Directory.Exists(path) && path.Trim() != "")                       // Check for file path and create it if needed
                Directory.CreateDirectory(path);

            this.logType = logType;

            if (logType == LOGTO.CONSOLE)
            {
                Trace.AutoFlush = true;
                mySource.Switch = new SourceSwitch("SourceSwitch", "Verbose");
            }

            if (logType == LOGTO.CMD)
            {
                AllocConsole();
                IntPtr stdHandle = GetStdHandle(STD_OUTPUT_HANDLE);
                SafeFileHandle safeFileHandle = new SafeFileHandle(stdHandle, true);
                FileStream fileStream = new FileStream(safeFileHandle, FileAccess.Write);
                Encoding encoding = System.Text.Encoding.GetEncoding(MY_CODE_PAGE);
                StreamWriter standardOutput = new StreamWriter(fileStream, encoding);
                standardOutput.AutoFlush = true;
                Console.SetOut(standardOutput);
            }
        }

        /// <summary>-------
        /// <para>The log method to write a message to the log file</para>
        /// </summary>
        /// <param name="level">is the LEVEL object used to identify the type of message. Use "Logger.TYPE.*" to choose the log level</param>
        /// <param name="message">is the text of message</param>
        public void log(LEVEL level, String message)
        {
            if (logType == LOGTO.DISABLE)
                return;

            if (message == null)
                message = "";

            if (canLog(level))
            {
                if (log_enable)
                {
                    lock (m_lock)
                    {
                        LOG_ID++;
                        if (LOG_ID == 99999)
                            LOG_ID = 0;

                        if (logType == LOGTO.CONSOLE)
                        {
                            mySource.TraceEvent(getFromTypeAnalyzer(level), LOG_ID, message);
                        }

                        if (logType == LOGTO.FILE)
                        {
                            using (StreamWriter w = File.AppendText(fileName))
                            {
                                w.WriteLine(getLine(level, LOG_ID, message));
                            }
                        }

                        if (logType == LOGTO.CMD)
                        {
                            try
                            {
                                Console.WriteLine(level.ToString() + "|" + LOG_ID + "|" + message);
                            }
                            catch (Exception)
                            {
                                // Do Nothing???
                            }
                        }

                    }
                }
            }

        }

        /// <summary>-------
        /// <para>The log method to write a message to the log file - Verbose Level setted by default</para>
        /// </summary>
        /// <param name="message">is the text of message</param>
        public void log(string p)
        {
            log(LEVEL.VERBOSE, p);
        }

        /// <summary>-------
        /// <para>Used to set the level of logging</para>
        /// </summary>
        /// <param name="level">The level of logging: CRITICAL &lt; ERROR &lt; WARNING &lt; INFO &lt; VERBOSE</param>
        public void setLevel(LEVEL logLevel)
        {
            level = logLevel;
        }
#endregion

#region HELPERS
        private bool canLog(LEVEL lev)
        {
            // Get the level of lev
            if (((int)lev) <= ((int)level))
                return true;
            return false;
        }

        private string getLine(LEVEL type, int p, string message)
        {
            String t = "";
            if (type == LEVEL.CRITICAL)
                t = "Critical";

            if (type == LEVEL.INFO)
                t = "Information";

            if (type == LEVEL.ERROR)
                t = "Error";

            if (type == LEVEL.WARNING)
                t = "Warning";

            if (type == LEVEL.VERBOSE)
                t = "Verbose";

            if (p > 99990)
                p = 0;

            // Add the timestamp to the log
            String timeStamp = DateTime.Now.ToString("yyyy-MM-dd|HH:mm:ss:ffff");

            return p.ToString("00000") + "|" + timeStamp + "|" + t + "|" + message;
        }

        private TraceEventType getFromTypeAnalyzer(LEVEL type)
        {
            TraceEventType t = TraceEventType.Information;
            if (type == LEVEL.CRITICAL)
                t = TraceEventType.Critical;

            if (type == LEVEL.INFO)
                t = TraceEventType.Information;

            if (type == LEVEL.ERROR)
                t = TraceEventType.Error;

            if (type == LEVEL.WARNING)
                t = TraceEventType.Warning;

            if (type == LEVEL.VERBOSE)
                t = TraceEventType.Verbose;

            return t;
        }

        public void disableLog()
        {
            log_enable = false;
        }

        public void enableLog()
        {
            log_enable = true;
        }

        public bool checkLogSize(long byteSize = 0)
        {
            if(fileName != null)
            {
                try
                {
                    FileInfo fileInfo = new FileInfo(fileName);
                
                    if (byteSize == 0)
                        byteSize = 6144000;

                    if (byteSize > 0 && fileInfo.Length > byteSize)
                    {
                        String fName = Path.GetFileNameWithoutExtension(fileName);
                        String fExtension = Path.GetExtension(fileName);
                        String date = String.Format("{0:yyyyMMdd'_'HHmmss}", DateTime.Now);

                        System.IO.File.Move(fileName, fName + "_" + date + fExtension);
                        return false; 
                    }  
                }
                catch (Exception )
                {
                    return true;
                }

            }
            return true; 
        }
#endregion

    }   // Close Class
}       // Close Namespace
