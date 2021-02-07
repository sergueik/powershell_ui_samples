using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;

namespace MonthCalendar
{
    public delegate void CanChangeYearEventHandler(object sender, CanChangeYearEventArgs e);

    public class CanChangeYearEventArgs : EventArgs
    {
        private DateTime m_OldYear;
        private DateTime m_NewYear;
        private bool m_bCanChangeYear = false;

        public CanChangeYearEventArgs(DateTime OldYear, DateTime NewYear)
        {
            m_OldYear = OldYear;
            m_NewYear = NewYear;
        }

        public DateTime OldYear
        {
            get
            {
                return m_OldYear;
            }
            set
            {
                m_OldYear = value;
            }
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

        public bool Cancel
        {
            get
            {
                return m_bCanChangeYear;
            }
            set
            {
                m_bCanChangeYear = value;
            }
        }
    }
}
