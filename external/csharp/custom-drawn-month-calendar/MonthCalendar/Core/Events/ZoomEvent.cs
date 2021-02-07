using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel;

namespace MonthCalendar
{
    public delegate void ZoomEventHandler(object sender, ZoomEventArgs e);

    public class ZoomEventArgs : EventArgs
    {
        private ViewMode m_NewZoom;

        public ZoomEventArgs(ViewMode NewZoom)
        {
            m_NewZoom = NewZoom;
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
    }
}
