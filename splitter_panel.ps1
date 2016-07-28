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

# http://www.java2s.com/Code/CSharp/GUI-Windows-Form/TwoPanelswithSplitter.htm

function promptWithPanels (
  [string]$title,
  [object]$caller
) {

  @( 'System.Drawing','System.Collections','System.ComponentModel','System.Windows.Forms','System.Data') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }
  $f = New-Object System.Windows.Forms.Form

  # $label_hint1.Font = New-Object System.Drawing.Font('Microsoft Sans Serif',8,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0);

  $f.Text = $title

  $panel1 = New-Object System.Windows.Forms.Panel
  $panel1.Parent = $f;
  $panel1.Size = New-Object System.Drawing.Size (408,317)

  $panel1.Dock = [System.Windows.Forms.DockStyle]::Fill
  $panel1.SuspendLayout()
  $panel1_Resize = {
    param(
      [object]$sender,
      [System.EventArgs]$eventargs
    )

    [System.Windows.Forms.Panel]$panel = $sender
    $panel.Invalidate()
  }
  $panel1.add_Resize($panel1_Resize)

  $panel1.BackColor = [System.Drawing.Color]::LightGray

  $g = [System.Drawing.Graphics]::FromHwnd($panel1.Handle)
  $rc = New-Object System.Drawing.Rectangle ($panel1.Left,$panel1.Top,($panel1.Width - 1),($panel1.Height - 1))
  $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::Lime)
  $g.FillRectangle($brush,$rc)
  $textbox1 = New-Object System.Windows.Forms.TextBox
  $textbox1.Location = New-Object System.Drawing.Point (12,7)
  $textbox1.Name = "textBoxMessage"
  $textbox1.Size = New-Object System.Drawing.Size (200,20)
  $textbox1.TabIndex = 0
  $textbox1.Text = 'name of the resource'

  $label_hint1 = New-Object System.Windows.Forms.Label
  $label_hint1.Location = New-Object System.Drawing.Size (12,32)
  $label_hint1.Size = New-Object System.Drawing.Size (100,16)
  $label_hint1.Text = ''

  $textbox1.Add_Leave({
      param(
        [object]$sender,
        [System.EventArgs]$eventargs
      )
      if ($sender.Text.Length -eq 0) {
        $label_hint1.Text = 'Input required'
        # [System.Windows.Forms.MessageBox]::Show('Input required') 
        $sender.Select()
        $result = $sender.Focus()
      } else {
        $label_hint1.Text = ''
      }
    })

  $list_box2 = New-Object System.Windows.Forms.ListBox

  $list_box2.FormattingEnabled = $true
  $list_box2.Location = New-Object System.Drawing.Point (142,57);
  $list_box2.Name = 'attributes';
  $list_box2.Size = New-Object System.Drawing.Size (120,218);
  $list_box2.TabIndex = 1;

  $list_box1 = New-Object System.Windows.Forms.ListBox

  $list_box1.FormattingEnabled = $true
  $list_box1.Location = New-Object System.Drawing.Point (12,57);
  $list_box1.Name = 'resources';
  $list_box1.Size = New-Object System.Drawing.Size (120,218);
  $list_box1.TabIndex = 1;

  $data = @{
    'package' = @( 'attribute1','attribute2','attribute3','attribute4');
    'process' = @( 'running');
    'service' = @( 'running','enabled','attribute3');
    'file' = @( 'running','enabled','attribute3');
  }
  $list_box1_SelectedIndexChanged = {
    param(
      [object]$sender,
      [System.EventArgs]$eventargs
    )

    [System.Windows.Forms.ListBox]$list_box1 = $sender
    # write-host $list_box1.SelectedItem
    $textbox1.Text = ''
    # the next is reached for single or multi select, also for list_box2
    if ($list_box1.SelectedItems.Count -ne 0) {

      $selectedItem = $list_box1.SelectedItems[0]
      $textbox1.Text = ''
      $list_box2.Items.Clear()
      try {
        $list_box2.Items.AddRange($data[$list_box1.SelectedItem]);
      } catch [exception]
      {
        # ignore 
      }
    }
  }
  $list_box1.Items.AddRange(@( 'package','service','port','directory','file','command','process'));
  $list_box1.add_SelectedIndexChanged($list_box1_SelectedIndexChanged)

  $panel1.Controls.AddRange(@( $list_box1,$label_hint1,$textbox1,$list_box2))
  $button1 = New-Object System.Windows.Forms.Button
  $components = New-Object System.ComponentModel.Container

  $button1.Location = New-Object System.Drawing.Point (8,280)
  $button1.Name = 'button1'
  $button1.Size = New-Object System.Drawing.Size (112,32)
  $button1.TabIndex = 4
  $button1.Text = 'Generate'

  $button1.Add_Click({
      $textbox2.Text = $textbox1.Text + " " + $list_box1.SelectedItem + " " + $list_box2.SelectedItem 
    })

  $panel1.Controls.Add($button1)
  $splitter = New-Object System.Windows.Forms.Splitter
  $splitter.Parent = $f
  $splitter.Dock = [System.Windows.Forms.DockStyle]::Right


  $panel2 = New-Object System.Windows.Forms.Panel
  $panel2.Parent = $f
  $panel2.Size = New-Object System.Drawing.Size (408,317)
  $panel2.Dock = [System.Windows.Forms.DockStyle]::Right
  $panel2.BackColor = [System.Drawing.Color]::Red

  $panel2_Resize = {
    param(
      [object]$sender,
      [System.EventArgs]$eventargs
    )
    # $caller.Data = $textbox1.Text
    [System.Windows.Forms.Panel]$panel = $sender
    $panel.Invalidate()
  }
  $panel2.add_Resize($panel2_Resize)
  $panel2.SuspendLayout()

  $textbox2 = New-Object System.Windows.Forms.TextBox
  $textbox2.Location = New-Object System.Drawing.Point (0,0)
  $textbox2.Size = New-Object System.Drawing.Size (408,317)
  $textbox2.Text = 'this is where the generated ...'
  $textbox2.Name = 'txtUser'

  $textbox2.Parent = $panel2;

  $textbox2.Dock = [System.Windows.Forms.DockStyle]::Fill
  $textbox2.BorderStyle = [System.Windows.Forms.BorderStyle]::None
  $textbox2.Multiline = $true
  $textbox2.ScrollBars = [System.Windows.Forms.ScrollBars]::Both
  $textbox2.AcceptsTab = $true
  # http://www.java2s.com/Code/CSharp/GUI-Windows-Form/RichTextBoxFontbolditalic.htm
  $f.SuspendLayout()
  $f.AutoScaleBaseSize = New-Object System.Drawing.Size (5,13)
  $f.ClientSize = New-Object System.Drawing.Size (808,317)
  # Order matters
  $f.Controls.AddRange(@( $panel1,$splitter,$panel2))
  $panel1.ResumeLayout($false)
  $panel1.PerformLayout()
  $panel2.ResumeLayout($false)
  $panel2.PerformLayout()
  $f.ResumeLayout($false)

  $f.Topmost = $true
  $f.Add_Shown({ $f.Activate() })
  $f.KeyPreview = $True
  [void]$f.ShowDialog([win32window]($caller))

  $f.Dispose()
}

Add-Type -TypeDefinition @"
using System;
using System.Windows.Forms;
public class Win32Window : IWin32Window {
	private IntPtr _hWnd;
	private string _data;

	public string Data {
		get { return _data; }
		set { _data = value; }
	}


	public Win32Window(IntPtr handle) {
		_hWnd = handle;
	}

	public IntPtr Handle {
		get { return _hWnd; }
	}
}

"@ -ReferencedAssemblies 'System.Windows.Forms.dll'


$DebugPreference = 'Continue'
$title = 'Splitter Panels Demo'
$caller = New-Object Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)
promptWithPanels -caller $caller -Title $title
#if ($caller.Data -ne $RESULT_CANCEL) {
#  Write-Debug ("Result is : {0} / {1}  " -f $caller.txtUser,$caller.txtPassword)
#}
