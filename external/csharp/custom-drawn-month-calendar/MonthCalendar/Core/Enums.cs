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
    public enum GradientStyle
    {
        Vertical,
        Horizontal,
        ForwardDiagonal,
        BackwardDiagonal
    }

    public enum EStyle
    {
        esColor,
        esTransparent,
        esParent,
        esGradient
    }

    public enum NavigationPos
    {
        npLeft,
        npRight
    }

    public enum ViewMode
    {
        vmMonth,
        vmYear,
        vm12Years,
        vm120Years
    }

    public enum HeaderAlign
    {
        Left,
        Center,
        Right
    }

    public enum WeekNumberAlign
    {
        Top,
        Center,
        Bottom
    }

    public struct SelectedDay
    {
        public int Row;
        public int Cell;
    }

    public struct WeekDayItem
    {
        public int Year;
        public int Month;
        public int Day;
        public bool TrailingDay;
        public DayOfWeek WeekDay;
    }

    public enum MonthImagePosition
    {
        Top,
        CalendarBackground,
        MonthBackground
    }

    public enum DateItemReccurence
    {
        None,
        Daily,
        Weekly,
        Monthly,
        Yearly
    }

    public enum SelectionMode
    {
        smNone,
        smOne,
        smMulti
    }

    public enum ExtendedSelection
    {
        None,
        Shift,
        Ctrl,
        Alt
    }

    public enum DateFormat
    {
        Short,
        Long
    }
}
