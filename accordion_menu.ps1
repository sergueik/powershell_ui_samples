#Copyright (c) 2014,2015 Serguei Kouzmine
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

param(
  [switch]$debug
)

# http://poshcode.org/2887
# http://stackoverflow.com/questions/8343767/how-to-get-the-current-directory-of-the-cmdlet-being-executed
# https://msdn.microsoft.com/en-us/library/system.management.automation.invocationinfo.pscommandpath%28v=vs.85%29.aspx
function Get-ScriptDirectory
{
  [string]$scriptDirectory = $null

  if ($host.Version.Major -gt 2) {
    $scriptDirectory = (Get-Variable PSScriptRoot).Value
    Write-Debug ('$PSScriptRoot: {0}' -f $scriptDirectory)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }
    $scriptDirectory = [System.IO.Path]::GetDirectoryName($MyInvocation.PSCommandPath)
    Write-Debug ('$MyInvocation.PSCommandPath: {0}' -f $scriptDirectory)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }

    $scriptDirectory = Split-Path -Parent $PSCommandPath
    Write-Debug ('$PSCommandPath: {0}' -f $scriptDirectory)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }
  } else {
    $scriptDirectory = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
    if ($scriptDirectory -ne $null) {
      return $scriptDirectory;
    }
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value
    if ($Invocation.PSScriptRoot) {
      $scriptDirectory = $Invocation.PSScriptRoot
    } elseif ($Invocation.MyCommand.Path) {
      $scriptDirectory = Split-Path $Invocation.MyCommand.Path
    } else {
      $scriptDirectory = $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf('\'))
    }
    return $scriptDirectory
  }
}


$global:button_panel_height = 25
$global:button_panel_width = 200
$global:up_arrow = New-Object System.Drawing.Bitmap ([System.IO.Path]::Combine((Get-ScriptDirectory),'up.png'))
$global:down_arrow = New-Object System.Drawing.Bitmap ([System.IO.Path]::Combine((Get-ScriptDirectory),'down.png'))

Add-Type -TypeDefinition @"

// "
using System;
using System.Windows.Forms;
public class Win32Window : IWin32Window
{
    private IntPtr _hWnd;
    private string _data;

    public String Data
    {
        get { return _data; }
        set { _data = value; }
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

function add_button_group {
  param(
    [System.Management.Automation.PSReference]$button_group_data_ref,
    [System.Management.Automation.PSReference]$button_group_ref,
    [System.Management.Automation.PSReference]$panel_ref # unused 
  )

  $button_group_data = $button_group_data_ref.Value
  $g = $button_group_ref.Value
  $g.BackColor = [System.Drawing.Color]::Gray
  $g.Dock = [System.Windows.Forms.DockStyle]::Top
  $g.FlatAppearance.BorderColor = [System.Drawing.Color]::Gray
  $g.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
  $g.ImageAlign = [System.Drawing.ContentAlignment]::MiddleRight
  $g.Location = New-Object System.Drawing.Point (0,0)
  $g.Name = $button_group_data['name']
  $g.Size = New-Object System.Drawing.Size ($global:button_panel_width,$global:button_panel_height)
  $g.TabIndex = 0
  $g.Text = $button_group_data['text']
  $g.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
  $g.UseVisualStyleBackColor = $false

  $g_click = $g.add_Click

  $local:click_handler = $g.add_Click
  if ($button_group_data.ContainsKey('callback')) {
    $local:click_handler.Invoke($button_group_data['callback'])
  }

  else {
    <# default click handler will not work.

    $local:click_handler.Invoke({
        param(
          [object]$sender,
          [System.EventArgs]$eventargs
        )


        $ref_panel = ($panel_ref)
        $ref_panel.Value
        $ref_button_menu_group = ($button_group_ref)
        #    $num_buttons = $button_group_data['buttons'] + 1
        $num_buttons = 3
        # use the current height of the element as indicator of its state.
        if ($ref_panel.Value.Height -eq $global:button_panel_height)
        {
          $ref_panel.Value.Height = ($global:button_panel_height * $num_buttons) + 2
          $ref_button_menu_group.Value.Image = $global:up_arrow
        }
        else
        {
          $ref_panel.Value.Height = $global:button_panel_height
          $ref_button_menu_group.Value.Image = $global:down_arrow
        }


      })
#>
  }
  $button_group_ref.Value = $g

}


function add_button {
  param(
    [System.Management.Automation.PSReference]$button_data_ref,
    [System.Management.Automation.PSReference]$button_ref
  )

  $button_data = $button_data_ref.Value

  #  TODO: assert ?

  $local:b = $button_ref.Value
  $local:b.BackColor = [System.Drawing.Color]::Silver
  $local:b.Dock = [System.Windows.Forms.DockStyle]::Top
  $local:b.FlatAppearance.BorderColor = [System.Drawing.Color]::DarkGray
  $local:b.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
  $local:b.Location = New-Object System.Drawing.Point (0,($global:button_panel_height * $button_data['cnt']))
  $local:b.Size = New-Object System.Drawing.Size ($global:button_panel_width,$global:button_panel_height)
  $local:b.TabIndex = 3
  $local:b.Name = $button_data['name']
  $local:b.Text = $button_data['text']
  $local:b.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
  $local:b.UseVisualStyleBackColor = $false

  $local:click_handler = $local:b.add_Click
  if ($button_data.ContainsKey('callback')) {
    $local:click_handler.Invoke($button_data['callback'])
  }

  else {
    # provide default click handler

    $local:click_handler.Invoke({

        param(
          [object]$sender,
          [System.EventArgs]$eventargs
        )
        $caller.Data = $sender.Text
        [System.Windows.Forms.MessageBox]::Show(('{0} default click handler!' -f $sender.Text))
      })

  }
  $button_ref.Value = $local:b
}



$caller = New-Object -TypeName 'Win32Window' -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)

@( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }

$f = New-Object -TypeName 'System.Windows.Forms.Form'
$f.Text = $title
$f.SuspendLayout()

$p = New-Object System.Windows.Forms.Panel
$m = New-Object System.Windows.Forms.Panel

$p3 = New-Object System.Windows.Forms.Panel
$g3 = New-Object System.Windows.Forms.Button
$b3_1 = New-Object System.Windows.Forms.Button
$b3_2 = New-Object System.Windows.Forms.Button
$b3_3 = New-Object System.Windows.Forms.Button

$p2 = New-Object System.Windows.Forms.Panel
$g2 = New-Object System.Windows.Forms.Button
$b2_1 = New-Object System.Windows.Forms.Button
$b2_2 = New-Object System.Windows.Forms.Button
$b2_3 = New-Object System.Windows.Forms.Button
$b2_4 = New-Object System.Windows.Forms.Button

$p1 = New-Object System.Windows.Forms.Panel
$g1 = New-Object System.Windows.Forms.Button
$b1_1 = New-Object System.Windows.Forms.Button
$b1_2 = New-Object System.Windows.Forms.Button

$l = New-Object System.Windows.Forms.Label
$m.SuspendLayout()
$p3.SuspendLayout()
$p2.SuspendLayout()
$p1.SuspendLayout()
$p.SuspendLayout()

#  
#  Menu Label
#  
$l.BackColor = [System.Drawing.Color]::DarkGray
$l.Dock = [System.Windows.Forms.DockStyle]::Top
$l.ForeColor = [System.Drawing.Color]::White
$l.Location = New-Object System.Drawing.Point (0,0)
$l.Name = 'l'
$l.Size = New-Object System.Drawing.Size (200,23)
$l.TabIndex = 0
$l.Text = 'Main Menu Label'
$l.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

#  Menu Panel
$m.Controls.AddRange(@( $p3,$p2,$p1))
$m.Controls.Add($l)
$m.Dock = [System.Windows.Forms.DockStyle]::Left
$m.Location = New-Object System.Drawing.Point (0,0)
$m.Name = 'm'
$m.Size = New-Object System.Drawing.Size ($global:button_panel_width,449)
$m.TabIndex = 1

#  Menu 3 Panel
$p3.Controls.AddRange(@( $b3_3,$b3_2,$b3_1,$g3))
$p3.Dock = [System.Windows.Forms.DockStyle]::Top
$p3.Location = New-Object System.Drawing.Point (0,231)
$p3.Name = 'p3'
$p3.TabIndex = 3


#  Menu 3 button 3
# Provide a callback with  System.Windows.Forms.Button.OnClick Method argument signature
[scriptblock]$b3_3_callback_ref = {
  param(
    [object]$sender,
    [System.EventArgs]$eventargs
  )
  $caller.Data = 'something'
  [System.Windows.Forms.MessageBox]::Show(('This is custom callback for {0} click!' -f $sender.Text))
}

add_button -button_ref ([ref]$b3_3) `
   -button_data_ref ([ref]@{
    'cnt' = 3;
    'text' = 'Menu 3 Sub Menu 3';
    'name' = 'b3_3';
    'callback' = $b3_3_callback_ref;
  })

#  Menu 3 button 2
add_button -button_ref ([ref]$b3_2) `
   -button_data_ref ([ref]@{
    'cnt' = 2;
    'text' = 'Menu 3 Sub Menu 2';
    'name' = 'b3_2'; })

#  Menu 3 button 1
add_button -button_ref ([ref]$b3_1) `
   -button_data_ref ([ref]@{
    'cnt' = 1;
    'text' = 'Menu 3 Sub Menu 1';
    'name' = 'b3_1';
  })

# Menu 3 button group
$global:g3_buttons = 3
$g3.Image = $global:down_arrow

[scriptblock]$g3_callback_ref = {
  param(
    [object]$sender,
    [System.EventArgs]$eventargs
  )

  $ref_panel = ([ref]$p3)
  $ref_button_menu_group = ([ref]$g3)
  $num_buttons = $global:g3_buttons + 1
  # use the current height of the element as indicator of its state.
  if ($ref_panel.Value.Height -eq $global:button_panel_height)
  {
    $ref_panel.Value.Height = ($global:button_panel_height * $num_buttons) + 2
    $ref_button_menu_group.Value.Image = $global:up_arrow
  }
  else
  {
    $ref_panel.Value.Height = $global:button_panel_height
    $ref_button_menu_group.Value.Image = $global:down_arrow
  }
}

add_button_group -button_group_ref ([ref]$g3) `
   -panel_ref ([ref]$p3) `
   -button_group_data_ref ([ref]@{
    'buttons' = 3;
    'text' = 'Menu Group 3';
    'name' = 'g3';
    'callback' = $g3_callback_ref;
  })


# Menu 2 Panel
$p2.Controls.AddRange(@( $b2_4,$b2_3,$b2_2,$b2_1,$g2))
$p2.Dock = [System.Windows.Forms.DockStyle]::Top
$p2.Location = New-Object System.Drawing.Point (0,127)
$p2.Name = 'p2'
$p2.TabIndex = 2

# Menu 2 button 4
add_button -button_ref ([ref]$b2_4) `
   -button_data_ref ([ref]@{
    'cnt' = 4;
    'text' = 'Menu 2 Sub Menu 4';
    'name' = 'b2_4';
  })

# Menu 2 button 3
add_button -button_ref ([ref]$b2_3) `
   -button_data_ref ([ref]@{
    'cnt' = 3;
    'text' = 'Menu 2 Sub Menu 3';
    'name' = 'b2_3';
  })


# Menu 2 button 2
add_button -button_ref ([ref]$b2_2) `
   -button_data_ref ([ref]@{
    'cnt' = 2;
    'text' = 'Menu 2 Sub Menu 2';
    'name' = 'b2_2';
  })

# Menu 2 button 1
add_button -button_ref ([ref]$b2_1) `
   -button_data_ref ([ref]@{
    'cnt' = 1;
    'text' = 'Menu 2 Sub Menu 1';
    'name' = 'b2_1';
  })


# Menu 2 button group
$global:g2_buttons = 4
$g2.Image = $global:down_arrow

[scriptblock]$g2_callback_ref = {
  param(
    [object]$sender,
    [System.EventArgs]$eventargs
  )

  $ref_panel = ([ref]$p2)
  $ref_button_menu_group = ([ref]$g2)
  $num_buttons = $global:g2_buttons + 1
  # use the current height of the element as indicator of its state.
  if ($ref_panel.Value.Height -eq $global:button_panel_height)
  {
    $ref_panel.Value.Height = ($global:button_panel_height * $num_buttons) + 2
    $ref_button_menu_group.Value.Image = $global:up_arrow
  }
  else
  {
    $ref_panel.Value.Height = $global:button_panel_height
    $ref_button_menu_group.Value.Image = $global:down_arrow
  }
}

add_button_group -button_group_ref ([ref]$g2) `
   -panel_ref ([ref]$p2) `
   -button_group_data_ref ([ref]@{
    'buttons' = $global:g2_buttons;
    'text' = 'Menu Group 2';
    'name' = 'g_2';
    'callback' = $g2_callback_ref;
  })

#  Panel Menu 1
$p1.Controls.AddRange(@( $b1_2,$b1_1,$g1))
$p1.Dock = [System.Windows.Forms.DockStyle]::Top
$p1.Location = New-Object System.Drawing.Point (0,23)
$p1.Name = 'p1'
$p1.TabIndex = 1

# Menu 1 button 1


add_button -button_ref ([ref]$b1_1) `
   -button_data_ref ([ref]@{
    'cnt' = 1;
    'text' = 'Menu 1 Sub Menu 1';
    'name' = 'b1_1';
  })

#  Menu 1 button 2
add_button  -button_ref ([ref]$b1_2)`
   -button_data_ref ([ref]@{ 
    'cnt' = 2; 
    'text' = 'Menu 1 Sub Menu 2'; 
    'name' = 'b1_2'; 
  })

#  Menu 1 button group 
$global:g1_buttons = 2
$g1.Image = $global:down_arrow

[scriptblock]$g1_callback_ref = {
  param(
    [object]$sender,
    [System.EventArgs]$eventargs
  )

  $ref_panel = ([ref]$p1)
  $ref_button_menu_group = ([ref]$g1)
  $num_buttons = $global:g1_buttons + 1
  # use the current height of the element as indicator of its state.
  if ($ref_panel.Value.Height -eq $global:button_panel_height)
  {
    $ref_panel.Value.Height = ($global:button_panel_height * $num_buttons) + 2
    $ref_button_menu_group.Value.Image = $global:up_arrow
  }
  else
  {
    $ref_panel.Value.Height = $global:button_panel_height
    $ref_button_menu_group.Value.Image = $global:down_arrow
  }
}

add_button_group -button_group_ref ([ref]$g1) `
   -panel_ref ([ref]$p1) `
   -button_group_data_ref ([ref]@{
    'buttons' = $global:g1_buttons;
    'text' = 'Menu Group 1';
    'name' = 'g1';
    'callback' = $g1_callback_ref;
  })




$p.ClientSize = New-Object System.Drawing.Size (200,449)
$p.Controls.Add($m)
$p1.Height = $global:button_panel_height
$p2.Height = $global:button_panel_height
$p3.Height = $global:button_panel_height

$m.ResumeLayout($false)
$p3.ResumeLayout($false)
$p2.ResumeLayout($false)
$p1.ResumeLayout($false)
$p.ResumeLayout($false)


$f.Controls.Add($p)
#  Form1
$f.AutoScaleDimensions = New-Object System.Drawing.SizeF (6.0,13.0)
$f.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font
$f.ClientSize = New-Object System.Drawing.Size (201,280)
$f.Controls.Add($c1)
$f.Controls.Add($p)
$f.Controls.Add($b1)
$f.Name = 'Form1'
$f.Text = 'Accordion Menu'
$f.ResumeLayout($false)

$f.Topmost = $True

$f.Add_Shown({ $f.Activate() })

[void]$f.ShowDialog([win32window]($caller))

$f.Dispose()

Write-Output $caller.Data
