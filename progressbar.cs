/*
 * Created by SharpDevelop.

based on: http://www.java2s.com/Code/CSharp/GUI-Windows-Form/ProgressBarHost.htm

User Interfaces in C#: Windows Forms and Custom Controls
by Matthew MacDonald

Publisher: Apress
ISBN: 1590590457
*/
/*
$env:path="${env:path};c:\Windows\Microsoft.NET\Framework\v4.0.30319"
csc.exe  .\progressbar.cs
 */
using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;

namespace ProgressBarUtility {
    public class ProgressBarHost : System.Windows.Forms.Form {
        internal System.Windows.Forms.Timer tmrIncrementBar;
        private System.Windows.Forms.Button cmdStart;
        private System.Windows.Forms.Button cmdStep;

        private Progress status;
        private System.ComponentModel.IContainer components;

        public ProgressBarHost() {
            //
            // Required for Windows Form Designer support
            //
            InitializeComponent();

            //
            // TODO: Add any constructor code after InitializeComponent call
            //
        }

        #region Windows Form Designer generated code
        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent() {
            this.components = new System.ComponentModel.Container();
            this.status = new Progress();
            this.tmrIncrementBar = new System.Windows.Forms.Timer(this.components);
            this.cmdStart = new System.Windows.Forms.Button();
            this.cmdStep = new System.Windows.Forms.Button();
            this.SuspendLayout();

            this.status.Location = new System.Drawing.Point(12, 8);
            this.status.Name = "status";
            this.status.Size = new System.Drawing.Size(272, 88);
            this.status.TabIndex = 0;
            this.status.Form = this;

            this.tmrIncrementBar.Interval = 1000;
            this.tmrIncrementBar.Tick += new System.EventHandler(this.tmrIncrementBar_Tick);

            this.cmdStart.Location = new System.Drawing.Point(24, 152);
            this.cmdStart.Name = "cmdStart";
            this.cmdStart.Size = new System.Drawing.Size(92, 24);
            this.cmdStart.TabIndex = 1;
            this.cmdStart.Text = "Start";
            this.cmdStart.Click += new System.EventHandler(this.cmdStart_Click);

            this.cmdStep.Location = new System.Drawing.Point(140, 152);
            this.cmdStep.Name = "cmdStep";
            this.cmdStep.Size = new System.Drawing.Size(92, 24);
            this.cmdStep.TabIndex = 2;
            this.cmdStep.Text = "Step";
            this.cmdStep.Click += new System.EventHandler(this.tmrIncrementBar_Tick);

            this.AutoScaleBaseSize = new System.Drawing.Size(5, 14);
            this.ClientSize = new System.Drawing.Size(292, 194);
            this.Controls.AddRange(new System.Windows.Forms.Control[] {
				this.cmdStart,
				this.cmdStep,
				this.status});
            this.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((System.Byte)(0)));
            this.Name = "ProgressBarHost";
            this.Text = "ProgressBarHost";

            this.ResumeLayout(false);

        }
        #endregion

        [STAThread]
        static void Main() {
            Application.Run(new ProgressBarHost());
        }

        private void tmrIncrementBar_Tick(object sender, System.EventArgs e) {
            status.PerformStep();
            if (status.Maximum == status.Value) {
                tmrIncrementBar.Enabled = false;
                this.Dispose(true);
                this.status.Form.Dispose(true);
            }
        }

        private void cmdStart_Click(object sender, System.EventArgs e) {
            tmrIncrementBar.Enabled = false;
            status.Value = 0;
            status.Maximum = 20;
            status.Step = 1;
            tmrIncrementBar.Enabled = true;
        }
    }

    public class Progress : System.Windows.Forms.UserControl {
        internal System.Windows.Forms.Label lblProgress;
        internal System.Windows.Forms.ProgressBar Bar;

		/*
			error CS1540: Cannot access protected member
			System.ComponentModel.Component.Dispose(bool) via a qualifier of type
			System.Windows.Forms.Form
			The qualifier must be of type
			ProgressBarUtility.ProgressBarHost or derived from it 	
		*/

        private ProgressBarUtility.ProgressBarHost form;
        public ProgressBarUtility.ProgressBarHost Form {
            get {
                return this.form;
            }
            set {
                this.form = value;
            }
        }

        private System.ComponentModel.Container components = null;

        public Progress() {
            InitializeComponent();
        }

        protected override void Dispose(bool disposing) {
            if (disposing) {
                if (components != null) {
                    components.Dispose();
                }
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code
        private void InitializeComponent() {
            this.lblProgress = new System.Windows.Forms.Label();
            this.Bar = new System.Windows.Forms.ProgressBar();
            this.SuspendLayout();

            this.lblProgress.Anchor = ((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                | System.Windows.Forms.AnchorStyles.Right);
            this.lblProgress.Location = new System.Drawing.Point(5, 46);
            this.lblProgress.Name = "lblProgress";
            this.lblProgress.Size = new System.Drawing.Size(152, 16);
            this.lblProgress.TabIndex = 3;
            this.lblProgress.Text = "0% Done";
            this.lblProgress.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            //
            // Bar
            //
            this.Bar.Anchor = ((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                | System.Windows.Forms.AnchorStyles.Right);
            this.Bar.Location = new System.Drawing.Point(5, 6);
            this.Bar.Name = "Bar";
            this.Bar.Size = new System.Drawing.Size(154, 32);
            this.Bar.TabIndex = 2;
            //
            // Progress
            //
            this.Controls.AddRange(new System.Windows.Forms.Control[] {
                                  this.lblProgress,
                                  this.Bar});
            this.Name = "Progress";
            this.Size = new System.Drawing.Size(164, 68);
            this.ResumeLayout(false);

        }
        #endregion

        [Description("The current value (between 0 and Maximum) which sets the position of the progress bar"),
        Category("Behavior"), DefaultValue(0)]
        public int Value {
            get {
                return Bar.Value;
            }
            set {
                Bar.Value = value;
                UpdateLabel();
            }
        }

        public int Maximum {
            get {
                return Bar.Maximum;
            }
            set {
                Bar.Maximum = value;
            }
        }

        public int Step {
            get  {
                return Bar.Step;
            }
            set {
                Bar.Step = value;
            }
        }

        public void PerformStep() {
            Bar.PerformStep();
            UpdateLabel();
        }

        private void UpdateLabel()
        {
            lblProgress.Text = (Math.Round((decimal)(Bar.Value * 100) /
                Bar.Maximum)).ToString();
            lblProgress.Text += "% Done";

            using (Graphics gr = Bar.CreateGraphics())
            {
                string sString = "Progress Bar Visible";
                Brush b = new SolidBrush(Color.Red);
                StringFormat sf = new StringFormat(StringFormatFlags.NoWrap);
                sf.Alignment = StringAlignment.Center;
                gr.DrawString(sString, new Font("Arial", 12.0f, FontStyle.Bold), b, Bar.ClientRectangle, sf);
                gr.Dispose();
                b.Dispose();
                sf.Dispose();
            }
        }
    }
}
