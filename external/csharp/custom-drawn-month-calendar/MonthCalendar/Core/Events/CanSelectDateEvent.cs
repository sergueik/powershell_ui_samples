using System;
using System.Collections.Generic;
using System.Text;

namespace WindowsCalendar
{
    public delegate void CanSelectDateEventHandler(object sender, CanSelectDateEventArgs e);

    public class CanSelectDateEventArgs : EventArgs
    {
        private DateTime m_New;
        private bool m_bCancel = false;

        public CanSelectDateEventArgs(DateTime New)
        {
            m_New = New;
        }

        public DateTime New
        {
            get
            {
                return m_New;
            }
            set
            {
                m_New = value;
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
