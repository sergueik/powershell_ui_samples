using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Demo
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            linkReference.LinkClicked += linkReference_LinkClicked;
        }
        protected override void OnLoad(EventArgs e)
        {
            txtDateFormat.Text = GetSetting("DateFormat", "");
            if (string.IsNullOrEmpty(txtDateFormat.Text))
                txtDateFormat.Text = "MM/dd/yyyy";

            txtTimeFormat.Text = GetSetting("TimeFormat", "");

            SetDateFormat();
            SetTimeFormat();

            txtValidDate.Text = "Month:\t'M'\r\nDay:\t'd'\r\nYear\t'y'";
            txtValidTime.Text = "Hour (12-Hour)\t'h'\r\nHour (24 Hour)\t'H'\r\nMinute\t\t'm'\r\nSecond\t\t's'\r\nAM/PM\t\t'tt'\r\n  (12-Hour Only)";
            base.OnLoad(e);
        }
        private void btnDateSet_Click(object sender, EventArgs e)
        {
            if (SetDateFormat())
                MessageBox.Show("Date format string property set.", "Success!", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        private bool SetDateFormat()
        {
            ctlDateTimePicker1.DateFormat = txtDateFormat.Text;
            return ctlDateTimePicker1.ValidFormatStrings;
        }
        private void btnTimeFormat_Click(object sender, EventArgs e)
        {
            if (SetTimeFormat())
                MessageBox.Show("Time format string property set.", "Success!", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        private bool SetTimeFormat()
        {
            ctlDateTimePicker1.TimeFormat = txtTimeFormat.Text;
            return ctlDateTimePicker1.ValidFormatStrings;
        }

        private void btnSaveFormat_Click(object sender, EventArgs e)
        {
            SaveSetting("DateFormat", txtDateFormat.Text);
            SaveSetting("TimeFormat", txtTimeFormat.Text);

            MessageBox.Show("Date and Time Formats Saved.", "Save Formats", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void btnClose_Click(object sender, EventArgs e)
        {
            Close();
        }
        void linkReference_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            System.Diagnostics.Process.Start(linkReference.Text);
        }

        #region Registry Methods

        protected void SaveSetting(string szValueName, string szValue)
        {
            string szKeyName = "HKEY_CURRENT_USER\\CompleteDateTimePicker";

            Microsoft.Win32.Registry.SetValue(szKeyName, szValueName, szValue);
        }
        protected string GetSetting(string szValueName)
        {
            return GetSetting(szValueName, "");
        }
        protected string GetSetting(string szValueName, string szDefaultValue)
        {
            string szKeyName = "HKEY_CURRENT_USER\\CompleteDateTimePicker";

            string szReturn = (string)Microsoft.Win32.Registry.GetValue(szKeyName, szValueName, szDefaultValue);
            if (string.IsNullOrEmpty(szReturn))
                szReturn = "";

            return szReturn;
        }
        #endregion
    }
}
