using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Threading;
using System.Windows.Forms;

namespace LoadingIndicator
{
    public partial class formLoading : Form
    {
        private const string VOWELS = "[aeiouAEIOU]";
        private const string CONSONANTS = "[b-df-hj-np-tv-zB-DF-HJ-NP-TV-Z]";
        private const string NUMBERS = "[0-9]";
        private const string SPECIALCHARS = "[^a-zA-Z0-9]";

        public formLoading()
        {
            InitializeComponent();
            dgvOutput.Visible = false;
            picLoader.Visible = false;
        }

        private void btnBrowse_Click(object sender, EventArgs e)
        {
            try
            {
                var dialog = new OpenFileDialog();
                dialog.Title = "Browse Text Files";
                dialog.DefaultExt = "txt";
                dialog.CheckFileExists = true;
                dialog.Filter = "Text files (*.txt)|*.txt|All files (*.*)|*.*";
                dialog.Multiselect = false;

                dialog.ShowDialog();

                var fileName = dialog.FileName;
                txtFilePath.Text = fileName;

            }
            catch (Exception ex)
            {
                DisplayError(ex);
            }
        }

        private void btnFind_Click(object sender, EventArgs e)
        {
            try
            {
                Thread threadInput = new Thread(DisplayData);
                threadInput.Start();
            }
            catch (Exception ex)
            {

                DisplayError(ex);
            }
        }

        private void DisplayData()
        {
            SetLoading(true);

            // Added to see the indicator (not required)
            Thread.Sleep(4000);

            var charType = string.Empty;
            var path = string.Empty;

            this.Invoke((MethodInvoker)delegate
            {
                charType = cmbCharacterType.Text;

                path = txtFilePath.Text.Trim();
            });

            if (string.IsNullOrWhiteSpace(path))
            {
                MessageBox.Show("Kindly choose a text file.");
                SetLoading(false);
                return;
            }

            if (string.IsNullOrWhiteSpace(charType))
            {
                MessageBox.Show("Kindly choose the character type.");
                SetLoading(false);
                return;
            }

            string[] lines = System.IO.File.ReadAllLines(path);

            var regex = string.Empty;

            switch (charType)
            {
                case "Vowels":
                    regex = VOWELS;
                    break;
                case "Consonants":
                    regex = CONSONANTS;
                    break;
                case "Numbers":
                    regex = NUMBERS;
                    break;
                case "Special Characters":
                    regex = SPECIALCHARS;
                    break;
            }

            var count = 1;
            var lstOutput = new List<LineInfo>();

            foreach (string line in lines)
            {
                var matchCollection = Regex.Matches(line, regex);
                var lstMatches = new List<string>();

                foreach (Match match in matchCollection)
                {
                    lstMatches.Add(match.Value);
                }

                var lineInfo = new LineInfo
                {
                    LineNumber = count,
                    Count = lstMatches.Count,
                    Text = string.Join(", ", lstMatches)
                };

                lstOutput.Add(lineInfo);
                count++;
            }

            this.Invoke((MethodInvoker)delegate
               {
                   dgvOutput.DataSource = null;
                   dgvOutput.DataSource = lstOutput;
                   dgvOutput.ClearSelection();
                   dgvOutput.Visible = true;
                   if (dgvOutput.Rows.Count > 0)
                   {
                       dgvOutput.Columns["Text"].DisplayIndex = 2;
                       dgvOutput.Columns["Text"].Width = 423;
                       dgvOutput.Columns["LineNumber"].Width = 90;
                       dgvOutput.Columns["Count"].Width = 90;
                   }
               });

            SetLoading(false);
        }

        private void SetLoading(bool displayLoader)
        {
            if (displayLoader)
            {
                this.Invoke((MethodInvoker)delegate
                {
                    picLoader.Visible = true;
                    this.Cursor = Cursors.WaitCursor;
                });
            }
            else
            {
                this.Invoke((MethodInvoker)delegate
                {
                    picLoader.Visible = false;
                    this.Cursor = Cursors.Default;
                });
            }
        }

        private void DisplayError(Exception ex)
        {
            MessageBox.Show("The below error occurred while processing the request: \n\r \n\r" + ex.Message);
        }
    }
}
