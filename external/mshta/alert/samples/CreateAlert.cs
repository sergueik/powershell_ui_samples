using System;
using System.IO;

namespace CreateAlert
{
	class CreateAlert
	{
		[STAThread]
		static void Main(string[] args)
		{
			TextWriter output = File.AppendText("c:\\MyAlerts\\queue\\" + System.Guid.NewGuid()+".txt");
			output.Write("Hello Microsoft|http://www.microsoft.com|en-UK_female");
			output.Close();
		}
	}
}
