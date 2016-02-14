using System;
using System.ComponentModel;
using System.Diagnostics;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media.Imaging;
using Hardcodet.Wpf.TaskbarNotification;

namespace VagrantTray.Classes
{
    /// <summary>
    ///     Simple enum for the different statuses that a box can have
    /// </summary>
    public enum VagrantBoxStatus
    {
        Unknown,
        On,
        Off,
        Working
    }

    /// <summary>
    ///     Simple class for holding result data from a Vagrant command
    /// </summary>
    public class VagrantOutput
    {
        public string Output { get; set; }
        public string Error { get; set; }
        public int ExitCode { get; set; }
    }

    /// <summary>
    ///     Class which holds data and methods for a single Vagrant box
    /// </summary>
    public class VagrantBox
    {
        public string Name { get; set; }
        public string Path { get; set; }
        public MenuItem TrayItem { get; set; }

        /// <summary>
        ///     Checks to see if this box is started or not
        /// </summary>
        public bool IsOn()
        {
            return GetStatus() == VagrantBoxStatus.On;
        }

        /// <summary>
        ///     Checks to see if this box is running or not
        /// </summary>
        public VagrantBoxStatus GetStatus()
        {
            var output = RunVagrantCommand("status");

            // If the output contains the word running then we can probably assume the box is now running
            return (output.Output.Contains("running") ? VagrantBoxStatus.On : VagrantBoxStatus.Off);
        }

        /// <summary>
        ///     Returns an Icon for use in the tray for a given status
        /// </summary>
        public Image GetStatusIcon(VagrantBoxStatus status)
        {
            var icon = new Image();
            var bmImage = new BitmapImage();
            bmImage.BeginInit();
            bmImage.UriSource = new Uri("pack://application:,,,/Resources/" + status + ".png",
                UriKind.RelativeOrAbsolute);
            bmImage.EndInit();
            icon.Source = bmImage;
            icon.MaxWidth = 25;

            return icon;
        }

        public void UpdateStatusIcon(VagrantBoxStatus status)
        {
            Application.Current.Dispatcher.Invoke(delegate
            {
                var startHaltItem = (MenuItem) TrayItem.Items.GetItemAt(0);
                startHaltItem.Header = (status == VagrantBoxStatus.On ? "Halt" : "Start");
                startHaltItem.IsEnabled = status != VagrantBoxStatus.Working;

                var sshItem = (MenuItem)TrayItem.Items.GetItemAt(2);
                sshItem.IsEnabled = status == VagrantBoxStatus.On;

                TrayItem.Icon = GetStatusIcon(status);
            });
        }

        /// <summary>
        ///     Runs a given Vagrant command on this box
        /// </summary>
        private VagrantOutput RunVagrantCommand(string command)
        {
            var startInfo = new ProcessStartInfo
            {
                WorkingDirectory = Path,
                FileName = App.Settings.VagrantPath,
                Arguments = command,
                CreateNoWindow = true,
                UseShellExecute = false,
                RedirectStandardOutput = true,
                RedirectStandardError = true
            };

            var output = new StringBuilder();
            var error = new StringBuilder();

            var process = Process.Start(startInfo);

            if (process == null)
            {
                return null;
            }

            process.OutputDataReceived += delegate(object sender, DataReceivedEventArgs e) { output.Append(e.Data); };

            process.ErrorDataReceived += delegate(object sender, DataReceivedEventArgs e) { error.Append(e.Data); };

            process.BeginOutputReadLine();
            process.BeginErrorReadLine();
            process.WaitForExit();

            return new VagrantOutput
            {
                Output = output.ToString(),
                Error = error.ToString(),
                ExitCode = process.ExitCode
            };
        }

        /// <summary>
        ///     Checks the output of running a Vagrant command to see if there were any errors or not to guess if the command ran
        ///     successfully or not
        /// </summary>
        private bool CommandWasSuccess(VagrantOutput output)
        {
            return (output.ExitCode == 0 && output.Error.Length == 0 ? true : false);
        }

        public void SSH()
        {
            var startInfo = new ProcessStartInfo
            {
                WorkingDirectory = Path,
                FileName = App.Settings.VagrantPath,
                Arguments = "ssh",
                CreateNoWindow = false
            };

            Process.Start(startInfo);
        }

        public void StatusAsync()
        {
            UpdateStatusIcon(VagrantBoxStatus.Working);

            var worker = new BackgroundWorker();

            worker.DoWork += StatusWorker;

            worker.RunWorkerAsync();
        }

        private void StatusWorker(object sender, DoWorkEventArgs e)
        {
            UpdateStatusIcon(GetStatus());
        }

        public void UpOrHaltAsync()
        {
            UpdateStatusIcon(VagrantBoxStatus.Working);

            var worker = new BackgroundWorker();

            worker.DoWork += UpOrHaltWorker;

            worker.RunWorkerAsync();
        }

        private void UpOrHaltWorker(object sender, DoWorkEventArgs e)
        {
            var status = GetStatus() == VagrantBoxStatus.Off ? Up() : Halt();

            switch (status)
            {
                case VagrantBoxStatus.On:
                    App.Settings.ShowBalloon("Vagrant Box '" + Name + "' Now Up",
                        "The Vagrant box '" + Name + "' has been started and is now online!");
                    break;
                case VagrantBoxStatus.Off:
                    App.Settings.ShowBalloon("Vagrant Box '" + Name + "' Now Down",
                        "The Vagrant box '" + Name + "' has been halted and is now offline!");
                    break;
                default:
                    App.Settings.ShowBalloon("Vagrant Box '" + Name + "' Errored",
                        "The Vagrant box '" + Name + "' had an error!", BalloonIcon.Error);
                    break;
            }

            UpdateStatusIcon(status);
        }

        public void UpAsync()
        {
            UpdateStatusIcon(VagrantBoxStatus.Working);

            var worker = new BackgroundWorker();

            worker.DoWork += UpWorker;

            worker.RunWorkerAsync();
        }

        private VagrantBoxStatus Up()
        {
            var output = RunVagrantCommand("up");

            // If the exit code is 0 and there are no errors from StdErr then assume we're now up, else find out what it is
            return CommandWasSuccess(output) ? VagrantBoxStatus.On : GetStatus();
        }

        private void UpWorker(object sender, DoWorkEventArgs e)
        {
            var output = RunVagrantCommand("up");

            // If the exit code is 0 and there are no errors from StdErr then assume we're now up, else find out what it is
            UpdateStatusIcon(CommandWasSuccess(output) ? VagrantBoxStatus.On : GetStatus());
        }

        public void HaltAsync()
        {
            UpdateStatusIcon(VagrantBoxStatus.Working);

            var worker = new BackgroundWorker();

            worker.DoWork += HaltWorker;

            worker.RunWorkerAsync();
        }

        public VagrantBoxStatus Halt()
        {
            var output = RunVagrantCommand("halt");

            // If the exit code is 0 and there are no errors from StdErr then assume we're now halted, else assume find out what it is
            return CommandWasSuccess(output) ? VagrantBoxStatus.Off : GetStatus();
        }

        private void HaltWorker(object sender, DoWorkEventArgs e)
        {
            var output = RunVagrantCommand("halt");

            // If the exit code is 0 and there are no errors from StdErr then assume we're now halted, else assume find out what it is
            UpdateStatusIcon(CommandWasSuccess(output) ? VagrantBoxStatus.Off : GetStatus());
        }

        public void OpenFolder()
        {
            Process.Start(Path);
        }
    }
}