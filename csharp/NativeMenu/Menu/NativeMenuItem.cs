using Properties;
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

        private ToolStripMenuItem _InstanceUpMenuItem;
        private ToolStripMenuItem _SSHMenuItem;
        private ToolStripMenuItem _InstanceReloadMenuItem;
        private ToolStripMenuItem _InstanceSuspendMenuItem;
        private ToolStripMenuItem _InstanceHaltMenuItem;
        private ToolStripMenuItem _InstanceDestroyMenuItem;
        private ToolStripMenuItem _InstanceProvisionMenuItem;

        private ToolStripMenuItem _OpenInExplorerMenuItem;
        private ToolStripMenuItem _OpenInTerminalMenuItem;
        private ToolStripMenuItem _AddBookmarkMenuItem;
        private ToolStripMenuItem _RemoveBookmarkMenuItem;
        private ToolStripMenuItem _ChooseProviderMenuItem;

        private ToolStripSeparator _MachineSeparator;
        private ToolStripSeparator _ActionSeparator;

        private List<ToolStripMenuItem> _MachineMenuItems;

        public NativeMenuItem() {
            _MachineMenuItems = new List<ToolStripMenuItem>();
        }

        public void Refresh() {


        }

    }
}
