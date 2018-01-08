using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms;
namespace CustomWindowsForm
{
    public class MenuStripZ : MenuStrip
    {
        public MenuStripZ()
        {
            this.Renderer = new MyMenuRenderer();
        }
    }

    public class MyMenuRenderer : ToolStripRenderer
    {
        protected override void OnRenderMenuItemBackground(ToolStripItemRenderEventArgs e)
        {
            base.OnRenderMenuItemBackground(e);

            if (e.Item.Enabled)
            {
                if (e.Item.IsOnDropDown == false && e.Item.Selected)
                {
                    var rect = new Rectangle(0, 0, e.Item.Width - 1, e.Item.Height - 1);
                    var rect2 = new Rectangle(0, 0, e.Item.Width - 1, e.Item.Height - 1);
                    e.Graphics.FillRectangle(new SolidBrush(Color.FromArgb(60, 60, 60)), rect);
                    e.Graphics.DrawRectangle(new Pen(new SolidBrush(Color.Black)), rect2);
                    e.Item.ForeColor = Color.White;
                }
                else
                {
                    e.Item.ForeColor = Color.White;
                }

                if (e.Item.IsOnDropDown && e.Item.Selected)
                {
                    var rect = new Rectangle(0, 0, e.Item.Width - 1, e.Item.Height - 1);
                    e.Graphics.FillRectangle(new SolidBrush(Color.FromArgb(60, 60, 60)), rect);
                    e.Graphics.DrawRectangle(new Pen(new SolidBrush(Color.Black)), rect);
                    e.Item.ForeColor = Color.White;
                }
                if ((e.Item as ToolStripMenuItem).DropDown.Visible && e.Item.IsOnDropDown == false)
                {
                    var rect = new Rectangle(0, 0, e.Item.Width - 1, e.Item.Height - 1);
                    var rect2 = new Rectangle(0, 0, e.Item.Width - 1, e.Item.Height - 1);
                    e.Graphics.FillRectangle(new SolidBrush(Color.FromArgb(20, 20, 20)), rect);
                    e.Graphics.DrawRectangle(new Pen(new SolidBrush(Color.Black)), rect2);
                    e.Item.ForeColor = Color.White;
                }
            }
        }
        protected override void OnRenderSeparator(ToolStripSeparatorRenderEventArgs e)
        {
            base.OnRenderSeparator(e);
            var DarkLine = new SolidBrush(Color.FromArgb(30, 30, 30));
            var rect = new Rectangle(30, 3, e.Item.Width - 30, 1);
            e.Graphics.FillRectangle(DarkLine, rect);
        }


        protected override void OnRenderItemCheck(ToolStripItemImageRenderEventArgs e)
        {
            base.OnRenderItemCheck(e);

            if (e.Item.Selected)
            {
                var rect = new Rectangle(4, 2, 18, 18);
                var rect2 = new Rectangle(5, 3, 16, 16);
                SolidBrush b = new SolidBrush(Color.Black);
                SolidBrush b2 = new SolidBrush(Color.FromArgb(220, 220, 220));

                e.Graphics.FillRectangle(b, rect);
                e.Graphics.FillRectangle(b2, rect2);
                e.Graphics.DrawImage(e.Image, new Point(5, 3));
            }
            else
            {
                var rect = new Rectangle(4, 2, 18, 18);
                var rect2 = new Rectangle(5, 3, 16, 16);
                SolidBrush b = new SolidBrush(Color.White);
                SolidBrush b2 = new SolidBrush(Color.FromArgb(255, 80, 90, 90));

                e.Graphics.FillRectangle(b, rect);
                e.Graphics.FillRectangle(b2, rect2);
                e.Graphics.DrawImage(e.Image, new Point(5, 3));
            }
        }

        protected override void OnRenderImageMargin(ToolStripRenderEventArgs e)
        {
            base.OnRenderImageMargin(e);

            var rect = new Rectangle(0, 0, e.ToolStrip.Width, e.ToolStrip.Height);
            e.Graphics.FillRectangle(new SolidBrush(Color.FromArgb(20, 20, 20)), rect);

            var DarkLine = new SolidBrush(Color.FromArgb(20, 20, 20));
            var rect3 = new Rectangle(0, 0, 26, e.AffectedBounds.Height);
            e.Graphics.FillRectangle(DarkLine, rect3);

            e.Graphics.DrawLine(new Pen(new SolidBrush(Color.FromArgb(20, 20, 20))), 28, 0, 28, e.AffectedBounds.Height);

            var rect2 = new Rectangle(0, 0, e.ToolStrip.Width - 1, e.ToolStrip.Height - 1);
            e.Graphics.DrawRectangle(new Pen(new SolidBrush(Color.Black)), rect2);
        }
    }
}