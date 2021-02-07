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

    #region keyboard steering
    [TypeConverter(typeof(KeyboardControlTypeConverter))]
    public class KeyboardControl
    {
        private bool m_AllowKeyboardSteering = true;
        private Calendar m_Parent;
        private Keys m_Left = Keys.Left;
        private Keys m_Right = Keys.Right;
        private Keys m_Up = Keys.Up;
        private Keys m_Down = Keys.Down;
        private Keys m_Zoomout = Keys.Add;
        private Keys m_Zoomin = Keys.Subtract;
        private Keys m_NextMonth = Keys.Home;
        private Keys m_PrevMonth = Keys.End;
        private Keys m_NextYear = Keys.PageUp;
        private Keys m_PrevYear = Keys.PageDown;
        private Keys m_NavNext = Keys.Insert;
        private Keys m_NavPrev = Keys.Delete;
        private Keys m_GoToday = Keys.F12;
        private Keys m_Select = Keys.Space;
        private ExtendedSelection m_MultiSelection = ExtendedSelection.Ctrl;

        public KeyboardControl(Calendar Parent)
        {
            m_Parent = Parent;
        }

        public ExtendedSelection MultipleSelection
        {
            get
            {
                return m_MultiSelection;
            }
            set
            {
                m_MultiSelection = value;
                if (m_Parent != null)
                    m_Parent.OnKeyboardChange();
            }
        }

        [Description("set it to true to allow the calendar steering with keyboard")]
        public bool AllowKeyboardSteering
        {
            get
            {
                return m_AllowKeyboardSteering;
            }
            set
            {
                m_AllowKeyboardSteering = value;
                if (m_Parent != null)
                    m_Parent.OnKeyboardChange();
            }
        }

        [Description("key to select the previos item")]
        public Keys Left
        {
            get
            {
                return m_Left;
            }
            set
            {
                m_Left = value;
                if (m_Parent != null)
                    m_Parent.OnKeyboardChange();
            }
        }

        [Description("key to select the next item")]
        public Keys Right
        {
            get
            {
                return m_Right;
            }
            set
            {
                m_Right = value;
                if (m_Parent != null)
                    m_Parent.OnKeyboardChange();
            }
        }

        [Description("key to select item from previos row")]
        public Keys Up
        {
            get
            {
                return m_Up;
            }
            set
            {
                m_Up = value;
                if (m_Parent != null)
                    m_Parent.OnKeyboardChange();
            }
        }

        [Description("key to select item from next row")]
        public Keys Down
        {
            get
            {
                return m_Down;
            }
            set
            {
                m_Down = value;
                if (m_Parent != null)
                    m_Parent.OnKeyboardChange();
            }
        }

        [Description("key to zoomout viewed area; Month -> Year; Year -> 12 Years; 12 Years -> 120 Years")]
        public Keys ZoomOut
        {
            get
            {
                return m_Zoomout;
            }
            set
            {
                m_Zoomout = value;
                if (m_Parent != null)
                    m_Parent.OnKeyboardChange();
            }
        }

        [Description("key to zoomin viewed area; 120 Years -> 12 Years; 12Years -> Year, Year -> Month")]
        public Keys Zoomin
        {
            get
            {
                return m_Zoomin;
            }
            set
            {
                m_Zoomin = value;
                if (m_Parent != null)
                    m_Parent.OnKeyboardChange();
            }
        }

        [Description("key to select next month")]
        public Keys NextMonth
        {
            get
            {
                return m_NextMonth;
            }
            set
            {
                m_NextMonth = value;
                if (m_Parent != null)
                    m_Parent.OnKeyboardChange();
            }
        }

        [Description("key to select previous month")]
        public Keys PrevMonth
        {
            get
            {
                return m_PrevMonth;
            }
            set
            {
                m_PrevMonth = value;
                if (m_Parent != null)
                    m_Parent.OnKeyboardChange();
            }
        }

        [Description("key to select next year")]
        public Keys NextYear
        {
            get
            {
                return m_NextYear;
            }
            set
            {
                m_NextYear = value;
                if (m_Parent != null)
                    m_Parent.OnKeyboardChange();
            }
        }

        [Description("key to select previous year")]
        public Keys PrevYear
        {
            get
            {
                return m_PrevYear;
            }
            set
            {
                m_PrevYear = value;
                if (m_Parent != null)
                    m_Parent.OnKeyboardChange();
            }
        }

        [Description("key to raise next navbutton")]
        public Keys NavNext
        {
            get
            {
                return m_NavNext;
            }
            set
            {
                m_NavNext = value;
                if (m_Parent != null)
                    m_Parent.OnKeyboardChange();
            }
        }

        [Description("key to raise previous navbutton")]
        public Keys NavPrev
        {
            get
            {
                return m_NavPrev;
            }
            set
            {
                m_NavPrev = value;
                if (m_Parent != null)
                    m_Parent.OnKeyboardChange();
            }
        }

        [Description("key to select today date")]
        public Keys GoToday
        {
            get
            {
                return m_GoToday;
            }
            set
            {
                m_GoToday = value;
                if (m_Parent != null)
                    m_Parent.OnKeyboardChange();
            }
        }

        [Description("key to select a date")]
        public Keys Select
        {
            get
            {
                return m_Select;
            }
            set
            {
                m_Select = value;
                if (m_Parent != null)
                    m_Parent.OnKeyboardChange();
            }
        }
    }

    #endregion
    
}
