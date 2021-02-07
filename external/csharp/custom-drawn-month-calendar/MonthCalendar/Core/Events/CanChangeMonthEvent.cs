using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;

namespace MonthCalendar
{
    public delegate void CanChangeMonthEventHandler(object sender, CanChangeMonthEventArgs e);

    public class CanChangeMonthEventArgs : EventArgs
    {
        private DateTime m_OldMonth;
        private DateTime m_NewMonth;
        private bool m_bCancel = false;

        public CanChangeMonthEventArgs(DateTime OldMonth, DateTime NewMonth)
        {
            m_OldMonth = OldMonth;
            m_NewMonth = NewMonth;
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

        public DateTime Old
        {
            get
            {
                return m_OldMonth;
            }
            set
            {
                m_OldMonth = value;
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
