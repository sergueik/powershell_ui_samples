using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.ComponentModel;
using System.Collections;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace MonthCalendar
{
    [TypeConverter(typeof(BackgroundStyleTypeConverter))]
    public class HeaderElementStyle
    {
        private Calendar m_Parent = null;
        private Font m_Font = null;
        private int m_ForeColorAlpha = 255;        
        private bool m_ShowNav = true;
        private bool m_HeaderVisible = true;
        private Color m_ForeColor = Color.White;
        private Color m_HoverColor = Color.DarkGray;
        private MonthDaysPadding m_Padding = null;
        private BorderStyle m_BStyle = null;
        private BackgroundStyle m_BackgroundStyle = null;
        private HeaderAlign m_Align = HeaderAlign.Center;
        public HeaderElementStyle(Calendar Parent)
        {
            m_Parent = Parent;
            m_BStyle = new BorderStyle(this);
            m_BackgroundStyle = new BackgroundStyle(this);
            m_Padding = new MonthDaysPadding(this, 10, 6);
            m_Font = new Font("Tahoma", 9);
        }      

        [Description("set header text align")]
        public HeaderAlign Align
        {
            get
            {
                return m_Align;
            }
            set
            {
                m_Align = value;
                PropertyChanged();
            }
        }

        [Description("set headertext transparent level")]
        public int TextTransparency
        {
            get
            {
                return m_ForeColorAlpha;
            }
            set
            {
                m_ForeColorAlpha = value;
                PropertyChanged();
            }
        }

        [Description("show/hide header navigationbutton to change selected month/year")]
        public bool ShowNav
        {
            get
            {
                return m_ShowNav;
            }
            set
            {
                m_ShowNav = value;
                PropertyChanged();
            }
        }

        [Description("Show/hide header with navigation and month and or year")]
        public bool Visible
        {
            get
            {
                return m_HeaderVisible;
            }
            set
            {
                m_HeaderVisible = value;
                PropertyChanged();
            }
        }

        [Description("set with header used font")]
        public Font Font
        {
            get
            {
                return m_Font;
            }
            set
            {
                m_Font = value;
                PropertyChanged();
            }
        }

        [Description("set with header used fontcolor")]
        public Color ForeColor
        {
            get
            {
                return m_ForeColor;
            }
            set
            {
                m_ForeColor = value;
                PropertyChanged();
            }
        }

        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        [Description("set header borderstyle")]
        public BorderStyle Border
        {
            get
            {
                return m_BStyle;
            }            
        }

        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        [Description("set header backgroundstyle")]
        public BackgroundStyle Background
        {
            get
            {
                return m_BackgroundStyle;
            }            
        }

        [Description("set mouseover color")]
        public Color HoverColor
        {
            get
            {
                return m_HoverColor;
            }
            set
            {
                m_HoverColor = value;
                PropertyChanged();
            }
        }

        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        public MonthDaysPadding Padding
        {
            get
            {
                return m_Padding;
            }
        }

        internal void PropertyChanged()
        {
            if (m_Parent != null)
            {
                m_Parent.OnHeaderChanged();
                m_Parent.Invalidate();
            }
        }

    }
}
