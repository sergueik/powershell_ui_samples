using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace SeleniumClient {
    public static class Program
    {
        [STAThread]
        public static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            using (ProcessIcon pi = new ProcessIcon())
            {
                pi.Display();

                Application.Run();
            }
        }
    }

}