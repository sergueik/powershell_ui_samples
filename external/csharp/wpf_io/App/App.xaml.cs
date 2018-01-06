using System;
using System.Diagnostics;
using System.Linq;
using System.Windows;

namespace App {
    public static class Program {
        [STAThread]
        public static void Main(String[] args) {
            var proc = Process.GetCurrentProcess();
            var processName = proc.ProcessName.Replace(".vshost", "");
            // NOTE: poor performance !
            var runningProcess = Process.GetProcesses()
                .FirstOrDefault(x => (x.ProcessName == processName || x.ProcessName == proc.ProcessName || x.ProcessName == proc.ProcessName + ".vshost") && x.Id != proc.Id);

            if (runningProcess == null) {
                var app = new App();
                app.InitializeComponent();
                var window = new MainWindow();
                MainWindow.HandleParameter(args);
                app.Run(window);
                return; // In this case we just proceed on loading the program
            }

            if (args.Length > 0) {
                UnsafeNative.SendMessage(runningProcess.MainWindowHandle, String.Join(" ", args));
            }
        }
    }

    public partial class App : Application {
    }
}