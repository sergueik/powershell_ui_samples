// -------------------------------------------------------
//         Logger.cs
//      Use this project for free
//      bye, bye
//          boschiotto4     
// -------------------------------------------------------
using System;
using System.Diagnostics;
using System.IO;

namespace SimpleLogger
{
    // Message LEVEL
    public enum LEVEL { CRITICAL, ERROR, WARNING, INFO, VERBOSE }
    public enum LOGTO { FILE, CONSOLE, DISABLE }

    /// <summary>-------
    /// <para>Simply Logger object</para>
    /// </summary>
    public class Logger
    {
        #region GLOBALS

        // Message ID
        int LOG_ID = 0;

        // For console logging
        private static TraceSource mySource = new TraceSource("LOG");
        
        // No file Text log
        LOGTO NoFileText = LOGTO.FILE;

        private bool log_enable = true;
        private object m_lock = new object();
        String fileName = "log.log";

        LEVEL level = LEVEL.VERBOSE;
        #endregion

        /// <summary>-------
        /// <para>Simply Logger object</para>
        /// </summary>
        /// <param name="file_name">Filename to be used as log, optional: default name is "log.log"</param>
        public Logger(String file_name = null, LOGTO logType = LOGTO.FILE) 
        {
            if(file_name != null)
                fileName = file_name;

            // Check for file path and create it if needed
            String path = Path.GetDirectoryName(fileName);
            if (!Directory.Exists(path) && path.Trim() != "")
                Directory.CreateDirectory(path);

            this.NoFileText = logType;

            Trace.AutoFlush = true;
            mySource.Switch = new SourceSwitch("SourceSwitch", "Verbose");
        }

        /// <summary>-------
        /// <para>The log method to write a message to the log file</para>
        /// </summary>
        /// <param name="level">is the LEVEL object used to identify the type of message. Use "Logger.TYPE.*" to choose the log level</param>
        /// <param name="message">is the text of message</param>
        public void log(LEVEL level, String message) 
        {
            if (NoFileText == LOGTO.DISABLE)
                return;

            if (message == null)
                message = "";
            lock (m_lock)
            {
                if (canLog(level))
                {
                    if (log_enable)
                    {
                        LOG_ID++;
                        if (LOG_ID == 99999)
                            LOG_ID = 0;

                        if (NoFileText == LOGTO.CONSOLE)
                        {
                            mySource.TraceEvent(getFromTypeAnalyzer(level), LOG_ID, message);
                        }

                        if (NoFileText == LOGTO.FILE)
                        {
                            using (StreamWriter w = File.AppendText(fileName))
                            {
                                w.WriteLine(getLine(level, LOG_ID, message));
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
        public void setLevel(LEVEL topLevel)
        {
            level = topLevel;
        }

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
        #endregion

    }
}
