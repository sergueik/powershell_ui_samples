using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

namespace MonthCalendar
{
    public delegate void MonthRenderEventHandler(object sender, MonthRenderEventArgs e);

    public class MonthRenderEventArgs : EventArgs
    {
        private Graphics m_Graphics = null;
        private Rectangle m_PaintRect;
        private string m_sMonthName = "";
        private bool m_bOwnerDraw = false;

        public MonthRenderEventArgs(Graphics Graphics, Rectangle PaintRect, string MonthName)
        {
            m_Graphics = Graphics;
            m_PaintRect = PaintRect;
            m_sMonthName = MonthName;
            m_bOwnerDraw = false;
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

        public string Monthname
        {
            get
            {
                return m_sMonthName;
            }
            set
            {
                m_sMonthName = value;
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
