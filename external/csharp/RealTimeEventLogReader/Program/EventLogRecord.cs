using System;
using System.Collections.Generic;
using System.Diagnostics.Eventing.Reader;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RealTimeEventLogReader
{
    public enum LogLevel
    {
        
        Error = 1,
           
        Warning = 2,
           
        Information = 4,
          
        SuccessAudit = 8,
         
        FailureAudit = 16
    }
    class EventLogRecord: ICloneable
    {
        private string levelString;
        private LogLevel level;
        private DateTime timestamp;
        private string source;
        private int eventID;
        private int taskCategory;
        private string detailsXML;
        private string logName;
        private string eventData;

        public string LevelString
        {
            get
            {
                return levelString;
            }

            set
            {
                levelString = value;
            }
        }

        //public LogLevel Level
        //{
        //    get
        //    {
        //        return level;
        //    }

        //    set
        //    {
        //        level = value;
        //    }
        //}

        public DateTime Timestamp
        {
            get
            {
                return timestamp;
            }

            set
            {
                timestamp = value;
            }
        }

        public string Source
        {
            get
            {
                return source;
            }

            set
            {
                source = value;
            }
        }

        public int EventID
        {
            get
            {
                return eventID;
            }

            set
            {
                eventID = value;
            }
        }

        public int TaskCategory
        {
            get
            {
                return taskCategory;
            }

            set
            {
                taskCategory = value;
            }
        }

        public string DetailsXML
        {
            get
            {
                return detailsXML;
            }

            set
            {
                detailsXML = value;
            }
        }

        public string LogName
        {
            get
            {
                return logName;
            }

            set
            {
                logName = value;
            }
        }

        public string EventData
        {
            get
            {
                return eventData;
            }

            set
            {
                eventData = value;
            }
        }

        public EventLogRecord(EventRecord eventdetail)
        {
            eventID = eventdetail.Id;
            detailsXML = eventdetail.ToXml();
            taskCategory = eventdetail.Task.Value;
            timestamp = eventdetail.TimeCreated.Value;
            source = eventdetail.ProviderName;
            //level = (LogLevel)eventdetail.Level.Value;
            levelString = eventdetail.LevelDisplayName;
            logName = eventdetail.LogName;
            eventData = GetEventData(eventdetail);
        }

        private string GetEventData(EventRecord eventdetail)
        {
            StringBuilder eventData = new StringBuilder();
            foreach(EventProperty prop in eventdetail.Properties)
            {
                if(prop.Value is byte[])
                {
                    eventData.Append(prop.Value.ToString() + "\n");
                }
                else
                {
                    eventData.Append(prop.Value.ToString() + "\n");
                }

                
            }

            return eventData.ToString();
        }

        public object Clone()
        {
            return this.MemberwiseClone();
        }
    }
}
