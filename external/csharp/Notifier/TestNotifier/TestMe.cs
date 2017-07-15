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
    public partial class TestMe : Form
    {
        public TestMe()
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

            // It is possible to get the ID of the note on the Creation
            short ID = Notifier.Show(textNote.Text, noteType, textTitle.Text);
        }

        private void buttonUpdate_Click(object sender, EventArgs e)
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

            Notifier.Update((short) numericNote.Value, 
                textNote.Text, noteType, textTitle.Text);
        }

        private void notifyDiagButton_Click(object sender, EventArgs e)
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

            // It is not possible to get the ID of the note on the Creation for dialogs
            Notifier.ShowDialog(textNote.Text, noteType, textTitle.Text, 
                BackDialogStyle.FadedApplication, this);
        }
    }
}
