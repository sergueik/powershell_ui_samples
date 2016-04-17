Add-Type @"

using System;
using System.Windows.Forms;

public class Helper
{
    public Helper()
    {
    }
    public String Current()
    {
        return String.Format("Resolution: {0}x{1}", Screen.PrimaryScreen.Bounds.Width.ToString(), Screen.PrimaryScreen.Bounds.Height.ToString());
    }
}
"@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Drawing.dll'

$o = New-Object -typename 'Helper'
Write-output $o.Current() 


[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
$o = [System.Windows.Forms.Screen]::PrimaryScreen
$o.Bounds
<#

Location : {X=0,Y=0}
Size     : {Width=1280, Height=720}
X        : 0
Y        : 0
Width    : 1280
Height   : 720
Left     : 0
Top      : 0
Right    : 1280
Bottom   : 720
IsEmpty  : False

#>