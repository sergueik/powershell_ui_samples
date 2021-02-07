using System;
using System.Collections.Generic;
using System.Text;

namespace WindowsCalendar
{
    public delegate void DateSelectEventHandler(object sender, DateSelectEventArgs e);

    public class DateSelectEventArgs : EventArgs
    {
        private DateTime m_NewDate;

        public DateSelectEventArgs(DateTime New)
        {
            m_NewDate = New;
        }

        public DateTime New
        {
            get
            {
                return m_NewDate;
            }
            set
            {
                m_NewDate = value;
            }
        }
    }
}
