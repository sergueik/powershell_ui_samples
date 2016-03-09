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

[System.Windows.Forms.ListViewItem]$i1 = new-object System.Windows.Forms.ListViewItem([String[]](@( "","sub 1","sub 2")), -1)
[System.Windows.Forms.ListViewItem]$i2 = new-object System.Windows.Forms.ListViewItem([String[]](@( "","sub 1","sub 2")), -1)
[System.Windows.Forms.ColumnHeader]$h1 = new-object System.Windows.Forms.ColumnHeader
[System.Windows.Forms.ColumnHeader]$h2 = new-object System.Windows.Forms.ColumnHeader
[System.Windows.Forms.ColumnHeader]$h3 = new-object System.Windows.Forms.ColumnHeader
$data_gridview_textbox_columnumn1 = new-object System.Windows.Forms.DataGridViewTextBoxColumn
$data_gridview_textbox_columnumn2 = new-object System.Windows.Forms.DataGridViewTextBoxColumn
$f.SuspendLayout()
#             
# listView1
#             
$listview1.CheckBoxes = $true
$listview1.Columns.AddRange(@($h1,$h2,$h3))
$i1.StateImageIndex = 0
$i2.StateImageIndex = 0
$listview1.Items.AddRange(@( $i1, $i2))
$listview1.Location = new-object System.Drawing.Point(12, 12)
$listview1.Name = "listView1"
# custom-drawn headers with  a checkboxs
$listview1.OwnerDraw = $true
$listview1.Size = new-object System.Drawing.Size(276, 139)
$listview1.TabIndex = 5
$listview1.UseCompatibleStateImageBehavior = $false
$listview1.View = [System.Windows.Forms.View]::Details

$listview1.add_ColumnClick({
  param([object] $sender, [System.Windows.Forms.ColumnClickEventArgs] $e)
  })

$listview1.add_DrawColumnHeader({
  param([object] $sender, [System.Windows.Forms.DrawListViewColumnHeaderEventArgs] $e)
    # TODO: update to owner-drawn
    if ($e.ColumnIndex -eq 0) {
        $e.DrawBackground()
    $value = [Convert]::ToBoolean($e.Header.Tag)
    if ($value) {
    $style = [System.Windows.Forms.VisualStyles.CheckBoxState]::CheckedNormal
    } else {
    $style = [System.Windows.Forms.VisualStyles.CheckBoxState]::UncheckedNormal
    }
    #https://msdn.microsoft.com/en-us/library/system.windows.forms.checkboxrenderer%28v=vs.110%29.aspx 
    [System.Windows.Forms.CheckBoxRenderer]::DrawCheckBox($e.Graphics, (new-object System.Drawing.Point(($e.Bounds.Left + 4), ($e.Bounds.Top + 4))), $style )
    } else { 
    
    $e.DrawDefault = $true
    }
  })

$listview1.add_DrawItem({
  param([object] $sender, [System.Windows.Forms.DrawListViewItemEventArgs] $e)
    $e.DrawDefault = $true
  })


$listview1.add_DrawSubItem({
  param([object] $sender, [System.Windows.Forms.DrawListViewSubItemEventArgs] $e)
    $e.DrawDefault = $true
  })

# 
# columnHeader1
# 
$h1.Text = ""
$h1.Width = 33
# 
# columnHeader2
# 
$h2.Text = "Column1"
$h2.Width = 83
# 
# columnHeader3
# 
$h3.Text = "Column2"
$h3.Width = 103
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
