`#Copyright (c) 2018 Serguei Kouzmine
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the 'Software'), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.

@( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }
Add-Type -TypeDefinition @"
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
        $comboBoxRef.Value.Items.Add($str)
      }
    }
  }
  $script:result = @{ 'text' = ''; 'status' = $null; }
  $script:result.status = [System.Windows.Forms.DialogResult]::None;

  $script:launch_browser = $false
  $form = New-Object System.Windows.Forms.Form
  $label_prompt = New-Object System.Windows.Forms.Label
  $okBtn = New-Object System.Windows.Forms.Button
  $cclBtn = New-Object System.Windows.Forms.Button
  $eCombobox = New-Object System.Windows.Forms.ComboBox
  $dcCombobox = New-Object System.Windows.Forms.ComboBox
  $rCombobox = New-Object System.Windows.Forms.ComboBox
  
  
  $checkBox1 = New-Object System.Windows.Forms.CheckBox
  # checkBox1   
  $checkBox1.Location = New-Object System.Drawing.Point (12,28)
  $checkBox1.Name = 'checkBox1'
  $checkBox1.TabIndex = 1
  $checkBox1.Text = 'launch browser'
  $checkBox1.add_click( { 
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
  $label_prompt.Font = New-Object System.Drawing.Font ('Microsoft Sans Serif',8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)
  $label_prompt.Location = New-Object System.Drawing.Point (12,9)
  $label_prompt.Name = 'lblPrompt'
  $label_prompt.Size = New-Object System.Drawing.Size (302,12)
  $label_prompt.TabIndex = 3
  $label_prompt.Font = New-Object System.Drawing.Font ('Arial',10,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,0)
  $okBtn.DialogResult = [System.Windows.Forms.DialogResult]::OK
  $okBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
  $okBtn.Location = New-Object System.Drawing.Point (326,8)
  $okBtn.Name = 'btnOK'
  $okBtn.Size = New-Object System.Drawing.Size (64,24)
  $okBtn.TabIndex = 1
  $okBtn.Text = '&OK'
  $okBtn.Add_Click({
    param([object]$sender,[System.EventArgs]$e)
    $script:result.status = [System.Windows.Forms.DialogResult]::OK
    $environment = $eCombobox.Text
    $node_name = $rCombobox.Text
    $datacenter = $dcCombobox.Text
    $key = ('{0}|{1}|{2}' -f $environment, $node_name, $datacnter );
    $script:result.Text =$result[$key]
    write-host $script:result.Text
    if ($launch_browser) {     
      if ($script:IE -eq $null) {
        $script:IE = new-object -com 'internetexplorer.application'
      }
      # TODO: HTTP URL encode
      $target_url = ( "https://www.google.com/search?q={0}&oq={0}" -f $script:result.Text )
      $script:IE.navigate2($target_url)
      $script:IE.visible = $true
      <#
        # non-working version borrowed from the snippets that embedded WebBrowser
        $browser = new-object System.Windows.Forms.WebBrowser
        write-host $browser
        // $browser.Dock = [System.Windows.Forms.DockStyle]::Fill
        $browser.Location = new-object System.Drawing.Point(0, 0)
        $browser.Name = 'webBrowser1'
        $browser.Size = new-object System.Drawing.Size(600, 600)
        $browser.TabIndex = 0
        $target_url = 'https://www.google.com'
        $browser.Navigate($target_url);
        $browser.visible = $true
      #>
    }
    return $null
  })
  $okBtn.Font = New-Object System.Drawing.Font ('Arial',10,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,0)
  $cclBtn.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
  $cclBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
  $cclBtn.Location = New-Object System.Drawing.Point (326,60)
  $cclBtn.Name = 'btnCancel'
  $cclBtn.Size = New-Object System.Drawing.Size (64,24)
  $cclBtn.TabIndex = 2
  $cclBtn.Text = '&Cancel'
  $cclBtn.Add_Click({
    param([object] $sender,[System.EventArgs] $e )
    $script:result.status = [System.Windows.Forms.DialogResult]::Cancel
    $script:result.Text = ''
    $form.Dispose()
  })
  $cclBtn.Font = New-Object System.Drawing.Font ('Arial',10,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,0)

  $eCombobox.Location = New-Object System.Drawing.Point (8,60)
  $eCombobox.Name = 'CmBxComboBox'
  $eCombobox.Size = New-Object System.Drawing.Size (60,20)
  $eCombobox.TabIndex = 0
  $eCombobox.Text = ''
  $eCombobox.Font = New-Object System.Drawing.Font ('Arial',10,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)
  $eCombobox.Add_TextChanged({
    param(
      [object]$sender,[System.EventArgs]$e )
    # no op
  })

  $eCombobox.Add_KeyPress({
    param(
      [object]$sender,[System.Windows.Forms.KeyPressEventArgs] $e )
    # no op
  })
  $eCombobox.Add_TextChanged({
    param(
      [object]$sender,[System.EventArgs] $e )
    # no op
  })

  $dcCombobox.Location = New-Object System.Drawing.Point (75,60)
  $dcCombobox.Name = 'CmBxComboBox'
  $dcCombobox.Size = New-Object System.Drawing.Size (50,20)
  $dcCombobox.TabIndex = 0
  $dcCombobox.Text = ''
  $dcCombobox.Font = New-Object System.Drawing.Font ('Arial',10,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)
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

  $rCombobox.Location = New-Object System.Drawing.Point (135,60)
  $rCombobox.Name = 'CmBxComboBox'
  $rCombobox.Size = New-Object System.Drawing.Size (190,20)
  $rCombobox.TabIndex = 0
  $rCombobox.Text = ''
  $rCombobox.Font = New-Object System.Drawing.Font ('Arial',10,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)
  $rCombobox.Add_TextChanged({
    param([object]$sender,[System.EventArgs]$e)
  })

  $rCombobox.Add_KeyPress({
    param(
      [object]$sender,[System.Windows.Forms.KeyPressEventArgs]$e )

  })
  $rCombobox.Add_TextChanged({
    param(
      [object]$sender,[System.EventArgs]$e )
  })

  $form.AutoScaleBaseSize = New-Object System.Drawing.Size (5,13)
  $form.ClientSize = New-Object System.Drawing.Size (398,88)
  $form.Controls.AddRange(@( $eCombobox, $dcCombobox, $rCombobox, $cclBtn, $okBtn, $label_prompt, $checkBox1))
  $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
  $form.MaximizeBox = $false
  $form.MinimizeBox = $false
  $form.Name = 'ComboBoxDialog'
  $form.ResumeLayout($false)
  $form.AcceptButton = $okBtn
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
      [object]$sender, [System.ComponentModel.CancelEventArgs] $e
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

$caller = New-Object Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)

### generate_patameters_yaml.ps1

# https://github.com/aaubry/YamlDotNet
# see also https://www.codeproject.com/Articles/28720/YAML-Parser-in-C
# https://github.com/scottmuc/PowerYaml
function load_shared_assemblies {

  param(
    [string]$shared_assemblies_path = "${env:USERPROFILE}\Downloads",

    [string[]]$shared_assemblies = @(
      'YamlDotNet.dll' # https://www.nuget.org/packages/YamlDotNet
    )
  )
  pushd $shared_assemblies_path

  $shared_assemblies | ForEach-Object {
    Unblock-File -Path $_
    Write-output $_
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

load_shared_assemblies

$filename = 'environment.yaml'
$data = (Get-Content -Path ([System.IO.Path]::Combine((Get-ScriptDirectory),$filename))) -join "`n"

write-debug $data
$stringReader = New-Object System.IO.StringReader ($data)

$deserializer = New-Object -TypeName 'YamlDotNet.Serialization.Deserializer' -ArgumentList $null, $null, $false
$yaml_obj = $deserializer.Deserialize([System.IO.TextReader]$stringReader)
# $yaml_obj | get-member
# $yaml_obj.Keys |  format-list


# convert hash into PSCustomObject

# http://stackoverflow.com/questions/3740128/pscustomobject-to-hashtable
$result = @{}
$yaml_obj.Keys | foreach-object {
  $hostname = $_;
  $data = $yaml_obj[$_]
  $pscustom_obj = new-object -typeName 'PSObject' -Property $data
  # $pscustom_obj
  # Convert the PSCustomObject back to a hashtable
  $data_hash_obj = @{}
  $pscustom_obj.psobject.properties | where-object { $_ -match '(?:datacenter|branch_name|consul_node_name|environment)' } | foreach-Object {
    $data_hash_obj[$_.Name] = $_.Value
  }
  $result[$hostname] = $data_hash_obj
}


$json_obj = $result | convertto-json
$data = $json_obj | convertfrom-json

# debuging only
# $data
# TODO :  list $data fragament
# map exact names to short names
$short_names = @{
  'iam-identity-manager-initial'   = 'identity';
  'apim-content-delivery-0'        = 'content';
  'apim-api-manager-store-0'       = 'store';
  'apim-api-manager-store-1'       = 'store';
  'apim-ap-manager-publisher-0'    = 'publisher';
  'apim-api-manager-key-manager-0' = 'keymanager';
  'apim-api-manager-key-manager-1' = 'keymanager';
  'service-discovery-server-0'     = 'discovery';
  'service-discovery-server-1'     = 'discovery';
}
# TCP ports
$ports = @{
  'content'   = 8443;
  'identity'  = 8443;
  'discovery' = 8500;
  'publisher' = 9443;
  'gateway'   = 9443;
}
$protocols = @{
  'identity'  = 'https';
  'discovery' = 'http';
  'publisher' = 'https';
  'gateway'   = 'https';
}
$landing_pages = @{
  'identity'  =  '#';
  'discovery' = 'ui';
  'publisher' = 'publisher';
  'gateway'   = 'carbon';
}

$reverse_result = @{}
# only collect what we can process
$match_exporession = ('(?:{0})' -f ([String]::join('|', ($short_names.keys | foreach-object { $_ = $_ -replace '\-', '\-'; write-output $_ ;} ))))

$environments = @{}
$branch_names = @{}
$datacenters = @{}
$roles = @{}

$result.keys | foreach-object {

  $hostname = $_;
  if ($result[$hostname]['consul_node_name'] -ne $null) {
    if ($result[$hostname]['consul_node_name'] -match $match_exporession ) {
      $node_name = $result[$hostname]['consul_node_name']
      $short_node_name = $short_names[$result[$hostname]['consul_node_name']]
      $environment = $result[$hostname]['environment']
      $datacenter = $result[$hostname]['datacenter']
      $branch_name = $result[$hostname]['branch_name']
      $key = ('{0}|{1}|{2}' -f $environment, $node_name, $datacnter );
      try {
        $protocol = $protocols[$short_node_name]
        $landing_page = $landing_pages[$short_node_name]
        $port = $ports[$short_node_name]
        $reverse_result[$key] = ('{0}://{1}:{2}/{3}'-f $protocol, $hostname,$port,$landing_page)
        $roles[$node_name] = 1
      } catch [Exception] {
        write-output ('Failed to process "{0}"|"{1}"' -f $node_name, $short_node_name)
      }
        $environments[$environment] = 1
        $datacenters[$datacenter] = 1
        $branch_names[$branch_name] = 1
    }
  }
}
write-output 'Results for lookup:'
$reverse_result | format-list

write-output 'Datacenters:'
$datacenters.keys | format-list

write-output 'Environments:'
$environments.keys | format-table

write-output 'Roles:'
$roles.keys | format-table
###  end generate_patameters_yaml.ps1

$script:IE = $null
$prompt_message = 'Select or Enter the Env/DC/Role'
$caption = 'Browser Launch Test'

$o = ComboInputBox -environments ($environments.keys) -dataCenters ($datacenters.keys) -roles ($roles.keys) -caption $caption -prompt_message $prompt_message -result ([ref] $reverse_result)
if ($o.status -match 'OK') {
  Write-Output $o.Text
}
