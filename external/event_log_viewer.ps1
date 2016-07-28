#Copyright (c) 2015,2016 Serguei Kouzmine
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


@( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }

function generate_event_filter {
  [string]$display_filter = ''
  [string[]]$display_filters = @()

  # Compose filter on event types
  if ($button_errors.Checked) {
    $display_filters += "(EventType='Error')"
  }
  if ($button_warnings.Checked) {
    $display_filters += "(EventType='Notice')"
  }
  if ($button_messages.Checked) {
    $display_filters += "(EventType='Info')"
  }
  <# TODO:
        ' If none of the buttons are pressed, this means they want none of these displayed
        If String.IsNullOrEmpty(displayFilter) Then
            displayFilter = "EventType=''"
         ...
#>
  $display_filter = $display_filters -join ' OR '

  #  Add a filter for the source
  if ($slo.Text -ne $null -and $slo.Text.Trim() -ne '') {
    $display_filter += (" AND Source='{0}'" -f $slo.Text.Trim())
  }
  # Add a filter for the typed message filter
  if ($find_text.Text -ne $null -and $find_text.Text.Trim() -ne '') {
    $display_filter += ("  AND Message LIKE '*{0}*'" -f $find_text.Text.Trim())
  }
  Write-Debug $display_filter
  $bs.Filter = $display_filter
}


$f = New-Object System.Windows.Forms.Form

# http://www.codeproject.com/Articles/14455/Eventlog-Viewer

$ts1 = New-Object System.Windows.Forms.ToolStrip
$button_errors = New-Object System.Windows.Forms.ToolStripButton
$bsep1 = New-Object System.Windows.Forms.ToolStripSeparator
$button_warnings = New-Object System.Windows.Forms.ToolStripButton
$bsep2 = New-Object System.Windows.Forms.ToolStripSeparator
$button_messages = New-Object System.Windows.Forms.ToolStripButton
$bsep4 = New-Object System.Windows.Forms.ToolStripSeparator
$sla = New-Object System.Windows.Forms.ToolStripLabel
$slo = New-Object System.Windows.Forms.ToolStripComboBox
$bsep5 = New-Object System.Windows.Forms.ToolStripSeparator
$find_label = New-Object System.Windows.Forms.ToolStripLabel
$find_text = New-Object System.Windows.Forms.ToolStripTextBox
$nothing_found = New-Object System.Windows.Forms.ToolStripLabel
$data_gridview = New-Object System.Windows.Forms.DataGridView
$img_event = New-Object System.Windows.Forms.DataGridViewImageColumn
$ts1.SuspendLayout()
$f.SuspendLayout()
#
# ToolStrip1
#
$ts1.GripStyle = [System.Windows.Forms.ToolStripGripStyle]::Hidden
$ts1.Items.AddRange(@( $button_errors,$bsep1,$button_warnings,$bsep2,$button_messages,$bsep4,$sla,$slo,$bsep5,$find_label,$find_text,$nothing_found))
$ts1.Location = New-Object System.Drawing.Point (0,0)
$ts1.Name = "ToolStrip1"
$ts1.Padding = New-Object System.Windows.Forms.Padding (4,1,1,1)
$ts1.Size = New-Object System.Drawing.Size (728,25)
$ts1.TabIndex = 4
$ts1.Text = "ToolStrip1"
# 
# btnErrors
# 
$button_errors.Checked = $true
$button_errors.CheckOnClick = $true
$button_errors.CheckState = [System.Windows.Forms.CheckState]::Checked
$button_errors.Image = [System.Drawing.Image]::FromFile(('{0}\{1}' -f (Get-ScriptDirectory),'Error.gif'))
$button_errors.Add_Click({
    param(
      [System.Object]$sender,[System.EventArgs]$e
    )
    generate_event_filter
  })
# Global.autoFocus.Components.My.Resources.Resources.ErrorGif
$button_errors.ImageScaling = [System.Windows.Forms.ToolStripItemImageScaling]::None
$button_errors.ImageTransparentColor = [System.Drawing.Color]::Magenta
$button_errors.Name = 'btnErrors'
$button_errors.Size = New-Object System.Drawing.Size (63,20)
$button_errors.Text = '0 Errors'
$button_errors.ToolTipText = '0 Errors'
# 
# ButtonSeparator1
# 
$bsep1.Margin = New-Object System.Windows.Forms.Padding (-1,0,1,0)
$bsep1.Name = "ButtonSeparator1"
$bsep1.Size = New-Object System.Drawing.Size (6,23)
# 
# btnWarnings
# 
$button_warnings.Checked = $true
$button_warnings.CheckOnClick = $true
$button_warnings.CheckState = [System.Windows.Forms.CheckState]::Checked
$button_warnings.Image = [System.Drawing.Image]::FromFile(('{0}\{1}' -f (Get-ScriptDirectory),'Warning.gif'))
$button_warnings.ImageScaling = [System.Windows.Forms.ToolStripItemImageScaling]::None
$button_warnings.ImageTransparentColor = [System.Drawing.Color]::Magenta
$button_warnings.Name = "btnWarnings"
$button_warnings.Size = New-Object System.Drawing.Size (81,20)
$button_warnings.Text = "0 Warnings"
$button_warnings.ToolTipText = "0 Warnings"
$button_warnings.Add_Click({
    param(
      [System.Object]$sender,[System.EventArgs]$e
    )
    generate_event_filter
  })

#
# ButtonSeparator2
# 
$bsep2.Margin = New-Object System.Windows.Forms.Padding (-1,0,1,0)
$bsep2.Name = "ButtonSeparator2"
$bsep2.Size = New-Object System.Drawing.Size (6,23)
# 
# btnMessages
# 
$button_messages.Checked = $true
$button_messages.CheckOnClick = $true
$button_messages.CheckState = [System.Windows.Forms.CheckState]::Checked
$button_messages.Image = [System.Drawing.Image]::FromFile(('{0}\{1}' -f (Get-ScriptDirectory),'Message.gif'))
$button_messages.ImageScaling = [System.Windows.Forms.ToolStripItemImageScaling]::None
$button_messages.ImageTransparentColor = [System.Drawing.Color]::Magenta
$button_messages.Name = 'btnMessages'
$button_messages.Size = New-Object System.Drawing.Size (82,20)
$button_messages.Text = '0 Messages'
$button_messages.ToolTipText = '0 Messages'
$button_messages.Add_Click({
    param(
      [System.Object]$sender,[System.EventArgs]$e
    )
    generate_event_filter
  })

#
# SourceSeparator
# 
$bsep4.Margin = New-Object System.Windows.Forms.Padding (-1,0,1,0)
$bsep4.Name = "SourceSeparator"
$bsep4.Size = New-Object System.Drawing.Size (6,23)
#
# SourceLabel
# 
$sla.Name = 'SourceLabel'
$sla.Size = New-Object System.Drawing.Size (44,20)
$sla.Text = 'Source:'
#
# SourceCombo
# 
$slo.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$slo.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
$slo.Font = New-Object System.Drawing.Font ('Tahoma',8.25,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,([byte]0))
$slo.Items.AddRange(@( ' '))
$slo.Margin = New-Object System.Windows.Forms.Padding (1,0,2,0)
$slo.Name = 'SourceCombo'
$slo.Size = New-Object System.Drawing.Size (100,23)
$slo.Sorted = $true
#
# FindSeparator
#
$bsep5.Margin = New-Object System.Windows.Forms.Padding (0,0,1,0)
$bsep5.Name = 'FindSeparator'
$bsep5.Size = New-Object System.Drawing.Size (6,23)
#
# FindLabel
#
$find_label.Name = 'FindLabel'
$find_label.Size = New-Object System.Drawing.Size (31,20)
$find_label.Text = 'Find:'
#
# FindText
#
$find_text.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$find_text.ForeColor = [System.Drawing.SystemColors]::WindowText
$find_text.Name = 'FindText'
$find_text.Padding = New-Object System.Windows.Forms.Padding (2,0,0,0)
$find_text.Size = New-Object System.Drawing.Size (86,23)
#
#NotFoundLabel
#
$nothing_found.Image = [System.Drawing.Image]::FromFile(('{0}\{1}' -f (Get-ScriptDirectory),'NotFound.gif'))
$nothing_found.Margin = New-Object System.Windows.Forms.Padding (5,1,0,2)
$nothing_found.Name = 'NotFoundLabel'
$nothing_found.Size = New-Object System.Drawing.Size (103,20)
$nothing_found.Text = 'No events found'
$nothing_found.ToolTipText = 'There are no events that match the defined filter.'
$nothing_found.Visible = $false
#
# DataGridView1
#
$data_gridview.AllowUserToAddRows = $false
$data_gridview.AllowUserToDeleteRows = $false
$data_gridview.AllowUserToResizeColumns = $true
$data_gridview.AllowUserToResizeRows = $false
$data_gridview.Anchor = [System.Windows.Forms.AnchorStyles]::Top `
   -bor [System.Windows.Forms.AnchorStyles]::Bottom `
   -bor [System.Windows.Forms.AnchorStyles]::Left `
   -bor [System.Windows.Forms.AnchorStyles]::Right
$data_gridview.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill
$data_gridview.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$data_gridview.CellBorderStyle = [System.Windows.Forms.DataGridViewCellBorderStyle]::None
$data_gridview.ColumnHeadersHeightSizeMode = [System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode]::AutoSize
$data_gridview.SelectionMode = [System.Windows.Forms.DataGridViewSelectionMode]::FullRowSelect
$data_gridview.RowTemplate.DefaultCellStyle.SelectionBackColor = [System.Drawing.Color]::Transparent
$data_gridview.AutoResizeRows([System.Windows.Forms.DataGridViewAutoSizeRowsMode]::AllCellsExceptHeaders)
$data_gridview.Columns.Add([System.Windows.Forms.DataGridViewColumn]$img_event)
$data_gridview.Location = New-Object System.Drawing.Point (0,26)
$data_gridview.MultiSelect = $false
$data_gridview.Name = "DataGridView1"
$data_gridview.ReadOnly = $true
$data_gridview.RowHeadersVisible = $false
$data_gridview.Size = New-Object System.Drawing.Size (728,320)
$data_gridview.TabIndex = 5
$data_gridview.Add_RowPrePaint({
    param(
      [object]$sender,
      [System.Windows.Forms.DataGridViewRowPrePaintEventArgs]$e
    )
    $e.PaintParts = $e.PaintParts -band (-bnot [System.Windows.Forms.DataGridViewPaintParts]::Focus)
    if (($e.State -band [System.Windows.Forms.DataGridViewElementStates]::Selected) -eq [System.Windows.Forms.DataGridViewElementStates]::Selected) {

      $row_bounds = New-Object System.Drawing.Rectangle (0,$e.RowBounds.Top,
        ($data_gridview.Columns.GetColumnsWidth([System.Windows.Forms.DataGridViewElementStates]::Visible) -
          $data_gridview.HorizontalScrollingOffset + 1),
        $e.RowBounds.Height)
      $back_brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush ($row_bounds,$data_gridview.DefaultCellStyle.SelectionBackColor,$e.InheritedRowStyle.ForeColor,[System.Drawing.Drawing2D.LinearGradientMode]::Horizontal)
      $back_brush_solid = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::Blue)
      try {
        $e.Graphics.FillRectangle($back_brush,$row_bounds)
      } finally {
        $back_brush.Dispose()
      }
    }

  })

# For a realistic data feed see https://github.com/lgarcia2/CraigslistScraper
# EventLog data feed.
$logname = 'Application'
$event_set = New-Object System.Diagnostics.EventLog ($logname)
$event_set.EnableRaisingEvents = $true
$event_set.Add_EntryWritten({
    param(
      [object]$sender,
      [System.Diagnostics.EntryWrittenEventArgs]$e
    )
    #  does not work
  })
$data_source = New-Object System.Data.DataSet ('EventLog Entries')
[void]$data_source.Tables.Add('Events')
$t = $data_source.Tables['Events']
# intend to hide 
 [void]$t.Columns.Add('EventType')
[void]$t.Columns.Add('Date/Time')
# "String was not recognized as a valid DateTime.Couldn't store <16-07-26 11:05:50> in Date/Time Column.
# $t.Columns['Date/Time'].DataType = [System.DateTime]
[void]$t.Columns.Add('Source')
[void]$t.Columns.Add('Message')

# Fields  appropriate to cloud-init.log :
$event_set_mock = @{ 'Entries' = @(
   @{
      'EntryType' = 'Notice';
      'Message' = 'ensure: created.';
      'ReplacementStrings' = '{}';
      'Source' = '/Stage[main]/Orm/File[C:\pce\or]/';
      'TimeGenerated' = '16-07-26 11:05:50';
    },
     @{
      'EntryType' = 'Notice';
      'Message' = 'Scheduling refresh of Exec[activate_windows.';
      'ReplacementStrings' = '{}';
      'Source' = 'Class[Wfdomain::Slmgr]:';
      'TimeGenerated' = '16-07-26 11:05:50';
    },   
    @{
      'EntryType' = 'Notice';
      'Message' = "Triggered 'refresh' from 1 events.";
      'ReplacementStrings' = '{}';
      'Source' = '/Stage[main]/Wfdomain/Reboot[after_domain_membership]:';
      'TimeGenerated' = '16-07-26 11:05:50';
    },
    @{
      'EntryType' = 'Info';
      'Message' = 'Creating state file C:/ProgramData/PuppetLabs/puppet/cache/state/state.yaml';
      'ReplacementStrings' = '{}';
      'Source' = '';
      'TimeGenerated' = '16-07-26 11:05:50';
    }    )
}

$event_set = $event_set_mock

$counts = @{
  'Error' = 0;
  'Warning' = 0;
  'Info' = 0;
}

$MAX_EVENTLOG_ENTRIES = 10
$max_cnt = $event_set.Entries.Count - 1
if ($max_cnt -gt $MAX_EVENTLOG_ENTRIES) {
  $max_cnt = $MAX_EVENTLOG_ENTRIES
}

0..$max_cnt | ForEach-Object {
  $cnt = $_
  $event_item = $event_set.Entries[$cnt]

# added by position
  [void]$data_source.Tables['Events'].Rows.Add(
    @(
      $event_item.EntryType,
      $event_item.TimeGenerated,
      $event_item.Source,
      $event_item.Message
    )
  )
  Write-output ($event_item | format-list)

  <#
  [void]$data_source.Tables['Events'].Rows.Add(
    @(
      $event_item['EntryType'],
      $event_item['TimeGenerated'],
      $event_item['Message'],
      $event_item['Source']
    )
  )
#>
  # Increment the event type counts
  switch ($event_item.EntryType)
  {
    'Error' {
      $counts['Error']++
    }
    'Warning' {
      $counts['Warning']++
    }
    'Info' {
      $counts['Info']++
    }
    default {
    }
  }

  # Update the buttons text
  $button_errors.ToolTipText = $button_errors.Text = ('{0} Errors' -f $counts['Error'])
  $button_warnings.ToolTipText = $button_warnings.Text = ('{0} Warnings' -f $counts['Warning'])
  $button_messages.ToolTipText = $button_messages.Text = ('{0} Messages' -f $counts['Info'])

}
[System.Windows.Forms.BindingSource]$bs = New-Object System.Windows.Forms.BindingSource ($data_source,'Events')
$data_gridview.DataSource = $bs
# want 
$data_gridview.add_CellFormatting({
    param(
      [object]$sender,
      [System.Windows.Forms.DataGridViewCellFormattingEventArgs]$e
    )
    $columns = $data_gridview.Columns

    # Convert Event Type to matching image 
    # intend to hide the eventtype column and show only the eventimage
    if ($columns[$e.ColumnIndex].Name.Equals('EventImage') -and $data_gridview.Columns.Contains('EventType')) {


      $EventType = $data_gridview.Item('EventType',$e.RowIndex).Value.ToString()

      switch ($EventType)
      {
        'Error' {
          $e.Value = [System.Drawing.Image]::FromFile(('{0}\{1}' -f (Get-ScriptDirectory),'Error.gif'))

        }

        'Warning' {
          $e.Value = [System.Drawing.Image]::FromFile(('{0}\{1}' -f (Get-ScriptDirectory),'Warning.gif'))
        }


        'Info' {
          $e.Value = [System.Drawing.Image]::FromFile(('{0}\{1}' -f (Get-ScriptDirectory),'Message.gif'))
        }
        default {
        
          $e.Value = [System.Drawing.Image]::FromFile(('{0}\{1}' -f (Get-ScriptDirectory),'NotFound.gif'))
        }
      }
    }
  })

#
# EventImage
#
$img_event.HeaderText = ''
$img_event.Name = 'EventImage'
$img_event.ReadOnly = $true
$img_event.Resizable = [System.Windows.Forms.DataGridViewTriState]::True
$img_event.SortMode = [System.Windows.Forms.DataGridViewColumnSortMode]::Automatic

#
#EventLogViewer
#
$f.AutoScaleDimensions = New-Object System.Drawing.SizeF (6.0,13.0)
$f.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font
$f.Controls.Add($data_gridview)
$f.Controls.Add($ts1)
$f.Name = 'EventLogViewer'
$f.Size = New-Object System.Drawing.Size (728,346)
$ts1.ResumeLayout($false)
$ts1.PerformLayout()
$f.ResumeLayout($false)
$f.PerformLayout()
$f.Topmost = $True
$f.Add_Shown({ $f.Activate() })
$city = "denver"
$currentSearchTerm = "miata"
$URL = ("http://" + $city + ".craigslist.org/search/cta?query=" + $currentSearchTerm + "&format=rss")


[System.Net.WebClient]$client = New-Object System.Net.WebClient
$client.Add_DownloadStringCompleted({
    param(
      [object]$sender,[System.Net.DownloadStringCompletedEventArgs]$e
    )

    [string]$result = $null
    if ((-not $e.Cancelled) -and ($e.Error -eq $null))
    {
      $result = $e.Result
    }
    if ($result -eq $null) {
      [System.Windows.Forms.MessageBox]::Show('Failed to Connect to website.')
      return
    }

    [System.Xml.XmlDocument]$xml_document = New-Object System.Xml.XmlDocument
    $xml_document.LoadXml($result)

    <#

    write-host $result: 
<rdf:RDF> 
<item rdf:about="http://denver.craigslist.org/cto/5017639313.html">
<title><![CDATA['90 Mazda Miata MX-5 (Elzabeth) &#x0024;3500]]></title>
<link>http://denver.craigslist.org/cto/5017639313.html</link>
<description><![CDATA[1990 Mazda Miata MX-5
- Clean
- 5 speed manual
- 136k original miles
- Runs and drives excellent
- Always maintained
$3500]]></description>
<dc:date>2015-05-14T09:44:45-06:00</dc:date>
<dc:language>en-us</dc:language>
<dc:rights>&#x26;copy; 2015 &#x3C;span class="desktop"&#x3E;craigslist&#x3C;/spa
n&#x3E;&#x3C;span class="mobile"&#x3E;CL&#x3C;/span&#x3E;</dc:rights>
<dc:source>http://denver.craigslist.org/cto/5017639313.html</dc:source>
<dc:title><![CDATA['90 Mazda Miata MX-5 (Elzabeth) &#x0024;3500]]></dc:title>
<dc:type>text</dc:type>
<enc:enclosure resource="http://images.craigslist.org/00h0h_ijv9klFNaBJ_300x300.
jpg" EventType="image/jpeg"/>
<dcterms:issued>2015-05-14T09:44:45-06:00</dcterms:issued>
</item>
</rdf:RDF>
#>
  })
$client.DownloadStringAsync((New-Object System.Uri ($URL)))



[void]$f.ShowDialog()


$f.Dispose()


