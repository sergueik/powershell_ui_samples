using System;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;

// based on: https://www.codeproject.com/Articles/1966/An-INI-file-handling-class-using-C
// NOTE: no p/invoke method to read sections
namespace Utils
{
	public class IniFileNative
	{
		public string path;

		[DllImport("kernel32")]
		private static extern long WritePrivateProfileString(string section, string key, string val, string filePath);
		[DllImport("kernel32")]
		private static extern uint GetPrivateProfileString(string section, string key, string def, StringBuilder retVal, uint size, string filePath);

		public IniFileNative(string path) {
			this.path = path;
		}

		public void WriteValue(string Section, string Key, string Value) {
			WritePrivateProfileString(Section, Key, Value, this.path);
		}
		
		// see also: https://www.pinvoke.net/default.aspx/kernel32.getprivateprofilestring
		public string ReadValue(string Section, string Key) { 
			StringBuilder sb = new StringBuilder(500);
			uint i = GetPrivateProfileString(Section, Key, "", sb, (uint)sb.Capacity, this.path);
			String result = sb.ToString();
			return result;
		}
	}
}