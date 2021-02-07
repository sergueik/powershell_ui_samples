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
    public class BackgroundStyle
    {
        private object m_Parent = null;
        private Color m_BackgroundColor1 = Color.White;
        private Color m_BackgroundColor2 = Color.Black;
        private GradientStyle m_Gradient = GradientStyle.Vertical;
        private EStyle m_EStyle = EStyle.esParent;
        private int m_Alpha = 255;
        private int m_Alpha2 = 255;

        public BackgroundStyle(object Parent)
        {
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

        [Description("set start color to draw an gradient. It will be also used on style - property - value 'color'")]
        public Color StartColor
        {
            get
            {
                return m_BackgroundColor1;
            }
            set
            {
                m_BackgroundColor1 = value;
                PropertiesChanged();
            }
        }

        [Description("set endcolor color for gradient")]
        public Color EndColor
        {
            get
            {
                return m_BackgroundColor2;
            }
            set
            {
                m_BackgroundColor2 = value;
                PropertiesChanged();
            }
        }

        [Description("set the gradientmode on which direction the gradient will be draw")]
        public GradientStyle Gradient
        {
            get
            {
                return m_Gradient;
            }
            set
            {
                m_Gradient = value;
                PropertiesChanged();
            }
        }

        [Description("set style for the background")]
        public EStyle Style
        {
            get
            {
                return m_EStyle;
            }
            set
            {
                m_EStyle = value;
                PropertiesChanged();
            }
        }

        [Description("set startcolor transparency level")]
        public int TransparencyStartColor
        {
            get
            {
                return m_Alpha;
            }
            set
            {
                if (value < 0)
                    value = 0;
                else if (value > 255)
                    value = 255;
                m_Alpha = value;
                PropertiesChanged();
            }
        }

        [Description("set endcolor transparency level")]
        public int TransparencyEndColor
        {
            get
            {
                return m_Alpha2;
            }
            set
            {
                if (value < 0)
                    value = 0;
                else if (value > 255)
                    value = 255;
                m_Alpha2 = value;
                PropertiesChanged();
            }
        }

        private void PropertiesChanged()
        {
            if (m_Parent != null)
            {
                if (m_Parent is Calendar)
                {
                    ((Calendar)m_Parent).Invalidate();
                }
                else if (m_Parent is HoverElementStyle)
                {
                    ((HoverElementStyle)m_Parent).PropertyChanged();
                } if (m_Parent is MonthDaysElementStyle)
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
