using System.Windows;
using Microsoft.WindowsAPICodePack.Dialogs;

namespace VagrantTray.GUI
{
    public partial class SettingsDialog : Window
    {
        public SettingsDialog()
        {
            InitializeComponent();

            txtBoxesPath.Text = App.Settings.BoxesPath;
            txtVagrantPath.Text = App.Settings.VagrantPath;
        }

        private void btnBoxesPath_Click(object sender, RoutedEventArgs e)
        {
            var dialog = new CommonOpenFileDialog
            {
                Multiselect = false,
                IsFolderPicker = true
            };

            if (dialog.ShowDialog() == CommonFileDialogResult.Ok)
            {
                txtBoxesPath.Text = dialog.FileName;
            }
        }

        private void btnVagrantPath_Click(object sender, RoutedEventArgs e)
        {
            var dialog = new CommonOpenFileDialog
            {
                Multiselect = false,
                IsFolderPicker = false
            };

            dialog.Filters.Add(new CommonFileDialogFilter
            {
                DisplayName = "Executables",
                Extensions = { "exe" },
                ShowExtensions = true
            });

            if (dialog.ShowDialog() == CommonFileDialogResult.Ok)
            {
                txtVagrantPath.Text = dialog.FileName;
            }
        }

        private void btnSave_Click(object sender, RoutedEventArgs e)
        {
            App.Settings.BoxesPath = txtBoxesPath.Text;
            App.Settings.VagrantPath = txtVagrantPath.Text;
            App.Settings.Save();
            Close();
        }

        private void btnCancel_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }
    }
}