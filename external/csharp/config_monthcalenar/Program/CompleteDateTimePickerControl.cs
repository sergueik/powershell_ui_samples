//Copyright 2013 by Peter Ringering.
//Feel free to use this code how ever you wish, but please don't remove this comment block.

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;

namespace CompleteDateTimePicker
{
    public partial class CompleteDateTimePickerControl : UserControl
    {
        #region Variables, Properties and Events
        private Rectangle m_rectButton;
        private System.Windows.Forms.VisualStyles.ComboBoxState m_eButtonState = System.Windows.Forms.VisualStyles.ComboBoxState.Normal;

        private string m_szDateEntryFormat = "MM/dd/yyyy";
        private string m_szDateDisplayFormat = "MM/dd/yyyy";
        private string m_szTimeEntryFormat = "";
        private string m_szTimeDisplayFormat = "";
        private string m_szCombinedEntryFormat = "";
        private string m_szCombinedDisplayFormat = "";
        private string m_szDateTimeEntryPattern = ""; //Used as the pattern when entering data.
        private bool m_bValidDateFormat = true;
        private bool m_bValidTimeFormat = true;
        private DateTime m_dteMaxDate = DateTime.MaxValue;
        private DateTime m_dteMinDate = DateTime.MinValue;

        protected const string NOSUPPORTDATECHARS = "fFgKz%\\";

        private MonthCalendar m_ctlCalendar = null;
        private PopupWindow m_wndCalendar = null;

        /// <summary>
        /// Get to check if both the date and time formats are valid.
        /// </summary>
        public bool ValidFormatStrings { get { return m_bValidDateFormat && m_bValidTimeFormat; } }
        /// <summary>
        /// Gets the pattern in 0's how the date and time are entered.
        /// </summary>
        public string DateTimeEntryPattern
        {
            get { return m_szDateTimeEntryPattern; }
        }
        /// <summary>
        /// Gets and sets the displayed date format string.
        /// </summary>
        public string DateFormat
        {
            get
            {
                return m_szDateDisplayFormat;
            }
            set
            {
                m_szDateDisplayFormat = value;
                ValidateDateFormat();
                SetDateTimeEntryPattern();
                ReformatDateControl(m_szCombinedDisplayFormat);
            }
        }
        /// <summary>
        /// Gets and sets the displayed time format string.
        /// </summary>
        public string TimeFormat
        {
            get
            {
                return m_szTimeDisplayFormat;
            }
            set
            {
                m_szTimeDisplayFormat = value;
                ValidateTimeFormat();
                SetDateTimeEntryPattern();
                ReformatDateControl(m_szCombinedDisplayFormat);
            }
        }
        /// <summary>
        /// Gets the displayed combined date and time format string.
        /// </summary>
        public string DateTimeFormat { get { return m_szCombinedDisplayFormat; } }

        /// <summary>
        /// Gets and sets the displayed date and time in the text part of the control.  Computer will beep if set value is not a valid date or time.
        /// </summary>
        public override string Text
        {
            get
            {
                if (txtDate.Text == m_szDateTimeEntryPattern)
                    return "";

                return txtDate.Text;
            }
            set
            {
                if (string.IsNullOrEmpty(value))
                {
                    if (this.ContainsFocus)
                        txtDate.Text = m_szDateTimeEntryPattern;
                    else
                        txtDate.Text = "";
                }
                else
                {
                    if (IsDateValid(value) == IsDateValidResult.Valid)
                    {
                        if (m_bValidDateFormat && m_bValidTimeFormat)
                            txtDate.Text = GBLMethods.FormatDate(GBLMethods.CDate(value, m_szCombinedDisplayFormat), m_szCombinedDisplayFormat);
                        else if (!DesignMode)
                            GBLMethods.MessageBeep(MessageBeepTypes.Default);
                    }
                    else if (!DesignMode)
                        GBLMethods.MessageBeep(MessageBeepTypes.Default);
                }
            }
        }
        /// <summary>
        /// Gets the displayed text in the textbox as is.
        /// </summary>
        public string FormattedText
        {
            get
            {
                return txtDate.Text;
            }
        }
        /// <summary>
        /// Gets and sets the DateTime value in the control.  Computer will beep if the control has an invalid date.
        /// </summary>
        public DateTime Value
        {
            get
            {
                DateTime dteValue = DateTime.MinValue;
                if (txtDate.Text == m_szDateTimeEntryPattern)
                    return dteValue;

                if (this.ValidDate == IsDateValidResult.Valid)
                    dteValue = GBLMethods.CDate(txtDate.Text, m_szCombinedEntryFormat);
                else if (!DesignMode)
                    GBLMethods.MessageBeep(MessageBeepTypes.Default);

                return dteValue;
            }
            set
            {
                if (m_bValidDateFormat && m_bValidTimeFormat)
                {
                    if (value == DateTime.MinValue && DesignMode)
                        txtDate.Text = m_szDateTimeEntryPattern;
                    else if (value == DateTime.MinValue)
                        txtDate.Text = "";
                    else
                        txtDate.Text = GBLMethods.FormatDate(value, m_szCombinedDisplayFormat);
                    OnValueChanged(new EventArgs());
                }
                else if (!DesignMode)
                    GBLMethods.MessageBeep(MessageBeepTypes.Default);
            }
        }
        /// <summary>
        /// Gets and sets the textbox's background color.
        /// </summary>
        public override Color BackColor
        {
            get
            {
                return base.BackColor;
            }
            set
            {
                base.BackColor = value;
                txtDate.BackColor = value;
            }
        }
        /// <summary>
        /// Gets and sets the textbox's foreground color.
        /// </summary>
        public override Color ForeColor
        {
            get
            {
                return base.ForeColor;
            }
            set
            {
                base.ForeColor = value;
                txtDate.ForeColor = value;
            }
        }
        /// <summary>
        /// Gets and sets the textbox's font.
        /// </summary>
        public override Font Font
        {
            get
            {
                return base.Font;
            }
            set
            {
                base.Font = value;
                txtDate.Font = value;
            }
        }
        /// <summary>
        /// Gets and sets the textbox's context menu strip.
        /// </summary>
        public override ContextMenuStrip ContextMenuStrip
        {
            get
            {
                return txtDate.ContextMenuStrip;
            }
            set
            {
                txtDate.ContextMenuStrip = value;
            }
        }
        /// <summary>
        /// Gets and sets the textbox's selection start.
        /// </summary>
        public int SelectionStart
        {
            get
            {
                return txtDate.SelectionStart;
            }
            set
            {
                txtDate.SelectionStart = value;
            }
        }
        /// <summary>
        /// Gets and sets the textbox's selection length.
        /// </summary>
        public int SelectionLength
        {
            get
            {
                return txtDate.SelectionLength;
            }
            set
            {
                txtDate.SelectionLength = value;
            }
        }
        /// <summary>
        /// Gets and sets the maximum date value allowed.
        /// </summary>
        public DateTime MaxDate
        {
            get { return m_dteMaxDate; }
            set { m_dteMaxDate = value; }
        }
        /// <summary>
        /// Gets and sets the minimum date value allowed.
        /// </summary>
        public DateTime MinDate
        {
            get { return m_dteMinDate; }
            set { m_dteMinDate = value; }
        }
        /// <summary>
        /// Gets to check if the value in the date textbox is a valid date.
        /// </summary>
        public IsDateValidResult ValidDate
        {
            get
            {
                return IsDateValid(txtDate.Text);
            }
        }
        //-----------------------------------------------------------------------------
        public delegate void ValueChangedEventHandler(Object sender, EventArgs e);
        /// <summary>
        /// Fired when the date and/or time value changes.
        /// </summary>
        public event ValueChangedEventHandler ValueChanged;
        /// <summary>
        /// Fires ValueChanged Event when the date and/or time value changes.
        /// </summary>
        protected virtual void OnValueChanged(EventArgs eventargs)
        {
            if (ValueChanged != null)
                ValueChanged(this, eventargs);
        }
        //-----------------------------------------------------------------------------
        #endregion

        #region Constructor/Setup
        public CompleteDateTimePickerControl()
        {
            InitializeComponent();
            //m_szCombinedEntryFormat = m_szDateEntryFormat + m_szTimeEntryFormat;
            m_rectButton = btnCalendar.ClientRectangle;

            m_ctlCalendar = new MonthCalendar();
            m_ctlCalendar.MaxSelectionCount = 1;
            m_wndCalendar = new PopupWindow(m_ctlCalendar);

            btnCalendar.Paint += btnCalendar_Paint;
            btnCalendar.MouseMove += btnCalendar_MouseMove;
            btnCalendar.MouseLeave += btnCalendar_MouseLeave;

            btnCalendar.Click += btnCalendar_Click;
            txtDate.KeyDown += txtDate_KeyDown;
            m_wndCalendar.Closed += m_wndCalendar_Closed;
            m_ctlCalendar.DateChanged += m_ctlCalendar_DateChanged;
            m_ctlCalendar.DateSelected += m_ctlCalendar_DateSelected;

            txtDate.KeyPress += txtDate_KeyPress;

            ValidateDateFormat();
            ValidateTimeFormat();
            SetDateTimeEntryPattern();
        }
        private void ValidateDateFormat()
        {
            if (string.IsNullOrEmpty(m_szDateDisplayFormat))
            {
                m_szDateEntryFormat = m_szDateDisplayFormat;
                m_bValidDateFormat = true;
                return;
            }
            //Get rid of date format characters that we don't support.
            m_szDateDisplayFormat = GBLMethods.StripText(m_szDateDisplayFormat, NOSUPPORTDATECHARS + "hHmst");
            bool bValid = GBLMethods.ValidateFormatString(m_szDateDisplayFormat);
            if (bValid)
            {
                m_szDateEntryFormat = m_szDateDisplayFormat;

                //Non-numeric date format strings dddd and MMMM--> becomes MM/dd/yyyy string.
                if (m_szDateEntryFormat.Contains("dddd") || m_szDateEntryFormat.Contains("MMMM"))
                    m_szDateEntryFormat = "MM/dd/yyyy";

                ScrubFormatSegment(ref m_szDateEntryFormat, "MM");
                ScrubFormatSegment(ref m_szDateEntryFormat, "dd");
                ScrubFormatSegment(ref m_szDateEntryFormat, "yyyy");

                m_bValidDateFormat = true;
            }
            else
            {
                m_bValidDateFormat = false;
                m_szDateEntryFormat = "";
                MessageBox.Show("Invalid date format string", "Invalid Format String", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
        }
        private void ValidateTimeFormat()
        {
            if (string.IsNullOrEmpty(m_szTimeDisplayFormat))
            {
                m_szTimeEntryFormat = m_szTimeDisplayFormat;
                m_bValidTimeFormat = true;
                return;
            }
            //Get rid of time format characters that we don't support.
            m_szTimeDisplayFormat = GBLMethods.StripText(m_szTimeDisplayFormat, NOSUPPORTDATECHARS + "Mdy");
            bool bValid = GBLMethods.ValidateFormatString(m_szTimeDisplayFormat);
            if (bValid)
            {
                m_szTimeEntryFormat = m_szTimeDisplayFormat;
                ScrubFormatSegment(ref m_szTimeEntryFormat, "hh");
                ScrubFormatSegment(ref m_szTimeEntryFormat, "HH");
                ScrubFormatSegment(ref m_szTimeEntryFormat, "mm");
                ScrubFormatSegment(ref m_szTimeEntryFormat, "ss");
                ScrubFormatSegment(ref m_szTimeEntryFormat, "tt");

                m_bValidTimeFormat = true;
            }
            else
            {
                m_bValidTimeFormat = false;
                m_szTimeEntryFormat = "";
                MessageBox.Show("Invalid time format string", "Invalid Format String", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
        }
        private void ScrubFormatSegment(ref string szFormat, string szFormatSegment)
        {
            int nFirstSegIndex = -1;
            int nLastSegIndex = -1;
            GetSegmentFirstLastPosition(szFormat, szFormatSegment[0], out nFirstSegIndex, out nLastSegIndex);

            if (nFirstSegIndex < 0)
                //Format segment doesn't exist in Format--we're done.
                return;

            if ((nLastSegIndex - nFirstSegIndex) + 1 == szFormatSegment.Length)
                //Format's segment is the right length--we're done.
                return;

            //Format has too many or too few chars in segment.  Cut out the old segment and replace it with szFormatSegment.
            szFormat = GBLMethods.LeftStr(szFormat, nFirstSegIndex) 
                + szFormatSegment 
                + GBLMethods.RightStr(szFormat, (szFormat.Length - nLastSegIndex) - 1);
        }
        private void GetSegmentFirstLastPosition(string szFormat, char cSegmentChar, out int nFirstSegmentIndex, out int nLastSegmentIndex)
        {
            nFirstSegmentIndex = szFormat.IndexOf(cSegmentChar);
            nLastSegmentIndex = szFormat.LastIndexOf(cSegmentChar, szFormat.Length - 1);
        }
        private void SetDateTimeEntryPattern()
        {
            if (!m_bValidDateFormat || !m_bValidTimeFormat)
            {
                m_szCombinedDisplayFormat = m_szCombinedEntryFormat = m_szDateTimeEntryPattern = txtDate.Text = "";
                ResizeControl(false);
                return;
            }
            if (string.IsNullOrEmpty(m_szDateEntryFormat) && string.IsNullOrEmpty(m_szTimeEntryFormat))
            {
                m_szCombinedDisplayFormat = m_szCombinedEntryFormat = m_szDateTimeEntryPattern = txtDate.Text = "";
                ResizeControl(false);
                return;
            }
            m_szCombinedEntryFormat = m_szDateEntryFormat + " " + m_szTimeEntryFormat;
            m_szCombinedEntryFormat = m_szCombinedEntryFormat.Trim();

            m_szCombinedDisplayFormat = m_szDateDisplayFormat + " " + m_szTimeDisplayFormat;
            m_szCombinedDisplayFormat = m_szCombinedDisplayFormat.Trim();

            string szNullDate = m_szCombinedEntryFormat;
            string szSegments = "MdyHhms";
            foreach (char cSegChar in szSegments)
                szNullDate = szNullDate.Replace(cSegChar, '0');

            szNullDate = szNullDate.Replace("tt", "AM");

            m_szDateTimeEntryPattern = szNullDate;
            if (DesignMode)
                if (txtDate.TextLength <= 0)
                    txtDate.Text = m_szDateTimeEntryPattern;

            bool bShowButton = !string.IsNullOrEmpty(m_szDateEntryFormat);
            ResizeControl(bShowButton);
        }
        private void ResizeControl(bool bShowButton)
        {
            btnCalendar.Visible = bShowButton;

            if (bShowButton)
            {
                txtDate.Width = (this.Width - btnCalendar.Width);
                btnCalendar.Left = txtDate.Width;
            }
            else
                txtDate.Width = this.Width;
        }
        protected override void OnEnter(EventArgs e)
        {
            if (string.IsNullOrEmpty(txtDate.Text))
                txtDate.Text = m_szDateTimeEntryPattern;
            else
                ReformatDateControl(m_szCombinedEntryFormat);

            base.OnEnter(e);
        }
        protected override void OnLeave(EventArgs e)
        {
            if (txtDate.Text == m_szDateTimeEntryPattern)
                txtDate.Text = "";
            else
                ReformatDateControl(m_szCombinedDisplayFormat);

            base.OnLeave(e);
        }
        private void ReformatDateControl(string szCombinedFormat)
        {
            if (this.ValidDate == IsDateValidResult.Valid)
                if (m_bValidDateFormat && m_bValidTimeFormat && txtDate.TextLength > 0 && txtDate.Text != m_szDateTimeEntryPattern)
                    txtDate.Text = GBLMethods.FormatDate(GBLMethods.CDate(txtDate.Text, szCombinedFormat), szCombinedFormat);
        }
        #endregion

        #region Drop Down Button
        void btnCalendar_Paint(object sender, PaintEventArgs e)
        {
            if (!ComboBoxRenderer.IsSupported)
                return;

            m_rectButton = btnCalendar.ClientRectangle;
            ComboBoxRenderer.DrawDropDownButton(e.Graphics, m_rectButton, m_eButtonState);
        }
        void btnCalendar_MouseMove(object sender, MouseEventArgs e)
        {
            m_eButtonState = System.Windows.Forms.VisualStyles.ComboBoxState.Normal;

            if (m_rectButton.Contains(e.Location))
                m_eButtonState = System.Windows.Forms.VisualStyles.ComboBoxState.Hot;

            if (!this.Enabled)
                m_eButtonState = System.Windows.Forms.VisualStyles.ComboBoxState.Disabled;

            btnCalendar.Invalidate();
        }
        void btnCalendar_MouseLeave(object sender, EventArgs e)
        {
            m_eButtonState = System.Windows.Forms.VisualStyles.ComboBoxState.Normal;

            if (!this.Enabled)
                m_eButtonState = System.Windows.Forms.VisualStyles.ComboBoxState.Disabled;

            btnCalendar.Invalidate();
        }
        protected override void OnEnabledChanged(EventArgs e)
        {
            base.OnEnabledChanged(e);
            if (this.Enabled)
                m_eButtonState = System.Windows.Forms.VisualStyles.ComboBoxState.Normal;
            else
                m_eButtonState = System.Windows.Forms.VisualStyles.ComboBoxState.Disabled;

            btnCalendar.Enabled = this.Enabled;
        }
        #endregion

        #region Calendar Control
        void m_wndCalendar_Closed(object sender, ToolStripDropDownClosedEventArgs e)
        {
            txtDate.Focus();
        }
        void txtDate_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.F4 && !e.Alt && !e.Control)
            {
                btnCalendar_Click(sender, new EventArgs());
                e.Handled = true;
                e.SuppressKeyPress = true;
            }
            if (e.KeyCode == Keys.Delete)
            {
                if (CheckAllSelectedResetControl())
                    OnValueChanged(new EventArgs());
                else
                    GBLMethods.MessageBeep(MessageBeepTypes.Default);

                e.Handled = true;
                e.SuppressKeyPress = true;
            }
        }
        void btnCalendar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(m_szDateTimeEntryPattern))
                return;

            m_wndCalendar.ResizeToFit();
            DateTime dteCurrent = DateTime.Today;
            dteCurrent = GBLMethods.CDate(txtDate.Text, m_szCombinedEntryFormat);
            if (dteCurrent.Year < 100)
                dteCurrent = DateTime.Today;
            m_ctlCalendar.SetDate(dteCurrent);
            m_ctlCalendar.MinDate = m_dteMinDate;
            m_ctlCalendar.MaxDate = m_dteMaxDate;

            m_wndCalendar.Show(this, 0, txtDate.Height);
            m_ctlCalendar.Focus();
        }
        void m_ctlCalendar_DateSelected(object sender, DateRangeEventArgs e)
        {
            m_wndCalendar.Hide();
            txtDate.Focus();
        }

        void m_ctlCalendar_DateChanged(object sender, DateRangeEventArgs e)
        {
            if (string.IsNullOrEmpty(m_szDateTimeEntryPattern))
                return;

            bool bChanged = true;
            if (txtDate.Text != m_szDateTimeEntryPattern)
            {
                DateTime dteCurrent = GBLMethods.CDate(txtDate.Text, m_szCombinedEntryFormat);
                bChanged = (e.Start != dteCurrent);
            }
            if (bChanged)
            {
                txtDate.Text = GBLMethods.FormatDate(e.Start, m_szCombinedEntryFormat);
                OnValueChanged(new EventArgs());
            }
        }
        #endregion

        #region Validation
        protected override void OnValidating(CancelEventArgs e)
        {
            base.OnValidating(e);

            if (txtDate.Text == m_szDateTimeEntryPattern)
                return;

            IsDateValidResult eResult = this.ValidDate;
            if (eResult != IsDateValidResult.Valid)
            {
                e.Cancel = true;
                ShowValFailMsg(eResult);
                txtDate.SelectAll();
            }
        }
        public void ShowValFailMsg(IsDateValidResult eResult)
        {
            string szErrorText = "";
            switch (eResult)
            {
                case IsDateValidResult.Invalid:
                    szErrorText = "You have entered an invalid date.  Please enter a valid date or hit Delete to reset the date to empty.";
                    break;
                case IsDateValidResult.GreaterThanMaxDate:
                    szErrorText = string.Format("You have entered a date that is greater than the maximum allowed date: {0}.  Please enter a valid date before {0}."
                        , m_dteMaxDate.ToShortDateString());
                    break;
                case IsDateValidResult.LessThanMinDate:
                    szErrorText = string.Format("You have entered a date that is less than the minimum allowed date: {0}.  Please enter a valid date after {0}."
                        , m_dteMinDate.ToShortDateString());
                    break;
            }
            MessageBox.Show(szErrorText, "Invalid Date", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
        }
        protected internal IsDateValidResult IsDateValid(string szDateText)
        {
            if (string.IsNullOrEmpty(szDateText))
                return IsDateValidResult.Valid;

            if (szDateText == m_szDateTimeEntryPattern)
                return IsDateValidResult.Valid;

            DateTime dteDate;
            try
            {
                dteDate = DateTime.ParseExact(szDateText, m_szCombinedDisplayFormat, null);
            }
            catch (Exception)
            {
                if (!DateTime.TryParse(szDateText, out dteDate))
                    return IsDateValidResult.Invalid;
            }
            //if (!DateTime.TryParse(szDateText, out dteDate))
            //    return IsDateValidResult.Invalid;

            if (dteDate < m_dteMinDate)
                return IsDateValidResult.LessThanMinDate;
            else if (dteDate > m_dteMaxDate)
                return IsDateValidResult.GreaterThanMaxDate;

            return IsDateValidResult.Valid;
        }
        #endregion

        #region Process User Keyed Char
        void txtDate_KeyPress(object sender, KeyPressEventArgs e)
        {
            e.Handled = true; //This class will process all keypress characters.
            if (!ProcessChar(e.KeyChar))
                GBLMethods.MessageBeep(MessageBeepTypes.Default);

            OnValueChanged(new EventArgs());

            OnKeyPress(e);
        }
        private bool ProcessChar(char cChar)
        {
            if (string.IsNullOrEmpty(m_szDateTimeEntryPattern))
                return false;

            switch (cChar)
            {
                case ' ':
                    if (CheckAllSelectedResetControl())
                        return true;
                    
                    if (txtDate.SelectionStart >= m_szCombinedEntryFormat.Length)
                        return false;

                    char cSegmentChar = m_szCombinedEntryFormat[txtDate.SelectionStart];
                    int nFirstSegIndex = -1;
                    int nLastSegIndex = -1;
                    GetSegmentFirstLastPosition(m_szCombinedEntryFormat, cSegmentChar, out nFirstSegIndex, out nLastSegIndex);
                    ReplaceDateCharAdvance(m_szDateTimeEntryPattern[txtDate.SelectionStart], nLastSegIndex);

                    return true;
                case '\b':
                    if (CheckAllSelectedResetControl())
                        return true;

                    if (txtDate.SelectionStart > 0)
                    {
                        if (GetActiveSegment(cChar, txtDate.SelectionStart - 1) == null)
                            //We're backspacing in the divider area.  Set selection to go back 1 now.
                            txtDate.SelectionStart--;

                        string szLeft = "";
                        if (txtDate.SelectionStart > 1)
                            szLeft = GBLMethods.LeftStr(txtDate.Text, txtDate.SelectionStart - 1);

                        char cNullChar = m_szDateTimeEntryPattern[txtDate.SelectionStart - 1];
                        string szNewText = szLeft
                            + cNullChar
                            + GBLMethods.RightStr(txtDate.Text, txtDate.TextLength - txtDate.SelectionStart);

                        int nSelStart = txtDate.SelectionStart;
                        txtDate.Text = szNewText;
                        txtDate.SelectionStart = nSelStart - 1;  //MS always resets SelectionStart when you change Text property.
                    }
                    return true;
            }
            DateSegment objDateSegment = GetActiveSegment(cChar);
            if (objDateSegment == null)
                return false;

            return objDateSegment.SegmentProcessChar();
        }
        internal bool CheckAllSelectedResetControl()
        {
            if (txtDate.SelectedText == txtDate.Text)
            {
                txtDate.Text = m_szDateTimeEntryPattern;
                txtDate.SelectionStart = txtDate.SelectionLength = 0;
                return true;
            }
            return false;
        }
        internal DateSegment GetActiveSegment(char cChar)
        {
            return GetActiveSegment(cChar, txtDate.SelectionStart);
        }
        internal DateSegment GetActiveSegment(char cChar, int nStart)
        {
            if (nStart >= m_szCombinedEntryFormat.Length)
                return null;

            char cSegmentChar = m_szCombinedEntryFormat[nStart];
            switch (cSegmentChar)
            {
                case 'M':
                    return GetDateSegment(enumDateSegments.Month, cChar, nStart);
                case 'd':
                    return GetDateSegment(enumDateSegments.Day, cChar, nStart);
                case 'y':
                    return GetDateSegment(enumDateSegments.Year, cChar, nStart);
                case 'h':
                case 'H':
                    return GetDateSegment(enumDateSegments.Hour, cChar, nStart);
                case 'm':
                    return GetDateSegment(enumDateSegments.Minute, cChar, nStart);
                case 's':
                    return GetDateSegment(enumDateSegments.Second, cChar, nStart);
                case 't':
                    return GetDateSegment(enumDateSegments.AMPM, cChar, nStart);
            }
            return null;
        }
        internal DateSegment GetDateSegment(enumDateSegments eSegmentType)
        {
            return GetDateSegment(eSegmentType, 'Z', txtDate.SelectionStart); //This will cause ValNumeric to return false, if the class's client runs SegmentProcessChar.
        }
        internal DateSegment GetDateSegment(enumDateSegments eSegmentType, char cChar, int nStart)
        {
            char cSegmentChar = m_szCombinedEntryFormat[nStart];
            int nFirstSegIndex = 0;
            int nLastSegIndex = 0;
            
            switch (eSegmentType)
            {
                case enumDateSegments.Month:
                    GetSegmentFirstLastPosition(m_szCombinedEntryFormat, 'M', out nFirstSegIndex, out nLastSegIndex);
                    return new DateSegmentMonth(this, cChar, nFirstSegIndex, nLastSegIndex, txtDate, cSegmentChar);
                case enumDateSegments.Day:
                    GetSegmentFirstLastPosition(m_szCombinedEntryFormat, 'd', out nFirstSegIndex, out nLastSegIndex);
                    return new DateSegmentDay(this, cChar, nFirstSegIndex, nLastSegIndex, txtDate, cSegmentChar);
                case enumDateSegments.Year:
                    GetSegmentFirstLastPosition(m_szCombinedEntryFormat, 'y', out nFirstSegIndex, out nLastSegIndex);
                    return new DateSegmentYear(this, cChar, nFirstSegIndex, nLastSegIndex, txtDate, cSegmentChar);
                case enumDateSegments.Hour:
                    GetSegmentFirstLastPosition(m_szCombinedEntryFormat, cSegmentChar, out nFirstSegIndex, out nLastSegIndex);
                    return new DateSegmentHour(this, cChar, nFirstSegIndex, nLastSegIndex, txtDate, cSegmentChar);
                case enumDateSegments.Minute:
                case enumDateSegments.Second:
                     GetSegmentFirstLastPosition(m_szCombinedEntryFormat, cSegmentChar, out nFirstSegIndex, out nLastSegIndex);
                    return new DateSegmentMinuteSecond(this, cChar, nFirstSegIndex, nLastSegIndex, txtDate, cSegmentChar);
                case enumDateSegments.AMPM:
                    GetSegmentFirstLastPosition(m_szCombinedEntryFormat, 't', out nFirstSegIndex, out nLastSegIndex);
                    return new DateSegmentAMPM(this, cChar, nFirstSegIndex, nLastSegIndex, txtDate, cSegmentChar);

            }
            return null;
        }
        internal void ReplaceDateCharAdvance(char cNewChar, int nSegmentEnd)
        {
            string szNewText = GBLMethods.LeftStr(txtDate.Text, txtDate.SelectionStart)
                + cNewChar
                + GBLMethods.RightStr(txtDate.Text, (txtDate.TextLength - txtDate.SelectionStart) - 1);

            int nSelStart = txtDate.SelectionStart;
            txtDate.Text = szNewText;

            txtDate.SelectionStart = nSelStart + 1;
            if (txtDate.SelectionStart > nSegmentEnd)
                if (txtDate.SelectionStart < txtDate.TextLength - 1)
                    txtDate.SelectionStart++;
        }
        #endregion

        #region Miscellaneous
        /// <summary>
        /// Selects all the text in the textbox.
        /// </summary>
        public void SelectAll()
        {
            txtDate.SelectAll();
        }
        #endregion
    }
}
