using System.Windows.Forms;
using System.Drawing;

namespace DialogMessage {
	public static class DMessage {
		/// <summary>
		/// A public static method with a return value of System.Windows.Forms.DialogResult
		/// </summary>
		/// <param name="_windowTitle"></param>
		/// <param name="_mainInstruction"></param>
		/// <param name="_msgButtons"></param>
		/// <param name="_msgIcons"></param> // Optional parameter with default value of None
		/// <param name="_content"></param> // Optional parameter with default value of Empty
		/// <returns></returns>
		public static DialogResult ShowMessage(string _windowTitle,
			string _mainInstruction,
			MsgButtons _msgButtons,
			MsgIcons _msgIcons = MsgIcons.None,
			string _content = "")
		{
			// Creates a new instance of MainForm so we can set the properties of the controls
			MainForm main = new MainForm();

			// Sets the initial height of the form
			main.Height = 157;

			// Sets Window Title
			main.Text = _windowTitle;

			// Sets MainInstruction
			main.mainInstruction.Text = _mainInstruction;

			// Sets Content
			main.content.Text = _content;

			// Sets the properties of the buttons based on which enum was provided
			switch (_msgButtons) {
			// Button1 is the left button
			// Button2 is the right button

				case MsgButtons.OK:
                    
					main.Button1.Visible = false;
					// https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.dialogresult?view=netframework-4.0
					main.Button2.DialogResult = System.Windows.Forms.DialogResult.OK;
					main.Button2.Text = "OK";
					main.AcceptButton = main.Button2; 
					main.Button2.TabIndex = 0;
					main.ActiveControl = main.Button2;

					break;

				case MsgButtons.OKCancel:

					main.Button1.DialogResult = System.Windows.Forms.DialogResult.OK;
					main.Button2.DialogResult = System.Windows.Forms.DialogResult.Cancel;
					main.Button1.Text = "OK";
					main.Button2.Text = "Cancel";
					main.AcceptButton = main.Button2; 
					main.Button1.TabIndex = 1;
					main.Button2.TabIndex = 0;
					main.ActiveControl = main.Button2;

					break;

				case MsgButtons.YesNo:

					main.Button1.DialogResult = System.Windows.Forms.DialogResult.Yes;
					main.Button2.DialogResult = System.Windows.Forms.DialogResult.No;
					main.Button1.Text = "Yes";
					main.Button2.Text = "No";
					main.AcceptButton = main.Button2; 
					main.Button1.TabIndex = 1;
					main.Button2.TabIndex = 0;
					main.ActiveControl = main.Button2;

					break;

				default:
					break;
			}

			// Sets the Image for the PictureBox based on which enum was provided
			// https://docs.microsoft.com/en-us/dotnet/api/system.drawing.systemicons?view=netframework-4.0
			if (_msgIcons != MsgIcons.None) {
				main.msgIcon.Visible = true;

				switch (_msgIcons) {
					case MsgIcons.Question:

						main.msgIcon.Image = System.Drawing.SystemIcons.Question.ToBitmap();
						break;

					case MsgIcons.Info:

						main.msgIcon.Image = System.Drawing.SystemIcons.Information.ToBitmap();
						break;

					case MsgIcons.Warning:

						main.msgIcon.Image = System.Drawing.SystemIcons.Warning.ToBitmap();
						break;

					case MsgIcons.Error:

						main.msgIcon.Image = System.Drawing.SystemIcons.Error.ToBitmap();
						break;

					case MsgIcons.Shield:

						main.msgIcon.Image = System.Drawing.SystemIcons.Shield.ToBitmap();
						break;

					default:
						break;
				}
			} else {
				main.msgIcon.Visible = false;
			}

			// Shows the message and gets the result selected by the user
			return main.ShowDialog();
		}

		// Message icon enum for switch statement in ShowMessage
		// This will set the Image for the PictureBox
		public enum MsgIcons {
			None = 0,
			Question = 1,
			Info = 2,
			Warning = 3,
			Error = 4,
			Shield = 5
		}

		// Message button enum for switch statement in ShowMessage
		// This will set the properties of the form buttons and their DialogResult
		public enum MsgButtons {
			OK = 0,
			OKCancel = 1,
			YesNo = 2
		}
	}
}
