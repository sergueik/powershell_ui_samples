$labelDesc = New-Object System.Windows.Forms.Label
$dateLabel = New-Object System.Windows.Forms.Label
$icon = New-Object System.Windows.Forms.PictureBox
$buttonClose = New-Object System.Windows.Forms.Button
# Type.ERROR
$buttonClose.BackColor = [System.Drawing.Color]::FromArgb(200,60,70)
# Type.INFO
$buttonClose.BackColor = [System.Drawing.Color]::FromArgb(90,140,230)
# Type.WARNING
$buttonClose.BackColor = [System.Drawing.Color]::FromArgb(200,200,80)
# Type.OK
$buttonClose.BackColor = [System.Drawing.Color]::FromArgb(80,200,130)
# ((System.ComponentModel.ISupportInitialize)($icon)).BeginInit()
$notifier.SuspendLayout()
#  
#  labelDesc
#  
$labelDesc.Font = New-Object System.Drawing.Font ("Microsoft Sans Serif",8.25,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,0)
$labelDesc.Image = global::Notify.Properties.Resources.notifier
$labelDesc.Location = New-Object System.Drawing.Point (42,30)
$labelDesc.Name = "labelDesc"
$labelDesc.Size = New-Object System.Drawing.Size (270,56)
$labelDesc.TabIndex = 3
$labelDesc.Text = "Description"
$labelDesc.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
#  
#  date
#  
$dateLabel.AutoSize = $true
$dateLabel.Font = New-Object System.Drawing.Font ("Microsoft Sans Serif",6,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)
$dateLabel.Image = global::Notify.Properties.Resources.notifier
$dateLabel.Location = New-Object System.Drawing.Point (43,86)
$dateLabel.Name = "date"
$dateLabel.Size = New-Object System.Drawing.Size (19,9)
$dateLabel.TabIndex = 4
$dateLabel.Text = "date"
#  
#  icon
#  
$icon.BackgroundImage = global::Notify.Properties.Resources.img_notifier
$icon.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Stretch
$icon.Image = global::Notify.Properties.Resources.info
$icon.Location = New-Object System.Drawing.Point (12,46)
$icon.Name = "icon"
$icon.Size = New-Object System.Drawing.Size (24,24)
$icon.TabIndex = 2
$icon.TabStop = $false
#  
#  buttonClose
#  
$buttonClose.BackColor = [System.Drawing.Color]::FromArgb(90,140,230)
$buttonClose.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Center
$buttonClose.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(255,115,135)
$buttonClose.FlatAppearance.BorderSize = 0
$buttonClose.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$buttonClose.Font = New-Object System.Drawing.Font ("Microsoft Sans Serif",9,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,0)
$buttonClose.ForeColor = [System.Drawing.Color]::White
$buttonClose.Image = global::Notify.Properties.Resources.close
$buttonClose.ImageAlign = [System.Drawing.ContentAlignment]::MiddleRight
$buttonClose.Location = New-Object System.Drawing.Point (2,2)
$buttonClose.Name = "buttonClose"
$buttonClose.Size = New-Object System.Drawing.Size (320,24)
$buttonClose.TabIndex = 1
$buttonClose.Text = " Calibrator"
$buttonClose.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
$buttonClose.UseVisualStyleBackColor = $false
$buttonClose.Click += New-Object System.EventHandler ($buttonClose_Click)
#  
#  Notifier
#  
$notifier.AutoScaleDimensions = New-Object System.Drawing.SizeF (6,13)
$notifier.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font
$notifier.BackColor = [System.Drawing.Color]::White
$notifier.BackgroundImage = global::Notify.Properties.Resources.notifier
$notifier.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Stretch
$notifier.ClientSize = New-Object System.Drawing.Size (324,100)
$notifier.Controls.Add($dateLabel)
$notifier.Controls.Add($labelDesc)
$notifier.Controls.Add($icon)
$notifier.Controls.Add($buttonClose)
$notifier.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$notifier.Name = "Notifier"
$notifier.ShowInTaskbar = $false
$notifier.Text = "Notifier"
$notifier.TopMost = true
$notifier.Load += New-Object System.EventHandler ($OnLoad)
# ((System.ComponentModel.ISupportInitialize)($icon)).EndInit()
$notifier.ResumeLayout($false)
$notifier.PerformLayout()


Add-Type @"

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace Notifier
{
    // Helper class for handle notifier position
    class PosXY
    {
        internal int X;
        internal int Y;

        public PosXY(int x, int y)
        {
            this.X = x;
            this.Y = y;
        }
    }
    public class Notifier : Form
    {
        private bool posXYContains(PosXY myPos)
        {
            foreach (PosXY p in posXY)
                if (p.X == myPos.X && p.Y == myPos.Y)
                    return true;
            return false;
        }

        static List<PosXY> posXY = new List<PosXY>();
        private string desc;
        private PosXY myPos;
        private void OnLoad(object sender, EventArgs e)
        {
            Rectangle rec = Screen.GetWorkingArea(this);

            //  Add position
            //  Check for a available Position
            int maxNot = rec.Height / this.Height;
            int x_Pos = rec.Width - this.Width;

            // int x_Shift = this.Width + 5;     //  Full visible note (no overlay)
            int x_Shift = 25;                   //  Custom overlay
            int n_columns = 0;
            int n_max_columns = rec.Width / x_Shift;
            bool add = false;
            myPos = new PosXY(x_Pos, rec.Height - (this.Height * 1));

            while (!add)
            {
                for (int n_not = 1; n_not <= maxNot; n_not++)
                {
                    myPos = new PosXY(x_Pos, rec.Height - (this.Height * n_not));

                    if (!posXYContains(myPos))
                    {
                        add = true; break;
                    }

                    //  X shift if no more column space
                    if (n_not == maxNot)
                    {
                        n_columns++;
                        n_not = 0;
                        x_Pos = rec.Width - this.Width - x_Shift * n_columns;
                    }

                    //  Last exit condition: the screen is full of note
                    if (n_columns >= n_max_columns)
                    {
                        add = true; break;
                    }
                }
            }

            //  Notify position
            this.Location = new Point(myPos.X, myPos.Y);
            posXY.Add(myPos);
        }
    }
}

"@
