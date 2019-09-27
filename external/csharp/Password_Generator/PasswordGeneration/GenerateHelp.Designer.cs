namespace PasswordGeneration
    {
    partial class GenerateHelp
        {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose ( bool disposing )
            {
            if ( disposing && ( components != null ) )
                {
                components.Dispose ( );
                }
            base.Dispose ( disposing );
            }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent ( )
            {
            this.OK_BUT = new System.Windows.Forms.Button ( );
            this.help_text_RTB = new System.Windows.Forms.RichTextBox ( );
            this.SuspendLayout ( );
            // 
            // OK_BUT
            // 
            this.OK_BUT.Location = new System.Drawing.Point ( 420, 674 );
            this.OK_BUT.Margin = new System.Windows.Forms.Padding ( 4 );
            this.OK_BUT.Name = "OK_BUT";
            this.OK_BUT.Size = new System.Drawing.Size ( 75, 35 );
            this.OK_BUT.TabIndex = 45;
            this.OK_BUT.Tag = "";
            this.OK_BUT.Text = "OK";
            this.OK_BUT.UseVisualStyleBackColor = true;
            this.OK_BUT.Click += new System.EventHandler ( this.BUT_Click );
            // 
            // help_text_RTB
            // 
            this.help_text_RTB.Location = new System.Drawing.Point ( 8, 7 );
            this.help_text_RTB.Margin = new System.Windows.Forms.Padding ( 4 );
            this.help_text_RTB.Name = "help_text_RTB";
            this.help_text_RTB.Size = new System.Drawing.Size ( 487, 655 );
            this.help_text_RTB.TabIndex = 44;
            this.help_text_RTB.Text = "";
            // 
            // GenerateHelp
            // 
            this.AcceptButton = this.OK_BUT;
            this.AutoScaleDimensions = new System.Drawing.SizeF ( 10F, 20F );
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size ( 502, 718 );
            this.Controls.Add ( this.OK_BUT );
            this.Controls.Add ( this.help_text_RTB );
            this.Font = new System.Drawing.Font ( "Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ( ( byte ) ( 0 ) ) );
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Margin = new System.Windows.Forms.Padding ( 4 );
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "GenerateHelp";
            this.Text = "Help";
            this.ResumeLayout ( false );

            }

        #endregion

        private System.Windows.Forms.Button OK_BUT;
        private System.Windows.Forms.RichTextBox help_text_RTB;
        }
    }