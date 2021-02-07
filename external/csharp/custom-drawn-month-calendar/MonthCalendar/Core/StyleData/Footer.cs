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
    public class FooterElementStyle
    {
        private Calendar m_Parent = null;
        private Font m_Font = null;
        private Color m_Forecolor = Color.Blue;
        private BorderStyle m_BorderStyle = null;
        private BackgroundStyle m_BackgroundStyle = null;
        private HeaderAlign m_Align = HeaderAlign.Left;
        private DateFormat m_DateFormat = DateFormat.Long;
        private Padding m_Padding;
        private bool m_Visible = true;
        private bool m_ShowLegend = true;
        private string m_Text = "";
        private int m_iTextTransparency = 255; //no transparents

        public FooterElementStyle(Calendar Parent)
        {
            m_Parent = Parent;
            m_Font = new Font("Tahoma", 9);
            m_BorderStyle = new BorderStyle(this);
            m_BackgroundStyle = new BackgroundStyle(this);
            m_Padding = new Padding(20, 5, 20, 5);
        }

        [Description("set show/hide footer")]
        public bool Visible
        {
            get
            {
                return m_Visible;
            }
            set
            {
                m_Visible = value;
                PropertyChanged();
            }
        }

        [Description("set in footer used font")]
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

        [Description("set in footer used fontcolor")]
        public Color ForeColor
        {
            get
            {
                return m_Forecolor;
            }
            set
            {
                m_Forecolor = value;
                PropertyChanged();
            }
        }

        [Description("set footer textalign")]
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

        [Description("set inner space between Text and footer rectangle")]
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

        [Description("set style for footerborder")]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        public BorderStyle Border
        {
            get
            {
                return m_BorderStyle;
            }
        }

        [Description("set backgroundstyle used in footer")]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        public BackgroundStyle Background
        {
            get
            {
                return m_BackgroundStyle;
            }
        }

        [Description("set footer text")]
        public string Text
        {
            get
            {
                return m_Text;
            }
            set
            {
                m_Text = value;
                PropertyChanged();
            }
        }

        [Description("set footer date dateformat")]
        public DateFormat DateFormat
        {
            get
            {
                return m_DateFormat;
            }
            set
            {
                m_DateFormat = value;
                PropertyChanged();
            }
        }

        [Description("set text transparency level")]
        public int TextTransparency
        {
            get
            {
                return m_iTextTransparency;
            }
            set
            {
                m_iTextTransparency = value;
                PropertyChanged();
            }
        }

        /*[Description("show/ hide today rectangle")]
        public bool ShowLegend
        {
            get
            {
                return m_ShowLegend;
            }
            set
            {
                m_ShowLegend = value;
                if (m_Parent != null)
                    m_Parent.Invalidate();
            }
        }*/

        internal void PropertyChanged()
        {
            if (m_Parent != null)
            {
                m_Parent.OnFooterChanged();
                m_Parent.Invalidate();
            }
        }
    }
}
