using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics.Eventing.Reader;

namespace SYSInfo
{
    class EventQuery
    {
        string sBootUp = "no data";
        System.Timers.Timer timer;
        EventLogQuery eventsQuery;
        EventLogReader logReader;
        System.Globalization.CultureInfo cInfo = System.Threading.Thread.CurrentThread.CurrentCulture;
        
        public EventQuery()
        {
            initQuery();
            //timer = new System.Timers.Timer(10000);
            //timer.Elapsed += new System.Timers.ElapsedEventHandler(Refresh);
            //timer.Enabled = true;
            //timer.Start();
            logQuery();
        }

        void initQuery()
        {
            string queryString =
                "<QueryList>" +
                "  <Query Id=\"0\" Path=\"System\">" +
                "    <Select Path=\"System\">" +
                "        *[System[Provider[@Name=\"Microsoft-Windows-Kernel-Boot\"] and (EventID=27) and" +
                "        TimeCreated[timediff(@SystemTime) &lt;= 864000000]]]" +
                "    </Select>" +
                "  </Query>" +
                "</QueryList>";

            eventsQuery = new EventLogQuery("System", PathType.LogName, queryString);
            logReader = new EventLogReader(eventsQuery);
        }

        void logQuery()
        {
            logReader.Seek(System.IO.SeekOrigin.End, 0);
            EventRecord eventInstance = logReader.ReadEvent();
            DateTime dt = eventInstance.TimeCreated.Value;
           // sBootUp = dt.ToString("dd.MM.yyyy HH:mm");
            sBootUp = dt.ToString(cInfo);
            sBootUp = sBootUp.Substring(0, sBootUp.Length - 3);
        }

        public string BootUpDate
        {
            get
            {                
                return sBootUp;
            }
        }

        public void Refresh()
        {
            logQuery();
        }

        private void Refresh(object sender, EventArgs e)
        {
            logQuery();
        }

    }
}
