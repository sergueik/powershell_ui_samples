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

param(
  [string]$image_name = $null,
  [switch]$cursor
)

# http://stackoverflow.com/questions/8343767/how-to-get-the-current-directory-of-the-cmdlet-being-executed
function Get-ScriptDirectory
{
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  if ($Invocation.PSScriptRoot)
  {
    $Invocation.PSScriptRoot;
  }
  elseif ($Invocation.MyCommand.Path)
  {
    Split-Path $Invocation.MyCommand.Path
  }
  else
  {
    $Invocation.InvocationName.Substring(0,$Invocation.InvocationName.LastIndexOf("\"))
  }
}

$guid = [guid]::NewGuid()

$helper_type_namespace = ("Util_{0}" -f ($guid -replace '-',''))
$helper_type_name = 'ScreenshotHelper'

# http://www.codeproject.com/Articles/12850/Capturing-the-Desktop-Screen-with-the-Mouse-Cursor
# NOTE: few namespaces are already included and should not be present in the invocation agument
# Warning as Error: 
# The using directive for 'System' appeared previously in this namespace
# The using directive for 'System.Runtime.InteropServices' appeared previously in this namespace
Add-Type -UsingNamespace @(
  'System.Drawing',
  'System.IO',
  'System.Windows.Forms',
  'System.Drawing.Imaging',
  'System.Collections.Generic',
  'System.Text' `
  ) `
   -MemberDefinition @"
public const int SM_CXSCREEN = 0;
public const int SM_CYSCREEN = 1;
public const Int32 CURSOR_SHOWING = 0x00000001;
[StructLayout(LayoutKind.Sequential)]
public struct ICONINFO
{
    public bool fIcon;
    public Int32 xHotspot;
    public Int32 yHotspot;
    public IntPtr hbmMask;
    public IntPtr hbmColor;
}
[StructLayout(LayoutKind.Sequential)]
public struct POINT
{
    public Int32 x;
    public Int32 y;
}

[StructLayout(LayoutKind.Sequential)]
public struct CURSORINFO
{
    public Int32 cbSize;
    public Int32 flags;
    public IntPtr hCursor;
    public POINT ptScreenPos;
}

[DllImport("user32.dll", EntryPoint = "GetDesktopWindow")]
public static extern IntPtr GetDesktopWindow();

[DllImport("user32.dll", EntryPoint = "GetDC")]
public static extern IntPtr GetDC(IntPtr ptr);

[DllImport("user32.dll", EntryPoint = "GetSystemMetrics")]
public static extern int GetSystemMetrics(int abc);

[DllImport("user32.dll", EntryPoint = "GetWindowDC")]
public static extern IntPtr GetWindowDC(Int32 ptr);

[DllImport("user32.dll", EntryPoint = "ReleaseDC")]
public static extern IntPtr ReleaseDC(IntPtr hWnd, IntPtr hDc);


[DllImport("user32.dll", EntryPoint = "GetCursorInfo")]
public static extern bool GetCursorInfo(out CURSORINFO pci);

[DllImport("user32.dll", EntryPoint = "CopyIcon")]
public static extern IntPtr CopyIcon(IntPtr hIcon);

[DllImport("user32.dll", EntryPoint = "GetIconInfo")]
public static extern bool GetIconInfo(IntPtr hIcon, out ICONINFO piconinfo);

public const int SRCCOPY = 13369376;

[DllImport("gdi32.dll", EntryPoint = "CreateDC")]
public static extern IntPtr CreateDC(IntPtr lpszDriver, string lpszDevice, IntPtr lpszOutput, IntPtr lpInitData);

[DllImport("gdi32.dll", EntryPoint = "DeleteDC")]
public static extern IntPtr DeleteDC(IntPtr hDc);

[DllImport("gdi32.dll", EntryPoint = "DeleteObject")]
public static extern IntPtr DeleteObject(IntPtr hDc);

[DllImport("gdi32.dll", EntryPoint = "BitBlt")]
public static extern bool BitBlt(IntPtr hdcDest, int xDest,
                                 int yDest, int wDest,
                                 int hDest, IntPtr hdcSource,
                                 int xSrc, int ySrc, int RasterOp);

[DllImport("gdi32.dll", EntryPoint = "CreateCompatibleBitmap")]
public static extern IntPtr CreateCompatibleBitmap
                            (IntPtr hdc, int nWidth, int nHeight);

[DllImport("gdi32.dll", EntryPoint = "CreateCompatibleDC")]
public static extern IntPtr CreateCompatibleDC(IntPtr hdc);

[DllImport("gdi32.dll", EntryPoint = "SelectObject")]
public static extern IntPtr SelectObject(IntPtr hdc, IntPtr bmp);


private Boolean _cursor;
public Boolean Cursor
{
    get { return _cursor; }
    set { _cursor = value; }
}
private string _imagePath;
public string ImagePath
{
    get { return _imagePath; }
    set { _imagePath = value; }
}

public struct SIZE
{
    public int cx;
    public int cy;
}

static Bitmap CaptureDesktop()
{
    SIZE size;
    IntPtr hBitmap;
    IntPtr hDC = GetDC(GetDesktopWindow());
    IntPtr hMemDC = CreateCompatibleDC(hDC);

    size.cx = GetSystemMetrics
              (SM_CXSCREEN);

    size.cy = GetSystemMetrics
              (SM_CYSCREEN);

    hBitmap = CreateCompatibleBitmap(hDC, size.cx, size.cy);

    if (hBitmap != IntPtr.Zero)
    {
        IntPtr hOld = (IntPtr)SelectObject
                               (hMemDC, hBitmap);

        BitBlt(hMemDC, 0, 0, size.cx, size.cy, hDC,
                                       0, 0, SRCCOPY);

        SelectObject(hMemDC, hOld);
        DeleteDC(hMemDC);
        ReleaseDC(GetDesktopWindow(), hDC);
        Bitmap bmp = System.Drawing.Image.FromHbitmap(hBitmap);
        DeleteObject(hBitmap);
        GC.Collect();
        return bmp;
    }
    return null;

}


static Bitmap CaptureCursor(ref int x, ref int y)
{
    Bitmap bmp;
    IntPtr hicon;
    CURSORINFO ci = new CURSORINFO();
    ICONINFO icInfo;
    ci.cbSize = Marshal.SizeOf(ci);
    if (GetCursorInfo(out ci))
    {
        if (ci.flags == CURSOR_SHOWING)
        {
            hicon = CopyIcon(ci.hCursor);
            if (GetIconInfo(hicon, out icInfo))
            {
                x = ci.ptScreenPos.x - ((int)icInfo.xHotspot);
                y = ci.ptScreenPos.y - ((int)icInfo.yHotspot);

                Icon ic = Icon.FromHandle(hicon);
                bmp = ic.ToBitmap();
                return bmp;
            }
        }
    }

    return null;
}

public static Bitmap CaptureDesktopWithCursor()
{
    int cursorX = 0;
    int cursorY = 0;
    Bitmap desktopBMP;
    Bitmap cursorBMP;
    Graphics g;
    Rectangle r;

    desktopBMP = CaptureDesktop();
    cursorBMP = CaptureCursor(ref cursorX, ref cursorY);
    if (desktopBMP != null)
    {
        if (cursorBMP != null)
        {
            r = new Rectangle(cursorX, cursorY, cursorBMP.Width, cursorBMP.Height);
            g = Graphics.FromImage(desktopBMP);
            g.DrawImage(cursorBMP, r);
            g.Flush();
        }
        else
        {
            throw (new Exception("!!!"));
        }
        return desktopBMP;
    }

    return null;

}

public void Screenshot()
{
    Bitmap finalBMP;
    Graphics graphics;

    finalBMP = CaptureDesktopWithCursor();
    graphics = Graphics.FromImage(finalBMP);
    // graphics.CopyFromScreen(0, 0, 0, 0, finalBMP.Size);
    finalBMP.Save(_imagePath, ImageFormat.Png); finalBMP.Dispose();
    graphics.Dispose();
}

"@ -ReferencedAssemblies @( 'System.Windows.Forms.dll',`
     'System.Drawing.dll',`
     'System.Data.dll',`
     'System.Xml.dll') `
   -Namespace $helper_type_namespace -Name $helper_type_name -ErrorAction Stop

if ($image_name -eq '') {
  $image_name = $env:IMAGE_NAME
}

if (($image_name -eq '') -or ($image_name -eq $null)) {
  $image_name = ($guid.ToString())
}
[string]$image_path = ('{0}\{1}.{2}' -f (Get-ScriptDirectory),$image_name,'png')
$helper = New-Object -TypeName ('{0}.{1}' -f $helper_type_namespace,$helper_type_name)
$helper.ImagePath = $image_path
[boolean]$cursor = $false
if ($PSBoundParameters['cursor']) {
  $cursor = $true
} else {
  $cursor = $false
}
$helper.Cursor = $cursor
try {
  $helper.Screenshot()
} catch [exception]{
  Write-Output ("Ignoring exception:`n{0}" -f $_.Exception.Message)
}
