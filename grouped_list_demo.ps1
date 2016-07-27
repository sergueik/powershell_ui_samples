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

param(
  [switch]$show_buttons
)

Add-Type -TypeDefinition @"

// "
using System;
using System.Windows.Forms;
public class Win32Window : IWin32Window
{
    private IntPtr _hWnd;
    private int _data;
    private string _message;

    public int Data
    {
        get { return _data; }
        set { _data = value; }
    }
    public string Message
    {
        get { return _message; }
        set { _message = value; }
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


$shared_assemblies = @{
  'nunit.core.dll' = $null;
  'nunit.framework.dll' = $null;
  # http://www.codeproject.com/Articles/451742/Extending-Csharp-ListView-with-Collapsible-Groups
  # http://www.codeproject.com/Articles/451735/Extending-Csharp-ListView-with-Collapsible-Groups
  'GroupedListControl.dll' = $null;
}

$shared_assemblies_path = 'c:\developer\sergueik\csharp\SharedAssemblies'

if (($env:SHARED_ASSEMBLIES_PATH -ne $null) -and ($env:SHARED_ASSEMBLIES_PATH -ne '')) {
  $shared_assemblies_path = $env:SHARED_ASSEMBLIES_PATH
}

pushd $shared_assemblies_path
$shared_assemblies.Keys | ForEach-Object {
  # http://all-things-pure.blogspot.com/2009/09/assembly-version-file-version-product.html
  $assembly = $_
  $assembly_path = [System.IO.Path]::Combine($shared_assemblies_path,$assembly)
  $assembly_version = [Reflection.AssemblyName]::GetAssemblyName($assembly_path).Version
  $assembly_version_string = ('{0}.{1}' -f $assembly_version.Major,$assembly_version.Minor)
  if ($shared_assemblies[$assembly] -ne $null) {
    # http://stackoverflow.com/questions/26999510/selenium-webdriver-2-44-firefox-33
    if (-not ($shared_assemblies[$assembly] -match $assembly_version_string)) {
      Write-Output ('Need {0} {1}, got {2}' -f $assembly,$shared_assemblies[$assembly],$assembly_path)
      Write-Output $assembly_version
      throw ('invalid version :{0}' -f $assembly)
    }
  }

  if ($host.Version.Major -gt 2) {
    Unblock-File -Path $_;
  }
  Write-Debug $_
  Add-Type -Path $_
}
popd


function GroupedListBox
{
  param(
    [string]$title,
    [bool]$show_buttons)

  @( 'System.Drawing',
    'System.Collections.Generic',
    'System.Collections',
    'System.ComponentModel',
    'System.Windows.Forms',
    'System.Text',
    'System.Data'
  ) | ForEach-Object { $assembly = $_; [void][System.Reflection.Assembly]::LoadWithPartialName($assembly) }


  $f = New-Object System.Windows.Forms.Form

  $f.Text = $title
  $f.Size = New-Object System.Drawing.Size (640,400)
  # http://www.codeproject.com/Articles/451742/Extending-Csharp-ListView-with-Collapsible-Groups
  # http://www.codeproject.com/Articles/451735/Extending-Csharp-ListView-with-Collapsible-Groups
  $glc = New-Object -TypeName 'GroupedListControl.GroupListControl'


  $glc.SuspendLayout()

  $glc.AutoScroll = $true
  $glc.BackColor = [System.Drawing.SystemColors]::Control
  $glc.FlowDirection = [System.Windows.Forms.FlowDirection]::TopDown
  $glc.SingleItemOnlyExpansion = $false
  $glc.WrapContents = $false
  $glc.Anchor = ([System.Windows.Forms.AnchorStyles](0 `
         -bor [System.Windows.Forms.AnchorStyles]::Top `
         -bor [System.Windows.Forms.AnchorStyles]::Bottom `
         -bor [System.Windows.Forms.AnchorStyles]::Left `
         -bor [System.Windows.Forms.AnchorStyles]::Right `
      ))


  $f.SuspendLayout()

  if ($show_buttons) {
    [System.Windows.Forms.CheckBox]$cb1 = New-Object -TypeName 'System.Windows.Forms.CheckBox'
    $cb1.AutoSize = $true
    $cb1.Location = New-Object System.Drawing.Point (12,52)
    $cb1.Name = "chkSingleItemOnlyMode"
    $cb1.Size = New-Object System.Drawing.Size (224,17)
    $cb1.Text = 'Single-Group toggle'
    $cb1.UseVisualStyleBackColor = $true
    function chkSingleItemOnlyMode_CheckedChanged
    {
      param([object]$sender,[eventargs]$e)
      $glc.SingleItemOnlyExpansion = $cb1.Checked
      if ($glc.SingleItemOnlyExpansion) {
        $glc.CollapseAll()
      } else {
        $glc.ExpandAll()
      }
    }
    $cb1.Add_CheckedChanged({ chkSingleItemOnlyMode_CheckedChanged })
    [System.Windows.Forms.Label]$label1 = New-Object -TypeName 'System.Windows.Forms.Label'
    $label1.Location = New-Object System.Drawing.Point (12,13)
    $label1.Size = New-Object System.Drawing.Size (230,18)
    $label1.Text = 'Grouped List Control Demo'
    $label1.Font = New-Object System.Drawing.Font ('Lucida Sans',10.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,[System.Byte]0);
    [System.Windows.Forms.Button]$button1 = New-Object -TypeName 'System.Windows.Forms.Button'

    $button1.Location = New-Object System.Drawing.Point (303,46)
    $button1.Name = "button1"
    $button1.Size = New-Object System.Drawing.Size (166,23)
    $button1.TabIndex = 3
    $button1.Text = 'Add Data Items (disconnected)'
    $button1.Enabled = $false
    $button1.UseVisualStyleBackColor = true
    $button1.Add_Click({ Write-Host $glc.GetType()

        $x = $glc | Get-Member
        Write-Host ($x -join "`n")
      })

    $f.Controls.Add($cb1)
    $f.Controls.Add($button1)
    $f.Controls.Add($label1)

    $glc.Location = New-Object System.Drawing.Point (0,75)
    $glc.Size = New-Object System.Drawing.Size ($f.Size.Width,($f.Size.Height - 75))

  } else {
    $glc.Size = $f.Size

  }
  foreach ($key in $configuration_discovery_results.Keys) {
    $values = $configuration_discovery_results[$key]
    $configurations = $values['CONFIGURATIONS']
    [GroupedListControl.ListGroup]$lg = New-Object -TypeName 'GroupedListControl.ListGroup'
    $lg.Columns.Add($values['COMMENT'],120)
    $lg.Columns.Add("Key",150)
    $lg.Columns.Add("Value",300)
    # TODO - document the error.
    #    $configurations.Keys | foreach-object {  
    foreach ($k in $configurations.Keys) {
      $v = $configurations[$k]
      [System.Windows.Forms.ListViewItem]$item = $lg.Items.Add($key)
      $item.SubItems.Add($k)
      $item.SubItems.Add($v)
    }

    $glc.Controls.Add($lg)

  }

  for ($group = 1; $group -le 2; $group++)
  {
    [GroupedListControl.ListGroup]$lg = New-Object -TypeName 'GroupedListControl.ListGroup'
    $lg.Columns.Add("List Group " + $group.ToString(),120)
    $lg.Columns.Add("Group " + $group + " SubItem 1",150)
    $lg.Columns.Add("Group " + $group + " Subitem 2",150)
    $lg.Columns.Add("Group " + $group + " Subitem 3",150)
    $lg.Name = ("Group " + $group)
    # add some sample items:

    for ($j = 1; $j -le 3; $j++) {
      [System.Windows.Forms.ListViewItem]$item = $lg.Items.Add(("Item " + $j.ToString()))
      $item.SubItems.Add($item.Text + " SubItem 1")
      $item.SubItems.Add($item.Text + " SubItem 2")
      $item.SubItems.Add($item.Text + " SubItem 3")
    }

    # Add handling for the columnRightClick Event. 
    # Note: It is unfinished in the original GroupedListBox
    #    lg.ColumnRightClick += new ListGroup.ColumnRightClickHandler(lg_ColumnRightClick)
    #    lg.MouseClick += new MouseEventHandler(lg_MouseClick)
    # TODO: http://msdn.microsoft.com/en-us/library/system.windows.forms.listview.columnclick%28v=vs.110%29.aspx
    <#
     private void ColumnClick(object o, ColumnClickEventArgs e)
        {
            // Set the ListViewItemSorter property to a new ListViewItemComparer  
            // object. Setting this property immediately sorts the  
            // ListView using the ListViewItemComparer object. 
            this.listView1.ListViewItemSorter = new ListViewItemComparer(e.Column);
        }

    #>
    $glc.Controls.Add($lg)
  }

  $f.Controls.Add($glc)
  $glc.ResumeLayout($false)
  $f.ResumeLayout($false)
  $f.StartPosition = 'CenterScreen'
  $f.KeyPreview = $True
  $f.Topmost = $True
  $caller = New-Object -TypeName 'Win32Window' -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)
  $f.Add_Shown({ $f.Activate() })
  [void]$f.ShowDialog([win32window]($caller))
  $f.Dispose()
  $result = $caller.Message
  $caller = $null
  return $result
}

function collect_config_data {

  param(
    [ValidateNotNull()]
    [string]$target_domain,
    [string]$target_unc_path,
    [scriptblock]$script_block,
    [bool]$verbose,
    [bool]$debug
  )

  $local:result = @()
  if (($target_domain -eq $null) -or ($target_domain -eq '')) {
    if ($powerless) {
      return $local:result
    } else {
      throw 'unspecified DOMAIN'
    }
  }
  if (-not ($target_domain -match $env:USERDOMAIN)) {
    if ($powerless) {
      return $local:result
    } else {
      throw 'Unreachable DOMAIN'
    }
  }
  if ($verbose) {
    Write-Host ('Probing "{0}"' -f $target_unc_path)
  }

  [xml]$xml_config = Get-Content -Path $target_unc_path
  $object_ref = ([ref]$xml_config)
  $result_ref = ([ref]$local:result)

  Invoke-Command $script_block -ArgumentList $object_ref,$result_ref,$verbose,$debug

  if ($verbose) {
    Write-Host ("Result:`r`n---`r`n{0}`r`n---`r`n" -f ($local:result -join "`r`n"))
  }

}

[scriptblock]$Extract_appSetting = {
  param(
    [System.Management.Automation.PSReference]$object_ref,
    [System.Management.Automation.PSReference]$result_ref,
    [string]$key = $null
  )

  if ($key -eq $null -or $key -eq '') {
    throw 'Key cannot be null'

  }

  $data = @{}
  $nodes = $object_ref.Value.Configuration.Location.appSettings.Add
  for ($cnt = 0; $cnt -ne $nodes.count; $cnt++) {
    $k = $nodes[$cnt].Getattribute('key')
    $v = $nodes[$cnt].Getattribute('value')

    if ($k -match $key) {
      if ($global:debug) {
        Write-Host $k
        Write-Host $key
        Write-Host $v
      }
      $data[$k] += $v
    }
  }
  $result_ref.Value = $data[$key]
}

[scriptblock]$Extract_RuleActionurl = {
  param(
    [System.Management.Automation.PSReference]$object_ref,
    [System.Management.Automation.PSReference]$result_ref,
    [string]$key = $null
  )

  if ($key -eq $null -or $key -eq '') {
    throw 'Key cannot be null'
  }

  $data = @{}
  $nodes = $object_ref.Value.Configuration.Location.'system.webServer'.rewrite.rules.rule
  if ($global:debug) {
    Write-Host $nodes.count
  }
  for ($cnt = 0; $cnt -ne $nodes.count; $cnt++) {

    $k = $nodes[$cnt].Getattribute('name')
    $v = $nodes[$cnt].action.Getattribute('url')
    if ($k -match $key) {
      $data[$k] += $v
      if ($global:debug) {
        Write-Output $k; Write-Output $v
      }
    }

  }

  $result_ref.Value = $data[$key]
}

$configuration_paths = @{

  'Staging' = @{
    'COMMENT' = 'Staging Web Servers ConnectionStrings.config';
    'DOMAIN' = 'CARNIVAL';
    'UNC_PATHS' = @(
      '\\cclprdecostg1.carnival.com\e$\SitecoreCMS\Carnival\Website\App_Config\ConnectionStrings.config',
      '\\cclprdecostg1.carnival.com\e$\Projects\prod.carnival.com\Carnival\App_Config\ConnectionStrings.config',
      $null
    );
  };
}

$DebugPreference = 'Continue'

$show_buttons_arg = $false

if ($PSBoundParameters["show_buttons"]) {
  $show_buttons_arg = $true
}

$configuration_discovery_results = @{
  'Web.config' = @{
    'COMMENT' = 'Web Server';
    'DOMAIN' = '';
    'CONFIGURATIONS' = @{
      'Exit SSL cms targetted offers' = 'http://www.carnival.com/{R:1}';
      'Force Non Https for Home Page' = 'http://www.carnival.com';
      'To new deck plans page' = 'http://www.carnival.com/common/CCLUS/ships/ship/htmldeckplans.aspx';
      'imagesCdnHostToPrepend' = 'http://static.carnivalcloud.com';
    };
  };

  'ConnectionStrings.config' = @{
    'COMMENT' = 'Admin Server';
    'DOMAIN' = '';
    'CONFIGURATIONS' = @{
      'SecureLoginUrl' = 'https://secure.carnival.com/SignInTopSSL.aspx';
      'SecureUrl' = 'https://secure.carnival.com/';
      'FullSiteURL' = 'http://www.carnival.com';
      'RESTProxyDomain' = 'http://www.carnival.com';
      'PersonalizationDomain' = 'services.carnival.com';
    };
  };
}

GroupedListBox -Title '' -show_buttons $show_buttons_arg | Out-Null

