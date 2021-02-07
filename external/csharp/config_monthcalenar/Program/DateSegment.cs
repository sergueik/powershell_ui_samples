//Copyright 2013 by Peter Ringering.
//Feel free to use this code how ever you wish, but please don't remove this comment block.

using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;

namespace CompleteDateTimePicker
{
    internal enum enumDateSegments
    {
        Month = 0,
        Day = 1,
        Year = 2,
        Hour = 3,
        Minute = 4,
        Second = 5,
        AMPM = 6,
    }
    //---------------------------------------------------------------------------------------------------------------------------------------
    internal class DateSegment
    {
        protected int m_nSegmentStart = 0;
        protected int m_nSegmentEnd = 0;
        protected TextBox m_txtDate = null;
        protected char m_cChar = '0';
        protected CompleteDateTimePickerControl m_ctlControl = null;
        protected char m_cFormatChar = 'M';

        public DateSegment(CompleteDateTimePickerControl ctlControl, char cChar, int nSegmentStart, int nSegmentEnd, TextBox txtDate, char cFormatChar)
        {
            m_ctlControl = ctlControl;
            m_cChar = cChar;
            m_nSegmentStart = nSegmentStart;
            m_nSegmentEnd = nSegmentEnd;
            m_txtDate = txtDate;
            m_cFormatChar = cFormatChar;
        }
        public virtual bool SegmentProcessChar()
        {
            m_ctlControl.CheckAllSelectedResetControl();
            m_ctlControl.ReplaceDateCharAdvance(m_cChar, m_nSegmentEnd);
            return true;
        }
        protected bool ValNumeric()
        {
            if (m_cChar < '0' || m_cChar > '9')
                return false;

            return true;
        }
        protected string GetNewSegmentText()
        {
            string szOldText = GBLMethods.MidStr(m_txtDate.Text, m_nSegmentStart, (m_nSegmentEnd - m_nSegmentStart) + 1);
            int nCharIndex = m_txtDate.SelectionStart - m_nSegmentStart;
            string szNewValue = GBLMethods.LeftStr(szOldText, nCharIndex)
                + m_cChar
                + GBLMethods.RightStr(szOldText, (szOldText.Length - nCharIndex) - 1);
            return szNewValue;
        }
        public string GetCurrentValue()
        {
            string szValue = "";
            if (m_nSegmentStart >= 0 && m_nSegmentEnd >= 0)
                szValue = GBLMethods.MidStr(m_txtDate.Text, m_nSegmentStart, (m_nSegmentEnd - m_nSegmentStart) + 1);
            return szValue;
        }
    }
    //---------------------------------------------------------------------------------------------------------------------------------------
    internal class DateSegmentMonth : DateSegment
    {
        public DateSegmentMonth(CompleteDateTimePickerControl ctlControl, char cChar, int nSegmentStart, int nSegmentEnd, TextBox txtDate, char cFormatChar)
            : base(ctlControl, cChar, nSegmentStart, nSegmentEnd, txtDate, cFormatChar)
        {
        }
        public override bool SegmentProcessChar()
        {
            if (!ValNumeric())
                return false;

            if (m_txtDate.SelectionStart == m_nSegmentStart)
            {
                if (m_cChar < '0' || m_cChar > '1')
                    return false;
            }
            else
            {
                int nNewValue = GBLMethods.CInt(GetNewSegmentText());
                if (nNewValue > 12)
                    return false;
            }
            return base.SegmentProcessChar();
        }
        public int GetMonthValue()
        {
            return GBLMethods.CInt(GetCurrentValue());
        }
    }
    //---------------------------------------------------------------------------------------------------------------------------------------
    internal class DateSegmentDay : DateSegment
    {
        public DateSegmentDay(CompleteDateTimePickerControl ctlControl, char cChar, int nSegmentStart, int nSegmentEnd, TextBox txtDate, char cFormatChar)
            : base(ctlControl, cChar, nSegmentStart, nSegmentEnd, txtDate, cFormatChar)
        {
        }
        public override bool SegmentProcessChar()
        {
            if (!ValNumeric())
                return false;

            DateSegmentMonth objMonth = m_ctlControl.GetDateSegment(enumDateSegments.Month) as DateSegmentMonth;
            int nMonth = objMonth.GetMonthValue();
            DateSegmentYear objYear = m_ctlControl.GetDateSegment(enumDateSegments.Year) as DateSegmentYear;
            int nYear = objYear.GetYearValue();

            if (m_txtDate.SelectionStart == m_nSegmentStart)
            {
                if (m_cChar < '0' || m_cChar > '3')
                    return false;
                if (nMonth == 2 && m_cChar == '3')
                    return false;
            }
            else
            {
                int nNewValue = GBLMethods.CInt(GetNewSegmentText());
                if (nNewValue > 31)
                    return false;

                if (nYear > 0 && nMonth > 0)
                    if (nNewValue > GBLMethods.GetLastDay(nMonth, nYear))
                        return false;
            }
            return base.SegmentProcessChar();
        }
    }
    //---------------------------------------------------------------------------------------------------------------------------------------
    internal class DateSegmentYear : DateSegment
    {
        public DateSegmentYear(CompleteDateTimePickerControl ctlControl, char cChar, int nSegmentStart, int nSegmentEnd, TextBox txtDate, char cFormatChar)
            : base(ctlControl, cChar, nSegmentStart, nSegmentEnd, txtDate, cFormatChar)
        {
        }
        public override bool SegmentProcessChar()
        {
            if (!ValNumeric())
                return false;

            return base.SegmentProcessChar();
        }
        public int GetYearValue()
        {
            return GBLMethods.CInt(GetCurrentValue());
        }
    }
    //---------------------------------------------------------------------------------------------------------------------------------------
    internal class DateSegmentHour : DateSegment
    {
        public DateSegmentHour(CompleteDateTimePickerControl ctlControl, char cChar, int nSegmentStart, int nSegmentEnd, TextBox txtDate, char cFormatChar)
            : base(ctlControl, cChar, nSegmentStart, nSegmentEnd, txtDate, cFormatChar)
        {
        }
        public override bool SegmentProcessChar()
        {
            if (!ValNumeric())
                return false;

            int nNewHour = GBLMethods.CInt(GetNewSegmentText());
            if (m_cFormatChar == 'h')
            {
                if (m_txtDate.SelectionStart == m_nSegmentStart)
                {
                    if (m_cChar < '0' || m_cChar > '1')
                        return false;
                }
                else
                    if (nNewHour > 12)
                        return false;
            }
            else
            {
                if (m_txtDate.SelectionStart == m_nSegmentStart)
                {
                    if (m_cChar < '0' || m_cChar > '2')
                        return false;
                }
                else
                    if (nNewHour > 23)
                        return false;
            }
            return base.SegmentProcessChar();
        }
    }
    //---------------------------------------------------------------------------------------------------------------------------------------
    internal class DateSegmentMinuteSecond : DateSegment
    {
        public DateSegmentMinuteSecond(CompleteDateTimePickerControl ctlControl, char cChar, int nSegmentStart, int nSegmentEnd, TextBox txtDate, char cFormatChar)
            : base(ctlControl, cChar, nSegmentStart, nSegmentEnd, txtDate, cFormatChar)
        {
        }
        public override bool SegmentProcessChar()
        {
            if (!ValNumeric())
                return false;

            int nNewValue = GBLMethods.CInt(GetNewSegmentText());
            if (nNewValue > 59)
                return false;

            return base.SegmentProcessChar();
        }
    }
    //---------------------------------------------------------------------------------------------------------------------------------------
    internal class DateSegmentAMPM : DateSegment
    {
        public DateSegmentAMPM(CompleteDateTimePickerControl ctlControl, char cChar, int nSegmentStart, int nSegmentEnd, TextBox txtDate, char cFormatChar)
            : base(ctlControl, cChar, nSegmentStart, nSegmentEnd, txtDate, cFormatChar)
        {
        }
        public override bool SegmentProcessChar()
        {
            string szChar = "";
            szChar += m_cChar;
            szChar = szChar.ToUpper();
            m_cChar = szChar[0];

            if (m_txtDate.SelectionStart == m_nSegmentStart)
            {
                if (!(m_cChar == 'A' || m_cChar == 'P'))
                    return false;
            }
            else
                if (m_cChar != 'M')
                    return false;

            return base.SegmentProcessChar();
        }
    }
    //---------------------------------------------------------------------------------------------------------------------------------------
}
