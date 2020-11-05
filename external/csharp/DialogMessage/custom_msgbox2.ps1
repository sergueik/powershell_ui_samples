#Copyright (c) 2020 Serguei Kouzmine
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
# Dialog Message in C# for .NET Framework
# https://www.codeproject.com/Articles/5264875/Dialog-Message-in-Csharp-for-NET-Framework-4-5
# https://github.com/chris-mackay/DialogMessage/tree/master/DialogMessage

$shared_assemblies = @(
  'nunit.core.dll',
  'nunit.framework.dll'
)


$shared_assemblies_path = 'c:\java\selenium\csharp\SharedAssemblies'

if (($env:SHARED_ASSEMBLIES_PATH -ne $null) -and ($env:SHARED_ASSEMBLIES_PATH -ne '')) {

  Write-Debug ('Using environment: {0}' -f $env:SHARED_ASSEMBLIES_PATH)
  $shared_assemblies_path = $env:SHARED_ASSEMBLIES_PATH
}

try {
  pushd $shared_assemblies_path -erroraction  'Stop' 
} catch [System.Management.Automation.ItemNotFoundException] {

# no shared assemblies 
throw
return

} catch [Exception]  {
# possibly System.Management.Automation.ItemNotFoundException
write-output ("Unexpected exception {0}`n{1}" -f  ( $_.Exception.GetType() ) , ( $_.Exception.Message) ) 

}

$shared_assemblies | ForEach-Object {
  $assembly = $_

  if ($host.Version.Major -gt 2) {
    Unblock-File -Path $assembly
  }
  Add-Type -Path $assembly
  Write-Debug $assembly
}
popd


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

add-type -TypeDefinition @"

using System.Windows.Forms;
using System.Drawing;

namespace DialogMessageInline {
  public static class DMessage {
    public static DialogResult ShowMessage(string _windowTitle, string _mainInstruction, MsgButtons _msgButtons, MsgIcons _msgIcons = MsgIcons.None, string _content = "") {
      MainForm main = new MainForm();
      main.Height = 157;
      main.Text = _windowTitle;
      main.mainInstruction.Text = _mainInstruction;
      main.content.Text = _content;
      switch (_msgButtons) {
      // Button1 is the left button
      // Button2 is the right button

        case MsgButtons.OK:
                    
          main.Button1.Visible = false;
          // https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.dialogresult
          main.Button2.DialogResult = System.Windows.Forms.DialogResult.OK;
          main.Button2.Text = "OK";
          main.AcceptButton = main.Button2; 
          main.Button2.TabIndex = 0;
          main.ActiveControl = main.Button2;

          break;

        case MsgButtons.OKCancel:

          main.Button1.DialogResult = System.Windows.Forms.DialogResult.OK;
          main.Button2.DialogResult = System.Windows.Forms.DialogResult.Cancel;
          main.Button1.Text = "OK";
          main.Button2.Text = "Cancel";
          main.AcceptButton = main.Button2; 
          main.Button1.TabIndex = 1;
          main.Button2.TabIndex = 0;
          main.ActiveControl = main.Button2;

          break;

        case MsgButtons.YesNo:

          main.Button1.DialogResult = System.Windows.Forms.DialogResult.Yes;
          main.Button2.DialogResult = System.Windows.Forms.DialogResult.No;
          main.Button1.Text = "Yes";
          main.Button2.Text = "No";
          main.AcceptButton = main.Button2; 
          main.Button1.TabIndex = 1;
          main.Button2.TabIndex = 0;
          main.ActiveControl = main.Button2;

          break;

        default:
          break;
      }

      // Sets the Image for the PictureBox based on which enum was provided
      // https://docs.microsoft.com/en-us/dotnet/api/system.drawing.systemicons
      if (_msgIcons != MsgIcons.None) {
        main.msgIcon.Visible = true;

        switch (_msgIcons) {
          case MsgIcons.Question:

            main.msgIcon.Image = System.Drawing.SystemIcons.Question.ToBitmap();
            break;

          case MsgIcons.Info:

            main.msgIcon.Image = System.Drawing.SystemIcons.Information.ToBitmap();
            break;

          case MsgIcons.Warning:
            main.msgIcon.Image = System.Drawing.SystemIcons.Warning.ToBitmap();
            break;

         case MsgIcons.Error:
           main.msgIcon.Image = System.Drawing.SystemIcons.Error.ToBitmap();
           break;

         case MsgIcons.Shield:
           main.msgIcon.Image = System.Drawing.SystemIcons.Shield.ToBitmap();
           break;

         default:
           break;
       }
     } else {
       main.msgIcon.Visible = false;
     }

     // Shows the message and gets the result selected by the user
     return main.ShowDialog();
   }

   public static MsgIcons setMsgIcon(string data) {
     MsgIcons value = MsgIcons.None;
     if (!System.Enum.TryParse(data, false, out value)) {
        value = MsgIcons.None;
      }
     return value;
   }

   public static MsgButtons setMsgButton(string data) {
      MsgButtons value = MsgButtons.OK;
      if (!System.Enum.TryParse(data, false, out value)) {
        value = MsgButtons.OK;
      }
      return value;
    }

    public enum MsgIcons {
      None = 0,
      Question = 1,
      Info = 2,
      Warning = 3,
      Error = 4,
      Shield = 5
    }

    public enum MsgButtons {
      OK = 0,
      OKCancel = 1,
      YesNo = 2
    }
  }


  public class MainForm : Form {
    private System.ComponentModel.IContainer components = null;

    protected override void Dispose(bool disposing) {
      if (disposing && (components != null)) {
        components.Dispose();
      }
      base.Dispose(disposing);
    }

  private void InitializeComponent() {
      this.whiteSpace = new System.Windows.Forms.Panel();
      this.content = new System.Windows.Forms.Label();
      this.mainInstruction = new System.Windows.Forms.Label();
      this.tablePanelLayout = new System.Windows.Forms.TableLayoutPanel();
      this.Button1 = new System.Windows.Forms.Button();
      this.Button2 = new System.Windows.Forms.Button();
      this.msgIcon = new System.Windows.Forms.PictureBox();
      this.whiteSpace.SuspendLayout();
      this.tablePanelLayout.SuspendLayout();
      ((System.ComponentModel.ISupportInitialize)(this.msgIcon)).BeginInit();
      this.SuspendLayout();
      //
      // whiteSpace
      //
      this.whiteSpace.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
      | System.Windows.Forms.AnchorStyles.Left)
      | System.Windows.Forms.AnchorStyles.Right)));
      this.whiteSpace.BackColor = System.Drawing.Color.White;
      this.whiteSpace.Controls.Add(this.content);
      this.whiteSpace.Controls.Add(this.mainInstruction);
      this.whiteSpace.Location = new System.Drawing.Point(0, 0);
      this.whiteSpace.Name = "whiteSpace";
      this.whiteSpace.Size = new System.Drawing.Size(383, 79);
      this.whiteSpace.TabIndex = 1;
      //
      // content
      //
      this.content.AutoSize = true;
      this.content.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.content.Location = new System.Drawing.Point(54, 51);
      this.content.MaximumSize = new System.Drawing.Size(305, 0);
      this.content.Name = "content";
      this.content.Size = new System.Drawing.Size(44, 13);
      this.content.TabIndex = 1;
      this.content.Text = "Content";
      //
      // mainInstruction
      //
      this.mainInstruction.AutoSize = true;
      this.mainInstruction.Font = new System.Drawing.Font("Segoe UI", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.mainInstruction.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(51)))), ((int)(((byte)(188)))));
      this.mainInstruction.Location = new System.Drawing.Point(54, 13);
      this.mainInstruction.Margin = new System.Windows.Forms.Padding(5, 0, 3, 18);
      this.mainInstruction.MaximumSize = new System.Drawing.Size(305, 0);
      this.mainInstruction.Name = "mainInstruction";
      this.mainInstruction.Size = new System.Drawing.Size(123, 21);
      this.mainInstruction.TabIndex = 0;
      this.mainInstruction.Text = "Main Instruction";
      //
      // tablePanelLayout
      //
      this.tablePanelLayout.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
      this.tablePanelLayout.ColumnCount = 2;
      this.tablePanelLayout.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
      this.tablePanelLayout.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
      this.tablePanelLayout.Controls.Add(this.Button1, 0, 0);
      this.tablePanelLayout.Controls.Add(this.Button2, 1, 0);
      this.tablePanelLayout.Location = new System.Drawing.Point(232, 83);
      this.tablePanelLayout.Name = "tablePanelLayout";
      this.tablePanelLayout.RowCount = 1;
      this.tablePanelLayout.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50F));
      this.tablePanelLayout.Size = new System.Drawing.Size(146, 29);
      this.tablePanelLayout.TabIndex = 2;
      //
      // Button1
      //
      this.Button1.Anchor = System.Windows.Forms.AnchorStyles.None;
      this.Button1.Location = new System.Drawing.Point(3, 3);
      this.Button1.Name = "Button1";
      this.Button1.Size = new System.Drawing.Size(67, 23);
      this.Button1.TabIndex = 0;
      this.Button1.Text = "Button1";
      //
      // Button2
      //
      this.Button2.Anchor = System.Windows.Forms.AnchorStyles.None;
      this.Button2.Location = new System.Drawing.Point(76, 3);
      this.Button2.Name = "Button2";
      this.Button2.Size = new System.Drawing.Size(67, 23);
      this.Button2.TabIndex = 1;
      this.Button2.Text = "Button2";
      //
      // msgIcon
      //
      this.msgIcon.BackColor = System.Drawing.Color.White;
      this.msgIcon.Location = new System.Drawing.Point(14, 14);
      this.msgIcon.Name = "msgIcon";
      this.msgIcon.Size = new System.Drawing.Size(32, 32);
      this.msgIcon.TabIndex = 3;
      this.msgIcon.TabStop = false;
      //
      // MainForm
      //
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(383, 118);
      this.Controls.Add(this.msgIcon);
      this.Controls.Add(this.tablePanelLayout);
      this.Controls.Add(this.whiteSpace);
      this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
      this.MaximizeBox = false;
      this.MinimizeBox = false;
      this.MinimumSize = new System.Drawing.Size(360, 157);
      this.Name = "MainForm";
      this.ShowIcon = false;
      this.ShowInTaskbar = false;
      this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
      this.Text = "Window Title";
      this.Load += new System.EventHandler(this.DialogMessage_Load);
      this.whiteSpace.ResumeLayout(false);
      this.whiteSpace.PerformLayout();
      this.tablePanelLayout.ResumeLayout(false);
      ((System.ComponentModel.ISupportInitialize)(this.msgIcon)).EndInit();
      this.ResumeLayout(false);

  }

  internal System.Windows.Forms.Panel whiteSpace;
  internal System.Windows.Forms.TableLayoutPanel tablePanelLayout;
  internal System.Windows.Forms.Label content;
  internal System.Windows.Forms.Label mainInstruction;
  internal System.Windows.Forms.Button Button1;
  internal System.Windows.Forms.Button Button2;
  internal System.Windows.Forms.PictureBox msgIcon;

  public MainForm() {
    InitializeComponent();
  }

  private void DialogMessage_Load(object sender, System.EventArgs e) {
            // Once the ShowMessage function is called and the form appears
            // the code below makes the appropriate adjustments so the text appears properly

            // If no icon will be shown then shift the MainInstruction and Content
            // left to an appropriate location

            // Adjust the MaximumSize to compensate for the shift left.
            if (msgIcon.Visible == false) {
                mainInstruction.Location = new System.Drawing.Point(12, mainInstruction.Location.Y);
                mainInstruction.MaximumSize = new System.Drawing.Size(353, 0);

                content.Location = new System.Drawing.Point(12, content.Location.Y);
                content.MaximumSize = new System.Drawing.Size(353, 0);
            }

            // Gets the Y location of the bottom of MainInstruction
            int mainInstructionBottom = mainInstruction.Location.Y + mainInstruction.Height;

            // Gets the Y location of the bottom of Content
            int contentBottom = content.Location.Y + content.Height;

            // Offsets the top of Content from the bottom of MainInstruction
            int contentTop = mainInstructionBottom + 18; // 18 just looked nice to me

            // Sets new location of the top of Content
            content.Location = new System.Drawing.Point(content.Location.X, contentTop);

            if (content.Text == string.Empty)

                // If only MainInstruction is provided then make the form a little shorter
                Height += (mainInstruction.Location.Y + mainInstruction.Height) - 50;
            else
                Height += (content.Location.Y + content.Height) - 60;
        }
    }

}

"@  -ReferencedAssemblies @( 'System.Windows.Forms.dll',`
     'System.Drawing.dll',`
     'System.Data.dll',`
     'System.Xml.dll') 


$button = [DialogMessageInline.DMessage]::setMsgButton('YesNo')
if ($button -ne $null) { 
  write-output ('[DialogMessage.DMessage]::MsgButtons.YesNo={0}' -f $button)
} else { 
  write-output 'Cannot access [DialogMessage.DMessage]::MsgButtons enum'
}

$icon = [DialogMessageInline.DMessage]::setMsgIcon('Shield')
if ($icon -ne $null) { 
  write-output ('[DialogMessage.DMessage]::MsgIcons.Shield={0}' -f $icon)
} else { 
  write-output 'Cannot access [DialogMessage.DMessage]::MsgIcons enum'
}


[DialogMessageInline.DMessage]::ShowMessage("Window Title","Want to learn how to write your own message box?",$button, $icon, @("In this project we will learn the logic necessary " + "to write your own dialog message box in Windows" ))
