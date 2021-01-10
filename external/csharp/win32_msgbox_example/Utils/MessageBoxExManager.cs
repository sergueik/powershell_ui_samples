using System;
using System.IO;
using System.Collections;
using System.Resources;
using System.Reflection;

namespace MessageBoxExLib {
	public class MessageBoxExManager {
		private static Hashtable _messageBoxes = new Hashtable();
		private static Hashtable _savedResponses = new Hashtable();
        private static Hashtable _standardButtonsText = new Hashtable();

        static MessageBoxExManager() {
            try {
                Assembly current = typeof(MessageBoxExManager).Assembly;
                string[] resources = current.GetManifestResourceNames();
                ResourceManager rm = new ResourceManager("Utils.MessageBoxExLib.Resources.StandardButtonsText", typeof(MessageBoxExManager).Assembly);
                _standardButtonsText[MessageBoxExButtons.Ok.ToString()] = rm.GetString("Ok");
                _standardButtonsText[MessageBoxExButtons.Cancel.ToString()] = rm.GetString("Cancel");
                _standardButtonsText[MessageBoxExButtons.Yes.ToString()] = rm.GetString("Yes");
                _standardButtonsText[MessageBoxExButtons.No.ToString()] = rm.GetString("No");
                _standardButtonsText[MessageBoxExButtons.Abort.ToString()] = rm.GetString("Abort");
                _standardButtonsText[MessageBoxExButtons.Retry.ToString()] = rm.GetString("Retry");
                _standardButtonsText[MessageBoxExButtons.Ignore.ToString()] = rm.GetString("Ignore");
            } catch(Exception ex) {
                System.Diagnostics.Debug.Assert(false, "Unable to load resources for MessageBoxEx", ex.ToString());

                //Load default resources
                _standardButtonsText[MessageBoxExButtons.Ok.ToString()] = "Ok";
                _standardButtonsText[MessageBoxExButtons.Cancel.ToString()] = "Cancel";
                _standardButtonsText[MessageBoxExButtons.Yes.ToString()] = "Yes";
                _standardButtonsText[MessageBoxExButtons.No.ToString()] = "No";
                _standardButtonsText[MessageBoxExButtons.Abort.ToString()] = "Abort";
                _standardButtonsText[MessageBoxExButtons.Retry.ToString()] = "Retry";
                _standardButtonsText[MessageBoxExButtons.Ignore.ToString()] = "Ignore";
            }
        }

        public static MessageBoxEx CreateMessageBox(string name) {
			if(name != null && _messageBoxes.ContainsKey(name)) {
				string err = string.Format("A MessageBox with the name {0} already exists.",name);
				throw new ArgumentException(err,"name");
			}

			MessageBoxEx msgBox = new MessageBoxEx();
			msgBox.Name = name;
			if(msgBox.Name != null) {
				_messageBoxes[name] = msgBox;
			}

			return msgBox;
		}

		public static MessageBoxEx GetMessageBox(string name) {
			if(_messageBoxes.Contains(name)) {
				return _messageBoxes[name] as MessageBoxEx;
			} else {
				return null;
			}
		}

		public static void DeleteMessageBox(string name){
			if(name == null)
				return;

			if(_messageBoxes.Contains(name)) {
				MessageBoxEx msgBox = _messageBoxes[name] as MessageBoxEx;
				msgBox.Dispose();
				_messageBoxes.Remove(name);
			}
		}

		public static void WriteSavedResponses(Stream stream) {
			throw new NotImplementedException("This feature has not yet been implemented");
		}

		public static void ReadSavedResponses(Stream stream) {
			throw new NotImplementedException("This feature has not yet been implemented");
		}

		public static void ResetSavedResponse(string messageBoxName) {
            if(messageBoxName == null)
                return;

			if(_savedResponses.ContainsKey(messageBoxName)) {
				_savedResponses.Remove(messageBoxName);
			}
		}

		public static void ResetAllSavedResponses() {
			_savedResponses.Clear();
		}

		internal static void SetSavedResponse(MessageBoxEx msgBox, string response) {
            if(msgBox.Name == null)
                return;
			_savedResponses[msgBox.Name] = response;
		}

		internal static string GetSavedResponse(MessageBoxEx msgBox) {
			string msgBoxName = msgBox.Name;
			return (msgBoxName == null) ?  null:
            (_savedResponses.ContainsKey(msgBoxName)) ?
				_savedResponses[msgBox.Name].ToString(): null;
		}

        internal static string GetLocalizedString(string key) {
          return  (_standardButtonsText.ContainsKey(key)) ?
          	(string)_standardButtonsText[key]: null;            
        }
	}
}
