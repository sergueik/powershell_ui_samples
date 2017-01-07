using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Growl.Connector;

namespace GrowlNETConnector.Sample
{
    public partial class Form1 : Form
    {
        private GrowlConnector growl;
        private NotificationType notificationType;
        private Growl.Connector.Application application;
        private string sampleNotificationType = "SAMPLE_NOTIFICATION";

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            this.notificationType = new NotificationType(sampleNotificationType, "Sample Notification");

            this.growl = new GrowlConnector();
            //this.growl = new GrowlConnector("password");    // use this if you need to set a password - you can also pass null or an empty string to this constructor to use no password
            //this.growl = new GrowlConnector("password", "hostname", GrowlConnector.TCP_PORT);   // use this if you want to connect to a remote Growl instance on another machine

            this.growl.NotificationCallback += new GrowlConnector.CallbackEventHandler(growl_NotificationCallback);

            // set this so messages are sent in plain text (easier for debugging)
            this.growl.EncryptionAlgorithm = Cryptography.SymmetricAlgorithmType.PlainText;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.application = new Growl.Connector.Application(this.textBox1.Text);

            this.growl.Register(application, new NotificationType[] { notificationType });
        }

        private void button2_Click(object sender, EventArgs e)
        {
            CallbackContext callbackContext = new CallbackContext("some fake information", "fake data");

            Notification notification = new Notification(this.application.Name, this.notificationType.Name, DateTime.Now.Ticks.ToString(), this.textBox2.Text, this.textBox3.Text);
            this.growl.Notify(notification, callbackContext);
        }

        void growl_NotificationCallback(Response response, CallbackData callbackData, object state)
        {
            string text = String.Format("Response Type: {0}\r\nNotification ID: {1}\r\nCallback Data: {2}\r\nCallback Data Type: {3}\r\n", callbackData.Result, callbackData.NotificationID, callbackData.Data, callbackData.Type);
            MessageBox.Show(text, "Callback received", MessageBoxButtons.OK, MessageBoxIcon.Information, MessageBoxDefaultButton.Button1);
        }
    }
}