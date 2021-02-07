using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;

namespace MonthCalendar
{    
    public delegate void ChangeYearEventHandler(object sender, ChangeYearEventArgs e);

    public class ChangeYearEventArgs : EventArgs
    {
        private DateTime m_NewYear;

        public ChangeYearEventArgs(DateTime NewYear)
        {
            m_NewYear = NewYear;
        }

        public DateTime NewYear
        {
            get
            {
                return m_NewYear;
            }
            set
            {
                m_NewYear = value;
            }
        }
    }
}
