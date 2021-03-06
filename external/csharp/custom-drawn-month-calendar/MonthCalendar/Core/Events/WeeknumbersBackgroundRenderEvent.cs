using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

namespace MonthCalendar
{   
    public delegate void WeekNumbersBackgroundEventHandler(object sender, WeekNumbersBackgroundRenderEventArgs e);

    public class WeekNumbersBackgroundRenderEventArgs : EventArgs
    {
        private Graphics m_Graphics = null;
        private Rectangle m_PaintRect;
        private bool m_bOwnerDraw = false;

        public WeekNumbersBackgroundRenderEventArgs(Graphics Graphics, Rectangle PaintRect)
        {
            m_Graphics = Graphics;
            m_PaintRect = PaintRect;
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
