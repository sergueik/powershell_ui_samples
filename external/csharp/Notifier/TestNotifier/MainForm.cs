//
//      MainForm.cs
//
//      Operation of the test application
//
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

using Notify;                                              // Add a reference to your project and then include this NS

namespace TestNotifier
{
    /// <summary>
    /// Frontend operations - MainForm.cs
    /// </summary>
    public partial class MainForm : Form
    {
        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Main constructor
        //-------------------------------------------------------------------------------------------------------------------------------
        public MainForm()
        {
            InitializeComponent();
        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Event for "Notify" button
        //-------------------------------------------------------------------------------------------------------------------------------
        private void onNotifyButtonClick(object sender, EventArgs e)
        {
            Notifier.Type noteType = Notifier.Type.INFO;

            if (radioButtonInfo.Checked)
                noteType = Notifier.Type.INFO;                          // Note type INFO

            if (radioButtonOk.Checked)
                noteType = Notifier.Type.OK;                            // Note type OK

            if (radioButtonWarning.Checked)
                noteType = Notifier.Type.WARNING;                       // Note type WARNING

            if (radioButtonError.Checked)
                noteType = Notifier.Type.ERROR;                         // Note type ERROR

            if (!(bool)inApp.Checked)
            {
                short ID = Notifier.Show(textNote.Text,                 // It is possible to get the ID of the note on the Creation
                                         noteType, 
                                         textTitle.Text, 
                                         false, 
                                         (int) timeout.Value);
            }
            else
            {
                short ID = Notifier.Show(textNote.Text,                 // It is possible to get the ID of the note on the Creation 
                                         noteType, 
                                         textTitle.Text, 
                                         false, 
                                         (int) timeout.Value, 
                                         this);
            }   
        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Event for "Notify Dialog" button
        //-------------------------------------------------------------------------------------------------------------------------------
        private void oNotifyDialogButtonClick(object sender, EventArgs e)
        {
            Notifier.Type noteType = Notifier.Type.INFO;
            BackDialogStyle back = BackDialogStyle.FadedApplication;

            // Note type
            if (radioButtonInfo.Checked)
                noteType = Notifier.Type.INFO;                  // Note type INFO

            if (radioButtonOk.Checked)
                noteType = Notifier.Type.OK;                    // Note type OK

            if (radioButtonWarning.Checked)
                noteType = Notifier.Type.WARNING;               // Note type WARNING

            if (radioButtonError.Checked)
                noteType = Notifier.Type.ERROR;                 // Note type ERROR

            if (backNone.Checked)
                back = BackDialogStyle.None;                    // Faded Background type: None

            if (backApp.Checked)
                back = BackDialogStyle.FadedApplication;        // Faded Background type: Application

            if (backFull.Checked)
                back = BackDialogStyle.FadedScreen;             // Faded Background type: Fullscreen

            Notifier.ShowDialog(textNote.Text,                  // It is not possible to get the ID of the note on the Creation for dialogs// It is not possible to get the ID of the note on the Creation for dialogs
                                noteType, 
                                textTitle.Text, 
                                back, 
                                this);
        }

        //-------------------------------------------------------------------------------------------------------------------------------
        //                                  Event for "Update" button
        //-------------------------------------------------------------------------------------------------------------------------------
        private void onUpdateButtonClick(object sender, EventArgs e)
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

            Notifier.Update((short) numericNote.Value,                      // Update the note 
                            textNote.Text, 
                            noteType, 
                            textTitle.Text);
        }
    }
}
