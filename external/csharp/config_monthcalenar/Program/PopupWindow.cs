using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace CompleteDateTimePicker
{
    public class PopupWindow : System.Windows.Forms.ToolStripDropDown
    {
        private System.Windows.Forms.Control _content;
        private System.Windows.Forms.ToolStripControlHost _host;

        public PopupWindow(System.Windows.Forms.Control content)
        {
            //Basic setup...
            this.AutoSize = true;
            this.DoubleBuffered = true;
            this.ResizeRedraw = true;

            this._content = content;
            this._host = new System.Windows.Forms.ToolStripControlHost(content);

            //Positioning and Sizing
            this.Padding = Padding.Empty;
            this.Margin = Padding.Empty;

            //this.MinimumSize = content.MinimumSize;
            //this.MaximumSize = content.Size;
            this.Size = content.Size;
            content.Location = new Point(0, 0);

            //Add the host to the list
            this.Items.Add(this._host);
        }
        public void ResizeToFit()
        {
            this.Size = _content.Size;
        }
    }
}
