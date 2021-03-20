using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using QiHe.Yaml.Grammar;

namespace QiHe.Yaml.YamlUtility.UI
{
    class YamlEmittor
    {
        public static TreeNode CreateNode(DataItem item)
        {
            if (item is Scalar)
            {
                return CreateNodeForScalar(item as Scalar);
            }
            else if (item is Sequence)
            {
                return CreateNodeForSequence(item as Sequence);
            }
            else if (item is Mapping)
            {
                return CreateNodeForMapping(item as Mapping);
            }
            else
            {
                return null;
            }
        }

        private static TreeNode CreateNodeForScalar(Scalar scalar)
        {
            return new TreeNode(scalar.Text);
        }

        private static TreeNode CreateNodeForSequence(Sequence sequence)
        {
            TreeNode node = new TreeNode("Sequence");
            foreach (DataItem item in sequence.Enties)
            {
                node.Nodes.Add(CreateNode(item));
            }
            return node;
        }

        private static TreeNode CreateNodeForMapping(Mapping mapping)
        {
            TreeNode node = new TreeNode("Mapping");
            foreach (MappingEntry entry in mapping.Enties)
            {
                TreeNode nodeEntry = new TreeNode("Entry");
                nodeEntry.Nodes.Add(CreateNode(entry.Key));
                nodeEntry.Nodes.Add(CreateNode(entry.Value));
                node.Nodes.Add(nodeEntry);
            }
            return node;
        }
    }
}
