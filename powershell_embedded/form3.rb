require 'base64'

command =  <<-EOF
$use_yaml_config = $true
$DebugPreference = 'Continue'
$use_json = $true

@( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }
add-type -typeDefinition @"
// "
using System;
using System.Windows.Forms;
public class Win32Window : IWin32Window
{
    private IntPtr _hWnd;
    private string _data;

    public string Data
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


function ComboInputBox {
  param(
    [string]$prompt_message = 'Select or Enter the Environment, Data Center, Role',
    [string[]]$environments = @(),
    [string[]]$dataCenters = @(),
    [string[]]$roles = @(),
    [System.Management.Automation.PSReference]$resultRef,
    [string]$caption = 'selection test'
  )

  $result = $resultRef.value

  # embedded
  function populateCombo () {
    param(
      [string[]]$comboBoxItems,
      [System.Management.Automation.PSReference]$comboBoxRef
    )
    for ($i = 0; $i -lt $comboBoxItems.Length; $i++) {
      $str = $comboBoxItems[$i]
      if ($str -ne $null) {
        $comboBoxRef.value.Items.Add($str)
      }
    }
  }
  $script:result = @{ 'text' = ''; 'status' = $null; }
  $script:result.status = [System.Windows.Forms.DialogResult]::None

  $script:browser = 'chrome.exe'
  # $script:browser = 'firefox.exe'
  $script:launch_browser = $false
  $form = new-object System.Windows.Forms.Form
  $label_prompt = new-object System.Windows.Forms.Label
  $projectBrowseButton = new-object System.Windows.Forms.Button
  $projectTextBox = new-object System.Windows.Forms.TextBox

  $launchButton = new-object System.Windows.Forms.Button
  $closeButton = new-object System.Windows.Forms.Button
  $eCombobox = new-object System.Windows.Forms.ComboBox
  $dcCombobox = new-object System.Windows.Forms.ComboBox
  $rCombobox = new-object System.Windows.Forms.ComboBox

  $checkBox1 = new-object System.Windows.Forms.CheckBox
  # checkBox1
  $checkBox1.Location = new-object System.Drawing.Point (12,28)
  $checkBox1.Name = 'checkBox1'
  $checkBox1.TabIndex = 1
  $checkBox1.Text = 'launch browser'
  $checkBox1.add_click({
      if ($checkBox1.Checked -eq $true) {
        $script:launch_browser = $true
      } else {
        $script:launch_browser = $false
      }
      # write-host ('Toggle launch broswer {0}' -f $script:launch_browser )
    })

  $form.SuspendLayout()
  $label_prompt.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
  $label_prompt.BackColor = [System.Drawing.SystemColors]::Control
  $label_prompt.Font = new-object System.Drawing.Font ('Microsoft Sans Serif',8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)
  $label_prompt.Location = new-object System.Drawing.Point (12,9)
  $label_prompt.Name = 'lblPrompt'
  $label_prompt.Size = new-object System.Drawing.Size (302,12)
  $label_prompt.TabIndex = 3
  $label_prompt.Font = new-object System.Drawing.Font ('Arial',10,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,0)

  $projectTextBox.Location = new-object System.Drawing.Point (10,100)
  $projectTextBox.Size = new-object System.Drawing.Size (270,20)
  $projectTextBox.Text = ''
  $projectTextBox.Name = 'txtProject'
  # http://blog.danskingdom.com/powershell-multi-line-input-box-dialog-open-file-dialog-folder-browser-dialog-input-box-and-message-box/

  # Show an Open Folder Dialog and return the directory selected by the user.
  function Read-FolderBrowserDialog ([string]$Message,[string]$InitialDirectory,[switch]$NoNewFolderButton)
  {
    $browseForFolderOptions = 0
    if ($NoNewFolderButton) { $browseForFolderOptions += 512 }

    $app = new-object -ComObject Shell.Application
    $folder = $app.BrowseForFolder(0,$Message,$browseForFolderOptions,$InitialDirectory)
    if ($folder) { $selectedDirectory = $folder.Self.Path } else { $selectedDirectory = '' }
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($app) > $null
    return $selectedDirectory
  }


  $projectBrowseButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
  $projectBrowseButton.Location = new-object System.Drawing.Point (290,100)
  $projectBrowseButton.Name = 'browse'
  $projectBrowseButton.Size = new-object System.Drawing.Size (64,24)
  $projectBrowseButton.TabIndex = 3
  $projectBrowseButton.Text = 'B&owse'
  $projectBrowseButton.add_click({
      $selectedDirectory = Read-FolderBrowserDialog -Message 'select project directory' -initialDirectory $env:userprofile -noNewFolderButton
      if ($selectedDirectory -ne $null) {
        $projectTextBox.Text = $selectedDirectory
      }
      return $null
    })


  $launchButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
  $launchButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
  $launchButton.Location = new-object System.Drawing.Point (10,130)
  $launchButton.Name = 'btnOK'
  $launchButton.Size = new-object System.Drawing.Size (64,24)
  $launchButton.TabIndex = 1
  $launchButton.Text = 'L&aunch'
  $launchButton.add_click({
      param([object]$sender,[System.EventArgs]$e)
      $script:result.status = [System.Windows.Forms.DialogResult]::OK
      $environment = $eCombobox.Text
      $node_name = $rCombobox.Text
      $datacenter = $dcCombobox.Text
      $key = ('{0}|{1}|{2}' -f $environment,$node_name,$datacnter)
      $script:result.Text = $result[$key]
      Write-Host ("Result: " + $script:result.Text)
      if ($launch_browser) {
        # TODO: HTTP URL encode
        $target_url = ("https://www.google.com/search?q={0}&oq={0}" -f $script:result.Text)
        Start-Process 'firefox.exe' $target_url
        # The 'internetexplorer.application' COM object is not needed for the current task. may be useful for other
        <# 
        if ($script:IE -eq $null) {
          $script:IE = new-object -com 'internetexplorer.application'
        }
        $script:IE.navigate2($target_url)
        $script:IE.visible = $true
      #>
        # older, non-working version borrowed from the Powershell/ Windows Forms snippets that embedded WebBrowser
        <#
        $browser = new-object System.Windows.Forms.WebBrowser
        write-host $browser
        // $browser.Dock = [System.Windows.Forms.DockStyle]::Fill
        $browser.Location = new-object System.Drawing.Point(0, 0)
        $browser.Name = 'webBrowser1'
        $browser.Size = new-object System.Drawing.Size(600, 600)
        $browser.TabIndex = 0
        $target_url = 'https://www.google.com'
        $browser.Navigate($target_url)
        $browser.visible = $true
      #>
      }
      return $null
    })
  $launchButton.Font = new-object System.Drawing.Font ('Arial',10,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,0)
  $closeButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
  $closeButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
  $closeButton.Location = new-object System.Drawing.Point (90,130)
  $closeButton.Name = 'btnCancel'
  $closeButton.Size = new-object System.Drawing.Size (64,24)
  $closeButton.TabIndex = 2
  $closeButton.Text = 'C&lose'
  $closeButton.add_click({
      param([object]$sender,[System.EventArgs]$e)
      $script:result.status = [System.Windows.Forms.DialogResult]::Cancel
      $script:result.Text = ''
      $form.Dispose()
    })
  $closeButton.Font = new-object System.Drawing.Font ('Arial',10,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,0)

  $eCombobox.Location = new-object System.Drawing.Point (8,60)
  $eCombobox.Name = 'CmBxComboBox'
  $eCombobox.Size = new-object System.Drawing.Size (60,20)
  $eCombobox.TabIndex = 0
  $eCombobox.Text = ''
  $eCombobox.Font = new-object System.Drawing.Font ('Arial',10,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)
  $eCombobox.Add_TextChanged({
      param(
        [object]$sender,[System.EventArgs]$e)
      # no op
    })

  $eCombobox.Add_KeyPress({
      param(
        [object]$sender,[System.Windows.Forms.KeyPressEventArgs]$e)
      # no op
    })
  $eCombobox.Add_TextChanged({
      param(
        [object]$sender,[System.EventArgs]$e)
      # no op
    })

  $dcCombobox.Location = new-object System.Drawing.Point (75,60)
  $dcCombobox.Name = 'CmBxComboBox'
  $dcCombobox.Size = new-object System.Drawing.Size (50,20)
  $dcCombobox.TabIndex = 0
  $dcCombobox.Text = ''
  $dcCombobox.Font = new-object System.Drawing.Font ('Arial',10,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)
  $dcCombobox.Add_TextChanged({
      param(
        [object]$sender,[System.EventArgs]$e
      )
    })

  $dcCombobox.Add_KeyPress({
      param(
        [object]$sender,[System.Windows.Forms.KeyPressEventArgs]$e
      )
    })
  $dcCombobox.Add_TextChanged({
      param(
        [object]$sender,[System.EventArgs]$e
      )
    })

  $rCombobox.Location = new-object System.Drawing.Point (135,60)
  $rCombobox.Name = 'CmBxComboBox'
  $rCombobox.Size = new-object System.Drawing.Size (220,20)
  $rCombobox.TabIndex = 0
  $rCombobox.Text = ''
  $rCombobox.Font = new-object System.Drawing.Font ('Arial',10,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)
  $rCombobox.Add_TextChanged({
      param([object]$sender,[System.EventArgs]$e)
    })

  $rCombobox.Add_KeyPress({
      param(
        [object]$sender,[System.Windows.Forms.KeyPressEventArgs]$e)

    })
  $rCombobox.Add_TextChanged({
      param(
        [object]$sender,[System.EventArgs]$e)
    })

  $form.AutoScaleBaseSize = new-object System.Drawing.Size (5,13)
  $form.ClientSize = new-object System.Drawing.Size (438,158)
  $form.Controls.AddRange(@( $eCombobox,$dcCombobox,$rCombobox,$closeButton,$launchButton,$projectBrowseButton,$projectTextBox,$label_prompt,$checkBox1))
  $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
  $form.MaximizeBox = $false
  $form.MinimizeBox = $false
  $form.Name = 'ComboBoxDialog'
  $form.ResumeLayout($false)
  $form.AcceptButton = $launchButton
  $script:result.status = [System.Windows.Forms.DialogResult]::Ignore
  $script:result.status = ''
  PopulateCombo -comboBoxItems $environments -comboBoxRef ([ref]$eCombobox)
  PopulateCombo -comboBoxItems $dataCenters -comboBoxRef ([ref]$dcCombobox)
  PopulateCombo -comboBoxItems $roles -comboBoxRef ([ref]$rCombobox)
  $label_prompt.Text = $prompt_message
  $form.Text = $caption
  $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
  $eCombobox.SelectionStart = 0
  $eCombobox.SelectionLength = $eCombobox.Text.Length
  $eCombobox.Focus()
  $form.Name = 'Form1'
  $form.ResumeLayout($false)

  $form.Topmost = $true

  $form.Add_Shown({ $form.Activate() })
  $form.Add_Closing({
      param(
        [object]$sender,[System.ComponentModel.CancelEventArgs]$e
      )
      # prevent the Closing event from closing the form
      # The 'Cancel' button will still do
      $e.Cancel = $true
    })
  [void]$form.ShowDialog($caller)

  $form.Dispose()
  $form = $null
  return $script:result

}

$caller = new-object Win32Window -argumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)

if ($use_yaml_config) {
  ### generate_patameters_yaml.ps1

  # https://github.com/aaubry/YamlDotNet
  # see also https://www.codeproject.com/Articles/28720/YAML-Parser-in-C
  # https://github.com/scottmuc/PowerYaml
  function load_shared_assemblies {

    param(
      [string]$shared_assemblies_path = "${env:USERPROFILE}\\Downloads",

      [string[]]$shared_assemblies = @(
        'YamlDotNet.dll' # https://www.nuget.org/packages/YamlDotNet
      )
    )
    pushd $shared_assemblies_path

    $shared_assemblies | ForEach-Object {
      Unblock-File -Path $_
      Write-Output $_
      Add-Type -Path $_
    }
    popd
  }

  # http://poshcode.org/2887
  # http://stackoverflow.com/questions/8343767/how-to-get-the-current-directory-of-the-cmdlet-being-executed
  # https://msdn.microsoft.com/en-us/library/system.management.automation.invocationinfo.pscommandpath%28v=vs.85%29.aspx
  function Get-ScriptDirectory
  {
    [string]$scriptDirectory = $null

    if ($host.Version.Major -gt 2) {
      $scriptDirectory = (Get-Variable PSScriptRoot).value
      Write-Debug ('$PSScriptRoot: {0}' -f $scriptDirectory)
      if ($scriptDirectory -ne $null) {
        return $scriptDirectory
      }
      $scriptDirectory = [System.IO.Path]::GetDirectoryName($MyInvocation.PSCommandPath)
      Write-Debug ('$MyInvocation.PSCommandPath: {0}' -f $scriptDirectory)
      if ($scriptDirectory -ne $null) {
        return $scriptDirectory
      }

      $scriptDirectory = Split-Path -Parent $PSCommandPath
      Write-Debug ('$PSCommandPath: {0}' -f $scriptDirectory)
      if ($scriptDirectory -ne $null) {
        return $scriptDirectory
      }
    } else {
      $scriptDirectory = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
      if ($scriptDirectory -ne $null) {
        return $scriptDirectory
      }
      $Invocation = (Get-Variable MyInvocation -Scope 1).value
      if ($Invocation.PSScriptRoot) {
        $scriptDirectory = $Invocation.PSScriptRoot
      } elseif ($Invocation.MyCommand.Path) {
        $scriptDirectory = Split-Path $Invocation.MyCommand.Path
      } else {
        $scriptDirectory = $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf('\\'))
      }
      return $scriptDirectory
    }
  }

  load_shared_assemblies

  $filename = 'environment.yaml'
  write-debug ('Loading {0} from {1}' -f $filename, ([System.IO.Path]::Combine((Get-ScriptDirectory),$filename)) )
  $data = (Get-Content -Path ([System.IO.Path]::Combine((Get-ScriptDirectory),$filename))) -join "`n"

  write-Debug $data
  $stringReader = new-object System.IO.StringReader ($data)

  $deserializer = new-object -TypeName 'YamlDotNet.Serialization.Deserializer' -ArgumentList $null,$null,$false
  $yaml_obj = $deserializer.Deserialize([System.IO.TextReader]$stringReader)
  # $yaml_obj | get-member
  # $yaml_obj.Keys |  format-list


  # convert hash into PSCustomObject

  # http://stackoverflow.com/questions/3740128/pscustomobject-to-hashtable
  $result = @{}
  $yaml_obj.Keys | ForEach-Object {
    $hostname = $_
    $data = $yaml_obj[$_]
    $pscustom_obj = new-object -TypeName 'PSObject' -Property $data
    # $pscustom_obj
    # Convert the PSCustomObject back to a hashtable
    $data_hash_obj = @{}
    $pscustom_obj.psobject.properties | Where-Object { $_ -match '(?:datacenter|branch_name|consul_node_name|environment)' } | ForEach-Object {
      $data_hash_obj[$_.Name] = $_.value
    }
    $result[$hostname] = $data_hash_obj
  }

  # TODO: list $data fragament
  # map exact names to short names
  $short_names = @{
    'iam-identity-manager-initial' = 'identity';
    'apim-content-delivery-0' = 'content';
    'apim-api-manager-store-0' = 'store';
    'apim-api-manager-store-1' = 'store';
    'apim-ap-manager-publisher-0' = 'publisher';
    'apim-api-manager-key-manager-0' = 'keymanager';
    'apim-api-manager-key-manager-1' = 'keymanager';
    'service-discovery-server-0' = 'discovery';
    'service-discovery-server-1' = 'discovery';
  }
  # TCP ports
  $ports = @{
    'content' = 8443;
    'identity' = 8443;
    'discovery' = 8500;
    'publisher' = 9443;
    'gateway' = 9443;
  }
  $protocols = @{
    'identity' = 'https';
    'discovery' = 'http';
    'publisher' = 'https';
    'gateway' = 'https';
  }
  $landing_pages = @{
    'identity' = '#';
    'discovery' = 'ui';
    'publisher' = 'publisher';
    'gateway' = 'carbon';
  }

  $reverse_result = @{}
  # only collect what we can process
  $match_exporession = ('(?:{0})' -f ([string]::join('|',($short_names.Keys | ForEach-Object { $_ = $_ -replace '\\-','\\-'; Write-Output $_; }))))

  $environments = @{}
  $branch_names = @{}
  $datacenters = @{}
  $roles = @{}

  $result.Keys | ForEach-Object {

    $hostname = $_;
    if ($result[$hostname]['consul_node_name'] -ne $null) {
      if ($result[$hostname]['consul_node_name'] -match $match_exporession) {
        $node_name = $result[$hostname]['consul_node_name']
        $short_node_name = $short_names[$result[$hostname]['consul_node_name']]
        $environment = $result[$hostname]['environment']
        $datacenter = $result[$hostname]['datacenter']
        $branch_name = $result[$hostname]['branch_name']
        $key = ('{0}|{1}|{2}' -f $environment,$node_name,$datacnter);
        try {
          $protocol = $protocols[$short_node_name]
          $landing_page = $landing_pages[$short_node_name]
          $port = $ports[$short_node_name]
          $reverse_result[$key] = ('{0}://{1}:{2}/{3}' -f $protocol,$hostname,$port,$landing_page)
          $roles[$node_name] = 1
        } catch [exception]{
          Write-Output ('Failed to process "{0}"|"{1}"' -f $node_name,$short_node_name)
        }
        $environments[$environment] = 1
        $datacenters[$datacenter] = 1
        $branch_names[$branch_name] = 1
      }
    }
  }
  Write-Output 'Results for lookup:'
  $reverse_result | Format-List

  Write-Output 'Datacenters:'
  $datacenters.Keys | Format-List

  Write-Output 'Environments:'
  $environments.Keys | Format-Table

  Write-Output 'Roles:'
  $roles.Keys | Format-Table
  ###  end generate_patameters_yaml.ps1

}
if ($use_json_config) {
  $filename = 'environment.json'
  # http://poshcode.org/2887
  # http://stackoverflow.com/questions/8343767/how-to-get-the-current-directory-of-the-cmdlet-being-executed
  # https://msdn.microsoft.com/en-us/library/system.management.automation.invocationinfo.pscommandpath%28v=vs.85%29.aspx
  function Get-ScriptDirectory
  {
    [string]$scriptDirectory = $null

    if ($host.Version.Major -gt 2) {
      $scriptDirectory = (Get-Variable PSScriptRoot).value
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
      $Invocation = (Get-Variable MyInvocation -Scope 1).value
      if ($Invocation.PSScriptRoot) {
        $scriptDirectory = $Invocation.PSScriptRoot
      } elseif ($Invocation.MyCommand.Path) {
        $scriptDirectory = Split-Path $Invocation.MyCommand.Path
      } else {
        $scriptDirectory = $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf('\\'))
      }
      return $scriptDirectory
    }
  }

  $data = (Get-Content -Path ([System.IO.Path]::Combine((Get-ScriptDirectory),$filename))) -join "`n"

  Write-Debug $data

  $json_obj = ConvertFrom-Json -InputObject $data
  # $json_obj is already a PSCustomObject
  $result = @{}

  # https://stackoverflow.com/questions/18779762/iterating-through-key-names-from-a-pscustomobject?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
  # Convert the PSCustomObject back to a hashtable

  $json_obj | Get-Member -MemberType NoteProperty | ForEach-Object {
    $hostname = $_.Name
    $result[$hostname] = @{}
    $data = $json_obj."$($_.Name)"
    $data_hash_obj = @{}
    $data | Get-Member -MemberType NoteProperty | ForEach-Object {
      $key = $_.Name
      $value = $data."$(${key})"
      $data_hash_obj[$key] = $value
    }
    $result[$hostname] = $data_hash_obj
  }

  # map exact names to short names
  $short_names = @{
    'iam-identity-manager-initial' = 'identity';
    'apim-content-delivery-0' = 'content';
    'apim-api-manager-store-0' = 'store';
    'apim-api-manager-store-1' = 'store';
    'apim-ap-manager-publisher-0' = 'publisher';
    'apim-api-manager-key-manager-0' = 'keymanager';
    'apim-api-manager-key-manager-1' = 'keymanager';
    'service-discovery-server-0' = 'discovery';
    'service-discovery-server-1' = 'discovery';
  }
  # TCP ports
  $ports = @{
    'content' = 8443;
    'identity' = 8443;
    'discovery' = 8500;
    'publisher' = 9443;
    'gateway' = 9443;
  }
  $protocols = @{
    'identity' = 'https';
    'discovery' = 'http';
    'publisher' = 'https';
    'gateway' = 'https';
  }
  $landing_pages = @{
    'identity' = '#';
    'discovery' = 'ui';
    'publisher' = 'publisher';
    'gateway' = 'carbon';
  }

  $reverse_result = @{}
  # only collect what we can process
  $match_exporession = ('(?:{0})' -f ([string]::join('|',($short_names.Keys | ForEach-Object { $_ = $_ -replace '\\-','\\-'; Write-Output $_; }))))
  $environments = @{}
  $branch_names = @{}
  $datacenters = @{}
  $roles = @{}
  $result.Keys | ForEach-Object {

    $hostname = $_;
    if ($result[$hostname]['consul_node_name'] -ne $null) {
      if ($result[$hostname]['consul_node_name'] -match $match_exporession) {
        $node_name = $result[$hostname]['consul_node_name']
        $short_node_name = $short_names[$result[$hostname]['consul_node_name']]
        $environment = $result[$hostname]['environment']
        $datacenter = $result[$hostname]['datacenter']
        $branch_name = $result[$hostname]['branch_name']
        $key = ('{0}|{1}|{2}|{3}' -f $environment,$branch_name,$result[$hostname]['consul_node_name'],$datacnter);
        try {
          $protocol = $protocols[$short_node_name]
          $landing_page = $landing_pages[$short_node_name]
          $port = $ports[$short_node_name]
          $reverse_result[$key] = ('{0}://{1}:{2}/{3}' -f $protocol,$hostname,$port,$landing_page)
          $roles[$node_name] = 1
        } catch [exception]{
          Write-Output ('Failed to process "{0}"|"{1}"' -f $node_name,$short_node_name)
        }
        $environments[$environment] = 1
        $datacenters[$datacenter] = 1
        $branch_names[$branch_name] = 1
      }
    }
  }
  Write-Output 'Results for lookup:'
  $reverse_result | Format-List

  Write-Output 'Datacenters:'
  $datacenters.Keys | Format-List

  Write-Output 'Environments:'
  $environments.Keys | Format-Table

  Write-Output 'Roles:'
  $roles.Keys | Format-Table

}

$script:IE = $null
$prompt_message = 'Select or Enter the Env/DC/Role'
$caption = 'Browser Launch Test'

$o = ComboInputBox -environments ($environments.Keys) -dataCenters ($datacenters.Keys) -roles ($roles.Keys) -caption $caption -prompt_message $prompt_message -result ([ref]$reverse_result)
if ($o.status -match 'OK') {
  Write-Output $o.Text
}

      EOF

# File.write('test.ps1', Base64.strict_encode64(command.encode('utf-16le')))
File.write('c:/windows/temp/test.ps1', command)

path = 'c:\Windows\Installer\16f6d0.msi'
property =  'UpgradeCode'


      # NOTE use double quotes with arguments
      arguments = "-Path \"#{path}\" -Property \"#{property}\""

result = %x|C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -executionpolicy remotesigned -file \"c:\\windows\\temp\\test.ps1\" #{arguments}|

puts result
