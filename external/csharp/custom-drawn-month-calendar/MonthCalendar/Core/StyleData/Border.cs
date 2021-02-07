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
    public class BorderStyle
    {
        private object m_Parent = null;
        private bool m_Visible = false;
        private Color m_BorderColor = Color.White;
        private int m_BorderColorAlpha = 255;

        public BorderStyle(object Parent)
        {
            //set parent to member
            m_Parent = Parent;
        }
        
        [Browsable(false)]
        public object Parent
        {
            get
            {
                return m_Parent;
            }
            set
            {
                if (m_Parent == null)
                    m_Parent = value;
            }
        }

        [Description("Set border visible/ invisible")]
        public bool Visible
        {
            get
            {
                return m_Visible;
            }
            set
            {
                m_Visible = value;
                PropertiesChanged();
            }
        }

        [Description("Set bordercolor")]
        public Color BorderColor
        {
            get
            {
                return m_BorderColor;
            }
            set
            {
                m_BorderColor = value;
                PropertiesChanged();
            }
        }

        [Description("Set bordercolor transparency level")]
        public int Transparency
        {
            get
            {
                return m_BorderColorAlpha;
            }
            set
            {
                m_BorderColorAlpha = value;
                PropertiesChanged();
            }
        }

        private void PropertiesChanged()
        {
            if (m_Parent != null)
            {
                if (m_Parent is Calendar)
                {
                    ((Calendar)m_Parent).OnBorderChanged();
                }
                else if (m_Parent is HoverElementStyle)
                {
                    ((HoverElementStyle)m_Parent).PropertyChanged();
                }
                else if (m_Parent is MonthDaysElementStyle)
                {
                    ((MonthDaysElementStyle)m_Parent).PropertyChanged();
                }
                else if (m_Parent is ElementStyle)
                {
                    ((ElementStyle)m_Parent).PropertyChanged();
                }
                else if (m_Parent is HeaderElementStyle)
                {
                    ((HeaderElementStyle)m_Parent).PropertyChanged();
                }
                else if (m_Parent is WeekDayElementStyle)
                {
                    ((WeekDayElementStyle)m_Parent).PropertyChanged();
                }
                else if (m_Parent is WeekNumbersElementStyle)
                {
                    ((WeekNumbersElementStyle)m_Parent).PropertyChanged();
                }
                else if (m_Parent is FooterElementStyle)
                {
                    ((FooterElementStyle)m_Parent).PropertyChanged();
                }
            }
        }

    }    
}
