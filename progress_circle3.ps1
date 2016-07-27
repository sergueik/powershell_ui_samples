#Copyright (c) 2014 Serguei Kouzmine
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

# $DebugPreference = 'Continue'

param(
  [switch]$pause
)

#  http://www.codeproject.com/Articles/25575/ProgressCircle-An-Alternative-to-ProgressBar
Add-Type -TypeDefinition @"

/////////////////////////////////////////////////////////////////////////////
// ProgressCircle.cs - progress control
//
// Written by Sergio A. B. Petrovcic (sergio_petrovcic@hotmail.com)
// Copyright (c) 2008 Sergio A. B. Petrovcic.
//
// This code may be used in compiled form in any way you desire. This
// file may be redistributed by any means PROVIDING it is
// not sold for profit without the authors written consent, and
// providing that this notice and the authors name is included.
//
// This file is provided "as is" with no expressed or implied warranty.
// The author accepts no liability if it causes any damage to you or your
// computer whatsoever.
//
// If you find bugs, have suggestions for improvements, etc.,
// please contact the author.
//
// History (Date/Author/Description):
// ----------------------------------
//
// 2008/04/23: Sergio A. B. Petrovcic
// - Original implementation

using System;
using System.Collections.Generic;

using System.Data;
using System.Diagnostics;

using System.Drawing;
using System.Drawing.Drawing2D;
using System.Reflection;
using System.Text;
using System.Windows.Forms;

namespace ProgressCircle
{
public partial class ProgressCircle : UserControl
{
public delegate void EventHandler (object sender, string message);
public event EventHandler m_EventIncremented;

public event EventHandler PCIncremented
{
    add { m_EventIncremented += new EventHandler (value); }
    remove { m_EventIncremented -= new EventHandler (value); }
}
public event EventHandler m_EventCompleted;
public event EventHandler PCCompleted
{
    add { m_EventCompleted += new EventHandler (value); }
    remove { m_EventCompleted -= new EventHandler (value); }
}

private LinearGradientMode m_eLinearGradientMode = LinearGradientMode.Vertical;
public LinearGradientMode PCLinearGradientMode
{
    get { return m_eLinearGradientMode; }
    set { m_eLinearGradientMode = value; }
}
private Color m_oColor1RemainingTime = Color.Navy;
public Color PCRemainingTimeColor1
{
    get { return m_oColor1RemainingTime; }
    set { m_oColor1RemainingTime = value; }
}
private Color m_oColor2RemainingTime = Color.LightSlateGray;
public Color PCRemainingTimeColor2
{
    get { return m_oColor2RemainingTime; }
    set { m_oColor2RemainingTime = value; }
}
private Color m_oColor1ElapsedTime = Color.IndianRed;
public Color PCElapsedTimeColor1
{
    get { return m_oColor1ElapsedTime; }
    set { m_oColor1ElapsedTime = value; }
}
private Color m_oColor2ElapsedTime = Color.Gainsboro;
public Color PCElapsedTimeColor2
{
    get { return m_oColor2ElapsedTime; }
    set { m_oColor2ElapsedTime = value; }
}
private int m_iTotalTime = 100;
public int PCTotalTime
{
    get { return m_iTotalTime; }
    set { m_iTotalTime = value; }
}
private int m_iElapsedTime = 0;
public int PCElapsedTime
{
    get { return m_iElapsedTime; }
    set { m_iElapsedTime = value; }
}

public ProgressCircle()
{
    InitializeComponent ();
}

public void Increment (int a_iValue)
{
    if (m_iElapsedTime > m_iTotalTime)
        return;

    if (m_iElapsedTime + a_iValue >= m_iTotalTime) {
        m_iElapsedTime = m_iTotalTime;
        this.Refresh ();
        if (m_EventIncremented != null)
            m_EventIncremented (this, null);
        if (m_EventCompleted != null)
            m_EventCompleted (this, null);
    }
    else{
        m_iElapsedTime += a_iValue;
        this.Refresh ();
        if (m_EventIncremented != null)
            m_EventIncremented (this, null);
    }
}
private void ProgressCircle_Paint (object sender, PaintEventArgs e)
{
    Rectangle t_oRectangle = new Rectangle (0, 0, this.Width, this.Height);
    Brush t_oBrushRemainingTime = new LinearGradientBrush (t_oRectangle, m_oColor1RemainingTime, m_oColor2RemainingTime, m_eLinearGradientMode);
    Brush t_oBrushElapsedTime = new LinearGradientBrush (t_oRectangle, m_oColor1ElapsedTime, m_oColor2ElapsedTime, m_eLinearGradientMode);

    e.Graphics.FillEllipse (t_oBrushRemainingTime, t_oRectangle);
    e.Graphics.FillPie (t_oBrushElapsedTime, t_oRectangle, -90f, (float)(360 * m_iElapsedTime / m_iTotalTime));
}

private void InitializeComponent ()
{
    this.SuspendLayout ();

    this.AutoScaleDimensions = new System.Drawing.SizeF (6F, 13F);
    this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
    this.Name = "LmaProgressBar";
    this.Size = new System.Drawing.Size (104, 89);
    this.Paint += new System.Windows.Forms.PaintEventHandler (this.ProgressCircle_Paint);
    this.ResumeLayout (false);
}
}
}

"@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Drawing.dll','System.Data.dll'



# http://poshcode.org/5520
# http://stackoverflow.com/questions/14401704/update-winforms-not-wpf-ui-from-another-thread

$total_steps = 25

# VisualStyles are only needed for a very few Windows Forms controls like ProgessBar
@( 'System.Drawing','System.Windows.Forms', 'System.Windows.Forms.VisualStyles') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }

$f = New-Object System.Windows.Forms.Form
$l1 = New-Object System.Windows.Forms.Label
$is= New-Object System.Windows.Forms.FormWindowState
$f.Text = 'Demo Progress Form'
$f.Name = 'Form'
$f.DataBindings.DefaultDataSourceUpdateMode = 0
$f.ClientSize = New-Object System.Drawing.Size (216,121)
# Label 
$l1.Name = 'progress_label'
$l1.Font = New-Object System.Drawing.Font ('Microsoft Sans Serif',10.25,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,[System.Byte]0)
$l1.Location = New-Object System.Drawing.Point (70,34)
$l1.Size = New-Object System.Drawing.Size (140,23)
$l1.Text = 'Start'

#  progressCircle1
$c1 = New-Object -TypeName 'ProgressCircle.ProgressCircle'
$c1.Location = New-Object System.Drawing.Point (20,20)
$c1.Name = "progress_circle"
$c1.PCElapsedTimeColor1 = [System.Drawing.Color]::Chartreuse
$c1.PCElapsedTimeColor2 = [System.Drawing.Color]::Yellow
$c1.PCLinearGradientMode = [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
$c1.PCRemainingTimeColor1 = [System.Drawing.Color]::Navy
$c1.PCRemainingTimeColor2 = [System.Drawing.Color]::LightBlue
$c1.PCTotalTime = $total_steps
$c1.Size = New-Object System.Drawing.Size (47,45)
$c1.TabIndex = 3
$progress_complete = $c1.add_PCCompleted
$progress_complete.Invoke({
    param([object]$sender,[string]$message)
    $local:message = 'Task completed!'
    # [System.Windows.Forms.MessageBox]::Show($local:message)
    # this does not always work
    $l1.Text = $local:message
    try {
      $elems = $sender.Parent.Controls.Find('progress_label',$false)
    } catch [exception]{
    }
    if ($elems -ne $null) {
      # write-host $elems.GetType()
      # write-host $elems[0].GetType()

      $elems[0].Text = $local:message
    }

  })


$f.Controls.AddRange(@($l1,$c1))

$is= $f.WindowState

$f.add_Load({
    $f.WindowState = $is
  })

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

$so = [hashtable]::Synchronized(@{
    'Visible' = [bool]$false;
    'ScriptDirectory' = [string]'';
    'Form' = [System.Windows.Forms.Form]$f;
  })

$Runspace = [Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace($host)

$so.ScriptDirectory = Get-ScriptDirectory
$rs = [runspacefactory]::CreateRunspace()
$rs.ApartmentState = 'STA'
$rs.ThreadOptions = 'ReuseThread'
$rs.Open()
$rs.SessionStateProxy.SetVariable('so',$so)
$po = [System.Management.Automation.PowerShell]::Create()
$po.Runspace = $rs

$run_script = $po.AddScript({
    [System.Windows.Forms.Application]::EnableVisualStyles()
    [System.Windows.Forms.Application]::Run($so.Form)
  })

$res = $po.BeginInvoke()

if ($PSBoundParameters['pause']) {
  Write-Output 'Pause'
  try {
    [void]$host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
  } catch [exception]{}
} else {
  Start-Sleep -Millisecond 1000
}

# http://poshcode.org/5520
# Asynchronous GUI by Peter Kriegel

# subclass
$eventargs = New-Object -TypeName 'System.EventArgs'

Add-Member -InputObject $eventargs -MemberType 'NoteProperty' -Name 'Increment' -Value 0 -Force
Add-Member -InputObject $eventargs -MemberType 'NoteProperty' -Name 'Text' -Value '' -Force

$handler = [System.EventHandler]{
  param(
    [object]$sender,
    [System.EventArgs]$e
  )
  $local:increment = $e.Increment
  $local:text = $e.Text
  $sender.Increment($local:increment)
  try {
    $elems = $sender.Parent.Controls.Find('progress_label',$false)
  } catch [exception]{
  }
  if ($elems -ne $null) {
    $elems[0].Text =  $local:text
  }

}

1..($total_steps ) | ForEach-Object {

  $current_step = $_
  $message = $eventargs.Text =( 'Processed {0} / {1}' -f $current_step , $total_steps )

  $eventargs.Increment = 1
  [void]$c1.BeginInvoke($handler,($c1,([System.EventArgs]$eventargs)))
  if ($host.Version.Major -eq 2) {
    $c1.Invoke(

        [System.Action[int, string]] { 
            param(
              [int]$increment, 
              [string]$message
            )
            $sender.Increment($increment) 
            try {
              $elems = $sender.Parent.Controls.Find('progress_label',$false)
            } catch [exception]{
            }
            if ($elems -ne $null) {
              $elems[0].Text = $message
            }

        },

        # Argument for the System.Action delegate scriptblock

        @(1, $message)

    )
  }
  Start-Sleep -Milliseconds (Get-Random -Maximum 1000)
  write-output $message
}

if ($PSBoundParameters['pause']) {
  Write-Output 'Pause'
  try {
    [void]$host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
  } catch [exception]{}
} else {
  Start-Sleep -Millisecond 1000
}

$so.Form.Close()
[System.Windows.Forms.Application]::Exit()
$po.EndInvoke($res)
$rs.Close()
$po.Dispose()
