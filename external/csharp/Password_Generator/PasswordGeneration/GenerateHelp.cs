using System;
using System.Drawing;
using System.Security.Permissions;
using System.Windows.Forms;

namespace PasswordGeneration {
	public partial class GenerateHelp : Form {
		const    int RTB_MARGIN = 10;

		public GenerateHelp() {
			InitializeComponent();
		}
        
		void set_RTB_and_form_size() {
			const int MINIMUM_TEXT_HEIGHT = 50;
			const int OFFSET = 7;     // pixels
			// there is a button at the 
			// bottom of the form
			int button_height = 0;
			int form_client_height = 0;
			int form_height = 0;
			int help_text_height;
			SizeF help_text_size;
			int text_height = 0;

			button_height = OK_BUT.Size.Height;
			form_height = this.Size.Height;
			form_client_height = this.ClientSize.Height;
            
			help_text_size = 
                help_text_RTB.
                CreateGraphics().
                MeasureString(help_text_RTB.Text,
				help_text_RTB.Font,
				help_text_RTB.Width, 
				new StringFormat(0));
			// increase by 10%
			help_text_size.Height += (0.10F *
			help_text_size.Height);
			help_text_height = 
                Convert.ToInt32(
				Math.Min(help_text_size.Height,
					form_client_height));
			help_text_height = Math.Max(help_text_height, 
				MINIMUM_TEXT_HEIGHT);
			// change RTB size
			text_height = help_text_RTB.Location.Y;
			help_text_RTB.Size = 
                new Size(help_text_RTB.Size.Width,
				help_text_height);
			text_height += help_text_RTB.Size.Height;
			text_height += OFFSET;
			// no change to OK X
			OK_BUT.Location = new Point(OK_BUT.Location.X,
				text_height);
			text_height += OK_BUT.Size.Height;
			text_height += OFFSET;
			// text_height is now the 
			// height of the help form 
			// client area => changed the 
			// height of the help form
			this.ClientSize = 
                new Size(this.ClientSize.Width,
				text_height);

		}

		void initialize_form_controls() {

			this.Text = "Generate Password Help";
			this.Icon = Properties.Resources.generate_icon;

			help_text_RTB.Clear();
			help_text_RTB.Text = Properties.
                                 Resources.
                                 generate_help_text;
			help_text_RTB.set_margins(RTB_MARGIN);
            
			set_RTB_and_form_size();
            
		}

		public bool initialize_form() {
			bool successful = true;
			initialize_form_controls();
			return (successful);
		}

		void BUT_Click(object sender, EventArgs  e) {
			Button button = (Button)sender;
			string name = button.Name.ToString().Trim();

			switch (name) {
				case "OK_BUT":
					this.Close();
					break;

				default:
					throw new ApplicationException(
						String.Format(
							"{0} is an unrecognized button name",
							name)); 
			}
		}

		/// https://docs.microsoft.com/en-us/dotnet/api/

		const int WM_SYSCOMMAND = 0x0112;
		const int SC_CLOSE = 0xF060;

		[PermissionSet(SecurityAction.Demand,  Name = "FullTrust")]
		protected override void WndProc(ref Message message) {
            
			switch (message.Msg) {
			// WinForms X button click
				case WM_SYSCOMMAND:
					if (((int)message.WParam & 0xFFF0) ==
					                   SC_CLOSE) {
						this.Close();
					}
					break;
			}
			base.WndProc(ref message);            
		}

	}

}
