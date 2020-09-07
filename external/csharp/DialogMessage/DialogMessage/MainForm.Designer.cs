namespace DialogMessage
{
    partial class MainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing) {
            if (disposing && (components != null)) {
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
            this.whiteSpace = new System.Windows.Forms.Panel();
            this.content = new System.Windows.Forms.Label();
            this.mainInstruction = new System.Windows.Forms.Label();
            this.tablePanelLayout = new System.Windows.Forms.TableLayoutPanel();
            this.Button1 = new System.Windows.Forms.Button();
            this.Button2 = new System.Windows.Forms.Button();
            this.msgIcon = new System.Windows.Forms.PictureBox();
            this.whiteSpace.SuspendLayout();
            this.tablePanelLayout.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.msgIcon)).BeginInit();
            this.SuspendLayout();
            // 
            // whiteSpace
            // 
            this.whiteSpace.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.whiteSpace.BackColor = System.Drawing.Color.White;
            this.whiteSpace.Controls.Add(this.content);
            this.whiteSpace.Controls.Add(this.mainInstruction);
            this.whiteSpace.Location = new System.Drawing.Point(0, 0);
            this.whiteSpace.Name = "whiteSpace";
            this.whiteSpace.Size = new System.Drawing.Size(383, 79);
            this.whiteSpace.TabIndex = 1;
            // 
            // content
            // 
            this.content.AutoSize = true;
            this.content.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.content.Location = new System.Drawing.Point(54, 51);
            this.content.MaximumSize = new System.Drawing.Size(305, 0);
            this.content.Name = "content";
            this.content.Size = new System.Drawing.Size(44, 13);
            this.content.TabIndex = 1;
            this.content.Text = "Content";
            // 
            // mainInstruction
            // 
            this.mainInstruction.AutoSize = true;
            this.mainInstruction.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mainInstruction.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(51)))), ((int)(((byte)(188)))));
            this.mainInstruction.Location = new System.Drawing.Point(54, 13);
            this.mainInstruction.Margin = new System.Windows.Forms.Padding(5, 0, 3, 18);
            this.mainInstruction.MaximumSize = new System.Drawing.Size(305, 0);
            this.mainInstruction.Name = "mainInstruction";
            this.mainInstruction.Size = new System.Drawing.Size(123, 21);
            this.mainInstruction.TabIndex = 0;
            this.mainInstruction.Text = "Main Instruction";
            // 
            // tablePanelLayout
            // 
            this.tablePanelLayout.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.tablePanelLayout.ColumnCount = 2;
            this.tablePanelLayout.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tablePanelLayout.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tablePanelLayout.Controls.Add(this.Button1, 0, 0);
            this.tablePanelLayout.Controls.Add(this.Button2, 1, 0);
            this.tablePanelLayout.Location = new System.Drawing.Point(232, 83);
            this.tablePanelLayout.Name = "tablePanelLayout";
            this.tablePanelLayout.RowCount = 1;
            this.tablePanelLayout.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tablePanelLayout.Size = new System.Drawing.Size(146, 29);
            this.tablePanelLayout.TabIndex = 2;
            // 
            // Button1
            // 
            this.Button1.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.Button1.Location = new System.Drawing.Point(3, 3);
            this.Button1.Name = "Button1";
            this.Button1.Size = new System.Drawing.Size(67, 23);
            this.Button1.TabIndex = 0;
            this.Button1.Text = "Button1";
            // 
            // Button2
            // 
            this.Button2.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.Button2.Location = new System.Drawing.Point(76, 3);
            this.Button2.Name = "Button2";
            this.Button2.Size = new System.Drawing.Size(67, 23);
            this.Button2.TabIndex = 1;
            this.Button2.Text = "Button2";
            // 
            // msgIcon
            // 
            this.msgIcon.BackColor = System.Drawing.Color.White;
            this.msgIcon.Location = new System.Drawing.Point(14, 14);
            this.msgIcon.Name = "msgIcon";
            this.msgIcon.Size = new System.Drawing.Size(32, 32);
            this.msgIcon.TabIndex = 3;
            this.msgIcon.TabStop = false;
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(383, 118);
            this.Controls.Add(this.msgIcon);
            this.Controls.Add(this.tablePanelLayout);
            this.Controls.Add(this.whiteSpace);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.MinimumSize = new System.Drawing.Size(360, 157);
            this.Name = "MainForm";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Window Title";
            this.Load += new System.EventHandler(this.DialogMessage_Load);
            this.whiteSpace.ResumeLayout(false);
            this.whiteSpace.PerformLayout();
            this.tablePanelLayout.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.msgIcon)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        internal System.Windows.Forms.Panel whiteSpace;
        internal System.Windows.Forms.TableLayoutPanel tablePanelLayout;
        internal System.Windows.Forms.Label content;
        internal System.Windows.Forms.Label mainInstruction;
        internal System.Windows.Forms.Button Button1;
        internal System.Windows.Forms.Button Button2;
        internal System.Windows.Forms.PictureBox msgIcon;
    }
}