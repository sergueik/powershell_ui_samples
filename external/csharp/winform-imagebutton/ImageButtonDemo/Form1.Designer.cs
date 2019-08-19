namespace ImageButtonDemo
{
    partial class Form1
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
            this.imageButton1 = new System.Windows.Forms.ImageButton();
            this.imageButton3 = new System.Windows.Forms.ImageButton();
            this.imageButton2 = new System.Windows.Forms.ImageButton();
            this.label1 = new System.Windows.Forms.Label();
            this.imageButton4 = new System.Windows.Forms.ImageButton();
            this.imageButton5 = new System.Windows.Forms.ImageButton();
            this.imageButton6 = new System.Windows.Forms.ImageButton();
            this.imageButton7 = new System.Windows.Forms.ImageButton();
            this.label2 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.imageButton1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.imageButton3)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.imageButton2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.imageButton4)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.imageButton5)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.imageButton6)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.imageButton7)).BeginInit();
            this.SuspendLayout();
            // 
            // imageButton1
            // 
            this.imageButton1.DialogResult = System.Windows.Forms.DialogResult.None;
            this.imageButton1.DownImage = global::ImageButtonDemo.Properties.Resources.ExampleButtonDown;
            this.imageButton1.HoverImage = global::ImageButtonDemo.Properties.Resources.ExampleButtonHover;
            this.imageButton1.Location = new System.Drawing.Point(12, 12);
            this.imageButton1.Name = "imageButton1";
            this.imageButton1.NormalImage = global::ImageButtonDemo.Properties.Resources.ExampleButton;
            this.imageButton1.Size = new System.Drawing.Size(100, 50);
            this.imageButton1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize;
            this.imageButton1.TabIndex = 0;
            this.imageButton1.TabStop = false;
            this.imageButton1.Click += new System.EventHandler(this.imageButton1_Click);
            // 
            // imageButton3
            // 
            this.imageButton3.DialogResult = System.Windows.Forms.DialogResult.None;
            this.imageButton3.DownImage = global::ImageButtonDemo.Properties.Resources.CUncheckedDown;
            this.imageButton3.HoverImage = global::ImageButtonDemo.Properties.Resources.CUncheckedHover;
            this.imageButton3.Location = new System.Drawing.Point(50, 83);
            this.imageButton3.Name = "imageButton3";
            this.imageButton3.NormalImage = global::ImageButtonDemo.Properties.Resources.CUncheckedNormal;
            this.imageButton3.Size = new System.Drawing.Size(20, 20);
            this.imageButton3.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize;
            this.imageButton3.TabIndex = 2;
            this.imageButton3.TabStop = false;
            this.imageButton3.Click += new System.EventHandler(this.imageButton3_Click);
            // 
            // imageButton2
            // 
            this.imageButton2.DialogResult = System.Windows.Forms.DialogResult.None;
            this.imageButton2.DownImage = global::ImageButtonDemo.Properties.Resources.ExampleButtonDownA;
            this.imageButton2.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.imageButton2.HoverImage = global::ImageButtonDemo.Properties.Resources.ExampleButtonHoverA;
            this.imageButton2.Location = new System.Drawing.Point(118, 12);
            this.imageButton2.Name = "imageButton2";
            this.imageButton2.NormalImage = global::ImageButtonDemo.Properties.Resources.ExampleButtonA;
            this.imageButton2.Size = new System.Drawing.Size(100, 50);
            this.imageButton2.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize;
            this.imageButton2.TabIndex = 1;
            this.imageButton2.TabStop = false;
            this.imageButton2.Text = "Example B";
            this.imageButton2.Click += new System.EventHandler(this.imageButton2_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.BackColor = System.Drawing.Color.Transparent;
            this.label1.Location = new System.Drawing.Point(68, 87);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(95, 13);
            this.label1.TabIndex = 3;
            this.label1.Text = "Disable click alerts";
            // 
            // imageButton4
            // 
            this.imageButton4.DialogResult = System.Windows.Forms.DialogResult.None;
            this.imageButton4.DownImage = global::ImageButtonDemo.Properties.Resources.ExampleButtonDownA;
            this.imageButton4.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.imageButton4.HoverImage = null;
            this.imageButton4.Location = new System.Drawing.Point(224, 12);
            this.imageButton4.Name = "imageButton4";
            this.imageButton4.NormalImage = global::ImageButtonDemo.Properties.Resources.ExampleButtonA;
            this.imageButton4.Size = new System.Drawing.Size(100, 50);
            this.imageButton4.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize;
            this.imageButton4.TabIndex = 4;
            this.imageButton4.TabStop = false;
            this.imageButton4.Text = "Example C";
            this.imageButton4.Click += new System.EventHandler(this.imageButton4_Click);
            // 
            // imageButton5
            // 
            this.imageButton5.DialogResult = System.Windows.Forms.DialogResult.None;
            this.imageButton5.DownImage = null;
            this.imageButton5.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.imageButton5.HoverImage = global::ImageButtonDemo.Properties.Resources.ExampleButtonHoverA;
            this.imageButton5.Location = new System.Drawing.Point(330, 12);
            this.imageButton5.Name = "imageButton5";
            this.imageButton5.NormalImage = global::ImageButtonDemo.Properties.Resources.ExampleButtonA;
            this.imageButton5.Size = new System.Drawing.Size(100, 50);
            this.imageButton5.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize;
            this.imageButton5.TabIndex = 5;
            this.imageButton5.TabStop = false;
            this.imageButton5.Text = "Example D";
            this.imageButton5.Click += new System.EventHandler(this.imageButton5_Click);
            // 
            // imageButton6
            // 
            this.imageButton6.DialogResult = System.Windows.Forms.DialogResult.None;
            this.imageButton6.DownImage = null;
            this.imageButton6.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.imageButton6.HoverImage = null;
            this.imageButton6.Location = new System.Drawing.Point(224, 68);
            this.imageButton6.Name = "imageButton6";
            this.imageButton6.NormalImage = global::ImageButtonDemo.Properties.Resources.ExampleButtonA;
            this.imageButton6.Size = new System.Drawing.Size(100, 50);
            this.imageButton6.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize;
            this.imageButton6.TabIndex = 6;
            this.imageButton6.TabStop = false;
            this.imageButton6.Text = "Example E";
            this.imageButton6.Click += new System.EventHandler(this.imageButton6_Click);
            // 
            // imageButton7
            // 
            this.imageButton7.DialogResult = System.Windows.Forms.DialogResult.None;
            this.imageButton7.DownImage = global::ImageButtonDemo.Properties.Resources.ExampleButtonDownA;
            this.imageButton7.Font = new System.Drawing.Font("Microsoft Sans Serif", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.imageButton7.HoverImage = global::ImageButtonDemo.Properties.Resources.ExampleButtonHoverA;
            this.imageButton7.Location = new System.Drawing.Point(330, 68);
            this.imageButton7.Name = "imageButton7";
            this.imageButton7.NormalImage = null;
            this.imageButton7.Size = new System.Drawing.Size(100, 50);
            this.imageButton7.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize;
            this.imageButton7.TabIndex = 7;
            this.imageButton7.TabStop = false;
            this.imageButton7.Text = "Example F";
            this.imageButton7.Click += new System.EventHandler(this.imageButton7_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(17, 61);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(83, 13);
            this.label2.TabIndex = 8;
            this.label2.Text = "Default button ^";
            // 
            // Form1
            // 
            this.AcceptButton = this.imageButton1;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(442, 127);
            this.Controls.Add(this.imageButton7);
            this.Controls.Add(this.imageButton6);
            this.Controls.Add(this.imageButton5);
            this.Controls.Add(this.imageButton4);
            this.Controls.Add(this.imageButton3);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.imageButton2);
            this.Controls.Add(this.imageButton1);
            this.Controls.Add(this.label2);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "Form1";
            this.ShowIcon = false;
            this.Text = "ImageButton Demo";
            ((System.ComponentModel.ISupportInitialize)(this.imageButton1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.imageButton3)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.imageButton2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.imageButton4)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.imageButton5)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.imageButton6)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.imageButton7)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ImageButton imageButton1;
        private System.Windows.Forms.ImageButton imageButton2;
        private System.Windows.Forms.ImageButton imageButton3;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ImageButton imageButton4;
        private System.Windows.Forms.ImageButton imageButton5;
        private System.Windows.Forms.ImageButton imageButton6;
        private System.Windows.Forms.ImageButton imageButton7;
        private System.Windows.Forms.Label label2;
    }
}

