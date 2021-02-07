using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.Globalization;
using System.Drawing;
using System.Drawing.Design;
using System.Drawing.Drawing2D;
using System.ComponentModel;
using System.Threading;

namespace MonthCalendar
{
    [DesignerAttribute(typeof(CalendarDesigner))]
    [DefaultProperty("Name")]
	public class Calendar: Control		
    {
        private CultureInfo m_Culture;
        private DateTimeFormatInfo m_DateTimeFormatInfo;
        private DatesCollection m_Dates = null;
        private SelectedItemsCollection m_SelectedDates = null;
        private Day m_FirstDayOfWeek = Day.Default;        
        private HeaderElementStyle m_HeaderStyle = null;
        private WeekDayElementStyle m_WeekDaysStyle = null;
        private WeekNumbersElementStyle m_WeekNumbers = null;
        private MonthDaysElementStyle m_MonthDaysStyle = null;
        private FooterElementStyle m_Footer = null;
        private MonthImageData m_MonthImages = null;
        private KeyboardControl m_KeyboardControl = null;
        private WeekDayItem[,] m_WeekDayItems = new WeekDayItem[7, 6];
        private BorderStyle m_Border;
        private DateTime m_SelectedDate = DateTime.Now;        
        private DateTime m_MinDate = new DateTime(1753, 1, 1);
        private DateTime m_MaxDate = new DateTime(9998, 12, 31);
        private Graphics m_Graphics;
        private ViewMode m_ViewMode = ViewMode.vmMonth;
        private SelectionMode m_SelectionMode = SelectionMode.smOne;
        private SelectedDay m_MouseSelectedDay;
        private SelectedDay m_MouseSelectedDayBackup;
        private SelectedDay m_StartMultiSelectionHover;
        private Button m_PreviousButton = null;
        private Button m_NextButton = null;
        private Button m_PreviousYearButton = null;
        private Button m_NextYearButton = null;
        private ImageList m_Images = null;
        private GlobalHook m_GloabalKeyBoardHook = new GlobalHook();
        private bool m_WeekDayArrayAlreadyCreated = false;        
        private bool m_MouseInTitleText = false;
        private bool m_MouseInWeekDay = false;
        private bool m_bMouseHover = false;
        private bool m_bKeyHandled = false;
        private bool m_bMOuseHoverHeader = false;
        private bool m_bOnlyMonthMode = false;
        private bool m_bMultipleSelectingModeActive = false;
        private bool m_bCanSelectTrailingDates = true;
        private bool m_bInitialised = false;
        private int m_Start12YearsRange = 2001;
        private int m_End12YearsRange = 2012;
        private int m_Start120YearsRange = 1990;
        private int m_End120YearsRange = 2100;
        private int m_NextTopPos = 0;
        private int m_TitlebarHeight = 0;
        private int m_WeekDayWidth = 0;
        private int m_WeekDayHeight = 0;
        private int m_MonthWidth = 0;
        private int m_MonthHeight = 0;
        private int m_SundayIndex = 0;
        private int m_FirstWeekNumber = 0;
        private int m_TitleTextLeftStartPos = 0;
        private int m_TitleTextWidth = 0;
        private int m_TitleTextTopStartPos = 0;
        private int m_TitleTextHeight = 0;
        private int m_WeekDaysTopStartPos = 0;
        private int m_WeekDaysLeftStartPos = 0;
        private int m_SelectedMonthIndex = 0;
        private int m_MonthDayWidthOffset = 0;
        private int m_MonthDayHeightOffset = 0;
        private int m_DrawedMonthDayTopStartPos = 0;
        private int m_DrawedMonthDayHeight = 0;
        
		public Calendar() {
			//initialize control
            this.ResizeRedraw = true;
            this.SetStyle(System.Windows.Forms.ControlStyles.DoubleBuffer, true);
            this.SetStyle(System.Windows.Forms.ControlStyles.SupportsTransparentBackColor, true);
            this.SetStyle(ControlStyles.UserPaint, true);
            this.SetStyle(System.Windows.Forms.ControlStyles.AllPaintingInWmPaint, true);
            this.SetStyle(ControlStyles.SupportsTransparentBackColor, true);
            this.SetStyle(ControlStyles.Selectable, true);
            this.UpdateStyles();

            m_Culture = CultureInfo.CurrentCulture;
            m_DateTimeFormatInfo = DateTimeFormatInfo.CurrentInfo;

            m_Dates = new DatesCollection(this);
            m_SelectedDates = new SelectedItemsCollection(this);
            //titlebar style element
            m_HeaderStyle = new HeaderElementStyle(this);
            m_HeaderStyle.Font = new Font(this.Font.Name, this.Font.Size);
            m_HeaderStyle.ForeColor = Color.FromArgb(255, 155, 155, 155);
            m_HeaderStyle.Border.Visible = false;
            m_HeaderStyle.Border.BorderColor = Color.Black;
            m_HeaderStyle.Border.Transparency = 255;
            m_HeaderStyle.Background.StartColor = Color.White;
            m_HeaderStyle.Background.EndColor = Color.Black;
            m_HeaderStyle.Background.Style = EStyle.esParent;
            m_HeaderStyle.Background.Gradient = GradientStyle.Vertical;
            m_HeaderStyle.Background.TransparencyStartColor = 255;
            m_HeaderStyle.Background.TransparencyEndColor = 255;
            //header style element
            m_WeekDaysStyle = new WeekDayElementStyle(this);
            m_WeekDaysStyle.Font = new Font(this.Font.Name, this.Font.Size);
            m_WeekDaysStyle.ForeColor = Color.FromArgb(255, 155, 155, 155);
            m_WeekDaysStyle.Border.Visible = true;
            m_WeekDaysStyle.Border.BorderColor = Color.Black;
            m_WeekDaysStyle.Border.Transparency = 255;
            m_WeekDaysStyle.Background.StartColor = Color.White;
            m_WeekDaysStyle.Background.EndColor = Color.Black;
            m_WeekDaysStyle.Background.TransparencyStartColor = 255;
            m_WeekDaysStyle.Background.TransparencyEndColor = 255;
            m_WeekDaysStyle.Background.Style = EStyle.esParent;
            m_WeekDaysStyle.Background.Gradient = GradientStyle.Vertical;
            //weeknumbers style element
            m_WeekNumbers = new WeekNumbersElementStyle(this);
            m_WeekNumbers.Font = new Font(this.Font.Name, this.Font.Size);
            m_WeekNumbers.ForeColor = Color.FromArgb(255, 155, 155, 155);
            m_WeekNumbers.Border.Visible = true;
            m_WeekNumbers.Border.BorderColor = Color.Black;
            m_WeekNumbers.Border.Transparency = 255;
            m_WeekNumbers.Background.StartColor = Color.White;
            m_WeekNumbers.Background.EndColor = Color.Black;
            m_WeekNumbers.Background.TransparencyStartColor = 255;
            m_WeekNumbers.Background.TransparencyEndColor = 255;
            m_WeekNumbers.Background.Style = EStyle.esParent;
            m_WeekNumbers.Background.Gradient = GradientStyle.Vertical;
            //weekday style
            m_MonthDaysStyle = new MonthDaysElementStyle(this);
            m_MonthDaysStyle.Font = new Font(this.Font.Name, this.Font.Size);
            m_MonthDaysStyle.ForeColor = Color.Black;
            m_MonthDaysStyle.Border.Visible = false;
            m_MonthDaysStyle.Border.BorderColor = Color.Black;
            m_MonthDaysStyle.Border.Transparency = 255;
            m_MonthDaysStyle.Background.StartColor = Color.White;
            m_MonthDaysStyle.Background.EndColor = Color.Black;
            m_MonthDaysStyle.Background.TransparencyStartColor = 255;
            m_MonthDaysStyle.Background.TransparencyEndColor = 255;
            m_MonthDaysStyle.Background.Style = EStyle.esParent;
            m_MonthDaysStyle.Background.Gradient = GradientStyle.Vertical;
            //
            m_Footer = new FooterElementStyle(this);
            //
            m_Border = new BorderStyle(this);
            m_Border.Visible = false;
            m_Border.BorderColor = Color.Black;
            m_Border.Transparency = 255;
            //
            m_KeyboardControl = new KeyboardControl(this);
            //
            m_MonthImages = new MonthImageData(this);            

            m_PreviousButton = new Button();
            m_PreviousButton.Image = Properties.Resources.previous;
            m_PreviousButton.Visible = false;
            m_PreviousButton.Click += new EventHandler(PrevClick);

            m_NextButton = new Button();
            m_NextButton.Image = Properties.Resources.next;
            m_NextButton.Visible = false;
            m_NextButton.Click += new EventHandler(NextClick);

            m_PreviousYearButton = new Button();
            m_PreviousYearButton.Image = Properties.Resources.PrevYear;
            m_PreviousYearButton.Visible = false;
            m_PreviousYearButton.Click += new EventHandler(PrevYearClick);

            m_NextYearButton = new Button();
            m_NextYearButton.Image = Properties.Resources.nextYear;
            m_NextYearButton.Visible = false;
            m_NextYearButton.Click += new EventHandler(NextYearClick);

            this.SetBounds(0, 0, 200, 175);

            this.Controls.Add(m_PreviousButton);
            this.Controls.Add(m_NextButton);
            this.Controls.Add(m_PreviousYearButton);
            this.Controls.Add(m_NextYearButton);
            //install keyboard hook
            m_GloabalKeyBoardHook.InstallKeyBoardHook();
            m_GloabalKeyBoardHook.OnKeyDown += new KeyEventHandler(Hook_KeyDown);
            m_GloabalKeyBoardHook.OnKeyUp += new KeyEventHandler(Hook_KeyUp);
        }

        protected override void Dispose(bool disposing)
        {
            //remove global keyboard hook
            m_GloabalKeyBoardHook.RemoveHook();

          
            base.Dispose(disposing);
        }

        #region properties

        [Browsable(false)]
        public SelectedItemsCollection Selected
        {
            get
            {
                return m_SelectedDates;
            }
        }

        [Description("set calendars startzoom"), Category("Behavior")]
        public ViewMode StartWithZoom
        {
            get
            {
                return m_ViewMode;
            }
            set
            {
                m_ViewMode = value;
                Invalidate();
            }
        }

        [Description("set true to select days from other month"), Category("Behavior")]
        public bool CanSelectTrailingDates
        {
            get
            {
                return m_bCanSelectTrailingDates;
            }
            set
            {
                m_bCanSelectTrailingDates = value;
                if (CanSelectTrailingDatesChanged != null) CanSelectTrailingDatesChanged(this, EventArgs.Empty);
            }
        }

        [Description("set mode to select days"), Category("Behavior")]
        public SelectionMode SelectionMode
        {
            get
            {
                return m_SelectionMode;
            }
            set
            {
            	if (value == SelectionMode.smMulti)
            		AddSelectedItem(m_SelectedDate);
                m_SelectionMode = value;
                if (SelectionModeChanged != null) SelectionModeChanged(this, EventArgs.Empty);
            }
        }

        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        [Description("Set footer style"), Category("Appearance")]
        public FooterElementStyle Footer
        {
            get
            {
                return m_Footer;
            }
        }

        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        [Description("set calendars borderstyle"), Category("Appearance")]
        public BorderStyle Border
        {
            get
            {
                return m_Border;
            }
        }

        [Category("Behavior")]
        [Description("if true user cannot zoomout calendar to a other range")]
        public bool OnlyMonthMode
        {
            get
            {
                return m_bOnlyMonthMode;
            }
            set
            {
                m_bOnlyMonthMode = value;
                //set viewmode to month mode
                if (value == true)
                {
                    if (m_ViewMode != ViewMode.vmMonth)
                    {
                        SetViewMode(ViewMode.vmMonth, m_ViewMode);
                    }
                }
                if (OnlyMonthModeChanged != null) OnlyMonthModeChanged(this, EventArgs.Empty);
            }
        }

        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        [Category("Behavior"), Description("setup calendar keyboard steering")]
        public KeyboardControl Keyboard
        {
            get
            {
                return m_KeyboardControl;
            }
        }

        [Description("set imagelist used with formated days"), Category("Behavior")]
        public ImageList ImageList
        {
            get
            {
                return m_Images;
            }
            set
            {
                m_Images = value;
            }
        }

        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        [Editor(typeof(DateItemCollectionEditor), typeof(UITypeEditor))]
        [Category("Appearance")]
        public DatesCollection Dates
        {
            get
            {
                return m_Dates;
            }
        }

        [Description("Set style for titlebar with Monthname and year"), Category("Appearance")]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        public HeaderElementStyle Header
        {
            get
            {
                return m_HeaderStyle;
            }            
        }

        [Description("set the short weekdaynames style"), Category("Appearance")]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        public WeekDayElementStyle WeekDays
        {
            get
            {
                return m_WeekDaysStyle;
            }            
        }

        [Description("set the style for weeknumbers on left side"), Category("Appearance")]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        public WeekNumbersElementStyle Weeknumbers
        {
            get
            {
                return m_WeekNumbers;
            }
            set
            {
                m_WeekNumbers = value;
            }
        }

        [Description("set the first of week set default to use the thread defaults"), Category("Behavior")]
        public Day FirstDayOfWeek
        {
            get
            {
                return m_FirstDayOfWeek;
            }
            set
            {
                m_FirstDayOfWeek = value;
                CreateWeekDaysArray();
                if (FirstDayOfWeekChanged != null) FirstDayOfWeekChanged(this, EventArgs.Empty);
                //set the first weekday
                this.Invalidate();
            }
        }

        [Description("set the style of each day in current month"), Category("Appearance")]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        public MonthDaysElementStyle MonthDays
        {
            get
            {
                return m_MonthDaysStyle;
            }            
        }        

        [Category("Appearance")]
        [DesignerSerializationVisibility(DesignerSerializationVisibility.Content)]
        public MonthImageData MonthImages
        {
            get
            {
                return m_MonthImages;
            }
            
        }

        [Description("get from user selected date"), Category("Behavior")]
        public DateTime SelectedDate
        {
            get
            {
                return m_SelectedDate;
            }
            set
            {
                CanSelectDayEventArgs myCanSelectDay = new CanSelectDayEventArgs(value);
                if (CanSelectDay != null) CanSelectDay(this, myCanSelectDay);
                if (myCanSelectDay.Cancel == false)
                {
                    m_SelectedDate = new DateTime(value.Year, value.Month, value.Day);
                    CreateWeekDaysArray();
                    if (SelectDay != null) SelectDay(this, new SelectDayEventArgs(value)); 
                    //set selected date
                    this.Invalidate();
                }
            }
        }

        [Description("set the min userselectable date"), Category("Behavior")]
        public DateTime MinDate
        {
            get
            {
                return m_MinDate;
            }
            set
            {
                m_MinDate = value;
                if (MinDateChanged != null) MinDateChanged(this, EventArgs.Empty);
                //set mindate
                this.Invalidate();
            }
        }

        [Description("set the max userselectable date"), Category("Behavior")]
        public DateTime MaxDate
        {
            get
            {
                return m_MaxDate;
            }
            set
            {
                m_MaxDate = value;
                if (MaxDateChanged != null) MaxDateChanged(this, EventArgs.Empty);
                //set maxdate
                this.Invalidate();
            }
        }

        [Description("Set the used language settings"), Category("Behavior")]
        public CultureInfo Culture
        {
            get
            {
                return m_Culture;
            }
            set
            {
                m_Culture = value;
                //refresh calendar with new regional settings
                Thread.CurrentThread.CurrentCulture = value;
                m_DateTimeFormatInfo = DateTimeFormatInfo.CurrentInfo;
                CreateWeekDaysArray();
                if (CultureChanged != null) CultureChanged(this, EventArgs.Empty);
                this.Invalidate();
            }
        }
        #endregion

        #region events

        [Category("Calendar")]
        public event ChangeYearEventHandler YearChanged;

        [Category("Calendar")]
        public event CanChangeYearEventHandler CanChangeYear;

        [Category("Calendar")]
        public event ChangeMonthEventHandler MonthChanged;

        [Category("Calendar")]
        public event CanChangeMonthEventHandler CanChangeMonth;

        [Category("Calendar")]
        public event EventHandler NavPreviousMonthClick;

        [Category("Calendar")]
        public event EventHandler NavPreviousYearClick;

        [Category("Calendar")]
        public event EventHandler NavNextYearClick;

        [Category("Calendar")]
        public event EventHandler NavNextMonthClick;

        [Category("Calendar")]
        public event CanSelectDayEventHandler CanSelectDay;

        [Category("Calendar")]
        public event SelectDayEventHandler SelectDay;

        [Category("Calendar")]
        public event CanZoomEventHandler CanZoomOut;

        [Category("Calendar")]
        public event ZoomEventHandler ZoomOut;

        [Category("Calendar")]
        public event CanZoomEventHandler CanZoomIn;

        [Category("Calendar")]
        public event ZoomEventHandler ZoomIn;

        [Category("Calendar")]
        public event MonthImageRenderEventHandler MonthImageRender;

        [Category("Calendar")]
        public event HeaderRenderEventHandler HeaderRender;

        [Category("Calendar")]
        public event WeekDayBackgroundEventHandler WeekDayBackgroundRender;

        [Category("Calendar")]
        public event WeekDayRenderEventHandler WeekDayRender;

        [Category("Calendar"), Description("notify the weeknumbers background is drawing")]
        public event WeekNumbersBackgroundEventHandler WeekNumbersBackgroundRender;

        [Category("Calendar"), Description("will be raised if a weeknumber is drawing")]
        public event WeekNumberRenderEventHandler WeekNumberRender;

        [Category("Calendar"), Description("notify a monthday is drawing")]
        public event MonthDayRenderEventHandler MonthDayRender;

        [Category("Calendar"), Description("notify a month in viewmode 'vmYear' is drawing")]
        public event MonthRenderEventHandler MonthRender;

        [Category("Calendar"), Description("notify a year in viewmode 'vm12Years' is drawing")]
        public event YearRenderEventHandler YearRender;

        [Category("Calendar"), Description("notify that a 12 years - group in viewmode 'vm120Years' is drawing")]
        public event YearGroupRenderEventHandler YearsGroupRender;

        [Category("Calendar"), Description("notify the calendarfooter is drawing")]
        public event FooterRenverEventHandler FooterRender;

        [Category("Action")]
        public event EventHandler HeaderClick;

        [Category("Action")]
        public event EventHandler EnableMultiSelectionMode;

        [Category("Action")]
        public event EventHandler DisableMultiSelectionMode;

        [Category("Action")]
        public event EventHandler SelectionStart;

        /*[Category("Action")]
        public event EventHandler SelectionChange;*/

        [Category("Action")]
        public event EventHandler SelectionEnd;

        [Category("PropertyChanged")]
        public event EventHandler FirstDayOfWeekChanged;

        [Category("PropertyChanged")]
        public event EventHandler MinDateChanged;

        [Category("PropertyChanged")]
        public event EventHandler MaxDateChanged;

        [Category("PropertyChanged")]
        public event EventHandler CultureChanged;

        [Category("PropertyChanged")]
        public event EventHandler OnlyMonthModeChanged;

        [Category("PropertyChanged")]
        public event EventHandler SelectionModeChanged;

        [Category("PropertyChanged")]
        public event EventHandler CanSelectTrailingDatesChanged;

        [Category("PropertyChanged")]
        public event EventHandler HeaderChanged;

        [Category("PropertyChanged")]
        public event EventHandler FooterChanged;

        [Category("PropertyChanged")]
        public event EventHandler WeekDaysChanged;

        [Category("PropertyChanged")]
        public event EventHandler WeekNumbersChanged;

        [Category("PropertyChanged")]
        public event EventHandler MonthDaysChanged;
        
        [Category("PropertyChanged")]
        public event EventHandler KeyboardChanged;

        [Category("PropertyChanged")]
        public event EventHandler MonthImagesChanged;

        [Category("PropertyChanged")]
        public event EventHandler BorderChanged;


        #endregion

        #region Helperfunctions
        /// <summary>
        /// retrives the titlebarheight
        /// </summary>
        /// <returns>titlebarheight</returns>
        private int GetTitleBarHeight()
        {
            if (m_HeaderStyle.Visible == true)
            {
                return m_HeaderStyle.Font.Height + 2 * m_HeaderStyle.Padding.Vertical;
            }
            else return 0;
        }

        /// <summary>
        /// retrives the header height
        /// </summary>
        /// <returns>headerheight</returns>
        private int GetWeekDaysHeight()
        {
            if (m_WeekDaysStyle.Visible == true)
            {
                return m_WeekDaysStyle.Font.Height + 1;
            }
            else return 0;
        }

        /// <summary>
        /// Retrives the width used for weeknumbers
        /// </summary>
        /// <returns>weeknumbers width</returns>
        private int GetWeekNumbersWidth()
        {
            if (m_Graphics == null)
            {
                m_Graphics = this.CreateGraphics();
            }
            if (m_WeekNumbers.Visible == true)
            {
                SizeF myStringDimension = m_Graphics.MeasureString("53", m_WeekNumbers.Font);
                return (int)myStringDimension.Width + m_WeekNumbers.Padding;
            }
            else return 1; //draw no weeknumbers
        }

        /// <summary>
        /// Get the height of the today string in controlfooter
        /// </summary>
        /// <returns>the height of the todaystring</returns>
        private int GetTodayHeight()
        {
            if (m_Footer.Visible == true)
            {
                return m_Footer.Padding.Top + m_Footer.Font.Height + m_Footer.Padding.Bottom;                
            }
            else return 0;
        }

        /// <summary>
        /// get the needed header monthimage height
        /// </summary>
        /// <returns>Höhe des Bildes</returns>
        private int GetMonthImageHeight()
        {
            if (m_MonthImages.UseImages == true && m_MonthImages.ImagePosition == MonthImagePosition.Top)
                return m_MonthImages.ImagesHeight;
            else return 0;
        }

        /// <summary>
        /// Returns the height of each monthday
        /// </summary>
        /// <returns>weekdayheight</returns>
        private int GetMonthDayHeight()
        {
            int iVerticalPadding = 7 * m_MonthDaysStyle.DaysPadding.Vertical;
            int iUseableHeight = this.Height - iVerticalPadding - (GetMonthImageHeight() + GetTitleBarHeight() +
                                 GetWeekDaysHeight()) - GetTodayHeight();
            int iValue = (int)iUseableHeight / 6;
            m_MonthDayHeightOffset = iUseableHeight - (iValue * 6);
            if (m_MonthDayHeightOffset < 0) m_MonthDayHeightOffset = 0;
            
            if (iValue < m_MonthDaysStyle.Font.Height)
            {
                iValue = m_MonthDaysStyle.Font.Height;
            }
            
            return iValue; 
        }        

        /// <summary>
        /// returns the monthday width
        /// </summary>
        /// <returns>monthdaywidth</returns>
        private int GetMonthDayWidth()
        {
            int iHorizontalPadding = 8 * m_MonthDaysStyle.DaysPadding.Horizontal;
            int iUseableWidth = this.Width - iHorizontalPadding - GetWeekNumbersWidth();
            int iMonthDayWidth = (int)iUseableWidth / 7;
            m_MonthDayWidthOffset = iUseableWidth - (iMonthDayWidth * 7);
            //m_MonthDayWidthOffset--;
            if (m_MonthDayWidthOffset < 0) m_MonthDayWidthOffset = 0;
            return iMonthDayWidth; 
        }

        /// <summary>
        /// get the needed width for the all month days in a row
        /// </summary>
        /// <returns></returns>
        private int GetNeededMonthDaysWidth()
        {
            if (m_Graphics == null)
            {
                m_Graphics = this.CreateGraphics();
            }
            int iMonthDayWidth = GetMonthDayWidth();
            SizeF myStringDimension = m_Graphics.MeasureString("30", m_MonthDaysStyle.Font);
            if (iMonthDayWidth < (int)myStringDimension.Width + 6)
            {
                iMonthDayWidth = (int)myStringDimension.Width + 6;
            }

            return (7 * iMonthDayWidth) + m_MonthDayWidthOffset + 
                   (8 * m_MonthDaysStyle.DaysPadding.Horizontal);
        }

        private int GetMonthDaysHeight()
        {
            return (6 * GetMonthDayHeight()) + 
                                 (7 * m_MonthDaysStyle.DaysPadding.Vertical) +
                                 m_MonthDayHeightOffset;
        }

        /// <summary>
        /// Get the First weekday from settings: the user definied first weekday or the systemdefault weekday
        /// </summary>
        /// <returns></returns>
        private DayOfWeek GetFirstWeekDay()
        {            
            //left startpos is m_WeeknumbersWidth
            if (m_FirstDayOfWeek == Day.Default)
            {
                return m_DateTimeFormatInfo.FirstDayOfWeek;
            }
            else
            {
                switch (m_FirstDayOfWeek)
                {
                    case Day.Monday:
                        return DayOfWeek.Monday;
                        break;
                    case Day.Tuesday:
                        return DayOfWeek.Tuesday;
                        break;
                    case Day.Wednesday:
                        return DayOfWeek.Wednesday;
                        break;
                    case Day.Thursday:
                        return DayOfWeek.Thursday;
                        break;
                    case Day.Friday:
                        return DayOfWeek.Friday;
                    case Day.Saturday:
                        return DayOfWeek.Saturday;
                        break;
                    case Day.Sunday:
                        return DayOfWeek.Sunday;
                        break;
                    default:
                        return DayOfWeek.Monday;
                        break;
                }                
            }            
        }

        /// <summary>
        /// returns the first weeknumber for selected month
        /// </summary>
        /// <returns>the first weeknumber for this month</returns>
        private int GetFirstWeekNumber(int Index)
        {            
             DayOfWeek myFirstWeekDay = GetFirstWeekDay();
             return m_DateTimeFormatInfo.Calendar.GetWeekOfYear(new DateTime(m_SelectedDate.Year, 
                                                                m_SelectedDate.Month, 1 + (Index * 7)), 
                                                                CalendarWeekRule.FirstDay, myFirstWeekDay);
        }

        /// <summary>
        /// get the previous of the current month
        /// </summary>
        /// <param name="Current">date from get the previous month</param>
        /// <returns>previous month date</returns>
        private DateTime GetPrevMonth(DateTime Current)
        {
            DateTime myNewDate = Current;
            if ((Current.Month == 1) && (Current.Year > 1753))
            {
                //change date to december of previous year
                myNewDate = new DateTime(Current.Year - 1, 12, 1);
            }
            else if ((Current.Month > 1) && (Current.Year >= 1753))
            {
                //change date to previous month in the same year
                myNewDate = new DateTime(Current.Year, Current.Month - 1, 1);
            }
            else
            {
                myNewDate = new DateTime(1752, 12, 1);
            }

            return myNewDate;
        }

        /// <summary>
        /// get the next of the current month
        /// </summary>
        /// <param name="Current">date from get the next month</param>
        /// <returns>next month data</returns>
        private DateTime GetNextMonth(DateTime Current)
        {
            DateTime myNewDate = Current;
            if ((Current.Month == 12) && (Current.Year < 9998))
            {
                myNewDate = new DateTime(Current.Year + 1, 1, 1);
            }
            else if ((Current.Month < 12) && (Current.Year <= 9998))
            {
                myNewDate = new DateTime(Current.Year, Current.Month + 1, 1);
            }
            else
            {
                myNewDate = new DateTime(9999, 1, 1);
            }
            return myNewDate;
        }

        /// <summary>
        /// get the previous year from current date
        /// </summary>
        /// <param name="Current">current date</param>
        /// <returns>the previous year</returns>
        private DateTime GetPrevYear(DateTime Current)
        {
            if (Current.Year > 1753)
                return new DateTime(Current.Year - 1, Current.Month, Current.Day);
            else
                return Current;
        }

        private DateTime GetNextYear(DateTime Current)
        {
            if (Current.Year < 9998)
                return new DateTime(Current.Year + 1, Current.Month, Current.Day);
            else
                return Current;
        }

        /// <summary>
        /// Get the array index for the first wwekday in selected month
        /// </summary>
        /// <param name="FirstWeekDay">the first weekday</param>
        /// <param name="DaysWeekDay">weekday from the first day in month</param>
        /// <returns>return the arrayindex for the first monthday</returns>
        private int GetFirstIndex(DayOfWeek FirstWeekDay, DayOfWeek DaysWeekDay)
        {
            int iArrayIndex = 0;
            bool bResultFound = false;
            for (int iWeekDayCounter = (int)FirstWeekDay; iWeekDayCounter <= 6; iWeekDayCounter++)
            {
                if (((DayOfWeek)iWeekDayCounter) == DaysWeekDay)
                {
                    bResultFound = true;
                    break;
                }
                iArrayIndex++;
            }
            if (bResultFound == false)
            {
                for (int iWeekDayCounter = 0; iWeekDayCounter < (int)FirstWeekDay; iWeekDayCounter++)
                {
                    if (((DayOfWeek)iWeekDayCounter) == DaysWeekDay)
                    {

                        break;
                    }
                    iArrayIndex++;
                }
            }
            return iArrayIndex;
        }


        /// <summary>
        /// Create the weekdays - arraylist to draw weekdays
        /// </summary>
        private void CreateWeekDaysArray()
        {
            //first get weekday from first day in month
            DateTime myFirstDate = new DateTime(m_SelectedDate.Year, m_SelectedDate.Month, 1);
            DayOfWeek myFirstWeekDay = myFirstDate.DayOfWeek;
            DayOfWeek myDefaultFirstWeekDay =  GetFirstWeekDay();
            int iWeekDayArrayPos = GetFirstIndex(myDefaultFirstWeekDay, myFirstWeekDay);
            DateTime myPrevTrailingDate = GetPrevMonth(myFirstDate);
            //get prevmonth days
            int iPrevTrailingMonthDays = DateTime.DaysInMonth(myPrevTrailingDate.Year, myPrevTrailingDate.Month);
            for (int iTrailingDayCounter = iWeekDayArrayPos - 1; iTrailingDayCounter >= 0; iTrailingDayCounter--)
            {
                m_WeekDayItems[iTrailingDayCounter, 0].TrailingDay = true;
                m_WeekDayItems[iTrailingDayCounter, 0].Day = iPrevTrailingMonthDays;
                m_WeekDayItems[iTrailingDayCounter, 0].Month = myPrevTrailingDate.Month;
                m_WeekDayItems[iTrailingDayCounter, 0].Year = myPrevTrailingDate.Year;
                //previous day
                iPrevTrailingMonthDays--;
            }

            int iCurrentMonthDays = DateTime.DaysInMonth(m_SelectedDate.Year, m_SelectedDate.Month);
            int iRowCounter = 0;
            int iFirstWeekDay = (int)(new DateTime(m_SelectedDate.Year, m_SelectedDate.Month, 1)).DayOfWeek;
            //write each monthday to array
            for (int iMonthDayCounter = 1; iMonthDayCounter <= iCurrentMonthDays; iMonthDayCounter++)
            {
                m_WeekDayItems[iWeekDayArrayPos, iRowCounter].TrailingDay = false;
                m_WeekDayItems[iWeekDayArrayPos, iRowCounter].Day = iMonthDayCounter;
                m_WeekDayItems[iWeekDayArrayPos, iRowCounter].Month = m_SelectedDate.Month;
                m_WeekDayItems[iWeekDayArrayPos, iRowCounter].Year = m_SelectedDate.Year;
                m_WeekDayItems[iWeekDayArrayPos, iRowCounter].WeekDay = (DayOfWeek)iFirstWeekDay;

                //get next weekday
                if (iFirstWeekDay == 6)
                    iFirstWeekDay = 0;
                else
                    iFirstWeekDay++;


                if (iWeekDayArrayPos == 6)
                {
                    iWeekDayArrayPos = 0;
                    iRowCounter++;
                }
                else
                {
                    iWeekDayArrayPos++;
                }
            }

            //get next trailing month
            DateTime myNextTrailingMonth = GetNextMonth(myFirstDate);
            int iNextTrailingMonthDays = DateTime.DaysInMonth(myNextTrailingMonth.Year, myNextTrailingMonth.Month);
            for (int iNextTrailingMonth = 1; iNextTrailingMonth <= iNextTrailingMonthDays; iNextTrailingMonth++)
            {
                m_WeekDayItems[iWeekDayArrayPos, iRowCounter].TrailingDay = true;
                m_WeekDayItems[iWeekDayArrayPos, iRowCounter].Day = iNextTrailingMonth;
                m_WeekDayItems[iWeekDayArrayPos, iRowCounter].Month = myNextTrailingMonth.Month;
                m_WeekDayItems[iWeekDayArrayPos, iRowCounter].Year = myNextTrailingMonth.Year;

                if (iWeekDayArrayPos == 6)
                {
                    iWeekDayArrayPos = 0;
                    //question if max rows 
                    if (iRowCounter < 5)
                    {
                        iRowCounter++;
                    }
                    else
                    {
                        //array writing complete exist for loop
                        break;
                    }
                }
                else
                {
                    iWeekDayArrayPos++;
                }
            }
            //m_WeekDayItems
        }

        /// <summary>
        /// check if the user selected date can be selected
        /// </summary>
        /// <param name="Date">user selected date</param>
        /// <returns>true if this date can be selected otherwise false</returns>
        private bool CanSelectDate(DateTime Date)
        {                      
            if (Date >= m_MinDate && Date <= m_MaxDate)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// add an datetime to the selecteditems collection
        /// </summary>
        /// <param name="myNewDate"></param>
        private void AddSelectedItem(DateTime myNewDate)
        {
            //if no multiple selectionmode is active clear selecteddates collection
            //befor add a new date
            if (m_bMultipleSelectingModeActive == false)
                m_SelectedDates.Clear();

            //select one item
            int iSelectedIndex = m_SelectedDates.IndexOf(myNewDate);
            if (iSelectedIndex == -1)
            {
                //add date
                m_SelectedDates.Add(myNewDate);
            }
            else
            {
                m_SelectedDates.RemoveAt(iSelectedIndex);
                this.Invalidate();
            }
        }

        /// <summary>
        /// returns the image for current month
        /// </summary>
        /// <returns>image</returns>
        private Image GetPaintMonthImage()
        {
            Image myMonthImage = m_MonthImages.JanuaryImage;
            switch (m_SelectedDate.Month)
            {
                case 1:
                    myMonthImage = m_MonthImages.JanuaryImage;
                    break;
                case 2:
                    myMonthImage = m_MonthImages.FebruaryImage;
                    break;
                case 3:
                    myMonthImage = m_MonthImages.MarchImage;
                    break;
                case 4:
                    myMonthImage = m_MonthImages.AprilImage;
                    break;
                case 5:
                    myMonthImage = m_MonthImages.MayImage;
                    break;
                case 6:
                    myMonthImage = m_MonthImages.JuneImage;
                    break;
                case 7:
                    myMonthImage = m_MonthImages.JulyImage;
                    break;
                case 8:
                    myMonthImage = m_MonthImages.AugustImage;
                    break;
                case 9:
                    myMonthImage = m_MonthImages.SeptemberImage;
                    break;
                case 10:
                    myMonthImage = m_MonthImages.OctoberImage;
                    break;
                case 11:
                    myMonthImage = m_MonthImages.NovemberImage;
                    break;
                case 12:
                    myMonthImage = m_MonthImages.DecemberImage;
                    break;
            }
            return myMonthImage;
        }

        private static Rectangle GetImageRect(DateItem Item, Image Img, int Width, int Height)
        {
            int iImgWidth = Img.Width;
            int iImgHeight = Img.Height;
            int iLeftPos = 0;
            int iTopPos = 0;
            switch (Item.ImageAlign)
            {
                case ContentAlignment.TopLeft:
                    iLeftPos = 0;
                    iTopPos = 0;
                    break;
                case ContentAlignment.TopCenter:
                    iTopPos = 0;
                    iLeftPos = (int)(Width - iImgWidth) / 2;
                    if (iLeftPos < 0) iLeftPos = 0;
                    break;
                case ContentAlignment.TopRight:
                    iTopPos = 0;
                    iLeftPos = Width - iImgWidth;
                    if (iLeftPos < 0) iLeftPos = 0;
                    break;
                case ContentAlignment.MiddleLeft:
                    iLeftPos = 0;
                    iTopPos = (int)(Height - iImgHeight) / 2;
                    if (iTopPos < 0) iTopPos = 0;
                    break;
                case ContentAlignment.MiddleCenter:
                    iTopPos = (int)(Height - iImgHeight) / 2;
                    if (iTopPos < 0) iTopPos = 0;
                    iLeftPos = (int)(Width - iImgWidth) / 2;
                    if (iLeftPos < 0) iLeftPos = 0;
                    break;
                case ContentAlignment.MiddleRight:
                    iTopPos = (int)(Height - iImgHeight) / 2;
                    if (iTopPos < 0) iTopPos = 0;
                    iLeftPos = Width - iImgWidth;
                    if (iLeftPos < 0) iLeftPos = 0;
                    break;
                case ContentAlignment.BottomLeft:
                    iLeftPos = 0;
                    iTopPos = Height - iImgHeight;
                    break;
                case ContentAlignment.BottomCenter:
                    iLeftPos = (int)(Width - iImgWidth) / 2;
                    if (iLeftPos < 0) iLeftPos = 0;
                    iTopPos = Height - iImgHeight;
                    break;
                case ContentAlignment.BottomRight:
                    iLeftPos = Width - iImgWidth;
                    if (iLeftPos < 0) iLeftPos = 0;
                    iTopPos = Height - iImgHeight;
                    break;
            }
            Rectangle myImageRect = new Rectangle(iLeftPos, iTopPos, iImgWidth, iImgHeight);
            return myImageRect;
        }

        #endregion

        #region PaintControl
        protected override void OnPaint(PaintEventArgs e)
        {
            if (m_bInitialised == false) m_bInitialised = true;
            base.OnPaint(e);

            if (m_WeekDayArrayAlreadyCreated == false)
            {
                m_WeekDayArrayAlreadyCreated = true;
                CreateWeekDaysArray();
            }

            switch (m_ViewMode) {
                case ViewMode.vmMonth:
                    DrawMonthImages(e);
                    //first drawi titlebar
                    DrawHeader(e);
                    //draw weekdayshortnames
                    DrawWeekDays(e);
                    //step two draw weenumbers
                    DrawWeekNumbers(e);
                    //draw weekdays
                    DrawMonthDays(e);

                    DrawFooter(e.Graphics);
                    break;
                case ViewMode.vmYear:
                    m_NextTopPos = 0;
                    DrawHeader(e);
                    DrawYear(e.Graphics);
                    break;
                case ViewMode.vm12Years:
                    m_NextTopPos = 0;
                    DrawHeader(e);
                    Draw12YearsRange(e.Graphics);
                    break;
                case ViewMode.vm120Years:
                    m_NextTopPos = 0;
                    DrawHeader(e);
                    Draw120YearsRange(e.Graphics);
                    break;
            }

            if (m_Border.Visible == true)
            {
                e.Graphics.DrawRectangle(new Pen(Color.FromArgb(m_Border.Transparency, m_Border.BorderColor)), new Rectangle(
                                         this.ClientRectangle.Left, this.ClientRectangle.Top,
                                         this.ClientRectangle.Width - 1, this.ClientRectangle.Height - 1));
            }

        }

        private void DrawMonthImages(PaintEventArgs e)
        {
            if (m_MonthImages.UseImages == true)
            {
                Image myMonthImage = GetPaintMonthImage();
                Rectangle myPaintRect = new Rectangle();

                if (myMonthImage != null) {
                    if (m_MonthImages.ImagePosition == MonthImagePosition.Top)
                    {
                        myPaintRect = new Rectangle(0, 0, this.Width, m_MonthImages.ImagesHeight);                        
                        m_NextTopPos = m_MonthImages.ImagesHeight + 1;
                    }
                    else if (m_MonthImages.ImagePosition == MonthImagePosition.CalendarBackground)
                    {
                        myPaintRect = this.ClientRectangle;                        
                        m_NextTopPos = 0;
                    }
                    else if (m_MonthImages.ImagePosition == MonthImagePosition.MonthBackground) {
                    	int iImageTopPos = GetTitleBarHeight() + GetWeekDaysHeight();
                    	int iImageLeftPos = GetWeekNumbersWidth();
                        int iMonthDayHeight = GetMonthDayHeight() + m_MonthDaysStyle.DaysPadding.Vertical; 
                        myPaintRect = new Rectangle(iImageLeftPos, iImageTopPos,
                    	                                       this.Width - GetWeekNumbersWidth()-1,
                                                               (6 * iMonthDayHeight) + m_MonthDayHeightOffset + 
                                                               m_MonthDaysStyle.DaysPadding.Vertical);                    	                        
                        m_NextTopPos = 0;
                    }
                    else m_NextTopPos = 0;
                    MonthImageRenderEventArgs myImageEvent = new MonthImageRenderEventArgs(e.Graphics,
                                                                 myPaintRect, myMonthImage);
                    if (MonthImageRender != null) MonthImageRender(this, myImageEvent);
                    if (myImageEvent.OwnerDraw == false)
                    {
                        //draw monthimage
                        e.Graphics.DrawImage(myMonthImage, myPaintRect);
                    }
                }
                else m_NextTopPos = 0;


            }
            else
                m_NextTopPos = 0;
        }



        private void DrawHeader(PaintEventArgs e)
        {
            if (m_HeaderStyle.Visible == true)
            {
                //first step: draw the background
                int iTextHeight = m_HeaderStyle.Font.Height;
                Rectangle myRectangle;

                myRectangle = new Rectangle(0, m_NextTopPos, this.Width, iTextHeight + 2 * m_HeaderStyle.Padding.Vertical);
                int iLeftPosPrevButton = 0;
                //repos navbuttons
                m_PreviousYearButton.SetBounds(m_HeaderStyle.Padding.Horizontal, m_NextTopPos + ((int)(myRectangle.Height - 18) / 2), 18, 18);
                if (m_ViewMode == ViewMode.vmMonth)
                {
                    if (m_PreviousYearButton.Visible != m_HeaderStyle.ShowNav) m_PreviousYearButton.Visible = m_HeaderStyle.ShowNav;
                    iLeftPosPrevButton = m_HeaderStyle.Padding.Horizontal + m_PreviousYearButton.Width + 1;
                }
                else
                {
                    if (m_PreviousYearButton.Visible != false) m_PreviousYearButton.Visible = false;
                    iLeftPosPrevButton = m_HeaderStyle.Padding.Horizontal;
                }

                m_PreviousButton.SetBounds(iLeftPosPrevButton, m_NextTopPos + ((int)(myRectangle.Height - 18) / 2), 18, 18);
                if (m_PreviousButton.Visible != m_HeaderStyle.ShowNav) m_PreviousButton.Visible = m_HeaderStyle.ShowNav;

                int iLeftPosNextButton = 0;
                m_NextYearButton.SetBounds(this.Width - m_NextYearButton.Width -
                                           m_HeaderStyle.Padding.Horizontal,
                                           m_NextTopPos + ((int)(myRectangle.Height - 18) / 2), 18, 18);
                if (m_ViewMode == ViewMode.vmMonth)
                {
                    if (m_NextYearButton.Visible != m_HeaderStyle.ShowNav) m_NextYearButton.Visible = m_HeaderStyle.ShowNav;
                    iLeftPosNextButton = this.Width - m_NextButton.Width - m_HeaderStyle.Padding.Horizontal -
                                         m_NextYearButton.Width - 1;
                }
                else
                {
                    if (m_NextYearButton.Visible != false) m_NextYearButton.Visible = false;
                    iLeftPosNextButton = this.Width - m_NextYearButton.Width - m_HeaderStyle.Padding.Horizontal;
                }

                string sTitleText = "";
                switch (m_ViewMode)
                {
                    case ViewMode.vmMonth:
                        sTitleText = m_SelectedDate.ToString("MMMM yyyy"); ;
                        break;
                    case ViewMode.vmYear:
                        sTitleText = m_SelectedDate.ToString("yyyy");
                        break;
                    case ViewMode.vm12Years:
                        sTitleText = m_Start12YearsRange.ToString() + "-" + m_End12YearsRange.ToString();
                        break;
                    case ViewMode.vm120Years:
                        sTitleText = m_Start120YearsRange.ToString() + "-" + ((int)m_End120YearsRange + 9).ToString();
                        break;
                }

                //draw header through user (ownerdraw)
                HeaderRenderEventArgs myHeaderRenderEvent = new HeaderRenderEventArgs(e.Graphics, myRectangle,
                                                                                      sTitleText);
                if (HeaderRender != null) HeaderRender(this, myHeaderRenderEvent);

                if (myHeaderRenderEvent.OwnerDraw == false)
                {
                    m_NextButton.SetBounds(iLeftPosNextButton,
                                               m_NextTopPos + ((int)(myRectangle.Height - 18) / 2), 18, 18);
                    if (m_NextButton.Visible != m_HeaderStyle.ShowNav) m_NextButton.Visible = m_HeaderStyle.ShowNav;


                    if (m_HeaderStyle.Background.Style == EStyle.esColor)
                    {
                        //fill rectangle with the first backgroundcolor;
                        Brush myBrush = new SolidBrush(Color.FromArgb(m_HeaderStyle.Background.TransparencyStartColor,
                                                      m_HeaderStyle.Background.StartColor.R,
                                                      m_HeaderStyle.Background.StartColor.G,
                                                      m_HeaderStyle.Background.StartColor.B));
                        e.Graphics.FillRectangle(myBrush, myRectangle);
                    }
                    else if (m_HeaderStyle.Background.Style == EStyle.esParent)
                    {
                        //fill rectangle with the first backgroundcolor;
                        Brush myBrush = new SolidBrush(this.BackColor);
                        e.Graphics.FillRectangle(myBrush, myRectangle);
                    }
                    else if (m_HeaderStyle.Background.Style == EStyle.esGradient)
                    {
                        LinearGradientMode myMode;
                        if (m_HeaderStyle.Background.Gradient == GradientStyle.Vertical)
                            myMode = LinearGradientMode.Vertical;
                        else if (m_HeaderStyle.Background.Gradient == GradientStyle.Horizontal)
                            myMode = LinearGradientMode.Horizontal;
                        else if (m_HeaderStyle.Background.Gradient == GradientStyle.ForwardDiagonal)
                            myMode = LinearGradientMode.ForwardDiagonal;
                        else
                            myMode = LinearGradientMode.BackwardDiagonal;

                        Color Color1 = Color.FromArgb(m_HeaderStyle.Background.TransparencyStartColor,
                                                      m_HeaderStyle.Background.StartColor.R,
                                                      m_HeaderStyle.Background.StartColor.G,
                                                      m_HeaderStyle.Background.StartColor.B);
                        Color Color2 = Color.FromArgb(m_HeaderStyle.Background.TransparencyEndColor,
                                                      m_HeaderStyle.Background.EndColor.R,
                                                      m_HeaderStyle.Background.EndColor.G,
                                                      m_HeaderStyle.Background.EndColor.B);
                        LinearGradientBrush myGBrush = new LinearGradientBrush(myRectangle, Color1, Color2, myMode);
                        e.Graphics.FillRectangle(myGBrush, myRectangle);
                    }
                    //step two: draw the text (monthname and year


                    SizeF myTextDimension = e.Graphics.MeasureString(sTitleText, m_HeaderStyle.Font);

                    StringFormat myStringFormat = new StringFormat();
                    switch (m_HeaderStyle.Align)
                    {
                        case HeaderAlign.Left:
                            myStringFormat.Alignment = StringAlignment.Near;
                            break;
                        case HeaderAlign.Center:
                            myStringFormat.Alignment = StringAlignment.Center;
                            break;
                        case HeaderAlign.Right:
                            myStringFormat.Alignment = StringAlignment.Far;
                            break;
                    }

                    int iLeftOffset = (int)(this.Width - (int)myTextDimension.Width) / 2;
                    Rectangle myTextRect = new Rectangle(33, m_NextTopPos + m_HeaderStyle.Padding.Vertical, this.Width - 66,
                                                         m_HeaderStyle.Font.Height);
                    m_TitlebarHeight = myRectangle.Height;// (int)myTextDimension.Height + 2 * this.m_TitlebarOffset;
                    //save titletextpos for using with mousedown event
                    m_TitleTextLeftStartPos = iLeftOffset;
                    m_TitleTextWidth = (int)myTextDimension.Width;
                    m_TitleTextTopStartPos = m_NextTopPos + m_HeaderStyle.Padding.Vertical;
                    m_TitleTextHeight = m_HeaderStyle.Font.Height;
                    //draw text
                    if (m_bMOuseHoverHeader == false)
                    {
                        e.Graphics.DrawString(sTitleText, m_HeaderStyle.Font, new SolidBrush(Color.FromArgb(m_HeaderStyle.TextTransparency,
                                              m_HeaderStyle.ForeColor)), myTextRect, myStringFormat);
                    }
                    else
                    {
                        e.Graphics.DrawString(sTitleText, m_HeaderStyle.Font, new SolidBrush(Color.FromArgb(m_HeaderStyle.TextTransparency,
                          m_HeaderStyle.HoverColor)), myTextRect, myStringFormat);

                    }
                    //draw border
                    if (m_HeaderStyle.Border.Visible == true)
                    {
                        //border on titlebar bottom
                        e.Graphics.DrawLine(new Pen(Color.FromArgb(255, m_HeaderStyle.Border.BorderColor)),
                                            myRectangle.Left, myRectangle.Bottom, myRectangle.Width, myRectangle.Bottom);
                    }                    
                }
                m_NextTopPos += (myRectangle.Height + 1);
            }
            else
            {
                //titlebar is hidden
                if (m_PreviousButton.Visible != false) m_PreviousButton.Visible = false;
                if (m_PreviousYearButton.Visible != false) m_PreviousYearButton.Visible = false;
                if (m_NextButton.Visible != false) m_NextButton.Visible = false;
                if (m_NextYearButton.Visible != false) m_NextYearButton.Visible = false;
                m_TitlebarHeight = 0;
            }
        }

        private void DrawWeekNumbers(PaintEventArgs e)
        {
            if (m_WeekNumbers.Visible == true)
            {
                //draw weeknumbers                
                m_DrawedMonthDayHeight = 0;
                m_DrawedMonthDayTopStartPos = 0;
                //m_NextTopPos
                m_WeekDayHeight = GetMonthDayHeight();
                m_FirstWeekNumber = GetFirstWeekNumber(0);
                //befor we can draw the weeknumbers we will draw the weeknumbersbackground
                Rectangle myPaintRect = new Rectangle(0, m_NextTopPos, GetWeekNumbersWidth(),
                                                      GetMonthDaysHeight());
                //ownerdraw
                WeekNumbersBackgroundRenderEventArgs myEventArgs = new WeekNumbersBackgroundRenderEventArgs(
                                                                        e.Graphics, myPaintRect);
                if (WeekNumbersBackgroundRender != null) WeekNumbersBackgroundRender(this, myEventArgs);
                if (myEventArgs.OwnerDraw == false)
                {
                    if (m_WeekNumbers.Background.Style == EStyle.esColor)
                    {
                        SolidBrush myBrush = new SolidBrush(Color.FromArgb(m_WeekNumbers.Background.TransparencyStartColor,
                                                            m_WeekNumbers.Background.StartColor.R,
                                                            m_WeekNumbers.Background.StartColor.G,
                                                            m_WeekNumbers.Background.StartColor.B));
                        e.Graphics.FillRectangle(myBrush, myPaintRect);
                    }
                    else if (m_WeekNumbers.Background.Style == EStyle.esParent)
                    {
                        SolidBrush myBrush = new SolidBrush(Color.FromArgb(this.BackColor.R,
                                                            this.BackColor.G, this.BackColor.B));
                        e.Graphics.FillRectangle(myBrush, myPaintRect);
                    } if (m_WeekNumbers.Background.Style == EStyle.esGradient)
                    {
                        LinearGradientMode myMode;
                        if (m_WeekNumbers.Background.Gradient == GradientStyle.Vertical)
                            myMode = LinearGradientMode.Vertical;
                        else if (m_WeekNumbers.Background.Gradient == GradientStyle.Horizontal)
                            myMode = LinearGradientMode.Horizontal;
                        else if (m_WeekNumbers.Background.Gradient == GradientStyle.ForwardDiagonal)
                            myMode = LinearGradientMode.ForwardDiagonal;
                        else
                            myMode = LinearGradientMode.BackwardDiagonal;

                        Color StartColor = Color.FromArgb(m_WeekNumbers.Background.TransparencyStartColor,
                                                          m_WeekNumbers.Background.StartColor.R,
                                                          m_WeekNumbers.Background.StartColor.G,
                                                          m_WeekNumbers.Background.StartColor.B);
                        Color EndColor = Color.FromArgb(m_WeekNumbers.Background.TransparencyEndColor,
                                                        m_WeekNumbers.Background.EndColor.R,
                                                        m_WeekNumbers.Background.EndColor.G,
                                                        m_WeekNumbers.Background.EndColor.B);
                        LinearGradientBrush myGBrush = new LinearGradientBrush(myPaintRect, StartColor, EndColor, myMode);
                        e.Graphics.FillRectangle(myGBrush, myPaintRect);
                    }
                }
                //draw weeknumbers
                for (int iWeekNumbersCount = 0; iWeekNumbersCount < 6; iWeekNumbersCount++)
                {
                    //draw each weeknumber
                    DrawWeekNumber(e.Graphics, iWeekNumbersCount);
                }

                //draw border
                if (m_WeekNumbers.Border.Visible == true)
                {
                    int iRightPos = GetWeekNumbersWidth() - 1;
                    e.Graphics.DrawLine(new Pen(Color.FromArgb(m_WeekNumbers.Border.Transparency, 
                                        m_WeekNumbers.Border.BorderColor)),
                                        iRightPos, m_DrawedMonthDayTopStartPos,
                                        iRightPos, m_DrawedMonthDayHeight + m_DrawedMonthDayTopStartPos +
                                        m_MonthDaysStyle.DaysPadding.Vertical);
                }
            }           
        }

        private void DrawWeekNumber(Graphics e, int Index)
        {
            int iPaddingOffset = (Index * m_MonthDaysStyle.DaysPadding.Vertical) +
                                  m_MonthDaysStyle.DaysPadding.Vertical;
            //get offset to fill out the space between the full monthdayheights and controlheight
            int iTopHeightOffset = 0;
            int iHeightOffset = 0;
            if (m_MonthDayHeightOffset > 0 && Index < m_MonthDayHeightOffset)
            {
                iTopHeightOffset = Index;
            }
            else
            {
                int iTempOffset = m_MonthDayHeightOffset - 1;
                if (iTempOffset < 0) iTempOffset = 0;
                iTopHeightOffset = iTempOffset;
            }
            if (m_MonthDayHeightOffset > 0 && Index < m_MonthDayHeightOffset - 1)
            {
                iHeightOffset = 1;
            }
            int iWeekNumber = ((int)m_FirstWeekNumber + Index);
            if (iWeekNumber == 53) iWeekNumber = 1;
            string sWeekNumber = iWeekNumber.ToString();
            //get paintrect
            Rectangle myPaintRect = new Rectangle(0, m_NextTopPos + (Index * (m_WeekDayHeight + 
                                                  m_MonthDaysStyle.DaysPadding.Vertical)) + 1+
                                                  m_MonthDaysStyle.DaysPadding.Vertical + iTopHeightOffset,
                                                  GetWeekNumbersWidth(), m_WeekDayHeight + iHeightOffset);
            //ownerdraw
            WeeknumberRenderEventArgs myEventArgs = new WeeknumberRenderEventArgs(e, myPaintRect, iWeekNumber);
            if (WeekNumberRender != null) WeekNumberRender(this, myEventArgs);
            if (myEventArgs.OwnerDraw == false)
            {
                //WeekNumberRender
                if (Index == 0)
                {
                    //save startpos to draw border later
                    m_DrawedMonthDayTopStartPos = myPaintRect.Top - m_MonthDaysStyle.DaysPadding.Vertical - 1;
                }

                m_DrawedMonthDayHeight += myPaintRect.Height + m_MonthDaysStyle.DaysPadding.Vertical;
                

                //draw weeknumberstext
                System.Diagnostics.Debug.WriteLine("Draw Weeknumber: " + sWeekNumber);                

                StringFormat myStringFormat = new StringFormat();
                myStringFormat.Alignment = StringAlignment.Far;
                switch (m_WeekNumbers.Align)
                {
                    case WeekNumberAlign.Top:
                        myStringFormat.LineAlignment = StringAlignment.Near;
                        break;
                    case WeekNumberAlign.Center:
                        myStringFormat.LineAlignment = StringAlignment.Center;
                        break;
                    case WeekNumberAlign.Bottom:
                        myStringFormat.LineAlignment = StringAlignment.Far;
                        break;
                }

                e.DrawString(sWeekNumber, m_WeekNumbers.Font, new SolidBrush(Color.FromArgb(m_WeekNumbers.TextTransparency,
                             m_WeekNumbers.ForeColor)), new Rectangle(0, myPaintRect.Top,
                                                                      GetWeekNumbersWidth() - 2,
                                                                      myPaintRect.Height), myStringFormat);
            }   
        }


        private void DrawWeekDays(PaintEventArgs e)
        {
            //draw header
            if (m_WeekDaysStyle.Visible == true)
            {
                //draw header background
                Rectangle myRect = new Rectangle(0, m_NextTopPos, this.Width, m_WeekDaysStyle.Font.Height);
                //ownerdraw
                WeekDayBackgroundRenderEventArgs myEventArgs = new WeekDayBackgroundRenderEventArgs(e.Graphics,
                                                                   myRect);
                if (WeekDayBackgroundRender != null) WeekDayBackgroundRender(this, myEventArgs);

                if (myEventArgs.OwnerDraw == false)
                {
                    if (m_WeekDaysStyle.Background.Style == EStyle.esColor)
                    {
                        SolidBrush myBrush = new SolidBrush(Color.FromArgb(m_WeekDaysStyle.Background.TransparencyStartColor,
                                                            m_WeekDaysStyle.Background.StartColor.R,
                                                            m_WeekDaysStyle.Background.StartColor.G,
                                                            m_WeekDaysStyle.Background.StartColor.B));
                        e.Graphics.FillRectangle(myBrush, myRect);
                    }
                    else if (m_WeekDaysStyle.Background.Style == EStyle.esParent)
                    {
                        SolidBrush myBrush = new SolidBrush(Color.FromArgb(this.BackColor.R,
                                                            this.BackColor.G, this.BackColor.B));
                        e.Graphics.FillRectangle(myBrush, myRect);
                    } if (m_WeekDaysStyle.Background.Style == EStyle.esGradient)
                    {
                        LinearGradientMode myMode;
                        if (m_WeekDaysStyle.Background.Gradient == GradientStyle.Vertical)
                            myMode = LinearGradientMode.Vertical;
                        else if (m_WeekDaysStyle.Background.Gradient == GradientStyle.Horizontal)
                            myMode = LinearGradientMode.Horizontal;
                        else if (m_WeekDaysStyle.Background.Gradient == GradientStyle.ForwardDiagonal)
                            myMode = LinearGradientMode.ForwardDiagonal;
                        else
                            myMode = LinearGradientMode.BackwardDiagonal;

                        Color StartColor = Color.FromArgb(m_WeekDaysStyle.Background.TransparencyStartColor,
                                                          m_WeekDaysStyle.Background.StartColor.R,
                                                          m_WeekDaysStyle.Background.StartColor.G,
                                                          m_WeekDaysStyle.Background.StartColor.B);
                        Color EndColor = Color.FromArgb(m_WeekDaysStyle.Background.TransparencyEndColor,
                                                        m_WeekDaysStyle.Background.EndColor.R,
                                                        m_WeekDaysStyle.Background.EndColor.G,
                                                        m_WeekDaysStyle.Background.EndColor.B);
                        LinearGradientBrush myGBrush = new LinearGradientBrush(myRect, StartColor, EndColor, myMode);
                        e.Graphics.FillRectangle(myGBrush, myRect);
                    }
                }

                DayOfWeek myFirstWeekDay = GetFirstWeekDay();
                
                
                //save weekdaywidth to draw weekdays
                int iWeekNumbersWidth = GetWeekNumbersWidth();
                m_WeekDayWidth = GetMonthDayWidth();

                //region draw weekdaynames
                int iWeekDayPos = 0;
                string sShortWeekName = "";
                StringFormat myStringFormat = new StringFormat();
                switch (m_WeekDaysStyle.Align)
                {
                    case HeaderAlign.Left:
                        myStringFormat.Alignment = StringAlignment.Near;
                        break;
                    case HeaderAlign.Center:
                        myStringFormat.Alignment = StringAlignment.Center;
                        break;
                    case HeaderAlign.Right:
                        myStringFormat.Alignment = StringAlignment.Far;
                        break;
                }

                int iPaddingOffset = m_MonthDaysStyle.DaysPadding.Horizontal;
                Color myUsedForeColor = m_WeekDaysStyle.ForeColor;
                int iLeftWidthOffset = 0;
                int iWidthOffset = 0;
                Rectangle myPaintRect = new Rectangle();
                for (int iWeekDayCounter = (int)myFirstWeekDay; iWeekDayCounter <= 6; iWeekDayCounter++)
                {
                    iLeftWidthOffset = 0;
                    iWidthOffset = 0;
                    //get needed leftwidthoffset to compensate space between all monthdays an controlwidth
                    if (m_MonthDayWidthOffset > 0 && iWeekDayCounter < m_MonthDayWidthOffset)
                    {
                        iLeftWidthOffset = iWeekDayCounter;
                    }
                    else
                    {
                        int iTmpWidthOffset = m_MonthDayWidthOffset - 1;
                        if (iTmpWidthOffset < 0) iTmpWidthOffset = 0;
                        iLeftWidthOffset = iTmpWidthOffset;
                    }
                    if (m_MonthDayWidthOffset > 0 && iWeekDayCounter < m_MonthDayWidthOffset - 1)
                    {
                        iWidthOffset = 1;
                    }
                    //get weekdayname
                    sShortWeekName = m_DateTimeFormatInfo.GetAbbreviatedDayName((DayOfWeek)iWeekDayCounter);

                    myPaintRect = new Rectangle(iWeekNumbersWidth + (iWeekDayPos * m_WeekDayWidth) +
                                                iPaddingOffset + iLeftWidthOffset, m_NextTopPos,
                                                m_WeekDayWidth + iWidthOffset, m_WeekDaysStyle.Font.Height);
                    //ownerdraw
                    WeekDayRenderEventArgs myWeekDayEventArgs = new WeekDayRenderEventArgs(e.Graphics, myPaintRect,
                                                                                           (DayOfWeek)iWeekDayCounter,
                                                                                           sShortWeekName);
                    if (WeekDayRender != null) WeekDayRender(this, myWeekDayEventArgs);
                    if (myWeekDayEventArgs.OwnerDraw == false)
                    {
                        if (((DayOfWeek)iWeekDayCounter) == DayOfWeek.Sunday && m_MonthDaysStyle.MarkSunday == true)
                            myUsedForeColor = m_MonthDaysStyle.SundayColor;
                        else if (((DayOfWeek)iWeekDayCounter) == DayOfWeek.Saturday && m_MonthDaysStyle.MarkSaturday == true)
                            myUsedForeColor = m_MonthDaysStyle.SaturdayColor;
                        else
                            myUsedForeColor = m_WeekDaysStyle.ForeColor;

                        e.Graphics.DrawString(sShortWeekName, m_WeekDaysStyle.Font, new SolidBrush(myUsedForeColor),
                                              myPaintRect, myStringFormat);
                    }
                    if (((DayOfWeek)iWeekDayCounter) == DayOfWeek.Sunday)
                    {
                        m_SundayIndex = iWeekDayPos;
                    }
                    iWeekDayPos++;
                    iPaddingOffset += m_MonthDaysStyle.DaysPadding.Horizontal;
                }
                //draw weekdays before firstweekday
                for (int iWeekDayCounter = 0; iWeekDayCounter < (int)myFirstWeekDay; iWeekDayCounter++)
                {                   
                    iLeftWidthOffset = 0;
                    iWidthOffset = 0;
                    //get needed leftwidthoffset to compensate space between all monthdays an controlwidth
                    if (m_MonthDayWidthOffset > 0 && iWeekDayCounter < m_MonthDayWidthOffset)
                    {
                        iLeftWidthOffset = iWeekDayCounter;
                    }
                    else
                    {
                        int iTmpWidthOffset = m_MonthDayWidthOffset - 1;
                        if (iTmpWidthOffset < 0) iTmpWidthOffset = 0;
                        iLeftWidthOffset = iTmpWidthOffset;
                    }
                    if (m_MonthDayWidthOffset > 0 && iWeekDayCounter < m_MonthDayWidthOffset - 1)
                    {
                        iWidthOffset = 1;
                    }

                    sShortWeekName = m_DateTimeFormatInfo.GetAbbreviatedDayName((DayOfWeek)iWeekDayCounter);

                    myPaintRect = new Rectangle(iWeekNumbersWidth + (iWeekDayPos * m_WeekDayWidth) +
                                                iPaddingOffset + iLeftWidthOffset, m_NextTopPos,
                                                m_WeekDayWidth + iWidthOffset, m_WeekDaysStyle.Font.Height);
                    //ownerdraw
                    WeekDayRenderEventArgs myWeekDayEventArgs = new WeekDayRenderEventArgs(e.Graphics, myPaintRect,
                                                                                           (DayOfWeek)iWeekDayCounter,
                                                                                           sShortWeekName);
                    if (WeekDayRender != null) WeekDayRender(this, myWeekDayEventArgs);
                    if (myWeekDayEventArgs.OwnerDraw == false)
                    {
                        if (((DayOfWeek)iWeekDayCounter) == DayOfWeek.Sunday && m_MonthDaysStyle.MarkSunday == true)
                            myUsedForeColor = m_MonthDaysStyle.SundayColor;
                        else if (((DayOfWeek)iWeekDayCounter) == DayOfWeek.Saturday && m_MonthDaysStyle.MarkSaturday == true)
                            myUsedForeColor = m_MonthDaysStyle.SaturdayColor;
                        else
                            myUsedForeColor = m_WeekDaysStyle.ForeColor;


                        e.Graphics.DrawString(sShortWeekName, m_WeekDaysStyle.Font, new SolidBrush(Color.FromArgb(
                                              m_WeekDaysStyle.TextTransparency, myUsedForeColor)),
                                              myPaintRect, myStringFormat);
                    }
                    if (((DayOfWeek)iWeekDayCounter) == DayOfWeek.Sunday)
                    {
                        m_SundayIndex = iWeekDayPos;
                    }
                    iWeekDayPos++;
                    iPaddingOffset += m_MonthDaysStyle.DaysPadding.Horizontal;
                }

                //draw border
                if (m_WeekDaysStyle.Border.Visible == true)
                {
                    e.Graphics.DrawLine(new Pen(Color.FromArgb(m_WeekDaysStyle.Border.Transparency, m_WeekDaysStyle.Border.BorderColor)),
                                        iWeekNumbersWidth, myRect.Bottom, myRect.Width, myRect.Bottom);

                }

                //add header to get next top start pos
                m_NextTopPos += myRect.Height;
            }
        }

        private void DrawMonthDays(PaintEventArgs e)
        {
            //get weekdays from array and draw it to control
            //get height of each weekday
            m_WeekDayHeight = GetMonthDayHeight();
            if (m_WeekDayHeight < m_MonthDaysStyle.Font.Height)
            {
                m_WeekDayHeight = m_MonthDaysStyle.Font.Height;
            }

            m_NextTopPos = m_NextTopPos + m_MonthDaysStyle.DaysPadding.Vertical;
            m_WeekDaysTopStartPos = m_NextTopPos + 1;
            m_WeekDaysLeftStartPos = GetWeekNumbersWidth()/* + m_MonthDaysStyle.DaysPadding.Horizontal*/;
            
            for (int iRowCounter = 0; iRowCounter < 6; iRowCounter++)
            {
                for (int iCellCounter = 0; iCellCounter < 7; iCellCounter++)
                {
                    if (m_WeekDayItems[iCellCounter, iRowCounter].TrailingDay == true)
                    {
                        if (m_MonthDaysStyle.ShowTrailingDays == true)
                        {
                            DrawTrailingDay(e.Graphics, iCellCounter, iRowCounter);
                        }
                    }
                    else
                    {
                        DrawMonthDay(e.Graphics, iCellCounter, iRowCounter);
                    }
                }
               
                m_NextTopPos += m_WeekDayHeight + m_MonthDaysStyle.DaysPadding.Vertical;
            }

            //draw hover for selecting range
            DrawMultiSelectHoverRange(e.Graphics);
        }

        private void DrawMultiSelectHoverRange(Graphics e)
        {
            //draw a hover rectangle from first selection to lastselection
            System.Diagnostics.Debug.WriteLine("Selectionmode: " + m_SelectionMode.ToString());
            System.Diagnostics.Debug.WriteLine("MultipleSelectionMode active: " + m_bMultipleSelectingModeActive.ToString());
            if (m_SelectionMode == SelectionMode.smMulti && m_bMultipleSelectingModeActive == true && m_bMouseHover == true)
            {
                System.Diagnostics.Debug.WriteLine("Hovermode active: " + m_bMouseHover.ToString());
                System.Diagnostics.Debug.WriteLine("Can i mark hover? " + m_MonthDaysStyle.MarkHover.ToString());
                if ((m_bMouseHover == true || this.Focused == true) && m_MonthDaysStyle.MarkHover == true)
                {
                    int iStartIndex = (m_StartMultiSelectionHover.Row * 7) + m_StartMultiSelectionHover.Cell;
                    int iCurrentIndex = (m_MouseSelectedDay.Row * 7) + m_MouseSelectedDay.Cell;
                    Rectangle myPaintRect = new Rectangle();
                    System.Diagnostics.Debug.WriteLine("Startitem: " + iStartIndex.ToString());
                    System.Diagnostics.Debug.WriteLine("StartItem cell: " + m_StartMultiSelectionHover.Cell.ToString() +
                                                        " row: " + m_StartMultiSelectionHover.Row.ToString());
                    System.Diagnostics.Debug.WriteLine("enditem: " + iCurrentIndex.ToString());
                    System.Diagnostics.Debug.WriteLine("EndItem cell: " + m_MouseSelectedDay.Cell.ToString() +
                                                        " row: " + m_MouseSelectedDay.Row.ToString());
                    if (iStartIndex != iCurrentIndex)
                    {
                        SelectedDay myTmpFirstSelDay = m_StartMultiSelectionHover;
                        SelectedDay myTmpLastSelDay = m_MouseSelectedDay;

                        //find startcell
                        if (m_StartMultiSelectionHover.Cell < m_MouseSelectedDay.Cell)
                        {
                            myTmpFirstSelDay.Cell = m_StartMultiSelectionHover.Cell;
                            myTmpLastSelDay.Cell = m_MouseSelectedDay.Cell;
                        }
                        else
                        {
                            myTmpFirstSelDay.Cell = m_MouseSelectedDay.Cell;
                            myTmpLastSelDay.Cell = m_StartMultiSelectionHover.Cell;
                        }
                        //find startrow
                        if (m_StartMultiSelectionHover.Row < m_MouseSelectedDay.Row)
                        {
                            myTmpFirstSelDay.Row = m_StartMultiSelectionHover.Row;
                            myTmpLastSelDay.Row = m_MouseSelectedDay.Row;
                        }
                        else
                        {
                            myTmpFirstSelDay.Row = m_MouseSelectedDay.Row;
                            myTmpLastSelDay.Row = m_StartMultiSelectionHover.Row;
                        }
                        
                        myTmpLastSelDay.Cell++;
                        myTmpLastSelDay.Row++;
                        //get needed leftwidthoffset to compensate space between all monthdays an controlwidth
                        int iLeftWidthOffset = 0;                        
                        int iWidthOffset = 0;                        
                        
                        if (m_MonthDayWidthOffset > 0 && myTmpFirstSelDay.Cell < m_MonthDayWidthOffset)
                        {
                            iLeftWidthOffset = myTmpFirstSelDay.Cell;
                        }
                        else
                        {
                            int iTmpWidthOffset = m_MonthDayWidthOffset - 1;
                            if (iTmpWidthOffset < 0) iTmpWidthOffset = 0;
                            iLeftWidthOffset = iTmpWidthOffset;
                        }
                        
                        //get startcellwidthoffset
                        if (m_MonthDayWidthOffset > 0 && myTmpFirstSelDay.Cell < m_MonthDayWidthOffset-1)
                        {
                            iWidthOffset = m_MonthDayWidthOffset - myTmpFirstSelDay.Cell-1;
                            if (iWidthOffset < 0) iWidthOffset = 0;
                        }

                        //the same for height
                        int iTopHeightOffset = 0;
                        int iHeightOffset = 0;
                        if (m_MonthDayHeightOffset > 0 && m_MouseSelectedDay.Row < m_MonthDayHeightOffset)
                        {
                            iTopHeightOffset = m_MouseSelectedDay.Row;
                        }
                        else
                        {
                            int iTempOffset = m_MonthDayHeightOffset - 1;
                            if (iTempOffset < 0) iTempOffset = 0;
                            iTopHeightOffset = iTempOffset;
                        }
                        if (m_MonthDayHeightOffset > 0 && m_MouseSelectedDay.Row < m_MonthDayHeightOffset - 1)
                        {
                            iHeightOffset = m_MonthDayHeightOffset - m_MouseSelectedDay.Row - 1;
                            if (iHeightOffset < 0) iHeightOffset = 0;
                        }
                        //get paintrect
                        int iLeftPos = ((myTmpFirstSelDay.Cell) * 
                                        (m_WeekDayWidth + m_MonthDaysStyle.DaysPadding.Horizontal)) + 
                                        m_MonthDaysStyle.DaysPadding.Horizontal;
                        //get top weekday pos
                        int iTopPos = ((myTmpFirstSelDay.Row) * 
                                       (m_WeekDayHeight + m_MonthDaysStyle.DaysPadding.Vertical));

                        int iSelCells = myTmpLastSelDay.Cell - myTmpFirstSelDay.Cell;
                        System.Diagnostics.Debug.WriteLine("SelCells: " + iSelCells.ToString());
                        if (iSelCells <= 0) iSelCells = 1;
                        int iSelRows = myTmpLastSelDay.Row - myTmpFirstSelDay.Row;
                        System.Diagnostics.Debug.WriteLine("SelRows: " + iSelRows.ToString());
                        if (iSelRows <= 0) iSelRows = 1;
                        System.Diagnostics.Debug.WriteLine("SelCells: " + iSelCells.ToString());
                        System.Diagnostics.Debug.WriteLine("SelRows: " + iSelRows.ToString());
                        //paintrect
                        myPaintRect = new Rectangle(GetWeekNumbersWidth() + iLeftPos + iLeftWidthOffset,
                                                    m_WeekDaysTopStartPos + iTopPos + iTopHeightOffset,
                                                    (iSelCells * 
                                                    (m_WeekDayWidth+m_MonthDaysStyle.DaysPadding.Horizontal))
                                                    - m_MonthDaysStyle.DaysPadding.Horizontal + iWidthOffset, 
                                                    (iSelRows * 
                                                    (m_WeekDayHeight+m_MonthDaysStyle.DaysPadding.Vertical))
                                                    - m_MonthDaysStyle.DaysPadding.Vertical + iHeightOffset);
                    }
                    else
                    {
                        int iLeftWidthOffset = 0;
                        int iWidthOffset = 0;
                        if (m_MonthDayWidthOffset > 0 && m_MouseSelectedDay.Cell < m_MonthDayWidthOffset)
                        {
                            iLeftWidthOffset = m_MouseSelectedDay.Cell * 1;
                        }
                        else
                        {
                            int iTmpWidthOffset = m_MonthDayWidthOffset - 1;
                            if (iTmpWidthOffset < 0) iTmpWidthOffset = 0;
                            iLeftWidthOffset = iTmpWidthOffset * 1;
                        }
                        if (m_MonthDayWidthOffset > 0 && m_MouseSelectedDay.Cell < m_MonthDayWidthOffset-1)
                        {
                            iWidthOffset = 1;
                        }

                        //the same for height
                        int iTopHeightOffset = 0;
                        int iHeightOffset = 0;
                        if (m_MonthDayHeightOffset > 0 && m_MouseSelectedDay.Row < m_MonthDayHeightOffset)
                        {
                            iTopHeightOffset = m_MouseSelectedDay.Row;
                        }
                        else
                        {
                            int iTempOffset = m_MonthDayHeightOffset - 1;
                            if (iTempOffset < 0) iTempOffset = 0;
                            iTopHeightOffset = iTempOffset;
                        }
                        if (m_MonthDayHeightOffset > 0 && m_MouseSelectedDay.Row < m_MonthDayHeightOffset - 1)
                        {
                            iHeightOffset = 1;
                        }
                        //draw hover over a single item
                        //get the left weekday pos
                        System.Diagnostics.Debug.WriteLine("draw a single item hover");
                        int iLeftPos = ((m_MouseSelectedDay.Cell) * 
                                        (m_WeekDayWidth + m_MonthDaysStyle.DaysPadding.Horizontal)) + 
                                        m_MonthDaysStyle.DaysPadding.Horizontal;
                        //get top weekday pos
                        int iTopPos = ((m_MouseSelectedDay.Row) * 
                                       (m_WeekDayHeight + m_MonthDaysStyle.DaysPadding.Vertical));
                        //paintrect
                        myPaintRect = new Rectangle(GetWeekNumbersWidth() + iLeftPos + iLeftWidthOffset,
                                                    m_WeekDaysTopStartPos + iTopPos + iTopHeightOffset,
                                                    m_WeekDayWidth + iWidthOffset, m_WeekDayHeight +
                                                    iHeightOffset);
                    }

                    if (m_MonthDaysStyle.HoverStyle.Background.Style == EStyle.esColor)
                    {
                        SolidBrush myBrush = new SolidBrush(Color.FromArgb(m_MonthDaysStyle.HoverStyle.Background.TransparencyStartColor,
                                                            m_MonthDaysStyle.HoverStyle.Background.StartColor));
                        e.FillRectangle(myBrush, myPaintRect);
                    }
                    else if (m_MonthDaysStyle.HoverStyle.Background.Style == EStyle.esParent)
                    {
                        SolidBrush myBrush = new SolidBrush(this.BackColor);
                        e.FillRectangle(myBrush, myPaintRect);
                    }
                    else if (m_MonthDaysStyle.HoverStyle.Background.Style == EStyle.esGradient)
                    {
                        LinearGradientMode myMode;
                        if (m_MonthDaysStyle.HoverStyle.Background.Gradient == GradientStyle.Vertical)
                            myMode = LinearGradientMode.Vertical;
                        else if (m_MonthDaysStyle.HoverStyle.Background.Gradient == GradientStyle.Horizontal)
                            myMode = LinearGradientMode.Horizontal;
                        else if (m_MonthDaysStyle.HoverStyle.Background.Gradient == GradientStyle.ForwardDiagonal)
                            myMode = LinearGradientMode.ForwardDiagonal;
                        else
                            myMode = LinearGradientMode.BackwardDiagonal;

                        LinearGradientBrush myGBrush = new LinearGradientBrush(myPaintRect, Color.FromArgb(
                                                                               m_MonthDaysStyle.HoverStyle.Background.TransparencyStartColor,
                                                                               m_MonthDaysStyle.HoverStyle.Background.StartColor),
                                                                               Color.FromArgb(m_MonthDaysStyle.HoverStyle.Background.TransparencyEndColor,
                                                                               m_MonthDaysStyle.HoverStyle.Background.EndColor), myMode);
                        e.FillRectangle(myGBrush, myPaintRect);
                    }

                    //draw border
                    if (m_MonthDaysStyle.HoverStyle.Border.Visible == true)
                    {
                        e.DrawRectangle(new Pen(Color.FromArgb(m_MonthDaysStyle.HoverStyle.Border.Transparency,
                                        m_MonthDaysStyle.HoverStyle.Border.BorderColor)),
                                        new Rectangle(myPaintRect.Left, myPaintRect.Top, myPaintRect.Width - 1,
                                        myPaintRect.Height - 1));

                    }
                }

            }
        }

        private void DrawMonthDay(Graphics e, int CellIndex, int RowIndex)
        {
            System.Diagnostics.Debug.WriteLine("MonthDaysWidthOffset: " + m_MonthDayWidthOffset.ToString());
            System.Diagnostics.Debug.WriteLine("MonthDaysHeightOffset: " + m_MonthDayHeightOffset.ToString());

            bool bSelectedDay = false;
            MonthDaysElementStyle myUsedElementStyle = m_MonthDaysStyle;
            DateTime myCurrentDate = new DateTime(m_WeekDayItems[CellIndex, RowIndex].Year,
                                                  m_WeekDayItems[CellIndex, RowIndex].Month,
                                                  m_WeekDayItems[CellIndex, RowIndex].Day);
            
            int iLeftWidthOffset = 0;
            int iWidthOffset = 0;
            //get needed leftwidthoffset to compensate space between all monthdays an controlwidth
            if (m_MonthDayWidthOffset > 0 && CellIndex < m_MonthDayWidthOffset)
            {
                iLeftWidthOffset = CellIndex;
            }
            else
            {
                int iTmpWidthOffset = m_MonthDayWidthOffset - 1;
                if (iTmpWidthOffset < 0) iTmpWidthOffset = 0;
                iLeftWidthOffset = iTmpWidthOffset;
            }
            if (m_MonthDayWidthOffset > 0 && CellIndex < m_MonthDayWidthOffset-1)
            {
                iWidthOffset = 1;
            }
            //the same for height
            int iTopHeightOffset = 0;
            int iHeightOffset = 0;
            if (m_MonthDayHeightOffset > 0 && RowIndex < m_MonthDayHeightOffset)
            {
                iTopHeightOffset = RowIndex;
            }
            else
            {
                int iTempOffset = m_MonthDayHeightOffset - 1;
                if (iTempOffset < 0) iTempOffset = 0;
                iTopHeightOffset = iTempOffset;
            }
            if (m_MonthDayHeightOffset > 0 && RowIndex < m_MonthDayHeightOffset - 1)
            {
                iHeightOffset = 1;
            }

            //get the left weekday pos
            int iLeftPos = (CellIndex) * (m_WeekDayWidth + m_MonthDaysStyle.DaysPadding.Horizontal);
            //get top weekday pos
            int iTopPos = (RowIndex) * m_WeekDayHeight;
            //paintrect
            Rectangle myPaintRect = new Rectangle(GetWeekNumbersWidth() + iLeftPos + iLeftWidthOffset +
                                                  m_MonthDaysStyle.DaysPadding.Horizontal,
                                                  m_NextTopPos + 1 + iTopHeightOffset,
                                                  m_WeekDayWidth + iWidthOffset, m_WeekDayHeight + iHeightOffset);
            //ownerdraw
            MonthDayRenderEventArgs myRenderEventArgs = new MonthDayRenderEventArgs(e, myPaintRect,
                                                                    m_WeekDayItems[CellIndex, RowIndex].WeekDay,
                                                                    m_WeekDayItems[CellIndex, RowIndex].Day, false);
            if (MonthDayRender != null) MonthDayRender(this, myRenderEventArgs);
            if (myRenderEventArgs.OwnerDraw == false)
            {


                if (m_SelectionMode == SelectionMode.smOne || m_SelectionMode == SelectionMode.smNone)
                {
                    if (myCurrentDate.ToShortDateString() == m_SelectedDate.ToShortDateString())
                    {
                        if (m_MonthDaysStyle.MarkSelectedDay == true)
                        {
                            bSelectedDay = true;
                        }
                    }
                }
                else if (m_SelectionMode == SelectionMode.smMulti)
                {
                    //draw multiple selected days
                    if (m_SelectedDates.IndexOf(myCurrentDate) > -1)
                        bSelectedDay = true;
                }

                //m_WeekDayItems[CellIndex, RowIndex]
                DateItem[] myItems = m_Dates.DateInfo(new DateTime(m_WeekDayItems[CellIndex, RowIndex].Year,
                                              m_WeekDayItems[CellIndex, RowIndex].Month,
                                              m_WeekDayItems[CellIndex, RowIndex].Day));




                //first draw background
                //get backgroundstyle
                BackgroundStyle myBackground = myUsedElementStyle.SelectedDay.Background;
                if (bSelectedDay == false)
                {
                    //get formatedday backgroundstyle
                    if (myItems.Length > 0 && myItems[0].Enabled == true)
                        myBackground = myItems[0].Background;
                    else //use normal backgroundstyle
                        myBackground = myUsedElementStyle.Background;
                    
                }
                //draw day
                if (myBackground.Style == EStyle.esColor)
                {
                    SolidBrush myBrush = new SolidBrush(Color.FromArgb(myBackground.TransparencyStartColor,
                                                        myBackground.StartColor));
                    e.FillRectangle(myBrush, myPaintRect);
                }
                else if (myBackground.Style == EStyle.esParent)
                {
                    SolidBrush myBrush = new SolidBrush(this.BackColor);
                    e.FillRectangle(myBrush, myPaintRect);
                }
                else if (myBackground.Style == EStyle.esGradient)
                {
                    LinearGradientMode myMode;
                    if (myBackground.Gradient == GradientStyle.Vertical)
                        myMode = LinearGradientMode.Vertical;
                    else if (myBackground.Gradient == GradientStyle.Horizontal)
                        myMode = LinearGradientMode.Horizontal;
                    else if (myBackground.Gradient == GradientStyle.ForwardDiagonal)
                        myMode = LinearGradientMode.ForwardDiagonal;
                    else
                        myMode = LinearGradientMode.BackwardDiagonal;

                    LinearGradientBrush myGBrush = new LinearGradientBrush(myPaintRect, Color.FromArgb(
                                                                           myBackground.TransparencyStartColor,
                                                                           myBackground.StartColor),
                                                                           Color.FromArgb(myBackground.TransparencyEndColor,
                                                                           myBackground.EndColor), myMode);
                    e.FillRectangle(myGBrush, myPaintRect);
                }

                ContentAlignment myDayAlign = myUsedElementStyle.Align;
                //draw formated days text
                if (myItems.Length > 0 && myItems[0].Enabled == true)
                {
                    int iAvailableWidth = myPaintRect.Width - (myItems[0].Padding.Left + myItems[0].Padding.Right);
                    int iAvailableHeight = myPaintRect.Height - (myItems[0].Padding.Top + myItems[0].Padding.Bottom);

                    #region draw backgroundimage
                    //draw formated day background image                
                    if (myItems[0].BackgroundImage != null)
                    {
                        int iBackImageHeight = myItems[0].BackgroundImage.Height;
                        int iBackImageWidth = myItems[0].BackgroundImage.Width;
                        int iLeftBackImgPos = 0;
                        int iTopBackImgPos = 0;

                        if (iBackImageHeight < myPaintRect.Height && iBackImageWidth < myPaintRect.Width)
                        {
                            //draw image backgroundcenter
                            iLeftBackImgPos = (int)((iAvailableWidth - iBackImageWidth) / 2);
                            iTopBackImgPos = (int)((iAvailableHeight - iBackImageHeight) / 2);
                            iTopBackImgPos = myItems[0].Padding.Top;
                            iLeftBackImgPos = myItems[0].Padding.Left;
                            iBackImageHeight = iBackImageHeight - (myItems[0].Padding.Top + myItems[0].Padding.Bottom);
                            iBackImageWidth = iBackImageWidth - (myItems[0].Padding.Left + myItems[0].Padding.Right);
                        }
                        else
                        {
                            double dReduceFactor = 0.0f;
                            //one site of backimage is greater than paintarea                                 
                            if (iAvailableWidth < iAvailableHeight)
                                dReduceFactor = ((double)iAvailableWidth / iBackImageWidth);
                            else
                                dReduceFactor = ((double)iAvailableHeight / iBackImageHeight);

                            iBackImageWidth = (int)((double)iBackImageWidth * dReduceFactor);
                            iBackImageHeight = (int)((double)iBackImageHeight * dReduceFactor);

                            //calc offsets
                            if (iBackImageWidth < iAvailableWidth)
                                iLeftBackImgPos = (int)(iAvailableWidth - iBackImageWidth) / 2;
                            else iLeftBackImgPos = 0;

                            if (iBackImageHeight < iAvailableHeight)
                                iTopBackImgPos = (int)(iAvailableHeight - iBackImageHeight) / 2;
                            else iTopBackImgPos = 0;
                        }
                        e.DrawImage(myItems[0].BackgroundImage, new Rectangle(myPaintRect.Left + iLeftBackImgPos,
                                                                              myPaintRect.Top + iTopBackImgPos,
                                                                              iBackImageWidth, iBackImageHeight));
                    }
                    #endregion

                    #region draw image

                    if (myItems[0].Image != null)
                    {
                        Rectangle myImageRect = GetImageRect(myItems[0], myItems[0].Image,
                                                             iAvailableWidth, iAvailableHeight);

                        e.DrawImage(myItems[0].Image, new Rectangle(myPaintRect.Left + myItems[0].Padding.Left +
                                                                    myImageRect.Left, myPaintRect.Top +
                                                                    myItems[0].Padding.Top + myImageRect.Top,
                                                                    myImageRect.Width, myImageRect.Height));
                    }
                    else if (this.ImageList != null && myItems[0].ImageIndex > -1 &&
                               myItems[0].ImageIndex < this.ImageList.Images.Count)
                    {
                        Rectangle myImageRect = GetImageRect(myItems[0], ImageList.Images[myItems[0].ImageIndex],
                                                             iAvailableWidth, iAvailableHeight);
                        this.ImageList.Draw(e, myPaintRect.Left + myItems[0].Padding.Left + myImageRect.Left,
                                            myPaintRect.Top + myItems[0].Padding.Top + myImageRect.Top,
                                            myImageRect.Width, myImageRect.Height, myItems[0].ImageIndex);
                    }
                    #endregion

                    #region draw fromated day text
                    //draw formated day text
                    StringFormat myFormatedDayFormat = new StringFormat();

                    switch (myItems[0].TextAlign)
                    {
                        case ContentAlignment.TopLeft:
                            myFormatedDayFormat.Alignment = StringAlignment.Near;
                            myFormatedDayFormat.LineAlignment = StringAlignment.Near;
                            break;
                        case ContentAlignment.TopCenter:
                            myFormatedDayFormat.Alignment = StringAlignment.Center;
                            myFormatedDayFormat.LineAlignment = StringAlignment.Near;
                            break;
                        case ContentAlignment.TopRight:
                            myFormatedDayFormat.Alignment = StringAlignment.Far;
                            myFormatedDayFormat.LineAlignment = StringAlignment.Near;
                            break;
                        case ContentAlignment.MiddleLeft:
                            myFormatedDayFormat.Alignment = StringAlignment.Near;
                            myFormatedDayFormat.LineAlignment = StringAlignment.Center;
                            break;
                        case ContentAlignment.MiddleCenter:
                            myFormatedDayFormat.Alignment = StringAlignment.Center;
                            myFormatedDayFormat.LineAlignment = StringAlignment.Center;
                            break;
                        case ContentAlignment.MiddleRight:
                            myFormatedDayFormat.Alignment = StringAlignment.Far;
                            myFormatedDayFormat.LineAlignment = StringAlignment.Center;
                            break;
                        case ContentAlignment.BottomLeft:
                            myFormatedDayFormat.Alignment = StringAlignment.Near;
                            myFormatedDayFormat.LineAlignment = StringAlignment.Far;
                            break;
                        case ContentAlignment.BottomCenter:
                            myFormatedDayFormat.Alignment = StringAlignment.Center;
                            myFormatedDayFormat.LineAlignment = StringAlignment.Far;
                            break;
                        case ContentAlignment.BottomRight:
                            myFormatedDayFormat.Alignment = StringAlignment.Far;
                            myFormatedDayFormat.LineAlignment = StringAlignment.Far;
                            break;
                    }
                    e.DrawString(myItems[0].Text, myItems[0].Font, new SolidBrush(myItems[0].ForeColor),
                                 new Rectangle(myPaintRect.Left + myItems[0].Padding.Left,
                                               myPaintRect.Top + myItems[0].Padding.Top,
                                               iAvailableWidth, iAvailableHeight), myFormatedDayFormat);
                    myDayAlign = myItems[0].DayAlign;
                    #endregion
                }

                //seond draw text
                StringFormat myStringFormat = new StringFormat();


                switch (myDayAlign)
                {
                    case ContentAlignment.TopLeft:
                        myStringFormat.Alignment = StringAlignment.Near;
                        myStringFormat.LineAlignment = StringAlignment.Near;
                        break;
                    case ContentAlignment.TopCenter:
                        myStringFormat.Alignment = StringAlignment.Center;
                        myStringFormat.LineAlignment = StringAlignment.Near;
                        break;
                    case ContentAlignment.TopRight:
                        myStringFormat.Alignment = StringAlignment.Far;
                        myStringFormat.LineAlignment = StringAlignment.Near;
                        break;
                    case ContentAlignment.MiddleLeft:
                        myStringFormat.Alignment = StringAlignment.Near;
                        myStringFormat.LineAlignment = StringAlignment.Center;
                        break;
                    case ContentAlignment.MiddleCenter:
                        myStringFormat.Alignment = StringAlignment.Center;
                        myStringFormat.LineAlignment = StringAlignment.Center;
                        break;
                    case ContentAlignment.MiddleRight:
                        myStringFormat.Alignment = StringAlignment.Far;
                        myStringFormat.LineAlignment = StringAlignment.Center;
                        break;
                    case ContentAlignment.BottomLeft:
                        myStringFormat.Alignment = StringAlignment.Near;
                        myStringFormat.LineAlignment = StringAlignment.Far;
                        break;
                    case ContentAlignment.BottomCenter:
                        myStringFormat.Alignment = StringAlignment.Center;
                        myStringFormat.LineAlignment = StringAlignment.Far;
                        break;
                    case ContentAlignment.BottomRight:
                        myStringFormat.Alignment = StringAlignment.Far;
                        myStringFormat.LineAlignment = StringAlignment.Far;
                        break;
                }

                Rectangle myDayTextRect = new Rectangle(myPaintRect.Left + myUsedElementStyle.Padding.Left,
                                                        myPaintRect.Top + myUsedElementStyle.Padding.Top,
                                                        myPaintRect.Width - (myUsedElementStyle.Padding.Left +
                                                        myUsedElementStyle.Padding.Right), myPaintRect.Height -
                                                        (myUsedElementStyle.Padding.Top +
                                                        myUsedElementStyle.Padding.Bottom));

                if (myUsedElementStyle.MarkSunday == true && m_WeekDayItems[CellIndex, RowIndex].WeekDay == DayOfWeek.Sunday)
                {
                    e.DrawString(m_WeekDayItems[CellIndex, RowIndex].Day.ToString(), m_MonthDaysStyle.Font,
                                 new SolidBrush(Color.FromArgb(m_MonthDaysStyle.TextTransparency, myUsedElementStyle.SundayColor)),
                                 myDayTextRect, myStringFormat);

                }
                else if (myUsedElementStyle.MarkSaturday == true && m_WeekDayItems[CellIndex, RowIndex].WeekDay == DayOfWeek.Saturday)
                {
                    e.DrawString(m_WeekDayItems[CellIndex, RowIndex].Day.ToString(), m_MonthDaysStyle.Font,
                                 new SolidBrush(Color.FromArgb(m_MonthDaysStyle.TextTransparency, myUsedElementStyle.SaturdayColor)),
                                 myDayTextRect, myStringFormat);
                }
                else
                {
                    if (bSelectedDay == false)
                    {
                        e.DrawString(m_WeekDayItems[CellIndex, RowIndex].Day.ToString(), myUsedElementStyle.Font,
                                     new SolidBrush(Color.FromArgb(m_MonthDaysStyle.TextTransparency, myUsedElementStyle.ForeColor)),
                                     myDayTextRect, myStringFormat);
                    }
                    else
                    {
                        e.DrawString(m_WeekDayItems[CellIndex, RowIndex].Day.ToString(),
                                     myUsedElementStyle.SelectedDay.Font,
                                     new SolidBrush(myUsedElementStyle.SelectedDay.ForeColor), myDayTextRect,
                                     myStringFormat);
                    }
                }

                //draw border 
                BorderStyle myBorder = myUsedElementStyle.Border;
                if (myItems.Length > 0 && myItems[0].Enabled == true)
                {
                    myBorder = myItems[0].Border;
                }

                //draw an frame around day
                if (bSelectedDay == false)
                {
                    if (myBorder.Visible == true)
                    {
                        e.DrawRectangle(new Pen(Color.FromArgb(myBorder.Transparency, myBorder.BorderColor)),
                                        new Rectangle(myPaintRect.Left, myPaintRect.Top, myPaintRect.Width - 1,
                                        myPaintRect.Height - 1));
                    }
                }
                else
                {
                    if (myUsedElementStyle.SelectedDay.Border.Visible == true)
                    {
                        e.DrawRectangle(new Pen(Color.FromArgb(myUsedElementStyle.SelectedDay.Border.Transparency,
                                        myUsedElementStyle.SelectedDay.Border.BorderColor)),
                                        new Rectangle(myPaintRect.Left, myPaintRect.Top, myPaintRect.Width - 1,
                                        myPaintRect.Height - 1));
                    }
                }


                if (m_WeekDayItems[CellIndex, RowIndex].Day == DateTime.Now.Day &&
                    m_WeekDayItems[CellIndex, RowIndex].Month == DateTime.Now.Month &&
                    m_WeekDayItems[CellIndex, RowIndex].Year == DateTime.Now.Year)
                {
                    if (myUsedElementStyle.MarkToday == true)
                    {
                        //draw an frame around day
                        e.DrawRectangle(new Pen(myUsedElementStyle.TodayColor),
                                        new Rectangle(myPaintRect.Left, myPaintRect.Top, myPaintRect.Width - 1,
                                        myPaintRect.Height - 1));
                    }
                }

                if ((m_SelectionMode == SelectionMode.smMulti && m_bMultipleSelectingModeActive == false) ||
                    m_SelectionMode == SelectionMode.smOne || m_SelectionMode == SelectionMode.smNone)
                {
                    if ((m_bMouseHover == true || this.Focused == true) && myUsedElementStyle.MarkHover == true &&
                        m_MouseSelectedDay.Cell == CellIndex && m_MouseSelectedDay.Row == RowIndex)
                    {
                        System.Diagnostics.Debug.WriteLine("Draw mouse over monthday");
                        //draw filled rectangle over monthday
                        if (myUsedElementStyle.HoverStyle.Background.Style == EStyle.esColor)
                        {
                            SolidBrush myBrush = new SolidBrush(Color.FromArgb(myUsedElementStyle.HoverStyle.Background.TransparencyStartColor,
                                                                myUsedElementStyle.HoverStyle.Background.StartColor));
                            e.FillRectangle(myBrush, myPaintRect);
                        }
                        else if (myUsedElementStyle.HoverStyle.Background.Style == EStyle.esParent)
                        {
                            SolidBrush myBrush = new SolidBrush(this.BackColor);
                            e.FillRectangle(myBrush, myPaintRect);
                        }
                        else if (myUsedElementStyle.HoverStyle.Background.Style == EStyle.esGradient)
                        {
                            LinearGradientMode myMode;
                            if (myUsedElementStyle.HoverStyle.Background.Gradient == GradientStyle.Vertical)
                                myMode = LinearGradientMode.Vertical;
                            else if (myUsedElementStyle.HoverStyle.Background.Gradient == GradientStyle.Horizontal)
                                myMode = LinearGradientMode.Horizontal;
                            else if (myUsedElementStyle.HoverStyle.Background.Gradient == GradientStyle.ForwardDiagonal)
                                myMode = LinearGradientMode.ForwardDiagonal;
                            else
                                myMode = LinearGradientMode.BackwardDiagonal;

                            LinearGradientBrush myGBrush = new LinearGradientBrush(myPaintRect, Color.FromArgb(
                                                                                   myUsedElementStyle.HoverStyle.Background.TransparencyStartColor,
                                                                                   myUsedElementStyle.HoverStyle.Background.StartColor),
                                                                                   Color.FromArgb(myUsedElementStyle.HoverStyle.Background.TransparencyEndColor,
                                                                                   myUsedElementStyle.HoverStyle.Background.EndColor), myMode);
                            e.FillRectangle(myGBrush, myPaintRect);
                        }
                        //draw border
                        if (myUsedElementStyle.HoverStyle.Border.Visible == true)
                        {
                            e.DrawRectangle(new Pen(Color.FromArgb(myUsedElementStyle.HoverStyle.Border.Transparency,
                                            myUsedElementStyle.HoverStyle.Border.BorderColor)),
                                            new Rectangle(myPaintRect.Left, myPaintRect.Top, myPaintRect.Width - 1,
                                            myPaintRect.Height - 1));

                        }
                    }

                }
            }
        }

        private void DrawTrailingDay(Graphics e, int CellIndex, int RowIndex)
        {

            if (m_WeekDayItems[CellIndex, RowIndex].Year < 9999 | m_WeekDayItems[CellIndex, RowIndex].Year > 1752)
            {
                int iLeftWidthOffset = 0;
                int iWidthOffset = 0;
                //get needed leftwidthoffset to compensate space between all monthdays an controlwidth
                if (m_MonthDayWidthOffset > 0 && CellIndex < m_MonthDayWidthOffset)
                {
                    iLeftWidthOffset = CellIndex * 1;
                }
                else
                {
                    int iTmpWidthOffset = m_MonthDayWidthOffset - 1;
                    if (iTmpWidthOffset < 0) iTmpWidthOffset = 0;
                    iLeftWidthOffset = iTmpWidthOffset * 1;
                }
                if (m_MonthDayWidthOffset > 0 && CellIndex < m_MonthDayWidthOffset - 1)
                {
                    iWidthOffset = 1;
                }

                //the same for height
                int iTopHeightOffset = 0;
                int iHeightOffset = 0;
                if (m_MonthDayHeightOffset > 0 && RowIndex < m_MonthDayHeightOffset)
                {
                    iTopHeightOffset = RowIndex;
                }
                else
                {
                    int iTempOffset = m_MonthDayHeightOffset - 1;
                    if (iTempOffset < 0) iTempOffset = 0;
                    iTopHeightOffset = iTempOffset;
                }
                if (m_MonthDayHeightOffset > 0 && RowIndex < m_MonthDayHeightOffset - 1)
                {
                    iHeightOffset = 1;
                }
                //get the left weekday pos
                int iLeftPos = (CellIndex) * (m_WeekDayWidth + m_MonthDaysStyle.DaysPadding.Horizontal);
                //get top weekday pos
                int iTopPos = (RowIndex) * m_WeekDayHeight;
                //paintrect
                Rectangle myPaintRect = new Rectangle(GetWeekNumbersWidth() + iLeftPos + iLeftWidthOffset +
                                                      m_MonthDaysStyle.DaysPadding.Horizontal,
                                                      m_NextTopPos + 1 + iTopHeightOffset,
                                                      m_WeekDayWidth + iWidthOffset, m_WeekDayHeight
                                                      + iHeightOffset);
                //ownerdraw
                MonthDayRenderEventArgs myRenderEventArgs = new MonthDayRenderEventArgs(e, myPaintRect,
                                                                        m_WeekDayItems[CellIndex, RowIndex].WeekDay,
                                                                        m_WeekDayItems[CellIndex, RowIndex].Day, true);
                if (MonthDayRender != null) MonthDayRender(this, myRenderEventArgs);
                if (myRenderEventArgs.OwnerDraw == false)
                {
                    //first draw background
                    if (m_MonthDaysStyle.TrailingDays.Background.Style == EStyle.esColor)
                    {
                        SolidBrush myBrush = new SolidBrush(Color.FromArgb(m_MonthDaysStyle.TrailingDays.Background.TransparencyStartColor,
                                                            m_MonthDaysStyle.TrailingDays.Background.StartColor));
                        e.FillRectangle(myBrush, myPaintRect);
                    }
                    else if (m_MonthDaysStyle.TrailingDays.Background.Style == EStyle.esParent)
                    {
                        SolidBrush myBrush = new SolidBrush(this.BackColor);
                        e.FillRectangle(myBrush, myPaintRect);
                    }
                    else if (m_MonthDaysStyle.TrailingDays.Background.Style == EStyle.esGradient)
                    {
                        LinearGradientMode myMode;
                        if (m_MonthDaysStyle.TrailingDays.Background.Gradient == GradientStyle.Vertical)
                            myMode = LinearGradientMode.Vertical;
                        else if (m_MonthDaysStyle.TrailingDays.Background.Gradient == GradientStyle.Horizontal)
                            myMode = LinearGradientMode.Horizontal;
                        else if (m_MonthDaysStyle.TrailingDays.Background.Gradient == GradientStyle.ForwardDiagonal)
                            myMode = LinearGradientMode.ForwardDiagonal;
                        else
                            myMode = LinearGradientMode.BackwardDiagonal;

                        LinearGradientBrush myGBrush = new LinearGradientBrush(myPaintRect, Color.FromArgb(
                                                                               m_MonthDaysStyle.TrailingDays.Background.TransparencyStartColor,
                                                                               m_MonthDaysStyle.TrailingDays.Background.StartColor),
                                                                               Color.FromArgb(m_MonthDaysStyle.TrailingDays.Background.TransparencyEndColor,
                                                                               m_MonthDaysStyle.TrailingDays.Background.EndColor), myMode);
                    }

                    //seond draw text
                    StringFormat myStringFormat = new StringFormat();
                    switch (m_MonthDaysStyle.Align)
                    {
                        case ContentAlignment.TopLeft:
                            myStringFormat.Alignment = StringAlignment.Near;
                            myStringFormat.LineAlignment = StringAlignment.Near;
                            break;
                        case ContentAlignment.TopCenter:
                            myStringFormat.Alignment = StringAlignment.Center;
                            myStringFormat.LineAlignment = StringAlignment.Near;
                            break;
                        case ContentAlignment.TopRight:
                            myStringFormat.Alignment = StringAlignment.Far;
                            myStringFormat.LineAlignment = StringAlignment.Near;
                            break;
                        case ContentAlignment.MiddleLeft:
                            myStringFormat.Alignment = StringAlignment.Near;
                            myStringFormat.LineAlignment = StringAlignment.Center;
                            break;
                        case ContentAlignment.MiddleCenter:
                            myStringFormat.Alignment = StringAlignment.Center;
                            myStringFormat.LineAlignment = StringAlignment.Center;
                            break;
                        case ContentAlignment.MiddleRight:
                            myStringFormat.Alignment = StringAlignment.Far;
                            myStringFormat.LineAlignment = StringAlignment.Center;
                            break;
                        case ContentAlignment.BottomLeft:
                            myStringFormat.Alignment = StringAlignment.Near;
                            myStringFormat.LineAlignment = StringAlignment.Far;
                            break;
                        case ContentAlignment.BottomCenter:
                            myStringFormat.Alignment = StringAlignment.Center;
                            myStringFormat.LineAlignment = StringAlignment.Far;
                            break;
                        case ContentAlignment.BottomRight:
                            myStringFormat.Alignment = StringAlignment.Far;
                            myStringFormat.LineAlignment = StringAlignment.Far;
                            break;
                    }

                    //draw trailing text
                    e.DrawString(m_WeekDayItems[CellIndex, RowIndex].Day.ToString(), m_MonthDaysStyle.TrailingDays.Font,
                                 new SolidBrush(Color.FromArgb(m_MonthDaysStyle.TextTransparency,
                                 m_MonthDaysStyle.TrailingDays.ForeColor)), new Rectangle(myPaintRect.Left +
                                 m_MonthDaysStyle.Padding.Left, myPaintRect.Top + m_MonthDaysStyle.Padding.Top,
                                 myPaintRect.Width - (m_MonthDaysStyle.Padding.Left + m_MonthDaysStyle.Padding.Right),
                                 myPaintRect.Height - (m_MonthDaysStyle.Padding.Top + m_MonthDaysStyle.Padding.Bottom)),
                                 myStringFormat);

                    //draw border 
                    if (m_MonthDaysStyle.TrailingDays.Border.Visible == true)
                    {
                        //draw an frame around day
                        e.DrawRectangle(new Pen(Color.FromArgb(m_MonthDaysStyle.TrailingDays.Border.Transparency,
                                        m_MonthDaysStyle.TrailingDays.Border.BorderColor)),
                                        new Rectangle(myPaintRect.Left, myPaintRect.Top, myPaintRect.Width - 1,
                                        myPaintRect.Height - 1));
                    }

                    if ((m_SelectionMode == SelectionMode.smMulti && m_bMultipleSelectingModeActive == false) ||
                    m_SelectionMode == SelectionMode.smOne || m_SelectionMode == SelectionMode.smNone)
                    {
                        if (m_bCanSelectTrailingDates == true)
                        {
                            if ((m_bMouseHover == true || this.Focused == true) && m_MonthDaysStyle.MarkHover == true &&
                                m_MouseSelectedDay.Cell == CellIndex && m_MouseSelectedDay.Row == RowIndex)
                            {
                                System.Diagnostics.Debug.WriteLine("Draw mouse over monthday");
                                //draw filled rectangle over monthday
                                if (m_MonthDaysStyle.HoverStyle.Background.Style == EStyle.esColor)
                                {
                                    SolidBrush myBrush = new SolidBrush(Color.FromArgb(m_MonthDaysStyle.HoverStyle.Background.TransparencyStartColor,
                                                                        m_MonthDaysStyle.HoverStyle.Background.StartColor));
                                    e.FillRectangle(myBrush, myPaintRect);
                                }
                                else if (m_MonthDaysStyle.HoverStyle.Background.Style == EStyle.esParent)
                                {
                                    SolidBrush myBrush = new SolidBrush(this.BackColor);
                                    e.FillRectangle(myBrush, myPaintRect);
                                }
                                else if (m_MonthDaysStyle.HoverStyle.Background.Style == EStyle.esGradient)
                                {
                                    LinearGradientMode myMode;
                                    if (m_MonthDaysStyle.HoverStyle.Background.Gradient == GradientStyle.Vertical)
                                        myMode = LinearGradientMode.Vertical;
                                    else if (m_MonthDaysStyle.HoverStyle.Background.Gradient == GradientStyle.Horizontal)
                                        myMode = LinearGradientMode.Horizontal;
                                    else if (m_MonthDaysStyle.HoverStyle.Background.Gradient == GradientStyle.ForwardDiagonal)
                                        myMode = LinearGradientMode.ForwardDiagonal;
                                    else
                                        myMode = LinearGradientMode.BackwardDiagonal;

                                    LinearGradientBrush myGBrush = new LinearGradientBrush(myPaintRect, Color.FromArgb(
                                                                                           m_MonthDaysStyle.HoverStyle.Background.TransparencyStartColor,
                                                                                           m_MonthDaysStyle.HoverStyle.Background.StartColor),
                                                                                           Color.FromArgb(m_MonthDaysStyle.HoverStyle.Background.TransparencyEndColor,
                                                                                           m_MonthDaysStyle.HoverStyle.Background.EndColor), myMode);
                                }
                                //draw border
                                if (m_MonthDaysStyle.HoverStyle.Border.Visible == true)
                                {
                                    e.DrawRectangle(new Pen(Color.FromArgb(m_MonthDaysStyle.HoverStyle.Border.Transparency,
                                                    m_MonthDaysStyle.HoverStyle.Border.BorderColor)),
                                                    new Rectangle(myPaintRect.Left, myPaintRect.Top, myPaintRect.Width - 1,
                                                    myPaintRect.Height - 1));

                                }
                            }
                        }
                    }
                }
            }
        }

        private void DrawFooter(Graphics e)
        {
            if (m_Footer.Visible == true)
            {
                int iTopPos = GetMonthImageHeight() + GetTitleBarHeight() + GetWeekDaysHeight() +
                              (6 * m_WeekDayHeight) + (7 * m_MonthDaysStyle.DaysPadding.Vertical) +
                              m_MonthDayHeightOffset + 1;

                Rectangle myFootRect = new Rectangle(0, iTopPos, this.Width, this.Height -
                                                     m_NextTopPos - 2);

                FooterRenderEventArgs myRenderEvent = new FooterRenderEventArgs(e, myFootRect, new DateTime(
                                                                                DateTime.Now.Year,
                                                                                DateTime.Now.Month,
                                                                                DateTime.Now.Day));
                if (FooterRender != null) FooterRender(this, myRenderEvent);
                if (myRenderEvent.OwnerDraw == false)
                {

                    StringFormat myStringFormat = new StringFormat();
                    myStringFormat.LineAlignment = StringAlignment.Near;
                    switch (m_Footer.Align)
                    {
                        case HeaderAlign.Left:
                            myStringFormat.Alignment = StringAlignment.Near;
                            break;
                        case HeaderAlign.Center:
                            myStringFormat.Alignment = StringAlignment.Center;
                            break;
                        case HeaderAlign.Right:
                            myStringFormat.Alignment = StringAlignment.Far;
                            break;
                    }


                    //draw background
                    switch (m_Footer.Background.Style)
                    {
                        case EStyle.esColor:
                            SolidBrush myBrush = new SolidBrush(Color.FromArgb(m_Footer.Background.TransparencyStartColor,
                                                                m_Footer.Background.StartColor));
                            e.FillRectangle(myBrush, myFootRect);
                            break;
                        case EStyle.esParent:
                            SolidBrush myBrush2 = new SolidBrush(this.BackColor);
                            e.FillRectangle(myBrush2, myFootRect);
                            break;
                        case EStyle.esGradient:
                            LinearGradientMode myMode;
                            if (m_Footer.Background.Gradient == GradientStyle.Vertical)
                                myMode = LinearGradientMode.Vertical;
                            else if (m_Footer.Background.Gradient == GradientStyle.Horizontal)
                                myMode = LinearGradientMode.Horizontal;
                            else if (m_Footer.Background.Gradient == GradientStyle.ForwardDiagonal)
                                myMode = LinearGradientMode.ForwardDiagonal;
                            else
                                myMode = LinearGradientMode.BackwardDiagonal;

                            LinearGradientBrush myGBrush = new LinearGradientBrush(myFootRect, Color.FromArgb(
                                                                                   m_Footer.Background.TransparencyStartColor,
                                                                                   m_Footer.Background.StartColor),
                                                                                   Color.FromArgb(
                                                                                   m_Footer.Background.TransparencyEndColor,
                                                                                   m_Footer.Background.EndColor),
                                                                                   myMode);
                            e.FillRectangle(myGBrush, myFootRect);

                            break;
                    }
                    //draw border
                    if (m_Footer.Border.Visible == true)
                    {
                        e.DrawRectangle(new Pen(Color.FromArgb(m_Footer.Border.Transparency,
                                        m_Footer.Border.BorderColor)),
                                        new Rectangle(myFootRect.Left, myFootRect.Top, myFootRect.Width - 1,
                                        myFootRect.Height - 1));

                    }

                    Rectangle myTextRect = new Rectangle(myFootRect.Left + m_Footer.Padding.Left,
                                                         (iTopPos - 1) + m_Footer.Padding.Top,
                                                         myFootRect.Width - (m_Footer.Padding.Left +
                                                         m_Footer.Padding.Right), m_Footer.Font.Height);
                    //get drawing string
                    string sTmp = m_Footer.Text;
                    if (m_Footer.DateFormat == DateFormat.Long)
                        sTmp += " " + DateTime.Now.ToLongDateString();
                    else
                        sTmp += " " + DateTime.Now.ToShortDateString();

                    e.DrawString(sTmp, m_Footer.Font, new SolidBrush(Color.FromArgb(m_Footer.TextTransparency,
                                 m_Footer.ForeColor)), myTextRect, myStringFormat);
                }
            }
        }

        private void DrawYear(Graphics e)
        {
            //draw twelf months
            m_MonthWidth = (int)(this.Width - 8 - (5 * m_MonthDaysStyle.DaysPadding.Horizontal)) / 4;
            m_MonthHeight = (int)(this.Height - 8 - m_NextTopPos - (4 * m_MonthDaysStyle.DaysPadding.Vertical)) / 3;
            m_WeekDaysLeftStartPos = 4 + m_MonthDaysStyle.DaysPadding.Horizontal;
            m_WeekDaysTopStartPos = m_NextTopPos + 4 + m_MonthDaysStyle.DaysPadding.Vertical;
            int iMonthIndex = 0;
            string sShortMonthName = "";
            for (int iRowCounter = 0; iRowCounter < 3; iRowCounter++)
            {
                for (int iCellCounter = 0; iCellCounter < 4; iCellCounter++)
                {
                    iMonthIndex = (iRowCounter * 4) + (iCellCounter + 1);
                    sShortMonthName = m_DateTimeFormatInfo.AbbreviatedMonthNames[iMonthIndex-1];

                    //draw month
                    DrawMonth(e, iRowCounter, iCellCounter, sShortMonthName);
                }
            }
        }

        private void DrawMonth(Graphics e, int Row, int Cell, string Name)
        {
            bool bSelectedDay = false;
            Rectangle myPaintRect = new Rectangle(4 + (Cell * (m_MonthWidth + 
                                                  m_MonthDaysStyle.DaysPadding.Horizontal)) +
                                                  m_MonthDaysStyle.DaysPadding.Horizontal, 
                                                  m_NextTopPos + 4 + (Row * (m_MonthHeight + 
                                                  m_MonthDaysStyle.DaysPadding.Vertical)) +
                                                  m_MonthDaysStyle.DaysPadding.Vertical,
                                                  m_MonthWidth, m_MonthHeight);
            int iCurrentMonth = (Row * 4) + (Cell + 1);
            //ownerdraw
            MonthRenderEventArgs myRenderEvent = new MonthRenderEventArgs(e, myPaintRect, iCurrentMonth.ToString());
            if (MonthRender != null) MonthRender(this, myRenderEvent);
            if (myRenderEvent.OwnerDraw == false)
            {
                //normal draw monthitem
                MonthDaysElementStyle myUsedElementStyle = m_MonthDaysStyle;
                if (iCurrentMonth == m_SelectedDate.Month)
                {
                    if (m_MonthDaysStyle.MarkSelectedDay == true)
                    {
                        bSelectedDay = true;
                    }
                }

                if (bSelectedDay == false)
                {
                    switch (myUsedElementStyle.Background.Style)
                    {
                        case EStyle.esColor:
                            SolidBrush myBrush = new SolidBrush(Color.FromArgb(myUsedElementStyle.Background.TransparencyStartColor,
                                                                myUsedElementStyle.Background.StartColor));
                            e.FillRectangle(myBrush, myPaintRect);
                            break;
                        case EStyle.esParent:
                            SolidBrush myBrush2 = new SolidBrush(this.BackColor);
                            e.FillRectangle(myBrush2, myPaintRect);
                            break;
                        case EStyle.esGradient:
                            LinearGradientMode myMode;
                            if (myUsedElementStyle.Background.Gradient == GradientStyle.Vertical)
                                myMode = LinearGradientMode.Vertical;
                            else if (myUsedElementStyle.Background.Gradient == GradientStyle.Horizontal)
                                myMode = LinearGradientMode.Horizontal;
                            else if (myUsedElementStyle.Background.Gradient == GradientStyle.ForwardDiagonal)
                                myMode = LinearGradientMode.ForwardDiagonal;
                            else
                                myMode = LinearGradientMode.BackwardDiagonal;

                            LinearGradientBrush myGBrush = new LinearGradientBrush(myPaintRect, Color.FromArgb(
                                                                                   myUsedElementStyle.Background.TransparencyStartColor,
                                                                                   myUsedElementStyle.Background.StartColor),
                                                                                   Color.FromArgb(
                                                                                   myUsedElementStyle.Background.TransparencyEndColor,
                                                                                   myUsedElementStyle.Background.EndColor),
                                                                                   myMode);
                            e.FillRectangle(myGBrush, myPaintRect);

                            break;
                    }
                }
                else
                {
                    //draw selected month
                    switch (myUsedElementStyle.SelectedDay.Background.Style)
                    {
                        case EStyle.esColor:
                            SolidBrush myBrush = new SolidBrush(Color.FromArgb(myUsedElementStyle.SelectedDay.Background.TransparencyStartColor,
                                                                myUsedElementStyle.SelectedDay.Background.StartColor));
                            e.FillRectangle(myBrush, myPaintRect);
                            break;
                        case EStyle.esParent:
                            SolidBrush myBrush2 = new SolidBrush(this.BackColor);
                            e.FillRectangle(myBrush2, myPaintRect);
                            break;
                        case EStyle.esGradient:
                            LinearGradientMode myMode;
                            if (myUsedElementStyle.SelectedDay.Background.Gradient == GradientStyle.Vertical)
                                myMode = LinearGradientMode.Vertical;
                            else if (myUsedElementStyle.SelectedDay.Background.Gradient == GradientStyle.Horizontal)
                                myMode = LinearGradientMode.Horizontal;
                            else if (myUsedElementStyle.SelectedDay.Background.Gradient == GradientStyle.ForwardDiagonal)
                                myMode = LinearGradientMode.ForwardDiagonal;
                            else
                                myMode = LinearGradientMode.BackwardDiagonal;

                            LinearGradientBrush myGBrush = new LinearGradientBrush(myPaintRect, Color.FromArgb(
                                                                                   myUsedElementStyle.SelectedDay.Background.TransparencyStartColor,
                                                                                   myUsedElementStyle.SelectedDay.Background.StartColor),
                                                                                   Color.FromArgb(
                                                                                   myUsedElementStyle.SelectedDay.Background.TransparencyEndColor,
                                                                                   myUsedElementStyle.SelectedDay.Background.EndColor),
                                                                                   myMode);
                            e.FillRectangle(myGBrush, myPaintRect);

                            break;
                    }
                }
                //draw text
                //seond draw text
                StringFormat myStringFormat = new StringFormat();
                switch (myUsedElementStyle.Align)
                {
                    case ContentAlignment.TopLeft:
                        myStringFormat.Alignment = StringAlignment.Near;
                        myStringFormat.LineAlignment = StringAlignment.Near;
                        break;
                    case ContentAlignment.TopCenter:
                        myStringFormat.Alignment = StringAlignment.Center;
                        myStringFormat.LineAlignment = StringAlignment.Near;
                        break;
                    case ContentAlignment.TopRight:
                        myStringFormat.Alignment = StringAlignment.Far;
                        myStringFormat.LineAlignment = StringAlignment.Near;
                        break;
                    case ContentAlignment.MiddleLeft:
                        myStringFormat.Alignment = StringAlignment.Near;
                        myStringFormat.LineAlignment = StringAlignment.Center;
                        break;
                    case ContentAlignment.MiddleCenter:
                        myStringFormat.Alignment = StringAlignment.Center;
                        myStringFormat.LineAlignment = StringAlignment.Center;
                        break;
                    case ContentAlignment.MiddleRight:
                        myStringFormat.Alignment = StringAlignment.Far;
                        myStringFormat.LineAlignment = StringAlignment.Center;
                        break;
                    case ContentAlignment.BottomLeft:
                        myStringFormat.Alignment = StringAlignment.Near;
                        myStringFormat.LineAlignment = StringAlignment.Far;
                        break;
                    case ContentAlignment.BottomCenter:
                        myStringFormat.Alignment = StringAlignment.Center;
                        myStringFormat.LineAlignment = StringAlignment.Far;
                        break;
                    case ContentAlignment.BottomRight:
                        myStringFormat.Alignment = StringAlignment.Far;
                        myStringFormat.LineAlignment = StringAlignment.Far;
                        break;
                }

                if (bSelectedDay == false)
                {
                    e.DrawString(Name, myUsedElementStyle.Font, new SolidBrush(Color.FromArgb(myUsedElementStyle.TextTransparency,
                                 myUsedElementStyle.ForeColor)), myPaintRect, myStringFormat);
                }
                else
                {
                    e.DrawString(Name, myUsedElementStyle.SelectedDay.Font,
                                 new SolidBrush(myUsedElementStyle.SelectedDay.ForeColor),
                                 myPaintRect, myStringFormat);
                }

                //draw border 
                if (bSelectedDay == false)
                {
                    if (myUsedElementStyle.Border.Visible == true)
                    {
                        //draw an frame around day
                        e.DrawRectangle(new Pen(Color.FromArgb(myUsedElementStyle.Border.Transparency, myUsedElementStyle.Border.BorderColor)),
                                        new Rectangle(myPaintRect.Left, myPaintRect.Top, myPaintRect.Width - 1,
                                        myPaintRect.Height - 1));
                    }
                }
                else
                {
                    //
                    if (myUsedElementStyle.SelectedDay.Border.Visible == true)
                    {
                        //draw an frame around day
                        e.DrawRectangle(new Pen(Color.FromArgb(myUsedElementStyle.SelectedDay.Border.Transparency,
                                        myUsedElementStyle.SelectedDay.Border.BorderColor)),
                                        new Rectangle(myPaintRect.Left, myPaintRect.Top, myPaintRect.Width - 1,
                                        myPaintRect.Height - 1));
                    }
                }

                if (m_SelectedDate.Year == DateTime.Now.Year &&
                    iCurrentMonth == DateTime.Now.Month)
                {
                    if (myUsedElementStyle.MarkToday == true)
                    {
                        //draw an frame around day
                        e.DrawRectangle(new Pen(myUsedElementStyle.TodayColor),
                                        new Rectangle(myPaintRect.Left, myPaintRect.Top, myPaintRect.Width - 1,
                                        myPaintRect.Height - 1));
                    }
                }

                System.Diagnostics.Debug.WriteLine("Draw month at cell: " + Cell.ToString() + " and row: " + Row.ToString());
                System.Diagnostics.Debug.WriteLine("Mouse is over cell: " + m_MouseSelectedDay.Cell.ToString() +
                                                   " and row: " + m_MouseSelectedDay.Row.ToString());
                if (m_bMouseHover == true && m_MonthDaysStyle.MarkHover == true &&
                    m_MouseSelectedDay.Cell == Cell && m_MouseSelectedDay.Row == Row)
                {
                    System.Diagnostics.Debug.WriteLine("Draw mouse over monthday");
                    //draw filled rectangle over monthday
                    if (m_MonthDaysStyle.HoverStyle.Background.Style == EStyle.esColor)
                    {
                        SolidBrush myBrush = new SolidBrush(Color.FromArgb(m_MonthDaysStyle.HoverStyle.Background.TransparencyStartColor,
                                                            m_MonthDaysStyle.HoverStyle.Background.StartColor));
                        e.FillRectangle(myBrush, myPaintRect);
                    }
                    else if (m_MonthDaysStyle.HoverStyle.Background.Style == EStyle.esParent)
                    {
                        SolidBrush myBrush = new SolidBrush(this.BackColor);
                        e.FillRectangle(myBrush, myPaintRect);
                    }
                    else if (m_MonthDaysStyle.HoverStyle.Background.Style == EStyle.esGradient)
                    {
                        LinearGradientMode myMode;
                        if (m_MonthDaysStyle.HoverStyle.Background.Gradient == GradientStyle.Vertical)
                            myMode = LinearGradientMode.Vertical;
                        else if (m_MonthDaysStyle.HoverStyle.Background.Gradient == GradientStyle.Horizontal)
                            myMode = LinearGradientMode.Horizontal;
                        else if (m_MonthDaysStyle.HoverStyle.Background.Gradient == GradientStyle.ForwardDiagonal)
                            myMode = LinearGradientMode.ForwardDiagonal;
                        else
                            myMode = LinearGradientMode.BackwardDiagonal;

                        LinearGradientBrush myGBrush = new LinearGradientBrush(myPaintRect, Color.FromArgb(
                                                                               m_MonthDaysStyle.HoverStyle.Background.TransparencyStartColor,
                                                                               m_MonthDaysStyle.HoverStyle.Background.StartColor),
                                                                               Color.FromArgb(m_MonthDaysStyle.HoverStyle.Background.TransparencyEndColor,
                                                                               m_MonthDaysStyle.HoverStyle.Background.EndColor), myMode);
                    }
                    //draw border

                }
            }
        }

        private void Draw12YearsRange(Graphics e)
        {
            m_MonthWidth = (int)(this.Width - 8 - (5 * m_MonthDaysStyle.DaysPadding.Horizontal)) / 4;
            m_MonthHeight = (int)(this.Height - 8 - m_NextTopPos - (4 * m_MonthDaysStyle.DaysPadding.Vertical)) / 3;
            m_WeekDaysLeftStartPos = 4;
            m_WeekDaysTopStartPos = m_NextTopPos + 4;
            for (int iRowCounter = 0; iRowCounter < 3; iRowCounter++)
            {
                for (int iCellCounter = 0; iCellCounter < 4; iCellCounter++)
                {
                    //draw years range
                    DrawYear(e, iRowCounter, iCellCounter);
                }
            }
        }

        private void DrawYear(Graphics e, int Row, int Cell)
        {
            bool bSelectedDay = false;
            //draw year
            int iViewedYear = m_Start12YearsRange + (Row * 4) + Cell;
            Rectangle myPaintRect = new Rectangle(4 + (Cell * (m_MonthWidth +
                                      m_MonthDaysStyle.DaysPadding.Horizontal)) +
                                      m_MonthDaysStyle.DaysPadding.Horizontal,
                                      m_NextTopPos + 4 + (Row * (m_MonthHeight +
                                      m_MonthDaysStyle.DaysPadding.Vertical)) +
                                      m_MonthDaysStyle.DaysPadding.Vertical,
                                      m_MonthWidth, m_MonthHeight);

            //ownerdraw
            YearRenderEventArgs myRenderEvent = new YearRenderEventArgs(e, myPaintRect, iViewedYear.ToString());
            if (YearRender != null) YearRender(this, myRenderEvent);
            if (myRenderEvent.OwnerDraw == false)
            {
                MonthDaysElementStyle myUsedElementStyle = m_MonthDaysStyle;
                if (iViewedYear == m_SelectedDate.Year)
                {
                    if (m_MonthDaysStyle.MarkSelectedDay == true)
                    {
                        bSelectedDay = true;
                    }
                }

                if (bSelectedDay == false)
                {
                    switch (myUsedElementStyle.Background.Style)
                    {
                        case EStyle.esColor:
                            SolidBrush myBrush = new SolidBrush(Color.FromArgb(myUsedElementStyle.Background.TransparencyStartColor,
                                                                myUsedElementStyle.Background.StartColor));
                            e.FillRectangle(myBrush, myPaintRect);
                            break;
                        case EStyle.esParent:
                            SolidBrush myBrush2 = new SolidBrush(this.BackColor);
                            e.FillRectangle(myBrush2, myPaintRect);
                            break;
                        case EStyle.esGradient:
                            LinearGradientMode myMode;
                            if (myUsedElementStyle.Background.Gradient == GradientStyle.Vertical)
                                myMode = LinearGradientMode.Vertical;
                            else if (myUsedElementStyle.Background.Gradient == GradientStyle.Horizontal)
                                myMode = LinearGradientMode.Horizontal;
                            else if (myUsedElementStyle.Background.Gradient == GradientStyle.ForwardDiagonal)
                                myMode = LinearGradientMode.ForwardDiagonal;
                            else
                                myMode = LinearGradientMode.BackwardDiagonal;

                            LinearGradientBrush myGBrush = new LinearGradientBrush(myPaintRect, Color.FromArgb(
                                                                                   myUsedElementStyle.Background.TransparencyStartColor,
                                                                                   myUsedElementStyle.Background.StartColor),
                                                                                   Color.FromArgb(
                                                                                   myUsedElementStyle.Background.TransparencyEndColor,
                                                                                   myUsedElementStyle.Background.EndColor),
                                                                                   myMode);
                            e.FillRectangle(myGBrush, myPaintRect);

                            break;
                    }
                }
                else
                {
                    //draw selected day
                    switch (myUsedElementStyle.SelectedDay.Background.Style)
                    {
                        case EStyle.esColor:
                            SolidBrush myBrush = new SolidBrush(Color.FromArgb(myUsedElementStyle.SelectedDay.Background.TransparencyStartColor,
                                                                myUsedElementStyle.SelectedDay.Background.StartColor));
                            e.FillRectangle(myBrush, myPaintRect);
                            break;
                        case EStyle.esParent:
                            SolidBrush myBrush2 = new SolidBrush(this.BackColor);
                            e.FillRectangle(myBrush2, myPaintRect);
                            break;
                        case EStyle.esGradient:
                            LinearGradientMode myMode;
                            if (myUsedElementStyle.SelectedDay.Background.Gradient == GradientStyle.Vertical)
                                myMode = LinearGradientMode.Vertical;
                            else if (myUsedElementStyle.SelectedDay.Background.Gradient == GradientStyle.Horizontal)
                                myMode = LinearGradientMode.Horizontal;
                            else if (myUsedElementStyle.SelectedDay.Background.Gradient == GradientStyle.ForwardDiagonal)
                                myMode = LinearGradientMode.ForwardDiagonal;
                            else
                                myMode = LinearGradientMode.BackwardDiagonal;

                            LinearGradientBrush myGBrush = new LinearGradientBrush(myPaintRect, Color.FromArgb(
                                                                                   myUsedElementStyle.SelectedDay.Background.TransparencyStartColor,
                                                                                   myUsedElementStyle.SelectedDay.Background.StartColor),
                                                                                   Color.FromArgb(
                                                                                   myUsedElementStyle.SelectedDay.Background.TransparencyEndColor,
                                                                                   myUsedElementStyle.SelectedDay.Background.EndColor),
                                                                                   myMode);
                            e.FillRectangle(myGBrush, myPaintRect);

                            break;
                    }
                }
                //draw text
                //seond draw text
                StringFormat myStringFormat = new StringFormat();
                switch (myUsedElementStyle.Align)
                {
                    case ContentAlignment.TopLeft:
                        myStringFormat.Alignment = StringAlignment.Near;
                        myStringFormat.LineAlignment = StringAlignment.Near;
                        break;
                    case ContentAlignment.TopCenter:
                        myStringFormat.Alignment = StringAlignment.Center;
                        myStringFormat.LineAlignment = StringAlignment.Near;
                        break;
                    case ContentAlignment.TopRight:
                        myStringFormat.Alignment = StringAlignment.Far;
                        myStringFormat.LineAlignment = StringAlignment.Near;
                        break;
                    case ContentAlignment.MiddleLeft:
                        myStringFormat.Alignment = StringAlignment.Near;
                        myStringFormat.LineAlignment = StringAlignment.Center;
                        break;
                    case ContentAlignment.MiddleCenter:
                        myStringFormat.Alignment = StringAlignment.Center;
                        myStringFormat.LineAlignment = StringAlignment.Center;
                        break;
                    case ContentAlignment.MiddleRight:
                        myStringFormat.Alignment = StringAlignment.Far;
                        myStringFormat.LineAlignment = StringAlignment.Center;
                        break;
                    case ContentAlignment.BottomLeft:
                        myStringFormat.Alignment = StringAlignment.Near;
                        myStringFormat.LineAlignment = StringAlignment.Far;
                        break;
                    case ContentAlignment.BottomCenter:
                        myStringFormat.Alignment = StringAlignment.Center;
                        myStringFormat.LineAlignment = StringAlignment.Far;
                        break;
                    case ContentAlignment.BottomRight:
                        myStringFormat.Alignment = StringAlignment.Far;
                        myStringFormat.LineAlignment = StringAlignment.Far;
                        break;
                }
                if (bSelectedDay == false)
                {
                    e.DrawString(iViewedYear.ToString(), myUsedElementStyle.Font,
                                 new SolidBrush(Color.FromArgb(myUsedElementStyle.TextTransparency, myUsedElementStyle.ForeColor)),
                                 myPaintRect, myStringFormat);
                }
                else
                {
                    e.DrawString(iViewedYear.ToString(), myUsedElementStyle.SelectedDay.Font,
                                 new SolidBrush(myUsedElementStyle.SelectedDay.ForeColor),
                                 myPaintRect, myStringFormat);
                }
                //draw border 
                if (bSelectedDay == false)
                {
                    if (myUsedElementStyle.Border.Visible == true)
                    {
                        //draw an frame around day
                        e.DrawRectangle(new Pen(Color.FromArgb(myUsedElementStyle.Border.Transparency, myUsedElementStyle.Border.BorderColor)),
                                        new Rectangle(myPaintRect.Left, myPaintRect.Top, myPaintRect.Width - 1,
                                        myPaintRect.Height - 1));
                    }
                }
                else
                {
                    if (myUsedElementStyle.SelectedDay.Border.Visible == true)
                    {
                        //draw an frame around day
                        e.DrawRectangle(new Pen(Color.FromArgb(myUsedElementStyle.SelectedDay.Border.Transparency,
                                        myUsedElementStyle.SelectedDay.Border.BorderColor)),
                                        new Rectangle(myPaintRect.Left, myPaintRect.Top, myPaintRect.Width - 1,
                                        myPaintRect.Height - 1));
                    }
                }

                if (iViewedYear == DateTime.Now.Year)
                {
                    if (myUsedElementStyle.MarkToday == true)
                    {
                        //draw an frame around day
                        e.DrawRectangle(new Pen(myUsedElementStyle.TodayColor),
                                        new Rectangle(myPaintRect.Left, myPaintRect.Top, myPaintRect.Width - 1,
                                        myPaintRect.Height - 1));
                    }
                }
                if (m_bMouseHover == true && m_MonthDaysStyle.MarkHover == true &&
                    m_MouseSelectedDay.Cell == Cell && m_MouseSelectedDay.Row == Row)
                {
                    System.Diagnostics.Debug.WriteLine("Draw mouse over monthday");
                    //draw filled rectangle over monthday
                    if (m_MonthDaysStyle.HoverStyle.Background.Style == EStyle.esColor)
                    {
                        SolidBrush myBrush = new SolidBrush(Color.FromArgb(m_MonthDaysStyle.HoverStyle.Background.TransparencyStartColor,
                                                            m_MonthDaysStyle.HoverStyle.Background.StartColor));
                        e.FillRectangle(myBrush, myPaintRect);
                    }
                    else if (m_MonthDaysStyle.HoverStyle.Background.Style == EStyle.esParent)
                    {
                        SolidBrush myBrush = new SolidBrush(this.BackColor);
                        e.FillRectangle(myBrush, myPaintRect);
                    }
                    else if (m_MonthDaysStyle.HoverStyle.Background.Style == EStyle.esGradient)
                    {
                        LinearGradientMode myMode;
                        if (m_MonthDaysStyle.HoverStyle.Background.Gradient == GradientStyle.Vertical)
                            myMode = LinearGradientMode.Vertical;
                        else if (m_MonthDaysStyle.HoverStyle.Background.Gradient == GradientStyle.Horizontal)
                            myMode = LinearGradientMode.Horizontal;
                        else if (m_MonthDaysStyle.HoverStyle.Background.Gradient == GradientStyle.ForwardDiagonal)
                            myMode = LinearGradientMode.ForwardDiagonal;
                        else
                            myMode = LinearGradientMode.BackwardDiagonal;

                        LinearGradientBrush myGBrush = new LinearGradientBrush(myPaintRect, Color.FromArgb(
                                                                               m_MonthDaysStyle.HoverStyle.Background.TransparencyStartColor,
                                                                               m_MonthDaysStyle.HoverStyle.Background.StartColor),
                                                                               Color.FromArgb(m_MonthDaysStyle.HoverStyle.Background.TransparencyEndColor,
                                                                               m_MonthDaysStyle.HoverStyle.Background.EndColor), myMode);
                    }
                    //draw border
                    if (m_MonthDaysStyle.HoverStyle.Border.Visible == true)
                    {
                        e.DrawRectangle(new Pen(Color.FromArgb(m_MonthDaysStyle.HoverStyle.Border.Transparency,
                                        m_MonthDaysStyle.HoverStyle.Border.BorderColor)),
                                        new Rectangle(myPaintRect.Left, myPaintRect.Top, myPaintRect.Width - 1,
                                        myPaintRect.Height - 1));

                    }
                }
            }
        }

        private void Draw120YearsRange(Graphics e)
        {
            m_MonthWidth = (int)(this.Width - 8 - (5 * m_MonthDaysStyle.DaysPadding.Horizontal)) / 4;
            m_MonthHeight = (int)(this.Height - 8 - m_NextTopPos - (4 * m_MonthDaysStyle.DaysPadding.Vertical)) / 3;
            m_WeekDaysLeftStartPos = 4;
            m_WeekDaysTopStartPos = m_NextTopPos + 4;
            for (int iRowCounter = 0; iRowCounter < 3; iRowCounter++)
            {
                for (int iCellCounter = 0; iCellCounter < 4; iCellCounter++)
                {
                    //draw years range
                    DrawYearGroup(e, iRowCounter, iCellCounter);
                }
            }
        }

        private void DrawYearGroup(Graphics e, int Row, int Cell)
        {
            bool bSelectedDay = false;
            //draw year
            int iViewedYear = m_Start120YearsRange + (((Row * 4) + Cell) * 10);
            Rectangle myPaintRect = new Rectangle(4 + (Cell * (m_MonthWidth +
                                      m_MonthDaysStyle.DaysPadding.Horizontal)) +
                                      m_MonthDaysStyle.DaysPadding.Horizontal,
                                      m_NextTopPos + 4 + (Row * (m_MonthHeight +
                                      m_MonthDaysStyle.DaysPadding.Vertical)) +
                                      m_MonthDaysStyle.DaysPadding.Vertical,
                                      m_MonthWidth, m_MonthHeight);

            YearGroupRenderEventArgs myRenderEvent = new YearGroupRenderEventArgs(e, myPaintRect, iViewedYear.ToString());
            if (YearsGroupRender != null) YearsGroupRender(this, myRenderEvent);
            if (myRenderEvent.OwnerDraw == false)
            {
                MonthDaysElementStyle myUsedElementStyle = m_MonthDaysStyle;
                if (m_SelectedDate.Year >= iViewedYear && m_SelectedDate.Year <= iViewedYear + 9)
                {
                    if (m_MonthDaysStyle.MarkSelectedDay == true)
                    {
                        bSelectedDay = true;
                    }
                }
                if (bSelectedDay == false)
                {
                    switch (myUsedElementStyle.Background.Style)
                    {
                        case EStyle.esColor:
                            SolidBrush myBrush = new SolidBrush(Color.FromArgb(myUsedElementStyle.Background.TransparencyStartColor,
                                                                myUsedElementStyle.Background.StartColor));
                            e.FillRectangle(myBrush, myPaintRect);
                            break;
                        case EStyle.esParent:
                            SolidBrush myBrush2 = new SolidBrush(this.BackColor);
                            e.FillRectangle(myBrush2, myPaintRect);
                            break;
                        case EStyle.esGradient:
                            LinearGradientMode myMode;
                            if (myUsedElementStyle.Background.Gradient == GradientStyle.Vertical)
                                myMode = LinearGradientMode.Vertical;
                            else if (myUsedElementStyle.Background.Gradient == GradientStyle.Horizontal)
                                myMode = LinearGradientMode.Horizontal;
                            else if (myUsedElementStyle.Background.Gradient == GradientStyle.ForwardDiagonal)
                                myMode = LinearGradientMode.ForwardDiagonal;
                            else
                                myMode = LinearGradientMode.BackwardDiagonal;

                            LinearGradientBrush myGBrush = new LinearGradientBrush(myPaintRect, Color.FromArgb(
                                                                                   myUsedElementStyle.Background.TransparencyStartColor,
                                                                                   myUsedElementStyle.Background.StartColor),
                                                                                   Color.FromArgb(
                                                                                   myUsedElementStyle.Background.TransparencyEndColor,
                                                                                   myUsedElementStyle.Background.EndColor),
                                                                                   myMode);
                            e.FillRectangle(myGBrush, myPaintRect);

                            break;
                    }
                }
                else
                {
                    //draw selected year-group
                    switch (myUsedElementStyle.SelectedDay.Background.Style)
                    {
                        case EStyle.esColor:
                            SolidBrush myBrush = new SolidBrush(Color.FromArgb(myUsedElementStyle.SelectedDay.Background.TransparencyStartColor,
                                                                myUsedElementStyle.SelectedDay.Background.StartColor));
                            e.FillRectangle(myBrush, myPaintRect);
                            break;
                        case EStyle.esParent:
                            SolidBrush myBrush2 = new SolidBrush(this.BackColor);
                            e.FillRectangle(myBrush2, myPaintRect);
                            break;
                        case EStyle.esGradient:
                            LinearGradientMode myMode;
                            if (myUsedElementStyle.SelectedDay.Background.Gradient == GradientStyle.Vertical)
                                myMode = LinearGradientMode.Vertical;
                            else if (myUsedElementStyle.SelectedDay.Background.Gradient == GradientStyle.Horizontal)
                                myMode = LinearGradientMode.Horizontal;
                            else if (myUsedElementStyle.SelectedDay.Background.Gradient == GradientStyle.ForwardDiagonal)
                                myMode = LinearGradientMode.ForwardDiagonal;
                            else
                                myMode = LinearGradientMode.BackwardDiagonal;

                            LinearGradientBrush myGBrush = new LinearGradientBrush(myPaintRect, Color.FromArgb(
                                                                                   myUsedElementStyle.SelectedDay.Background.TransparencyStartColor,
                                                                                   myUsedElementStyle.SelectedDay.Background.StartColor),
                                                                                   Color.FromArgb(
                                                                                   myUsedElementStyle.SelectedDay.Background.TransparencyEndColor,
                                                                                   myUsedElementStyle.SelectedDay.Background.EndColor),
                                                                                   myMode);
                            e.FillRectangle(myGBrush, myPaintRect);

                            break;
                    }
                }
                //draw text
                //seond draw text
                StringFormat myStringFormat = new StringFormat();
                switch (myUsedElementStyle.Align)
                {
                    case ContentAlignment.TopLeft:
                        myStringFormat.Alignment = StringAlignment.Near;
                        myStringFormat.LineAlignment = StringAlignment.Near;
                        break;
                    case ContentAlignment.TopCenter:
                        myStringFormat.Alignment = StringAlignment.Center;
                        myStringFormat.LineAlignment = StringAlignment.Near;
                        break;
                    case ContentAlignment.TopRight:
                        myStringFormat.Alignment = StringAlignment.Far;
                        myStringFormat.LineAlignment = StringAlignment.Near;
                        break;
                    case ContentAlignment.MiddleLeft:
                        myStringFormat.Alignment = StringAlignment.Near;
                        myStringFormat.LineAlignment = StringAlignment.Center;
                        break;
                    case ContentAlignment.MiddleCenter:
                        myStringFormat.Alignment = StringAlignment.Center;
                        myStringFormat.LineAlignment = StringAlignment.Center;
                        break;
                    case ContentAlignment.MiddleRight:
                        myStringFormat.Alignment = StringAlignment.Far;
                        myStringFormat.LineAlignment = StringAlignment.Center;
                        break;
                    case ContentAlignment.BottomLeft:
                        myStringFormat.Alignment = StringAlignment.Near;
                        myStringFormat.LineAlignment = StringAlignment.Far;
                        break;
                    case ContentAlignment.BottomCenter:
                        myStringFormat.Alignment = StringAlignment.Center;
                        myStringFormat.LineAlignment = StringAlignment.Far;
                        break;
                    case ContentAlignment.BottomRight:
                        myStringFormat.Alignment = StringAlignment.Far;
                        myStringFormat.LineAlignment = StringAlignment.Far;
                        break;
                }
                if (bSelectedDay == false)
                {
                    string myYearsRange = iViewedYear.ToString() + "-" + ((int)iViewedYear + 9).ToString();
                    e.DrawString(myYearsRange, myUsedElementStyle.Font,
                                 new SolidBrush(Color.FromArgb(myUsedElementStyle.TextTransparency, myUsedElementStyle.ForeColor)),
                                 myPaintRect, myStringFormat);
                }
                else
                {
                    string myYearsRange = iViewedYear.ToString() + "-" + ((int)iViewedYear + 9).ToString();
                    e.DrawString(myYearsRange, myUsedElementStyle.SelectedDay.Font,
                                 new SolidBrush(myUsedElementStyle.SelectedDay.ForeColor),
                                 myPaintRect, myStringFormat);
                }
                if (bSelectedDay == false)
                {
                    //draw border 
                    if (myUsedElementStyle.Border.Visible == true)
                    {
                        //draw an frame around day
                        e.DrawRectangle(new Pen(Color.FromArgb(myUsedElementStyle.Border.Transparency, myUsedElementStyle.Border.BorderColor)),
                                        new Rectangle(myPaintRect.Left, myPaintRect.Top, myPaintRect.Width - 1,
                                        myPaintRect.Height - 1));
                    }
                }
                else
                {
                    //draw border 
                    if (myUsedElementStyle.SelectedDay.Border.Visible == true)
                    {
                        //draw an frame around day
                        e.DrawRectangle(new Pen(Color.FromArgb(myUsedElementStyle.SelectedDay.Border.Transparency,
                                        myUsedElementStyle.SelectedDay.Border.BorderColor)),
                                        new Rectangle(myPaintRect.Left, myPaintRect.Top, myPaintRect.Width - 1,
                                        myPaintRect.Height - 1));
                    }
                }

                if (DateTime.Now.Year >= iViewedYear && DateTime.Now.Year <= iViewedYear + 9)
                {
                    if (myUsedElementStyle.MarkToday == true)
                    {
                        //draw an frame around day
                        e.DrawRectangle(new Pen(myUsedElementStyle.TodayColor),
                                        new Rectangle(myPaintRect.Left, myPaintRect.Top, myPaintRect.Width - 1,
                                        myPaintRect.Height - 1));
                    }
                }

                if (m_bMouseHover == true && m_MonthDaysStyle.MarkHover == true &&
                    m_MouseSelectedDay.Cell == Cell && m_MouseSelectedDay.Row == Row)
                {
                    System.Diagnostics.Debug.WriteLine("Draw mouse over monthday");
                    //draw filled rectangle over monthday
                    if (m_MonthDaysStyle.HoverStyle.Background.Style == EStyle.esColor)
                    {
                        SolidBrush myBrush = new SolidBrush(Color.FromArgb(m_MonthDaysStyle.HoverStyle.Background.TransparencyStartColor,
                                                            m_MonthDaysStyle.HoverStyle.Background.StartColor));
                        e.FillRectangle(myBrush, myPaintRect);
                    }
                    else if (m_MonthDaysStyle.HoverStyle.Background.Style == EStyle.esParent)
                    {
                        SolidBrush myBrush = new SolidBrush(this.BackColor);
                        e.FillRectangle(myBrush, myPaintRect);
                    }
                    else if (m_MonthDaysStyle.HoverStyle.Background.Style == EStyle.esGradient)
                    {
                        LinearGradientMode myMode;
                        if (m_MonthDaysStyle.HoverStyle.Background.Gradient == GradientStyle.Vertical)
                            myMode = LinearGradientMode.Vertical;
                        else if (m_MonthDaysStyle.HoverStyle.Background.Gradient == GradientStyle.Horizontal)
                            myMode = LinearGradientMode.Horizontal;
                        else if (m_MonthDaysStyle.HoverStyle.Background.Gradient == GradientStyle.ForwardDiagonal)
                            myMode = LinearGradientMode.ForwardDiagonal;
                        else
                            myMode = LinearGradientMode.BackwardDiagonal;

                        LinearGradientBrush myGBrush = new LinearGradientBrush(myPaintRect, Color.FromArgb(
                                                                               m_MonthDaysStyle.HoverStyle.Background.TransparencyStartColor,
                                                                               m_MonthDaysStyle.HoverStyle.Background.StartColor),
                                                                               Color.FromArgb(m_MonthDaysStyle.HoverStyle.Background.TransparencyEndColor,
                                                                               m_MonthDaysStyle.HoverStyle.Background.EndColor), myMode);
                    }
                    //draw border
                    if (m_MonthDaysStyle.HoverStyle.Border.Visible == true)
                    {
                        e.DrawRectangle(new Pen(Color.FromArgb(m_MonthDaysStyle.HoverStyle.Border.Transparency,
                                        m_MonthDaysStyle.HoverStyle.Border.BorderColor)),
                                        new Rectangle(myPaintRect.Left, myPaintRect.Top, myPaintRect.Width - 1,
                                        myPaintRect.Height - 1));

                    }
                }
            }
        }
        #endregion

        #region Mouseevents
        protected override void OnMouseLeave(EventArgs e)
        {
            base.OnMouseLeave(e);
            if (m_bMOuseHoverHeader == true | m_bMouseHover == true)
            {
                //m_bMouseHover = false;
                m_bMOuseHoverHeader = false;
                m_bMouseHover = false;
                Invalidate();
            }

        }

        protected override void OnGotFocus(EventArgs e)
        {
            base.OnGotFocus(e);
            m_bMouseHover = true;
            Invalidate();
        }

        protected override void OnLostFocus(EventArgs e)
        {
            base.OnLostFocus(e);
            m_bMouseHover = false;
            Invalidate();
        }

        protected override void OnMouseMove(MouseEventArgs e)
        {
            if (e.X > m_TitleTextLeftStartPos && e.X < m_TitleTextLeftStartPos + m_TitleTextWidth &&
                        e.Y > m_TitleTextTopStartPos && e.Y < m_TitleTextTopStartPos + m_TitleTextHeight)
            {
                m_bMOuseHoverHeader = true;
                Invalidate();
            }
            else
            {
                m_bMOuseHoverHeader = false;
                if (m_MonthDaysStyle.MarkHover == true)
                {
                    switch (m_ViewMode)
                    {
                        case ViewMode.vmMonth:
                            int iTmpMonthDayWidth = m_WeekDayWidth + m_MonthDaysStyle.DaysPadding.Horizontal;
                            int iTmpMonthDayHeight = m_WeekDayHeight + m_MonthDaysStyle.DaysPadding.Vertical;

                            if (e.X > m_WeekDaysLeftStartPos && e.X < m_WeekDaysLeftStartPos + (7 * iTmpMonthDayWidth) &&
                                e.Y > m_WeekDaysTopStartPos && e.Y < m_WeekDaysTopStartPos + (6 * iTmpMonthDayHeight))
                            {
                                m_MouseSelectedDay.Cell = (int)(e.X - m_WeekDaysLeftStartPos) / iTmpMonthDayWidth;
                                m_MouseSelectedDay.Row = (int)(e.Y - m_WeekDaysTopStartPos) / iTmpMonthDayHeight;                                
                                
                                if (m_MouseInWeekDay == false)
                                    m_StartMultiSelectionHover = m_MouseSelectedDay;
                                
                                m_bMouseHover = true;
                                System.Diagnostics.Debug.WriteLine("MOuse in monthdaysarea cell:" + 
                                                                   m_MouseSelectedDay.Cell.ToString() + 
                                                                   " row: " + m_MouseSelectedDay.Row.ToString());
                            }
                            else
                            {
                                m_bMouseHover = false;
                                System.Diagnostics.Debug.WriteLine("Mouse not in monthdaysarea");
                            }
                            break;
                        case ViewMode.vmYear:
                            int iTmpMonthWidth = m_MonthWidth + m_MonthDaysStyle.DaysPadding.Horizontal;
                            int iTmpMonthHeight = m_MonthHeight + m_MonthDaysStyle.DaysPadding.Vertical;

                            if (e.X > m_WeekDaysLeftStartPos && e.X < m_WeekDaysLeftStartPos + (4 * iTmpMonthWidth) &&
                            e.Y > m_WeekDaysTopStartPos && e.Y < m_WeekDaysTopStartPos + (3 * iTmpMonthHeight))
                            {
                                m_MouseSelectedDay.Cell = (int)(e.X - m_WeekDaysLeftStartPos) / iTmpMonthWidth;
                                m_MouseSelectedDay.Row = (int)(e.Y - m_WeekDaysTopStartPos) / iTmpMonthHeight;
                                
                                System.Diagnostics.Debug.WriteLine("MOuse in yearsarea cell:" +
                                                                   m_MouseSelectedDay.Cell.ToString() + " row: " +
                                                                   m_MouseSelectedDay.Row.ToString());
                                m_bMouseHover = true;
                            }
                            else
                            {
                                m_bMouseHover = false;
                                System.Diagnostics.Debug.WriteLine("Mouse not in yearsarea");
                            }
                            break;
                        case ViewMode.vm12Years:
                            iTmpMonthWidth = m_MonthWidth + m_MonthDaysStyle.DaysPadding.Horizontal;
                            iTmpMonthHeight = m_MonthHeight + m_MonthDaysStyle.DaysPadding.Vertical;

                            if (e.X > m_WeekDaysLeftStartPos && e.X < m_WeekDaysLeftStartPos + (4 * iTmpMonthWidth) &&
                            e.Y > m_WeekDaysTopStartPos && e.Y < m_WeekDaysTopStartPos + (3 * iTmpMonthHeight))
                            {
                                m_MouseSelectedDay.Cell = (int)(e.X - m_WeekDaysLeftStartPos) / iTmpMonthWidth;
                                m_MouseSelectedDay.Row = (int)(e.Y - m_WeekDaysTopStartPos) / iTmpMonthHeight;
                                
                                System.Diagnostics.Debug.WriteLine("MOuse in 12yearsarea cell:" + 
                                                                   m_MouseSelectedDay.Cell.ToString() +
                                                                   " row: " + m_MouseSelectedDay.Row.ToString());
                                m_bMouseHover = true;
                            }
                            else
                            {
                                m_bMouseHover = false;
                                System.Diagnostics.Debug.WriteLine("Mouse not in 12yearsarea");
                            }
                            break;
                        case ViewMode.vm120Years:
                            iTmpMonthWidth = m_MonthWidth + m_MonthDaysStyle.DaysPadding.Horizontal;
                            iTmpMonthHeight = m_MonthHeight + m_MonthDaysStyle.DaysPadding.Vertical;

                            if (e.X > m_WeekDaysLeftStartPos && e.X < m_WeekDaysLeftStartPos + (4 * iTmpMonthWidth) &&
                            e.Y > m_WeekDaysTopStartPos && e.Y < m_WeekDaysTopStartPos + (3 * iTmpMonthHeight))
                            {
                                m_MouseSelectedDay.Cell = (int)(e.X - m_WeekDaysLeftStartPos) / iTmpMonthWidth;
                                m_MouseSelectedDay.Row = (int)(e.Y - m_WeekDaysTopStartPos) / iTmpMonthHeight;
                                
                                System.Diagnostics.Debug.WriteLine("MOuse in 120yearsarea cell:" + 
                                                                   m_MouseSelectedDay.Cell.ToString() +
                                                                   " row: " + m_MouseSelectedDay.Row.ToString());
                                m_bMouseHover = true;
                            }
                            else
                            {
                                m_bMouseHover = false;
                                System.Diagnostics.Debug.WriteLine("Mouse not in 120yearsarea");
                            }
                            break;
                    }
                    if (m_MouseSelectedDayBackup.Row != m_MouseSelectedDay.Row |
                        m_MouseSelectedDayBackup.Cell != m_MouseSelectedDay.Cell)
                    {
                        m_MouseSelectedDayBackup = m_MouseSelectedDay;
                        Invalidate();
                    }
                }
            }
        }

        protected override void OnMouseDown(MouseEventArgs e)
        {
            switch (m_ViewMode)
            {
                case ViewMode.vmMonth:
                    int iTmpMonthDayWidth = m_WeekDayWidth + m_MonthDaysStyle.DaysPadding.Horizontal;
                    int iTmpMonthDayHeight = m_WeekDayHeight + m_MonthDaysStyle.DaysPadding.Vertical;

                    if (e.X > m_TitleTextLeftStartPos && e.X < m_TitleTextLeftStartPos + m_TitleTextWidth &&
                        e.Y > m_TitleTextTopStartPos && e.Y < m_TitleTextTopStartPos + m_TitleTextHeight)
                    {
                        m_MouseInTitleText = true;
                    }
                    else if (e.X > m_WeekDaysLeftStartPos && e.X < m_WeekDaysLeftStartPos + (7 * iTmpMonthDayWidth) &&
                        e.Y > m_WeekDaysTopStartPos && e.Y < m_WeekDaysTopStartPos + (6 * iTmpMonthDayHeight))
                    {
                        m_MouseSelectedDay.Cell = (int)(e.X - m_WeekDaysLeftStartPos) / iTmpMonthDayWidth;
                        m_MouseSelectedDay.Row = (int)(e.Y - m_WeekDaysTopStartPos) / iTmpMonthDayHeight;
                        
                        //save startpos to select a range
                        if (m_SelectionMode == SelectionMode.smMulti && m_bMultipleSelectingModeActive == true)
                        {
                            m_StartMultiSelectionHover = m_MouseSelectedDay;
                            if (SelectionStart != null) SelectionStart(this, EventArgs.Empty);
                        }
                        m_MouseInWeekDay = true;
                    }
                    break;
                case ViewMode.vmYear:
                    int iTmpMonthWidth = m_MonthWidth + m_MonthDaysStyle.DaysPadding.Horizontal;
                    int iTmpMonthHeight = m_MonthHeight + m_MonthDaysStyle.DaysPadding.Vertical;

                    if (e.X > m_TitleTextLeftStartPos && e.X < m_TitleTextLeftStartPos + m_TitleTextWidth &&
                        e.Y > m_TitleTextTopStartPos && e.Y < m_TitleTextTopStartPos + m_TitleTextHeight)
                    {
                        m_MouseInTitleText = true;
                    }
                    else if (e.X > m_WeekDaysLeftStartPos && e.X < m_WeekDaysLeftStartPos + (4 * iTmpMonthWidth) &&
                        e.Y > m_WeekDaysTopStartPos && e.Y < m_WeekDaysTopStartPos + (3 * iTmpMonthHeight))
                    {
                        int iXIndexPos = (int)(e.X - m_WeekDaysLeftStartPos) / iTmpMonthWidth;
                        int iYIndexPos = (int)(e.Y - m_WeekDaysTopStartPos) / iTmpMonthHeight;
                        //calc clicked month
                        m_SelectedMonthIndex = (iYIndexPos * 4) + iXIndexPos;
                        m_MouseInWeekDay = true;
                    }
                    break;
                case ViewMode.vm12Years:
                    iTmpMonthWidth = m_MonthWidth + m_MonthDaysStyle.DaysPadding.Horizontal;
                    iTmpMonthHeight = m_MonthHeight + m_MonthDaysStyle.DaysPadding.Vertical;

                    if (e.X > m_TitleTextLeftStartPos && e.X < m_TitleTextLeftStartPos + m_TitleTextWidth &&
                        e.Y > m_TitleTextTopStartPos && e.Y < m_TitleTextTopStartPos + m_TitleTextHeight)
                    {
                        m_MouseInTitleText = true;
                    }
                    else if (e.X > m_WeekDaysLeftStartPos && e.X < m_WeekDaysLeftStartPos + (4 * iTmpMonthWidth) &&
                        e.Y > m_WeekDaysTopStartPos && e.Y < m_WeekDaysTopStartPos + (3 * iTmpMonthHeight))
                    {
                        int iXIndexPos = (int)(e.X - m_WeekDaysLeftStartPos) / iTmpMonthWidth;
                        int iYIndexPos = (int)(e.Y - m_WeekDaysTopStartPos) / iTmpMonthHeight;
                        //calc clicked month
                        m_SelectedMonthIndex = (iYIndexPos * 4) + iXIndexPos;
                        m_MouseInWeekDay = true;
                    }
                    break;
                case ViewMode.vm120Years:
                    iTmpMonthWidth = m_MonthWidth + m_MonthDaysStyle.DaysPadding.Horizontal;
                    iTmpMonthHeight = m_MonthHeight + m_MonthDaysStyle.DaysPadding.Vertical;

                    if (e.X > m_WeekDaysLeftStartPos && e.X < m_WeekDaysLeftStartPos + (4 * iTmpMonthWidth) &&
                        e.Y > m_WeekDaysTopStartPos && e.Y < m_WeekDaysTopStartPos + (3 * iTmpMonthHeight))
                    {
                        int iXIndexPos = (int)(e.X - m_WeekDaysLeftStartPos) / iTmpMonthWidth;
                        int iYIndexPos = (int)(e.Y - m_WeekDaysTopStartPos) / iTmpMonthHeight;
                        //calc clicked month
                        m_SelectedMonthIndex = (iYIndexPos * 4) + iXIndexPos;
                        m_MouseInWeekDay = true;
                    }
                    break;
            }
        }

        protected override void OnMouseUp(MouseEventArgs e)
        {
            switch (m_ViewMode)
            {
                case ViewMode.vmMonth:
                    if (m_MouseInTitleText == true)
                    {
                        m_MouseInTitleText = false;
                        //raise headerclick - event
                        if (HeaderClick != null) HeaderClick(this, EventArgs.Empty);
                        //view month of a complete year
                        SetViewMode(ViewMode.vmYear, ViewMode.vmMonth);
                    } else if (m_MouseInWeekDay == true)
                    {
                        int iTmpMonthDayWidth = m_WeekDayWidth + m_MonthDaysStyle.DaysPadding.Horizontal;
                        int iTmpMonthDayHeight = m_WeekDayHeight + m_MonthDaysStyle.DaysPadding.Vertical;

                        int iXIndexPos = (int)(e.X - m_WeekDaysLeftStartPos) / iTmpMonthDayWidth;
                        int iYIndexPos = (int)(e.Y - m_WeekDaysTopStartPos) / iTmpMonthDayHeight;
                        if (iXIndexPos < 0) iXIndexPos = 0;
                        if (iXIndexPos > 6) iXIndexPos = 6;
                        if (iYIndexPos < 0) iYIndexPos = 0;
                        if (iYIndexPos > 5) iYIndexPos = 5;                        

                        m_MouseInWeekDay = false;
                        //set new selected date
                        DateTime myNewDate = new DateTime(
                            m_WeekDayItems[m_MouseSelectedDay.Cell, m_MouseSelectedDay.Row].Year,
                            m_WeekDayItems[m_MouseSelectedDay.Cell, m_MouseSelectedDay.Row].Month,
                            m_WeekDayItems[m_MouseSelectedDay.Cell, m_MouseSelectedDay.Row].Day);
                        if (CanSelectDate(myNewDate) == true)
                        {                                                                       
                            if (m_SelectionMode == SelectionMode.smOne || 
                                (m_SelectionMode == SelectionMode.smMulti &&
                                m_bMultipleSelectingModeActive == false))
                            {
                                if ((m_bCanSelectTrailingDates == true &&
                                    m_WeekDayItems[m_MouseSelectedDay.Cell, m_MouseSelectedDay.Row].TrailingDay == true) ||
                                    m_WeekDayItems[m_MouseSelectedDay.Cell, m_MouseSelectedDay.Row].TrailingDay == false)
                                {                                    
                                    this.SelectedDate = myNewDate;                                                                    
                                    
                                }
                            }

                            if (m_SelectionMode == SelectionMode.smMulti)
                            {
                                if (m_bMultipleSelectingModeActive == true)
                                {
                                    if (SelectionEnd != null) SelectionEnd(this, EventArgs.Empty);
                                }
                                //multiple selectionmode
                                int iNewItemIndex = (m_MouseSelectedDay.Row * 7) + m_MouseSelectedDay.Cell;
                                int iOldItemIndex = (m_StartMultiSelectionHover.Row * 7) + m_StartMultiSelectionHover.Cell;
                                if (iOldItemIndex != iNewItemIndex)
                                {
                                    SelectedDay myTmpFirstSelDay = m_StartMultiSelectionHover;
                                    SelectedDay myTmpLastSelDay = m_MouseSelectedDay;
                                    //find startcell
                                    if (m_StartMultiSelectionHover.Cell < m_MouseSelectedDay.Cell)
                                    {
                                        myTmpFirstSelDay.Cell = m_StartMultiSelectionHover.Cell;
                                        myTmpLastSelDay.Cell = m_MouseSelectedDay.Cell;
                                    }
                                    else
                                    {
                                        myTmpFirstSelDay.Cell = m_MouseSelectedDay.Cell;
                                        myTmpLastSelDay.Cell = m_StartMultiSelectionHover.Cell;
                                    }
                                    //find startrow
                                    if (m_StartMultiSelectionHover.Row < m_MouseSelectedDay.Row)
                                    {
                                        myTmpFirstSelDay.Row = m_StartMultiSelectionHover.Row;
                                        myTmpLastSelDay.Row = m_MouseSelectedDay.Row;
                                    }
                                    else
                                    {
                                        myTmpFirstSelDay.Row = m_MouseSelectedDay.Row;
                                        myTmpLastSelDay.Row = m_StartMultiSelectionHover.Row;
                                    }
                                    

                                    for (int iRowCounter = myTmpFirstSelDay.Row; 
                                         iRowCounter <= myTmpLastSelDay.Row; iRowCounter++)
                                    {
                                        for (int iCellCounter = myTmpFirstSelDay.Cell;
                                            iCellCounter <= myTmpLastSelDay.Cell; iCellCounter++)
                                        {
                                            if ((m_bCanSelectTrailingDates == true &&
                                                m_WeekDayItems[iCellCounter, iRowCounter].TrailingDay == true) ||
                                                m_WeekDayItems[iCellCounter, iRowCounter].TrailingDay == false)
                                            {
                                                myNewDate = new DateTime(m_WeekDayItems[iCellCounter, iRowCounter].Year,
                                                                         m_WeekDayItems[iCellCounter, iRowCounter].Month,
                                                                         m_WeekDayItems[iCellCounter, iRowCounter].Day);
                                                //add date to selecteditems
                                                AddSelectedItem(myNewDate);
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    if ((m_bCanSelectTrailingDates == true &&
                                    m_WeekDayItems[m_MouseSelectedDay.Cell, m_MouseSelectedDay.Row].TrailingDay == true) ||
                                    m_WeekDayItems[m_MouseSelectedDay.Cell, m_MouseSelectedDay.Row].TrailingDay == false)
                                    {
                                        //multiselectionmode
                                        AddSelectedItem(myNewDate);
                                    }
                                }
                            }
                        }
                    }
                    break;
                case ViewMode.vmYear:
                    if (m_MouseInTitleText == true)
                    {
                        m_MouseInTitleText = false;
                        //view month of a complete year
                        if (m_SelectedDate.Year - 6 >= m_MinDate.Year)
                            m_Start12YearsRange = m_SelectedDate.Year - 6;
                        else
                        {
                            
                            m_Start12YearsRange = m_MinDate.Year;
                        }

                        m_End12YearsRange = m_Start12YearsRange + 11;
                        SetViewMode(ViewMode.vm12Years, ViewMode.vmYear);
                    }
                    else if (m_MouseInWeekDay == true)
                    {
                        m_MouseInWeekDay = false;
                        DateTime myNewDate = new DateTime(m_SelectedDate.Year, m_SelectedMonthIndex+1, m_SelectedDate.Day);
                        if (m_SelectionMode != SelectionMode.smNone)
                        {
                            SelectedDate = myNewDate;
                        }
                        SetViewMode(ViewMode.vmMonth, ViewMode.vmYear);
                        
                    }
                    break;
                case ViewMode.vm12Years:
                    if (m_MouseInTitleText == true)
                    {
                        m_MouseInTitleText = false;
                        if (m_Start12YearsRange - 60 > m_MinDate.Year)
                            m_Start120YearsRange = m_Start12YearsRange - 60;
                        else
                        {
                            m_Start120YearsRange = m_MinDate.Year;
                        }
                        m_End120YearsRange = m_Start120YearsRange + 119;
                        //view month of a complete year
                        SetViewMode(ViewMode.vm120Years, ViewMode.vm12Years);
                    }
                    else if (m_MouseInWeekDay == true)
                    {
                        m_MouseInWeekDay = false;
                        int iNewYear = m_Start12YearsRange + m_SelectedMonthIndex;
                        DateTime myNewDate = new DateTime(iNewYear, m_SelectedDate.Month, m_SelectedDate.Day);
                        if (m_SelectionMode != SelectionMode.smNone)
                        {
                            SelectedDate = myNewDate;
                        }
                        SetViewMode(ViewMode.vmYear, ViewMode.vm12Years);
                    }
                    break;
                case ViewMode.vm120Years:
                    if (m_MouseInWeekDay == true)
                    {
                        m_MouseInWeekDay = false;
                        int iNewYear = m_Start120YearsRange + (m_SelectedMonthIndex * 10);
                        if (m_SelectionMode != SelectionMode.smNone)
                        {
                            m_Start12YearsRange = iNewYear;
                            m_End12YearsRange = iNewYear + 11;
                        }
                        SetViewMode(ViewMode.vm12Years, ViewMode.vm120Years);
                    }
                    break;
            }
        }

        protected override void OnResize(EventArgs e)
        {
            int iNeededWidth = GetWeekNumbersWidth() + GetNeededMonthDaysWidth();
            int iNeededHeight = GetMonthImageHeight() + GetTitleBarHeight() + 
                                GetWeekDaysHeight() + GetMonthDaysHeight() + 
                                GetTodayHeight();
            Size myNewSize = new Size(this.Width, this.Height);
            if (this.Width < iNeededWidth) myNewSize.Width = iNeededWidth;
            if (this.Height < iNeededHeight) myNewSize.Height = iNeededHeight;

            this.SetBounds(this.Left, this.Top, myNewSize.Width, myNewSize.Height);
        }

        #endregion

        #region navigationbuttons
        private void PrevClick(object sender, EventArgs e)
        {
            switch (m_ViewMode) {
                case ViewMode.vmMonth:
                    SelectPreviousMonth();
                    break;
                case ViewMode.vmYear:
                    DateTime myNewDate2 = GetPrevYear(m_SelectedDate);
                    if (CanSelectDate(myNewDate2) == true)
                    {
                        if (myNewDate2.Year - 6 >= 1753)
                        {
                            m_Start12YearsRange = myNewDate2.Year - 6;
                            m_End12YearsRange = myNewDate2.Year + 5;
                        }
                        this.SelectedDate = myNewDate2;
                    }
                    break;
                case ViewMode.vm12Years:
                    if (m_Start12YearsRange - 1 >= 1753)
                    {
                        m_Start12YearsRange--;
                        m_End12YearsRange--;
                        int iYearGroupIndex = (int)m_Start12YearsRange / 10;
                        if (iYearGroupIndex > 175)
                        {
                            m_Start120YearsRange = (iYearGroupIndex - 6) * 10;
                            m_End120YearsRange = (iYearGroupIndex + 5) * 10;
                        }
                        Invalidate();
                    }
                    break;
                case ViewMode.vm120Years:
                    if (m_Start120YearsRange - 10 >= 1760)
                    {
                        m_Start120YearsRange = m_Start120YearsRange - 10;
                        m_End120YearsRange = m_End120YearsRange - 10;
                        Invalidate();
                    }
                    break;
            }
            this.Focus();
            if (NavPreviousMonthClick != null) NavPreviousMonthClick(this, EventArgs.Empty);
        }

        private void NextClick(object sender, EventArgs e)
        {
            switch (m_ViewMode)
            {
                case ViewMode.vmMonth:

                    SelectNextMonth();                    
                    break;
                case ViewMode.vmYear:
                    DateTime myNewDate2 = GetNextYear(m_SelectedDate);
                    if (CanSelectDate(myNewDate2) == true)
                    {
                        if (myNewDate2.Year + 5 <= 9998)
                        {
                            m_Start12YearsRange = myNewDate2.Year - 6;
                            m_End12YearsRange = myNewDate2.Year + 5;
                            
                        }
                        this.SelectedDate = myNewDate2;
                    }
                    break;
                case ViewMode.vm12Years:
                    if (m_End12YearsRange + 1 <= 9998)
                    {
                        m_Start12YearsRange++;
                        m_End12YearsRange++;

                        int iYearGroupIndex = (int)m_Start12YearsRange / 10;
                        if (iYearGroupIndex < 999)
                        {
                            m_Start120YearsRange = (iYearGroupIndex - 6) * 10;
                            m_End120YearsRange = (iYearGroupIndex + 5) * 10;
                        }
                        Invalidate();
                    }
                    break;
                case ViewMode.vm120Years:
                    if (m_End120YearsRange + 10 <= 9990)
                    {
                        m_Start120YearsRange = m_Start120YearsRange + 10;
                        m_End120YearsRange = m_End120YearsRange + 10;
                        Invalidate();
                    }
                    break;
            }
            this.Focus();
            if (NavNextMonthClick != null) NavNextMonthClick(this, EventArgs.Empty);
        }

        private void PrevYearClick(object sender, EventArgs e)
        {
            SelectPreviousYear();
            this.Focus();
            if (NavPreviousYearClick != null) NavPreviousYearClick(this, EventArgs.Empty);
        }

        private void NextYearClick(object sender, EventArgs e)
        {
            SelectNextYear();
            this.Focus();
            if (NavNextYearClick != null) NavNextYearClick(this, EventArgs.Empty);
        }

        #endregion

        #region public functions
        /// <summary>
        /// set calendars allowed modes: Month, Year, 12 Years or 120 Years
        /// </summary>
        /// <param name="Mode">viewmode</param>
        public void SetViewMode(ViewMode NewMode, ViewMode OldMode)
        {
            if (m_bOnlyMonthMode == true)
            {
                if (NewMode != ViewMode.vmMonth)
                {
                    m_ViewMode = ViewMode.vmMonth;
                    Invalidate();
                }
            }
            else
            {
                ViewMode myMode = NewMode;
                if ((int)NewMode > (int)OldMode)
                {
                    //zoomout
                    CanZoomEventArgs myCanZoomEventArgs = new CanZoomEventArgs(OldMode, NewMode);
                    if (CanZoomOut != null) CanZoomOut(this, myCanZoomEventArgs);
                    if (myCanZoomEventArgs.CanZoom == false)
                    {
                        myMode = OldMode;                        
                    } else
                        if (ZoomOut != null) ZoomOut(this, new ZoomEventArgs(myMode));

                }
                else if ((int)NewMode < (int)OldMode)
                {
                    CanZoomEventArgs myCanZoomEventArgs = new CanZoomEventArgs(OldMode, NewMode);
                    if (CanZoomIn != null) CanZoomIn(this, myCanZoomEventArgs);

                    if (myCanZoomEventArgs.CanZoom == false)
                    {
                        myMode = OldMode;                        
                    } else
                        if (ZoomIn != null) ZoomIn(this, new ZoomEventArgs(myMode));
                }
                m_ViewMode = myMode;
                Invalidate();
            }
        }

        /// <summary>
        /// Select the previous month
        /// </summary>
        public void SelectPreviousMonth()
        {
            DateTime myDT = GetPrevMonth(m_SelectedDate);
            if (CanSelectDate(myDT) == true)
            {
                CanChangeMonthEventArgs myCanChangeMonthEvent = new CanChangeMonthEventArgs(m_SelectedDate, myDT);
                if (CanChangeMonth != null) CanChangeMonth(this, myCanChangeMonthEvent);
                if (myCanChangeMonthEvent.Cancel == false)
                {
                    if (MonthChanged != null) MonthChanged(this, new ChangeMonthEventArgs(m_SelectedDate));
                    SelectedDate = new DateTime(myDT.Year, myDT.Month, m_SelectedDate.Day);                    
                }
            }
        }

        /// <summary>
        /// Select the next month
        /// </summary>
        public void SelectNextMonth()
        {
            DateTime myDT = GetNextMonth(m_SelectedDate);
            if (CanSelectDate(myDT) == true)
            {
                CanChangeMonthEventArgs myCanChangeMonthEvent = new CanChangeMonthEventArgs(m_SelectedDate, myDT);
                if (CanChangeMonth != null) CanChangeMonth(this, myCanChangeMonthEvent);
                if (myCanChangeMonthEvent.Cancel == false)
                {
                    if (MonthChanged != null) MonthChanged(this, new ChangeMonthEventArgs(m_SelectedDate));
                    SelectedDate = new DateTime(myDT.Year, myDT.Month, m_SelectedDate.Day);                    
                }
            }
        }

        /// <summary>
        /// selectt the previous year
        /// </summary>
        public void SelectPreviousYear()
        {
            DateTime myDT = GetPrevYear(m_SelectedDate);
            if (CanSelectDate(myDT) == true)
            {
                CanChangeYearEventArgs myCanChangeYearEvent = new CanChangeYearEventArgs(m_SelectedDate, myDT);
                if (CanChangeYear != null) CanChangeYear(this, myCanChangeYearEvent);

                if (myCanChangeYearEvent.Cancel == false)
                {
                    if (YearChanged != null) YearChanged(this, new ChangeYearEventArgs(m_SelectedDate));
                    SelectedDate = new DateTime(myDT.Year, m_SelectedDate.Month, m_SelectedDate.Day);                    
                }
            }
        }

        /// <summary>
        /// select the next year
        /// </summary>
        public void SelectNextYear()
        {
            DateTime myDT = GetNextYear(m_SelectedDate);
            if (CanSelectDate(myDT) == true)
            {
                CanChangeYearEventArgs myCanChangeYearEvent = new CanChangeYearEventArgs(m_SelectedDate, myDT);
                if (CanChangeYear != null) CanChangeYear(this, myCanChangeYearEvent);

                if (myCanChangeYearEvent.Cancel == false)
                {
                    if (YearChanged != null) YearChanged(this, new ChangeYearEventArgs(m_SelectedDate));
                    SelectedDate = new DateTime(myDT.Year, m_SelectedDate.Month, m_SelectedDate.Day);                    
                }
            }
        }

        /// <summary>
        /// select the today date
        /// </summary>
        public void SelectToday()
        {
            DateTime myTmpDate = DateTime.Now;            
            if (DateTime.Now.Year - 6 >= m_MinDate.Year)
                m_Start12YearsRange = DateTime.Now.Year - 6;
            else
                m_Start12YearsRange = m_MinDate.Year;
            m_End12YearsRange = m_Start12YearsRange + 11;

            if (m_Start12YearsRange - 60 >= m_MinDate.Year)
                m_Start120YearsRange = m_Start12YearsRange - 60;
            else
                m_Start120YearsRange = m_MinDate.Year;
            m_End120YearsRange = m_Start120YearsRange + 119;
            SelectedDate = myTmpDate;
        }
        #endregion

        #region keyboard steering
        public override bool PreProcessMessage(ref Message msg)
        {
            if (msg.Msg == GlobalHookHelpers.WM_KEYDOWN)
            {
                Keys myKeyCode = ((Keys)(int)msg.WParam);
                if (myKeyCode == m_KeyboardControl.Left ||
                    myKeyCode == m_KeyboardControl.Right ||
                    myKeyCode == m_KeyboardControl.Up ||
                    myKeyCode == m_KeyboardControl.Down ||
                    myKeyCode == m_KeyboardControl.ZoomOut ||
                    myKeyCode == m_KeyboardControl.Zoomin ||
                    myKeyCode == m_KeyboardControl.NextMonth ||
                    myKeyCode == m_KeyboardControl.PrevMonth ||
                    myKeyCode == m_KeyboardControl.NextYear ||
                    myKeyCode == m_KeyboardControl.PrevYear ||
                    myKeyCode == m_KeyboardControl.NavNext ||
                    myKeyCode == m_KeyboardControl.NavPrev ||
                    myKeyCode == m_KeyboardControl.GoToday)
                {
                    if (m_bKeyHandled)
                        return false;
                }
            }
            else
            {
                Keys myKeyCode = ((Keys)(int)msg.WParam);
                if (myKeyCode == m_KeyboardControl.Left ||
                    myKeyCode == m_KeyboardControl.Right ||
                    myKeyCode == m_KeyboardControl.Up ||
                    myKeyCode == m_KeyboardControl.Down ||
                    myKeyCode == m_KeyboardControl.ZoomOut ||
                    myKeyCode == m_KeyboardControl.Zoomin ||
                    myKeyCode == m_KeyboardControl.NextMonth ||
                    myKeyCode == m_KeyboardControl.PrevMonth ||
                    myKeyCode == m_KeyboardControl.NextYear ||
                    myKeyCode == m_KeyboardControl.PrevYear ||
                    myKeyCode == m_KeyboardControl.NavNext ||
                    myKeyCode == m_KeyboardControl.NavPrev ||
                    myKeyCode == m_KeyboardControl.GoToday)
                {
                    if (m_bKeyHandled)
                        return false;
                }
            }
            return base.PreProcessMessage(ref msg);
        }

        private void Hook_KeyDown(object sender, KeyEventArgs e)
        {
            if (m_KeyboardControl.AllowKeyboardSteering == true)
            {
                if (this.Focused)
                {
                    m_bKeyHandled = false;
                    if (e.KeyCode == Keys.LControlKey || e.KeyCode == Keys.RControlKey)
                    {
                        if (m_KeyboardControl.MultipleSelection == ExtendedSelection.Ctrl)
                        {
                            m_bMultipleSelectingModeActive = true;
                            if (EnableMultiSelectionMode != null) EnableMultiSelectionMode(this, EventArgs.Empty);
                        }
                    }
                    else if (e.KeyCode == Keys.LShiftKey || e.KeyCode == Keys.RShiftKey)
                    {
                        if (m_KeyboardControl.MultipleSelection == ExtendedSelection.Shift)
                        {
                            m_bMultipleSelectingModeActive = true;
                            if (EnableMultiSelectionMode != null) EnableMultiSelectionMode(this, EventArgs.Empty);
                        }
                    }
                    else if (e.KeyCode == Keys.LMenu)
                    {
                        if (m_KeyboardControl.MultipleSelection == ExtendedSelection.Alt)
                        {
                            m_bMultipleSelectingModeActive = true;
                            if (EnableMultiSelectionMode != null) EnableMultiSelectionMode(this, EventArgs.Empty);
                        }
                    }
                    else if (e.KeyCode == m_KeyboardControl.Select)
                    {
                        if (m_SelectionMode == SelectionMode.smMulti && m_bMultipleSelectingModeActive == true)
                        {
                            m_StartMultiSelectionHover = m_MouseSelectedDay;
                            if (SelectionStart != null) SelectionStart(this, EventArgs.Empty);
                        }
                        m_MouseInWeekDay = true;
                    }
                    else if (e.KeyCode == m_KeyboardControl.Left)
                    {

                        switch (m_ViewMode)
                        {
                            case ViewMode.vmMonth:
                                if (m_MouseSelectedDay.Cell == 0)
                                {
                                    if (m_MouseSelectedDay.Row > 0)
                                    {
                                        m_MouseSelectedDay.Cell = 6;
                                        m_MouseSelectedDay.Row--;
                                    }
                                }
                                else if (m_MouseSelectedDay.Cell > 0)
                                    m_MouseSelectedDay.Cell--;

                                if (m_MouseInWeekDay == false)
                                    m_StartMultiSelectionHover = m_MouseSelectedDay;
                                m_bKeyHandled = true;
                                break;
                            default:
                                if (m_MouseSelectedDay.Cell == 0)
                                {
                                    if (m_MouseSelectedDay.Row > 0)
                                    {
                                        m_MouseSelectedDay.Cell = 3;
                                        m_MouseSelectedDay.Row--;
                                    }
                                }
                                else if (m_MouseSelectedDay.Cell > 0)
                                    m_MouseSelectedDay.Cell--;


                                m_bKeyHandled = true;
                                break;
                        }
                    }
                    else if (e.KeyCode == m_KeyboardControl.Right)
                    {
                        switch (m_ViewMode)
                        {
                            case ViewMode.vmMonth:
                                if (m_MouseSelectedDay.Cell == 6)
                                {
                                    if (m_MouseSelectedDay.Row < 5)
                                    {
                                        m_MouseSelectedDay.Cell = 0;
                                        m_MouseSelectedDay.Row++;
                                    }
                                }
                                else if (m_MouseSelectedDay.Cell < 6)
                                    m_MouseSelectedDay.Cell++;

                                if (m_MouseInWeekDay == false)
                                    m_StartMultiSelectionHover = m_MouseSelectedDay;
                                m_bKeyHandled = true;
                                break;
                            default:
                                if (m_MouseSelectedDay.Cell == 3)
                                {
                                    if (m_MouseSelectedDay.Row < 2)
                                    {
                                        m_MouseSelectedDay.Cell = 0;
                                        m_MouseSelectedDay.Row++;
                                    }
                                }
                                else if (m_MouseSelectedDay.Cell < 3)
                                    m_MouseSelectedDay.Cell++;
                                m_bKeyHandled = true;
                                break;
                        }
                    }
                    else if (e.KeyCode == m_KeyboardControl.Up)
                    {
                        switch (m_ViewMode)
                        {
                            case ViewMode.vmMonth:
                                if (m_MouseSelectedDay.Row > 0)
                                    m_MouseSelectedDay.Row--;

                                if (m_MouseInWeekDay == false)
                                    m_StartMultiSelectionHover = m_MouseSelectedDay;
                                m_bKeyHandled = true;
                                break;
                            default:
                                if (m_MouseSelectedDay.Row > 0)
                                    m_MouseSelectedDay.Row--;
                                m_bKeyHandled = true;
                                break;
                        }
                    }
                    else if (e.KeyCode == m_KeyboardControl.Down)
                    {
                        switch (m_ViewMode)
                        {
                            case ViewMode.vmMonth:
                                if (m_MouseSelectedDay.Row < 5)
                                    m_MouseSelectedDay.Row++;
                                if (m_MouseInWeekDay == false)
                                    m_StartMultiSelectionHover = m_MouseSelectedDay;
                                m_bKeyHandled = true;
                                break;
                            default:
                                if (m_MouseSelectedDay.Row < 2)
                                    m_MouseSelectedDay.Row++;
                                m_bKeyHandled = true;
                                break;
                        }
                    }


                    this.Invalidate();
                }
            }
        }
        
        private void Hook_KeyUp(object sender, KeyEventArgs e)
        {
            if (m_KeyboardControl.AllowKeyboardSteering == true)
            {
                int iSelectedIndex = 0;
                if (this.Focused)
                {
                    if (e.KeyCode == Keys.LControlKey || e.KeyCode == Keys.RControlKey)
                    {
                        if (m_KeyboardControl.MultipleSelection == ExtendedSelection.Ctrl &&
                            m_bMultipleSelectingModeActive == true)
                        {
                            m_bMultipleSelectingModeActive = false;
                            if (DisableMultiSelectionMode != null) DisableMultiSelectionMode(this, EventArgs.Empty);
                        }
                    }
                    else if (e.KeyCode == Keys.LShiftKey || e.KeyCode == Keys.RShiftKey)
                    {
                        if (m_KeyboardControl.MultipleSelection == ExtendedSelection.Shift &&
                            m_bMultipleSelectingModeActive == true)
                        {
                            m_bMultipleSelectingModeActive = false;
                            if (DisableMultiSelectionMode != null) DisableMultiSelectionMode(this, EventArgs.Empty);
                        }
                    }
                    else if (e.KeyCode == Keys.LMenu)
                    {
                        if (m_KeyboardControl.MultipleSelection == ExtendedSelection.Alt &&
                            m_bMultipleSelectingModeActive == true)
                        {
                            m_bMultipleSelectingModeActive = false;
                            if (DisableMultiSelectionMode != null) DisableMultiSelectionMode(this, EventArgs.Empty);
                        }
                    }

                    if (e.KeyCode == m_KeyboardControl.Select)
                    {
                        switch (m_ViewMode)
                        {
                            case ViewMode.vmMonth:
                                DateTime myNewDate = new DateTime(
                                    m_WeekDayItems[m_MouseSelectedDay.Cell, m_MouseSelectedDay.Row].Year,
                                    m_WeekDayItems[m_MouseSelectedDay.Cell, m_MouseSelectedDay.Row].Month,
                                    m_WeekDayItems[m_MouseSelectedDay.Cell, m_MouseSelectedDay.Row].Day);
                                if (CanSelectDate(myNewDate) == true)
                                {                                   
                                    //select one date
                                    if (m_SelectionMode == SelectionMode.smOne ||
                                        (m_SelectionMode == SelectionMode.smMulti && 
                                         m_bMultipleSelectingModeActive == false))
                                    {
                                        if ((m_bCanSelectTrailingDates == true &&
                                            m_WeekDayItems[m_MouseSelectedDay.Cell, m_MouseSelectedDay.Row].TrailingDay == true) ||
                                            m_WeekDayItems[m_MouseSelectedDay.Cell, m_MouseSelectedDay.Row].TrailingDay == false)
                                        {                                            
                                            this.SelectedDate = myNewDate;                                                                                

                                            m_bKeyHandled = true;
                                        }
                                    }

                                    if (m_SelectionMode == SelectionMode.smMulti)
                                    {
                                        if (m_bMultipleSelectingModeActive == true)
                                        {
                                            if (SelectionEnd != null) SelectionEnd(this, EventArgs.Empty);
                                        }

                                        m_MouseInWeekDay = false;
                                        //multiple selectionmode
                                        int iNewItemIndex = (m_MouseSelectedDay.Row * 7) + m_MouseSelectedDay.Cell;
                                        int iOldItemIndex = (m_StartMultiSelectionHover.Row * 7) + m_StartMultiSelectionHover.Cell;
                                        if (iOldItemIndex != iNewItemIndex)
                                        {
                                            SelectedDay myTmpFirstSelDay = m_StartMultiSelectionHover;
                                            SelectedDay myTmpLastSelDay = m_MouseSelectedDay;

                                            //find startcell
                                            if (m_StartMultiSelectionHover.Cell < m_MouseSelectedDay.Cell)
                                            {
                                                myTmpFirstSelDay.Cell = m_StartMultiSelectionHover.Cell;
                                                myTmpLastSelDay.Cell = m_MouseSelectedDay.Cell;
                                            }
                                            else
                                            {
                                                myTmpFirstSelDay.Cell = m_MouseSelectedDay.Cell;
                                                myTmpLastSelDay.Cell = m_StartMultiSelectionHover.Cell;
                                            }
                                            //find startrow
                                            if (m_StartMultiSelectionHover.Row < m_MouseSelectedDay.Row)
                                            {
                                                myTmpFirstSelDay.Row = m_StartMultiSelectionHover.Row;
                                                myTmpLastSelDay.Row = m_MouseSelectedDay.Row;
                                            }
                                            else
                                            {
                                                myTmpFirstSelDay.Row = m_MouseSelectedDay.Row;
                                                myTmpLastSelDay.Row = m_StartMultiSelectionHover.Row;
                                            }
                                            

                                            for (int iRowCounter = myTmpFirstSelDay.Row;
                                                 iRowCounter <= myTmpLastSelDay.Row; iRowCounter++)
                                            {
                                                for (int iCellCounter = myTmpFirstSelDay.Cell;
                                                    iCellCounter <= myTmpLastSelDay.Cell; iCellCounter++)
                                                {
                                                    if ((m_bCanSelectTrailingDates == true &&
                                                        m_WeekDayItems[iCellCounter, iRowCounter].TrailingDay == true) ||
                                                        m_WeekDayItems[iCellCounter, iRowCounter].TrailingDay == false)
                                                    {
                                                        myNewDate = new DateTime(m_WeekDayItems[iCellCounter, iRowCounter].Year,
                                                                                 m_WeekDayItems[iCellCounter, iRowCounter].Month,
                                                                                 m_WeekDayItems[iCellCounter, iRowCounter].Day);
                                                        //add date to selecteditems
                                                        AddSelectedItem(myNewDate);
                                                    }
                                                }
                                            }
                                        }
                                        else
                                        {
                                            if ((m_bCanSelectTrailingDates == true &&
                                                m_WeekDayItems[m_MouseSelectedDay.Cell, m_MouseSelectedDay.Row].TrailingDay == true) ||
                                                m_WeekDayItems[m_MouseSelectedDay.Cell, m_MouseSelectedDay.Row].TrailingDay == false)
                                            {
                                                //multiselectionmode
                                                AddSelectedItem(myNewDate);
                                            }
                                        }
                                    }
                                }
                                break;
                            case ViewMode.vmYear:
                                iSelectedIndex = (m_MouseSelectedDay.Row * 4) + m_MouseSelectedDay.Cell;
                                myNewDate = new DateTime(m_SelectedDate.Year, iSelectedIndex + 1, m_SelectedDate.Day);
                                if (m_SelectionMode != SelectionMode.smNone)
                                {
                                    SelectedDate = myNewDate;
                                }
                                SetViewMode(ViewMode.vmMonth, ViewMode.vmYear);
                                break;
                            case ViewMode.vm12Years:
                                iSelectedIndex = (m_MouseSelectedDay.Row * 4) + m_MouseSelectedDay.Cell;
                                int iNewYear = m_Start12YearsRange + iSelectedIndex;
                                myNewDate = new DateTime(iNewYear, m_SelectedDate.Month, m_SelectedDate.Day);
                                if (m_SelectionMode != SelectionMode.smNone)
                                {
                                    SelectedDate = myNewDate;
                                }
                                SetViewMode(ViewMode.vmYear, ViewMode.vm12Years);
                                break;
                            case ViewMode.vm120Years:
                                iSelectedIndex = (m_MouseSelectedDay.Row * 4) + m_MouseSelectedDay.Cell;
                                iNewYear = m_Start120YearsRange + (iSelectedIndex * 10);
                                m_Start12YearsRange = iNewYear;
                                m_End12YearsRange = iNewYear + 11;
                                SetViewMode(ViewMode.vm12Years, ViewMode.vm120Years);
                                break;
                        }
                    }
                    else if (e.KeyCode == m_KeyboardControl.ZoomOut)
                    {
                        switch (m_ViewMode)
                        {
                            case ViewMode.vmMonth:
                                SetViewMode(ViewMode.vmYear, ViewMode.vmMonth);
                                break;
                            case ViewMode.vmYear:
                                if (m_SelectedDate.Year - 6 >= m_MinDate.Year)
                                    m_Start12YearsRange = m_SelectedDate.Year - 6;
                                else
                                {

                                    m_Start12YearsRange = m_MinDate.Year;
                                }
                                m_End12YearsRange = m_Start12YearsRange + 11;
                                SetViewMode(ViewMode.vm12Years, ViewMode.vmYear);
                                break;
                            case ViewMode.vm12Years:
                                if (m_Start12YearsRange - 60 > m_MinDate.Year)
                                    m_Start120YearsRange = m_Start12YearsRange - 60;
                                else
                                {
                                    m_Start120YearsRange = m_MinDate.Year;
                                }
                                m_End120YearsRange = m_Start120YearsRange + 119;
                                SetViewMode(ViewMode.vm120Years, ViewMode.vm12Years);
                                break;
                        }
                        m_bKeyHandled = true;
                    }
                    else if (e.KeyCode == m_KeyboardControl.Zoomin)
                    {
                        switch (m_ViewMode)
                        {
                            case ViewMode.vm120Years:
                                SetViewMode(ViewMode.vm12Years, ViewMode.vm120Years);
                                break;
                            case ViewMode.vm12Years:
                                SetViewMode(ViewMode.vmYear, ViewMode.vm12Years);
                                break;
                            case ViewMode.vmYear:
                                SetViewMode(ViewMode.vmMonth, ViewMode.vmYear);
                                break;
                        }
                    }
                    else if (e.KeyCode == m_KeyboardControl.GoToday)
                    {
                        SelectToday();
                        m_bKeyHandled = true;
                    }
                    else if (e.KeyCode == m_KeyboardControl.NavNext)
                    {
                        NextClick(this, EventArgs.Empty);
                        m_bKeyHandled = true;
                    }
                    else if (e.KeyCode == m_KeyboardControl.NavPrev)
                    {
                        PrevClick(this, EventArgs.Empty);
                        m_bKeyHandled = true;
                    }
                    else if (e.KeyCode == m_KeyboardControl.NextMonth)
                    {
                        switch (m_ViewMode)
                        {
                            case ViewMode.vmMonth:
                                SelectNextMonth();
                                m_bKeyHandled = true;
                                break;
                        }
                    }
                    else if (e.KeyCode == m_KeyboardControl.PrevMonth)
                    {
                        switch (m_ViewMode)
                        {
                            case ViewMode.vmMonth:
                                SelectPreviousMonth();
                                m_bKeyHandled = true;
                                break;
                        }
                    }
                    else if (e.KeyCode == m_KeyboardControl.NextYear)
                    {
                        switch (m_ViewMode)
                        {
                            case ViewMode.vmMonth:
                                SelectNextYear();
                                m_bKeyHandled = true;
                                break;
                        }
                    }
                    else if (e.KeyCode == m_KeyboardControl.PrevYear)
                    {
                        switch (m_ViewMode)
                        {
                            case ViewMode.vmMonth:
                                SelectPreviousYear();
                                m_bKeyHandled = true;
                                break;
                        }
                    }
                }

            }
        }

        #endregion

        #region properties changed
        internal void OnHeaderChanged()
        {
            if (m_bInitialised == true)
                if (HeaderChanged != null) HeaderChanged(this, EventArgs.Empty);
        }

        internal void OnFooterChanged()
        {
            if (m_bInitialised == true)
                if (FooterChanged != null) FooterChanged(this, EventArgs.Empty);
        }

        internal void OnWeekDaysChanged()
        {
            if (m_bInitialised == true)
                if (WeekDaysChanged != null) WeekDaysChanged(this, EventArgs.Empty);
        }

        internal void OnWeekNumbersChanged()
        {
            if (m_bInitialised == true)
                if (WeekNumbersChanged != null) WeekNumbersChanged(this, EventArgs.Empty);
        }

        internal void OnMonthDaysChanged()
        {
            if (m_bInitialised == true)
                if (MonthDaysChanged != null) MonthDaysChanged(this, EventArgs.Empty);
        }

        internal void OnKeyboardChange()
        {
            if (m_bInitialised == true)
                if (KeyboardChanged != null) KeyboardChanged(this, EventArgs.Empty);
        }

        internal void OnMonthImagesChange()
        {
            if (m_bInitialised == true)
                if (MonthImagesChanged != null) MonthImagesChanged(this, EventArgs.Empty);
        }

        internal void OnBorderChanged()
        {
            if (m_bInitialised == true)
            {
                if (BorderChanged != null) BorderChanged(this, EventArgs.Empty);
                Invalidate();
            }
        }

        internal void OnDatesChange()
        {
            //dates changed
            //if (DatesChanged != null) DatesChanged(this, EventArgs.Empty);
        }
        #endregion

        protected override void OnClick(EventArgs e)
        {
            base.OnClick(e);
            this.Focus();
            m_bMouseHover = true;
            Invalidate();
        }
    }
}
