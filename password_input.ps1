#Copyright (c) 2014,2018 Serguei Kouzmine
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

$RESULT_OK = 0
$RESULT_CANCEL = 2

function PromptPassword {
  param(
    [string]$title,
    [string]$user,
    [object]$caller
  )

  @( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }

  $f = New-Object System.Windows.Forms.Form
  $f.MaximizeBox = $false
  $f.MinimizeBox = $false
  $f.Text = $title

  $l1 = New-Object System.Windows.Forms.Label
  $l1.Location = New-Object System.Drawing.Size (10,20)
  $l1.Size = New-Object System.Drawing.Size (100,20)
  $l1.Text = 'Username'
  $f.Controls.Add($l1)

  $f.Font = New-Object System.Drawing.Font ('Microsoft Sans Serif',10,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)

  $t1 = New-Object System.Windows.Forms.TextBox
  $t1.Location = New-Object System.Drawing.Point (120,20)
  $t1.Size = New-Object System.Drawing.Size (140,20)
  $t1.Text = $user
  $t1.Name = 'txtUser'
  $f.Controls.Add($t1)

  $l2 = New-Object System.Windows.Forms.Label
  $l2.Location = New-Object System.Drawing.Size (10,50)
  $l2.Size = New-Object System.Drawing.Size (100,20)
  $l2.Text = 'Password'
  $f.Controls.Add($l2)

  $t2 = New-Object System.Windows.Forms.TextBox
  $t2.Location = New-Object System.Drawing.Point (120,50)
  $t2.Size = New-Object System.Drawing.Size (140,20)
  $t2.Text = ''
  $t2.Name = 'txtPassword'
  $t2.PasswordChar = '*'
  $f.Controls.Add($t2)

  $btnOK = New-Object System.Windows.Forms.Button
  $x2 = 20
  $y1 = ($t1.Location.Y + $t1.Size.Height + + $btnOK.Size.Height + 20)
  $btnOK.Location = New-Object System.Drawing.Point ($x2,$y1)
  $btnOK.Text = 'OK'
  $btnOK.Name = "btnOK"
  $f.Controls.Add($btnOK)
  $btnCancel = New-Object System.Windows.Forms.Button
  $x1 = (($f.Size.Width - $btnCancel.Size.Width) - 20)

  $btnCancel.Location = New-Object System.Drawing.Point ($x1,$y1)
  $btnCancel.Text = 'Cancel'
  $btnCancel.Name = 'btnCancel'
  $f.Controls.Add($btnCancel)

  $s1 = ($f.Size.Width - $btnCancel.Size.Width) - 20
  $y2 = ($t1.Location.Y + $t1.Size.Height + $btnOK.Size.Height)

  $f.Size = New-Object System.Drawing.Size ($f.Size.Width,(($btnCancel.Location.Y +
        $btnCancel.Size.Height + 40)))

  $btnCancel.add_click({
      $caller.txtPassword = $null
      $caller.txtUser = $null
      $f.Close()
    })
  $btnOK.add_click({
      $caller.Data = $RESULT_OK
      $caller.txtPassword = $t2.Text
      $caller.txtUser = $t1.Text
      $f.Close()
    })

  $f.Controls.Add($l)
  $f.Topmost = $true


  $caller.Data = $RESULT_CANCEL
  $f.Add_Shown({ $f.Activate() })
  $f.KeyPreview = $True
  $f.Add_KeyDown({

      if ($_.KeyCode -eq 'Escape') { $caller.Data = $RESULT_CANCEL }
      else { return }
      $f.Close()
    })

  [void]$f.ShowDialog([win32window]($caller))

  $f.Dispose()
}

Add-Type -TypeDefinition @"
using System;
using System.Windows.Forms;
public class Win32Window : IWin32Window
{
    private IntPtr _hWnd;
    private int _data;
    private string _txtUser;
    private string _txtPassword;

    public int Data
    {
        get { return _data; }
        set { _data = value; }
    }


    public string TxtUser
    {
        get { return _txtUser; }
        set { _txtUser = value; }
    }
    public string TxtPassword
    {
        get { return _txtPassword; }
        set { _txtPassword = value; }
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



[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

$shared_assemblies = @(
  'CredentialManagement.dll',
  'nunit.framework.dll'
)

$selenium_drivers_path = $shared_assemblies_path = "c:\Users\${env:USERNAME}\Downloads"

if (($env:SHARED_ASSEMBLIES_PATH -ne $null) -and ($env:SHARED_ASSEMBLIES_PATH -ne '')) {
  $shared_assemblies_path = $env:SHARED_ASSEMBLIES_PATH
}

pushd $shared_assemblies_path

$shared_assemblies | ForEach-Object { Unblock-File -Path $_; Add-Type -Path $_ }
popd
# https://www.c-sharpcorner.com/forums/windows-credential-manager-with-c-sharp
# one can install wth nuget

# https://www.nuget.org/packages/CredentialManagement/

Add-Type -TypeDefinition @"
// "
using System;
using CredentialManagement;

public class Helper {
  private String password = null;
  private String userName = null;

  public string UserName {
    get { return userName; }
    set { userName = value; }
  }
  public string Password {
    set { password = value; }
  }

  public void SavePassword() {
    try {
      using (var cred = new Credential()) {
        cred.Password = password;
        cred.Target = userName;
        cred.Type = CredentialType.Generic;
        cred.PersistanceType = PersistanceType.LocalComputer;
        cred.Save();
      }
    } catch(Exception ex){
      Console.Error.WriteLine("Exception (ignord) " + ex.ToString());
    }
  }

  public String GetPassword() {
    try {
      using (var cred = new Credential()) {
        cred.Target = userName;
        cred.Load();
        return cred.Password;
      }
    } catch (Exception ex) {
      Console.Error.WriteLine("Exception (ignord) " + ex.ToString());
    }
    return "";
  }
}

"@  -ReferencedAssemblies 'System.Security.dll', "c:\Users\${env:USERNAME}\Downloads\CredentialManagement.dll"

$DebugPreference = 'Continue'
$title = 'Enter credentials'
$user = 'admin'
$caller = New-Object Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)

PromptPassword -Title $title -user $user -caller $caller
if ($caller.Data -ne $RESULT_CANCEL) {
  Write-Debug ('Oridinal password was : {0} / {1}' -f $caller.txtUser,$caller.txtPassword)
  $o = new-object Helper
  $o.UserName = $caller.txtUser
  $o.Password = $caller.txtPassword
  $o.SavePassword()
  write-output ("Password loaded back: {0} " -f $o.GetPassword())
}
