using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Media;
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
using System.Windows.Navigation;
using System.Windows.Shapes;
using MsgBoxEx;

namespace MsgBoxExample
{
	public class ErrorMsgDelegate : MsgBoxExDelegate
	{
		public override MessageBoxResult PerformAction(string message, string details=null)
		{
			this.Message = message;
			this.Details = details;
			this.MessageDate = DateTime.Now;

			// for this sample, we're just showing another messagebox
			MessageBoxResult result = MessageBoxEx.Show("You're about to do something because this is an error message (clicking yes with play a beep sound). Are you sure?", 
								  "Send Error Message To Support", 
								  MessageBoxButton.YesNo, 
								  MessageBoxImage.Question);
			if (result == MessageBoxResult.Yes)
			{
				//indicate that they clicked yes
				SystemSounds.Beep.Play();
			}
			return result;
		}
	}

	/// <summary>
	/// Interaction logic for MainWindow.xaml
	/// </summary>
	public partial class MainWindow : Window, INotifyPropertyChanged
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

		MsgBoxExCheckBoxData checkboxData = new MsgBoxExCheckBoxData(){ CheckBoxIsChecked=false, CheckBoxText="Don't show this message any more"};
		ErrorMsgDelegate errorDelegate = new ErrorMsgDelegate();

		private bool playSystemSounds;
		public bool PlaySystemSounds 
		{ 
			get { return this.playSystemSounds; } 
			set 
			{ 
				if (value != playSystemSounds) 
				{ 
					this.playSystemSounds = value; 
					NotifyPropertyChanged(); 
					MessageBoxEx.SetAsSilent(!this.playSystemSounds);
				} 
			} 
		}

		public MainWindow()
		{
			this.InitializeComponent();
			this.DataContext = this;
			this.InitMessageBox();
			this.PlaySystemSounds = true;
		}

		private void InitMessageBox()
		{
			MessageBoxEx.SetParentWindow(this);
			MessageBoxEx.SetMessageForeground(Colors.White);
			MessageBoxEx.SetMessageBackground(Colors.Black);
			MessageBoxEx.SetButtonBackground(MessageBoxEx.ColorFromString("#333333"));
			MessageBoxEx.SetButtonTemplateName("AefCustomButton");
			MessageBoxEx.SetMaxFormWidth(600);
			MessageBoxEx.SetErrorDelegate(new ErrorMsgDelegate());
			// if you want to make the messagebox silent when you use icons, uncomment the next line
			//MessageBoxEx.SetAsSilent(true);
		}

		private string Testmsg()
		{
			StringBuilder msg = new StringBuilder();
			msg.AppendLine("using System;");
			msg.AppendLine("using System.Collections.Generic;");
			msg.AppendLine("using System.Linq;");
			msg.AppendLine("using System.Text;");
			msg.AppendLine("using System.Threading.Tasks;");
			msg.AppendLine("using System.Windows;");
			msg.AppendLine("using System.Windows.Controls;");
			msg.AppendLine("using System.Windows.Data;");
			msg.AppendLine("using System.Windows.Documents;");
			msg.AppendLine("using System.Windows.Input;");
			msg.AppendLine("using System.Windows.Media;");
			msg.AppendLine("using System.Windows.Media.Imaging;");
			msg.AppendLine("using System.Windows.Navigation;");
			msg.AppendLine("using System.Windows.Shapes;");
			msg.AppendLine("using WpfCommon.Controls;");
			msg.AppendLine("using ObjectExtensions;");
			msg.AppendLine("using EntityFactory.ViewModels;");
			msg.AppendLine("using System.Windows.Controls.Primitives;");
			msg.AppendLine("using System.Diagnostics;");
			msg.AppendLine("using System.ComponentModel;");
			msg.AppendLine("using System.Threading;");
			msg.AppendLine("using EntityFactory.Common;");
			msg.AppendLine("using EntityFactory.Database;");
			msg.AppendLine("using EntityFactory.Windows;");
			msg.AppendLine("using PaddedwallDAL;");
			msg.AppendLine("public VMStoredProcItems StoredProcedures  { get { return this.storedProcedures;  } set { if (value != this.storedProcedures ) { this.storedProcedures  = value; this.NotifyPropertyChanged(); } } }");
			msg.AppendLine("public VMDbNameItem      DBName            { get { return this.dbName;            } set { if (value != this.dbName           ) { this.dbName = value; this.NotifyPropertyChanged(); } } }");
			msg.AppendLine("//public VMDbNameItems     DBNames           { get { return this.dbNames;           } set { if (value != this.dbNames          ) { this.dbNames = value; this.NotifyPropertyChanged(); this.NotifyPropertyChanged(\"CanEnableCombo\"); } } }");
			msg.AppendLine("public string            CombinedClassName { get { return this.combinedClassName; } set { if (value != this.combinedClassName) { this.combinedClassName = value; this.NotifyPropertyChanged(); } } }");
			msg.AppendLine("public bool              CanEnablePage     { get { return this.canEnablePage;     } set { if (value != this.canEnablePage    ) { this.canEnablePage     = value; this.NotifyPropertyChanged(); } } }");
			msg.AppendLine("//public bool              CanEnableCombo    { get { return (this.DBNames != null && this.DBNames.Count > 0); } }");
			msg.AppendLine("public bool              EnableShowButtons { get { return this.enableShowButtons; } set { if (value != this.enableShowButtons) { this.enableShowButtons = value; this.NotifyPropertyChanged(); } } }");
			msg.AppendLine("public Visibility        Waiting");
			msg.AppendLine("{");
			msg.AppendLine("	get { return this.waiting;           }");
			msg.AppendLine("	set { if (value != this.waiting          ) { this.waiting           = value; this.NotifyPropertyChanged(); } }");
			msg.AppendLine("}");
			msg.AppendLine("public int               ListViewColSpan { get { return (this.cbShowHelp.IsChecked == true) ? 1 : 3; } }");
			msg.AppendLine("using System;");
			msg.AppendLine("using System.Collections.Generic;");
			msg.AppendLine("using System.Linq;");
			msg.AppendLine("using System.Text;");
			msg.AppendLine("using System.Threading.Tasks;");
			msg.AppendLine("using System.Windows;");
			msg.AppendLine("using System.Windows.Controls;");
			msg.AppendLine("using System.Windows.Data;");
			msg.AppendLine("using System.Windows.Documents;");
			msg.AppendLine("using System.Windows.Input;");
			msg.AppendLine("using System.Windows.Media;");
			msg.AppendLine("using System.Windows.Media.Imaging;");
			msg.AppendLine("using System.Windows.Navigation;");
			msg.AppendLine("using System.Windows.Shapes;");
			msg.AppendLine("using WpfCommon.Controls;");
			msg.AppendLine("using ObjectExtensions;");
			msg.AppendLine("using EntityFactory.ViewModels;");
			msg.AppendLine("using System.Windows.Controls.Primitives;");
			msg.AppendLine("using System.Diagnostics;");
			msg.AppendLine("using System.ComponentModel;");
			msg.AppendLine("using System.Threading;");
			msg.AppendLine("using EntityFactory.Common;");
			msg.AppendLine("using EntityFactory.Database;");
			msg.AppendLine("using EntityFactory.Windows;");
			msg.AppendLine("using PaddedwallDAL;");
			msg.AppendLine("public VMStoredProcItems StoredProcedures  { get { return this.storedProcedures;  } set { if (value != this.storedProcedures ) { this.storedProcedures  = value; this.NotifyPropertyChanged(); } } }");
			msg.AppendLine("public VMDbNameItem      DBName            { get { return this.dbName;            } set { if (value != this.dbName           ) { this.dbName = value; this.NotifyPropertyChanged(); } } }");
			msg.AppendLine("//public VMDbNameItems   DBNames           { get { return this.dbNames;           } set { if (value != this.dbNames          ) { this.dbNames = value; this.NotifyPropertyChanged(); this.NotifyPropertyChanged(\"CanEnableCombo\"); } } }");
			msg.AppendLine("public string            CombinedClassName { get { return this.combinedClassName; } set { if (value != this.combinedClassName) { this.combinedClassName = value; this.NotifyPropertyChanged(); } } }");
			msg.AppendLine("public bool              CanEnablePage     { get { return this.canEnablePage;     } set { if (value != this.canEnablePage    ) { this.canEnablePage     = value; this.NotifyPropertyChanged(); } } }");
			msg.AppendLine("//public bool            CanEnableCombo    { get { return (this.DBNames != null && this.DBNames.Count > 0); } }");
			msg.AppendLine("public bool              EnableShowButtons { get { return this.enableShowButtons; } set { if (value != this.enableShowButtons) { this.enableShowButtons = value; this.NotifyPropertyChanged(); } } }");
			msg.AppendLine("public Visibility        Waiting");
			msg.AppendLine("{");
			msg.AppendLine("	get { return this.waiting;           }");
			msg.AppendLine("	set { if (value != this.waiting          ) { this.waiting           = value; this.NotifyPropertyChanged(); } }");
			msg.AppendLine("}");
			msg.AppendLine("public int               ListViewColSpan { get { return (this.cbShowHelp.IsChecked == true) ? 1 : 3; } }");
			msg.AppendLine("//==================================== END OF TEST MSG ===================");
			return msg.ToString();
		}

		#region no frills

		private void BtnClickme1a_Click(object sender, RoutedEventArgs e)
		{
			// show a short message with no icon, and uses the default OK button
			MessageBox.Show  ("Short message.", "Short Msg, No Frills");
			MessageBoxEx.Show("Short message.", "Short Msg, No Frills");
		}
		private void BtnClickme2a_Click(object sender, RoutedEventArgs e)
		{
			// show a longer message with no icon, and uses the OK/Cancel buttons
			MessageBox.Show  ("Longer message text intended to show auto-sizing form, as well as testing max width. This text should have multiple lines.", "Longer Message, No Frills"
								, MessageBoxButton.OKCancel);
			MessageBoxEx.Show("Longer message text intended to show auto-sizing form, as well as testing max width. This text should have multiple lines.", "Longer Message, No Frills"
								, MessageBoxButton.OKCancel);
		}
		private void BtnClickme3a_Click(object sender, RoutedEventArgs e)
		{
			// show a really long message with no icon, and uses the Yes/No buttons
			MessageBox.Show  (Testmsg(), "Really Long Message, No Frills", MessageBoxButton.YesNo);
			MessageBoxEx.Show(Testmsg(), "Really Long Message, No Frills", MessageBoxButton.YesNo);
		}
		private void BtnClickme4a_Click(object sender, RoutedEventArgs e)
		{
			// show a longer message with no icon, and uses the Yes/NoCancel buttons
			MessageBox.Show  ("Longer message text intended to show auto-sizing form, as well as testing max width.", "Longer Message, No Frills"
								, MessageBoxButton.YesNoCancel);
			MessageBoxEx.Show("Longer message text intended to show auto-sizing form, as well as testing max width.", "Longer Message, No Frills"
								, MessageBoxButton.YesNoCancel);
		}

		private void BtnClickme1b_Click(object sender, RoutedEventArgs e)
		{
			// show info icon
			MessageBox.Show  ("Illustrate icon alignment with short message.", "Info", MessageBoxButton.OK, MessageBoxImage.Information);
			MessageBoxEx.Show("Illustrate icon alignment with short message.", "Info", MessageBoxButton.OK, MessageBoxImage.Information);
		}

		private void BtnClickme2b_Click(object sender, RoutedEventArgs e)
		{
			// show warning icon
			MessageBox.Show  ("Illustrate icon alignment with multiline message. The icon should be positioned at the top of the message box when there are multiple lines of message text.", "Warning"
								, MessageBoxButton.OKCancel, MessageBoxImage.Warning);
			MessageBoxEx.Show("Illustrate icon alignment with multiline message. The icon should be positioned at the top of the message box when there are multiple lines of message text.", "Warning"
								, MessageBoxButton.OKCancel, MessageBoxImage.Warning);
		}

		private void BtnClickme3b_Click(object sender, RoutedEventArgs e)
		{
			// show question icon
			MessageBox.Show  ("Show the \"question\" icon.\r\n\r\nDoes it look okay?", "Question", MessageBoxButton.YesNo, MessageBoxImage.Question);
			MessageBoxEx.Show("Show the \"question\" icon.\r\n\r\nDoes it look okay?", "Question", MessageBoxButton.YesNo, MessageBoxImage.Question);
		}

		private void BtnClickme4b_Click(object sender, RoutedEventArgs e)
		{
			// show error icon
			MessageBox.Show  ("Show an error message.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
			MessageBoxEx.Show("Show an error message.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
		}

		private void BtnClickme1c_Click(object sender, RoutedEventArgs e)
		{
			// show clickable error icon
			MessageBoxEx.SetErrorDelegate(this.errorDelegate);
			MessageBoxEx.Show("Show an error message. The icon is clickable.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
		}

		private void BtnClickme2c_Click(object sender, RoutedEventArgs e)
		{
			// show box details 
			MessageBoxEx.ShowWithDetails("Here's some source code. Click the Details expander below.", Testmsg(), "Really Long Message, No Frills"
											, MessageBoxButton.OK, MessageBoxImage.Information);
		}

		private void BtnClickme3c_Click(object sender, RoutedEventArgs e)
		{
			// Handling the decision to show/not show a messagebox is handled by checking the status of the checkbox data. 
			// The mesagebox itself doesn't care
			if (this.checkboxData != null && !this.checkboxData.CheckBoxIsChecked)
			{
				// show box with a checkbox
				MessageBoxEx.ShowWithCheckBox("This is possibly pointless and can be permenantly dismissed by clicking the checkbox below.", this.checkboxData, "Checkbox Sample");
			}
			else
			{
				MessageBoxEx.Show("But you said not to show the message anymore. Make up your mind.","Hypocrite Notice");
			}
		}

		private void BtnClickme4c_Click(object sender, RoutedEventArgs e)
		{
			if (this.checkboxData != null && !this.checkboxData.CheckBoxIsChecked)
			{
				// show box with checkbox and details 
				MessageBoxEx.ShowWithCheckBoxAndDetails("This is possibly pointless and can be permenantly dismissed by clicking the checkbox below." 
														, this.checkboxData, this.Testmsg(), "Checkbox Sample"
														, MessageBoxButton.OK, MessageBoxImage.Information);
			}
			else
			{
				MessageBoxEx.Show("But you said not to show the message anymore. Make up your mind.","Hypocrite Notice");
			}

		}

		#endregion no frills


	}
}
