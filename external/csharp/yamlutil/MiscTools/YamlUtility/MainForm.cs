using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;
using QiHe.CodeLib;
using QiHe.Yaml.Grammar;
// using QiHe.Yaml.Grammar.YamlParser;

namespace QiHe.Yaml.YamlUtility.UI
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
        }

        private void toolStripButtonOpen_Click(object sender, EventArgs e)
        {
            string file = FileSelector.BrowseFile();
            if (file != null)
            {
                richTextBoxSource.Text = File.ReadAllText(file);
            }
        }

        private void toolStripButtonParse_Click(object sender, EventArgs e)
        {
            TextInput input = new TextInput(richTextBoxSource.Text);

            bool success;
            YamlParser parser = new YamlParser();
            YamlStream yamlStream = parser.ParseYamlStream(input, out success);
            if (success)
            {
                treeViewData.Nodes.Clear();	
                foreach (QiHe.Yaml.Grammar.YamlDocument doc in yamlStream.Documents)
                {
                    treeViewData.Nodes.Add(YamlEmittor.CreateNode(doc.Root));
                }
                treeViewData.ExpandAll();
                tabControl1.SelectedTab = tabPageDataTree;
            }
            else
            {
                MessageBox.Show(parser.GetEorrorMessages());
            }

        }
    }
}