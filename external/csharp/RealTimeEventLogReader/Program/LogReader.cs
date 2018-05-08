using System;
using System.Collections.Generic;
using System.Diagnostics.Eventing.Reader;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace RealTimeEventLogReader
{
    class LogReader
    {
        public delegate void AddRecordDelegate(EventLogRecord record);

        public AddRecordDelegate AddRecord;

        public int ReadInterval = 1000;

        public int LogLimit = 5000;

        public string LogName = string.Empty;

        private bool Stop = true;

        private Thread readerThread = null;
        private DateTime _lastReadTime = DateTime.UtcNow;
        private const string TimeFormatString = "yyyy-MM-ddTHH:mm:ss.fffffff00K";
        private const string EventReaderQuery = "*[System/TimeCreated/@SystemTime >='{0}']";

        public LogReader(string logName)
        {
            LogName = logName;
            StartReader();
       }

        public void StopReader()
        {
            if(readerThread != null && readerThread.IsAlive && !Stop)
            {
                Stop = true;
                readerThread = null;
            }
        }

        public void StartReader()
        {
            if (Stop)
            {
                Stop = false;
                if (readerThread != null)
                {
                    readerThread = null;
                }
                readerThread = new Thread(ReadLogs);
                readerThread.Start();
            }
        }


        private void ReadLogs()
        {
            while (!Stop)
            {
                // 1. Calculate elapsed time since previous read.
                double elapsedTimeSincePreviousRead = (DateTime.UtcNow - _lastReadTime).TotalSeconds;
                DateTime timeSpanToReadEvents = DateTime.UtcNow.AddSeconds(-elapsedTimeSincePreviousRead);
                string strTimeSpanToReadEvents = timeSpanToReadEvents.ToString(TimeFormatString, CultureInfo.InvariantCulture);
                string query = string.Format(EventReaderQuery, strTimeSpanToReadEvents);
                int readEventCount = 0;

                // 2. Create event log query using elapsed time.
                // 3. Read the record using EventLogReader.
                EventLogQuery eventsQuery = new EventLogQuery(LogName, PathType.LogName, query) { ReverseDirection = true };
                EventLogReader logReader = new EventLogReader(eventsQuery);

                // 4. Set lastReadTime to Date.Now
                _lastReadTime = DateTime.UtcNow;

                for (EventRecord eventdetail = logReader.ReadEvent(); eventdetail != null; eventdetail = logReader.ReadEvent())
                {
                    byte[] bytes = null;
                    if (eventdetail.Properties.Count >= 2)
                    {
                        bytes = (byte[])eventdetail.Properties[eventdetail.Properties.Count-1].Value;
                    }
                    EventLogRecord record = new EventLogRecord(eventdetail);

                    // 5. Post record read using event log query.
                    // if (parser.IsValid(temporaryRecord))
                    {
                        PostDetail(record);
                    }
                    // 6. Post only latest InternalLogLimit records, if result of event log query is more than InternalLogLimit.
                    if (++readEventCount >= LogLimit)
                    {
                        break;
                    }
                }
                Thread.Sleep(ReadInterval);
            }
          
        }

        private void PostDetail(params EventLogRecord[] records)
        {
            if (AddRecord != null && records != null)
            {
                //Return each record in the list to the viewer using AddRecord
                foreach (EventLogRecord record in records)
                {
                    if (record != null)
                    {
                        AddRecord.BeginInvoke((EventLogRecord)record.Clone(), null, null);
                    }
                }
            }
        }

    }
}
