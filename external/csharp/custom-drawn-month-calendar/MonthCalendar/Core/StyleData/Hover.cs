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
    public class HoverElementStyle
    {
        private object m_Parent = null;
        private Font m_Font = null;
        private Color m_ForeColor = Color.White;
        private BorderStyle m_BStyle = null;
        private BackgroundStyle m_BackgroundStyle = null;

        public HoverElementStyle(object Parent)
        {
            m_Parent = Parent;
            m_BStyle = new BorderStyle(this);
            m_BackgroundStyle = new BackgroundStyle(this);
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
            //refresh parent
            if (m_Parent is MonthDaysElementStyle)
            {
                ((MonthDaysElementStyle)m_Parent).PropertyChanged();
            }
        }

    }
}
