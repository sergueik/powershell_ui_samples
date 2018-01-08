using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CustomWindowsForm
{
    public partial class Dashboard_Form : Form
    {
        public Dashboard_Form()
        {
            InitializeComponent();
        }

        Point offset;
        bool isTopPanelDragged = false;


        private void Dashboard_Form_Load(object sender, EventArgs e)
        {
            dashboard_button_Click(sender, e);
        }

        private void TopPanel_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                isTopPanelDragged = true;
                Point pointStartPosition = this.PointToScreen(new Point(e.X, e.Y));
                offset = new Point();
                offset.X = this.Location.X - (pointStartPosition.X + LeftTopPanel.Size.Width);
                offset.Y = this.Location.Y - pointStartPosition.Y;
            }
            else
            {
                isTopPanelDragged = false;
            }
        }

        private void TopPanel_MouseMove(object sender, MouseEventArgs e)
        {
            if (isTopPanelDragged)
            {
                Point newPoint = TopPanel.PointToScreen(new Point(e.X, e.Y));
                newPoint.Offset(offset);
                this.Location = newPoint;
            }
        }

        private void TopPanel_MouseUp(object sender, MouseEventArgs e)
        {
            isTopPanelDragged = false;
        }

        private void _CloseButton_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void _MinButton_Click(object sender, EventArgs e)
        {
            this.WindowState = FormWindowState.Minimized;
        }

        private void DashboardLabel_mouseDown(object sender, MouseEventArgs e)
        {
            TopPanel_MouseDown(sender, e);
        }

        private void DashboardLabel_mouseMove(object sender, MouseEventArgs e)
        {
            TopPanel_MouseMove(sender, e);
        }

        private void DashboardLabel_mouseUp(object sender, MouseEventArgs e)
        {
            TopPanel_MouseUp(sender, e);
        }








        private void dashboard_button_Click(object sender, EventArgs e)
        {
            dashboard_button.BZBackColor = Color.FromArgb(20, 20, 20);
            dashboard_button.ChangeColorMouseHC = false;
            stats_button.BZBackColor = Color.FromArgb(30, 30, 40);
            pages_button.BZBackColor = Color.FromArgb(30, 30, 40);
            layout_button.BZBackColor = Color.FromArgb(30, 30, 40);
            theme_button.BZBackColor = Color.FromArgb(30, 30, 40);
            settings_button.BZBackColor = Color.FromArgb(30, 30, 40);
            stats_button.ChangeColorMouseHC = true;
            pages_button.ChangeColorMouseHC = true;
            layout_button.ChangeColorMouseHC = true;
            theme_button.ChangeColorMouseHC = true;
            settings_button.ChangeColorMouseHC = true;
        }

        private void stats_button_Click(object sender, EventArgs e)
        {
            stats_button.BZBackColor = Color.FromArgb(20, 20, 20);
            stats_button.ChangeColorMouseHC = false;
            dashboard_button.BZBackColor = Color.FromArgb(30, 30, 40);
            pages_button.BZBackColor = Color.FromArgb(30, 30, 40);
            layout_button.BZBackColor = Color.FromArgb(30, 30, 40);
            theme_button.BZBackColor = Color.FromArgb(30, 30, 40);
            settings_button.BZBackColor = Color.FromArgb(30, 30, 40);
            dashboard_button.ChangeColorMouseHC = true;
            pages_button.ChangeColorMouseHC = true;
            layout_button.ChangeColorMouseHC = true;
            theme_button.ChangeColorMouseHC = true;
            settings_button.ChangeColorMouseHC = true;
        }

        private void pages_button_Click(object sender, EventArgs e)
        {
            pages_button.BZBackColor = Color.FromArgb(20, 20, 20);
            pages_button.ChangeColorMouseHC = false;
            dashboard_button.BZBackColor = Color.FromArgb(30, 30, 40);
            stats_button.BZBackColor = Color.FromArgb(30, 30, 40);
            layout_button.BZBackColor = Color.FromArgb(30, 30, 40);
            theme_button.BZBackColor = Color.FromArgb(30, 30, 40);
            settings_button.BZBackColor = Color.FromArgb(30, 30, 40);
            dashboard_button.ChangeColorMouseHC = true;
            stats_button.ChangeColorMouseHC = true;
            layout_button.ChangeColorMouseHC = true;
            theme_button.ChangeColorMouseHC = true;
            settings_button.ChangeColorMouseHC = true;
        }

        private void layout_button_Click(object sender, EventArgs e)
        {
            layout_button.BZBackColor = Color.FromArgb(20, 20, 20);
            layout_button.ChangeColorMouseHC = false;
            dashboard_button.BZBackColor = Color.FromArgb(30, 30, 40);
            stats_button.BZBackColor = Color.FromArgb(30, 30, 40);
            pages_button.BZBackColor = Color.FromArgb(30, 30, 40);
            theme_button.BZBackColor = Color.FromArgb(30, 30, 40);
            settings_button.BZBackColor = Color.FromArgb(30, 30, 40);
            dashboard_button.ChangeColorMouseHC = true;
            stats_button.ChangeColorMouseHC = true;
            pages_button.ChangeColorMouseHC = true;
            theme_button.ChangeColorMouseHC = true;
            settings_button.ChangeColorMouseHC = true;
        }

        private void theme_button_Click(object sender, EventArgs e)
        {
            theme_button.BZBackColor = Color.FromArgb(20, 20, 20);
            theme_button.ChangeColorMouseHC = false;
            dashboard_button.BZBackColor = Color.FromArgb(30, 30, 40);
            stats_button.BZBackColor = Color.FromArgb(30, 30, 40);
            pages_button.BZBackColor = Color.FromArgb(30, 30, 40);
            layout_button.BZBackColor = Color.FromArgb(30, 30, 40);
            settings_button.BZBackColor = Color.FromArgb(30, 30, 40);
            dashboard_button.ChangeColorMouseHC = true;
            stats_button.ChangeColorMouseHC = true;
            pages_button.ChangeColorMouseHC = true;
            layout_button.ChangeColorMouseHC = true;
            settings_button.ChangeColorMouseHC = true;
        }

        private void settings_button_Click(object sender, EventArgs e)
        {
            settings_button.BZBackColor = Color.FromArgb(20, 20, 20);
            settings_button.ChangeColorMouseHC = false;
            dashboard_button.BZBackColor = Color.FromArgb(30, 30, 40);
            stats_button.BZBackColor = Color.FromArgb(30, 30, 40);
            pages_button.BZBackColor = Color.FromArgb(30, 30, 40);
            layout_button.BZBackColor = Color.FromArgb(30, 30, 40);
            theme_button.BZBackColor = Color.FromArgb(30, 30, 40);
            dashboard_button.ChangeColorMouseHC = true;
            stats_button.ChangeColorMouseHC = true;
            pages_button.ChangeColorMouseHC = true;
            layout_button.ChangeColorMouseHC = true;
            theme_button.ChangeColorMouseHC = true;
        }



    }
}
