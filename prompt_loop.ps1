#Copyright (c) 2021 Serguei Kouzmine
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

Add-Type -TypeDefinition @"

using System;
using System.Drawing;
using System.Windows.Forms;

public class TimerPanel : Panel
{
    private System.Timers.Timer _timer;
    private System.ComponentModel.Container components = null;
    public System.Timers.Timer Timer
    {
        get
        {
            return _timer;
        }
        set { _timer = value; }
    }


    public TimerPanel()
    {
        InitializeComponent();
    }

    protected override void Dispose(bool disposing)
    {
        if (disposing)
        {
            if (components != null)
            {
                components.Dispose();
            }
        }
        _timer.Stop();
        base.Dispose(disposing);
    }

    private void InitializeComponent()
    {
        this._timer = new System.Timers.Timer();
        ((System.ComponentModel.ISupportInitialize)(this._timer)).BeginInit();
        this.SuspendLayout();
        this._timer.Interval = 1000;
        this._timer.Start();
        this._timer.Enabled = true;
        this._timer.SynchronizingObject = this;
        this._timer.Elapsed += new System.Timers.ElapsedEventHandler(this.OnTimerElapsed);
        ((System.ComponentModel.ISupportInitialize)(this._timer)).EndInit();
        this.ResumeLayout(false);

    }

    private void OnTimerElapsed(object sender, System.Timers.ElapsedEventArgs e)
    {
        // Console.WriteLine(".");
    }

}
"@ -ReferencedAssemblies 'System.Windows.Forms.dll'

$RESULT_OK = 0
$RESULT_CANCEL = 1
$RESULT_TIMEOUT = 2

$Readable = @{
  $RESULT_OK = 'OK';
  $RESULT_CANCEL = 'CANCEL';
  $RESULT_TIMEOUT = 'TIMEOUT';
}

function PromptAuto {

  param(
    [string]$title,
    [string]$message,
    [object]$caller
  )


  @( 'System.Drawing','System.Windows.Forms') | ForEach-Object { [void][System.Reflection.Assembly]::LoadWithPartialName($_) }

  $f = new-object System.Windows.Forms.Form
  $f.Text = $title

  $f.Size = new-object System.Drawing.Size (340,290)

  $p = new-object TimerPanel
  $p.Size = $f.Size


  $l1 = new-object System.Windows.Forms.Label
  $l1.Location = new-object System.Drawing.Size (10,20)
  $l1.Size = new-object System.Drawing.Size (100,20)
  $l1.Text = 'Username'
  $p.Controls.Add($l1)

  $f.Font = new-object System.Drawing.Font ('Microsoft Sans Serif',10,[System.Drawing.FontStyle]::Regular,[System.Drawing.GraphicsUnit]::Point,0)
  # alternatively just
  $l1.Font = 'Microsoft Sans Serif,10'
  $t1 = new-object System.Windows.Forms.TextBox
  $t1.Location = new-object System.Drawing.Point (120,20)
  $t1.Size = new-object System.Drawing.Size (190,20)
  if (($caller.txtUser -eq $null) -or ( $caller.txtUser -eq '')) {
    $t1.Text = $env:USERNAME
  } else {
    $t1.Text = $caller.txtUser
  }
  $t1.Name = 'txtUser'
  $p.Controls.Add($t1)

  $l2 = new-object System.Windows.Forms.Label
  $l2.Location = new-object System.Drawing.Size (10,50)
  $l2.Size = new-object System.Drawing.Size (100,20)
  $l2.Text = 'Password'
  $p.Controls.Add($l2)

  $t2 = new-object System.Windows.Forms.TextBox
  $t2.Location = new-object System.Drawing.Point (120,50)
  $t2.Size = new-object System.Drawing.Size (190,20)
  $t2.Text = $caller.txtPassword
  $t2.Name = 'txtPassword'
  $t2.PasswordChar = '*'
  $p.Controls.Add($t2)

  $f.StartPosition = 'CenterScreen'

  $f.KeyPreview = $True
  $f.Add_KeyDown({

      if ($_.KeyCode -eq 'O') { $caller.Data = $RESULT_OK }
      elseif ($_.KeyCode -eq 'Escape') { $caller.Data = $RESULT_CANCEL }
      else { return }
      $f.Close()

    })

  $button_ok = new-object System.Windows.Forms.Button
  $button_ok.Font = new-object System.Drawing.Font ('Arial',10,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,0)
  $button_ok.Location = new-object System.Drawing.Size (50,110)
  $button_ok.Size = new-object System.Drawing.Size (75,23)
  $button_ok.Text = 'OK'
  $button_ok.add_click({
    $caller.Data = $RESULT_OK
    $caller.txtPassword = $t2.Text
    $caller.txtUser = $t1.Text
    $f.Close()
  })

  $p.Controls.Add($button_ok)
  $end = (Get-Date -UFormat '%s')
  $end = ([int]$end + 60)
  $button_cancel = new-object System.Windows.Forms.Button
  $button_cancel.Font = new-object System.Drawing.Font ('Arial',10,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,0)
  $button_cancel.Location = new-object System.Drawing.Size (130,110)
  $button_cancel.Size = new-object System.Drawing.Size (75,23)
  $button_cancel.Text = 'Cancel'
  $button_cancel.add_click({
    $caller.txtPassword = $null
    $caller.txtUser = $null
    $f.Close()
  })
  $p.Controls.Add($button_cancel)

  $l = new-object System.Windows.Forms.Label
  $l.Font = new-object System.Drawing.Font ('Arial',7,[System.Drawing.FontStyle]::Bold,[System.Drawing.GraphicsUnit]::Point,0)
  $l.Location = new-object System.Drawing.Size (10,80)
  $l.Size = new-object System.Drawing.Size (280,20)
  if ($message -eq $null) {
    $l.Text = ' '
  } else {
    $l.Text = $message
  }
  $p.Controls.Add($l)

  $checkBox1 = new-object System.Windows.Forms.CheckBox
  $checkBox2 = new-object System.Windows.Forms.CheckBox
  $groupBox1 = new-object System.Windows.Forms.GroupBox
  $groupBox1.Controls.AddRange( @(  $checkBox1, $checkBox2))
  $groupBox1.Location = new-object System.Drawing.Point(8, 140)
  $groupBox1.Name = 'groupBox1'
  $groupBox1.Size = new-object System.Drawing.Size(320, 80)
  $groupBox1.TabIndex = 1
  $groupBox1.TabStop = $false
  $groupBox1.Text = 'execution options'
  $checkBox1.add_CheckedChanged({
    $caller.Continue = $checkbox1.Checked
  })
  $checkBox1.Location = new-object System.Drawing.Point(16, 16)
  $checkBox1.Name = 'checkBox1'
  $checkBox1.TabIndex = 1
  $checkBox1.Text = 'Continue'
  $checkbox1.Checked = $caller.Continue

  # checkBox2

  $checkBox2.Location = new-object System.Drawing.Point(16, 48)
  $checkBox2.Name = 'checkBox2'
  $checkBox2.TabIndex = 2
  $checkBox2.Text = 'Record'
  $checkbox2.Enabled = $false
  $p.Controls.Add($groupBox1)


  $p.Timer.Stop()
  $p.Timer.Interval = 5000
  $p.Timer.Start()
  $p.Timer.add_Elapsed({
      $start = (Get-Date -UFormat '%s')

      $elapsed = New-TimeSpan -Seconds ($end - $start)
      $l.Text = ('Remaining time {0:00}:{1:00}:{2:00}' -f $elapsed.Hours,$elapsed.Minutes,$elapsed.Seconds,($end - $start))

      if ($end - $start -lt 0) {
        $caller.Data = $RESULT_TIMEOUT
        $f.Close()
      }

    })
  $f.Controls.Add($p)
  $f.Topmost = $True

  $caller.Data = $RESULT_TIMEOUT

  $f.Add_Shown({

    $caller.Data = $RESULT_CANCEL
    if ($caller.txtPassword -eq $null) {
      $f.ActiveControl = $t2
    }
    $f.Activate()
  })


  [void]$f.ShowDialog([System.Windows.Forms.IWin32Window]($caller))
  $f.Dispose()
}

$caller_class = 'Win32Window_2'
Add-Type -TypeDefinition @"

using System;
using System.Windows.Forms;
public class ${caller_class}: IWin32Window
{
    private IntPtr _hWnd;
    private int _data;
    private bool _continue;
    private string _txtUser;
    private string _txtPassword;

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

    public int Data
    {
        get { return _data; }
        set { _data = value; }
    }

    public bool Continue
    {
        get { return _continue; }
        set { _continue = value; }
    }

    public ${caller_class}(IntPtr handle)
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


$DebugPreference = 'Continue'
$title = 'Repeated Prompt with Timeout'
$message = 'Continue ?'
$window_handle = [System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle
if ($window_handle -eq 0) {
  $processid = [System.Diagnostics.Process]::GetCurrentProcess().Id
  $parent_process_id = get-wmiobject win32_process | where-object {$_.processid -eq  $processid } | select-object -expandproperty parentprocessid

  $window_handle = get-process -id $parent_process_id | select-object -expandproperty MainWindowHandle
  write-output ('Using current process parent process {0} handle {1}' -f $parent_process_id, $window_handle)
} else {
  write-output ('Using current process handle {0}' -f $window_handle)
}

$caller = new-object $caller_class -ArgumentList ($window_handle)
$result = $RESULT_OK
$continue = $true
while ($continue -and ($result -ne $RESULT_CANCEL) -and ($result -ne $RESULT_TIMEOUT)) { 
  PromptAuto -Title $title -Message $message -caller $caller
  $result = $caller.Data
  $continue = $caller.Continue
  write-output ('Result is : {0} ({1})'  -f $Readable.Item($result),$result)
  write-output ('Password is : {0}' -f $caller.TxtPassword)
  # call Selenium or other tasks
}
