using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace SeleniumClient
{
	public static class Program
	{
		[STAThread]
		public static void Main()
		{
			Boolean DEBUG = (Environment.GetEnvironmentVariable("DEBUG") == null) ? false : true;

			var parseArgs = new ParseArgs(System.Environment.CommandLine);

			Application.EnableVisualStyles();
			Application.SetCompatibleTextRenderingDefault(false);

			using (var processIcon = new ProcessIcon()) {
				processIcon.Display();
				Application.Run();
			}
		}
	}

}