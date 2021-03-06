#Copyright (c) 2015 Serguei Kouzmine
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


# http://www.codeproject.com/Articles/12538/Y-et-A-nother-TabControl-A-Custom-Tab-Control-With


# $caller = New-Object -TypeName 'Win32Window' -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)

@( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }


$shared_assemblies = @(
  'nunit.framework.dll'
)

$shared_assemblies_path = 'c:\developer\sergueik\csharp\SharedAssemblies'

if (($env:SHARED_ASSEMBLIES_PATH -ne $null) -and ($env:SHARED_ASSEMBLIES_PATH -ne '')) {
  $shared_assemblies_path = $env:SHARED_ASSEMBLIES_PATH
}

pushd $shared_assemblies_path

$shared_assemblies | ForEach-Object {

  if ($host.Version.Major -gt 2) {
    Unblock-File -Path $_;
  }
  Write-Debug $_
  Add-Type -Path $_
}
popd


$extra_assemblies = @(
'GrayIris.Utilities.dll'
)

$extra_assemblies_path  = 'c:\developer\sergueik\csharp\yet-another-tab-control-master\bin\Debug'

if (($env:EXTRA_ASSEMBLIES_PATH -ne $null) -and ($env:EXTRA_ASSEMBLIES_PATH -ne '')) {
   $extra_assemblies_path = $env:extra_ASSEMBLIES_PATH
}

pushd $extra_assemblies_path

$extra_assemblies | ForEach-Object {

  if ($host.Version.Major -gt 2) {
    Unblock-File -Path $_;
  }
  Write-Debug $_
  Add-Type -Path $_
}
popd

$f = New-Object -TypeName 'System.Windows.Forms.Form'
$f.Text = $title
$f.SuspendLayout()
$o = new-object -typeName 'GrayIris.Utilities.UI.Controls.YaTabControl'
# $o | get-member
$o.ClientSize = New-Object System.Drawing.Size (610,440)
# $o.XmlFile = 'C:\developer\sergueik\powershell_ui_samples\external\powershell_script_triggered_by_event.xml'

#  Form1
$f.AutoScaleDimensions = New-Object System.Drawing.SizeF (6.0,13.0)
$f.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font
$f.ClientSize = New-Object System.Drawing.Size (610,440)
$f.Controls.Add($o)
$f.Name = "Form1"
$f.Text = "XmlTreeView"
$f.ResumeLayout($false)

$f.Topmost = $True


#            $f.components = new-object System.ComponentModel.Container
#            System.Windows.Forms.ToolStripMenuItem tabDrawerToolStripMenuItem;
#            System.ComponentModel.ComponentResourceManager resources = new-object System.ComponentModel.ComponentResourceManager(typeof(YatcForm))
#            System.Windows.Forms.ToolStripMenuItem dockStyleToolStripMenuItem;
#            System.Windows.Forms.ToolStripMenuItem tabLocationToolStripMenuItem;
#            System.Windows.Forms.ToolStripMenuItem preventToolStripMenuItem;
            $_otd = new-object GrayIris.Utilities.UI.Controls.OvalTabDrawer
            $_vtd = new-object GrayIris.Utilities.UI.Controls.VsTabDrawer
            $menu = new-object System.Windows.Forms.MenuStrip
            $draw_ovals = new-object System.Windows.Forms.ToolStripMenuItem
            $draw_vstudioio = new-object System.Windows.Forms.ToolStripMenuItem
            $draw_excel = new-object System.Windows.Forms.ToolStripMenuItem
            $_tabs = new-object GrayIris.Utilities.UI.Controls.YaTabControl
            $_xlTabDrawer = new-object GrayIris.Utilities.UI.Controls.XlTabDrawer
            $_tabpage1 = new-object GrayIris.Utilities.UI.Controls.YaTabPage
            $_tabpage2 = new-object GrayIris.Utilities.UI.Controls.YaTabPage
            $_tabpage3 = new-object GrayIris.Utilities.UI.Controls.YaTabPage
            # $_images = new-object System.Windows.Forms.ImageList($fcomponents)
            $_dockNone = new-object System.Windows.Forms.ToolStripMenuItem
            $toolStripSeparator1 = new-object System.Windows.Forms.ToolStripSeparator
            $_dockFill = new-object System.Windows.Forms.ToolStripMenuItem
            $dockLeft = new-object System.Windows.Forms.ToolStripMenuItem
            $dockTop = new-object System.Windows.Forms.ToolStripMenuItem
            $dockRight = new-object System.Windows.Forms.ToolStripMenuItem
            $dockBottom = new-object System.Windows.Forms.ToolStripMenuItem
            $dockTabsTop = new-object System.Windows.Forms.ToolStripMenuItem
            $dockTabsRight = new-object System.Windows.Forms.ToolStripMenuItem
            $dockTabsBottom = new-object System.Windows.Forms.ToolStripMenuItem
            $dockTabsLeft = new-object System.Windows.Forms.ToolStripMenuItem
            $preventSelection = new-object System.Windows.Forms.ToolStripMenuItem
            $tabDrawerToolStripMenuItem = new-object System.Windows.Forms.ToolStripMenuItem
            $dockStyleToolStripMenuItem = new-object System.Windows.Forms.ToolStripMenuItem
            $tabLocationToolStripMenuItem = new-object System.Windows.Forms.ToolStripMenuItem
            $preventToolStripMenuItem = new-object System.Windows.Forms.ToolStripMenuItem
            $menu.SuspendLayout()
            $_tabs.SuspendLayout()
            $f.SuspendLayout()
            
            # _menu
            
            $menu.Items.AddRange(@(
            $tabDrawerToolStripMenuItem,
            $dockStyleToolStripMenuItem,
            $tabLocationToolStripMenuItem,
            $preventToolStripMenuItem))
            $menu.Location = new-object System.Drawing.Point(0, 0)
            $menu.Name = "_menu"
            $menu.Size = new-object System.Drawing.Size(838, 24)
            $menu.TabIndex = 1
            $menu.Text = "menuStrip1"
            
            # tabDrawerToolStripMenuItem
            $tabDrawerToolStripMenuItem.DropDownItems.AddRange(@(
            $draw_excel,
            $draw_ovals,
            $draw_vstudioio))
            $tabDrawerToolStripMenuItem.Name = "tabDrawerToolStripMenuItem"
            $tabDrawerToolStripMenuItem.Size = new-object System.Drawing.Size(79, 20)
            $tabDrawerToolStripMenuItem.Text = "Tab Drawer"
             
            # _drawOvals            
            $draw_ovals.Name = "_drawOvals"
            $draw_ovals.Size = new-object System.Drawing.Size(152, 22)
            $draw_ovals.Text = "Ovals"
            # $draw_ovals.Click += new System.EventHandler($fChangeToOvals)
             
            # _drawVisualStudio
            $draw_vstudioio.Name = "_drawVisualStudio"
            $draw_vstudioio.Size = new-object System.Drawing.Size(152, 22)
            $draw_vstudioio.Text = "Visual Studio"
            # $draw_vstudioio.Click += new System.EventHandler($fChangeToVisualStudio)
 
            # _drawExcel
            $draw_excel.Checked = $true
            $draw_excel.CheckState = [System.Windows.Forms.CheckState]::Checked
            $draw_excel.Name = "_drawExcel"
            $draw_excel.Size = new-object System.Drawing.Size(152, 22)
            $draw_excel.Text = "Excel"
            # $draw_excel.Click += new System.EventHandler($fChangeToExcel)
             
            # _tabs
            
            $_tabs.ActiveColor = [System.Drawing.SystemColors]::Control
            $_tabs.BackColor = [System.Drawing.SystemColors]::Control
            # $_tabs.BorderColor = System.Drawing.Color.FromArgb(((int)(((byte)(169)))), ((int)(((byte)(169)))), ((int)(((byte)(169)))))
            $_tabs.Controls.Add($_tabpage1)
            $_tabs.Controls.Add($_tabpage2)
            $_tabs.Controls.Add($_tabpage3)
            $_tabs.ImageIndex = 0
            $_tabs.ImageList = $_images
            $_tabs.InactiveColor = [System.Drawing.SystemColors]::Window
            $_tabs.Location = new-object System.Drawing.Point(224, 107)
            $_tabs.Name = "_tabs"
            $_tabs.ScrollButtonStyle = [GrayIris.Utilities.UI.Controls.YaScrollButtonStyle]::Always
            $_tabs.SelectedIndex = 0
            $_tabs.SelectedTab = $_tabpage1
            $_tabs.Size = new-object System.Drawing.Size(390, 300)
            $_tabs.TabDock = [System.Windows.Forms.DockStyle]::Top
            $_tabs.TabDrawer = $_xlTabDrawer
            $_tabs.TabFont = new-object System.Drawing.Font("Microsoft Sans Serif", 8.25, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([byte](0)))
            $_tabs.TabIndex = 2
            # _tabpage1
            $_tabpage1.Dock = [System.Windows.Forms.DockStyle]::Fill
            $_tabpage1.ImageIndex = -1
            $_tabpage1.Location = new-object System.Drawing.Point(4, 30)
            $_tabpage1.Name = "_tabpage1"
            $_tabpage1.Size = new-object System.Drawing.Size(382, 266)
            $_tabpage1.TabIndex = 0
            $_tabpage1.Text = "First Tab"
            # _tabpage2
            $_tabpage2.Dock = [System.Windows.Forms.DockStyle]::Fill
            $_tabpage2.ImageIndex = 1
            $_tabpage2.Location = new-object System.Drawing.Point(4, 30)
            $_tabpage2.Name = "_tabpage2"
            $_tabpage2.Size = new-object System.Drawing.Size(292, 266)
            $_tabpage2.TabIndex = 1
            $_tabpage2.Text = "Second Tab"
            # _tabpage3
            $_tabpage3.Dock = [System.Windows.Forms.DockStyle]::Fill
            $_tabpage3.ImageIndex = 2;
            $_tabpage3.Location = new-object System.Drawing.Point(4, 30)
            $_tabpage3.Name = "_tabpage3"
            $_tabpage3.Size = new-object System.Drawing.Size(292, 266)
            $_tabpage3.TabIndex = 2;
            $_tabpage3.Text = "Third Tab"
            # _images
            # $_images.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("_images.ImageStream")))
            # $_images.TransparentColor = System.Drawing.Color.Transparent;
            # $_images.Images.SetKeyName(0, "fork.png")
            # $_images.Images.SetKeyName(1, "online_support.png")
            # $_images.Images.SetKeyName(2, "weather.png")
            # dockStyleToolStripMenuItem
            $dockStyleToolStripMenuItem.DropDownItems.AddRange(@(
            $_dockNone,
            $toolStripSeparator1,
            $_dockFill,
            $dockLeft,
            $dockTop,
            $dockRight,
            $dockBottom))
            $dockStyleToolStripMenuItem.Name = "dockStyleToolStripMenuItem"
            $dockStyleToolStripMenuItem.Size = new-object System.Drawing.Size(74, 20)
            $dockStyleToolStripMenuItem.Text = "Dock Style"
            # _dockNone
            $_dockNone.Checked = $true
            $_dockNone.CheckState = [System.Windows.Forms.CheckState]::Checked
            $_dockNone.Name = "_dockNone"
            $_dockNone.Size = new-object System.Drawing.Size(152, 22)
            $_dockNone.Text = "None"
            # $_dockNone.Click += new System.EventHandler($fChangeDockState)
            # toolStripSeparator1
            $toolStripSeparator1.Name = "toolStripSeparator1"
            $toolStripSeparator1.Size = new-object System.Drawing.Size(149, 6)
            # _dockFill
            # 
            $_dockFill.Name = "_dockFill"
            $_dockFill.Size = new-object System.Drawing.Size(152, 22)
            $_dockFill.Text = "Fill"
            # $_dockFill.Click += new System.EventHandler($fChangeDockState)
            # 
            # _dockLeft
            # 
            $dockLeft.Name = "_dockLeft"
            $dockLeft.Size = new-object System.Drawing.Size(152, 22)
            $dockLeft.Text = "Left"
            # $dockLeft.Click += new System.EventHandler($fChangeDockState)
            # 
            # _dockTop
            # 
            $dockTop.Name = "_dockTop"
            $dockTop.Size = new-object System.Drawing.Size(152, 22)
            $dockTop.Text = "Top"
            # $dockTop.Click += new System.EventHandler($fChangeDockState)
            # 
            # _dockRight
            # 
            $dockRight.Name = "_dockRight"
            $dockRight.Size = new-object System.Drawing.Size(152, 22)
            $dockRight.Text = "Right"
            # $dockRight.Click += new System.EventHandler($fChangeDockState)
            # 
            # _dockBottom
            # 
            $dockBottom.Name = "_dockBottom"
            $dockBottom.Size = new-object System.Drawing.Size(152, 22)
            $dockBottom.Text = "Bottom"
            # $dockBottom.Click += new System.EventHandler($fChangeDockState)
            # 
            # tabLocationToolStripMenuItem
            # 
            $tabLocationToolStripMenuItem.DropDownItems.AddRange(@(
            $dockTabsTop,
            $dockTabsRight,
            $dockTabsBottom,
            $dockTabsLeft))
            $tabLocationToolStripMenuItem.Name = "tabLocationToolStripMenuItem"
            $tabLocationToolStripMenuItem.Size = new-object System.Drawing.Size(88, 20)
            $tabLocationToolStripMenuItem.Text = "Tab Location"
            # 
            # _dockTabsTop
            # 
            $dockTabsTop.Checked = $true
            $dockTabsTop.CheckState = [System.Windows.Forms.CheckState]::Checked
            $dockTabsTop.Name = "_dockTabsTop"
            $dockTabsTop.Size = new-object System.Drawing.Size(152, 22)
            $dockTabsTop.Text = "Top"
            #$dockTabsTop.Click += new System.EventHandler($fChangeTabLocation)
            # 
            # _dockTabsRight
            # 
            $dockTabsRight.Name = "_dockTabsRight"
            $dockTabsRight.Size = new-object System.Drawing.Size(152, 22)
            $dockTabsRight.Text = "Right"
            #$dockTabsRight.Click += new System.EventHandler($fChangeTabLocation)
            # 
            # _dockTabsBottom
            # 
            $dockTabsBottom.Name = "_dockTabsBottom"
            $dockTabsBottom.Size = new-object System.Drawing.Size(152, 22)
            $dockTabsBottom.Text = "Bottom"
            # $dockTabsBottom.Click += new System.EventHandler($fChangeTabLocation)
            # 
            # _dockTabsLeft
            # 
            $dockTabsLeft.Name = "_dockTabsLeft"
            $dockTabsLeft.Size = new-object System.Drawing.Size(152, 22)
            $dockTabsLeft.Text = "Left"
            # $dockTabsLeft.Click += new System.EventHandler($fChangeTabLocation)
            # 
            # preventToolStripMenuItem
            # 
            $preventToolStripMenuItem.DropDownItems.AddRange(@(
            $preventSelection))
            $preventToolStripMenuItem.Name = "preventToolStripMenuItem"
            $preventToolStripMenuItem.Size = new-object System.Drawing.Size(59, 20)
            $preventToolStripMenuItem.Text = "Prevent"
            # 
            # _preventSelection
            # 
            $preventSelection.Name = "_preventSelection"
            $preventSelection.Size = new-object System.Drawing.Size(197, 22)
            $preventSelection.Text = "Selecting `"Second Tab`""
            # $preventSelection.Click += new System.EventHandler($fChangeSelectingCapability)
            # 
            # YatcForm
            # 
            $f.AutoScaleDimensions = new-object System.Drawing.SizeF(6.0, 13.0)
            $f.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font
            $f.ClientSize = new-object System.Drawing.Size(838, 515)
            $f.Controls.Add($_tabs)
            $f.Controls.Add($menu)
            $f.MainMenuStrip = $menu
            $f.MaximizeBox = $false
            $f.MinimizeBox = $false
            $f.Name = "YatcForm"
            $f.ShowIcon = $false
            $f.Text = "Yet Another Tab Control Example Form"
            $menu.ResumeLayout($false)
            $menu.PerformLayout()
            $_tabs.ResumeLayout($false)
            $f.ResumeLayout($false)
            $f.PerformLayout()

$f.Add_Shown({ $f.Activate() })

[void]$f.ShowDialog()#[win32window]($caller))

$f.Dispose()

