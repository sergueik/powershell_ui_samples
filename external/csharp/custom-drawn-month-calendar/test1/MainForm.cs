/*
 * Erstellt mit SharpDevelop.
 * Benutzer: matthias
 * Datum: 07.05.2007
 * Zeit: 11:34
 * 
 * Sie können diese Vorlage unter Extras > Optionen > Codeerstellung > Standardheader ändern.
 */

using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;

namespace test1
{
	/// <summary>
	/// Description of MainForm.
	/// </summary>
	public partial class MainForm : Form
	{
		[STAThread]
		public static void Main(string[] args)
		{
			Application.EnableVisualStyles();
			Application.SetCompatibleTextRenderingDefault(false);
			Application.Run(new MainForm());
		}
		
		public MainForm()
		{
			//
			// The InitializeComponent() call is required for Windows Forms designer support.
			//
			InitializeComponent();
			
			//
			// TODO: Add constructor code after the InitializeComponent() call.
			//
		}

        private void MainForm_Load(object sender, EventArgs e)
        {
            propertyGrid1.SelectedObject = calendar1;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            //calendar1.FirstDayOfWeek = Day.Sunday;
        }

        private void calendar1_DateSelected(object sender, EventArgs e)
        {
            //MessageBox.Show("gewähltes Datum " + calendar1.SelectedDate.ToString("d. MMMM yyyy"));
        }

        private void calendar1_ZoomIn(object sender, MonthCalendar.ZoomEventArgs e)
        {
            //MessageBox.Show("Zoomin");
        }

        private void calendar1_ZoomOut(object sender, MonthCalendar.ZoomEventArgs e)
        {
            //MessageBox.Show("ZoomOut");
            
        }

        private void calendar1_CanZoomIn(object sender, MonthCalendar.CanZoomEventArgs e)
        {

        }

        private void calendar1_CanZoomOut(object sender, MonthCalendar.CanZoomEventArgs e)
        {
            
        }

        private void calendar1_MonthImageRender(object sender, MonthCalendar.MonthImageRenderEventArgs e)
        {
            //e.OwnerDraw = true;
            
        }

        private void calendar1_HeaderRender(object sender, MonthCalendar.HeaderRenderEventArgs e)
        {
            //e.OwnerDraw = true;
        }

        private void calendar1_WeekNumberRender(object sender, MonthCalendar.WeeknumberRenderEventArgs e)
        {
            //e.OwnerDraw = true;
        }

        private void calendar1_WeekDayRender(object sender, MonthCalendar.WeekDayRenderEventArgs e)
        {
            //e.OwnerDraw = true;
        }

        private void calendar1_WeekDayBackgroundRender(object sender, MonthCalendar.WeekDayBackgroundRenderEventArgs e)
        {
            //e.OwnerDraw = true;
        }

        private void calendar1_MonthDayRender(object sender, MonthCalendar.MonthDayRenderEventArgs e)
        {
            //e.OwnerDraw = true;
        }

        private void calendar1_FooterRender(object sender, MonthCalendar.FooterRenderEventArgs e)
        {
            //e.OwnerDraw = true;
        }

        private void calendar1_MonthRender(object sender, MonthCalendar.MonthRenderEventArgs e)
        {
            //e.OwnerDraw = true;
        }

        private void calendar1_YearRender(object sender, MonthCalendar.YearRenderEventArgs e)
        {
            //e.OwnerDraw = true;
        }

        private void calendar1_YearsGroupRender(object sender, MonthCalendar.YearGroupRenderEventArgs e)
        {
            //e.OwnerDraw = true;
        }

        private void calendar1_WeekNumbersBackgroundRender(object sender, MonthCalendar.WeekNumbersBackgroundRenderEventArgs e)
        {
            //e.OwnerDraw = true;
        }

        private void calendar1_SelectionStart(object sender, EventArgs e)
        {
            //MessageBox.Show("StartMultiselektion");
        }

        private void calendar1_SelectionEnd(object sender, EventArgs e)
        {
            //MessageBox.Show("EndMultiselektion");
        }

        private void calendar1_KeyboardChanged(object sender, EventArgs e)
        {
            //MessageBox.Show("KeyboardChanged");
        }

        private void calendar1_MonthImagesChanged(object sender, EventArgs e)
        {
            //MessageBox.Show("MonthImagesChanged");
        }

        private void calendar1_HeaderChanged(object sender, EventArgs e)
        {
            //MessageBox.Show("HeaderChanged");
        }

        private void calendar1_FooterChanged(object sender, EventArgs e)
        {
            //MessageBox.Show("FooterChanged");
        }

        private void calendar1_WeekDaysChanged(object sender, EventArgs e)
        {
            //MessageBox.Show("WeekDaysChanged");
        }

        private void calendar1_WeekNumbersChanged(object sender, EventArgs e)
        {
            //MessageBox.Show("Weeknumberschanged");
        }

        private void calendar1_MonthDaysChanged(object sender, EventArgs e)
        {
            //MessageBox.Show("MonthDaysChanged");
        }

        private void calendar1_EnableMultiSelectionMode(object sender, EventArgs e)
        {
            //MessageBox.Show("EnableMultiSelectionMode");
        }

        private void calendar1_DisableMultiSelectionMode(object sender, EventArgs e)
        {
            //MessageBox.Show("DisableMultiSelectionMode");
        }

        private void calendar1_HeaderClick(object sender, EventArgs e)
        {
            //MessageBox.Show("HeaderClick");
        }

        private void calendar1_CanSelectTrailingDatesChanged(object sender, EventArgs e)
        {
            //MessageBox.Show("CanSelectTrailingDatesChanged");
        }

        private void calendar1_CultureChanged(object sender, EventArgs e)
        {
            //MessageBox.Show("CultureChanged");
        }

        private void calendar1_DatesChanged(object sender, EventArgs e)
        {
            //MessageBox.Show("DAtesChanged");
        }

        private void calendar1_FirstDayOfWeekChanged(object sender, EventArgs e)
        {
            //MessageBox.Show("FirstWeekDayChanged");
        }

        private void calendar1_MaxDateChanged(object sender, EventArgs e)
        {
            //MessageBox.Show("MaxDateChanged");
        }

        private void calendar1_MinDateChanged(object sender, EventArgs e)
        {
            //MessageBox.Show("MinDateChanged");
        }

        private void calendar1_OnlyMonthModeChanged(object sender, EventArgs e)
        {
            //MessageBox.Show("OnlyMOnthModeChanged");
        }

        private void calendar1_SelectionModeChanged(object sender, EventArgs e)
        {
            //MessageBox.Show("SelectionModeChanged");
        }

        private void calendar1_BorderChanged(object sender, EventArgs e)
        {
            //MessageBox.Show("Borderchanged");
        }
	}
}
