using System;
using System.Security.Permissions;
using System.Windows.Forms;

using GG = PasswordGeneration.GenerateGlobals;
using GP = PasswordGeneration.GeneratePassword;

namespace TestPasswordGeneration {
    
	public partial class TestPasswordGeneration : Form {
       
		GP generate_password_form;
		string generated_password = String.Empty;
		public TestPasswordGeneration() {
			InitializeComponent();
			this.Text = String.Format("Test Generate Password");
			this.StartPosition = FormStartPosition.CenterScreen;
			generated_password_TB.Visible = false;
		}
		
		void BUT_Click(object sender, EventArgs  e) {
			Button button = (Button)sender;
			string name = button.Name.Trim();
			switch (name) {
				case "generate_BUT":
					generate_password_form = 
                        new PasswordGeneration.GeneratePassword();
					if (((PasswordGeneration.GeneratePassword)
                                generate_password_form).
                                initialize_form()) {
						// use modal (ShowDialog) so 
						// that the generated password 
						// can be captured
						generate_password_form.ShowDialog();
						if (!String.IsNullOrEmpty(
							                      GG.generated_password)) {
							generated_password = 
                                GG.generated_password;
							generated_password_TB.Clear();
							generated_password_TB.Text = 
                                generated_password;
							generated_password_TB.Visible = true;
						}
					} else {
						MessageBox.Show(
							String.Format(
								"Unable to open Password " +
								"Generation Window{0}{)}" +
								"Program must exit",
								Environment.NewLine),
							"Fatal Error",
							MessageBoxButtons.OK,
							MessageBoxIcon.Error);
						this.Close();
					}
					break;

				case "exit_BUT":
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

		[ PermissionSet(SecurityAction.Demand, Name = "FullTrust")]
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
