using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Menu;
using System.IO;

namespace HudsonClient {
    public enum VagrantMachineState { UnknownState, NotCreatedState, PowerOffState, SavedState, RunningState, RestoringState }
    public enum PossibleVmStates { running, suspended, off };
    
    class App :  MenuDelegate {
    	public String ProductVersion = "0.1";
        private NativeMenu _NativeMenu;
        
        private static App _Instance;
        public Timer RefreshTimer { get; set; }

        public static App Instance {
            get {
                if (_Instance == null) {
                    _Instance = new App();
                }
                return _Instance;
            }
        }

        public void Run() {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            _NativeMenu = new NativeMenu();
            _NativeMenu.Delegate = this;
            
            Application.ApplicationExit += Application_ApplicationExit;

            var dummy = _NativeMenu.Menu.Handle; 
            // forces handle creation so _NativeMenu.Menu.BeginInvoke can work before the menu was ever clicked

            Application.Run();
        }

        void Application_ApplicationExit(object sender, EventArgs e) {
        }
        
    }
}