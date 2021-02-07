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
    [TypeConverter(typeof(MonthDaysPaddingTypeConverter))]
    public class MonthDaysPadding
    {
        private object m_Parent = null;
        private int m_iHorizontalPadding = 0;
        private int m_iVerticalPadding = 0;

        public MonthDaysPadding(object Parent)
        {
            m_Parent = Parent;
        }

        public MonthDaysPadding(object Parent, int Horizontal, int Vertical)
        {
            m_Parent = Parent;
            m_iHorizontalPadding = Horizontal;
            m_iVerticalPadding = Vertical;
        }
        public MonthDaysPadding(int Horizontal, int Vertical)
        {
            m_Parent = null;
            m_iHorizontalPadding = Horizontal;
            m_iVerticalPadding = Vertical;
        }

        [Description("set the horizontal space between the items")]
        public int Horizontal
        {
            get
            {
                return m_iHorizontalPadding;
            }
            set
            {
                m_iHorizontalPadding = value;
                PropertyChanged();
            }
        }

        [Description("set the vertical space between the items")]
        public int Vertical
        {
            get
            {
                return m_iVerticalPadding;
            }
            set
            {
                m_iVerticalPadding = value;
                PropertyChanged();
            }
        }

        private void PropertyChanged()
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
                else if (m_Parent is HeaderElementStyle)
                {
                    ((HeaderElementStyle)m_Parent).PropertyChanged();
                }
            }
        }
    }
}
