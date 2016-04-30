# origin: https://github.com/Beej126/PoShSlideshow
# 's todo 

param(
  [string]$image_folder = "${env:USERPROFILE}\Pictures",
  [string]$idleTimeout = 2 #minutes
)

if ((Get-WmiObject Win32_Process -Filter "Name like 'powershell%' AND CommandLine like '%$(split-path $PSCommandPath -leaf)'").Count -gt 1) {
    #$existingWindow = [win32]::FindWindowByCaption("PoShSlideShow")
    #[Win32]::SetForegroundWindow($existingWindow)
    #[Win32]::ShowWindow($existingWindow, 9 <#SW_SHOW#>)
    exit
}

Add-Type -AssemblyName System.Windows.Forms

[System.WIndows.Forms.Application]::EnableVisualStyles()
try { [System.WIndows.Forms.Application]::SetCompatibleTextRenderingDefault($false) } catch { $Error.Clear() }

$notifyIcon = new-object System.Windows.Forms.NotifyIcon
$notifyIcon.Icon = new-object System.Drawing.Icon "$(Split-Path -parent $PSCommandPath)\slideshow_service.ico"
$notifyIcon.Visible = $true

function cleanExit {
  $notifyIcon.Visible = $false
  $folders | export-csv $folderCacheFile -Encoding Unicode #nugget: without -encoding sometimes yielded binary garbage 
  [System.Windows.Forms.Application]::Exit()
  exit
}

#Create a custom form with double buffering... otherwise each image would visibly repaint top to bottom a couple times... assuming because of the labels used for image path etc.
#concept from here: http://www.winsoft.se/category/dotnet/powershell/
try {
Add-Type -WarningAction SilentlyContinue -ReferencedAssemblies @("System.Windows.Forms", "System.Drawing") @'
using System;
using System.Windows.Forms;
//using System.Drawing;
using System.Runtime.InteropServices;

public class DoubleBufferedForm : System.Windows.Forms.Form
{
    public DoubleBufferedForm() {
        DoubleBuffered = true;
        SetStyle(ControlStyles.SupportsTransparentBackColor, true);
    }
}

public class Win32
{
  [DllImport("user32.dll")]
  [return: MarshalAs(UnmanagedType.Bool)]
  public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

  [DllImport("user32")]
  public static extern int SetForegroundWindow(int hwnd);

  [DllImport("user32.dll", CharSet = CharSet.Unicode)]
  public static extern IntPtr FindWindow(String sClassName, String sWindowCaption);

  [DllImport("user32.dll", EntryPoint = "FindWindow", SetLastError = true)]
  private static extern IntPtr FindWindowByCaptionInternal(IntPtr ZeroOnly, string sWindowCaption);
  public static IntPtr FindWindowByCaption(String sWindowCaption)
  {
    return FindWindowByCaptionInternal(IntPtr.Zero, sWindowCaption);
  }
}

// origin: http://stackoverflow.com/questions/15845508/get-idle-time-of-machine
public static class UserInput {

    [DllImport("user32.dll", SetLastError=false)]
    private static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);

    [StructLayout(LayoutKind.Sequential)]
    private struct LASTINPUTINFO {
        public uint cbSize;
        public int dwTime;
    }

    public static DateTime LastInput {
        get {
            DateTime bootTime = DateTime.UtcNow.AddMilliseconds(-Environment.TickCount);
            DateTime lastInput = bootTime.AddMilliseconds(LastInputTicks);
            return lastInput;
        }
    }

    public static TimeSpan IdleTime {
        get {
            return DateTime.UtcNow.Subtract(LastInput);
        }
    }

    public static int LastInputTicks {
        get {
            LASTINPUTINFO lii = new LASTINPUTINFO();
            lii.cbSize = (uint)Marshal.SizeOf(typeof(LASTINPUTINFO));
            GetLastInputInfo(ref lii);
            return lii.dwTime;
        }
    }
}
'@} catch {$Error.Clear()}

function isElevated {
  return (new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

function showBalloon { param($message, $icon)
  $script:notifyIcon.ShowBalloonTip(5000, "Slideshow", $message + ("", " - aborting")[$icon -eq "error"], ("Info", $icon)[!!($icon)])
  if ($icon -eq "error") { start-sleep 5; cleanExit }
}

if (!(isElevated)) { showBalloon "Not running under elevated permissions" "error" }

$script:rotationMap = @{}
$script:rotationMap["1"] = [Drawing.RotateFlipType]::RotateNoneFlipNone
$script:rotationMap["2"] = [Drawing.RotateFlipType]::RotateNoneFlipX
$script:rotationMap["3"] = [Drawing.RotateFlipType]::Rotate180FlipNone
$script:rotationMap["4"] = [Drawing.RotateFlipType]::Rotate180FlipX
$script:rotationMap["5"] = [Drawing.RotateFlipType]::Rotate90FlipX
$script:rotationMap["6"] = [Drawing.RotateFlipType]::Rotate90FlipNone
$script:rotationMap["7"] = [Drawing.RotateFlipType]::Rotate270FlipX
$script:rotationMap["8"] = [Drawing.RotateFlipType]::Rotate270FlipNone

$script:filesShown = new-object collections.arraylist
$script:rewindIndex = ($script:filesShown.Count - 1)

function showImage() {
  $script:img = $null
  if ($script:pictureBox.Image -ne $null) { $script:pictureBox.Image.Dispose() }
  $script:pictureBox.Image = $null
  $script:pictureBox.Hide()

  if ($script:randomFile.Extension -ne ".jpg") {
    $script:frmFade.Opacity = 0.001
    start-process -WindowStyle Hidden -wait -filepath vlc -ArgumentList "--fullscreen --video-on-top --play-and-exit `"$($randomFile.FullName)`""
    $script:frmFade.Opacity = 1
    $script:frmFade.BringToFront()
    #$script:frmFade.Activate()
    $script:timerAnimate.Start()
  }

  else {

    try {
      $script:img = [system.drawing.image]::FromFile($script:randomFile.FullName)
    }
    catch {
      $Error.Clear()
      return
    }
    
    # https://web.archive.org/web/20131207065832/http://exif.org/Exif2-2.PDF
    $EXIForientation = 274

    if ($script:img.PropertyIdList -contains $EXIForientation) {
      try { 
        $script:img.RotateFlip($script:rotationMap[[string]$script:img.GetPropertyItem($EXIForientation).Value[0]])
      }
      catch {$Error.Clear()}
    }

    $script:pictureBox.Left = 0
    $script:pictureBox.Top = 0

    $imagePathLabel.Text = $script:randomFile.FullName.Replace("$image_folder\", "")

    $script:pictureBox.Image = $script:img
    $script:pictureBox.Show()
    $script:animationMode = "fadeIn"
  }

}

function addLabel {
   param(
  [string] $text)
    [System.Windows.Forms.Label]$l = new-object System.Windows.Forms.Label
    $l.Text = $text
    $l.BackColor = "Transparent"
    $l.AutoSize = $true
    $l.ForeColor = [System.Drawing.Color]::White
    $l.Font = new-object System.Drawing.Font -ArgumentList "Segoe UI", 30
    $l.Dock = [System.Windows.Forms.DockStyle]::Bottom
    # ipc 
    $l.Parent = $script:frmImage
    return $l
}

$screen = [System.Windows.Forms.Screen]::PrimaryScreen

# another window to cover over the image and fade in/out via opactity
$script:frmFade = new-object DoubleBufferedForm
$script:frmFade.Name = "frmFade"
$script:frmFade.Text = "PoShSlideShow"
$script:frmFade.Bounds = $screen.Bounds
$script:frmFade.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$script:frmFade.BackColor = "Black"
$script:frmFade.ShowInTaskbar = $false
$script:frmFade.TopMost = $true

$rightLabel = new-object System.Windows.Forms.Label
$rightLabel.Font = new-object System.Drawing.Font("Times New Roman",100,[System.Drawing.FontStyle]::Regular)
$rightLabel.Text = ">"
$rightLabel.ForeColor = "white"
$rightLabel.Parent = $frmFade
$rightLabel.Dock = "left"
$rightLabel.add_Click({forward})

$leftLabel = new-object System.Windows.Forms.Label
$leftLabel.Font = new-object System.Drawing.Font("Times New Roman",100,[System.Drawing.FontStyle]::Regular)
$leftLabel.Text = "<"
$leftLabel.ForeColor = "white"
$leftLabel.Parent = $frmFade
$leftLabel.Dock = "left"
$leftLabel.add_Click({reverse})

$btnPause = new-object System.Windows.Forms.Panel
$btnPause.Parent = $frmFade
$btnPause.Dock = "fill"
$btnPause.add_Click({TogglePause})
$btnPause.add_DoubleClick({ToggleDisplay})

# the main form that holds the photo image content (and labels like the folder name)
$script:frmImage = new-object DoubleBufferedForm  #System.Windows.Forms.Form
$script:frmImage.Name = "frmImage"
$script:frmImage.Text = "frmImage"
$script:frmImage.Bounds = $screen.Bounds
$script:frmImage.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$script:frmImage.BackColor = "Black" #[System.Drawing.Color]::FromArgb(17, 114, 169)
$script:frmImage.ShowInTaskbar = $false
$script:frmImage.Owner = $script:frmFade

$imagePathLabel = addLabel
$script:debugLabel = addLabel
$script:debugLabel.Visible = $false

$script:pictureBox = new-object System.Windows.Forms.PictureBox
$script:pictureBox.SizeMode = "Zoom"
#$script:pictureBox.BackgroundImageLayout = "Zoom" # None, Tile, Center, Stretch, Zoom
$script:pictureBox.BackColor = "Black"
$script:pictureBox.Parent = $script:frmImage
$script:pictureBox.Bounds = $frmImage.Bounds
#$script:pictureBox.Width += 125 #a little bigger than screen to allow for sliding animation - caused significant slowdown while sliding... assuming clipping math is more complex
#$script:pictureBox.Height += 125

$script:idleTimer = new-object System.Windows.Forms.Timer
$script:idleTimer.Interval = 30000
$script:idleTimer.add_Tick({
  if ([UserInput]::IdleTime.TotalMinutes -gt $script:idleTimeout) {
      #pause timer since this is a long retrieval
    $script:idleTimer.Stop()
    #only start if there's nothing currently running on the display
    #currently checking via heavy "powercfg" CLI call... would be nice to find a lighter approach
    $powerCfg = powercfg /requests
    if (
      #this catches video streams that don't register as a Display request but do show under System as audio stream playing 
      !($powerCfg | select-string "playing" -quiet) `
      -or ($powerCfg | select-string "DISPLAY:" -context 0,1).Context.PostContext -eq "None." ) { ToggleDisplay; return }
    $script:idleTimer.Start()
  }
})


function ToggleDisplay {
  if ($script:frmFade.Visible) {
    $script:timerAnimate.Stop()
    $script:frmImage.Hide()
    $script:frmFade.Hide()

    if ($script:enableMenuItem.Text -eq "Disable Idle") { $script:idleTimer.Start() }
  }
  else {
    $script:idleTimer.Stop()

    $script:frmFade.Opacity = 1
    $script:frmFade.Show()
    $script:frmFade.Activate()
    $script:frmImage.Show()
    $script:frmFade.BringToFront()

    $script:animationMode = "showImage"
    $script:timerAnimate.Start()
  }

  $script:playMenu.Text = ("Play", "Pause")[$script:playMenu.Text -eq "Play"]; 
}

function pauseAnimation {
  $script:frmFade.Opacity = 0.05
  $script:timerAnimate.Stop()
}

function reverse {
  if ($script:rewindIndex -gt 0) {
    pauseAnimation
    $script:randomFile = (gi $script:filesShown[(--$script:rewindIndex)])
    showImage
  }
  else { showBalloon "at the beginning of image sequence" }
}

function forward {
  if ($script:rewindIndex -lt ($script:filesShown.Count - 1)) {
    pauseAnimation
    $script:randomFile = (gi $script:filesShown[++$script:rewindIndex])
    showImage
  } 
  else {
    $script:animationMode = "showimage"
    $script:timerAnimate.Start()
  }

  #$script:debugLabel.Text = $script:rewindIndex
}

function TogglePause {
  if ($script:timerAnimate.Enabled) { pauseAnimation } else {$script:timerAnimate.Start()};
}

$commands = {

    $keyEventArgs = $_

    $keycode = [string]($keyEventArgs.KeyCode)
    $keycode = $keycode.Substring(0, [math]::Min(6, $keycode.Length))

    if ($keycode -eq "Volume") {return}

    pauseAnimation

    #debug: $keyEventArgs | Format-List | Out-Host

	#nugget: these event handlers run in their own separate scope and thus need to reference all other global script variables as $script:var

    switch ($keycode) {
        "Escape" { ToggleDisplay }
        "O" { Invoke-Item $script:randomFile.DirectoryName; ToggleDisplay }

        "C" {
            $destination = $env:HOMEDRIVE+$env:Homepath+"\Pictures\"+$script:randomFile.FullName.Replace("$image_folder\", "").Replace("\", "_")
            copy-item $script:randomFile.FullName $destination
            showBalloon "File copied successfully:`n$destination"
            $script:timerAnimate.Start()
        }

        "M" { Invoke-Item ($env:HOMEDRIVE+$env:Homepath+"\Pictures\"); ToggleDisplay }

        "R" { $script:pictureBox.Image = $null; $script:img.RotateFlip([Drawing.RotateFlipType]::Rotate90FlipNone); $script:pictureBox.Image = $script:img; $script:img.Save($script:randomFile.FullName); }

        "Left" { reverse } 
        "Right" { forward }
        "Space" { TogglePause }

        default {
            $wshell.Popup("Keycode: $keycode`n`nESC - Exit`nO - Open folder`rC - [C]opy to 'My Pictures'`rM - Open [M]y Pictures folder`rR - Rotate`rLeft Cursor - Previous image`rRight Cursor - Next image`rSpace - Pause", 3 <#timeout seconds#>, "Usage:", 4096 <#TopMost#> + 64 <#Information icon#>) 
            $script:timerAnimate.Start()
		}
    }
}

$script:frmFade.add_KeyDown($commands)

$wshell = new-object -ComObject Wscript.Shell -ErrorAction Stop

$folderCacheFile = "$image_folder\AllFolders_$(("shared", "local")[$image_folder -like "*:*"]).txt"
if (!(test-path $folderCacheFile)) {
  showBalloon "Creating folder cache: $folderCacheFile"
  try {
    #nugget: -ExpandProperty prevents ellipsis on long strings
    $folders = dir -Directory -Recurse -Exclude .* -Path $image_folder | select @{Name="lastShown"; expression={[datetime]0}}, @{Name="path"; expression={$_.FullName}}
    $folders | Export-Csv $folderCacheFile
  }
  catch {
    showBalloon "unable to create: $folderCacheFile`n`n$Error" "error"
  }
}
else {
  $folders = import-csv $folderCacheFile | select @{Name="lastShown"; expression={[datetime]$_.lastShown}},path
}

#fade and slide timer
$script:timerAnimate = new-object System.Windows.Forms.Timer
$script:timerAnimate.Interval = 1
$script:timerAnimate.add_Tick({
    
    #$script:debugLabel.Text = $script:animationMode
    #$script:debugLabel.Text = "left: $($script:pictureBox.Left), top: $($script:pictureBox.Top)"

    switch ($script:animationMode) {
        "fadeOut" {
            #bring down the lights by increasing the overlay form's opacity from 0 to 1
            if ($script:frmFade.Opacity -lt 1) { $script:frmFade.Opacity += 0.05 }
            else { $script:animationMode = "showImage" }
        }
        "showImage" {
            $script:timerAnimate.Stop()

            #get next random folder... that we haven't seen for XX days
            $skipCount = 0
            do { $folder = $folders | random; $skipCount++ } until ($folder.lastShown -lt [DateTime]::UtcNow.AddMonths(-1) -or $skipCount -eq $folders.Count )
            $folder.lastShown = [DateTime]::UtcNow

            #get next randome file
            #nugget: http://stackoverflow.com/questions/790796/confused-with-include-parameter-of-the-get-childitem-cmdlet
            #there's an interesting interplay between -filter, -include and -recurse...
            #-filter only applies to a single extension, so we need to use -include (less performant since it scans the whole folder but we don't expect that many files per folder)
            #the wildcard on end of path allows the -include to apply to the contents... otherwise the -include operates on the path vs the contents
            #-recurse would basically work without the wildcard tacked on to the path... but then it digs into subfolders undesirably for this use case
            $script:randomFile = gci -Path "$($folder.path)\*" -File -Include @("*.jpg", "*.mp4", "*.mov", "*.avi") | random 
            $script:filesShown.Add($script:randomFile.FullName)
            $script:rewindIndex = ($script:filesShown.Count - 1)
            #$script:debugLabel.Text = $script:rewindIndex

            showImage

            $script:timerAnimate.Start()
        }
        "fadeIn" {
            #fade in the new image
            if ($script:frmFade.Opacity -gt 0.05) { $script:frmFade.Opacity -= 0.05 }
            else {
                $script:slideDirection = random -input (1,-1),(1,1),(-1,1),(-1,-1)
                $script:slideCount = 0
                $script:animationMode = "slide"
            }
        }
        "slide" {
            #slide it for a little ambience
            $script:slideCount += 1
            if ($script:slideCount -lt 250) {
                if ($script:slideCount % 2 -eq 0) {
                    $script:pictureBox.Left += $script:slideDirection[0]
                    $script:pictureBox.Top += $script:slideDirection[1]
                }
            }
            else {
                $script:animationMode = "fadeOut"
            }
            #$script:debugLabel.Text = "Location X,Y, fade: $($script:frmImage.Left), $($script:frmImage.Top), $fade"
        }
    }
})

#open context menu on left mouse for convenience (right mouse works by default)
$notifyIcon.add_MouseDown( { 
  if ($script:contextMenu.Visible) { $script:contextMenu.Hide(); return }
  if ($_.Button -ne [System.Windows.Forms.MouseButtons]::Left) {return}

  #from: http://stackoverflow.com/questions/21076156/how-would-one-attach-a-contextmenustrip-to-a-notifyicon
  #nugget: ContextMenu.Show() yields a known popup positioning bug... this trick leverages notifyIcons private method that properly handles positioning
  [System.Windows.Forms.NotifyIcon].GetMethod("ShowContextMenu", [System.Reflection.BindingFlags] "NonPublic, Instance").Invoke($script:notifyIcon, $null)
})

$contextMenu = new-object System.Windows.Forms.ContextMenuStrip
$contextMenu.ShowImageMargin = $false
$notifyIcon.ContextMenuStrip = $contextMenu
$contextMenu.Items.Add( "Path: $image_folder", $null, $null ) | Out-Null
$contextMenu.Items.Add( "E&xit", $null, { cleanExit } ) | Out-Null

$enableMenuItem = $contextMenu.Items.Add( "Disable Idle", $null, {
  $script:enableMenuItem.Text = ("Enable Idle", "Disable Idle")[$script:enableMenuItem.Text -eq "Enable Idle"]
  if(!$script:frmFade.Visible -and $script:enableMenuItem.Text -eq "Disable Idle") { $script:idleTimer.Start() }
})

$playMenu = $contextMenu.Items.Add( "Play", $null, { ToggleDisplay } )

$script:idleTimer.Start()
[System.Windows.Forms.Application]::Run()
if ($Error -ne $null) { showBalloon $Error "error" }
