using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

namespace MonthCalendar
{
    public delegate void FooterRenverEventHandler(object sender, FooterRenderEventArgs e);

    public class FooterRenderEventArgs : EventArgs
    {
        private Graphics m_Graphics = null;
        private Rectangle m_PaintRect;
        private DateTime m_Date;
        private bool m_bOwnerDraw = false;

        public FooterRenderEventArgs(Graphics Graphics, Rectangle PaintRect, DateTime Date)
        {
            m_Graphics = Graphics;
            m_PaintRect = PaintRect;
            m_Date = Date;
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

        public DateTime Date
        {
            get
            {
                return m_Date;
            }
            set
            {
                m_Date = value;
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
