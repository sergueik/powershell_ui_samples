using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;
using Hardcodet.Wpf.TaskbarNotification;
using VagrantTray.Classes;

namespace VagrantTray
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        /// <summary>
        /// The Settings for the app
        /// </summary>
        public static Settings Settings = new Settings();

        public App()
        {
            Settings.Load();
        }
    }
}
