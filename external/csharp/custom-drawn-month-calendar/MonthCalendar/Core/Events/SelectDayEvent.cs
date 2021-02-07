using System;
using System.Collections.Generic;
using System.Text;

namespace MonthCalendar
{
    public delegate void SelectDayEventHandler(object sender, SelectDayEventArgs e);

    public class SelectDayEventArgs : EventArgs
    {
        private DateTime m_SelDate;

        public SelectDayEventArgs(DateTime Date)
        {
            m_SelDate = Date;
        }

        public DateTime Date
        {
            get
            {
                return m_SelDate;
            }
            set
            {
                m_SelDate = value;
            }
        }
    }
}
