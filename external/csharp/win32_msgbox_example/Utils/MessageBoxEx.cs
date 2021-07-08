using System;
using System.Drawing;
using System.Windows.Forms;

namespace MessageBoxExLib {
	public class MessageBoxEx {
		private MessageBoxExForm _msgBox = new MessageBoxExForm();
		private bool _useSavedResponse = true;
		private string _name = null;

		internal string Name {
			get{ return _name; }
			set{ _name = value; }
		}

		public string Caption {
			get { return _msgBox.Caption; }
			set{ _msgBox.Caption = value; }
		}

		public string Text {
			get { return _msgBox.Message; }
			set{ _msgBox.Message = value; }
		}

		/// <summary>
		/// Sets the icon to show in the message box
		/// </summary>
		public Icon CustomIcon
		{
			set{_msgBox.CustomIcon = value;}
		}

		/// <summary>
		/// Sets the icon to show in the message box
		/// </summary>
		public MessageBoxExIcon Icon
		{
			set{ _msgBox.StandardIcon = (MessageBoxIcon)Enum.Parse(typeof(MessageBoxIcon), value.ToString());}
		}
		
		public Font Font {
			set{_msgBox.Font = value;}
		}

		public bool AllowSaveResponse {
			get{ return _msgBox.AllowSaveResponse; }
			set{ _msgBox.AllowSaveResponse = value; }
		}

		public string SaveResponseText {
			set{_msgBox.SaveResponseText = value; }
		}

		public bool UseSavedResponse {
			get{ return _useSavedResponse; }
			set{ _useSavedResponse = value; }
		}

		public bool PlayAlsertSound {
			get{ return _msgBox.PlayAlertSound; }
			set{ _msgBox.PlayAlertSound = value; }
		}

        public int Timeout {
            get{ return _msgBox.Timeout; }
            set{ _msgBox.Timeout = value; }
        }
        public TimeoutResult TimeoutResult
        {
            get{ return _msgBox.TimeoutResult; }
            set{ _msgBox.TimeoutResult = value; }
        }

		public string Show() {
			return Show(null);
		}

		public string Show(IWin32Window owner) {
			if(_useSavedResponse && this.Name != null) {
				string savedResponse = MessageBoxExManager.GetSavedResponse(this);
				if( savedResponse != null)
					return savedResponse;
			}
			
			if(owner == null) {
				_msgBox.ShowDialog();
			} else {
				_msgBox.ShowDialog(owner);
			}

            if(this.Name != null) {
                if(_msgBox.AllowSaveResponse && _msgBox.SaveResponse)
                    MessageBoxExManager.SetSavedResponse(this, _msgBox.Result);
                else
                    MessageBoxExManager.ResetSavedResponse(this.Name);
            } else {
                Dispose();
            }

			return _msgBox.Result;
		}

		public void AddButton(MessageBoxExButton button) {
			if(button == null)
				throw new ArgumentNullException("button","A null button cannot be added");

			_msgBox.Buttons.Add(button);

			if(button.IsCancelButton) {
				_msgBox.CustomCancelButton = button;
			}
		}

		public void AddButton(string text, string val) {
			if(text == null)
				throw new ArgumentNullException("text","Text of a button cannot be null");

			if(val == null)
				throw new ArgumentNullException("val","Value of a button cannot be null");

			MessageBoxExButton button = new MessageBoxExButton();
			button.Text = text;
			button.Value = val;

			AddButton(button);
		}
        
		public void AddButton(MessageBoxExButtons button) {
            string buttonText = MessageBoxExManager.GetLocalizedString(button.ToString());
            if(buttonText == null) {
                buttonText = button.ToString();
            }

            string buttonVal = button.ToString();

            MessageBoxExButton btn = new MessageBoxExButton();
            btn.Text = buttonText;
            btn.Value = buttonVal;

            if(button == MessageBoxExButtons.Cancel) {
                btn.IsCancelButton = true;
            }

			AddButton(btn);
		}

		public void AddButtons(MessageBoxButtons buttons) {
			switch(buttons) {
				case MessageBoxButtons.OK:
					AddButton(MessageBoxExButtons.Ok);
					break;

				case MessageBoxButtons.AbortRetryIgnore:
					AddButton(MessageBoxExButtons.Abort);
					AddButton(MessageBoxExButtons.Retry);
					AddButton(MessageBoxExButtons.Ignore);
					break;

				case MessageBoxButtons.OKCancel:
					AddButton(MessageBoxExButtons.Ok);
					AddButton(MessageBoxExButtons.Cancel);
					break;

				case MessageBoxButtons.RetryCancel:
					AddButton(MessageBoxExButtons.Retry);
					AddButton(MessageBoxExButtons.Cancel);
					break;

				case MessageBoxButtons.YesNo:
					AddButton(MessageBoxExButtons.Yes);
					AddButton(MessageBoxExButtons.No);
					break;

				case MessageBoxButtons.YesNoCancel:
					AddButton(MessageBoxExButtons.Yes);
					AddButton(MessageBoxExButtons.No);
					AddButton(MessageBoxExButtons.Cancel);
					break;
			}
		}
		
		internal MessageBoxEx() {
		}

		internal void Dispose() {
			if(_msgBox != null) {
				_msgBox.Dispose();
			}
		}
	}
}
