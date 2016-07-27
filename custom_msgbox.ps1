#Copyright (c) 2014,2015 Serguei Kouzmine
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
  [switch]$debug
)

@( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }


# http://poshcode.org/1942
function assert {
  [CmdletBinding()]
  param(
    [Parameter(Position = 0,ParameterSetName = 'Script',Mandatory = $true)]
    [scriptblock]$Script,
    [Parameter(Position = 0,ParameterSetName = 'Condition',Mandatory = $true)]
    [bool]$Condition,
    [Parameter(Position = 1,Mandatory = $true)]
    [string]$message)

  $message = "ASSERT FAILED: $message"
  if ($PSCmdlet.ParameterSetName -eq 'Script') {
    try {
      $ErrorActionPreference = 'STOP'
      $success = & $Script
    } catch {
      $success = $false
      $message = "$message`nEXCEPTION THROWN: $($_.Exception.GetType().FullName)"
    }
  }
  if ($PSCmdlet.ParameterSetName -eq 'Condition') {
    try {
      $ErrorActionPreference = 'STOP'
      $success = $Condition
    } catch {
      $success = $false
      $message = "$message`nEXCEPTION THROWN: $($_.Exception.GetType().FullName)"
    }
  }

  # show_exception

  if (!$success) {
    $action = Show3 -messageText $message `
       -messageTitle 'Assert failed' `
       -IcOn 'Error' `
       -btn 'RetryCancel' `
       -Description ("Try:{0}`r`nScript:{1}`r`nLine:{2}`r`nFunction:{3}" -f $Script,(Get-PSCallStack)[1].ScriptName,(Get-PSCallStack)[1].ScriptLineNumber,(Get-PSCallStack)[1].FunctionName)
    if ($action -ne 'Ignore') {
      throw $message
    }
  }
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


# http://www.codeproject.com/Tips/827370/Custom-Message-Box-DLL

function return_response
{
  param(
    [object]$sender,
    [System.EventArgs]$eventargs
  )

  [string ]$button_text = ([System.Windows.Forms.Button]$sender[0]).Text

  if ($button_text -match '(Yes|No|OK|Cancel|Abort|Retry|Ignore)') {
    $script:Result = $button_text
  }
  $f.Dispose()
}

function add_buttons {
  param([psobject]$param)

  switch ($param) {
    ('None') {
      $button_ok.Width = 80
      $button_ok.Height = 24
      $button_ok.Location = New-Object System.Drawing.Point (391,114)
      $button_ok.Text = 'OK'
      $panel.Controls.Add($button_ok)
      $button_ok.add_click.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          return_response ($sender,$eventargs)
        })

    }
    ('OK') {
      $button_ok.Width = 80
      $button_ok.Height = 24
      $button_ok.Location = New-Object System.Drawing.Point (391,114)
      $button_ok.Text = 'OK'
      $panel.Controls.Add($button_ok)
      $button_ok.add_click.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          return_response ($sender,$eventargs)
        })
    }
    ('YesNo') {
      # add No button
      $button_no.Width = 80
      $button_no.Height = 24
      $button_no.Location = New-Object System.Drawing.Point (391,114)
      $button_no.Text = 'No'
      $panel.Controls.Add($button_no)
      $button_no.add_click.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          return_response ($sender,$eventargs)
        })
      # add Yes button
      $button_yes.Width = 80
      $button_yes.Height = 24
      $button_yes.Location = New-Object System.Drawing.Point (($button_no.Location.X - $button_no.Width - 2),114)
      $button_yes.Text = 'Yes'
      $panel.Controls.Add($button_yes)
      $button_yes.add_click.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          return_response ($sender,$eventargs)
        })
    }
    ('YesNoCancel') {
      # add Cancel button
      $button_cancel.Width = 80
      $button_cancel.Height = 24
      $button_cancel.Location = New-Object System.Drawing.Point (391,114)
      $button_cancel.Text = 'Cancel'
      $panel.Controls.Add($button_cancel)
      $button_cancel.add_click.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          return_response ($sender,$eventargs)
        })
      # add No button
      $button_no.Width = 80
      $button_no.Height = 24
      $button_no.Location = New-Object System.Drawing.Point (($button_cancel.Location.X - $button_cancel.Width - 2),114)
      $button_no.Text = 'No'
      $panel.Controls.Add($button_no)
      $button_no.add_click.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          return_response ($sender,$eventargs)
        })

      # add Yes button
      $button_yes.Width = 80
      $button_yes.Height = 24
      $button_yes.Location = New-Object System.Drawing.Point (($button_no.Location.X - $button_no.Width - 2),114)
      $button_yes.Text = 'Yes'
      $panel.Controls.Add($button_yes)
      $button_yes_Response.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          return_response ($sender,$eventargs)
        })
    }
    ('RetryCancel') {
      # add Cancel button
      $button_cancel.Width = 80
      $button_cancel.Height = 24
      $button_cancel.Location = New-Object System.Drawing.Point (391,114)
      $button_cancel.Text = 'Cancel'
      $panel.Controls.Add($button_cancel)
      $button_cancel.add_click.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          return_response ($sender,$eventargs)
        })
      # add Retry button
      $button_retry.Width = 80
      $button_retry.Height = 24
      $button_retry.Location = New-Object System.Drawing.Point (($button_cancel.Location.X - $button_cancel.Width - 2),114)
      $button_retry.Text = 'Retry'
      $panel.Controls.Add($button_retry)
      $button_retry.add_click.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          return_response ($sender,$eventargs)
        })

    }
    ('AbortRetryIgnore') {
      # add Ignore button
      $button_ignore.Width = 80
      $button_ignore.Height = 24
      $button_ignore.Location = New-Object System.Drawing.Point (391,114)
      $button_ignore.Text = 'Ignore'
      $panel.Controls.Add($button_ignore)
      $button_ignore.add_click.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          return_response ($sender,$eventargs)
        })
      # add Retry button
      $button_retry.Width = 80
      $button_retry.Height = 24
      $button_retry.Location = New-Object System.Drawing.Point (($button_ignore.Location.X - $button_ignore.Width - 2),114)
      $button_retry.Text = 'Retry'
      $panel.Controls.Add($button_retry)
      $button_retry.add_click.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          return_response ($sender,$eventargs)
        })
      #add Abort button
      $button_abort.Width = 80
      $button_abort.Height = 24
      $button_abort.Location = New-Object System.Drawing.Point (($button_retry.Location.X - $button_retry.Width - 2),114)
      $button_abort.Text = 'Abort'
      $panel.Controls.Add($button_abort)
      $button_abort.add_click.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          return_response ($sender,$eventargs)
        })
    }
    default {}
  }
}

function add_icon_bitmap {
  param([psobject]$param)

  switch ($param)
  {
    ('Error') {
      $icon_bitmap.Image = ([System.Drawing.SystemIcons]::Error).ToBitmap()
    }
    ('Information') {
      $icon_bitmap.Image = ([System.Drawing.SystemIcons]::Information).ToBitmap()
    }
    ('Question') {
      $icon_bitmap.Image = ([System.Drawing.SystemIcons]::Question).ToBitmap()
    }
    ('Warning') {
      $icon_bitmap.Image = ([System.Drawing.SystemIcons]::Warning).ToBitmap()
    }
    default {
      $icon_bitmap.Image = ([System.Drawing.SystemIcons]::Information).ToBitmap()
    }
  }
}

function click_handler
{

  param(
    [object]$sender,
    [System.EventArgs]$eventArgs
  )
  if ($button_details.Tag.ToString() -match 'collapse')
  {
    $f.Height = $f.Height + $txtDescription.Height + 6
    $button_details.Tag = 'expand'
    $button_details.Text = 'Hide Details'
    $txtDescription.WordWrap = true
    # txtDescription.Focus();
    # txtDescription.SelectionLength = 0;
  }
  elseif ($button_details.Tag.ToString() -match 'expand')
  {
    $f.Height = $f.Height - $txtDescription.Height - 6
    $button_details.Tag = 'collapse'
    $button_details.Text = 'Show Details'
  }
}

function set_message_text
{
  param(
    [string]$messageText,
    [string]$Title,
    [string]$Description
  )
  $label_message.Text = $messageText
  if (($Description -ne $null) -and ($Description -ne ''))
  {
    $txtDescription.Text = $Description
  }
  else
  {
    $button_details.Visible = $false
  }
  if (($Title -ne $null) -and ($Title -ne ''))
  {
    $f.Text = $Title
  }
  else
  {
    $f.Text = 'Your Message Box'
  }
}

function Show1
{
  param(
    [string]$messageText
  )

  $f = New-Object System.Windows.Forms.Form
  $button_details = New-Object System.Windows.Forms.Button
  $button_ok = New-Object System.Windows.Forms.Button
  $button_yes = New-Object System.Windows.Forms.Button
  $button_no = New-Object System.Windows.Forms.Button
  $button_cancel = New-Object System.Windows.Forms.Button
  $button_abort = New-Object System.Windows.Forms.Button
  $button_retry = New-Object System.Windows.Forms.Button
  $button_ignore = New-Object System.Windows.Forms.Button
  $txtDescription = New-Object System.Windows.Forms.TextBox
  $icon_bitmap = New-Object System.Windows.Forms.PictureBox
  $panel = New-Object System.Windows.Forms.Panel
  $label_message = New-Object System.Windows.Forms.Label
  set_message_text $messageText '' $null
  add_icon_bitmap -param 'Information'
  add_buttons -param 'OK'
  DrawBox
  [void]$f.ShowDialog()
  Write-Host ('$script:Result = ' + $script:Result)
  $script:Result
}

function Show2
{
  param(
    [string]$messageText,
    [string]$messageTitle,
    [string]$description
  )
  $f = New-Object System.Windows.Forms.Form
  $button_details = New-Object System.Windows.Forms.Button
  $button_ok = New-Object System.Windows.Forms.Button
  $button_yes = New-Object System.Windows.Forms.Button
  $button_no = New-Object System.Windows.Forms.Button
  $button_cancel = New-Object System.Windows.Forms.Button
  $button_abort = New-Object System.Windows.Forms.Button
  $button_retry = New-Object System.Windows.Forms.Button
  $button_ignore = New-Object System.Windows.Forms.Button
  $txtDescription = New-Object System.Windows.Forms.TextBox
  $icon_bitmap = New-Object System.Windows.Forms.PictureBox
  $panel = New-Object System.Windows.Forms.Panel
  $label_message = New-Object System.Windows.Forms.Label
  set_message_text $messageText $messageTitle $description
  add_icon_bitmap -param 'Information'
  add_buttons -param 'OK'
  DrawBox
  [void]$f.ShowDialog()
  Write-Host ('$script:Result = ' + $script:Result)
  return $script:Result
}

function Show3
{
  param(
    [string]$messageText,
    [string]$messageTitle,
    [string]$description,
    [object]$IcOn,
    [object]$btn
  )

  $f = New-Object System.Windows.Forms.Form
  $button_details = New-Object System.Windows.Forms.Button
  $button_ok = New-Object System.Windows.Forms.Button
  $button_yes = New-Object System.Windows.Forms.Button
  $button_no = New-Object System.Windows.Forms.Button
  $button_cancel = New-Object System.Windows.Forms.Button
  $button_abort = New-Object System.Windows.Forms.Button
  $button_retry = New-Object System.Windows.Forms.Button
  $button_ignore = New-Object System.Windows.Forms.Button
  $txtDescription = New-Object System.Windows.Forms.TextBox
  $icon_bitmap = New-Object System.Windows.Forms.PictureBox
  $panel = New-Object System.Windows.Forms.Panel
  $label_message = New-Object System.Windows.Forms.Label

  set_message_text $messageText $messageTitle $description
  add_icon_bitmap -param $IcOn
  add_buttons -param $btn
  $script:Result = 'Cancel'

  DrawBox
  [void]$f.ShowDialog()
  $f.Dispose()
  Write-Host ('$script:Result = ' + $script:Result)
  return $script:Result
}

function show_exception
{
  param([System.Exception]$ex)

  $f = New-Object System.Windows.Forms.Form
  $button_details = New-Object System.Windows.Forms.Button
  $button_ok = New-Object System.Windows.Forms.Button
  $button_yes = New-Object System.Windows.Forms.Button
  $button_no = New-Object System.Windows.Forms.Button
  $button_cancel = New-Object System.Windows.Forms.Button
  $button_abort = New-Object System.Windows.Forms.Button
  $button_retry = New-Object System.Windows.Forms.Button
  $button_ignore = New-Object System.Windows.Forms.Button
  $txtDescription = New-Object System.Windows.Forms.TextBox
  $icon_bitmap = New-Object System.Windows.Forms.PictureBox
  $panel = New-Object System.Windows.Forms.Panel
  $label_message = New-Object System.Windows.Forms.Label
  set_message_text -Title 'Exception' -messageText $ex.Message -Description $ex.StackTrace
  add_icon_bitmap -param 'Error'
  add_buttons -param 'YesNo'
  DrawBox
  [void]$f.ShowDialog()
  Write-Host ('$script:Result = ' + $script:Result)
  return $script:Result
}

function DrawBox
{
  $f.Controls.Add($panel)
  $panel.Dock = [System.Windows.Forms.DockStyle]::Fill
  # draw picturebox
  $icon_bitmap.Height = 36
  $icon_bitmap.Width = 40
  $icon_bitmap.Location = New-Object System.Drawing.Point (10,11)
  $panel.Controls.Add($icon_bitmap)
  # add textbox
  $txtDescription.Multiline = $true
  $txtDescription.Height = 183
  $txtDescription.Width = 464
  $txtDescription.Location = New-Object System.Drawing.Point (6,143)
  $txtDescription.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
  $txtDescription.ScrollBars = [System.Windows.Forms.ScrollBars]::Both
  $txtDescription.ReadOnly = $true
  $panel.Controls.Add($txtDescription)

  # add detail button
  $button_details.Height = 24
  $button_details.Width = 80
  $button_details.Location = New-Object System.Drawing.Point (6,114)
  $button_details.Tag = 'expand'
  $button_details.Text = 'Show Details'
  $panel.Controls.Add($button_details)
  $button_details.add_click.Invoke({
      param(
        [object]$sender,
        [System.EventArgs]$eventargs
      )
      click_handler ($sender,$eventargs)
    })

  $label_message.Location = New-Object System.Drawing.Point (64,22)
  $label_message.AutoSize = $true
  $panel.Controls.Add($label_message)
  $f.Height = 360
  $f.Width = 483

  # set form layout
  $f.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
  $f.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
  $f.MaximizeBox = $false
  $f.MinimizeBox = $false
  ## frm.FormClosing += new FormClosingEventHandler(frm_FormClosing)
  $f.BackColor = [System.Drawing.SystemColors]::ButtonFace

  ## origin http://www.iconarchive.com/search?q=ico+files&page=7
  $f.Icon = New-Object System.Drawing.Icon ([System.IO.Path]::Combine((Get-ScriptDirectory),"Martz90-Circle-Files.ico"))
  if ($button_details.Tag.ToString() -match 'expand')
  {
    $f.Height = $f.Height - $txtDescription.Height - 6
    $button_details.Tag = 'collapse'
    $button_details.Text = 'Show Details'
  }
}

function test_assert {
  $color = 'Red'
  assert -Script { ($color.IndexOf('Black') -gt -1) } -Message "Unexpected color: ${color}"
}

$text = 'This is a Lorem Ipsum test'
$description = "This is is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout."

$script:Result = ''
#  Show1 -Message 'This is a test'
Show2 -messageText "test" -messageTitle "title" -Description "description"

# Show3 -messageText $text -messageTitle "title" -icon 'Information' -Description $description -Btn 'AbortRetryIgnore' # 'RetryCancel' # 'YesNoCancel' # 'YesNo' 


Show3 -messageText $text -messageTitle "title" -IcOn 'Error' -Description $description -btn 'RetryCancel'
# test_assert


try {
  Get-Item -Path 'C:\NONE' -ErrorAction STOP

} catch [exception]{
  $action = show_exception -ex $_.Exception
  if ($action -ne 'Ignore') {
    throw $_.Exception
  }

}
return
