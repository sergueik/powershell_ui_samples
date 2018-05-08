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
    public partial class LogDetails : Form
    {
        public LogDetails()
        {
            InitializeComponent();
        }

        public LogDetails(string source,string xmlDetails)
        {
            InitializeComponent();
            Text = source;
           var xml = System.Xml.Linq.XDocument.Parse(xmlDetails).ToString();
            rtbDetailXML.Text = xml;
        }

    }
}
