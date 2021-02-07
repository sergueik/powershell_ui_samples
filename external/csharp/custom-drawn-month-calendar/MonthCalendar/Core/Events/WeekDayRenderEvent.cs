using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

namespace MonthCalendar
{
    public delegate void WeekDayRenderEventHandler(object sender, WeekDayRenderEventArgs e);

    public class WeekDayRenderEventArgs : EventArgs
    {
        private Graphics m_Graphics = null;
        private Rectangle m_PaintRect;    
        private DayOfWeek m_WeekDay;
        private bool m_bOwnerDraw = false;
        private string m_sDayName;

        public WeekDayRenderEventArgs(Graphics Graphics, Rectangle PaintRect, DayOfWeek WeekDay, string DayName)
        {
            m_Graphics = Graphics;
            m_PaintRect = PaintRect;
            m_WeekDay = WeekDay;
            m_sDayName = DayName;
        }

        public Graphics Graphics
        {
            get
            {
                return m_Graphics;
            }
            set
            {
                m_Graphics = value;
            }
        }

        public Rectangle PaintRect
        {
            get
            {
                return m_PaintRect;
            }
            set
            {
                m_PaintRect = value;
            }
        }

        public DayOfWeek WeekDay
        {
            get
            {
                return m_WeekDay;
            }
            set
            {
                m_WeekDay = value;
            }
        }

        public string DayName
        {
            get
            {
                return m_sDayName;
            }
            set
            {
                m_sDayName = value;
            }
        }

        public bool OwnerDraw
        {
            get
            {
                return m_bOwnerDraw;
            }
            set
            {
                m_bOwnerDraw = value;
            }
        }
    }
}
