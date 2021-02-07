using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;

namespace MonthCalendar
{
    public delegate void HeaderRenderEventHandler(object sender, HeaderRenderEventArgs e);

    public class HeaderRenderEventArgs : EventArgs
    {
        private Graphics m_Graphics = null;
        private Rectangle m_PaintRect;
        private string m_sText;
        private bool m_bOwnerDraw = false;

        public HeaderRenderEventArgs(Graphics Graphics, Rectangle HeaderRect, string Text)
        {
            m_Graphics = Graphics;
            m_PaintRect = HeaderRect;
            m_sText = Text;
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

        public Rectangle HeaderRect
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

        public String Text
        {
            get
            {
                return m_sText;
            }
            set
            {
                m_sText = value;
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
