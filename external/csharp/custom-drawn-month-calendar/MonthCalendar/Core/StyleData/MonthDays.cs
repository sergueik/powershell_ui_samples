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
    public class MonthDaysElementStyle
    {
        private Calendar m_Parent = null;
        private Font m_Font = null;
        private Color m_ForeColor = Color.White;
        private Color m_SundayColor = Color.Red;
        private Color m_SaturdayColor = Color.DarkGoldenrod;
        private Color m_TodayColor = Color.Blue;
        private BorderStyle m_BStyle = null;
        private BackgroundStyle m_BackgroundStyle = null;
        private ContentAlignment m_Align = ContentAlignment.MiddleCenter;
        private HoverElementStyle m_HoverStyle = null;
        private ElementStyle m_SelectedDay = null;
        private ElementStyle m_TrailingDays = null;
        private Padding m_Padding;
        private MonthDaysPadding m_DaysPadding = null;
        private int m_Alpha = 255;
        private bool m_bMarkSunday = true;
        private bool m_bMarkSaturday = false;
        private bool m_bMarkToday = true;
        private bool m_bMarkSelectedDay = true;
        private bool m_bMarkHover = true;
        private bool m_bShowTrailingDays = true;

        public MonthDaysElementStyle(Calendar Parent)
        {
            m_Parent = Parent;
            m_BStyle = new BorderStyle(this);
            m_BackgroundStyle = new BackgroundStyle(this);
            m_SelectedDay = new ElementStyle(this);
            m_SelectedDay.ForeColor = Color.Black;
            m_SelectedDay.Background.StartColor = Color.FromArgb(230, 222, 185);
            m_SelectedDay.Background.Style = EStyle.esColor;
            m_HoverStyle = new HoverElementStyle(this);
            m_HoverStyle.Background.StartColor = Color.Blue;
            m_HoverStyle.Background.TransparencyStartColor = 128;
            m_HoverStyle.Background.Style = EStyle.esColor;
            m_HoverStyle.Border.BorderColor = Color.DarkBlue;
            m_HoverStyle.Border.Transparency = 128;
            m_HoverStyle.Border.Visible = true;
            m_TrailingDays = new ElementStyle(this);
            m_TrailingDays.ForeColor = Color.FromArgb(140, 140, 140);
            m_TrailingDays.Background.Style = EStyle.esParent;

            m_Padding = new Padding(2);
            m_Font = new Font("Tahoma", 9);
            m_DaysPadding = new MonthDaysPadding(this, 2, 2);
        }

        [Description("set monthday align")]
        public ContentAlignment Align
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

        [Description("set with monthdays used font")]
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

        [Description("set with monthdays used fontcolor")]
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

        [Description("set monthdays font transparent level")]
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
        [Description("set monthdays borderstyle")]
        public BorderStyle Border
        {
            get
            {
                return m_BStyle;
            }            
        }

        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        [Description("set monthdays backgroundstyle")]
        public BackgroundStyle Background
        {
            get
            {
                return m_BackgroundStyle;
            }            
        }

        [Description("set color with mark sunday")]
        public Color SundayColor
        {
            get
            {
                return m_SundayColor;
            }
            set
            {
                m_SundayColor = value;
                PropertyChanged();
            }
        }

        [Description("set true to mark sunday")]
        public bool MarkSunday
        {
            get
            {
                return m_bMarkSunday;
            }
            set
            {
                m_bMarkSunday = value;
                PropertyChanged();
            }
        }

        [Description("set true to mark saturday with a special fontcolor")]
        public bool MarkSaturday
        {
            get
            {
                return m_bMarkSaturday;
            }
            set
            {
                m_bMarkSaturday = value;
                PropertyChanged();
            }
        }

        [Description("set the color to mark saturday")]
        public Color SaturdayColor
        {
            get
            {
                return m_SaturdayColor;
            }
            set
            {
                m_SaturdayColor = value;
                PropertyChanged();
            }
        }

        [Description("set color with mark today")]
        public Color TodayColor
        {
            get
            {
                return m_TodayColor;
            }
            set
            {
                m_TodayColor = value;
                PropertyChanged();
            }
        }

        [Description("set true to mark today")]
        public bool MarkToday
        {
            get
            {
                return m_bMarkToday;
            }
            set
            {
                m_bMarkToday = value;
                PropertyChanged();
            }
        }

        [Description("indicates wether selected mark with a other style")]
        public bool MarkSelectedDay
        {
            get
            {
                return m_bMarkSelectedDay;
            }
            set
            {
                m_bMarkSelectedDay = value;
                PropertyChanged();
            }
        }

        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        [Description("set selected day style")]
        public ElementStyle SelectedDay
        {
            get
            {
                return m_SelectedDay;
            }            
        }

        [Description("set true to mark day if mouse is over monthdays")]
        public bool MarkHover
        {
            get
            {
                return m_bMarkHover;
            }
            set
            {
                m_bMarkHover = value;
                PropertyChanged();
            }
        }

        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        [Description("set style for mouseover on monthdays")]
        public HoverElementStyle HoverStyle
        {
            get
            {
                return m_HoverStyle;
            }            
        }

        [Description("set true to show days from other months")]
        public bool ShowTrailingDays
        {
            get
            {
                return m_bShowTrailingDays;
            }
            set
            {
                m_bShowTrailingDays = value;
                PropertyChanged();
            }
        }

        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        [Description("set style for days from other months")]
        public ElementStyle TrailingDays
        {
            get
            {
                return m_TrailingDays;
            }            
        }

        public Padding Padding
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

        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        [Description("set space between the items")]
        public MonthDaysPadding DaysPadding
        {
            get
            {
                return m_DaysPadding;
            }            
        }

        internal void PropertyChanged()
        {
            //notify that properties has been changed
            if (m_Parent != null)
            {
                m_Parent.OnMonthDaysChanged();
                m_Parent.Invalidate();
            }
        }
    }
}
