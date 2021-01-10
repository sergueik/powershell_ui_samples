using System;

namespace MessageBoxExLib {
	public class MessageBoxExButton{
		private string _text = null;
		public string Text {
			get{ return _text; }
			set{ _text = value; }
		}

		private string _value = null;
		public string Value {
			get{ return _value; }
			set{_value = value; }
		}

		private string _helpText = null;
		
		public string HelpText {
			get{ return _helpText; }
			set{ _helpText = value; }
		}

		private bool _isCancelButton = false;
		public bool IsCancelButton {
			get{ return _isCancelButton; }
			set{ _isCancelButton = value; }
		}
	}
}
