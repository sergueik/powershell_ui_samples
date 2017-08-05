#Copyright (c) 2017 Serguei Kouzmine
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.


# based on
# http://www.cyberforum.ru/powershell/thread2023497-page2.html
$global:ImagePath = 'c:\temp\PrintScreen1.png'

$provider = New-Object Microsoft.VisualBasic.VBCodeProvider
$params = New-Object System.CodeDom.Compiler.CompilerParameters
$params.GenerateInMemory = $true
$refs = @(
  'System.dll',
  'Microsoft.VisualBasic.dll'
)
$params.referencedAssemblies.AddRange($refs)
$results = $provider.CompileAssemblyFromSource($params,@'
Class mBox
    Declare Sub keybd_event Lib "User32.dll" Alias "keybd_event" (ByVal bVk As Byte, ByVal bScan As Byte, ByVal dwFlags As Integer, ByVal dwExtraInfo As Integer)
    Sub Main()
        keybd_event(44, 1, 0, 0)
    End Sub
End Class
'@
)
<#
# additional snippets / alternative
$script = @'
Imports System.Windows.Forms
Imports System.Drawing
Imports System.Runtime.InteropServices
 
Public Class Saver
 
 
    Public Declare Auto Function GetWindowRect Lib "user32.dll" (hwnd As IntPtr, ByRef rectangle As Rect) As Boolean
    <DllImport("user32.dll", SetLastError:=True)>
    Private Shared Function GetActiveWindow() As IntPtr
    End Function
    Public Sub Save(path As String)
 
        Dim winrect As Rect
        GetWindowRect(GetActiveWindow, winrect)
        Dim bm As New Bitmap(winrect.Right - winrect.Left, winrect.Bottom - winrect.Top)
        Dim g As Graphics = Graphics.FromImage(bm)
        g.CopyFromScreen(New Point(winrect.Left, winrect.Top), New Point(0, 0), bm.Size)
        bm.Save(path, Imaging.ImageFormat.Png)
        g.Dispose()
        bm.Dispose()
    End Sub
 
    Public Structure Rect
        Public Property Left As Integer
        Public Property Top As Integer
        Public Property Right As Integer
        Public Property Bottom As Integer
 
    End Structure
End Class
"@

$type=@"
using System;
using System.Net;
using System.Runtime.InteropServices;
 
public class WIN32
{
        
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
    
    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern bool GetWindowRect(IntPtr hwnd, ref RECT rectangle);
    
    [DllImport("user32.dll")]
    public static extern bool PrintWindow(IntPtr hWnd, IntPtr hdcBlt, int nFlags);
    
}
 
 public struct RECT
{
    public int Left; // x position of upper-left corner
    public int Top; // y position of upper-left corner
    public int Right; // x position of lower-right corner
    public int Bottom; // y position of lower-right corner
}
 
"@
 
Add-Type $type
add-type -AssemblyName system.drawing
$handle=[WIN32]::GetForegroundWindow()
$RECT= New-Object RECT
[WIN32]::GetWindowRect($handle,[ref]$RECT)|Out-Null

#>
$mAssembly = $results.CompiledAssembly
$mAssembly.CreateInstance('mBox').main()

[reflection.assembly]::LoadWithPartialName('System.Drawing') | Out-Null
Add-Type -AssemblyName 'System.Windows.Forms'
Add-Type -AssemblyName 'System.Drawing'
[void][Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms.VisualStyles')

# ----------------------------------------------
# Step 2
# Design the Form to collect the clipboard
# ----------------------------------------------

# No UI elements: form won't be shown
$Form = New-Object System.Windows.Forms.Form
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState

$Form.Text = 'Form'
$Form.Name = 'Form'
$Form.DataBindings.DefaultDataSourceUpdateMode = 0
$Form.ClientSize = '10,10'

#Save the initial state of the form
$InitialFormWindowState = $Form.WindowState
$global:ImagePath = 'c:\temp\PrintScreen1.png'

# initializes the OnLoad event
$Form.add_Load({
    [reflection.assembly]::LoadWithPartialName('System.Drawing')
    $global:screenImage = New-Object System.Drawing.Bitmap 1920,1080
    $global:screenImage = [System.Windows.Forms.Clipboard]::GetImage();
    $global:screenImage.Save($global:ImagePath,([System.Drawing.Imaging.ImageFormat]::png));
    $Form.WindowState = $InitialFormWindowState
    $form.Close()
  })


$Form.Topmost = $True

$Form.Add_Shown({ $Form.Activate() })

[void]$Form.ShowDialog()

$Form.Dispose()

