# origin: http://poshcode.org/6223
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Move-MouseDown
{
    $global:mCurFirstX = ([System.Windows.Forms.Cursor]::Position.X )
    $global:mCurFirstY = ([System.Windows.Forms.Cursor]::Position.Y )
}

function Move-Mouse ($mControlName)
{
    $mCurMoveX = ([System.Windows.Forms.Cursor]::Position.X )
    $mCurMoveY = ([System.Windows.Forms.Cursor]::Position.Y )

    if ($global:mCurFirstX -ne 0 -and $global:mCurFirstY -ne 0){

        $mDifX = $global:mCurFirstX - $mCurMoveX
        $mDifY = $global:mCurFirstY - $mCurMoveY

        $this.Left = $this.Left - $mDifX
        $this.Top  = $this.Top  - $mDifY

        $global:mCurFirstX = $mCurMoveX
        $global:mCurFirstY = $mCurMoveY
    }
}

function Move-MouseUp ($mControlObj)
{
    $mCurUpX = ([System.Windows.Forms.Cursor]::Position.X )
    $mCurUpY = ([System.Windows.Forms.Cursor]::Position.Y )

    $global:mCurFirstX = 0
    $global:mCurFirstY = 0

    foreach ($mElement in $global:mFormObj.Elements)
    {
        if ($mElement.Name -eq $this.Name)
        {
            foreach($mProp in $mElement.Properties)
            {
                switch ($mProp.Name)
                {
                    'Top' { $mProp.Value = $this.Top  }
                    'Left'{ $mProp.Value = $this.Left }
                }
            }
        }
    }

    Update-Grid
}

function Update-Grid
{
    $mList = New-Object System.Collections.ArrayList
    [array]$mElementsArr = $mFormObj.Elements | Select-Object -Property Name,Type
    $mList.AddRange($mElementsArr)
    $mElemetnsGrid.DataSource = $mList
    $mElemetnsGrid.Columns[1].ReadOnly = $true

    $mList2 = New-Object System.Collections.ArrayList
    [array]$mPropertyArr = $mFormObj.Elements[$mElemetnsGrid.CurrentRow.Index].Properties
    $mList2.AddRange($mPropertyArr)
    $mPropertiesGrid.DataSource = $mList2
    $mPropertiesGrid.Columns[0].ReadOnly = $true
}

function Delete-Element
{
    $global:mFormObj.Elements = $mFormObj.Elements |
        Where-Object {$_.Name -notlike $mFormObj.Elements[$mElemetnsGrid.CurrentRow.Index].Name}

    Update-Grid
}

function Add-Property ($mName,$mValue)
{
    $mPropertyObj = New-Object PSCustomObject
    $mPropertyObj | Add-Member -Name 'Name'  -MemberType NoteProperty -Value $mName
    $mPropertyObj | Add-Member -Name 'Value' -MemberType NoteProperty -Value $mValue

    return $mPropertyObj
}

function Update-Element
{
    $mList2 = New-Object System.Collections.ArrayList
    [array]$mPropertyArr =  $mFormObj.Elements[$mElemetnsGrid.CurrentRow.Index].Properties
    $mList2.AddRange($mPropertyArr)
    $mPropertiesGrid.DataSource = $mList2
}

function Edit-Element
{
    $global:mFormObj.Elements[$mElemetnsGrid.CurrentRow.Index].Name = $mElemetnsGrid.CurrentCell.FormattedValue

    Update-Form
}

function Add-Element
{
    $mPropertiesArr = @()
    $mSameType = ($mFormObj.Elements | Where-Object {$_.Type -like $mControlType.SelectedItem})

    if ($mSameType.count -ne $NUll -and $mSameType -ne $null)
    {
        $mControlName = '' + $mControlType.SelectedItem + ($mSameType.count+1)
    }
    elseif ($mSameType.Count -eq $null -and $mSameType -ne $null)
    {
        $mControlName = '' + $mControlType.SelectedItem + '2'
    }
    else
    {
        $mControlName = '' + $mControlType.SelectedItem + '1'
    }

    $mPropertiesArr += Add-Property 'Text' $mControlName
    $mPropertiesArr += Add-Property 'SizeX' 100
    $mPropertiesArr += Add-Property 'SizeY' 23
    $mPropertiesArr += Add-Property 'Top' 5
    $mPropertiesArr += Add-Property 'Left' 5
    $mPropertiesArr += Add-Property 'Anchor' 'Left,Top'

    $mElementsObj = New-Object PSCustomObject
    $mElementsObj | Add-Member -Name 'Name' -MemberType NoteProperty -Value $mControlName
    $mElementsObj | Add-Member -Name 'Type' -MemberType NoteProperty -Value ($mControlType.SelectedItem)
    $mElementsObj | Add-Member -Name 'Properties' -MemberType NoteProperty -Value $mPropertiesArr
    $global:mFormObj.Elements += $mElementsObj

    Update-Grid
    Update-Form
}

function Add-Control ($mControl)
{
    $mReturnControl = $null

    switch ($mControl.Type)
    {
        "TextBox"        { $mReturnControl = New-Object System.Windows.Forms.TextBox        }
        "ListBox"        { $mReturnControl = New-Object System.Windows.Forms.ListBox        }
        "ComboBoX"       { $mReturnControl = New-Object System.Windows.Forms.ComboBox       }
        "Label"          { $mReturnControl = New-Object System.Windows.Forms.Label          }
        "DataGrid"       { $mReturnControl = New-Object System.Windows.Forms.DataGridView   }
        "Button"         { $mReturnControl = New-Object System.Windows.Forms.Button         }
        'CheckBox'       { $mReturnControl = New-Object System.Windows.Forms.CheckBox       }
        'DateTimePicker' { $mReturnControl = New-Object System.Windows.Forms.DateTimePicker }
        'ListView'       { $mReturnControl = New-Object System.Windows.Forms.ListView       }
        'PictureBox'     { $mReturnControl = New-Object System.Windows.Forms.PictureBox     }
        'RichTextBox'    { $mReturnControl = New-Object System.Windows.Forms.RichTextBox    }
        'TreeView'       { $mReturnControl = New-Object System.Windows.Forms.TreeView       }
        'WebBrowser'     { $mReturnControl = New-Object System.Windows.Forms.WebBrowser     }
        "default"        { Write-Host 'something goes wrong sorry :('                       }
    }

    $mReturnControl.Name = $mControl.Name

    $mSizeX = $null
    $mSizeY = $null

    foreach ($mProperty in $mControl.Properties)
    {
        switch ($mProperty.Name)
        {
            'Text'  { $mReturnControl.Text = $mProperty.Value   }
            'SizeX' { $mSizeX = $mProperty.Value                }
            'SizeY' { $mSizeY = $mProperty.Value                }
            'Top'   { $mReturnControl.Top = $mProperty.Value    }
            'Left'  { $mReturnControl.Left = $mProperty.Value   }
            'Anchor'{ $mReturnControl.Anchor = $mProperty.Value }
        }
    }

    $mReturnControl.Size = New-Object System.Drawing.Size($mSizeX,$mSizeY)
    $mReturnControl.Add_MouseDown({Move-MouseDown})
    $mReturnControl.Add_MouseMove({Move-Mouse ($mControl.Name)})
    $mReturnControl.Add_MouseUP({Move-MouseUp})

    return $mReturnControl
}

function Edit-Property
{
    foreach ($mProperty in $global:mFormObj.Elements[$mElemetnsGrid.CurrentRow.Index].Properties)
    {
        if ($mProperty.Name -eq $mPropertiesGrid.CurrentRow.Cells[0].FormattedValue)
        {
            $mProperty.Value = $mPropertiesGrid.CurrentRow.Cells[1].FormattedValue
        }
    }

    Update-Form
}


function Update-Form
{
    $mFormGroupBox.Size = New-Object System.Drawing.Size(($mFormObj.SizeX),($mFormObj.SizeY))
    $mFormGroupBox.Controls.Clear()

    foreach ($mElement in $mFormObj.Elements)
    {
        $mFormGroupBox.Controls.Add((Add-Control $mElement))
    }
}

function Edit-FormSize ($x,$y)
{
    $global:mFormObj.SizeX = $X
    $global:mFormObj.SizeY = $Y

    Update-Form
}


function Export-Form
{
    $mFormObj
    $mExportString = "
    "
    $mExportString+= '
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    $MyForm = New-Object System.Windows.Forms.Form
    $MyForm.Text="MyForm"
    $MyForm.Size = New-Object System.Drawing.Size('+$mFormObj.SizeX+','+$mFormObj.SizeY+')
    '
    foreach ($mElement in $mFormObj.Elements)
    {
        $mExportString += '

        $m' + $mElement.Name + ' = New-Object System.Windows.Forms.'+$mElement.Type+''
        $mPrSizeX=''
        $mPrSizeY=''

        foreach ($mProperty in $mElement.Properties)
        {
            if ($mProperty.Name -eq 'SizeX')
            {
                $mPrSizeX = $mProperty.Value
            }
            elseIf ($mProperty.Name -eq 'SizeY')
            {
                $mPrSizeY = $mProperty.Value
            }
            else
            {
                $mExportString += '
                $m'+$mElement.Name+'.'+$mProperty.Name +'="'+$mProperty.Value+'"'
            }
        }

        $mExportString += '
        $m'+$mElement.Name+'.Size = New-Object System.Drawing.Size('+$mPrSizeX+','+$mPrSizeY+')
        $MyForm.Controls.Add($m'+$mElement.Name+')
        '
    }

    $mExportString+= '$MyForm.ShowDialog()'

    $mFileName=''
    $mFileName = Get-Filename 'C:\'
    if ($mFileName -notlike '')
    {
        $mExportString > $mFileName
    }
}

function Get-FileName($initialDirectory)
{
    $SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $SaveFileDialog.InitialDirectory = $initialDirectory
    $SaveFileDialog.Filter = “Powershell Script (*.ps1)|*.ps1|All files (*.*)|*.*”
    $SaveFileDialog.ShowDialog() | Out-Null
    $SaveFileDialog.Filename
}


$mForm = New-Object System.Windows.Forms.Form
$mForm.Size = New-Object System.Drawing.Size(400,403)
$mForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
$mForm.AutoSize = $true
$mForm.Text = 'FormsMaker'

$mControlType = New-Object System.Windows.Forms.ComboBoX
$mControlType.Anchor = 'Left,Top'
$mControlType.Size = New-Object System.Drawing.Size(100,23)
$mControlType.Left = 5
$mControlType.Top = 5
$mControlType.Items.Add("TextBox")        | Out-Null
$mControlType.Items.Add("ListBox")        | Out-Null
$mControlType.Items.Add("ComboBoX")       | Out-Null
$mControlType.Items.Add("Label")          | Out-Null
$mControlType.Items.Add("DataGrid")       | Out-Null
$mControlType.Items.Add("Button")         | Out-Null
$mControlType.Items.Add("CheckBox")       | Out-Null
$mControlType.Items.Add("DateTimePicker") | Out-Null
$mControlType.Items.Add("ListView")       | Out-Null
$mControlType.Items.Add("PictureBox")     | Out-Null
$mControlType.Items.Add("RichTextBox")    | Out-Null
$mControlType.Items.Add("TreeView")       | Out-Null
$mControlType.Items.Add("WebBrowser")     | Out-Null
$mForm.Controls.Add($mControlType)

$mAddButton = New-Object System.Windows.Forms.Button
$mAddButton.Anchor = 'Left,Top'
$mAddButton.Text = 'Add'
$mAddButton.Left = 110
$mAddButton.Top = 5
$mAddButton.Size = New-Object System.Drawing.Size(50,23)
$mAddButton.Add_Click({Add-Element})
$mForm.Controls.Add($mAddButton)

$mFormLabel = New-Object System.Windows.Forms.Label
$mFormLabel.Text = 'Form Size:'
$mFormLabel.Top = 5
$mFormLabel.Left = 165
$mFormLabel.Anchor = 'Left,Top'
$mFormLabel.Size = New-Object System.Drawing.Size(80,23)
$mFormLabel.TextAlign = 'MiddleRight'
$mForm.Controls.Add($mFormLabel)

$mFormXTextBox = New-Object System.Windows.Forms.TextBox
$mFormXTextBox.Left = 250
$mFormXTextBox.Top = 5
$mFormXTextBox.Size = New-Object System.Drawing.Size(30,23)
$mFormXTextBox.Anchor = 'Left,Top'
$mFormXTextBox.Text = 300
$mForm.Controls.Add($mFormXTextBox)

$mFormXLabel = New-Object System.Windows.Forms.Label
$mFormXLabel.Text = 'X'
$mFormXLabel.Top = 5
$mFormXLabel.Left = 280
$mFormXLabel.Anchor = 'Left,Top'
$mFormXLabel.Size = New-Object System.Drawing.Size(20,23)
$mFormXLabel.TextAlign = 'MiddleCenter'
$mFormXTextBox.Add_TextChanged({Edit-FormSize $mFormXTextBox.Text $mFormYTextBox.Text })
$mForm.Controls.Add($mFormXLabel)

$mFormYTextBox = New-Object System.Windows.Forms.TextBox
$mFormYTextBox.Left = 300
$mFormYTextBox.Top = 5
$mFormYTextBox.Size = New-Object System.Drawing.Size(30,23)
$mFormYTextBox.Anchor = 'Left,Top'
$mFormYTextBox.Text = 300
$mFormYTextBox.Add_TextChanged({Edit-FormSize $mFormXTextBox.Text $mFormYTextBox.Text})
$mForm.Controls.Add($mFormYTextBox)

$mFormGroupBox = New-Object System.Windows.Forms.GroupBox
$mFormGroupBox.Left = 350
$mFormGroupBox.Top = 5
$mFormGroupBox.Anchor = 'Left,Top'
$mFormGroupBox.Size = New-Object System.Drawing.Size($mFormXTextBox.Text,$mFormYTextBox.Text)
$mFormGroupBox.Text = 'New Form'
$mForm.Controls.Add($mFormGroupBox)

$mElemetnsGrid = New-Object System.Windows.Forms.DataGridView
$mElemetnsGrid.Size = New-Object System.Drawing.Size(155,400)
$mElemetnsGrid.Left = 5
$mElemetnsGrid.Top = 33
$mElemetnsGrid.Anchor = 'Top,Left'
$mElemetnsGrid.RowHeadersVisible =$false
$mElemetnsGrid.Add_CellContentClick({Update-Element})
$mElemetnsGrid.Add_CellEndEdit({Edit-Element})
$mForm.Controls.Add($mElemetnsGrid)

$mPropertiesGrid = New-Object System.Windows.Forms.DataGridView
$mPropertiesGrid.Size = New-Object System.Drawing.Size(155,400)
$mPropertiesGrid.Left = 180
$mPropertiesGrid.Top = 33
$mPropertiesGrid.Anchor = 'Top,Left'
$mPropertiesGrid.ColumnHeadersVisible=$true
$mPropertiesGrid.RowHeadersVisible =$false
$mPropertiesGrid.Add_CellEndEdit({Edit-Property})
$mForm.Controls.Add($mPropertiesGrid)

$mDeleteButton = New-Object System.Windows.Forms.Button
$mDeleteButton.Size = New-Object System.Drawing.Size(155,23)
$mDeleteButton.Text = 'Delete'
$mDeleteButton.Left = 5
$mDeleteButton.Top = 438
$mDeleteButton.Anchor = 'Top,Left'
$mDeleteButton.Add_Click({Delete-Element})
$mForm.Controls.Add($mDeleteButton)

$mExportButton = New-Object System.Windows.Forms.Button
$mExportButton.Size = New-Object System.Drawing.Size(155,23)
$mExportButton.Text = 'Export'
$mExportButton.Left = 180
$mExportButton.Top = 438
$mExportButton.Anchor='Top,Left'
$mExportButton.Add_Click({Export-Form})
$mForm.Controls.Add($mExportButton)

$global:mFormObj = New-Object PSCustomObject
$global:mFormObj | Add-Member -Name 'SizeX'    -MemberType NoteProperty -Value 300
$global:mFormObj | Add-Member -Name 'SizeY'    -MemberType NoteProperty -Value 300
$global:mFormObj | Add-Member -Name 'Elements' -MemberType NoteProperty -Value @()
$global:mCurFirstX = 0
$global:mCurFirstY = 0

$mForm.ShowDialog() | Out-Null
$mForm.Dispose()