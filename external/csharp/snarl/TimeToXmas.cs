using System;
using System.Reflection;
using libSnarlExtn;
using Snarl.V42;

// origin: https://sourceforge.net/p/snarlwin/code/HEAD/tree/trunk/src/samples/dotnet/extensions/TimeToXmas

namespace SnarlExtensions
{
	[System.Runtime.InteropServices.ProgId("TimeToXmas.extension")]
	public class TimeToXmas : ISnarlExtension
	{
		private readonly String VersionDate = DateTime.Parse("2011-09-18").ToLongDateString();
		private const String Release = "1.1";
		// Extension version - displayed after extension name in Extensions list
		private const int Revision = 1;
		// Can be any non-zero number
		private const int SnarlApiVersion = 41;
		// Version should be 41 (to indicate V41 API support)

		private readonly String ApplicationName = "TimeToXmas";
		private readonly String IconPath = Assembly.GetExecutingAssembly().Location + ",101";

		private SnarlInterface snarl = null;

		/// <summary>
		/// Called when the user clicks "Configure..." button in Snarl.
		/// (Only if we passed in SNARL_EXTENSION_FLAGS.SNARL_EXTN_IS_CONFIGURABLE in info.Flags)
		/// </summary>
		public int GetConfigWindow()
		{
			snarl.Notify(null, ApplicationName, "Config invoked");
			return (int)SnarlInterface.SnarlStatus.Success;
		}

		/// <summary>
		/// Called by Snarl to get details about the extension - 
		/// this is called before <see cref="Initialize()"/> and <see cref="Start()"/>.
		/// </summary>
		public void GetInfo(ref extension_info info)
		{
			// The info struct is filled according to the discussion found here:
			// http://groups.google.com/group/snarl-development/browse_thread/thread/53a5677b15fa9e68

			info.Author = "Toke Noer";
			info.Copyright = "Copyright © Noer.IT 2011";
			info.Date = VersionDate;
			info.Description = "Shows time until it is Christmas on every startup";
			// info.Flags     = SNARL_EXTENSION_FLAGS.SNARL_EXTN_IS_CONFIGURABLE | SNARL_EXTENSION_FLAGS.SNARL_EXTN_WANTS_PULSE;
			info.IconPath = IconPath;
			info.Name = ApplicationName;
			info.Path = Assembly.GetExecutingAssembly().Location;
			info.Release = Release;
			info.Revision = Revision;
			info.SupportEmail = "toke@noer.it";
			info.URL = "http://www.noer.it/Snarl/";
			info.Version = SnarlApiVersion; // API version
		}

		/// <summary>
		/// Initialize is called when Snarl want to initialize the extension.
		/// </summary>
		/// <returns>Extension must return SnarlStatus.Success - any other return code and Snarl won't load the extension.</returns>
		public int Initialize()
		{
			snarl = new SnarlInterface();
			snarl.Register("Noer.IT/" + ApplicationName, ApplicationName, IconPath);

			return (int)SnarlInterface.SnarlStatus.Success;
		}

		/// <summary>
		/// When returning an error code from f.x. <see cref="Initialize"/>, Snarl calls this
		/// function to get a detailed description of the error.
		/// </summary>
		/// <param name="Description"></param>
		public void LastError(ref string Description)
		{

		}

		/// <summary>
		/// Pulse is called periodically (~ every 250ms) from Snarl if we set:
		/// info.Flags = SNARL_EXTENSION_FLAGS.SNARL_EXTN_WANTS_PULSE;
		/// </summary>
		public void Pulse()
		{
			// snarl.Notify(null, ApplicationName, "Pulse");
		}

		/// <summary>
		/// Start is called after <see cref="Initialze"/> - the plugin should start doing it's work.
		/// </summary>
		public void Start()
		{
			ShowMessage();
		}

		/// <summary>
		/// Stop is called before <see cref="TidyUp"/> on shutdown
		/// - in the future it might be called if Snarl wants to temporarely stop the extension.
		/// (Ie. when Snarl enters Away mode) So stop periodic updates etc.
		/// </summary>
		public void Stop()
		{
			// snarl.Notify(null, ApplicationName, "Stop");
		}

		/// <summary>
		/// TidyUp is called when the extension is about to get unloaded.
		/// </summary>
		public void TidyUp()
		{
			// snarl.Notify(null, ApplicationName, "TidyUp");
			if (snarl != null)
				snarl.Unregister();
		}

		/// <summary>
		/// Show Snarl message with time until X-Mas.
		/// </summary>
		private void ShowMessage()
		{
			DateTime xmas = new DateTime(DateTime.Now.Year, 12, 24, 23, 59, 59);
			int days = (int)(xmas - DateTime.Now).TotalDays;
			String msg = String.Format("There is {0} day{1} until christmas.", days, days == 1 ? "" : "s");
			snarl.Notify(null, ApplicationName, msg, null, IconPath, null);
		}
	}
}
