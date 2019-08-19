using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace ImageButtonDemo
{
    public partial class Form1 : Form
    {
        private bool hideAlerts = false;
        public Form1()
        {
            InitializeComponent();
        }

        private void imageButton1_Click(object sender, EventArgs e)
        {
            if (!hideAlerts)
                MessageBox.Show("Clicked default button.");
        }

        private void imageButton2_Click(object sender, EventArgs e)
        {
            if (!hideAlerts)
                MessageBox.Show("Clicked button B.");
        }

        private void imageButton3_Click(object sender, EventArgs e)
        {
            hideAlerts = !hideAlerts;
            if (hideAlerts)
            {
                imageButton3.NormalImage = ImageButtonDemo.Properties.Resources.CCheckedNormal;
                imageButton3.HoverImage = ImageButtonDemo.Properties.Resources.CCheckedHover;
                imageButton3.DownImage = ImageButtonDemo.Properties.Resources.CCheckedDown;
            }
            else
            {
                imageButton3.NormalImage = ImageButtonDemo.Properties.Resources.CUncheckedNormal;
                imageButton3.HoverImage = ImageButtonDemo.Properties.Resources.CUncheckedHover;
                imageButton3.DownImage = ImageButtonDemo.Properties.Resources.CUncheckedDown;
            }
        }

        private void imageButton4_Click(object sender, EventArgs e)
        {
            if (!hideAlerts)
                MessageBox.Show("Clicked button C.");
        }

        private void imageButton5_Click(object sender, EventArgs e)
        {
            if (!hideAlerts)
                MessageBox.Show("Clicked button D.");
        }

        private void imageButton6_Click(object sender, EventArgs e)
        {
            if (!hideAlerts)
                MessageBox.Show("Clicked button E.");
        }

        private void imageButton7_Click(object sender, EventArgs e)
        {
            if (!hideAlerts)
                MessageBox.Show("Clicked button F.");
        }
    }
}