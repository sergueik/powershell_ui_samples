using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Windows.Forms;

namespace Notify
{
    public partial class Notifier : Form
    {
        #region GLOBALS
        // Set the type of the notify
        public enum Type { INFO, WARNING, ERROR, OK }
        
        // Helper class for handle notifier position
        class PosXY{
            internal int X;
            internal int Y;

            public PosXY(int x, int y)
            {
                this.X = x;
                this.Y = y;
            }
        }
        static List<PosXY> posXY = new List<PosXY>();

        private string desc;
        private PosXY myPos;
        Type type = Type.INFO;
        String title = "Notifier";
        #endregion

        #region CONSTRUCTOR & CREATE
        public Notifier(string dsc, Type type = Type.INFO, string tit = "Notifier")
        {
            this.desc = dsc;
            this.type = type;
            this.title = tit;

            InitializeComponent();
        }

        private void OnLoad(object sender, EventArgs e)
        {
            BackColor = Color.Gray;
            TransparencyKey = Color.Gray;
            FormBorderStyle = FormBorderStyle.None;

            this.Tag = "__Notifier";

            // Fill the note
            buttonClose.Text = title;
            labelDesc.Text = desc;
            date.Text = DateTime.Now + "";

            switch (type)
            {
                case Type.ERROR:
                    icon.Image = global::Notify.Properties.Resources.ko;
                    buttonClose.BackColor = Color.FromArgb(200, 60, 70);
                    break;
                case Type.INFO: 
                    icon.Image = global::Notify.Properties.Resources.info;
                    buttonClose.BackColor = Color.FromArgb(90, 140, 230);
                    break;
                case Type.WARNING:
                    icon.Image = global::Notify.Properties.Resources.warning;
                    buttonClose.BackColor = Color.FromArgb(200, 200, 80);
                    break;
                case Type.OK:
                    icon.Image = global::Notify.Properties.Resources.ok;
                    buttonClose.BackColor = Color.FromArgb(80, 200, 130);
                    break;
            }
            Rectangle rec = Screen.GetWorkingArea(this);

            // Add position
            // Check for a available Position
            int maxNot = rec.Height / this.Height;
            int x_Pos = rec.Width - this.Width;
            
            //int x_Shift = this.Width + 5;     // Full visible note (no overlay)
            int x_Shift = 25;                   // Custom overlay
            int n_columns = 0;
            int n_max_columns = rec.Width / x_Shift;
            bool add = false;
            myPos = new PosXY(x_Pos, rec.Height - (this.Height * 1));
            
            while (!add)
            {
                for (int n_not = 1; n_not <= maxNot; n_not++)
                {
                    myPos = new PosXY(x_Pos, rec.Height - (this.Height * n_not));

                    if (!posXYContains(myPos) )
                    {
                        add = true; break;
                    }

                    // X shift if no more column space
                    if (n_not == maxNot)
                    {
                        n_columns++;
                        n_not = 0;
                        x_Pos = rec.Width - this.Width - x_Shift * n_columns;
                    }

                    // Last exit condition: the screen is full of note
                    if (n_columns >= n_max_columns)
                    {
                        add = true; break;
                    }
                }
            }

            // Notify position
            this.Location = new Point(myPos.X, myPos.Y);
            posXY.Add(myPos);
        }
        #endregion

        #region EVENTS
        private void buttonClose_Click(object sender, EventArgs e)
        {
            posXY.Remove(myPos);
            this.Dispose();
            this.Close();
        }
        #endregion

        #region HELPERS
        private bool posXYContains(PosXY myPos)
        {
            foreach (PosXY p in posXY)
                if (p.X == myPos.X && p.Y == myPos.Y)
                    return true;
            return false;
        }
        #endregion
    }
}
