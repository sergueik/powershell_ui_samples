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
# http://www.codeproject.com/Tips/827370/Custom-Message-Box-DLL
Add-Type -TypeDefinition @"

// "

/*
        private void btnDetails_click(object sender, EventArgs e)
        {
            if (btnDetails.Tag.ToString() == "col")
            {
                frm.Height = frm.Height + txtDescription.Height + 6;
                btnDetails.Tag = "exp";
                btnDetails.Text = "Hide Details";
                txtDescription.WordWrap = true;
                //txtDescription.Focus();
                //txtDescription.SelectionLength = 0;
            }
            else if (btnDetails.Tag.ToString() == "exp")
            {
                frm.Height = frm.Height - txtDescription.Height - 6;
                btnDetails.Tag = "col";
                btnDetails.Text = "Show Details";
            }
        }


*/
"@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Drawing.dll','System.Data.dll','System.ComponentModel.dll'


$MSGICON = @{

  'None' = 0;
  'Error' = 10;
  'Information' = 20;
  'Warning' = 30;
  'Question' = 40;

}

$MSGBUTTON = New-Object PSObject
$MSGBUTTON | Add-Member -NotePropertyName 'None' -NotePropertyValue 0
$MSGBUTTON | Add-Member -NotePropertyName 'OK' -NotePropertyValue 1
$MSGBUTTON | Add-Member -NotePropertyName 'YesNo' -NotePropertyValue 2
$MSGBUTTON | Add-Member -NotePropertyName 'YesNoCancel' -NotePropertyValue 3
$MSGBUTTON | Add-Member -NotePropertyName 'RetryCancle' -NotePropertyValue 4
$MSGBUTTON | Add-Member -NotePropertyName 'AbortRetryIgnore' -NotePropertyValue 5

$MSGRESPONSE =  New-Object PSObject
$MSGRESPONSE | Add-Member -NotePropertyName 'None' -NotePropertyValue 0
$MSGRESPONSE | Add-Member -NotePropertyName 'Yes' -NotePropertyValue 1
$MSGRESPONSE | Add-Member -NotePropertyName 'No' -NotePropertyValue 2
$MSGRESPONSE | Add-Member -NotePropertyName 'OK' -NotePropertyValue 3
$MSGRESPONSE | Add-Member -NotePropertyName 'Abort' -NotePropertyValue 4
$MSGRESPONSE | Add-Member -NotePropertyName 'Retry' -NotePropertyValue 5
$MSGRESPONSE | Add-Member -NotePropertyName 'Ignore' -NotePropertyValue 6
$MSGRESPONSE | Add-Member -NotePropertyName 'Cancel' -NotePropertyValue 7



function Return_Response
{
  param(
    [object]$sender,
    [System.EventArgs]$eventargs
  )

  [string ]$buttonText = ([System.Windows.Forms.Button]$sender[0]).Text

  if ($buttonText -eq "Yes")
  {
    $Global:response = $MSGRESPONSE.Yes
  }
  elseif ($buttonText -eq 'No')
  {
    $Global:response =  $MSGRESPONSE.No
  }
  elseif ($buttonText -eq "Cancel")
  {
    $Global:response =  $MSGRESPONSE.Cancel
  }
  elseif ($buttonText -eq "OK")
  {
    $Global:response =  $MSGRESPONSE.OK
  }
  elseif ($buttonText -eq "Abort")
  {
    $Global:response =  $MSGRESPONSE.Abort
  }
  elseif ($buttonText -eq 'Retry')
  {
    $Global:response =  $MSGRESPONSE.Retry
  }
  elseif ($buttonText -eq "Ignore")
  {
    $Global:response =  $MSGRESPONSE.Ignore
  }
  else
  {
    # $response  =  $response
  }
  write-host ('--->' + $Global:response )

  $frm.Dispose()
}


function AddButton {
  # 
  # AddButton -MSGBTN $MSGBUTTON.YesNoCancel
  param([psobject]$param)

  switch ($param) {
    ($MSGBUTTON.None) {
      $btnOK.Width = 80
      $btnOK.Height = 24
      $btnOK.Location = New-Object System.Drawing.Point (391,114)
      $btnOK.Text = 'OK'
      $formpanel.Controls.Add($btnOK)

      $btnOK_response =  $btnOK.add_Click
      $btnOK_Response.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          Return_Response ($sender,$eventargs)
        })

    }
    ($MSGBUTTON.OK) {
      $btnOK.Width = 80
      $btnOK.Height = 24
      $btnOK.Location = New-Object System.Drawing.Point (391,114)
      $btnOK.Text = 'OK'
      $formpanel.Controls.Add($btnOK)
      $btnOK_response =  $btnOK.add_Click
      $btnOK_Response.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          Return_Response ($sender,$eventargs)
        })


    }
    ($MSGBUTTON.YesNo) {
      # btNo
      $btnNo.Width = 80
      $btnNo.Height = 24
      $btnNo.Location = New-Object System.Drawing.Point (391,114)
      $btnNo.Text = "No"
      $formpanel.Controls.Add($btnNo)
      $btnNo_response =  $btnNo.add_Click
      $btnNo_Response.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          Return_Response ($sender,$eventargs)
        })
      # btnYes
      $btnYes.Width = 80
      $btnYes.Height = 24
      $btnYes.Location = New-Object System.Drawing.Point (($btnNo.Location.X - $btnNo.Width - 2),114)
      $btnYes.Text = "Yes"
      $formpanel.Controls.Add($btnYes)
      $btnYes_response =  $btnYes.add_Click
      $btnYes_Response.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          Return_Response ($sender,$eventargs)
        })
    }
    ($MSGBUTTON.YesNoCancel) {
      # btnCancle
      $btnCancel.Width = 80
      $btnCancel.Height = 24
      $btnCancel.Location = New-Object System.Drawing.Point (391,114)
      $btnCancel.Text = 'Cancel'
      $formpanel.Controls.Add($btnCancel)
      $btnCancel_response =  $btnCancel.add_Click
      $btnCancel_Response.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          Return_Response ($sender,$eventargs)
        })
      # btnNo
      $btnNo.Width = 80
      $btnNo.Height = 24
      $btnNo.Location = New-Object System.Drawing.Point (($btnCancel.Location.X - $btnCancel.Width - 2),114)
      $btnNo.Text = 'No'
      $formpanel.Controls.Add($btnNo)
      $btnNo_response =  $btnNo.add_Click
      $btnNo_Response.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          Return_Response ($sender,$eventargs)
        })
      # btnYes
      $btnYes.Width = 80
      $btnYes.Height = 24
      $btnYes.Location = New-Object System.Drawing.Point (($btnNo.Location.X - $btnNo.Width - 2),114)
      $btnYes.Text = 'Yes'
      $formpanel.Controls.Add($btnYes)
      $btnYes_Response.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          Return_Response ($sender,$eventargs)
        })
    }
    ($MSGBUTTON.RetryCancle) {
      # button cancel
      $btnCancel.Width = 80
      $btnCancel.Height = 24
      $btnCancel.Location = New-Object System.Drawing.Point (391,114)
      $btnCancel.Text = 'Cancel'
      $formpanel.Controls.Add($btnCancel)
      $btnCancel_response =  $btnCancel.add_Click
      $btnCancel_Response.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          Return_Response ($sender,$eventargs)
        })
      #button Retry
      $btnRetry.Width = 80
      $btnRetry.Height = 24
      $btnRetry.Location = New-Object System.Drawing.Point (($btnCancel.Location.X - $btnCancel.Width - 2),114)
      $btnRetry.Text = 'Retry'
      $formpanel.Controls.Add($btnRetry)
      $btnRetry_response =  $btnRetry.add_Click
      $btnRetry_Response.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          Return_Response ($sender,$eventargs)
        })

    }
    ($MSGBUTTON.AbortRetryIgnore) {
      #button Ignore
      $btnIgnore.Width = 80
      $btnIgnore.Height = 24
      $btnIgnore.Location = New-Object System.Drawing.Point (391,114)
      $btnIgnore.Text = 'Ignore'
      $formpanel.Controls.Add($btnIgnore)
      $btnIgnore_response =  $btnIgnore.add_Click
      $btnIgnore_Response.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          Return_Response ($sender,$eventargs)
        })
      #button Retry
      $btnRetry.Width = 80
      $btnRetry.Height = 24
      $btnRetry.Location = New-Object System.Drawing.Point (($btnIgnore.Location.X - $btnIgnore.Width - 2),114)
      $btnRetry.Text = 'Retry'
      $formpanel.Controls.Add($btnRetry)
      $btnRetry_response =  $btnRetry.add_Click
      $btnRetry_Response.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          Return_Response ($sender,$eventargs)
        })
      #button Abort
      $btnAbort.Width = 80
      $btnAbort.Height = 24
      $btnAbort.Location = New-Object System.Drawing.Point (($btnRetry.Location.X - $btnRetry.Width - 2),114)
      $btnAbort.Text = 'Abort'
      $formpanel.Controls.Add($btnAbort)
      $btnAbort_response =  $btnAbort.add_Click
      $btnAbort_Response.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          Return_Response ($sender,$eventargs)
        })
    }
    default {}
  }

}


function AddIconImage {
  param([psobject]$param)

  switch ($param)
  {
    ($MSGICON.Error) {
      $icnPicture.Image = ([System.Drawing.SystemIcons]::Error).ToBitmap()
    }
    ($MSGICON.Information) {

      $icnPicture.Image = ([System.Drawing.SystemIcons]::Information).ToBitmap()
    }
    ($MSGICON.Question) {
      $icnPicture.Image = ([System.Drawing.SystemIcons]::Question).ToBitmap()
    }
    ($MSGICON.Warning) {
      $icnPicture.Image = ([System.Drawing.SystemIcons]::Warning).ToBitmap()
    }
    default {
      $icnPicture.Image = ([System.Drawing.SystemIcons]::Information).ToBitmap()
    }
  }

}


function btnDetails_click
{

  param(
     [object]$sender,
     [System.EventArgs]$eventArgs
   )
  if ($btnDetails.Tag.ToString() -match "col")
  {
    $frm.Height = $frm.Height + $txtDescription.Height + 6
    $btnDetails.Tag = "exp"
    $btnDetails.Text = "Hide Details"
    $txtDescription.WordWrap = true
    # txtDescription.Focus();
    # txtDescription.SelectionLength = 0;
  }
  elseif ($btnDetails.Tag.ToString() -match "exp")
  {
    $frm.Height = $frm.Height - $txtDescription.Height - 6
    $btnDetails.Tag = "col"
    $btnDetails.Text = "Show Details"
  }
}
function SetMessageText
{
  param(
    [string]$messageText,
    [string]$Title,
    [string]$Description
  )
  $lblmessage.Text = $messageText
  if (($Description -ne $null) -and ($Description -ne ''))
  {
    $txtDescription.Text = $Description
  }
  else
  {
    $btnDetails.Visible = $false
  }
  if (($Title -ne $null) -and ($Title -ne ''))
  {
    $frm.Text = $Title
  }
  else
  {
    $frm.Text = 'Your Message Box From DLL'
  }
}

function Show1
{
  param(
    [string]$messageText
  )

  [void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
  [void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')

  $frm = New-Object System.Windows.Forms.Form
  $btnDetails = New-Object System.Windows.Forms.Button
  $btnOK = New-Object System.Windows.Forms.Button
  $btnYes = New-Object System.Windows.Forms.Button
  $btnNo = New-Object System.Windows.Forms.Button
  $btnCancel = New-Object System.Windows.Forms.Button
  $btnAbort = New-Object System.Windows.Forms.Button
  $btnRetry = New-Object System.Windows.Forms.Button
  $btnIgnore = New-Object System.Windows.Forms.Button
  $txtDescription = New-Object System.Windows.Forms.TextBox
  $icnPicture = New-Object System.Windows.Forms.PictureBox
  $formpanel = New-Object System.Windows.Forms.Panel
  $lblmessage = New-Object System.Windows.Forms.Label
  # static MSGRESPONSE $response =  new MSGRESPONSE()
  SetMessageText $messageText '' $null
  AddIconImage -param $MSGICON.Information
  AddButton -param $MSGBUTTON.OK
  DrawBox
  $frm.ShowDialog()
  return $response

}

function Show2
{
  param(
    [string]$messageText,
    [string]$messageTitle,
    [string]$description
  )

  [void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
  [void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')

  $frm = New-Object System.Windows.Forms.Form
  $btnDetails = New-Object System.Windows.Forms.Button
  $btnOK = New-Object System.Windows.Forms.Button
  $btnYes = New-Object System.Windows.Forms.Button
  $btnNo = New-Object System.Windows.Forms.Button
  $btnCancel = New-Object System.Windows.Forms.Button
  $btnAbort = New-Object System.Windows.Forms.Button
  $btnRetry = New-Object System.Windows.Forms.Button
  $btnIgnore = New-Object System.Windows.Forms.Button
  $txtDescription = New-Object System.Windows.Forms.TextBox
  $icnPicture = New-Object System.Windows.Forms.PictureBox
  $formpanel = New-Object System.Windows.Forms.Panel
  $lblmessage = New-Object System.Windows.Forms.Label
  # static MSGRESPONSE $response =  new MSGRESPONSE()
  SetMessageText $messageText $messageTitle $description
  AddIconImage -param $MSGICON.Information
  AddButton -param $MSGBUTTON.OK
  DrawBox
  $frm.ShowDialog()
  return $response

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

  [void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
  [void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')

  $frm = New-Object System.Windows.Forms.Form
  $btnDetails = New-Object System.Windows.Forms.Button
  $btnOK = New-Object System.Windows.Forms.Button
  $btnYes = New-Object System.Windows.Forms.Button
  $btnNo = New-Object System.Windows.Forms.Button
  $btnCancel = New-Object System.Windows.Forms.Button
  $btnAbort = New-Object System.Windows.Forms.Button
  $btnRetry = New-Object System.Windows.Forms.Button
  $btnIgnore = New-Object System.Windows.Forms.Button
  $txtDescription = New-Object System.Windows.Forms.TextBox
  $icnPicture = New-Object System.Windows.Forms.PictureBox
  $formpanel = New-Object System.Windows.Forms.Panel
  $lblmessage = New-Object System.Windows.Forms.Label
  # static MSGRESPONSE $response =  new MSGRESPONSE()


  SetMessageText $messageText $messageTitle $description
  # // frmMessage.Text = messageTitle;
  AddIconImage -param $IcOn
  AddButton -param $btn
  DrawBox
  $frm.ShowDialog()
  # return $response

}

function ShowException
{
  param([System.Exception]$ex)


  [void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
  [void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')

  $frm = New-Object System.Windows.Forms.Form
  $btnDetails = New-Object System.Windows.Forms.Button
  $btnOK = New-Object System.Windows.Forms.Button
  $btnYes = New-Object System.Windows.Forms.Button
  $btnNo = New-Object System.Windows.Forms.Button
  $btnCancel = New-Object System.Windows.Forms.Button
  $btnAbort = New-Object System.Windows.Forms.Button
  $btnRetry = New-Object System.Windows.Forms.Button
  $btnIgnore = New-Object System.Windows.Forms.Button
  $txtDescription = New-Object System.Windows.Forms.TextBox
  $icnPicture = New-Object System.Windows.Forms.PictureBox
  $formpanel = New-Object System.Windows.Forms.Panel
  $lblmessage = New-Object System.Windows.Forms.Label
  # static MSGRESPONSE $response =  new MSGRESPONSE();
  $Global:response =  $MSGRESPONSE.Cancel
  SetMessageText $ex.Message $ex.Message $ex.StackTrace
  # //frmMessage.Text = messageTitle
  AddIconImage -param MSGICON.Error
  AddButton -param MSGBUTTON.OK
  DrawBox
  $frm.ShowDialog()
  return $response

}


# AddIconImage -param $MSGICON.Information

function DrawBox
{
  # draw panel
  $frm.Controls.Add($formpanel)
  $formpanel.Dock = [System.Windows.Forms.DockStyle]::Fill
  # draw picturebox
  $icnPicture.Height = 36
  $icnPicture.Width = 40
  $icnPicture.Location = New-Object System.Drawing.Point (10,11)
  $formpanel.Controls.Add($icnPicture)
  # drawing textbox
  $txtDescription.Multiline = $true
  $txtDescription.Height = 183
  $txtDescription.Width = 464
  $txtDescription.Location = New-Object System.Drawing.Point (6,143)
  $txtDescription.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
  $txtDescription.ScrollBars = [System.Windows.Forms.ScrollBars]::Both
  $txtDescription.ReadOnly = $true
  $formpanel.Controls.Add($txtDescription)

  # drawing detail button
  $btnDetails.Height = 24
  $btnDetails.Width = 80
  $btnDetails.Location = New-Object System.Drawing.Point (6,114)
  $btnDetails.Tag = "exp"
  $btnDetails.Text = "Show Details"
  $formpanel.Controls.Add($btnDetails)
      $btnDetails_response =  $btnDetails.add_Click
      $btnDetails_Response.Invoke({
          param(
            [object]$sender,
            [System.EventArgs]$eventargs
          )
          btnDetails_click ($sender,$eventargs)
        })



  $lblmessage.Location = New-Object System.Drawing.Point (64,22)
  $lblmessage.AutoSize = $true
  $formpanel.Controls.Add($lblmessage)
  $frm.Height = 360
  $frm.Width = 483

  # set form layout
  $frm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
  $frm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
  $frm.MaximizeBox = $false
  $frm.MinimizeBox = $false
  ## frm.FormClosing += new FormClosingEventHandler(frm_FormClosing);
  $frm.BackColor = [System.Drawing.SystemColors]::ButtonFace

  ##//http://www.iconarchive.com/search?q=ico+files&page=7
  [string]$p = "C:\developer\sergueik\powershell_ui_samples\external\Martz90-Circle-Files.ico"
  $frm.Icon = New-Object System.Drawing.Icon ($p)
  if ($btnDetails.Tag.ToString() -match "exp")
  {
    $frm.Height = $frm.Height - $txtDescription.Height - 6
    $btnDetails.Tag = "col"
    $btnDetails.Text = "Show Details"
  }
}

$text = "this is a Lorem Ipsum test"
$description = "This is is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout."
# Show1 -Message "test"
# Show2 -messageText "test" -messageTitle "title" -Description "description"

Show3 -messageText $text -messageTitle "title" -icon $MSGICON.Error -Description $description -Btn $MSGBUTTON.AbortRetryIgnore # $MSGBUTTON.RetryCancle # $MSGBUTTON.YesNoCancel # $MSGBUTTON.YesNo 