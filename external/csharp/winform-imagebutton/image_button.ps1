# https://www.codeproject.com/Articles/29010/WinForm-ImageButton 
# https://www.codeproject.com/Tips/5164771/Faded-Dimmed-Button-Images


param(
  [switch]$pause
)


@( 'System.Drawing','System.Windows.Forms','System.Windows.Forms.VisualStyles') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }


function imageButtonForm($title,$message) {

$o = add-type -TypeDefinition @'
using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.Drawing;
using System.ComponentModel;

namespace System.Windows.Forms
{
	public class ImageButton : PictureBox, IButtonControl
	{

		#region IButtonControl Members

		private DialogResult m_DialogResult;
		public DialogResult DialogResult {
			get {
				return m_DialogResult;
			}
			set {
				m_DialogResult = value;
			}
		}

		public void NotifyDefault(bool value)
		{
			isDefault = value;
		}

		public void PerformClick()
		{
			base.OnClick(EventArgs.Empty);
		}

		#endregion

		#region HoverImage
		private Image m_HoverImage;

		[Category("Appearance")]
		[Description("Image to show when the button is hovered over.")]
		public Image HoverImage {
			get { return m_HoverImage; }
			set {
				m_HoverImage = value;
				if (hover)
					Image = value;
			}
		}
		#endregion
		#region DownImage
		private Image m_DownImage;

		[Category("Appearance")]
		[Description("Image to show when the button is depressed.")]
		public Image DownImage {
			get { return m_DownImage; }
			set {
				m_DownImage = value;
				if (down)
					Image = value;
			}
		}
		#endregion
		#region NormalImage
		private Image m_NormalImage;

		[Category("Appearance")]
		[Description("Image to show when the button is not in any other state.")]
		public Image NormalImage {
			get { return m_NormalImage; }
			set {
				m_NormalImage = value;
				if (!(hover || down))
					Image = value;
			}
		}
		#endregion

		private const int WM_KEYDOWN = 0x0100;
		private const int WM_KEYUP = 0x0101;
		private bool hover = false;
		private bool down = false;
		private bool isDefault = false;

		#region Overrides

		[Browsable(true)]
		[DesignerSerializationVisibility(DesignerSerializationVisibility.Visible)]
		[Category("Appearance")]
		[Description("The text associated with the control.")]
		public override string Text {
			get {
				return base.Text;
			}
			set {
				base.Text = value;
			}
		}

		[Browsable(true)]
		[DesignerSerializationVisibility(DesignerSerializationVisibility.Visible)]
		[Category("Appearance")]
		[Description("The font used to display text in the control.")]
		public override Font Font {
			get {
				return base.Font;
			}
			set {
				base.Font = value;
			}
		}

		#endregion

		#region Description Changes
		[Description("Controls how the ImageButton will handle image placement and control sizing.")]
		public new PictureBoxSizeMode SizeMode { get { return base.SizeMode; } set { base.SizeMode = value; } }

		[Description("Controls what type of border the ImageButton should have.")]
		public new BorderStyle BorderStyle { get { return base.BorderStyle; } set { base.BorderStyle = value; } }
		#endregion

		#region Hiding

		[Browsable(false)]
		[DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
		public new Image Image { get { return base.Image; } set { base.Image = value; } }

		[Browsable(false)]
		[DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
		public new ImageLayout BackgroundImageLayout { get { return base.BackgroundImageLayout; } set { base.BackgroundImageLayout = value; } }

		[Browsable(false)]
		[DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
		public new Image BackgroundImage { get { return base.BackgroundImage; } set { base.BackgroundImage = value; } }

		[Browsable(false)]
		[DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
		public new String ImageLocation { get { return base.ImageLocation; } set { base.ImageLocation = value; } }

		[Browsable(false)]
		[DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
		public new Image ErrorImage { get { return base.ErrorImage; } set { base.ErrorImage = value; } }

		[Browsable(false)]
		[DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
		public new Image InitialImage { get { return base.InitialImage; } set { base.InitialImage = value; } }

		[Browsable(false)]
		[DesignerSerializationVisibility(DesignerSerializationVisibility.Hidden)]
		public new bool WaitOnLoad { get { return base.WaitOnLoad; } set { base.WaitOnLoad = value; } }
		#endregion

		#region Events
		protected override void OnMouseMove(MouseEventArgs e)
		{
			hover = true;
			if (down) {
				if ((m_DownImage != null) && (Image != m_DownImage))
					Image = m_DownImage;
			} else if (m_HoverImage != null)
				Image = m_HoverImage;
			else
				Image = m_NormalImage;
			base.OnMouseMove(e);
		}

		protected override void OnMouseLeave(EventArgs e)
		{
			hover = false;
			Image = m_NormalImage;
			base.OnMouseLeave(e);
		}

		protected override void OnMouseDown(MouseEventArgs e)
		{
			base.Focus();
			OnMouseUp(null);
			down = true;
			if (m_DownImage != null)
				Image = m_DownImage;
			base.OnMouseDown(e);
		}

		protected override void OnMouseUp(MouseEventArgs e)
		{
			down = false;
			if (hover) {
				if (m_HoverImage != null)
					Image = m_HoverImage;
			} else
				Image = m_NormalImage;
			base.OnMouseUp(e);
		}

		private bool holdingSpace = false;

		public override bool PreProcessMessage(ref Message msg)
		{
			if (msg.Msg == WM_KEYUP) {
				if (holdingSpace) {
					if ((int)msg.WParam == (int)Keys.Space) {
						OnMouseUp(null);
						PerformClick();
					} else if ((int)msg.WParam == (int)Keys.Escape
					                        || (int)msg.WParam == (int)Keys.Tab) {
						holdingSpace = false;
						OnMouseUp(null);
					}
				}
				return true;
			} else if (msg.Msg == WM_KEYDOWN) {
				if ((int)msg.WParam == (int)Keys.Space) {
					holdingSpace = true;
					OnMouseDown(null);
				} else if ((int)msg.WParam == (int)Keys.Enter) {
					PerformClick();
				}
				return true;
			} else
				return base.PreProcessMessage(ref msg);
		}

		protected override void OnLostFocus(EventArgs e)
		{
			holdingSpace = false;
			OnMouseUp(null);
			base.OnLostFocus(e);
		}

		protected override void OnPaint(PaintEventArgs pe)
		{
			base.OnPaint(pe);
			if ((!string.IsNullOrEmpty(Text)) && (pe != null) && (base.Font != null)) {
				SolidBrush drawBrush = new SolidBrush(base.ForeColor);
				SizeF drawStringSize = pe.Graphics.MeasureString(base.Text, base.Font);
				PointF drawPoint;
				if (base.Image != null)
					drawPoint = new PointF(base.Image.Width / 2 - drawStringSize.Width / 2, base.Image.Height / 2 - drawStringSize.Height / 2);
				else
					drawPoint = new PointF(base.Width / 2 - drawStringSize.Width / 2, base.Height / 2 - drawStringSize.Height / 2);
				pe.Graphics.DrawString(base.Text, base.Font, drawBrush, drawPoint);
			}
		}

		protected override void OnTextChanged(EventArgs e)
		{
			Refresh();
			base.OnTextChanged(e);
		}
		#endregion
	}
}

'@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Drawing.dll','System.Data.dll'


# http://stackoverflow.com/questions/8343767/how-to-get-the-current-directory-of-the-cmdlet-being-executed
function Get-ScriptDirectory
{
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  if ($Invocation.PSScriptRoot)
  {
    $Invocation.PSScriptRoot
  }
  elseif ($Invocation.MyCommand.Path)
  {
    Split-Path $Invocation.MyCommand.Path
  }
  else
  {
    $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf("\"))
  }
}

$f = New-Object System.Windows.Forms.Form

$o = New-Object -TypeName System.Windows.Forms.ImageButton

$o.Location = New-Object System.Drawing.Point (200,32)
# $o.Size = New-Object System.Drawing.Size (32,32)
$o.Name = 'b1'
$o.TabIndex = 1
$o.Text = "b1"


$f.SuspendLayout()

$o.add_click({ $f.Close() })

[System.Windows.Forms.ImageButton[]] $buttons = @()
$buttons += $o 

$buttons | foreach-object {
Add-Member -InputObject $_ -MemberType 'NoteProperty' -Name 'ImgState' -Value $btnState.BUTTON_UP -Force
Add-Member -InputObject $_ -MemberType 'NoteProperty' -Name 'mouseEnter' -Value $false -Force
Add-Member -InputObject $_ -MemberType 'NoteProperty' -Name 'Pressed' -Value $false -Force

} 



$buttons | foreach-object {$_.add_Paint($button_OnPaint)  } 
$button_OnGotFocus = {
  param(
    [object]$sender,[System.EventArgs]$e
  )

}
$buttons | foreach-object {$_.add_GotFocus($button_OnGotFocus)  } 

$button_OnLostFocus = {
  param(
    [object]$sender,[System.EventArgs]$e
  )
  $sender.Invalidate()

}

$buttons | foreach-object {$_.add_LostFocus($button_OnLostFocus)  } 
$button_OnMouseEnter = {
  param(
    [object]$sender,[System.EventArgs]$e
  )
  $sender.Invalidate()

}
$buttons | foreach-object {$_.add_MouseEnter($button_OnMouseEnter)  } 

$button_OnMouseLeave = {
  param(
    [object]$sender,[System.EventArgs]$e
  )
  # only restore state if doesn't have focus
  if ($sender.ImgState -ne $btnState.BUTTON_FOCUSED)
  {
    $sender.ImgState = $btnState.BUTTON_UP
  }
  $sender.Invalidate()

}

$buttons | foreach-object {$_.add_MouseLeave($button_OnMouseLeave)  } 

$button_OnMouseDown = {
  param(
    [object]$sender,[System.Windows.Forms.MouseEventArgs]$e
  )
  $sender.Invalidate()
}

$buttons | foreach-object {$_.add_MouseDown($button_OnMouseDown)  } 

$button_OnMouseUp = {
  param(
    [object]$sender,[System.Windows.Forms.MouseEventArgs]$e
  )
  $sender.Invalidate()

}
$buttons | foreach-object {$_.add_MouseUp($button_OnMouseUp)  } 
# Form
$f.AutoScaleDimensions = New-Object System.Drawing.SizeF (6.0,13.0)
$f.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font
$f.ClientSize = New-Object System.Drawing.Size (263,109)
$f.Controls.AddRange(@( $o ))
$f.Name = 'form'
$f.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$f.Text = 'Image Button'
$f.ResumeLayout($false)
$f.Add_Shown({ $f.Activate() })  
[void]$f.ShowDialog()
}


Add-Type -TypeDefinition @'
using System;
using System.Windows.Forms;
public class Win32Window : IWin32Window
{
    private IntPtr _hWnd;
    private int _data;
    private string _script_directory;

    public int Data
    {
        get { return _data; }
        set { _data = value; }
    }
    public string ScriptDirectory
    {
        get { return _script_directory; }
        set { _script_directory = value; }
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

'@ -ReferencedAssemblies 'System.Windows.Forms.dll'

$owner = New-Object Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)
imageButtonForm "Test" $owner
Start-Sleep -Millisecond 100
