
#Copyright (c) 2014,2018,2020 Serguei Kouzmine
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

# https://support.microsoft.com/en-us/help/4026814/windows-accessing-credential-manager
# Control Panel -> User Accounts -> Credential Manager -> Windows Credential

param (
  [string]$user = 'demouser',
  [switch]$store,
  [switch]$clipboard,
  [switch]$debug
)

$RESULT_OK = 0
$RESULT_CANCEL = 2

function PromptPassword {
  param(
    [string]$title,
    [string]$user,
    [object]$caller,
    [switch]$clipboard
  )
  $clipboard_flag = [bool]$PSBoundParameters['clipboard'].IsPresent

  @( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }

  $f = new-object System.Windows.Forms.Form
  $f.MaximizeBox = $false
  $f.MinimizeBox = $false
  $f.Text = $title
  $f.size = new-object System.Drawing.Size(290,172)

  $l1 = new-object System.Windows.Forms.Label
  $l1.Location = new-object System.Drawing.Size (10,20)
  $l1.Size = new-object System.Drawing.Size (100,20)
  $l1.Text = 'Username'
  $f.Controls.Add($l1)

  $f.Font = new-object System.Drawing.Font ('Microsoft Sans Serif',10,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)

  $t1 = new-object System.Windows.Forms.TextBox
  $t1.Location = new-object System.Drawing.Point (120,20)
  $t1.Size = new-object System.Drawing.Size (140,20)
  $t1.Text = $user
  $t1.Name = 'txtUser'
  $f.Controls.Add($t1)

  $l2 = new-object System.Windows.Forms.Label
  $l2.Location = new-object System.Drawing.Size (10,50)
  $l2.Size = new-object System.Drawing.Size (100,20)
  $l2.Text = 'Password'
  $f.Controls.Add($l2)

  $t2 = new-object System.Windows.Forms.TextBox
  $t2.Location = new-object System.Drawing.Point (120,50)
  $t2.Size = new-object System.Drawing.Size (140,20)
  $t2.Text = ''
  $t2.Name = 'txtPassword'
  $t2.PasswordChar = '*'
  $f.Controls.Add($t2)

  $btnOK = new-object System.Windows.Forms.Button
  $btnOK.Location = new-object System.Drawing.Point(20, 89)
  $btnOK.Text = 'OK'
  $btnOK.Name = "btnOK"
  $f.Controls.Add($btnOK)

  $btnCancel = new-object System.Windows.Forms.Button
  $btnCancel.Location = new-object System.Drawing.Point(175, 89)
  $btnCancel.Text = 'Cancel'
  $btnCancel.Name = 'btnCancel'
  $f.Controls.Add($btnCancel)

  $btnCancel.add_click({
    if ($clipboard_flag) {
      [System.Windows.Forms.Clipboard]::Clear()
    } else {
      $caller.txtPassword = $null
      $caller.txtUser = $null
    }
    $f.Close()
  })
  $btnOK.add_click({
    if ($clipboard_flag) {
      $Password = $t2.Text
      $user = $t1.Text

      [String]$cred = "${user}:${Password}"
      write-host ('Encoding {0}' -f $cred)
      $encodedCred = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($cred))

      # $basicAuthValue = "Basic $encodedCred"
      #
      # $Headers = @{
      #  Authorization = $basicAuthValue
      # }

      # ContentType = 'application/json'
      # $uri = 'https://www.github.com
      # Invoke-WebRequest -Uri $uri -ContentType 'text/json' -Headers $Headers

      [System.Windows.Forms.Clipboard]::SetText($encodedCred)
    } else {
      $caller.Data = $RESULT_OK
      $caller.txtPassword = $t2.Text
      $caller.txtUser = $t1.Text
    }
    $f.Close()
  })

  $f.Controls.Add($l)
  $f.Topmost = $true

  if ($clipboard_flag) {
      [System.Windows.Forms.Clipboard]::Clear()
  } else {
    $caller.Data = $RESULT_CANCEL
  }
  $f.Add_Shown({ $f.Activate() })
  $f.KeyPreview = $True
  $f.Add_KeyDown({
    if ($_.KeyCode -eq 'Escape') {
      if ($clipboard_flag) {
        [System.Windows.Forms.Clipboard]::Clear()
      } else {
        $caller.Data = $RESULT_CANCEL
      }
    }
    else { return }
    $f.Close()
  })

  if ($clipboard_flag) {
    [void]$f.ShowDialog()
  } else {
    [void]$f.ShowDialog([win32window]($caller))
  }
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

[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')


$store_flag = [bool]$PSBoundParameters['store'].IsPresent
if ($store_flag){
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

  # cmdkey can create, list, and deletes stored user names and passwords or credentials.
  # Passwords will not be displayed once they are stored
  # https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/cmdkey

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
      Console.Error.WriteLine("Exception (ignored) " + ex.ToString());
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
      Console.Error.WriteLine("Exception (ignored) " + ex.ToString());
    }
    return "";
  }
}

"@  -ReferencedAssemblies 'System.Security.dll', "c:\Users\${env:USERNAME}\Downloads\CredentialManagement.dll"

}
$clipboard_flag = [bool]$PSBoundParameters['clipboard'].IsPresent

$debug_flag = [bool]$PSBoundParameters['debug'].IsPresent
if ($debug_flag){
  $DebugPreference = 'Continue'
}
$title = 'Enter credentials'
<#
NOTE: launch powershell window
[System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle
788284
within powershell window, launch powershell again
- this is often done when debugging c# code embedded in Powershell script via add-type
 - this will lose MainWindowHandle
powershell.exe
Windows PowerShell
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

[System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle
0
#>
if (-not $clipboard_flag) {
  write-output '1'
  $window_handle = [System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle
  write-output ('Using current process handle {0}' -f $window_handle)
  if ($window_handle -eq 0) {
    $processid = [System.Diagnostics.Process]::GetCurrentProcess().Id
    $parent_process_id = get-wmiobject win32_process | where-object {$_.processid -eq  $processid } | select-object -expandproperty parentprocessid

    $window_handle = get-process -id $parent_process_id | select-object -expandproperty MainWindowHandle
    write-output ('Using current process parent process {0} handle {1}' -f $parent_process_id, $window_handle)
  }

  $caller = new-object Win32Window -ArgumentList ($window_handle)
  PromptPassword -Title $title -user $user -caller $caller
  if ($caller.Data -ne $RESULT_CANCEL) {
    if ($debug_flag){
      Write-Debug ('Oridinal username/password was: {0} / {1}' -f $caller.txtUser,$caller.txtPassword)
    }
      $o = new-object Helper
    $o.UserName = $caller.txtUser
    if ($store_flag) {
      $o.Password = $caller.txtPassword
      $o.SavePassword()
      write-output 'Password is stored in the vault'
    } else {
    if ([system.String]::Compare($o.GetPassword(), $caller.txtPassword) -eq 0 ){
      $result = 'valid'
    } else {
      $result = 'invalid'
    }
    write-output ('Password is ' + $result)
    if ($debug_flag){
      write-debug ('Password loaded from Vault: {0}' -f $o.GetPassword())
    }
    }
  }
} else {
  PromptPassword -Title $title -user $user -clipboard
  $data = [System.Windows.Forms.Clipboard]::GetText()
  if ($debug){
  [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String( $data))

  } else {
    write-output ('clipboard: {0}' -f $data)
  }
  [System.Windows.Forms.Clipboard]::Clear()

}
