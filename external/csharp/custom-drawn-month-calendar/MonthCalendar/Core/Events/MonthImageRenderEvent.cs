using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

namespace MonthCalendar
{
    public delegate void MonthImageRenderEventHandler(object sender, MonthImageRenderEventArgs e);

    public class MonthImageRenderEventArgs : EventArgs
    {
        private Graphics m_Graphics = null;
        private Rectangle m_PaintRect;
        private Image m_MonthImage = null;
        private bool m_bOwnerDraw = false;

        public MonthImageRenderEventArgs(Graphics Graphics, Rectangle PaintRect, Image MonthImage)
        {
            m_Graphics = Graphics;
            m_PaintRect = PaintRect;
            m_MonthImage = MonthImage;
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

        public Image MonthImage
        {
            get
            {
                return MonthImage;
            }
            set
            {
                MonthImage = value;
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
