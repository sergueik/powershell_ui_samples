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

# http://www.codeproject.com/Tips/816113/Console-Monitor
Add-Type -TypeDefinition @"

using System;
using System.Drawing;
using System.IO;
using System.Windows.Forms;
using System.Drawing.Imaging;
public class WindowHelper
{
    private Bitmap bmp;
    private int _count = 0;
    public int Count
    {
        get { return _count; }
        set { _count = value; }
    }
    public String Screenshot()
    {
        bmp = new Bitmap(Screen.PrimaryScreen.Bounds.Width, Screen.PrimaryScreen.Bounds.Height);
        Graphics gr = Graphics.FromImage(bmp);
        gr.CopyFromScreen(0, 0, 0, 0, bmp.Size);
        Label();

        string str = string.Format(@"C:\temp\Snap[{0}].jpeg", _count);
        bmp.Save(str, ImageFormat.Jpeg);
        return str;
    }

    public void Label() { 

string firstText = "Hello";
string secondText = "World";

PointF firstLocation = new PointF(10f, 10f);
PointF secondLocation = new PointF(10f, 50f);

using(Graphics graphics = Graphics.FromImage(bmp))
{
    using (Font arialFont =  new Font("Arial", 40))
    {
        graphics.DrawString(firstText, arialFont, Brushes.White, firstLocation);
        graphics.DrawString(secondText, arialFont, Brushes.Red, secondLocation);
    }
}
}
    public WindowHelper()
    {
    }

}

"@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Drawing.dll','System.Data.dll'

  $owner = New-Object WindowHelper
  $owner.count = $iteration
  $owner| get-member 
  try {  
  $owner.Screenshot()
 } catch [Exception]  {
   write-output $_.Exception.Message
 }

<#
# PowerShell Invoke-Command -FilePath example
Invoke-Command -ComputerName 'targetnode.com'  -FilePath "C:\Users\user\console_snapshot_local.ps1" 
#>
