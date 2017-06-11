using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

namespace PowershellStarter {
	static class Program {
		static void Main() {
			ServiceBase[] ServicesToRun;
			ServicesToRun = new ServiceBase[] {
				new PowershellStarterService()
			};
			ServiceBase.Run(ServicesToRun);
		}
	}
}