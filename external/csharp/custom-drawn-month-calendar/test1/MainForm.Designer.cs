/*
 * Erstellt mit SharpDevelop.
 * Benutzer: matthias
 * Datum: 07.05.2007
 * Zeit: 11:34
 * 
 * Sie können diese Vorlage unter Extras > Optionen > Codeerstellung > Standardheader ändern.
 */
namespace test1
{
	partial class MainForm
	{
		/// <summary>
		/// Designer variable used to keep track of non-visual components.
		/// </summary>
		private System.ComponentModel.IContainer components = null;
		
		/// <summary>
		/// Disposes resources used by the form.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing) {
				if (components != null) {
					components.Dispose();
				}
			}
			base.Dispose(disposing);
		}
		
		/// <summary>
		/// This method is required for Windows Forms designer support.
		/// Do not change the method contents inside the source code editor. The Forms designer might
		/// not be able to load this method if it was changed manually.
		/// </summary>
		private void InitializeComponent()
		{
			this.components = new System.ComponentModel.Container();
			System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
			this.imageList1 = new System.Windows.Forms.ImageList(this.components);
			this.propertyGrid1 = new System.Windows.Forms.PropertyGrid();
			this.calendar1 = new MonthCalendar.Calendar();
			this.dateItem1 = new MonthCalendar.DateItem();
			this.SuspendLayout();
			// 
			// imageList1
			// 
			this.imageList1.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("imageList1.ImageStream")));
			this.imageList1.TransparentColor = System.Drawing.Color.Olive;
			this.imageList1.Images.SetKeyName(0, "Bild1.bmp");
			this.imageList1.Images.SetKeyName(1, "Bild2.bmp");
			this.imageList1.Images.SetKeyName(2, "Bild3.bmp");
			this.imageList1.Images.SetKeyName(3, "Bild4.bmp");
			this.imageList1.Images.SetKeyName(4, "Bild5.bmp");
			this.imageList1.Images.SetKeyName(5, "Bild6.bmp");
			this.imageList1.Images.SetKeyName(6, "Bild7.bmp");
			this.imageList1.Images.SetKeyName(7, "Bild8.png");
			// 
			// propertyGrid1
			// 
			this.propertyGrid1.Location = new System.Drawing.Point(12, 10);
			this.propertyGrid1.Name = "propertyGrid1";
			this.propertyGrid1.Size = new System.Drawing.Size(191, 276);
			this.propertyGrid1.TabIndex = 1;
			// 
			// calendar1
			// 
			this.calendar1.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
			this.calendar1.Border.BorderColor = System.Drawing.Color.Black;
			this.calendar1.Border.Parent = this.calendar1;
			this.calendar1.Border.Transparency = 255;
			this.calendar1.Border.Visible = true;
			this.calendar1.CanSelectTrailingDates = true;
			this.calendar1.Culture = new System.Globalization.CultureInfo("de-DE");
			this.calendar1.Dates.AddRange(new MonthCalendar.DateItem[] {
									this.dateItem1});
			this.calendar1.FirstDayOfWeek = System.Windows.Forms.Day.Default;
			this.calendar1.Footer.Align = MonthCalendar.HeaderAlign.Left;
			this.calendar1.Footer.Background.EndColor = System.Drawing.Color.Black;
			this.calendar1.Footer.Background.Gradient = MonthCalendar.GradientStyle.Vertical;
			this.calendar1.Footer.Background.Parent = this.calendar1.Footer;
			this.calendar1.Footer.Background.StartColor = System.Drawing.Color.White;
			this.calendar1.Footer.Background.Style = MonthCalendar.EStyle.esParent;
			this.calendar1.Footer.Background.TransparencyEndColor = 255;
			this.calendar1.Footer.Background.TransparencyStartColor = 255;
			this.calendar1.Footer.Border.BorderColor = System.Drawing.Color.White;
			this.calendar1.Footer.Border.Parent = this.calendar1.Footer;
			this.calendar1.Footer.Border.Transparency = 255;
			this.calendar1.Footer.Border.Visible = false;
			this.calendar1.Footer.DateFormat = MonthCalendar.DateFormat.Long;
			this.calendar1.Footer.Font = new System.Drawing.Font("Tahoma", 9F);
			this.calendar1.Footer.ForeColor = System.Drawing.Color.Blue;
			this.calendar1.Footer.Padding = new System.Windows.Forms.Padding(18, 0, 20, 0);
			this.calendar1.Footer.Text = "Heute";
			this.calendar1.Footer.TextTransparency = 255;
			this.calendar1.Footer.Visible = true;
			this.calendar1.Header.Align = MonthCalendar.HeaderAlign.Center;
			this.calendar1.Header.Background.EndColor = System.Drawing.Color.Black;
			this.calendar1.Header.Background.Gradient = MonthCalendar.GradientStyle.Vertical;
			this.calendar1.Header.Background.Parent = this.calendar1.Header;
			this.calendar1.Header.Background.StartColor = System.Drawing.Color.White;
			this.calendar1.Header.Background.Style = MonthCalendar.EStyle.esTransparent;
			this.calendar1.Header.Background.TransparencyEndColor = 255;
			this.calendar1.Header.Background.TransparencyStartColor = 255;
			this.calendar1.Header.Border.BorderColor = System.Drawing.Color.Black;
			this.calendar1.Header.Border.Parent = this.calendar1.Header;
			this.calendar1.Header.Border.Transparency = 255;
			this.calendar1.Header.Border.Visible = false;
			this.calendar1.Header.Font = new System.Drawing.Font("Segoe UI", 8.25F);
			this.calendar1.Header.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(155)))), ((int)(((byte)(155)))));
			this.calendar1.Header.HoverColor = System.Drawing.Color.DarkGray;
			this.calendar1.Header.Padding.Horizontal = 10;
			this.calendar1.Header.Padding.Vertical = 6;
			this.calendar1.Header.ShowNav = true;
			this.calendar1.Header.TextTransparency = 255;
			this.calendar1.Header.Visible = true;
			this.calendar1.ImageList = this.imageList1;
			this.calendar1.Keyboard.AllowKeyboardSteering = true;
			this.calendar1.Keyboard.Down = System.Windows.Forms.Keys.Down;
			this.calendar1.Keyboard.GoToday = System.Windows.Forms.Keys.F12;
			this.calendar1.Keyboard.Left = System.Windows.Forms.Keys.Left;
			this.calendar1.Keyboard.MultipleSelection = MonthCalendar.ExtendedSelection.Ctrl;
			this.calendar1.Keyboard.NavNext = System.Windows.Forms.Keys.Insert;
			this.calendar1.Keyboard.NavPrev = System.Windows.Forms.Keys.Delete;
			this.calendar1.Keyboard.NextMonth = System.Windows.Forms.Keys.Home;
			this.calendar1.Keyboard.NextYear = System.Windows.Forms.Keys.PageUp;
			this.calendar1.Keyboard.PrevMonth = System.Windows.Forms.Keys.End;
			this.calendar1.Keyboard.PrevYear = System.Windows.Forms.Keys.Next;
			this.calendar1.Keyboard.Right = System.Windows.Forms.Keys.Right;
			this.calendar1.Keyboard.Select = System.Windows.Forms.Keys.Space;
			this.calendar1.Keyboard.Up = System.Windows.Forms.Keys.Up;
			this.calendar1.Keyboard.Zoomin = System.Windows.Forms.Keys.Subtract;
			this.calendar1.Keyboard.ZoomOut = System.Windows.Forms.Keys.Add;
			this.calendar1.Location = new System.Drawing.Point(247, 10);
			this.calendar1.MaxDate = new System.DateTime(9998, 12, 31, 0, 0, 0, 0);
			this.calendar1.MinDate = new System.DateTime(1753, 1, 1, 0, 0, 0, 0);
			this.calendar1.MonthDays.Align = System.Drawing.ContentAlignment.MiddleCenter;
			this.calendar1.MonthDays.Background.EndColor = System.Drawing.Color.Black;
			this.calendar1.MonthDays.Background.Gradient = MonthCalendar.GradientStyle.Vertical;
			this.calendar1.MonthDays.Background.Parent = this.calendar1.MonthDays;
			this.calendar1.MonthDays.Background.StartColor = System.Drawing.Color.White;
			this.calendar1.MonthDays.Background.Style = MonthCalendar.EStyle.esTransparent;
			this.calendar1.MonthDays.Background.TransparencyEndColor = 255;
			this.calendar1.MonthDays.Background.TransparencyStartColor = 255;
			this.calendar1.MonthDays.Border.BorderColor = System.Drawing.Color.Black;
			this.calendar1.MonthDays.Border.Parent = this.calendar1.MonthDays;
			this.calendar1.MonthDays.Border.Transparency = 255;
			this.calendar1.MonthDays.Border.Visible = false;
			this.calendar1.MonthDays.DaysPadding.Horizontal = 2;
			this.calendar1.MonthDays.DaysPadding.Vertical = 2;
			this.calendar1.MonthDays.Font = new System.Drawing.Font("Tahoma", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.calendar1.MonthDays.ForeColor = System.Drawing.Color.Black;
			this.calendar1.MonthDays.HoverStyle.Background.EndColor = System.Drawing.Color.Black;
			this.calendar1.MonthDays.HoverStyle.Background.Gradient = MonthCalendar.GradientStyle.Vertical;
			this.calendar1.MonthDays.HoverStyle.Background.Parent = this.calendar1.MonthDays.HoverStyle;
			this.calendar1.MonthDays.HoverStyle.Background.StartColor = System.Drawing.Color.Blue;
			this.calendar1.MonthDays.HoverStyle.Background.Style = MonthCalendar.EStyle.esColor;
			this.calendar1.MonthDays.HoverStyle.Background.TransparencyEndColor = 255;
			this.calendar1.MonthDays.HoverStyle.Background.TransparencyStartColor = 30;
			this.calendar1.MonthDays.HoverStyle.Border.BorderColor = System.Drawing.Color.DarkBlue;
			this.calendar1.MonthDays.HoverStyle.Border.Parent = this.calendar1.MonthDays.HoverStyle;
			this.calendar1.MonthDays.HoverStyle.Border.Transparency = 128;
			this.calendar1.MonthDays.HoverStyle.Border.Visible = true;
			this.calendar1.MonthDays.MarkHover = true;
			this.calendar1.MonthDays.MarkSaturday = true;
			this.calendar1.MonthDays.MarkSelectedDay = true;
			this.calendar1.MonthDays.MarkSunday = true;
			this.calendar1.MonthDays.MarkToday = true;
			this.calendar1.MonthDays.Padding = new System.Windows.Forms.Padding(2);
			this.calendar1.MonthDays.SaturdayColor = System.Drawing.Color.DarkGoldenrod;
			this.calendar1.MonthDays.SelectedDay.Background.EndColor = System.Drawing.Color.Black;
			this.calendar1.MonthDays.SelectedDay.Background.Gradient = MonthCalendar.GradientStyle.Vertical;
			this.calendar1.MonthDays.SelectedDay.Background.Parent = this.calendar1.MonthDays.SelectedDay;
			this.calendar1.MonthDays.SelectedDay.Background.StartColor = System.Drawing.Color.FromArgb(((int)(((byte)(230)))), ((int)(((byte)(222)))), ((int)(((byte)(185)))));
			this.calendar1.MonthDays.SelectedDay.Background.Style = MonthCalendar.EStyle.esColor;
			this.calendar1.MonthDays.SelectedDay.Background.TransparencyEndColor = 255;
			this.calendar1.MonthDays.SelectedDay.Background.TransparencyStartColor = 255;
			this.calendar1.MonthDays.SelectedDay.Border.BorderColor = System.Drawing.Color.White;
			this.calendar1.MonthDays.SelectedDay.Border.Parent = this.calendar1.MonthDays.SelectedDay;
			this.calendar1.MonthDays.SelectedDay.Border.Transparency = 255;
			this.calendar1.MonthDays.SelectedDay.Border.Visible = false;
			this.calendar1.MonthDays.SelectedDay.Font = new System.Drawing.Font("Tahoma", 9F);
			this.calendar1.MonthDays.SelectedDay.ForeColor = System.Drawing.Color.Black;
			this.calendar1.MonthDays.ShowTrailingDays = true;
			this.calendar1.MonthDays.SundayColor = System.Drawing.Color.Red;
			this.calendar1.MonthDays.TextTransparency = 255;
			this.calendar1.MonthDays.TodayColor = System.Drawing.Color.Blue;
			this.calendar1.MonthDays.TrailingDays.Background.EndColor = System.Drawing.Color.Black;
			this.calendar1.MonthDays.TrailingDays.Background.Gradient = MonthCalendar.GradientStyle.Vertical;
			this.calendar1.MonthDays.TrailingDays.Background.Parent = this.calendar1.MonthDays.TrailingDays;
			this.calendar1.MonthDays.TrailingDays.Background.StartColor = System.Drawing.Color.White;
			this.calendar1.MonthDays.TrailingDays.Background.Style = MonthCalendar.EStyle.esTransparent;
			this.calendar1.MonthDays.TrailingDays.Background.TransparencyEndColor = 255;
			this.calendar1.MonthDays.TrailingDays.Background.TransparencyStartColor = 255;
			this.calendar1.MonthDays.TrailingDays.Border.BorderColor = System.Drawing.Color.White;
			this.calendar1.MonthDays.TrailingDays.Border.Parent = this.calendar1.MonthDays.TrailingDays;
			this.calendar1.MonthDays.TrailingDays.Border.Transparency = 255;
			this.calendar1.MonthDays.TrailingDays.Border.Visible = false;
			this.calendar1.MonthDays.TrailingDays.Font = new System.Drawing.Font("Tahoma", 9F);
			this.calendar1.MonthDays.TrailingDays.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(140)))), ((int)(((byte)(140)))), ((int)(((byte)(140)))));
			this.calendar1.MonthImages.AprilImage = ((System.Drawing.Image)(resources.GetObject("calendar1.MonthImages.AprilImage")));
			this.calendar1.MonthImages.AugustImage = ((System.Drawing.Image)(resources.GetObject("calendar1.MonthImages.AugustImage")));
			this.calendar1.MonthImages.DecemberImage = ((System.Drawing.Image)(resources.GetObject("calendar1.MonthImages.DecemberImage")));
			this.calendar1.MonthImages.FebruaryImage = ((System.Drawing.Image)(resources.GetObject("calendar1.MonthImages.FebruaryImage")));
			this.calendar1.MonthImages.ImagePosition = MonthCalendar.MonthImagePosition.Top;
			this.calendar1.MonthImages.ImagesHeight = 68;
			this.calendar1.MonthImages.JanuaryImage = ((System.Drawing.Image)(resources.GetObject("calendar1.MonthImages.JanuaryImage")));
			this.calendar1.MonthImages.JulyImage = ((System.Drawing.Image)(resources.GetObject("calendar1.MonthImages.JulyImage")));
			this.calendar1.MonthImages.JuneImage = ((System.Drawing.Image)(resources.GetObject("calendar1.MonthImages.JuneImage")));
			this.calendar1.MonthImages.MarchImage = ((System.Drawing.Image)(resources.GetObject("calendar1.MonthImages.MarchImage")));
			this.calendar1.MonthImages.MayImage = ((System.Drawing.Image)(resources.GetObject("calendar1.MonthImages.MayImage")));
			this.calendar1.MonthImages.NovemberImage = ((System.Drawing.Image)(resources.GetObject("calendar1.MonthImages.NovemberImage")));
			this.calendar1.MonthImages.OctoberImage = ((System.Drawing.Image)(resources.GetObject("calendar1.MonthImages.OctoberImage")));
			this.calendar1.MonthImages.SeptemberImage = ((System.Drawing.Image)(resources.GetObject("calendar1.MonthImages.SeptemberImage")));
			this.calendar1.MonthImages.UseImages = true;
			this.calendar1.Name = "calendar1";
			this.calendar1.OnlyMonthMode = false;
			this.calendar1.SelectedDate = new System.DateTime(2007, 6, 20, 0, 0, 0, 0);
			this.calendar1.SelectionMode = MonthCalendar.SelectionMode.smMulti;
			this.calendar1.Size = new System.Drawing.Size(321, 300);
			this.calendar1.StartWithZoom = MonthCalendar.ViewMode.vmMonth;
			this.calendar1.TabIndex = 2;
			this.calendar1.WeekDays.Align = MonthCalendar.HeaderAlign.Center;
			this.calendar1.WeekDays.Background.EndColor = System.Drawing.Color.Black;
			this.calendar1.WeekDays.Background.Gradient = MonthCalendar.GradientStyle.Vertical;
			this.calendar1.WeekDays.Background.Parent = this.calendar1.WeekDays;
			this.calendar1.WeekDays.Background.StartColor = System.Drawing.Color.Maroon;
			this.calendar1.WeekDays.Background.Style = MonthCalendar.EStyle.esColor;
			this.calendar1.WeekDays.Background.TransparencyEndColor = 255;
			this.calendar1.WeekDays.Background.TransparencyStartColor = 255;
			this.calendar1.WeekDays.Border.BorderColor = System.Drawing.Color.Black;
			this.calendar1.WeekDays.Border.Parent = this.calendar1.WeekDays;
			this.calendar1.WeekDays.Border.Transparency = 255;
			this.calendar1.WeekDays.Border.Visible = true;
			this.calendar1.WeekDays.Font = new System.Drawing.Font("Segoe UI", 8.25F);
			this.calendar1.WeekDays.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(155)))), ((int)(((byte)(155)))));
			this.calendar1.WeekDays.TextTransparency = 255;
			this.calendar1.WeekDays.Visible = true;
			this.calendar1.Weeknumbers.Align = MonthCalendar.WeekNumberAlign.Center;
			this.calendar1.Weeknumbers.Background.EndColor = System.Drawing.Color.Black;
			this.calendar1.Weeknumbers.Background.Gradient = MonthCalendar.GradientStyle.Vertical;
			this.calendar1.Weeknumbers.Background.Parent = this.calendar1.Weeknumbers;
			this.calendar1.Weeknumbers.Background.StartColor = System.Drawing.Color.Maroon;
			this.calendar1.Weeknumbers.Background.Style = MonthCalendar.EStyle.esColor;
			this.calendar1.Weeknumbers.Background.TransparencyEndColor = 255;
			this.calendar1.Weeknumbers.Background.TransparencyStartColor = 255;
			this.calendar1.Weeknumbers.Border.BorderColor = System.Drawing.Color.Black;
			this.calendar1.Weeknumbers.Border.Parent = this.calendar1.Weeknumbers;
			this.calendar1.Weeknumbers.Border.Transparency = 255;
			this.calendar1.Weeknumbers.Border.Visible = true;
			this.calendar1.Weeknumbers.Font = new System.Drawing.Font("Segoe UI", 8.25F);
			this.calendar1.Weeknumbers.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(155)))), ((int)(((byte)(155)))), ((int)(((byte)(155)))));
			this.calendar1.Weeknumbers.Padding = 5;
			this.calendar1.Weeknumbers.TextTransparency = 255;
			this.calendar1.Weeknumbers.Visible = true;
			this.calendar1.OnlyMonthModeChanged += new System.EventHandler(this.calendar1_OnlyMonthModeChanged);
			this.calendar1.YearsGroupRender += new MonthCalendar.YearGroupRenderEventHandler(this.calendar1_YearsGroupRender);
			this.calendar1.MonthImagesChanged += new System.EventHandler(this.calendar1_MonthImagesChanged);
			this.calendar1.SelectionStart += new System.EventHandler(this.calendar1_SelectionStart);
			this.calendar1.KeyboardChanged += new System.EventHandler(this.calendar1_KeyboardChanged);
			this.calendar1.MonthDaysChanged += new System.EventHandler(this.calendar1_MonthDaysChanged);
			this.calendar1.ZoomOut += new MonthCalendar.ZoomEventHandler(this.calendar1_ZoomOut);
			this.calendar1.HeaderChanged += new System.EventHandler(this.calendar1_HeaderChanged);
			this.calendar1.CanZoomOut += new MonthCalendar.CanZoomEventHandler(this.calendar1_CanZoomOut);
			this.calendar1.MonthImageRender += new MonthCalendar.MonthImageRenderEventHandler(this.calendar1_MonthImageRender);
			this.calendar1.MinDateChanged += new System.EventHandler(this.calendar1_MinDateChanged);
			this.calendar1.BorderChanged += new System.EventHandler(this.calendar1_BorderChanged);
			this.calendar1.SelectionEnd += new System.EventHandler(this.calendar1_SelectionEnd);
			this.calendar1.WeekDaysChanged += new System.EventHandler(this.calendar1_WeekDaysChanged);
			this.calendar1.SelectionModeChanged += new System.EventHandler(this.calendar1_SelectionModeChanged);
			this.calendar1.WeekNumberRender += new MonthCalendar.WeekNumberRenderEventHandler(this.calendar1_WeekNumberRender);
			this.calendar1.WeekDayRender += new MonthCalendar.WeekDayRenderEventHandler(this.calendar1_WeekDayRender);
			this.calendar1.FirstDayOfWeekChanged += new System.EventHandler(this.calendar1_FirstDayOfWeekChanged);
			this.calendar1.EnableMultiSelectionMode += new System.EventHandler(this.calendar1_EnableMultiSelectionMode);
			this.calendar1.CanSelectTrailingDatesChanged += new System.EventHandler(this.calendar1_CanSelectTrailingDatesChanged);
			this.calendar1.MonthDayRender += new MonthCalendar.MonthDayRenderEventHandler(this.calendar1_MonthDayRender);
			this.calendar1.FooterChanged += new System.EventHandler(this.calendar1_FooterChanged);
			this.calendar1.YearRender += new MonthCalendar.YearRenderEventHandler(this.calendar1_YearRender);
			this.calendar1.WeekNumbersBackgroundRender += new MonthCalendar.WeekNumbersBackgroundEventHandler(this.calendar1_WeekNumbersBackgroundRender);
			this.calendar1.HeaderClick += new System.EventHandler(this.calendar1_HeaderClick);
			this.calendar1.CanZoomIn += new MonthCalendar.CanZoomEventHandler(this.calendar1_CanZoomIn);
			this.calendar1.DisableMultiSelectionMode += new System.EventHandler(this.calendar1_DisableMultiSelectionMode);
			this.calendar1.FooterRender += new MonthCalendar.FooterRenverEventHandler(this.calendar1_FooterRender);
			this.calendar1.WeekDayBackgroundRender += new MonthCalendar.WeekDayBackgroundEventHandler(this.calendar1_WeekDayBackgroundRender);
			this.calendar1.CultureChanged += new System.EventHandler(this.calendar1_CultureChanged);
			this.calendar1.MonthRender += new MonthCalendar.MonthRenderEventHandler(this.calendar1_MonthRender);
			this.calendar1.MaxDateChanged += new System.EventHandler(this.calendar1_MaxDateChanged);
			this.calendar1.ZoomIn += new MonthCalendar.ZoomEventHandler(this.calendar1_ZoomIn);
			this.calendar1.WeekNumbersChanged += new System.EventHandler(this.calendar1_WeekNumbersChanged);
			this.calendar1.HeaderRender += new MonthCalendar.HeaderRenderEventHandler(this.calendar1_HeaderRender);
			// 
			// dateItem1
			// 
			this.dateItem1.Background.EndColor = System.Drawing.Color.Black;
			this.dateItem1.Background.Gradient = MonthCalendar.GradientStyle.Vertical;
			this.dateItem1.Background.Parent = this.calendar1;
			this.dateItem1.Background.StartColor = System.Drawing.Color.White;
			this.dateItem1.Background.Style = MonthCalendar.EStyle.esTransparent;
			this.dateItem1.Background.TransparencyEndColor = 255;
			this.dateItem1.Background.TransparencyStartColor = 255;
			this.dateItem1.BackgroundImage = null;
			this.dateItem1.Border.BorderColor = System.Drawing.Color.White;
			this.dateItem1.Border.Parent = this.calendar1;
			this.dateItem1.Border.Transparency = 255;
			this.dateItem1.Border.Visible = false;
			this.dateItem1.Calendar = this.calendar1;
			this.dateItem1.Date = new System.DateTime(2007, 6, 21, 0, 0, 0, 0);
			this.dateItem1.DayAlign = System.Drawing.ContentAlignment.TopRight;
			this.dateItem1.Enabled = true;
			this.dateItem1.Font = new System.Drawing.Font("Tahoma", 9F);
			this.dateItem1.ForeColor = System.Drawing.Color.Black;
			this.dateItem1.Image = null;
			this.dateItem1.ImageAlign = System.Drawing.ContentAlignment.TopLeft;
			this.dateItem1.ImageIndex = 1;
			this.dateItem1.Padding = new System.Windows.Forms.Padding(2);
			this.dateItem1.Range = new System.DateTime(2007, 6, 21, 0, 0, 0, 0);
			this.dateItem1.Reccurence = MonthCalendar.DateItemReccurence.None;
			this.dateItem1.Text = "test";
			this.dateItem1.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
			// 
			// MainForm
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(687, 331);
			this.Controls.Add(this.calendar1);
			this.Controls.Add(this.propertyGrid1);
			this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
			this.MaximizeBox = false;
			this.MinimizeBox = false;
			this.Name = "MainForm";
			this.Text = "test1";
			this.Load += new System.EventHandler(this.MainForm_Load);
			this.ResumeLayout(false);
        }
        private System.Windows.Forms.ImageList imageList1;
        private System.Windows.Forms.PropertyGrid propertyGrid1;
        private MonthCalendar.Calendar calendar1;
        private MonthCalendar.DateItem dateItem1;
	}
}
