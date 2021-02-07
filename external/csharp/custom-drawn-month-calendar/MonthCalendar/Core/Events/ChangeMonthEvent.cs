using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;

namespace MonthCalendar
{
    public delegate void ChangeMonthEventHandler(object sender, ChangeMonthEventArgs e);

    public class ChangeMonthEventArgs : EventArgs
    {
        private DateTime m_NewMonth;

        public ChangeMonthEventArgs(DateTime New)
        {
            m_NewMonth = New;
        }

        public DateTime New
        {
            get
            {
                return m_NewMonth;
            }
            set
            {
                m_NewMonth = value;
            }
        }
    }
}
