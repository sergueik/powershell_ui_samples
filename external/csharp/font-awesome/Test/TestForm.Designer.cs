using FontAwesomeIcons;
using System.Windows.Forms;

namespace FontAwesomeWinForms {
    partial class TestForm {
        private IconButton iconButton1;
        private TextBox textBox1;
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
        private System.ComponentModel.IContainer components = null;
        protected override void Dispose(bool disposing) {
            if (disposing && (components != null)) {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        
        private void InitializeComponent() {
            textBox1 = new TextBox();
            iconButton4 = new IconButton();
            iconButton3 = new IconButton();
            iconButton2 = new IconButton();
            iconButton1 = new IconButton();
            iconButton5 = new IconButton();
            iconButton6 = new IconButton();
            iconButton7 = new IconButton();
            iconButton8 = new IconButton();
            iconButton9 = new IconButton();
            iconButton10 = new IconButton();
            iconButton11 = new IconButton();
            label1 = new Label();
            ((System.ComponentModel.ISupportInitialize)(this.iconButton4)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.iconButton3)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.iconButton2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.iconButton1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.iconButton5)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.iconButton6)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.iconButton7)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.iconButton8)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.iconButton9)).BeginInit();
            this.SuspendLayout();
            // 
            // textBox1
            // 
            textBox1.Location = new System.Drawing.Point(95, 179);
            textBox1.Name = "textBox1";
            textBox1.Size = new System.Drawing.Size(100, 20);
            textBox1.TabIndex = 1;
            textBox1.Text = "Transparency Test";
            // 
            // iconButton4
            // 
            iconButton4.ActiveColor = System.Drawing.Color.Red;
            iconButton4.BackColor = System.Drawing.Color.Transparent;
            iconButton4.IconType = IconType.EnvelopeO;
            iconButton4.ToolTipText = "Envelope";
            iconButton4.InActiveColor = System.Drawing.Color.Orange;
            iconButton4.Location = new System.Drawing.Point(255, 191);
            iconButton4.Name = "iconButton4";
            iconButton4.Size = new System.Drawing.Size(80, 80);
            iconButton4.TabIndex = 4;
            iconButton4.TabStop = false;
            iconButton4.ToolTipText = null;
            iconButton4.Click += new System.EventHandler(this.iconButton4_Click);
            // 
            // iconButton3
            // 
            iconButton3.ActiveColor = System.Drawing.Color.Black;
            iconButton3.BackColor = System.Drawing.Color.Transparent;
            iconButton3.IconType = IconType.User;
            iconButton3.InActiveColor = System.Drawing.Color.DimGray;
            iconButton3.Location = new System.Drawing.Point(170, 179);
            iconButton3.Name = "iconButton3";
            iconButton3.Size = new System.Drawing.Size(40, 40);
            iconButton3.TabIndex = 3;
            iconButton3.TabStop = false;
            iconButton3.ToolTipText = null;
            // 
            // iconButton2
            // 
            iconButton2.ActiveColor = System.Drawing.Color.Black;
            iconButton2.BackColor = System.Drawing.Color.Transparent;
            iconButton2.IconType = IconType.Music;
            iconButton2.InActiveColor = System.Drawing.Color.DimGray;
            iconButton2.Location = new System.Drawing.Point(195, 86);
            iconButton2.Name = "iconButton2";
            iconButton2.Size = new System.Drawing.Size(40, 40);
            iconButton2.TabIndex = 2;
            iconButton2.TabStop = false;
            iconButton2.ToolTipText = "This icon has a tooltip";
            // 
            // iconButton1
            // 
            iconButton1.ActiveColor = System.Drawing.Color.Black;
            iconButton1.BackColor = System.Drawing.Color.Transparent;
            iconButton1.IconType = IconType.Star;
            
            iconButton1.SetIconChar(string.Format("{0} {1}", ((char)IconType.Star).ToString(),"test"));
            iconButton1.InActiveColor = System.Drawing.Color.DimGray;
            iconButton1.Location = new System.Drawing.Point(114, 28);
            iconButton1.Name = "iconButton1";
            var size1 = TextRenderer.MeasureText("X test",new System.Drawing.Font("Arial",8) );
            iconButton1.Size = new System.Drawing.Size(size1.Width,size1.Height);
            iconButton1.TabIndex = 0;
            iconButton1.TabStop = false;
            iconButton1.ToolTipText = null;
            
            
            iconButton10.SetIconChar(string.Format("{0} {1}", ((char)IconType.ChevronRight).ToString(),"development"));
            iconButton10.InActiveColor = System.Drawing.Color.DimGray;
            iconButton10.Location = new System.Drawing.Point(114, 44);
            iconButton10.Name = "iconButton1";
            var size10 = TextRenderer.MeasureText("X development",new System.Drawing.Font("Arial",8) );
            iconButton10.Size = new System.Drawing.Size(size10.Width,size10.Height);
            iconButton10.TabIndex = 0;
            iconButton10.TabStop = false;
            iconButton10.ToolTipText = null;
            
            iconButton11.SetIconChar(string.Format("{0} {1}", ((char)IconType.ChevronRight).ToString(),"production"));
            iconButton11.InActiveColor = System.Drawing.Color.DimGray;
            iconButton11.Location = new System.Drawing.Point(114, 60);
            iconButton11.Name = "iconButton1";
            var size11 = TextRenderer.MeasureText("X production",new System.Drawing.Font("Arial",8) );
            iconButton11.Size = new System.Drawing.Size(size11.Width,size11.Height);
            iconButton11.TabIndex = 0;
            iconButton11.TabStop = false;
            iconButton11.ToolTipText = null;
            
            
            // 
            // iconButton5
            // 
            iconButton5.ActiveColor = System.Drawing.Color.YellowGreen;
            iconButton5.BackColor = System.Drawing.Color.Transparent;
            iconButton5.IconType = IconType.Star;
            iconButton5.InActiveColor = System.Drawing.Color.OliveDrab;
            iconButton5.Location = new System.Drawing.Point(12, 86);
            iconButton5.Name = "iconButton5";
            iconButton5.Size = new System.Drawing.Size(73, 70);
            iconButton5.TabIndex = 5;
            iconButton5.TabStop = false;
            iconButton5.ToolTipText = null;
            // 
            // iconButton6
            // 
            iconButton6.ActiveColor = System.Drawing.Color.Black;
            iconButton6.BackColor = System.Drawing.Color.Transparent;
            iconButton6.IconType = IconType.Star;
            iconButton6.InActiveColor = System.Drawing.Color.DimGray;
            iconButton6.Location = new System.Drawing.Point(-1, 0);
            iconButton6.Name = "iconButton6";
            iconButton6.Size = new System.Drawing.Size(16, 16);
            iconButton6.TabIndex = 6;
            iconButton6.TabStop = false;
            iconButton6.ToolTipText = null;
            // 
            // iconButton7
            // 
            iconButton7.ActiveColor = System.Drawing.Color.Black;
            iconButton7.BackColor = System.Drawing.Color.Transparent;
            iconButton7.IconType = IconType.Search;
            iconButton7.InActiveColor = System.Drawing.Color.DimGray;
            iconButton7.Location = new System.Drawing.Point(12, 0);
            iconButton7.Name = "iconButton7";
            iconButton7.Size = new System.Drawing.Size(16, 16);
            iconButton7.TabIndex = 7;
            iconButton7.TabStop = false;
            iconButton7.ToolTipText = null;
            // 
            // iconButton8
            // 
            iconButton8.ActiveColor = System.Drawing.Color.Black;
            iconButton8.BackColor = System.Drawing.Color.Transparent;
            iconButton8.IconType = IconType.Cog;
            iconButton8.InActiveColor = System.Drawing.Color.DimGray;
            iconButton8.Location = new System.Drawing.Point(27, 0);
            iconButton8.Name = "iconButton8";
            iconButton8.Size = new System.Drawing.Size(16, 16);
            iconButton8.TabIndex = 8;
            iconButton8.TabStop = false;
            iconButton8.ToolTipText = null;
            // 
            // iconButton9
            // 
            iconButton9.ActiveColor = System.Drawing.Color.Black;
            iconButton9.BackColor = System.Drawing.Color.Transparent;
            iconButton9.IconType = IconType.Folder;
            iconButton9.InActiveColor = System.Drawing.Color.DimGray;
            iconButton9.Location = new System.Drawing.Point(42, 0);
            iconButton9.Name = "iconButton9";
            iconButton9.Size = new System.Drawing.Size(16, 16);
            iconButton9.TabIndex = 9;
            iconButton9.TabStop = false;
            iconButton9.ToolTipText = null;
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Location = new System.Drawing.Point(192, 241);
            label1.Name = "label1";
            label1.Size = new System.Drawing.Size(63, 13);
            label1.TabIndex = 10;
            label1.Text = "Click Me -->";
            // 
            // TestForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = AutoScaleMode.Font;
            // this.BackgroundImage = global::FontAwesomeWinForms.Properties.Resources.bg;
            this.ClientSize = new System.Drawing.Size(347, 272);
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
            ((System.ComponentModel.ISupportInitialize)(this.iconButton4)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.iconButton3)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.iconButton2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.iconButton1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.iconButton5)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.iconButton6)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.iconButton7)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.iconButton8)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.iconButton9)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

    }
}

