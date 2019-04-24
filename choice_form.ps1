# replica of the sample 
# http://social.technet.microsoft.com/Forums/scriptcenter/en-US/f9de89d7-b2e5-4051-a241-f8f76f297fe6/stoping-powershell-script
# most controls removed.
$new_message = "12344"

function promptForContinueAuto ($title,$message)
{
  $title = $title
  $manual = New-Object System.Management.Automation.Host.ChoiceDescription "&Manual",`
     "Manually perform this step, then select Manual for the process to continue to the next step."

  $auto = New-Object System.Management.Automation.Host.ChoiceDescription "&Auto",`
     "Perform step with powershell script and continue to the next step."

  $cancelprocessing = New-Object System.Management.Automation.Host.ChoiceDescription "&Cancel",`
     "Perform step with powershell script and continue to the next step."

  $options = [System.Management.Automation.Host.ChoiceDescription[]]($manual,$auto,$cancelprocessing)

  $result = $host.ui.PromptForChoice($title,$message,$options,0)

  switch ($result)
  {
    0 { return $false }
    1 { return $true }
    2 { Write-Host `n"Process Halted At Step: " $title`n
      break }
  }
}


function dialogForContinueAuto {
param ([String]$title,[String]$message,[Win32Window]$owner)


  @( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }
  $objForm = New-Object System.Windows.Forms.Form
  $objForm.Text = $title
  $objForm.Size = New-Object System.Drawing.Size (400,130)
  $objForm.Owner = $owner
  $objForm.StartPosition = 'CenterScreen'
  $objForm.Topmost = $True

  $ManualButton = New-Object System.Windows.Forms.Button
  $ManualButton.Location = New-Object System.Drawing.Size (75,50)
  $ManualButton.Size = New-Object System.Drawing.Size (75,23)
  $ManualButton.Text = 'Manual'
  $ManualButton.add_click({
      Write-Host '123'
      $new_message = "777555"
      Write-Host $new_message
      $objForm.Close(); return $true })

  $objForm.Controls.Add($ManualButton)

  $ManualButton = New-Object System.Windows.Forms.Button
  $AutoButton = New-Object System.Windows.Forms.Button
  $AutoButton.Location = New-Object System.Drawing.Size (170,50)
  $AutoButton.Size = New-Object System.Drawing.Size (75,23)
  $AutoButton.Text = 'Auto'
  $AutoButton.add_click({
      $new_message = "45677"
      $objForm.Close(); return $false })

  $objForm.Controls.Add($AutoButton)

  $CancelButton = New-Object System.Windows.Forms.Button
  $CancelButton.Location = New-Object System.Drawing.Size (260,50)
  $CancelButton.Size = New-Object System.Drawing.Size (75,23)
  $CancelButton.Text = "Cancel"
  $CancelButton.add_click({
      $new_message = "45677"
      $result = 2; $objForm.Close(); Write-Host ("`nProcess Halted At Step: {0}" -f $title); return })

  $objForm.Controls.Add($CancelButton)


  $objLblComplist = New-Object System.Windows.Forms.label
  $objLblComplist.Location = New-Object System.Drawing.Size (30,30)
  $objLblComplist.Size = New-Object System.Drawing.Size (400,20)
  $objLblComplist.Text = $message
  $objForm.Controls.Add($objLblComplist)


  $objForm.Add_Shown({ $objForm.Activate() })
  [void]$objForm.ShowDialog()

  Write-Host $new_message

}

Add-Type -TypeDefinition @"
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

"@ -ReferencedAssemblies 'System.Windows.Forms.dll'

$sitecorehostnames = "server1"

$owner = New-Object Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)
dialogForContinueAuto "StepName - Rollback Authoring CMS ($sitecorehostnames)" "Rename KeepaliveON to KeepAlivsssOFF" $owner

# $result = [System.Windows.Forms.MessageBox]::Show("Continue Task?","What a Mess", "YesNo" , "Information" , "Button1")
# $result = promptForContinueAuto( "StepName - Rollback Authoring CMS ($sitecorehostnames)", "Rename KeepaliveON to KeepAlivsssOFF")


Write-Host $new_message
if ($result -eq $true) {
  Write-Output 'result is true'
} else {
  Write-Output 'result is false'
}
Write-Output ("{0}" -f $result)
