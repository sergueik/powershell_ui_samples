using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

namespace MonthCalendar
{
    public delegate void YearRenderEventHandler(object sender, YearRenderEventArgs e);

    public class YearRenderEventArgs : EventArgs
    {
        private Graphics m_Graphics = null;
        private Rectangle m_PaintRect;
        private string m_sYear = "";
        private bool m_bOwnerDraw = false;

        public YearRenderEventArgs(Graphics Graphics, Rectangle PaintRect, string Year)
        {
            m_Graphics = Graphics;
            m_PaintRect = PaintRect;
            m_sYear = Year;
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

        public string Year
        {
            get
            {
                return m_sYear;
            }
            set
            {
                m_sYear = value;
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
