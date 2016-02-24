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
// using HudsonClient.Properties;

namespace HudsonClient {
    public enum VagrantMachineState { UnknownState, NotCreatedState, PowerOffState, SavedState, RunningState, RestoringState }
    public enum PossibleVmStates { running, suspended, off };
    
    class App :  MenuDelegate {
    	public String ProductVersion = "0.1";
        private NativeMenu _NativeMenu;
        
        private int QueuedRefreshes;
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

//            if (Properties.Settings.Default.Guid.Length == 0) {
//                Properties.Settings.Default.Guid = System.Guid.NewGuid().ToString();
//                Properties.Settings.Default.Save();
//            }

            
            Application.ApplicationExit += Application_ApplicationExit;

            var dummy = _NativeMenu.Menu.Handle; // forces handle creation so _NativeMenu.Menu.BeginInvoke can work before the menu was ever clicked

            // this.VerifyVBoxManagePath();

            this.RefreshTimerState();

            Application.Run();
        }

        void Application_ApplicationExit(object sender, EventArgs e) {
        }



        
        public void RefreshTimerState() {
            if (RefreshTimer != null) {
                RefreshTimer.Stop();
                RefreshTimer = null;
            }

        }

        public void VerifyVBoxManagePath() {
            if (!File.Exists(Properties.Settings.Default.VBoxManagePath) && !Properties.Settings.Default.VBoxManagePathPrompted) {

                MessageBox.Show("VBoxManage.exe not found at default location", "Vagrant Manager - Error", MessageBoxButtons.OK, MessageBoxIcon.Error);

                OpenFileDialog dialog = new OpenFileDialog();
                dialog.Title = "Select VBoxManage.exe";
                dialog.Filter = "VBoxManage|VBoxManage.exe";
                if (dialog.ShowDialog() == DialogResult.OK) {
                    DirectoryInfo info = new DirectoryInfo(dialog.FileName);
                    Properties.Settings.Default.VBoxManagePath = info.FullName;
                    Properties.Settings.Default.Save();
                }

            }

            Properties.Settings.Default.VBoxManagePathPrompted = true;
            Properties.Settings.Default.Save();
        }

        
    }
}