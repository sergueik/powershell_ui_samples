namespace TestPasswordGeneration
    {
    partial class TestPasswordGeneration
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager ( typeof ( TestPasswordGeneration ) );
            this.generate_BUT = new System.Windows.Forms.Button ( );
            this.exit_BUT = new System.Windows.Forms.Button ( );
            this.generated_password_TB = new System.Windows.Forms.TextBox ( );
            this.SuspendLayout ( );
            // 
            // generate_BUT
            // 
            this.generate_BUT.Location = new System.Drawing.Point ( 154, 12 );
            this.generate_BUT.Name = "generate_BUT";
            this.generate_BUT.Size = new System.Drawing.Size ( 120, 35 );
            this.generate_BUT.TabIndex = 0;
            this.generate_BUT.Text = "Generate";
            this.generate_BUT.UseVisualStyleBackColor = true;
            this.generate_BUT.Click += new System.EventHandler ( this.BUT_Click );
            // 
            // exit_BUT
            // 
            this.exit_BUT.Location = new System.Drawing.Point ( 177, 111 );
            this.exit_BUT.Name = "exit_BUT";
            this.exit_BUT.Size = new System.Drawing.Size ( 75, 35 );
            this.exit_BUT.TabIndex = 1;
            this.exit_BUT.Text = "Exit";
            this.exit_BUT.UseVisualStyleBackColor = true;
            this.exit_BUT.Click += new System.EventHandler ( this.BUT_Click );
            // 
            // generated_password_TB
            // 
            this.generated_password_TB.Location = new System.Drawing.Point ( 15, 64 );
            this.generated_password_TB.Name = "generated_password_TB";
            this.generated_password_TB.Size = new System.Drawing.Size ( 399, 30 );
            this.generated_password_TB.TabIndex = 2;
            this.generated_password_TB.Text = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
            // 
            // TestPasswordGeneration
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF ( 12F, 25F );
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size ( 429, 157 );
            this.Controls.Add ( this.generated_password_TB );
            this.Controls.Add ( this.exit_BUT );
            this.Controls.Add ( this.generate_BUT );
            this.Font = new System.Drawing.Font ( "Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ( ( byte ) ( 0 ) ) );
            this.Icon = ( ( System.Drawing.Icon ) ( resources.GetObject ( "$this.Icon" ) ) );
            this.Margin = new System.Windows.Forms.Padding ( 4, 5, 4, 5 );
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "TestPasswordGeneration";
            this.Text = "Test Password Generation";
            this.ResumeLayout ( false );
            this.PerformLayout ( );

            }

        #endregion

        private System.Windows.Forms.Button generate_BUT;
        private System.Windows.Forms.Button exit_BUT;
        private System.Windows.Forms.TextBox generated_password_TB;
        }
    }

