namespace PasswordGeneration
    {
    partial class GeneratePassword
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager ( typeof ( GeneratePassword ) );
            this.generated_password_TB = new System.Windows.Forms.TextBox ( );
            this.generated_password_LAB = new System.Windows.Forms.Label ( );
            this.password_strength_LAB = new System.Windows.Forms.Label ( );
            this.password_length_NUD = new System.Windows.Forms.NumericUpDown ( );
            this.password_length_LAB = new System.Windows.Forms.Label ( );
            this.upper_case_letters_CHKBX = new System.Windows.Forms.CheckBox ( );
            this.symbols_CHKBX = new System.Windows.Forms.CheckBox ( );
            this.numbers_CHKBX = new System.Windows.Forms.CheckBox ( );
            this.lower_case_letters_CHKBX = new System.Windows.Forms.CheckBox ( );
            this.characters_to_include_PAN = new System.Windows.Forms.GroupBox ( );
            this.easy_to_say_RB = new System.Windows.Forms.RadioButton ( );
            this.all_characters_RB = new System.Windows.Forms.RadioButton ( );
            this.easy_to_read_RB = new System.Windows.Forms.RadioButton ( );
            this.regenerate_BUT = new System.Windows.Forms.Button ( );
            this.generate_help_BUT = new System.Windows.Forms.Button ( );
            this.accept_password_BUT = new System.Windows.Forms.Button ( );
            this.cancel_generate_BUT = new System.Windows.Forms.Button ( );
            this.generate_PAN = new System.Windows.Forms.Panel ( );
            this.password_strength_PB = new System.Windows.Forms.ProgressBar ( );
            this.strength_LAB = new Utilities.TransparentLabel ( );
            ( ( System.ComponentModel.ISupportInitialize ) ( this.password_length_NUD ) ).BeginInit ( );
            this.characters_to_include_PAN.SuspendLayout ( );
            this.generate_PAN.SuspendLayout ( );
            this.SuspendLayout ( );
            // 
            // generated_password_TB
            // 
            this.generated_password_TB.Location = new System.Drawing.Point ( 7, 34 );
            this.generated_password_TB.Margin = new System.Windows.Forms.Padding ( 2 );
            this.generated_password_TB.Name = "generated_password_TB";
            this.generated_password_TB.Size = new System.Drawing.Size ( 329, 27 );
            this.generated_password_TB.TabIndex = 0;
            this.generated_password_TB.Text = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
            // 
            // generated_password_LAB
            // 
            this.generated_password_LAB.AutoSize = true;
            this.generated_password_LAB.Location = new System.Drawing.Point ( 7, 7 );
            this.generated_password_LAB.Margin = new System.Windows.Forms.Padding ( 2, 0, 2, 0 );
            this.generated_password_LAB.Name = "generated_password_LAB";
            this.generated_password_LAB.Size = new System.Drawing.Size ( 166, 20 );
            this.generated_password_LAB.TabIndex = 1;
            this.generated_password_LAB.Text = "Generated Password";
            // 
            // password_strength_LAB
            // 
            this.password_strength_LAB.AutoSize = true;
            this.password_strength_LAB.Location = new System.Drawing.Point ( 7, 65 );
            this.password_strength_LAB.Name = "password_strength_LAB";
            this.password_strength_LAB.Size = new System.Drawing.Size ( 151, 20 );
            this.password_strength_LAB.TabIndex = 4;
            this.password_strength_LAB.Text = "Password Strength";
            // 
            // password_length_NUD
            // 
            this.password_length_NUD.Location = new System.Drawing.Point ( 149, 134 );
            this.password_length_NUD.Maximum = new decimal ( new int [ ] {
            32,
            0,
            0,
            0} );
            this.password_length_NUD.Minimum = new decimal ( new int [ ] {
            6,
            0,
            0,
            0} );
            this.password_length_NUD.Name = "password_length_NUD";
            this.password_length_NUD.Size = new System.Drawing.Size ( 46, 27 );
            this.password_length_NUD.TabIndex = 5;
            this.password_length_NUD.Value = new decimal ( new int [ ] {
            32,
            0,
            0,
            0} );
            this.password_length_NUD.ValueChanged += new System.EventHandler ( this.NUD_ValueChanged );
            // 
            // password_length_LAB
            // 
            this.password_length_LAB.AutoSize = true;
            this.password_length_LAB.Location = new System.Drawing.Point ( 7, 137 );
            this.password_length_LAB.Name = "password_length_LAB";
            this.password_length_LAB.Size = new System.Drawing.Size ( 139, 20 );
            this.password_length_LAB.TabIndex = 6;
            this.password_length_LAB.Text = "Password Length";
            // 
            // upper_case_letters_CHKBX
            // 
            this.upper_case_letters_CHKBX.AutoSize = true;
            this.upper_case_letters_CHKBX.Location = new System.Drawing.Point ( 6, 22 );
            this.upper_case_letters_CHKBX.Name = "upper_case_letters_CHKBX";
            this.upper_case_letters_CHKBX.Size = new System.Drawing.Size ( 175, 24 );
            this.upper_case_letters_CHKBX.TabIndex = 7;
            this.upper_case_letters_CHKBX.Text = "Upper Case Letters";
            this.upper_case_letters_CHKBX.UseVisualStyleBackColor = true;
            this.upper_case_letters_CHKBX.CheckedChanged += new System.EventHandler ( this.CHKBX_CheckedChanged );
            // 
            // symbols_CHKBX
            // 
            this.symbols_CHKBX.AutoSize = true;
            this.symbols_CHKBX.Location = new System.Drawing.Point ( 5, 106 );
            this.symbols_CHKBX.Name = "symbols_CHKBX";
            this.symbols_CHKBX.Size = new System.Drawing.Size ( 184, 24 );
            this.symbols_CHKBX.TabIndex = 8;
            this.symbols_CHKBX.Text = "Symbols (! @ # $ %)";
            this.symbols_CHKBX.UseVisualStyleBackColor = true;
            this.symbols_CHKBX.CheckedChanged += new System.EventHandler ( this.CHKBX_CheckedChanged );
            // 
            // numbers_CHKBX
            // 
            this.numbers_CHKBX.AutoSize = true;
            this.numbers_CHKBX.Location = new System.Drawing.Point ( 5, 78 );
            this.numbers_CHKBX.Name = "numbers_CHKBX";
            this.numbers_CHKBX.Size = new System.Drawing.Size ( 137, 24 );
            this.numbers_CHKBX.TabIndex = 9;
            this.numbers_CHKBX.Text = "Numbers (0-9)";
            this.numbers_CHKBX.UseVisualStyleBackColor = true;
            this.numbers_CHKBX.CheckedChanged += new System.EventHandler ( this.CHKBX_CheckedChanged );
            // 
            // lower_case_letters_CHKBX
            // 
            this.lower_case_letters_CHKBX.AutoSize = true;
            this.lower_case_letters_CHKBX.Location = new System.Drawing.Point ( 5, 50 );
            this.lower_case_letters_CHKBX.Name = "lower_case_letters_CHKBX";
            this.lower_case_letters_CHKBX.Size = new System.Drawing.Size ( 176, 24 );
            this.lower_case_letters_CHKBX.TabIndex = 10;
            this.lower_case_letters_CHKBX.Text = "Lower Case Letters";
            this.lower_case_letters_CHKBX.UseVisualStyleBackColor = true;
            this.lower_case_letters_CHKBX.CheckedChanged += new System.EventHandler ( this.CHKBX_CheckedChanged );
            // 
            // characters_to_include_PAN
            // 
            this.characters_to_include_PAN.Controls.Add ( this.easy_to_say_RB );
            this.characters_to_include_PAN.Controls.Add ( this.all_characters_RB );
            this.characters_to_include_PAN.Controls.Add ( this.upper_case_letters_CHKBX );
            this.characters_to_include_PAN.Controls.Add ( this.numbers_CHKBX );
            this.characters_to_include_PAN.Controls.Add ( this.easy_to_read_RB );
            this.characters_to_include_PAN.Controls.Add ( this.lower_case_letters_CHKBX );
            this.characters_to_include_PAN.Controls.Add ( this.symbols_CHKBX );
            this.characters_to_include_PAN.Location = new System.Drawing.Point ( 19, 168 );
            this.characters_to_include_PAN.Name = "characters_to_include_PAN";
            this.characters_to_include_PAN.Size = new System.Drawing.Size ( 347, 136 );
            this.characters_to_include_PAN.TabIndex = 11;
            this.characters_to_include_PAN.TabStop = false;
            this.characters_to_include_PAN.Text = "Characters to include";
            // 
            // easy_to_say_RB
            // 
            this.easy_to_say_RB.AutoSize = true;
            this.easy_to_say_RB.Location = new System.Drawing.Point ( 209, 22 );
            this.easy_to_say_RB.Name = "easy_to_say_RB";
            this.easy_to_say_RB.Size = new System.Drawing.Size ( 114, 24 );
            this.easy_to_say_RB.TabIndex = 0;
            this.easy_to_say_RB.TabStop = true;
            this.easy_to_say_RB.Text = "Easy to say";
            this.easy_to_say_RB.UseVisualStyleBackColor = true;
            this.easy_to_say_RB.CheckedChanged += new System.EventHandler ( this.RB_CheckedChanged );
            // 
            // all_characters_RB
            // 
            this.all_characters_RB.AutoSize = true;
            this.all_characters_RB.Location = new System.Drawing.Point ( 209, 78 );
            this.all_characters_RB.Name = "all_characters_RB";
            this.all_characters_RB.Size = new System.Drawing.Size ( 131, 24 );
            this.all_characters_RB.TabIndex = 2;
            this.all_characters_RB.TabStop = true;
            this.all_characters_RB.Text = "All characters";
            this.all_characters_RB.UseVisualStyleBackColor = true;
            this.all_characters_RB.CheckedChanged += new System.EventHandler ( this.RB_CheckedChanged );
            // 
            // easy_to_read_RB
            // 
            this.easy_to_read_RB.AutoSize = true;
            this.easy_to_read_RB.Location = new System.Drawing.Point ( 209, 50 );
            this.easy_to_read_RB.Name = "easy_to_read_RB";
            this.easy_to_read_RB.Size = new System.Drawing.Size ( 121, 24 );
            this.easy_to_read_RB.TabIndex = 1;
            this.easy_to_read_RB.TabStop = true;
            this.easy_to_read_RB.Text = "Easy to read";
            this.easy_to_read_RB.UseVisualStyleBackColor = true;
            this.easy_to_read_RB.CheckedChanged += new System.EventHandler ( this.RB_CheckedChanged );
            // 
            // regenerate_BUT
            // 
            this.regenerate_BUT.BackgroundImage = global::PasswordGeneration.Properties.Resources.regenerate_image;
            this.regenerate_BUT.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.regenerate_BUT.Location = new System.Drawing.Point ( 340, 32 );
            this.regenerate_BUT.Name = "regenerate_BUT";
            this.regenerate_BUT.Size = new System.Drawing.Size ( 35, 30 );
            this.regenerate_BUT.TabIndex = 13;
            this.regenerate_BUT.UseVisualStyleBackColor = true;
            this.regenerate_BUT.Click += new System.EventHandler ( this.BUT_Click );
            // 
            // generate_help_BUT
            // 
            this.generate_help_BUT.BackColor = System.Drawing.SystemColors.Control;
            this.generate_help_BUT.BackgroundImage = global::PasswordGeneration.Properties.Resources.help_image;
            this.generate_help_BUT.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.generate_help_BUT.Location = new System.Drawing.Point ( 136, 312 );
            this.generate_help_BUT.Name = "generate_help_BUT";
            this.generate_help_BUT.Size = new System.Drawing.Size ( 35, 35 );
            this.generate_help_BUT.TabIndex = 53;
            this.generate_help_BUT.UseVisualStyleBackColor = false;
            this.generate_help_BUT.Click += new System.EventHandler ( this.BUT_Click );
            // 
            // accept_password_BUT
            // 
            this.accept_password_BUT.Location = new System.Drawing.Point ( 225, 312 );
            this.accept_password_BUT.Name = "accept_password_BUT";
            this.accept_password_BUT.Size = new System.Drawing.Size ( 150, 35 );
            this.accept_password_BUT.TabIndex = 54;
            this.accept_password_BUT.Text = "Accept Password";
            this.accept_password_BUT.UseVisualStyleBackColor = true;
            this.accept_password_BUT.Click += new System.EventHandler ( this.BUT_Click );
            // 
            // cancel_generate_BUT
            // 
            this.cancel_generate_BUT.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.cancel_generate_BUT.Location = new System.Drawing.Point ( 7, 312 );
            this.cancel_generate_BUT.Name = "cancel_generate_BUT";
            this.cancel_generate_BUT.Size = new System.Drawing.Size ( 75, 35 );
            this.cancel_generate_BUT.TabIndex = 55;
            this.cancel_generate_BUT.Text = "Cancel";
            this.cancel_generate_BUT.UseVisualStyleBackColor = true;
            this.cancel_generate_BUT.Click += new System.EventHandler ( this.BUT_Click );
            // 
            // generate_PAN
            // 
            this.generate_PAN.Controls.Add ( this.strength_LAB );
            this.generate_PAN.Controls.Add ( this.generated_password_LAB );
            this.generate_PAN.Controls.Add ( this.cancel_generate_BUT );
            this.generate_PAN.Controls.Add ( this.password_strength_PB );
            this.generate_PAN.Controls.Add ( this.generated_password_TB );
            this.generate_PAN.Controls.Add ( this.accept_password_BUT );
            this.generate_PAN.Controls.Add ( this.generate_help_BUT );
            this.generate_PAN.Controls.Add ( this.password_strength_LAB );
            this.generate_PAN.Controls.Add ( this.regenerate_BUT );
            this.generate_PAN.Controls.Add ( this.password_length_NUD );
            this.generate_PAN.Controls.Add ( this.password_length_LAB );
            this.generate_PAN.Controls.Add ( this.characters_to_include_PAN );
            this.generate_PAN.Location = new System.Drawing.Point ( 7, 1 );
            this.generate_PAN.Name = "generate_PAN";
            this.generate_PAN.Size = new System.Drawing.Size ( 385, 351 );
            this.generate_PAN.TabIndex = 56;
            // 
            // password_strength_PB
            // 
            this.password_strength_PB.ForeColor = System.Drawing.Color.LimeGreen;
            this.password_strength_PB.Location = new System.Drawing.Point ( 11, 92 );
            this.password_strength_PB.Name = "password_strength_PB";
            this.password_strength_PB.Size = new System.Drawing.Size ( 322, 35 );
            this.password_strength_PB.TabIndex = 57;
            this.password_strength_PB.Value = 40;
            // 
            // strength_LAB
            // 
            this.strength_LAB.Location = new System.Drawing.Point ( 116, 98 );
            this.strength_LAB.Name = "strength_LAB";
            this.strength_LAB.Size = new System.Drawing.Size ( 113, 23 );
            this.strength_LAB.TabIndex = 59;
            this.strength_LAB.TabStop = false;
            this.strength_LAB.Text = "Very Strong";
            this.strength_LAB.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // GeneratePassword
            // 
            this.AcceptButton = this.accept_password_BUT;
            this.AutoScaleDimensions = new System.Drawing.SizeF ( 10F, 20F );
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.CancelButton = this.cancel_generate_BUT;
            this.ClientSize = new System.Drawing.Size ( 399, 354 );
            this.Controls.Add ( this.generate_PAN );
            this.Font = new System.Drawing.Font ( "Microsoft Sans Serif", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ( ( byte ) ( 0 ) ) );
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Icon = ( ( System.Drawing.Icon ) ( resources.GetObject ( "$this.Icon" ) ) );
            this.Margin = new System.Windows.Forms.Padding ( 3, 4, 3, 4 );
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "GeneratePassword";
            this.Text = "Generate Password";
            ( ( System.ComponentModel.ISupportInitialize ) ( this.password_length_NUD ) ).EndInit ( );
            this.characters_to_include_PAN.ResumeLayout ( false );
            this.characters_to_include_PAN.PerformLayout ( );
            this.generate_PAN.ResumeLayout ( false );
            this.generate_PAN.PerformLayout ( );
            this.ResumeLayout ( false );

            }

        #endregion

        private System.Windows.Forms.TextBox generated_password_TB;
        private System.Windows.Forms.Label generated_password_LAB;
        private System.Windows.Forms.Label password_strength_LAB;
        private System.Windows.Forms.NumericUpDown password_length_NUD;
        private System.Windows.Forms.Label password_length_LAB;
        private System.Windows.Forms.CheckBox upper_case_letters_CHKBX;
        private System.Windows.Forms.CheckBox symbols_CHKBX;
        private System.Windows.Forms.CheckBox numbers_CHKBX;
        private System.Windows.Forms.CheckBox lower_case_letters_CHKBX;
        private System.Windows.Forms.GroupBox characters_to_include_PAN;
        private System.Windows.Forms.RadioButton all_characters_RB;
        private System.Windows.Forms.RadioButton easy_to_read_RB;
        private System.Windows.Forms.RadioButton easy_to_say_RB;
        private System.Windows.Forms.Button regenerate_BUT;
        private System.Windows.Forms.Button generate_help_BUT;
        private System.Windows.Forms.Button accept_password_BUT;
        private System.Windows.Forms.Button cancel_generate_BUT;
        private System.Windows.Forms.Panel generate_PAN;
        private System.Windows.Forms.ProgressBar password_strength_PB;
        private Utilities.TransparentLabel strength_LAB;
        }
    }