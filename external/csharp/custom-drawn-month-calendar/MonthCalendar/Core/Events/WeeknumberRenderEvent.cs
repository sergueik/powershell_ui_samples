using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

namespace MonthCalendar
{
    public delegate void WeekNumberRenderEventHandler(object sender, WeeknumberRenderEventArgs e);

    public class WeeknumberRenderEventArgs : EventArgs
    {
        private Graphics m_Graphics = null;
        private Rectangle m_PaintRect;
        private int m_iWeekNumber = 0;
        private bool m_bOwnerDraw = false;

        public WeeknumberRenderEventArgs(Graphics Graphics, Rectangle PaintRect, int WeekNumber)
        {
            m_Graphics = Graphics;
            m_PaintRect = PaintRect;
            m_iWeekNumber = WeekNumber;
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

        public int WeekNumber
        {
            get
            {
                return m_iWeekNumber;
            }
            set
            {
                m_iWeekNumber = value;
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
