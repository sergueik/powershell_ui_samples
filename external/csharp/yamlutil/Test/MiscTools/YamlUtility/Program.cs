using System;
using System.Collections.Generic;
using System.Windows.Forms;

[assembly: System.Reflection.AssemblyTitle("YamlUtility")]
[assembly: System.Reflection.AssemblyProduct("YamlUtility")]
[assembly: System.Reflection.AssemblyVersion("2009.7.22")]

namespace QiHe.Yaml.YamlUtility.UI
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainForm());
        }
    }
}