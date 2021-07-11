using System;
using System.Windows.Forms;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Text;
using FontAwesomeIcons;

namespace Test {
    static class Program {
        [STAThread]
        static void Main() {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new TestForm());
        }
    }
	
	    public class TestForm : Form {
        public TestForm() {
            InitializeComponent();
        }
		
        private IconButton iconButton1;
        private IconButton iconButton2;
        private IconButton iconButton3;
        private IconButton iconButton4;
        private IconButton iconButton5;
        private IconButton iconButton6;
        private IconButton iconButton7;
        private IconButton iconButton8;
        private IconButton iconButton9;
        private IconButton iconButton10;
        private IconButton iconButton11;
        private Label label1;
        private TextBox textBox1;

        private System.ComponentModel.IContainer components = null;
        protected override void Dispose(bool disposing) {
            if (disposing && (components != null)) {
                components.Dispose();
            }
            base.Dispose(disposing);
        }
        
        private void InitializeComponent() {
            iconButton1 = new IconButton();
            iconButton2 = new IconButton();
            iconButton3 = new IconButton();
            iconButton4 = new IconButton();
            iconButton5 = new IconButton();
            iconButton6 = new IconButton();
            iconButton7 = new IconButton();
            iconButton8 = new IconButton();
            iconButton9 = new IconButton();
            iconButton10 = new IconButton();
            iconButton11 = new IconButton();
            label1 = new Label();
            textBox1 = new TextBox();
            ((System.ComponentModel.ISupportInitialize)(iconButton1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton3)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton4)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton5)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton6)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton7)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton8)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton9)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton10)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton11)).BeginInit();
            this.SuspendLayout();
            // 
            // textBox1
            // 
            textBox1.Location = new Point(95, 179);
            textBox1.Name = "textBox1";
            textBox1.Size = new Size(100, 20);
            textBox1.TabIndex = 1;
            textBox1.Text = "Transparency Test";
            // 
            // iconButton4
            // 
            iconButton4.ActiveColor = Color.Red;
            iconButton4.BackColor = Color.Transparent;
            iconButton4.IconType = IconType.EnvelopeO;
            iconButton4.ToolTipText = "Envelope";
            iconButton4.InActiveColor = Color.Orange;
            iconButton4.Location = new Point(255, 191);
            iconButton4.Name = "iconButton4";
            iconButton4.Size = new Size(80, 80);
            iconButton4.TabIndex = 4;
            iconButton4.TabStop = false;
            iconButton4.ToolTipText = null;
            iconButton4.Click += (sender,  e) => MessageBox.Show("You clicked me");
            // 
            // iconButton3
            // 
            iconButton3.ActiveColor = Color.Black;
            iconButton3.InActiveColor = Color.DimGray;
            iconButton3.BackColor = Color.Transparent;
            iconButton3.IconType = IconType.User;
            iconButton3.Location = new Point(170, 179);
            iconButton3.Name = "iconButton3";
            iconButton3.Size = new Size(40, 40);
            iconButton3.TabIndex = 3;
            iconButton3.TabStop = false;
            iconButton3.ToolTipText = null;
            // 
            // iconButton2
            // 
            iconButton2.ActiveColor = Color.Black;
            iconButton2.Location = new Point(195, 86);
            iconButton2.BackColor = Color.Transparent;
            iconButton2.IconType = IconType.Music;
            iconButton2.InActiveColor = Color.DimGray;
            iconButton2.Name = "iconButton2";
            iconButton2.Size = new Size(40, 40);
            iconButton2.TabIndex = 2;
            iconButton2.TabStop = false;
            iconButton2.ToolTipText = "This icon has a tooltip";
            // 
            // iconButton1
            // 
            iconButton1.ActiveColor = Color.Brown;
            iconButton1.BackColor = Color.Transparent;
            iconButton1.InActiveColor = Color.Gray;
            iconButton1.IconType = IconType.Star;            
            iconButton1.SetIconChar(string.Format("{0} {1}", ((char)IconType.Star).ToString(),"test"));
            iconButton1.Location = new Point(114, 28);
            iconButton1.Name = "iconButton1";
            var size1 = TextRenderer.MeasureText("X test",new Font("Arial",8) );
            iconButton1.Size = new Size(size1.Width,size1.Height);
            iconButton1.TabIndex = 0;
            iconButton1.TabStop = false;
            iconButton1.ToolTipText = null;
            
            
            iconButton10.SetIconChar(string.Format("{0} {1}", ((char)IconType.ChevronRight).ToString(),"development"));
            iconButton10.ActiveColor = Color.PaleGreen;
            iconButton10.InActiveColor = Color.Gray;
            iconButton10.Location = new Point(114, 44);
            iconButton10.Name = "iconButton1";
            var size10 = TextRenderer.MeasureText("X development",new Font("Arial",8) );
            iconButton10.Size = new Size(size10.Width,size10.Height);
            iconButton10.TabIndex = 0;
            iconButton10.TabStop = false;
            iconButton10.ToolTipText = null;
            
            iconButton11.SetIconChar(string.Format("{0} {1}", ((char)IconType.ChevronRight).ToString(),"production"));
            iconButton11.ActiveColor = Color.LightBlue;
            iconButton11.InActiveColor = Color.Gray;
            iconButton11.Location = new Point(114, 60);
            iconButton11.Name = "iconButton1";
            var size11 = TextRenderer.MeasureText("X production",new Font("Arial",8) );
            iconButton11.Size = new Size(size11.Width,size11.Height);
            iconButton11.TabIndex = 0;
            iconButton11.TabStop = false;
            iconButton11.ToolTipText = null;
            
            
            // 
            // iconButton5
            // 
            iconButton5.ActiveColor = Color.YellowGreen;
            iconButton5.BackColor = Color.Transparent;
            iconButton5.IconType = IconType.Star;
            iconButton5.InActiveColor = Color.OliveDrab;
            iconButton5.Location = new Point(12, 86);
            iconButton5.Name = "iconButton5";
            iconButton5.Size = new Size(73, 70);
            iconButton5.TabIndex = 5;
            iconButton5.TabStop = false;
            iconButton5.ToolTipText = null;
            // 
            // iconButton6
            // 
            iconButton6.ActiveColor = Color.Black;
            iconButton6.BackColor = Color.Transparent;
            iconButton6.IconType = IconType.Star;
            iconButton6.InActiveColor = Color.DimGray;
            iconButton6.Location = new Point(-1, 0);
            iconButton6.Name = "iconButton6";
            iconButton6.Size = new Size(16, 16);
            iconButton6.TabIndex = 6;
            iconButton6.TabStop = false;
            iconButton6.ToolTipText = null;
            // 
            // iconButton7
            // 
            iconButton7.ActiveColor = Color.Black;
            iconButton7.BackColor = Color.Transparent;
            iconButton7.IconType = IconType.Search;
            iconButton7.InActiveColor = Color.DimGray;
            iconButton7.Location = new Point(12, 0);
            iconButton7.Name = "iconButton7";
            iconButton7.Size = new Size(16, 16);
            iconButton7.TabIndex = 7;
            iconButton7.TabStop = false;
            iconButton7.ToolTipText = null;
            // 
            // iconButton8
            // 
            iconButton8.ActiveColor = Color.Black;
            iconButton8.BackColor = Color.Transparent;
            iconButton8.IconType = IconType.Cog;
            iconButton8.InActiveColor = Color.DimGray;
            iconButton8.Location = new Point(27, 0);
            iconButton8.Name = "iconButton8";
            iconButton8.Size = new Size(16, 16);
            iconButton8.TabIndex = 8;
            iconButton8.TabStop = false;
            iconButton8.ToolTipText = null;
            // 
            // iconButton9
            // 
            iconButton9.ActiveColor = Color.Black;
            iconButton9.BackColor = Color.Transparent;
            iconButton9.IconType = IconType.Folder;
            iconButton9.InActiveColor = Color.DimGray;
            iconButton9.Location = new Point(42, 0);
            iconButton9.Name = "iconButton9";
            iconButton9.Size = new Size(16, 16);
            iconButton9.TabIndex = 9;
            iconButton9.TabStop = false;
            iconButton9.ToolTipText = null;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new Point(192, 241);
            label1.Name = "label1";
            label1.Size = new Size(63, 13);
            label1.TabIndex = 10;
            label1.Text = "Click Me -->";
            // 
            // TestForm
            // 
            this.AutoScaleDimensions = new SizeF(6F, 13F);
            this.AutoScaleMode = AutoScaleMode.Font;
            // this.BackgroundImage = global::FontAwesomeWinForms.Properties.Resources.bg;
            this.ClientSize = new Size(347, 272);
            Controls.Add(label1);
            Controls.Add(iconButton9);
            Controls.Add(iconButton10);
            Controls.Add(iconButton11);            
            Controls.Add(iconButton8);
            Controls.Add(iconButton7);
            Controls.Add(iconButton6);
            Controls.Add(iconButton5);
            Controls.Add(iconButton4);
            Controls.Add(iconButton3);
            Controls.Add(iconButton2);
            Controls.Add(textBox1);
            Controls.Add(iconButton1);
            this.Name = "TestForm";
            this.Text = "Form1";
            ((System.ComponentModel.ISupportInitialize)(iconButton1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton3)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton4)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton5)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton6)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton7)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton8)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton9)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton10)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(iconButton11)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }
    }

}
