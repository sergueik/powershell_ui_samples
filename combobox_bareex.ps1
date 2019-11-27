#Copyright (c) 2019 Serguei Kouzmine
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

# http://www.cyberforum.ru/powershell/thread2530957.html
# https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.combobox.selectedindexchanged?view=netframework-4.5
# see also: http://www.cyberforum.ru/powershell/thread2538578.html
param(
  [switch]$dropdownlist,
  [switch]$debug
)

@( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }
$f = new-object System.Windows.Forms.Form
$f.AutoScaleBaseSize = new-object System.Drawing.Size (5,13)
$f.ClientSize = new-object System.Drawing.Size (438,158)
$f.SuspendLayout()

$c = new-object System.Windows.Forms.ComboBox

# toggle to observe modify some event processing
if ([bool]$PSBoundParameters['DropDownList'].IsPresent) {
  $c.DropDownStyle = 'DropDownList'
  $c.Text = ''
}
$c.DataSource = @('Sony','COWON','FiiO', 'iBasso')
$c.Location = new-object System.Drawing.Point (135,60)
$c.Name = 'comboBox'
$c.Size = new-object System.Drawing.Size (220,20)
$c.TabIndex = 0
$c.Font = new-object System.Drawing.Font('Microsoft Sans Serif',10,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)

$c.Add_TextChanged({ param([object]$s,[System.EventArgs]$e)
  $result = $s.Text
  write-host ('text changed {0}' -f $result )
})

$c.Add_KeyPress({  param([object]$s,[System.Windows.Forms.KeyPressEventArgs]$e)
  write-host ('key pressed {0}' -f $s.Text )
})
$c.Add_SelectedIndexChanged({ param([object]$s,[System.EventArgs]$e)
  write-host ('index changed {0} {1}' -f $s.SelectedIndex, $s.Text )
})


$f.Controls.AddRange(@( $c))
$f.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$f.MaximizeBox = $false
$f.MinimizeBox = $false
$f.Name = 'comboBoxDialog'
$f.ResumeLayout($false)
$f.Topmost = $true

$f.Add_Shown({ $f.Activate() })
# Clean up the control events
$form_closed_handler = [System.Windows.Forms.FormClosedEventHandler]{
  # borrowed from snippet generated by SAPIEN Technologies, Inc., PowerShell Studio
  param(
    [Object]$sender,
    [EventArgs]$eventargs
  )
  try
    {
      write-host 'remove all event handlers from the controls'
      # Does one really need to fully specify the event handler code for the second time here? Appears so:
      # System.Management.Automation.PSInvalidCastException Cannot convert the 'System.EventHandler' value of type 'System.EventHandler' to type 'System.Windows.Forms.KeyPressEventHandler'.
      # NOTE: can not specidy a no arg constructor: $c.remove_TextChanged( (new-object -typename 'System.EventHandler') )
      # System.Management.Automation.PSArgumentException: A constructor was not found. Cannot find an appropriate constructor for type System.EventHandler.
      $c.Remove_TextChanged( [System.EventHandler]{} )
      $c.Remove_KeyPress( [System.Windows.Forms.KeyPressEventHandler]{} )
      $c.Remove_SelectedIndexChanged( [System.EventHandler]{} )
      write-host 'remove self'
      $f.remove_FormClosed($form_closed_handler)
      write-host 'done.'
    } catch [exception]{
      # slurp the exception - debug code omitted
      $message = "EXCEPTION: $($_.Exception.GetType().FullName)"
      write-host $message
      write-host (($_.Exception.Message) -split "`n")[0]
    }
}
$f.add_FormClosed($form_closed_handler)
[void]$f.ShowDialog($null)

