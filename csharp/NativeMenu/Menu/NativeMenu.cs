using HudsonClient.Properties;
using DialogWindows;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Reflection;
using System.Resources;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Forms;

namespace Menu {
    class NativeMenu : NativeMenuItemDelegate {
        private AboutWindow AboutWindow;

        public MenuDelegate Delegate { get; set; }

        private ContextMenuStrip _Menu;
        private NotifyIcon _NotifyIcon;
        private ToolStripMenuItem _RefreshMenuItem;
        private List<NativeMenuItem> _MenuItems;

        private ToolStripSeparator _TopMachineSeparator;
        private ToolStripSeparator _BottomMachineSeparator;

       
        private int _RefreshIconFrame;
        private Timer _RefreshTimer;

        public ContextMenuStrip Menu { get { return _Menu; } }

        public NativeMenu() {


            _Menu = new ContextMenuStrip();

            _NotifyIcon = new NotifyIcon() {
            	
            	// Icon=  Icon.FromHandle(bmp.GetHicon());
            	Icon = new System.Drawing.Icon("sample.ico"),
                // Icon = Icon.FromHandle(Resources.vagrant_logo_off.GetHicon()),
                Text = "Vagrant Manager",
                ContextMenuStrip = _Menu,
                Visible = true,
            };
            
           // _NotifyIcon.Icon = Icon.FromHandle(HudsonClient.Properties.Resources.vagrant_logo_on.GetHicon());

            _NotifyIcon.MouseUp += NotifyIcon_MouseUp;

            _MenuItems = new List<NativeMenuItem>();

           // _Menu.Items.Add(_RefreshMenuItem);

            _TopMachineSeparator = new ToolStripSeparator();

            // instances here

            _BottomMachineSeparator = new ToolStripSeparator();
            _Menu.Items.Add(_BottomMachineSeparator);

            ToolStripMenuItem allMachinesMenuItem = new ToolStripMenuItem("All Machines");
            allMachinesMenuItem.DropDownItems.AddRange(new ToolStripMenuItem[] {
            });
            _Menu.Items.Add(allMachinesMenuItem);
        }

        
        #region Control

        public void RebuildMenu() {
            _MenuItems.ForEach(item => item.Refresh());

            List<NativeMenuItem> sortedList = _MenuItems.ToList();

            
            sortedList.ForEach(item => {
                if (_Menu.Items.Contains(item.MenuItem)) {
                    _Menu.Items.Remove(item.MenuItem);
                }

                _Menu.Items.Insert(_Menu.Items.IndexOf(_BottomMachineSeparator), item.MenuItem);
            });

            _MenuItems = sortedList;

            if (_Menu.Items.Contains(_TopMachineSeparator)) {
                _Menu.Items.Remove(_TopMachineSeparator);
            }

            if (_MenuItems.Count > 0) {
                _Menu.Items.Insert(_Menu.Items.IndexOf(_RefreshMenuItem) + 1, _TopMachineSeparator);
            }
            
        }

        private void SetUpdatesAvailable(bool updatesAvailable) {
            //_CheckForUpdatesMenuItem.Image = updatesAvailable ? Resources.status_icon_problem : null;
        }

        private void SetIsRefreshing(bool isRefreshing) {
            _RefreshMenuItem.Enabled = !isRefreshing;
            _RefreshMenuItem.Text = isRefreshing ? "Refreshing..." : "Refresh";

            if (isRefreshing) {
                _RefreshIconFrame = 1;
                _RefreshTimer = new Timer();
                _RefreshTimer.Interval = 200;
                _RefreshTimer.Tick += UpdateRefreshIcon;
                _RefreshTimer.Start();
            } else {
                _RefreshTimer.Stop();
                _RefreshTimer = null;
            }
        }

        private void UpdateRefreshIcon(object s, EventArgs args) {
            _NotifyIcon.Icon = Icon.FromHandle((Resources.ResourceManager.GetObject(String.Format("vagrant_logo_refresh{0}", _RefreshIconFrame)) as Bitmap).GetHicon());

            if(++_RefreshIconFrame > 6) {
                _RefreshIconFrame = 1;
            }
        }

        #endregion


        private void AboutMenuItem_Click(object sender, EventArgs e) {
            AboutWindow = new AboutWindow();
            AboutWindow.StartPosition = FormStartPosition.CenterScreen;
            AboutWindow.Show();
        }


        private void ExitMenuItem_Click(object Sender, EventArgs e) {
            Application.Exit();
        }

        private void NotifyIcon_MouseUp(object sender, MouseEventArgs e) {
            if (e.Button == MouseButtons.Left) {
                MethodInfo mi = typeof(NotifyIcon).GetMethod("ShowContextMenu", BindingFlags.Instance | BindingFlags.NonPublic);
                mi.Invoke(_NotifyIcon, null);
            }
        }

    }
}
