# http://www.pinvoke.net/default.aspx/user32.enumdisplaysettings
# http://www.codeproject.com/Articles/6810/Dynamic-Screen-Resolution

param (
  [int]$width,
  [int]$height,
  [switch]$list,
  [switch]$apply
)

Add-Type @"

//" 

using System;
using System.Windows.Forms;
using System.Runtime.InteropServices;

public class Utility
{

    [StructLayout(LayoutKind.Sequential)]
    public struct DEVMODE
    {
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
        public string _dmDeviceName;
        public short _dmSpecVersion;
        public short _dmDriverVersion;
        public short _dmSize;
        public short _dmDriverExtra;
        public int _dmFields;

        public short _dmOrientation;
        public short _dmPaperSize;
        public short _dmPaperLength;
        public short _dmPaperWidth;

        public short _dmScale;
        public short _dmCopies;
        public short _dmDefaultSource;
        public short _dmPrintQuality;
        public short _dmColor;
        public short _dmDuplex;
        public short _dmYResolution;
        public short _dmTTOption;
        public short _dmCollate;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
        public string _dmFormName;
        public short _dmLogPixels;
        public short _dmBitsPerPel;
        public int _dmPelsWidth;
        public int _dmPelsHeight;

        public int _dmDisplayFlags;
        public int _dmDisplayFrequency;

        public int _dmICMMethod;
        public int _dmICMIntent;
        public int _dmMediaType;
        public int _dmDitherType;
        public int _dmReserved1;
        public int _dmReserved2;

        public int _dmPanningWidth;
        public int _dmPanningHeight;
    };


    [DllImport("user32.dll")]
    public static extern int EnumDisplaySettings(string deviceName, int modeNum, ref DEVMODE devMode);

    public void EnumDisplaySettings_Helper()
    {

    }

    [DllImport("user32.dll")]
    public static extern int ChangeDisplaySettings(ref DEVMODE devMode, int flags);

    public const int ENUM_CURRENT_SETTINGS = -1;
    public const int CDS_UPDATEREGISTRY = 0x01;
    public const int CDS_TEST = 0x02;
    // origin: 
    // http://msdn.microsoft.com/en-us/library/windows/desktop/dd183411%28v=vs.85%29.aspx
    public const int DISP_CHANGE_SUCCESSFUL = 0;
    public const int DISP_CHANGE_RESTART = 1;
    public const int DISP_CHANGE_FAILED = -1;
    public const int DISP_CHANGE_BADMODE = -2;
    public const int DISP_CHANGE_NOTUPDATED = -3;
    public const int DISP_CHANGE_BADFLAGS = -4;
    public const int DISP_CHANGE_BADPARAM = -5;
    public const int DISP_CHANGE_BADDUALVIEW = -6;

    private int _height = 0, _width = 0;

    public Utility() { }
    public void List() {
        Screen _screen = Screen.PrimaryScreen;
        _height= _screen.Bounds.Height;
        _width = _screen.Bounds.Width;
        // in Virtual Box Windows 7, does not show the current resolution correctly after changing it
        Console.WriteLine("Current resolution:\nWidth:{0} Height:{1}", _width, _height);

        DEVMODE _dm = new DEVMODE();
        int i = 0;
        Console.WriteLine("Available resolutions:");
        while (0 != EnumDisplaySettings(null, i, ref _dm)) {
            Console.WriteLine("Width:{0} Height:{1} Color:{2} Frequency:{3}",
                _dm._dmPelsWidth,
                _dm._dmPelsHeight,
                _dm._dmBitsPerPel, _dm._dmDisplayFrequency
            );
            i++;
        }
    }
    public void Change_Resulution(int width, int height) {
        DEVMODE _dm = new DEVMODE();
        _dm._dmDeviceName = new String(new char[32]);
        _dm._dmFormName = new String(new char[32]);
        _dm._dmSize = (short)Marshal.SizeOf(_dm);
        if (0 != EnumDisplaySettings(null, ENUM_CURRENT_SETTINGS, ref _dm)) {

            _dm._dmPelsWidth = width;
            _dm._dmPelsHeight = height;

            int _result = ChangeDisplaySettings(ref _dm, CDS_TEST);

            if (_result == DISP_CHANGE_FAILED) {
              Console.WriteLine("Failed");
            } else {
              _result = ChangeDisplaySettings(ref _dm, CDS_UPDATEREGISTRY);
              switch (_result) {
                  case DISP_CHANGE_SUCCESSFUL: {
                      Console.WriteLine(" Success");
                      break;
                  }
                  case DISP_CHANGE_RESTART: {
                      Console.WriteLine(" You Need To Reboot For The Change To Happen.\n If You Feel Any Problem After Rebooting Your Machine\nThen Try To Change Resolution In Safe Mode.");
                      break;
                  }
                  case DISP_CHANGE_BADMODE: {
                      Console.WriteLine("Invalid / bad resolution.");
                      break;
                  }
                  default: {
                      Console.WriteLine("Error during The Resolution Change : {0}", _result);
                      break;
                  }
              }
            }
        }
    }
}

"@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Drawing.dll'
add-type @'

using System;
using System.Windows.Forms;

public class Helper {
    public Helper() { }
    public String Current() {
        return String.Format("Resolution: {0}x{1}", Screen.PrimaryScreen.Bounds.Width.ToString(), Screen.PrimaryScreen.Bounds.Height.ToString());
    }
}
'@ -ReferencedAssemblies 'System.Windows.Forms.dll','System.Drawing.dll'

$utility = new-object -typename 'Utility'
if ($PSBoundParameters['list']) {
  try {
    $utility.List() 
  } catch [Exception] {
    write-output $_.Exception.Message
  }
  # few shorter methods 
  $helper = new-object -typename 'Helper'
  write-output $helper.Current() 
  
  [void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
  $helper = [System.Windows.Forms.Screen]::PrimaryScreen
  $helper.Bounds
}

if ($PSBoundParameters['apply']) {
  if (($width -ne $null) -and ($height -ne $null)){
    try {
      $utility.Change_Resulution($width,$height )
    } catch [Exception] {
      write-output $_.Exception.Message
    }
  }
}
