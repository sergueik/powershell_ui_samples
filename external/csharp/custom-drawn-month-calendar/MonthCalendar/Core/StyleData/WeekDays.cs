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
    public class WeekDayElementStyle
    {
        private Calendar m_Parent = null;
        private Font m_Font = null;
        private Color m_ForeColor = Color.White;
        private BorderStyle m_BStyle = null;
        private BackgroundStyle m_BackgroundStyle = null;
        private HeaderAlign m_Align = HeaderAlign.Center;
        private bool m_WeekDaysVisible = true;
        private int m_Alpha = 255;

        public WeekDayElementStyle(Calendar Parent)
        {
            m_Parent = Parent;
            m_BStyle = new BorderStyle(this);
            m_BackgroundStyle = new BackgroundStyle(this);
            m_Font = new Font("Tahoma", 9);
        }

        [Description("set weekdays visible/hide")]
        public bool Visible
        {
            get
            {
                return m_WeekDaysVisible;
            }
            set
            {
                m_WeekDaysVisible = value;
                PropertyChanged();
            }
        }

        [Description("set weekday - caption align")]
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

        [Description("set with weekdays used font")]
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

        [Description("set with weekdays used fontcolor")]
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

        [Description("set weekdaynames transparent level")]
        public int TextTransparency
        {
            get
            {
                return m_Alpha;
            }
            set
            {
                m_Alpha = value;
                PropertyChanged();
            }
        }

        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        [Description("set weekdays borderstyle")]
        public BorderStyle Border
        {
            get
            {
                return m_BStyle;
            }           
        }

        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        [Description("set weekdays backgroundstyle")]
        public BackgroundStyle Background
        {
            get
            {
                return m_BackgroundStyle;
            }            
        }

        internal void PropertyChanged()
        {
            if (m_Parent != null)
            {
                m_Parent.OnWeekDaysChanged();
                m_Parent.Invalidate();
            }
        }

    }
}
