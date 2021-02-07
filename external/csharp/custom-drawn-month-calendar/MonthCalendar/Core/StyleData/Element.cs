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
    public class ElementStyle
    {
        private object m_Parent = null;
        private Font m_Font = null;
        private Color m_ForeColor = Color.White;
        private BorderStyle m_BStyle = null;
        private BackgroundStyle m_BackgroundStyle = null;

        public ElementStyle(object Parent)
        {
            m_Parent = Parent;
            m_BStyle = new BorderStyle(this);
            m_BackgroundStyle = new BackgroundStyle(this);
            m_Font = new Font("Tahoma", 9);
        }

        [Description("set used font")]
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

        [Description("set used fontcolor")]
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
        public BorderStyle Border
        {
            get
            {
                return m_BStyle;
            }            
        }

        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
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
                if (m_Parent is Calendar)
                {
                    ((Calendar)m_Parent).Invalidate();
                }
                else if (m_Parent is MonthDaysElementStyle)
                {
                    ((MonthDaysElementStyle)m_Parent).PropertyChanged();
                }
            }
        }
        

    }
}
