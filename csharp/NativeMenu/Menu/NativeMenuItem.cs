// using HudsonClient.Properties;
using DialogWindows;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Menu {
    class NativeMenuItem {
        public NativeMenuItemDelegate Delegate { get; set; }
        public ToolStripMenuItem MenuItem { get; set; }

        private List<ToolStripMenuItem> _MachineMenuItems;

        public NativeMenuItem() {
            _MachineMenuItems = new List<ToolStripMenuItem>();
        }

        public void Refresh() {


        }

    }
}
