using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;


namespace MonthCalendar
{
    public delegate void CanZoomEventHandler(object sender, CanZoomEventArgs e);

    public class CanZoomEventArgs : EventArgs
    {
        private ViewMode m_OldZoom = ViewMode.vmMonth;
        private ViewMode m_NewZoom = ViewMode.vmMonth;
        private bool m_bCanZoom = true;

        public CanZoomEventArgs(ViewMode OldZoom, ViewMode NewZoom)
        {
            m_OldZoom = OldZoom;
            m_NewZoom = NewZoom;
        }

        public ViewMode OldZoom
        {
            get
            {
                return m_OldZoom;
            }
            set
            {
                m_OldZoom = value;
            }
        }

        public ViewMode NewZoom
        {
            get
            {
                return m_NewZoom;
            }
            set
            {
                m_NewZoom = value;
            }
        }

        public bool CanZoom
        {
            get
            {
                return m_bCanZoom;
            }
            set
            {
                m_bCanZoom = value;
            }
        }
    }
}
