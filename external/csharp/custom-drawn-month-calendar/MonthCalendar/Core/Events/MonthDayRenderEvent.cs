using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

namespace MonthCalendar
{
    public delegate void MonthDayRenderEventHandler(object sender, MonthDayRenderEventArgs e);

    public class MonthDayRenderEventArgs :EventArgs
    {
        private Graphics m_Graphics = null;
        private Rectangle m_PaintRect;
        private DayOfWeek m_WeekDay;
        private int m_iDay;
        private bool m_bOwnerDraw = false;
        private bool m_bTrailingDay = false;

        public MonthDayRenderEventArgs(Graphics Graphics, Rectangle PaintRect, DayOfWeek WeekDay, int Day, bool TrailingDay)
        {
            m_Graphics = Graphics;
            m_PaintRect = PaintRect;
            m_WeekDay = WeekDay;
            m_iDay = Day;
            m_bTrailingDay = TrailingDay;
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

        public int Day
        {
            get
            {
                return m_iDay;
            }
            set
            {
                m_iDay = value;
            }
        }

        public bool TrailingDay
        {
            get
            {
                return m_bTrailingDay;
            }
            set
            {
                m_bTrailingDay = value;
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
