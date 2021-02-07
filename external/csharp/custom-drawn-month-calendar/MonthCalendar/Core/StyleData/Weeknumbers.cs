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
    public class WeekNumbersElementStyle
    {
        private Calendar m_Parent = null;
        private Font m_Font = null;
        private Color m_ForeColor = Color.White;
        private BorderStyle m_BStyle = null;
        private BackgroundStyle m_BackgroundStyle = null;
        private WeekNumberAlign m_Align = WeekNumberAlign.Center;
        private bool m_WeekNumbersVisible = false;
        private int m_Alpha = 255;
        private int m_Padding = 5;

        public WeekNumbersElementStyle(Calendar Parent)
        {
            m_Parent = Parent;
            m_BStyle = new BorderStyle(this);
            m_BackgroundStyle = new BackgroundStyle(this);
            m_Font = new Font("Tahoma", 9);
        }

        [Description("Show/hide weeknumbers on left controlside")]
        public bool Visible
        {
            get
            {
                return m_WeekNumbersVisible;
            }
            set
            {
                m_WeekNumbersVisible = value;
                PropertyChanged();
            }
        }

        [Description("Set weeknumbers align")]
        public WeekNumberAlign Align
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

        [Description("set with weeknumbers used font")]
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

        [Description("set with weeknumbers used fontcolor")]
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

        [Description("set weeknumbers font transparent level")]
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
        [Description("set weeknumbers borderstyle")]
        public BorderStyle Border
        {
            get
            {
                return m_BStyle;
            }            
        }

        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        [Description("set weeknumbers backgroundstyle")]
        public BackgroundStyle Background
        {
            get
            {
                return m_BackgroundStyle;
            }           
        }

        [Description("Set space between left border and text startpos")]
        public int Padding
        {
            get
            {
                return m_Padding;
            }
            set
            {
                m_Padding = value;
                PropertyChanged();
            }
        }

        internal void PropertyChanged()
        {
            if (m_Parent != null)
            {
                m_Parent.OnWeekNumbersChanged();
                m_Parent.Invalidate();
            }
        }

    }

}
