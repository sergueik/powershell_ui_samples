using System;
using System.Collections.Generic;
using System.Text;

namespace MonthCalendar
{
    public delegate void CanSelectDayEventHandler(object sender, CanSelectDayEventArgs e);

    public class CanSelectDayEventArgs : EventArgs
    {
        private DateTime m_Date;
        private bool m_bCancel = false;

        public CanSelectDayEventArgs(DateTime Date)
        {
            m_Date = Date;            
        }

        public DateTime Date
        {
            get
            {
                return m_Date;
            }
            set
            {
                m_Date = value;
            }
        }      

        public bool Cancel
        {
            get
            {
                return m_bCancel;
            }
            set
            {
                m_bCancel = value;
            }
        }
    }
}
