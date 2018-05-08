using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace RealTimeEventLogReader
{
    public partial class MainForm : Form
    {
        private LogReader reader;
        private BindingList<EventLogRecord> eventLogRecordList = new BindingList<EventLogRecord>();
        private bool stop;
        public MainForm()
        {
            InitializeComponent();

            LogNamePrompt prompt = new LogNamePrompt();
            if( prompt.ShowDialog() == DialogResult.OK)
            {
                if (prompt.GetLogName() != string.Empty)
                {
                    BindingSource bindingSource = new BindingSource();
                    bindingSource.DataSource = eventLogRecordList;
                    reader = new LogReader(prompt.GetLogName());
                    reader.AddRecord += OnAddRecord;
                    gvLogs.DataSource = bindingSource;
                    toolStripStatusLabelStatusString.Text = "Started";
                }
            }
            else
            {
                Application.Exit();
            }
        }

        private void OnAddRecord(EventLogRecord record)
        {
           // if(!reader.Stop)
            {
                this.BeginInvoke(new Action<EventLogRecord>(this.AddRecord), record);

                Application.DoEvents();
            }
            
        }

        private void AddRecord(EventLogRecord record)
        {
            eventLogRecordList.Add(record);
            toolStripStatusLabelNumCount.Text = eventLogRecordList.Count.ToString();
            toolStripStatusLabelStatusString.Text = "Started";
            if (eventLogRecordList.Count >= reader.LogLimit)
            {
                eventLogRecordList.RemoveAt(0);
            }
            gvLogs.FirstDisplayedScrollingRowIndex = gvLogs.RowCount - 1;

        }

        private void MainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if(reader != null)
            {
                reader.StopReader();
            }
            
        }

        private void gvLogs_DoubleClick(object sender, EventArgs e)
        {
            if(gvLogs.SelectedRows.Count > 0)
            {
                DataGridViewRow selectedRow = gvLogs.SelectedRows[0];
                EventLogRecord selectedRecord = selectedRow.DataBoundItem as EventLogRecord;

                if(selectedRecord != null)
                {
                    LogDetails logDetails = new LogDetails(selectedRecord.Source, selectedRecord.DetailsXML);
                    logDetails.Show();
                }

            }
        }

        private void startToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (reader != null)
                reader.StartReader();

        }

        private void stopToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (reader != null)
                reader.StopReader();
            toolStripStatusLabelStatusString.Text = "Stopped";
        }
    }
}
