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
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.


# origin:http://www.codeproject.com/Tips/1083589/Adding-Checkbox-to-a-List-View-Column-Header-in
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$f = New-Object System.Windows.Forms.Form

$listview1 = new-object System.Windows.Forms.ListView

[System.Windows.Forms.ListViewItem]$listViewItem1 = new-object System.Windows.Forms.ListViewItem(@( "","sub 1","sub 2"), -1)
[System.Windows.Forms.ListViewItem]$listViewItem2 = new-object System.Windows.Forms.ListViewItem(@( "","sub 1","sub 2"), -1)
[System.Windows.Forms.ColumnHeader]$columnHeader1 = new-object System.Windows.Forms.ColumnHeader
[System.Windows.Forms.ColumnHeader]$columnHeader2 = new-object System.Windows.Forms.ColumnHeader
[System.Windows.Forms.ColumnHeader]$columnHeader3 = new-object System.Windows.Forms.ColumnHeader
$data_gridview_textbox_columnumn1 = new-object System.Windows.Forms.DataGridViewTextBoxColumn
$data_gridview_textbox_columnumn2 = new-object System.Windows.Forms.DataGridViewTextBoxColumn
$f.SuspendLayout()
#             
# listView1
#             
$listview1.CheckBoxes = $true
$listview1.Columns.AddRange(@($columnHeader1,$columnHeader2,$columnHeader3))
$listViewItem1.StateImageIndex = 0
$listViewItem2.StateImageIndex = 0
$listview1.Items.AddRange(@( $listViewItem1, $listViewItem2))
$listview1.Location = new-object System.Drawing.Point(12, 12)
$listview1.Name = "listView1"
$listview1.OwnerDraw = $true
$listview1.Size = new-object System.Drawing.Size(276, 139)
$listview1.TabIndex = 5
$listview1.UseCompatibleStateImageBehavior = $false
$listview1.View = [System.Windows.Forms.View]::Details
# TODO:
# $listview1.ColumnClick += new-object System.Windows.Forms.ColumnClickEventHandler($listview1_ColumnClick)
# $listview1.DrawColumnHeader += new-object System.Windows.Forms.DrawListViewColumnHeaderEventHandler($listview1_DrawColumnHeader)
# $listview1.DrawItem += new-object System.Windows.Forms.DrawListViewItemEventHandler($listview1_DrawItem)
# $listview1.DrawSubItem += new-object System.Windows.Forms.DrawListViewSubItemEventHandler($listview1_DrawSubItem)
# 
# columnHeader1
# 
$columnHeader1.Text = ""
$columnHeader1.Width = 33
# 
# columnHeader2
# 
$columnHeader2.Text = "Column1"
$columnHeader2.Width = 83
# 
# columnHeader3
# 
$columnHeader3.Text = "Column2"
$columnHeader3.Width = 103
# 
# dataGridViewTextBoxColumn1
# 
$data_gridview_textbox_columnumn1.HeaderText = "Column1"
$data_gridview_textbox_columnumn1.Name = "dataGridViewTextBoxColumn1"
# 
# dataGridViewTextBoxColumn2
# 
$data_gridview_textbox_columnumn2.HeaderText = "Column2"
$data_gridview_textbox_columnumn2.Name = "dataGridViewTextBoxColumn2"
# 
# Form1
# 
$f.AutoScaleDimensions = new-object System.Drawing.Size(8, 16)
$f.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font
$f.ClientSize = new-object System.Drawing.Size(300, 163)
$f.Controls.Add($listview1)
$f.Name = "Form1"
$f.Text = "Form1"
$f.ResumeLayout($false)
[void]$f.ShowDialog()
