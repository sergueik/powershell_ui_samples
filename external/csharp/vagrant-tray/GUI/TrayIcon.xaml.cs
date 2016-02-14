using System.Diagnostics;
using System.Windows;
using System.Windows.Controls;
using VagrantTray.Classes;

namespace VagrantTray.GUI
{
    public partial class TrayIcon : Window
    {
        public TrayIcon()
        {
            while (!App.Settings.IsBoxesPathValid() || !App.Settings.IsVagrantPathValid())
            {
                ShowSettingsDialog();
            }

            // Load all the Vagrant boxes in the folder
            App.Settings.LoadVagrantBoxes();

            InitializeComponent();

            // Setup the version number in the tray
            Version.Header = "VagrantTray v" + Classes.Settings.Version;

            // Setup a reference to our TaskBar
            App.Settings.TaskBar = TaskBar;

            // Setup the Boxes Menu
            SetupBoxesMenu();
        }

        private void SetupBoxesMenu()
        {
            Boxes.Items.Clear();

            foreach (var box in App.Settings.VagrantBoxes)
            {
                // Create the new menu item
                var item = new MenuItem
                {
                    Header = box.Name,
                    Tag = box
                };

                box.TrayItem = item;

                // Create the Start/Halt menu item
                var startHaltItem = new MenuItem
                {
                    Header = "Start/Halt",
                    Tag = box
                };
                startHaltItem.Click += startHaltItem_Click;
                item.Items.Add(startHaltItem);

                // Create the Open Folder menu item
                var openFolderItem = new MenuItem
                {
                    Header = "Open Folder",
                    Tag = box
                };
                openFolderItem.Click += openFolderItem_Click;
                item.Items.Add(openFolderItem);

                // Create the SSH menu item
                var sshItem = new MenuItem
                {
                    Header = "SSH",
                    Tag = box
                };
                sshItem.Click += sshItem_Click;
                item.Items.Add(sshItem);

                Boxes.Items.Add(item);

                box.StatusAsync();
            }

            if (Boxes.Items.Count == 0)
            {
                Boxes.Items.Add(new MenuItem
                {
                    Header = "No Boxes Found",
                    IsEnabled = false
                });
            }
        }

        private void ShowSettingsDialog()
        {
            new SettingsDialog().ShowDialog();
        }

        private void startHaltItem_Click(object sender, RoutedEventArgs e)
        {
            var item = (MenuItem) sender;
            var box = (VagrantBox) item.Tag;

            box.UpOrHaltAsync();
        }

        private void openFolderItem_Click(object sender, RoutedEventArgs e)
        {
            var item = (MenuItem) sender;
            var box = (VagrantBox) item.Tag;

            box.OpenFolder();
        }

        private void sshItem_Click(object sender, RoutedEventArgs e)
        {
            var item = (MenuItem) sender;
            var box = (VagrantBox) item.Tag;

            box.SSH();
        }

        /// <summary>
        ///     Opens up the users default browser to the GitHub repository for this application
        /// </summary>
        private void OpenGitHub_Click(object sender, RoutedEventArgs e)
        {
            Process.Start("https://github.com/RyanTheAllmighty/VagrantTray");
        }

        /// <summary>
        ///     Shows the Settings dialog for the application
        /// </summary>
        private void Settings_Click(object sender, RoutedEventArgs e)
        {
            ShowSettingsDialog();
        }

        /// <summary>
        ///     Exits the application
        /// </summary>
        private void Exit_Click(object sender, RoutedEventArgs e)
        {
            App.Settings.Save();
            Application.Current.Shutdown();
        }
    }
}