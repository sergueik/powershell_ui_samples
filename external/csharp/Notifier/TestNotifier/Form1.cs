using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

// Add a reference to your project and then include this NS
using Notify;

namespace TestNotifier
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void notifyButton_Click(object sender, EventArgs e)
        {
            Notifier.Type noteType = Notifier.Type.INFO;

            if (radioButtonInfo.Checked)
                noteType = Notifier.Type.INFO;

            if (radioButtonOk.Checked)
                noteType = Notifier.Type.OK;

            if (radioButtonWarning.Checked)
                noteType = Notifier.Type.WARNING;

            if (radioButtonError.Checked)
                noteType = Notifier.Type.ERROR;

            new Notifier(textNote.Text, noteType, textTitle.Text).Show();
        }
    }
}
