#Copyright (c) 2016 Serguei Kouzmine
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,e
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

Add-Type -TypeDefinition @"


// https://msdn.microsoft.com/en-us/library/system.windows.forms.treeView1.checkboxes%28v=vs.110%29.aspx
using System;
using System.Drawing;
using System.Windows.Forms;
using System.Collections;
public class TreeViewSample : System.Windows.Forms.Panel
{

    private readonly Hashtable _hash_table = new Hashtable();
    public RikTheVeggie.TriStateTreeView treeView1;
    // public System.Windows.Forms.TreeView treeView1;

    private Button showCheckedNodesButton;
    private TreeViewCancelEventHandler checkForCheckedChildren;
    private bool isDrawing = false;
    public TreeViewSample()
    {
        treeView1 = new RikTheVeggie.TriStateTreeView();
        // treeView1 = new System.Windows.Forms.TreeView();

        showCheckedNodesButton = new Button();
        checkForCheckedChildren =
            new TreeViewCancelEventHandler(CheckForCheckedChildrenHandler);

        this.SuspendLayout();

        // Initialize treeView1.
        treeView1.Location = new Point(0, 25);
        treeView1.Size = new Size(292, 248);
        treeView1.Anchor = AnchorStyles.Top | AnchorStyles.Left |
            AnchorStyles.Bottom | AnchorStyles.Right;
        treeView1.CheckBoxes = true;

        showCheckedNodesButton.Size = new Size(144, 24);
        showCheckedNodesButton.Text = "Show Selected Items";
        showCheckedNodesButton.Click +=
            new EventHandler(showCheckedNodesButton_Click);

        // Initialize the elements
        this.ClientSize = new Size(292, 273);
        this.Controls.AddRange(new Control[] { showCheckedNodesButton, treeView1 });
        treeView1.AfterCheck += treeView1_AfterCheck;

        this.ResumeLayout(false);
    }
    public void Add(object o)
    {
        _hash_table[o] = null;
    }

    public bool Contains(object o)
    {
        return _hash_table.ContainsKey(o);
    }

    public void CopyTo(Array array, int index)
    {
        _hash_table.Keys.CopyTo(array, index);
    }

    public int Count
    {
        get { return _hash_table.Count; }
    }

    public IEnumerator GetEnumerator()
    {
        return _hash_table.Keys.GetEnumerator();
    }

    public bool IsSynchronized
    {
        get { return _hash_table.IsSynchronized; }
    }

    public void Remove(object o)
    {
        _hash_table.Remove(o);
    }

    public object SyncRoot
    {
        get { return _hash_table.SyncRoot; }
    }

    private void showCheckedNodesButton_Click(object sender, EventArgs e)
    {
        treeView1.BeginUpdate();
        treeView1.CollapseAll();
        treeView1.BeforeExpand += checkForCheckedChildren;

        // Prevent Nodes without checked children from expanding 
        treeView1.ExpandAll();

        // Remove the checkForCheckedChildren event handler 
        treeView1.BeforeExpand -= checkForCheckedChildren;

        // Enable redrawing of treeView1.
        treeView1.EndUpdate();
    }

    private void checkNodes(TreeNode node, bool isChecked)
    {
        foreach (TreeNode child in node.Nodes)
        {
            child.Checked = isChecked;
            checkNodes(child, isChecked);
        }
    }

    // https://msdn.microsoft.com/en-us/library/system.windows.forms.treeView1.aftercheck%28v=vs.110%29.aspx
    private void treeView1_AfterCheck(object sender, TreeViewEventArgs e)
    {

        // http://stackoverflow.com/questions/5478984/treeview-with-checkboxes-in-c-sharp
        if (isDrawing) return;
        isDrawing = true;
        
        if (!e.Node.Checked)
        {

            if (e.Node.Parent!= null && !HasCheckedChildNodes(e.Node.Parent))
            {
                try
                {
                    e.Node.Parent.Checked = false;
                }
                catch { }
            }


        } 
        

        try
        {
            checkNodes(e.Node, e.Node.Checked);
        }
        finally
        {
            isDrawing = false;
        }
    }

    // Prevent expansion of a node that does not have any checked child nodes.
    private void CheckForCheckedChildrenHandler(object sender,
        TreeViewCancelEventArgs e)
    {
        if (!HasCheckedChildNodes(e.Node)) e.Cancel = true;
    }

    // Traverse childnodes returning a value indicating whether the specified node has checked child nodes.
    private bool HasCheckedChildNodes(TreeNode node)
    {
        if (node.Nodes.Count == 0) return false;
        foreach (TreeNode childNode in node.Nodes)
        {
            if (childNode.Checked)
            {
                Add(childNode.Text);
                return true;
            }
            // Recursively check the children of the current child node.
            if (HasCheckedChildNodes(childNode)) return true;
        }
        return false;
    }
}
namespace RikTheVeggie
{
    // Copyright (CPOL) 2011 RikTheVeggie - see http://www.codeproject.com/info/cpol10.aspx
    // Tri-State Tree View http://www.codeproject.com/script/Articles/ViewDownloads.aspx?aid=202435
    public class TriStateTreeView : System.Windows.Forms.TreeView
    {
        public enum CheckedState : int { UnInitialised = -1, UnChecked, Checked, Mixed };

        int IgnoreClickAction = 0;

        public enum TriStateStyles : int { Standard = 0, Installer };

        private TriStateStyles TriStateStyle = TriStateStyles.Standard;

        [System.ComponentModel.Category("Tri-State Tree View")]
        [System.ComponentModel.DisplayName("Style")]
        [System.ComponentModel.Description("Style of the Tri-State Tree View")]
        public TriStateStyles TriStateStyleProperty
        {
            get { return TriStateStyle; }
            set { TriStateStyle = value; }
        }

        public TriStateTreeView()
            : base()
        {
            StateImageList = new System.Windows.Forms.ImageList();

            // populate the image list, using images from the System.Windows.Forms.CheckBoxRenderer class
            for (int i = 0; i < 3; i++)
            {
                // Create a bitmap which holds the relevent check box style
                // see http://msdn.microsoft.com/en-us/library/ms404307.aspx and http://msdn.microsoft.com/en-us/library/system.windows.forms.checkboxrenderer.aspx

                System.Drawing.Bitmap bmp = new System.Drawing.Bitmap(16, 16);
                System.Drawing.Graphics chkGraphics = System.Drawing.Graphics.FromImage(bmp);
                switch (i)
                {
                    // 0,1 - offset the checkbox slightly so it positions in the correct place
                    case 0:
                        System.Windows.Forms.CheckBoxRenderer.DrawCheckBox(chkGraphics, new System.Drawing.Point(0, 1), System.Windows.Forms.VisualStyles.CheckBoxState.UncheckedNormal);
                        break;
                    case 1:
                        System.Windows.Forms.CheckBoxRenderer.DrawCheckBox(chkGraphics, new System.Drawing.Point(0, 1), System.Windows.Forms.VisualStyles.CheckBoxState.CheckedNormal);
                        break;
                    case 2:
                        System.Windows.Forms.CheckBoxRenderer.DrawCheckBox(chkGraphics, new System.Drawing.Point(0, 1), System.Windows.Forms.VisualStyles.CheckBoxState.MixedNormal);
                        break;
                }

                StateImageList.Images.Add(bmp);
            }
        }

        protected override void OnCreateControl()
        {
            base.OnCreateControl();
            CheckBoxes = false;			// Disable default CheckBox functionality if it's been enabled

            // Give every node an initial 'unchecked' image
            IgnoreClickAction++;	// we're making changes to the tree, ignore any other change requests
            UpdateChildState(this.Nodes, (int)CheckedState.UnChecked, false, true);
            IgnoreClickAction--;
        }

        protected override void OnAfterCheck(System.Windows.Forms.TreeViewEventArgs e)
        {
            base.OnAfterCheck(e);

            if (IgnoreClickAction > 0)
            {
                return;
            }

            IgnoreClickAction++;	// we're making changes to the tree, ignore any other change requests

            // the checked state has already been changed, we just need to update the state index

            // node is either ticked or unticked.  ignore mixed state, as the node is still only ticked or unticked regardless of state of children
            System.Windows.Forms.TreeNode tn = e.Node;
            tn.StateImageIndex = tn.Checked ? (int)CheckedState.Checked : (int)CheckedState.UnChecked;

            // force all children to inherit the same state as the current node
            UpdateChildState(e.Node.Nodes, e.Node.StateImageIndex, e.Node.Checked, false);

            // populate state up the tree, possibly resulting in parents with mixed state
            UpdateParentState(e.Node.Parent);

            IgnoreClickAction--;
        }

        protected override void OnAfterExpand(System.Windows.Forms.TreeViewEventArgs e)
        {
            // If any child node is new, give it the same check state as the current node
            // So if current node is ticked, child nodes will also be ticked
            base.OnAfterExpand(e);

            IgnoreClickAction++;	// we're making changes to the tree, ignore any other change requests
            UpdateChildState(e.Node.Nodes, e.Node.StateImageIndex, e.Node.Checked, true);
            IgnoreClickAction--;
        }

        protected void UpdateChildState(System.Windows.Forms.TreeNodeCollection Nodes, int StateImageIndex, bool Checked, bool ChangeUninitialisedNodesOnly)
        {
            foreach (System.Windows.Forms.TreeNode tnChild in Nodes)
            {
                if (!ChangeUninitialisedNodesOnly || tnChild.StateImageIndex == -1)
                {
                    tnChild.StateImageIndex = StateImageIndex;
                    tnChild.Checked = Checked;	// override 'checked' state of child with that of parent

                    if (tnChild.Nodes.Count > 0)
                    {
                        UpdateChildState(tnChild.Nodes, StateImageIndex, Checked, ChangeUninitialisedNodesOnly);
                    }
                }
            }
        }

        protected void UpdateParentState(System.Windows.Forms.TreeNode tn)
        {
            // Node needs to check all of it's children to see if any of them are ticked or mixed
            if (tn == null)
                return;

            int OrigStateImageIndex = tn.StateImageIndex;

            int UnCheckedNodes = 0, CheckedNodes = 0, MixedNodes = 0;

            // The parent needs to know how many of it's children are Checked or Mixed
            foreach (System.Windows.Forms.TreeNode tnChild in tn.Nodes)
            {
                if (tnChild.StateImageIndex == (int)CheckedState.Checked)
                    CheckedNodes++;
                else if (tnChild.StateImageIndex == (int)CheckedState.Mixed)
                {
                    MixedNodes++;
                    break;
                }
                else
                    UnCheckedNodes++;
            }

            if (TriStateStyle == TriStateStyles.Installer)
            {
                // In Installer mode, if all child nodes are checked then parent is checked
                // If at least one child is unchecked, then parent is unchecked
                if (MixedNodes == 0)
                {
                    if (UnCheckedNodes == 0)
                    {
                        // all children are checked, so parent must be checked
                        tn.Checked = true;
                    }
                    else
                    {
                        // at least one child is unchecked, so parent must be unchecked
                        tn.Checked = false;
                    }
                }
            }

            // Determine the parent's new Image State
            if (MixedNodes > 0)
            {
                // at least one child is mixed, so parent must be mixed
                tn.StateImageIndex = (int)CheckedState.Mixed;
            }
            else if (CheckedNodes > 0 && UnCheckedNodes == 0)
            {
                // all children are checked
                if (tn.Checked)
                    tn.StateImageIndex = (int)CheckedState.Checked;
                else
                    tn.StateImageIndex = (int)CheckedState.Mixed;
            }
            else if (CheckedNodes > 0)
            {
                // some children are checked, the rest are unchecked
                tn.StateImageIndex = (int)CheckedState.Mixed;
            }
            else
            {
                // all children are unchecked
                if (tn.Checked)
                    tn.StateImageIndex = (int)CheckedState.Mixed;
                else
                    tn.StateImageIndex = (int)CheckedState.UnChecked;
            }

            if (OrigStateImageIndex != tn.StateImageIndex && tn.Parent != null)
            {
                // Parent's state has changed, notify the parent's parent
                UpdateParentState(tn.Parent);
            }
        }

        protected override void OnKeyDown(System.Windows.Forms.KeyEventArgs e)
        {
            base.OnKeyDown(e);

            // is the keypress a space?  If not, discard it
            if (e.KeyCode == System.Windows.Forms.Keys.Space)
            {
                // toggle the node's checked status.  This will then fire OnAfterCheck
                SelectedNode.Checked = !SelectedNode.Checked;
            }
        }

        protected override void OnNodeMouseClick(System.Windows.Forms.TreeNodeMouseClickEventArgs e)
        {
            base.OnNodeMouseClick(e);

            // is the click on the checkbox?  If not, discard it
            System.Windows.Forms.TreeViewHitTestInfo info = HitTest(e.X, e.Y);
            if (info == null || info.Location != System.Windows.Forms.TreeViewHitTestLocations.StateImage)
            {
                return;
            }

            // toggle the node's checked status.  This will then fire OnAfterCheck
            System.Windows.Forms.TreeNode tn = e.Node;
            tn.Checked = !tn.Checked;
        }
    }
}
"@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Data.dll','System.Drawing.dll','System.Collections.dll'

Add-Type -TypeDefinition @"
using System;
using System.Windows.Forms;
public class Win32Window : IWin32Window
{
    private IntPtr _hWnd;
    private int _data;
    private string _message;

    public int Data
    {
        get { return _data; }
        set { _data = value; }
    }
    public string Message
    {
        get { return _message; }
        set { _message = value; }
    }

    public Win32Window(IntPtr handle)
    {
        _hWnd = handle;
    }

    public IntPtr Handle
    {
        get { return _hWnd; }
    }
}

"@ -ReferencedAssemblies 'System.Windows.Forms.dll'

# Simplified structure to generate a treeview
# see https://communities.vmware.com/docs/DOC-17938
# https://communities.vmware.com/servlet/JiveServlet/download/17938-4-78419/Dumper.psm1

$tree =
@{
  'Fruit' = @{
              'Pepo' = '$null';
              'Hesperidium' = @{
                                'Lemon' = '$null';
                                'Grapefruit' = '$null';
                                'Lime' = '$null';
                                'Orange' = '$null';
                               };
              'True berry' = @{
                               'Lucuma' = '$null';
                               'Blueberry' = '$null';
                               'Gooseberry' = '$null';
                               'Eggplant' = '$null';
                               'Guava' = '$null';
                               'Chili pepper' = '$null';
                               'Kiwifruit' = '$null';
                               'Blackcurrant' = '$null';
                               'Redcurrant' = '$null';
                               'Pomegranate' = '$null';
                               'Grape' = '$null';
                               'Cranberry' = '$null';
                               'Tomato' = '$null';
                              }
             };
  'Vegetable' = @{
                  'Allium sativum' = @{
                                       'garlic' = '$null';
                                      };
                  'Phaseolus' = @{
                                  'green bean' = '$null';
                                  'haricot bean' = '$null';
                                  'French bean' = '$null';
                                  'runner bean' = '$null';
                                  'Lima bean' = '$null';
                                 };
                  'Pisum sativum' = @{
                                      'snow pea' = '$null';
                                      'pea' = '$null';
                                      'split pea' = '$null';
                                      'snap pea' = '$null';
                                     };
                  'Daucus carota' = @{
                                      'carrot' = '$null';
                                     };
                  'Brassica oleracea' = @{
                                          'red cabbage' = '$null';
                                          'broccoli' = '$null';
                                          'Brussels sprouts' = '$null';
                                          'cabbage' = '$null';
                                          'cauliflower' = '$null';
                                         };
                 };
 }


$deeply_nested_tree =
@{
  'a' = @{
          'aa' = @{
                   'aaa' = @{
                             'aaaa' = @{
                                        'aaaaa' = '$null';
                                       }
                            };
                   'aab' = @{
                             'aaba' = '$null';
                            };
                   'aac' = '$null';
                  };
          'ab' = @{
                   'aba' = @{
                             'abaa' = '$null';
                             'abab' = '$null'
                            }
                  };
          'ac' = @{
                   'aca' = '$null';
                   'acb' = '$null';
                   'acc' = '$null';
                   'acd' = '$null';
                   'ace' = '$null';
                   'acf' = '$null';
                   'acg' = '$null';
                   'ach' = '$null';
                  };
          'ad' = '$null';
         };
  'b' = @{
          'ba' = '$null'
          'bb' = '$null';
          'bc' = '$null';
          'bd' = '$null';
          'be' = '$null';
         };
  'c ' = '$null';
 }


function populateTree {
  param(
    [Object]$Object,
    [System.Windows.Forms.TreeNode]$parent_node
  )
 
  [System.Windows.Forms.TreeNode]$new_node

  if ( $Object -is [hashtable] ) {
    foreach ( $pair in $Object.GetEnumerator() ){
      # Add node
      if ($parent_node -eq $null) { 
        $new_node = $t.treeView1.Nodes.Add($pair.Key)
      } else {
        $new_node  = $parent_node.Nodes.Add($pair.Key)
      }
      # Recursion is here
      populateTree -object $pair.Value -parent_node $new_node 
    }
  }

}

function PromptTreeView
{
  param(
    [string]$title,
    [object]$caller = $null
  )

  @( 'System.Drawing','System.Collections.Generic','System.Collections','System.ComponentModel','System.Text','System.Data','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }
  $f = New-Object System.Windows.Forms.Form
  $f.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
  $f.Text = $title
  $t = New-Object TreeViewSample
  $t.Dock = [System.Windows.Forms.DockStyle]::Fill
  $components = New-Object System.ComponentModel.Container
  $t.Size = New-Object System.Drawing.Size (284,256)
  populateTree -object $tree -parent_node $null
  $f.SuspendLayout()
  $f.AutoScaleBaseSize = New-Object System.Drawing.Size (5,13)
  $f.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
  $f.ClientSize = New-Object System.Drawing.Size (292,266)
  $f.Controls.Add($t)
  $f.ResumeLayout($false)
  $f.Topmost = $true
  if ($caller -eq $null) {
    $caller = New-Object Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)
  }
  $f.Add_Shown({ $f.Activate() })

  [void]$f.ShowDialog([win32window]($caller))
  $results = @()
  $caller.Message = ''
  $caller.Data = 0
  if ($t.Count -gt 0) {
    $caller.Data = $t.Count
    $t.GetEnumerator() | ForEach-Object {
      $results += $_
    }
    $caller.Message = $results -join "`r`n"
  } else {
    $caller.Data = 0
  }

  $t.Dispose()
  $f.Dispose()

}

$caller = New-Object Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)
$result = PromptTreeView 'Treeview' $caller

if ($caller.Data -gt 0) {
  $caller.Data = 1
  Write-Host ('Selection is : {0}' -f $caller.Message)
} else {
  Write-Host 'Nothing was selected.'

}
