using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Drawing;
using System.Windows.Interop;
using System.Media;
using System.Globalization;
using System.Windows.Threading;

namespace MsgBoxEx
{
	// The MessageBoxEx class we getting kinda crowded, so I took advantage of the fact that it's a 
	// partial class, and segregated the static from the non-static. The code looks less chatotic 
	// and is easier to maintain as a result.

	/// <summary>
	/// Non-static interaction logic for MessageBoxEx.xaml
	/// </summary>
	public partial class MessageBoxEx : Window, INotifyPropertyChanged
	{
		#region INotifyPropertyChanged

		private bool isModified = false;
		public bool IsModified { get { return this.isModified; } set { if (value != this.isModified) { this.isModified = true; this.NotifyPropertyChanged(); } } }
		/// <summary>
		/// Occurs when a property value changes.
		/// </summary>
		public event PropertyChangedEventHandler PropertyChanged;

		/// <summary>
		/// Notifies that the property changed, and sets IsModified to true.
		/// </summary>
		/// <param name="propertyName">Name of the property.</param>
        protected void NotifyPropertyChanged([CallerMemberName] String propertyName = "")
        {
            if (this.PropertyChanged != null)
            {
                this.PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
				if (propertyName != "IsModified")
				{
					this.IsModified = true;
				}
            }
        }
	
		#endregion INotifyPropertyChanged

		private const string _DEFAULT_CAPTION = "Application Message";

		#region fields

		private double            screenHeight;
		private string            message;
		private string            messageTitle;
		private MessageBoxButton  buttons;
		private MessageBoxResult  messageResult;
		private ImageSource       messageIcon;
		private MessageBoxImage   msgBoxImage;
		private double            buttonWidth = 0d;
		private bool              expanded = false;

		#endregion fields

		#region properties

		/// <summary>
		/// Get/set the screen's work area height
		/// </summary>
		public double            ScreenHeight       { get { return this.screenHeight;     } set { if (value != this.screenHeight    ) { this.screenHeight     = value; this.NotifyPropertyChanged(); } } }
		/// <summary>
		/// Get/set the message text
		/// </summary>
		public string            Message	           { get { return this.message;          } set { if (value != this.message         ) { this.message          = value; this.NotifyPropertyChanged(); } } }
		/// <summary>
		/// Get/set the form caption 
		/// </summary>
		public string            MessageTitle       { get { return this.messageTitle;     } set { if (value != this.messageTitle    ) { this.messageTitle     = value; this.NotifyPropertyChanged(); } } }
		/// <summary>
		/// Get/set the message box result (which button was pressed to dismiss the form)
		/// </summary>
		public MessageBoxResult  MessageResult      { get { return this.messageResult;    } set { this.messageResult = value; } } 
		/// <summary>
		/// Get/set the buttons ued in the form (and update visibility for them)
		/// </summary>
		public MessageBoxButton  Buttons            
		{ 
			get { return this.buttons;          } 
			set 
			{ 
				if (value != this.buttons         ) 
				{ 
					this.buttons          = value; 
					this.NotifyPropertyChanged(); 
					this.NotifyPropertyChanged("ShowOk"); 
					this.NotifyPropertyChanged("ShowCancel"); 
					this.NotifyPropertyChanged("ShowYes"); 
					this.NotifyPropertyChanged("ShowNo"); 
					
				} 
			} 
		}
		/// <summary>
		/// Get the visibility of the ok button
		/// </summary>
		public Visibility        ShowOk             { get { return (this.Buttons == MessageBoxButton.OK       || this.Buttons == MessageBoxButton.OKCancel   ) ? Visibility.Visible : Visibility.Collapsed; }}
		/// <summary>
		/// Get the visibility of the cancel button
		/// </summary>
		public Visibility        ShowCancel         { get { return (this.Buttons == MessageBoxButton.OKCancel || this.Buttons == MessageBoxButton.YesNoCancel) ? Visibility.Visible : Visibility.Collapsed; }}
		/// <summary>
		/// Get the visibility of the yes button
		/// </summary>
		public Visibility        ShowYes            { get { return (this.Buttons == MessageBoxButton.YesNo    || this.Buttons == MessageBoxButton.YesNoCancel) ? Visibility.Visible : Visibility.Collapsed; }}
		/// <summary>
		/// Get the visibility of the no button
		/// </summary>
		public Visibility        ShowNo             { get { return (this.Buttons == MessageBoxButton.YesNo    || this.Buttons == MessageBoxButton.YesNoCancel) ? Visibility.Visible : Visibility.Collapsed; }}
		/// <summary>
		/// Get this visibility of the message box icon
		/// </summary>
		public Visibility        ShowIcon           { get { return (this.MessageIcon != null) ? Visibility.Visible : Visibility.Collapsed; }}
		/// <summary>
		/// Get/set the icon specified by the user
		/// </summary>
		public ImageSource       MessageIcon        { get { return this.messageIcon;     } set { if (value != this.messageIcon    ) { this.messageIcon = value; this.NotifyPropertyChanged(); } } }
		/// <summary>
		/// Get/set the width of the largest button (so all buttons are the same width as the widest button)
		/// </summary>
		public double            ButtonWidth        { get { return this.buttonWidth;     } set { if (value != this.buttonWidth    ) { this.buttonWidth = value; this.NotifyPropertyChanged(); } } }
		/// <summary>
		/// Get/set the flag inicating whether the expander is expanded
		/// </summary>
		public bool              Expanded           { get { return this.expanded;        } set { if (value != expanded            ) { this.expanded    = value; this.NotifyPropertyChanged(); } } }

		#endregion properties

		#region constructors

		/// <summary>
		/// Default constructor for VS designer)
		/// </summary>
		private MessageBoxEx()
		{
			this.InitializeComponent();
			this.DataContext = this;
			this.LargestButtonWidth();
		}

		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="msg"></param>
		/// <param name="title"></param>
		/// <param name="buttons">(Optinal) Message box button(s) to be displayed (default = OK)</param>
		/// <param name="image">(Optional) Message box image to display (default = None)</param>
		public MessageBoxEx(string msg, string title, MessageBoxButton buttons=MessageBoxButton.OK, MessageBoxImage image=MessageBoxImage.None)
		{
			this.InitializeComponent();
			this.DataContext  = this;
			this.LargestButtonWidth();
			this.Init(msg, title, buttons, image);
		}

		#endregion constructors

		#region non-static methods

		/// <summary>
		/// Performs message box initialization
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="title">Window title</param>
		/// <param name="buttons">What buttons are to be displayed</param>
		/// <param name="image">What message box icon image is to be displayed</param>
		protected virtual void Init(string msg, string title, MessageBoxButton buttons, MessageBoxImage image)
		{
			ShowDetailsBtn = (string.IsNullOrEmpty(DetailsText)) ? Visibility.Collapsed : Visibility.Visible;
			ShowCheckBox   = (CheckBoxData == null) ? Visibility.Collapsed : Visibility.Visible;

			// determine the screen area height, and the height of the textblock
			this.ScreenHeight = SystemParameters.WorkArea.Height - 150;

			// configure the form based on specified criteria
			this.Message      = msg;
			this.MessageTitle = (string.IsNullOrEmpty(title.Trim())) ? _DEFAULT_CAPTION : title;
			this.Buttons      = buttons;
			if (ParentWindow != null)
			{
				this.FontFamily = ParentWindow.FontFamily;
				this.FontSize = ParentWindow.FontSize;
			}
			// set the button template (if specified)
			if (!string.IsNullOrEmpty(ButtonTemplateName))
			{
				this.btnOK.SetResourceReference    (Control.TemplateProperty, ButtonTemplateName);
				this.btnYes.SetResourceReference   (Control.TemplateProperty, ButtonTemplateName);
				this.btnNo.SetResourceReference    (Control.TemplateProperty, ButtonTemplateName);
				this.btnCancel.SetResourceReference(Control.TemplateProperty, ButtonTemplateName);
			}

			// set the form's colors (you can also set these colors in your program's startup code 
			// (either in app.xaml.cs or MainWindow.cs) before you use the MessageBox for the 
			// first time
			MessageBackground = (MessageBackground == null) ? new SolidColorBrush(Colors.White) : MessageBackground;
			MessageForeground = (MessageForeground == null) ? new SolidColorBrush(Colors.Black) : MessageForeground;
			ButtonBackground  = (ButtonBackground  == null) ? new SolidColorBrush(ColorFromString("#cdcdcd")) : ButtonBackground;

			this.MessageIcon = null;

			// 2020.01.03/jms - added support for messagebox icons
			// some of the message box images have duplicate ordinal values but present the same 
			// image, so we have to normalize these values before we can determine which image 
			// to display.
			image = (image == MessageBoxImage.Stop || image == MessageBoxImage.Hand) ? MessageBoxImage.Error       : image;
			image = (image == MessageBoxImage.Asterisk)                              ? MessageBoxImage.Information : image;
			image = (image == MessageBoxImage.Exclamation)                           ? MessageBoxImage.Warning     : image;

			// svae it so we can use it later
			this.msgBoxImage = image;
			this.imgMsgBoxIcon.Tag = (image == MessageBoxImage.Error) ? 1 : 0;
			if (image == MessageBoxImage.Error)
			{
				Style style = (Style)(this.FindResource("ImageOpacityChanger"));
				if (style != null)
				{
					this.imgMsgBoxIcon.Style = style;
					ToolTip tooltip = new ToolTip() { Content = "Click this icon for additional info/actions." };
					// for some reason, Image elements can't do tooltips, so I assign the tootip 
					// to the parent grid. This seems to work fine.
					this.imgGrid.ToolTip = tooltip; 
				}
			}

			// now that the image is normalized, we can see what the user actually wants. We can 
			// also play the appropriate sound based on which icon is specified. The sound names 
			// don't exactly align with the icon (which I find quite strange). Welcome to Windows.
			switch (image)
			{
				case MessageBoxImage.Error       : 
					this.MessageIcon = this.GetIcon(SystemIcons.Error);       
					if (!isSilent) { SystemSounds.Hand.Play(); }
					break;

				case MessageBoxImage.Information : 
					this.MessageIcon = this.GetIcon(SystemIcons.Information); 
					if (!isSilent) { SystemSounds.Asterisk.Play(); }
					break;

				case MessageBoxImage.Question    : 
					this.MessageIcon = this.GetIcon(SystemIcons.Question);    
					if (!isSilent) { SystemSounds.Question.Play(); }
					break;
				case MessageBoxImage.Warning     : 
					this.MessageIcon = this.GetIcon(SystemIcons.Warning);     
					if (!isSilent) { SystemSounds.Exclamation.Play(); }
					break;
				default                          : 
					this.MessageIcon = null;
					break;
			}
		}

		/// <summary>
		/// Converts the specified icon into a WPF-comptible ImageSource object.
		/// </summary>
		/// <param name="icon"></param>
		/// <returns>An ImageSource object that represents the specified icon.</returns>
		public ImageSource GetIcon(System.Drawing.Icon icon)
		{
            var image = System.Windows.Interop.Imaging.CreateBitmapSourceFromHIcon(icon.Handle, Int32Rect.Empty, BitmapSizeOptions.FromEmptyOptions());
            return image;
		}

		// The form is rendered and position BEFORE the SizeToContent property takes effect, 
		// so we have to take stepts to re-center it after the size changes. This code takes care 
		// of the re-positioning, and is called from the SizeChanged event handler.
		/// <summary>
		/// Center the form on the screen.
		/// </summary>
		protected virtual void CenterInScreen()
		{
			double width  = this.ActualWidth;
			double height = this.ActualHeight;
			this.Left     = (SystemParameters.WorkArea.Width  - width ) / 2 + SystemParameters.WorkArea.Left;
			this.Top      = (SystemParameters.WorkArea.Height - height) / 2 + SystemParameters.WorkArea.Top;
		}

		/// <summary>
		/// Calculate the width of the largest button.
		/// </summary>
		protected void LargestButtonWidth()
		{
			// we base the width on the width of the content. This allows us to avoid the problems 
			// with button width/actualwidth properties, especially when a given button is 
			// Collapsed.
			Typeface typeface = new Typeface(this.FontFamily, this.FontStyle, this.FontWeight, this.FontStretch);

			StackPanel panel = (StackPanel)this.stackButtons.Child;
			double width = 0;
			string largestName = string.Empty;
			/*			
			Matrix m =
				PresentationSource.FromVisual(Application.Current.MainWindow).CompositionTarget.TransformToDevice;
				double dx = m.M11; // notice it's divided by 96 already
				double dy = m.M22; // notice it's divided by 96 already
			*/
			foreach (Button button in panel.Children)
			{
				// Because we have a details button with a polygon, we have to wrangle the "content" 
				// a little differently than the rest of the buttons. using the FormattedText object 
				// will strip whitespace before measuring the text, so we convert spaces to double 
				// hyphens to compensate (I like to pad button Content with a leading and trailing				
				// space) so that the button is wide enough to present a more padded appearance.
				// https://docs.microsoft.com/en-us/dotnet/api/system.windows.media.visualtreehelper?view=netframework-4.5.2
				//	gets the DPI information at which this Visual is measured and rendered - added in 4.6.2
				// https://stackoverflow.com/questions/5977445/how-to-get-windows-display-settings				
				// https://docs.microsoft.com/en-us/dotnet/api/system.windows.media.numbersubstitution.-ctor?view=netframework-4.5.2
				FormattedText formattedText = new FormattedText((button.Name=="btnDetails") ? "--Details--" : ((string)(button.Content)).Replace(" ", "--"),
																CultureInfo.CurrentUICulture, 
																FlowDirection.LeftToRight, 
																typeface, FontSize = this.FontSize, System.Windows.Media.Brushes.Black
																/*  https://docs.microsoft.com/en-us/dotnet/api/system.windows.media.numbersubstitution.-ctor?view=netframework-4.5.2		VisualTreeHelper.GetDpi(this).PixelsPerDip */ );
				if (width < formattedText.Width)
				{
					largestName = button.Name;
				}
				width = Math.Max(width, formattedText.Width);
			}
			this.ButtonWidth = Math.Ceiling(width/*width + polyArrow.Width+polyArrow.Margin.Right+Margin.Left*/);
		}

		#endregion non-static methods

		////////////////////////////////////////////////////////////////////////////////////////////
		// Form events
		////////////////////////////////////////////////////////////////////////////////////////////

		/// <summary>
		/// Handle the click event for the OK button
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void BtnOK_Click(object sender, RoutedEventArgs e)
		{
			this.MessageResult = MessageBoxResult.OK;
			this.DialogResult = true;
		}

		/// <summary>
		/// Handle the click event for the Yes button
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void BtnYes_Click(object sender, RoutedEventArgs e)
		{
			this.MessageResult = MessageBoxResult.Yes;
			this.DialogResult = true;
		}

		/// <summary>
		/// Handle the click event for the No button
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void BtnNo_Click(object sender, RoutedEventArgs e)
		{
			this.MessageResult = MessageBoxResult.No;
			this.DialogResult = true;
		}

		/// <summary>
		/// Handle the click event for the Cancel button
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void BtnCancel_Click(object sender, RoutedEventArgs e)
		{
			this.MessageResult = MessageBoxResult.Cancel;
			this.DialogResult = true;
		}

		/// <summary>
		/// Handle the size changed event so we can re-center the form on the screen
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void NotifiableWindow_SizeChanged(object sender, SizeChangedEventArgs e)
		{
			// we have to do this because the SizeToContent property is evaluated AFTER the window 
			// is positioned.
			this.CenterInScreen();
		}

		/// <summary>
		/// Handle the window loaded event
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void Window_Loaded(object sender, RoutedEventArgs e)
		{
			// if this in an error message box, this tooltip will be displayed. The intent is to set 
			// this value one time, and use it throughout the application session. However, you can 
			// certainly set it before displaying the messagebox to something that is contextually 
			// appropriate, but you'll have to clear it or reset it each time you use the MessageBox.
			this.imgMsgBoxIcon.ToolTip = (this.msgBoxImage == MessageBoxImage.Error) ? MsgBoxIconToolTip : null;
		}

		/// <summary>
		///  Handles the window closing event
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void Window_Closing(object sender, CancelEventArgs e)
		{
			// we always clear the details text and checkbox data. 
			DetailsText = null;
			CheckBoxData = null;

			// if the user didn't click a button to close the form, we set the MessageResult to the 
			// most negative button value that was available.
			if (this.MessageResult == MessageBoxResult.None)
			{
				switch (this.Buttons)
				{
					case MessageBoxButton.OK          : this.MessageResult = MessageBoxResult.OK; break;
					case MessageBoxButton.YesNoCancel : 
					case MessageBoxButton.OKCancel    : this.MessageResult = MessageBoxResult.Cancel; break;
					case MessageBoxButton.YesNo       : this.MessageResult = MessageBoxResult.No; break;
				}
			}
		}

		/// <summary>
		/// Since an icon isn't a button, we have to look for the left-mouse-up event to know it's 
		/// been clicked
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void ImgMsgBoxIcon_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
		{
			// we only want to allow the click if this is an error message, and the delegate 
			// object has been specified.
			if (DelegateObj != null && this.msgBoxImage == MessageBoxImage.Error && this.Buttons == MessageBoxButton.OK)
			{
				MessageBoxResult result = DelegateObj.PerformAction(this.Message);
				//despite the result of the method, we close this message
				if (ExitAfterErrorAction)
				{
					this.DialogResult = true;
				}
			}
		}
	}

	/// <summary>
	/// Non-static interaction logic for MessageBoxEx.xaml
	/// </summary>
	public partial class MessageBoxEx : Window, INotifyPropertyChanged
	{
		#region static fields

		private static ContentControl       parentWindow;
		private static string               buttonTemplateName;
		private static SolidColorBrush      messageBackground;
		private static SolidColorBrush      messageForeground;
		private static SolidColorBrush      buttonBackground;
		private static double               maxFormWidth   = 800;
		private static bool                 isSilent       = false;
		private static Visibility           showDetailsBtn = Visibility.Collapsed;
		private static string               detailsText;
		private static Visibility           showCheckBox   = Visibility.Collapsed;
		private static MsgBoxExCheckBoxData checkBoxData   = null;

		#endregion static fields

		#region static properties

		/// <summary>
		/// Get/set the icon tooltip text
		/// </summary>
		private static string             MsgBoxIconToolTip    { get; set; }
		/// <summary>
		/// Get/set the external icon delegate object
		/// </summary>
		protected static MsgBoxExDelegate DelegateObj          { get; set; }
		/// <summary>
		/// Get/set the flag that indicates whether the parent messagebox is closed after the 
		/// external action is finished.
		/// </summary>
		protected static bool             ExitAfterErrorAction { get; set; }

		/// <summary>
		/// Get/set the parent content control
		/// </summary>
		public static ContentControl       ParentWindow       { get { return parentWindow;       } set { parentWindow       = value; } }
		/// <summary>
		/// Get/set the button template name (for styling buttons)
		/// </summary>
		public static string               ButtonTemplateName { get { return buttonTemplateName; } set { buttonTemplateName = value; } }
		/// <summary>
		/// Get/set the brush for the message text background
		/// </summary>
		public static SolidColorBrush      MessageBackground  { get { return messageBackground;  } set { messageBackground  = value; } }
		/// <summary>
		/// Get/set the brush for the message text foreground
		/// </summary>
		public static SolidColorBrush      MessageForeground  { get { return messageForeground;  } set { messageForeground  = value; } }
		/// <summary>
		/// Get/set the brush for the button panel background
		/// </summary>
		public static SolidColorBrush      ButtonBackground	  { get { return buttonBackground;   } set { buttonBackground   = value; } }
		/// <summary>
		/// Get/set max form width
		/// </summary>
		public static double               MaxFormWidth       { get { return maxFormWidth;       } set { maxFormWidth       = value; } }
		/// <summary>
		/// Get the visibility of the no button
		/// </summary>
		public static Visibility           ShowDetailsBtn     { get { return showDetailsBtn;     } set { showDetailsBtn     = value; } }
		/// <summary>
		/// Get/set details text
		/// </summary>
		public static string               DetailsText        { get { return detailsText;        } set { detailsText        = value; } }
		/// <summary>
		/// Get/set the visibility of the checkbox
		/// </summary>
		public static Visibility           ShowCheckBox       { get { return showCheckBox;       } set { showCheckBox       = value; } }
		/// <summary>
		/// Get/set the checkbox data object
		/// </summary>
		public static MsgBoxExCheckBoxData CheckBoxData       { get { return checkBoxData;       } set { checkBoxData       = value; } }

		#endregion static properties

		#region static show methods

		/// <summary>
		/// Does the work of actually opening the messagebox
		/// </summary>
		/// <param name="msg"></param>
		/// <param name="title"></param>
		/// <param name="buttons"></param>
		/// <param name="image"></param>
		/// <returns></returns>
		private static MessageBoxResult OpenMessageBox(string msg, string title, MessageBoxButton buttons, MessageBoxImage image)
		{
			MessageBoxEx form = new MessageBoxEx(msg, title, buttons, image){ Owner = Application.Current.MainWindow };
			form.ShowDialog();
			return form.MessageResult;

		}

		/////////////////////////////////////// without icons

		/// <summary>
		/// Show a messagebox, using default caption and just the OK button
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult Show(string msg)
		{
			return OpenMessageBox(msg, _DEFAULT_CAPTION, MessageBoxButton.OK, MessageBoxImage.None);
		}

		/// <summary>
		/// Show a messagebox with the specified caption, and just the OK button
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="title">The messagebox caption</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult Show(string msg, string title)
		{
			title = (string.IsNullOrEmpty(title)) ? _DEFAULT_CAPTION : title;
			return OpenMessageBox(msg, title, MessageBoxButton.OK, MessageBoxImage.None);
		}

		/// <summary>
		/// Show a messagebox with the default caption and the specified buttons
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="buttons">The buttons to display</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult Show(string msg, MessageBoxButton buttons)
		{
			return OpenMessageBox(msg, _DEFAULT_CAPTION, buttons, MessageBoxImage.None);
		}

		/// <summary>
		/// Show a mesagebox with the specified caption and button(s)
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="title">The title for the message box</param>
		/// <param name="parentWindow">The parent window that supplies the font family/size</param>
		/// <param name="buttons">The buttons to display</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult Show(string msg, string title, MessageBoxButton buttons)
		{
			title = (string.IsNullOrEmpty(title)) ? _DEFAULT_CAPTION : title;
			return OpenMessageBox(msg, title, buttons, MessageBoxImage.None);
		}

		/////////////////////////////////////// with icons

		/// <summary>
		/// Show a messagebox, using default caption, the OK button, and the specified icon
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="image">The message box icon to diplay</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult Show(string msg, MessageBoxImage image)
		{
			return OpenMessageBox(msg, _DEFAULT_CAPTION, MessageBoxButton.OK, image);
		}

		/// <summary>
		/// Show a messagebox with the specified caption, the OK button, and the specified icon
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="title">The messagebox caption</param>
		/// <param name="image">The message box icon to diplay</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult Show(string msg, string title, MessageBoxImage image)
		{
			title = (string.IsNullOrEmpty(title)) ? _DEFAULT_CAPTION : title;
			return OpenMessageBox(msg, title, MessageBoxButton.OK, image);
		}

		/// <summary>
		/// Show a messagebox with the default caption, the specified button(s), and the specified icon
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="buttons">The buttons to display</param>
		/// <param name="image">The message box icon to diplay</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult Show(string msg, MessageBoxButton buttons, MessageBoxImage image)
		{
			return OpenMessageBox(msg, _DEFAULT_CAPTION, buttons, image);
		}

		/// <summary>
		/// Show a mesagebox with the specified caption, the specified button(s), and the specified icon
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="title">The title for the message box</param>
		/// <param name="parentWindow">The parent window that supplies the font family/size</param>
		/// <param name="buttons">The buttons to display</param>
		/// <param name="image">The message box icon to diplay</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult Show(string msg, string title, MessageBoxButton buttons, MessageBoxImage image)
		{
			return OpenMessageBox(msg, title, buttons, image);
		}

		/////////////////////////////////////// details without icons

		/// <summary>
		/// Show a messagebox, using default caption and just the OK button
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="details">Amplifying message details (turns on "Details" expander)</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithDetails(string msg, string details)
		{
			DetailsText = details;
			return OpenMessageBox(msg, _DEFAULT_CAPTION, MessageBoxButton.OK, MessageBoxImage.None);
		}

		/// <summary>
		/// Show a messagebox with the specified caption, and just the OK button
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="details">Amplifying message details (turns on "Details" expander)</param>
		/// <param name="title">The messagebox caption</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithDetails(string msg, string details, string title)
		{
			DetailsText = details;
			title = (string.IsNullOrEmpty(title)) ? _DEFAULT_CAPTION : title;
			return OpenMessageBox(msg, title, MessageBoxButton.OK, MessageBoxImage.None);
		}

		/// <summary>
		/// Show a messagebox with the default caption and the specified buttons
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="details">Amplifying message details (turns on "Details" expander)</param>
		/// <param name="buttons">The buttons to display</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithDetails(string msg, string details, MessageBoxButton buttons)
		{
			DetailsText = details;
			return OpenMessageBox(msg, _DEFAULT_CAPTION, buttons, MessageBoxImage.None);
		}

		/// <summary>
		/// Show a mesagebox with the specified caption and button(s)
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="details">Amplifying message details (turns on "Details" expander)</param>
		/// <param name="title">The title for the message box</param>
		/// <param name="parentWindow">The parent window that supplies the font family/size</param>
		/// <param name="buttons">The buttons to display</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithDetails(string msg, string details, string title, MessageBoxButton buttons)
		{
			DetailsText = details;
			title = (string.IsNullOrEmpty(title)) ? _DEFAULT_CAPTION : title;
			return OpenMessageBox(msg, title, buttons, MessageBoxImage.None);
		}

		/////////////////////////////////////// details with icons
		
		/// <summary>
		/// Show a messagebox, using default caption, the OK button, and the specified icon
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="details">Amplifying message details (turns on "Details" expander)</param>
		/// <param name="image">The message box icon to diplay</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithDetails(string msg, string details, MessageBoxImage image)
		{
			DetailsText = details;
			return OpenMessageBox(msg, _DEFAULT_CAPTION, MessageBoxButton.OK, image);
		}

		/// <summary>
		/// Show a messagebox with the specified caption, the OK button, and the specified icon
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="details">Amplifying message details (turns on "Details" expander)</param>
		/// <param name="title">The messagebox caption</param>
		/// <param name="image">The message box icon to diplay</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithDetails(string msg, string details, string title, MessageBoxImage image)
		{
			DetailsText = details;
			title = (string.IsNullOrEmpty(title)) ? _DEFAULT_CAPTION : title;
			return OpenMessageBox(msg, title, MessageBoxButton.OK, image);
		}

		/// <summary>
		/// Show a messagebox with the default caption, the specified button(s), and the specified icon
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="details">Amplifying message details (turns on "Details" expander)</param>
		/// <param name="buttons">The buttons to display</param>
		/// <param name="image">The message box icon to diplay</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithDetails(string msg, string details, MessageBoxButton buttons, MessageBoxImage image)
		{
			DetailsText = details;
			return OpenMessageBox(msg, _DEFAULT_CAPTION, buttons, image);
		}

		/// <summary>
		/// Show a mesagebox with the specified caption, the specified button(s), and the specified icon
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="details">Amplifying message details (turns on "Details" expander)</param>
		/// <param name="title">The title for the message box</param>
		/// <param name="parentWindow">The parent window that supplies the font family/size</param>
		/// <param name="buttons">The buttons to display</param>
		/// <param name="image">The message box icon to diplay</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithDetails(string msg, string details, string title, MessageBoxButton buttons, MessageBoxImage image)
		{
			DetailsText = details;
			return OpenMessageBox(msg, title, buttons, image);
		}

		/////////////////////////////////////// checkbox without icons

		/// <summary>
		/// Show a messagebox, using default caption and just the OK button
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="data">Bindable data object</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithCheckBox(string msg, MsgBoxExCheckBoxData data)
		{
			MessageBoxResult  result = MessageBoxResult.None;
			if (data != null)
			{
				CheckBoxData = data;
				result = OpenMessageBox(msg, _DEFAULT_CAPTION, MessageBoxButton.OK, MessageBoxImage.None);
			}
			return result;
		}

		/// <summary>
		/// Show a messagebox with the specified caption, and just the OK button
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="data">Bindable data object</param>
		/// <param name="title">The messagebox caption</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithCheckBox(string msg, MsgBoxExCheckBoxData data, string title)
		{
			MessageBoxResult  result = MessageBoxResult.None;
			if (data != null)
			{
				CheckBoxData = data;
				title = (string.IsNullOrEmpty(title)) ? _DEFAULT_CAPTION : title;
				result = OpenMessageBox(msg, title, MessageBoxButton.OK, MessageBoxImage.None);
			}
			return result;
		}

		/// <summary>
		/// Show a messagebox with the default caption and the specified buttons
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="data">Bindable data object</param>
		/// <param name="buttons">The buttons to display</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithCheckBox(string msg, MsgBoxExCheckBoxData data, MessageBoxButton buttons)
		{
			MessageBoxResult  result = MessageBoxResult.None;
			if (data != null)
			{
				CheckBoxData = data;
				result = OpenMessageBox(msg, _DEFAULT_CAPTION, buttons, MessageBoxImage.None);
			}
			return result;
		}

		/// <summary>
		/// Show a mesagebox with the specified caption and button(s)
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="data">Bindable data object</param>
		/// <param name="title">The title for the message box</param>
		/// <param name="parentWindow">The parent window that supplies the font family/size</param>
		/// <param name="buttons">The buttons to display</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithCheckBox(string msg, MsgBoxExCheckBoxData data, string title, MessageBoxButton buttons)
		{
			MessageBoxResult  result = MessageBoxResult.None;
			if (data != null)
			{
				CheckBoxData = data;
				title = (string.IsNullOrEmpty(title)) ? _DEFAULT_CAPTION : title;
				result = OpenMessageBox(msg, title, buttons, MessageBoxImage.None);
			}
			return result;
		}

		/////////////////////////////////////// checkbox with icons

		/// <summary>
		/// Show a messagebox, using default caption and just the OK button
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="data">Bindable data object</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithCheckBox(string msg, MsgBoxExCheckBoxData data, MessageBoxImage image)
		{
			MessageBoxResult  result = MessageBoxResult.None;
			if (data != null)
			{
				CheckBoxData = data;
				result = OpenMessageBox(msg, _DEFAULT_CAPTION, MessageBoxButton.OK, image);
			}
			return result;
		}

		/// <summary>
		/// Show a messagebox with the specified caption, and just the OK button
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="data">Bindable data object</param>
		/// <param name="title">The messagebox caption</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithCheckBox(string msg, MsgBoxExCheckBoxData data, string title, MessageBoxImage image)
		{
			MessageBoxResult  result = MessageBoxResult.None;
			if (data != null)
			{
				CheckBoxData = data;
				title = (string.IsNullOrEmpty(title)) ? _DEFAULT_CAPTION : title;
				result = OpenMessageBox(msg, title, MessageBoxButton.OK, image);
			}
			return result;
		}

		/// <summary>
		/// Show a messagebox with the default caption and the specified buttons
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="data">Bindable data object</param>
		/// <param name="buttons">The buttons to display</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithCheckBox(string msg, MsgBoxExCheckBoxData data, MessageBoxButton buttons, MessageBoxImage image)
		{
			MessageBoxResult  result = MessageBoxResult.None;
			if (data != null)
			{
				CheckBoxData = data;
				result = OpenMessageBox(msg, _DEFAULT_CAPTION, buttons, image);
			}
			return result;
		}

		/// <summary>
		/// Show a mesagebox with the specified caption and button(s)
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="data">Bindable data object</param>
		/// <param name="title">The title for the message box</param>
		/// <param name="parentWindow">The parent window that supplies the font family/size</param>
		/// <param name="buttons">The buttons to display</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithCheckBox(string msg, MsgBoxExCheckBoxData data, string title, MessageBoxButton buttons, MessageBoxImage image)
		{
			MessageBoxResult  result = MessageBoxResult.None;
			if (data != null)
			{
				CheckBoxData = data;
				title = (string.IsNullOrEmpty(title)) ? _DEFAULT_CAPTION : title;
				result = OpenMessageBox(msg, title, buttons, image);
			}
			return result;
		}

		/////////////////////////////////////// checkbox and details without icons

		/// <summary>
		/// Show a messagebox, using default caption and just the OK button
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="data">Bindable data object</param>
		/// <param name="details">Amplifying message details (turns on "Details" expander)</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithCheckBoxAndDetails(string msg, MsgBoxExCheckBoxData data, string details)
		{
			MessageBoxResult  result = MessageBoxResult.None;
			if (data != null)
			{
				DetailsText = details;
				CheckBoxData = data;
				result = OpenMessageBox(msg, _DEFAULT_CAPTION, MessageBoxButton.OK, MessageBoxImage.None);
			}
			return result;
		}

		/// <summary>
		/// Show a messagebox with the specified caption, and just the OK button
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="data">Bindable data object</param>
		/// <param name="details">Amplifying message details (turns on "Details" expander)</param>
		/// <param name="title">The messagebox caption</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithCheckBoxAndDetails(string msg, MsgBoxExCheckBoxData data, string details, string title)
		{
			MessageBoxResult  result = MessageBoxResult.None;
			if (data != null)
			{
				DetailsText = details;
				CheckBoxData = data;
				title = (string.IsNullOrEmpty(title)) ? _DEFAULT_CAPTION : title;
				result = OpenMessageBox(msg, title, MessageBoxButton.OK, MessageBoxImage.None);
			}
			return result;
		}

		/// <summary>
		/// Show a messagebox with the default caption and the specified buttons
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="data">Bindable data object</param>
		/// <param name="details">Amplifying message details (turns on "Details" expander)</param>
		/// <param name="buttons">The buttons to display</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithCheckBoxAndDetails(string msg, MsgBoxExCheckBoxData data, string details, MessageBoxButton buttons)
		{
			MessageBoxResult  result = MessageBoxResult.None;
			if (data != null)
			{
				DetailsText = details;
				CheckBoxData = data;
				result = OpenMessageBox(msg, _DEFAULT_CAPTION, buttons, MessageBoxImage.None);
			}
			return result;
		}

		/// <summary>
		/// Show a mesagebox with the specified caption and button(s)
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="data">Bindable data object</param>
		/// <param name="details">Amplifying message details (turns on "Details" expander)</param>
		/// <param name="title">The title for the message box</param>
		/// <param name="parentWindow">The parent window that supplies the font family/size</param>
		/// <param name="buttons">The buttons to display</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithCheckBoxAndDetails(string msg, MsgBoxExCheckBoxData data, string details, string title, MessageBoxButton buttons)
		{
			MessageBoxResult  result = MessageBoxResult.None;
			if (data != null)
			{
				DetailsText = details;
				CheckBoxData = data;
				title = (string.IsNullOrEmpty(title)) ? _DEFAULT_CAPTION : title;
				result = OpenMessageBox(msg, title, buttons, MessageBoxImage.None);
			}
			return result;
		}

		/////////////////////////////////////// checkbox and details  with icons

		/// <summary>
		/// Show a messagebox, using default caption and just the OK button
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="data">Bindable data object</param>
		/// <param name="details">Amplifying message details (turns on "Details" expander)</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithCheckBoxAndDetails(string msg, MsgBoxExCheckBoxData data, string details, MessageBoxImage image)
		{
			MessageBoxResult  result = MessageBoxResult.None;
			if (data != null)
			{
				DetailsText = details;
				CheckBoxData = data;
				result = OpenMessageBox(msg, _DEFAULT_CAPTION, MessageBoxButton.OK, image);
			}
			return result;
		}

		/// <summary>
		/// Show a messagebox with the specified caption, and just the OK button
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="data">Bindable data object</param>
		/// <param name="details">Amplifying message details (turns on "Details" expander)</param>
		/// <param name="title">The messagebox caption</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithCheckBoxAndDetails(string msg, MsgBoxExCheckBoxData data, string details, string title, MessageBoxImage image)
		{
			MessageBoxResult  result = MessageBoxResult.None;
			if (data != null)
			{
				DetailsText = details;
				CheckBoxData = data;
				title = (string.IsNullOrEmpty(title)) ? _DEFAULT_CAPTION : title;
				result = OpenMessageBox(msg, title, MessageBoxButton.OK, image);
			}
			return result;
		}

		/// <summary>
		/// Show a messagebox with the default caption and the specified buttons
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="data">Bindable data object</param>
		/// <param name="details">Amplifying message details (turns on "Details" expander)</param>
		/// <param name="buttons">The buttons to display</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithCheckBoxAndDetails(string msg, MsgBoxExCheckBoxData data, string details, MessageBoxButton buttons, MessageBoxImage image)
		{
			MessageBoxResult  result = MessageBoxResult.None;
			if (data != null)
			{
				DetailsText = details;
				CheckBoxData = data;
				result = OpenMessageBox(msg, _DEFAULT_CAPTION, buttons, image);
			}
			return result;
		}

		/// <summary>
		/// Show a mesagebox with the specified caption and button(s)
		/// </summary>
		/// <param name="msg">The message to display</param>
		/// <param name="data">Bindable data object</param>
		/// <param name="details">Amplifying message details (turns on "Details" expander)</param>
		/// <param name="title">The title for the message box</param>
		/// <param name="parentWindow">The parent window that supplies the font family/size</param>
		/// <param name="buttons">The buttons to display</param>
		/// <returns>The button that was clicked to dismiss the messagebox</returns>
		public static MessageBoxResult ShowWithCheckBoxAndDetails(string msg, MsgBoxExCheckBoxData data, string details, string title, MessageBoxButton buttons, MessageBoxImage image)
		{
			MessageBoxResult  result = MessageBoxResult.None;
			if (data != null)
			{
				DetailsText = details;
				CheckBoxData = data;
				title = (string.IsNullOrEmpty(title)) ? _DEFAULT_CAPTION : title;
				result = OpenMessageBox(msg, title, buttons, image);
			}
			return result;
		}

		#endregion static show methods

		#region static configuration methods

		// colors

		/// <summary>
		/// Set the background color for the message area
		/// </summary>
		/// <param name="color"></param>
		public static void SetMessageBackground(System.Windows.Media.Color color)
		{
			try
			{
				MessageBackground = new SolidColorBrush(color);
			}
			catch (Exception ex)
			{
				MessageBox.Show(ex.Message, ex.ToString());
			}
		}

		/// <summary>
		/// Set the foreground color for the message area
		/// </summary>
		/// <param name="color"></param>
		public static void SetMessageForeground(System.Windows.Media.Color color)
		{
			try
			{
				MessageForeground = new SolidColorBrush(color);
			}
			catch (Exception ex)
			{
				MessageBox.Show(ex.Message, ex.ToString());
			}
		}

		/// <summary>
		/// Set the background color for the button panel area
		/// </summary>
		/// <param name="color"></param>
		public static void SetButtonBackground(System.Windows.Media.Color color)
		{
			try
			{
				ButtonBackground = new SolidColorBrush(color);
			}
			catch (Exception ex)
			{
				MessageBox.Show(ex.Message, ex.ToString());
			}
		}

		/// <summary>
		///  Create a WPF-compatible Color fro an octet string (such as "#123456")
		/// </summary>
		/// <param name="colorOctet"></param>
		/// <returns></returns>
		public static System.Windows.Media.Color ColorFromString(string colorOctet)
		{
			System.Windows.Media.Color wpfColor = (System.Windows.Media.Color)(System.Windows.Media.ColorConverter.ConvertFromString(colorOctet));
			return wpfColor;
		}

		// mechanicals

		/// <summary>
		/// Set the parent window to allow the messge box to inherit the font family and size
		/// </summary>
		/// <param name="parent"></param>
		public static void SetParentWindow(ContentControl parent)
		{
			ParentWindow = parent;
		}

		/// <summary>
		/// Set the custom button template *NAME*
		/// </summary>
		/// <param name="name"></param>
		public static void SetButtonTemplateName(string name)
		{
			ButtonTemplateName = name;
		}

		/// <summary>
		/// Sets the max form width to largest of 300 or the specified value
		/// </summary>
		/// <param name="value"></param>
		public static void SetMaxFormWidth(double value)
		{
			MaxFormWidth = Math.Max(value, 300);
		}

		// message box icon 

		public static void SetAsSilent(bool quiet)
		{
			isSilent = quiet;
		}

		/// <summary>
		/// Sets the error delegate object which provides code that runs when the message box icon 
		/// is clicked.
		/// </summary>
		/// <param name="obj"></param>
		public static void SetErrorDelegate(MsgBoxExDelegate obj)
		{
			DelegateObj = obj;
		}

		/// <summary>
		/// Causes the original messagebox to close after the delegate action has pbeen processed.
		/// </summary>
		/// <param name="exitAfter"></param>
		public static void SetExitAfterErrorAction(bool exitAfter)
		{
			ExitAfterErrorAction = exitAfter;
		}

		/// <summary>
		/// Sets the tooltip for the message box icon. If the tooltip text is null, it won't be 
		/// displayed.
		/// </summary>
		/// <param name="tooltip"></param>
		public static void SetMsgBoxIconToolTip(string tooltip)
		{
			MsgBoxIconToolTip = tooltip;
		}

		public static void ShowDetailsButton(bool show)
		{
			ShowDetailsBtn = (show) ? Visibility.Visible : Visibility.Collapsed;
		}

		#endregion static configuration methods
	}

	// This class doesn't have to be inherted because its use is highly specific.
	/// <summary>
	/// Reresents the object that allows the checkbox state to be discoevered externally of the 
	/// messagebox.
	/// </summary>
	public class MsgBoxExCheckBoxData : INotifyPropertyChanged
	{
		#region INotifyPropertyChanged

		private bool isModified = false;
		public bool IsModified { get { return this.isModified; } set { if (value != this.isModified) { this.isModified = true; this.NotifyPropertyChanged(); } } }
		/// <summary>
		/// Occurs when a property value changes.
		/// </summary>
		public event PropertyChangedEventHandler PropertyChanged;

		/// <summary>
		/// Notifies that the property changed, and sets IsModified to true.
		/// </summary>
		/// <param name="propertyName">Name of the property.</param>
        protected void NotifyPropertyChanged([CallerMemberName] String propertyName = "")
        {
            if (this.PropertyChanged != null)
            {
                this.PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
				if (propertyName != "IsModified")
				{
					this.IsModified = true;
				}
            }
        }
	
		#endregion INotifyPropertyChanged

		private string checkBoxText;
		private bool   checkBoxIsChecked;

		/// <summary>
		/// Get/set the text content of the checkbox
		/// </summary>
		public string CheckBoxText      { get { return this.checkBoxText;      } set { if (value != this.checkBoxText     ) { this.checkBoxText      = value; this.NotifyPropertyChanged(); } } }
		/// <summary>
		/// Get/set the flag that indicates whether the checkbox is checked
		/// </summary>
		public bool   CheckBoxIsChecked { get { return this.checkBoxIsChecked; } set { if (value != this.checkBoxIsChecked) { this.checkBoxIsChecked = value; this.NotifyPropertyChanged(); } } }
	}

	// This class MUST be inherited, and the PerformAction method MUST be overriden.
	/// <summary>
	/// Represents the object that allows a message box icon to execute code. This class must be 
	/// inherited.
	/// </summary>
	public abstract class MsgBoxExDelegate
	{
		/// <summary>
		/// Get/set the message text from the calling message box
		/// </summary>
		public string   Message     { get; set; }
		/// <summary>
		/// Get/set the details text (if it was specified in the messagebox)
		/// </summary>
		public string   Details     { get; set; }
		/// <summary>
		/// Get/set the message datetime at which this object was created
		/// </summary>
		public DateTime MessageDate { get; set; }

		/// <summary>
		/// Performs the desired action, and returns the result. MUST BE OVERIDDEN IN INHERITING CLASS. 
		/// </summary>
		/// <returns></returns>
		public virtual MessageBoxResult PerformAction(string message, string details=null)
		{ 
			throw new NotImplementedException(); 
		}
	}

}
