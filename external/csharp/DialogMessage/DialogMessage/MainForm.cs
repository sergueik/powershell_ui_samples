using System;
using System.Windows.Forms;
using System.Drawing;

namespace DialogMessage {
    public partial class MainForm : Form {
        public MainForm() {
            InitializeComponent();
        }

        private void DialogMessage_Load(object sender, EventArgs e) {
            // Once the ShowMessage function is called and the form appears
            // the code below makes the appropriate adjustments so the text appears properly

            // If no icon will be shown then shift the MainInstruction and Content 
            // left to an appropriate location

            // Adjust the MaximumSize to compensate for the shift left.
            if (msgIcon.Visible == false) {
                mainInstruction.Location = new System.Drawing.Point(12, mainInstruction.Location.Y);
                mainInstruction.MaximumSize = new System.Drawing.Size(353, 0);

                content.Location = new System.Drawing.Point(12, content.Location.Y);
                content.MaximumSize = new System.Drawing.Size(353, 0);
            }

            // Gets the Y location of the bottom of MainInstruction
            int mainInstructionBottom = mainInstruction.Location.Y + mainInstruction.Height;

            // Gets the Y location of the bottom of Content
            int contentBottom = content.Location.Y + content.Height;

            // Offsets the top of Content from the bottom of MainInstruction
            int contentTop = mainInstructionBottom + 18; // 18 just looked nice to me

            // Sets new location of the top of Content
            content.Location = new System.Drawing.Point(content.Location.X, contentTop);

            if (content.Text == string.Empty)

                // If only MainInstruction is provided then make the form a little shorter
                Height += (mainInstruction.Location.Y + mainInstruction.Height) - 50;
            else
                Height += (content.Location.Y + content.Height) - 60;
        }
    }
}
