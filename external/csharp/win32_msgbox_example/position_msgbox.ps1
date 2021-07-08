#Copyright (c) 2020,2021 Serguei Kouzmine
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

# based on: https://www.codeproject.com/Tips/472294/Position-a-Windows-Forms-MessageBox-in-Csharp
param (
  [string]$caption = 'caption',
  [string]$text = 'dialog text',
  [string]$button = 'Ok',
  [string]$icon = 'Exclamation',
  [int]$x = 100,
  [int]$y = 100,

  [switch]$debug
)

[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')

Add-Type -TypeDefinition @"
using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Globalization;
using System.Runtime.InteropServices;
using System.Threading;

public class Mover {

  [DllImport("user32.dll")]
  static extern IntPtr FindWindow(IntPtr classname, string title);

  [DllImport("user32.dll")]
  static extern void MoveWindow(IntPtr hwnd, int X, int Y, int nWidth, int nHeight, bool rePaint);

  [DllImport("user32.dll")]
  static extern bool GetWindowRect(IntPtr hwnd, out Rectangle rect);

  public static void FindAndMoveMsgBox(int x, int y, bool repaint, string title) {
    Thread thr = new Thread(() => {
      IntPtr hwnd = IntPtr.Zero;
      // wait to discover MessageBox window handle through window title
      while ((hwnd = FindWindow(IntPtr.Zero, title)) == IntPtr.Zero) ;
      Rectangle rectangle = new Rectangle();
      GetWindowRect(hwnd, out rectangle);
      MoveWindow(hwnd, x, y, rectangle.Width - rectangle.X, rectangle.Height - rectangle.Y, repaint);
    });
      thr.Start(); // starts the thread
  }

}
"@ -ReferencedAssemblies 'System.Windows.Forms.dll', 'System.Drawing.dll'
[Mover]::FindAndMoveMsgBox($x, $y, $true, $caption)
# NOTE: the MessageBox class does not have constructor

$result = [System.Windows.Forms.MessageBox]::Show($text, $caption, $button, $icon)

