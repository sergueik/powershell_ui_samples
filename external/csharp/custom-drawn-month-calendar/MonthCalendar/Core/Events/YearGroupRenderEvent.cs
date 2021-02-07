using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

namespace MonthCalendar
{
    public delegate void YearGroupRenderEventHandler(object sender, YearGroupRenderEventArgs e);

    public class YearGroupRenderEventArgs : EventArgs
    {
        private Graphics m_Graphics = null;
        private Rectangle m_PaintRect;
        private string m_sYearGroup = "";
        private bool m_bOwnerDraw = false;

        public YearGroupRenderEventArgs(Graphics Graphics, Rectangle PaintRect, string YearGroup)
        {
            m_Graphics = Graphics;
            m_PaintRect = PaintRect;
            m_sYearGroup = YearGroup;
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

        public string YearGroup
        {
            get
            {
                return m_sYearGroup;
            }
            set
            {
                m_sYearGroup = value;
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
