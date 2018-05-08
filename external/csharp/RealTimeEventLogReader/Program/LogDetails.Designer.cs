namespace RealTimeEventLogReader
{
    partial class LogDetails
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.rtbDetailXML = new System.Windows.Forms.RichTextBox();
            this.SuspendLayout();
            // 
            // rtbDetailXML
            // 
            this.rtbDetailXML.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.rtbDetailXML.Location = new System.Drawing.Point(13, 13);
            this.rtbDetailXML.Name = "rtbDetailXML";
            this.rtbDetailXML.ReadOnly = true;
            this.rtbDetailXML.Size = new System.Drawing.Size(662, 436);
            this.rtbDetailXML.TabIndex = 0;
            this.rtbDetailXML.Text = "";
            // 
            // LogDetails
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(687, 461);
            this.Controls.Add(this.rtbDetailXML);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Name = "LogDetails";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "LogDetails";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.RichTextBox rtbDetailXML;
    }
}