require 'ffi'
# origin https://stackoverflow.com/questions/49590622/ruby-ffi-windows-form
module Win
  extend FFI::Library
  ffi_convention(:stdcall)

  COLOR_BACKGROUND = 1
  COLOR_BTNFACE = 15


  # window styles
  WS_OVERLAPPED = 0
  WS_POPUP = 0x80000000
  WS_CHILD = 0x40000000
  WS_MINIMIZE = 0x20000000
  WS_VISIBLE = 0x10000000
  WS_DISABLED = 0x8000000
  WS_CLIPSIBLINGS = 0x4000000
  WS_CLIPCHILDREN = 0x2000000
  WS_MAXIMIZE = 0x1000000
  WS_CAPTION = 0xC00000                  #  WS_BORDER | WS_DLGFRAME
  WS_BORDER = 0x800000
  WS_DLGFRAME = 0x400000
  WS_VSCROLL = 0x200000
  WS_HSCROLL = 0x100000
  WS_SYSMENU = 0x80000
  WS_THICKFRAME = 0x40000
  WS_GROUP = 0x20000
  WS_TABSTOP = 0x10000

  WS_MINIMIZEBOX = 0x20000
  WS_MAXIMIZEBOX = 0x10000

  WS_TILED = WS_OVERLAPPED
  WS_ICONIC = WS_MINIMIZE
  WS_SIZEBOX = WS_THICKFRAME
  WS_OVERLAPPEDWINDOW = WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX
  WS_TILEDWINDOW = WS_OVERLAPPEDWINDOW

  # Common Window Styles
  WS_POPUPWINDOW = (WS_POPUP | WS_BORDER | WS_SYSMENU)
  WS_CHILDWINDOW = (WS_CHILD)

  # Extended Window Styles
  WS_EX_LEFT                = 0
  WS_EX_LTRREADING          = 0
  WS_EX_RIGHTSCROLLBAR      = 0
  WS_EX_DLGMODALFRAME       = 1
  WS_EX_NOPARENTNOTIFY      = 4
  WS_EX_TOPMOST             = 8
  WS_EX_ACCEPTFILES         = 0x10
  WS_EX_TRANSPARENT         = 0x20
  WS_EX_MDICHILD            = 0x40
  WS_EX_TOOLWINDOW          = 0x80
  WS_EX_WINDOWEDGE          = 0x100
  WS_EX_CLIENTEDGE          = 0x200
  WS_EX_CONTEXTHELP         = 0x400
  WS_EX_RIGHT               = 0x1000
  WS_EX_RTLREADING          = 0x2000
  WS_EX_LEFTSCROLLBAR       = 0x4000
  WS_EX_CONTROLPARENT       = 0x10000
  WS_EX_STATICEDGE          = 0x20000
  WS_EX_APPWINDOW           = 0x40000
  WS_EX_LAYERED             = 0x80000
  WS_EX_NOINHERITLAYOUT     = 0x100000
  WS_EX_NOREDIRECTIONBITMAP = 0x200000
  WS_EX_LAYOUTRTL           = 0x400000
  WS_EX_COMPOSITED          = 0x2000000
  WS_EX_NOACTIVATE          = 0x8000000
  WS_EX_OVERLAPPEDWINDOW    = WS_EX_WINDOWEDGE | WS_EX_CLIENTEDGE
  WS_EX_PALETTEWINDOW       = WS_EX_WINDOWEDGE | WS_EX_TOOLWINDOW | WS_EX_TOPMOST


  # Window Messages
  WM_NULL = 0
  WM_CREATE = 1
  WM_DESTROY = 2
  WM_MOVE = 3
  WM_SIZE = 5
  WM_ACTIVATE = 6
  WM_SETFOCUS = 7
  WM_KILLFOCUS = 8
  WM_ENABLE = 0xA
  WM_SETREDRAW = 0xB
  WM_SETTEXT = 0xC
  WM_GETTEXT = 0xD
  WM_GETTEXTLENGTH = 0xE
  WM_PAINT = 0xF
  WM_CLOSE = 0x10
  WM_QUERYENDSESSION = 0x11
  WM_QUIT = 0x12
  WM_QUERYOPEN = 0x13
  WM_ERASEBKGND = 0x14
  WM_SYSCOLORCHANGE = 0x15
  WM_ENDSESSION = 0x16
  WM_SYSTEMERROR = 0x17
  WM_SHOWWINDOW = 0x18
  WM_CTLCOLOR = 0x19
  WM_WININICHANGE = 0x1A
  WM_DEVMODECHANGE = 0x1B
  WM_ACTIVATEAPP = 0x1C
  WM_FONTCHANGE = 0x1D
  WM_TIMECHANGE = 0x1E
  WM_CANCELMODE = 0x1F
  WM_SETCURSOR = 0x20
  WM_MOUSEACTIVATE = 0x21
  WM_CHILDACTIVATE = 0x22
  WM_QUEUESYNC = 0x23
  WM_GETMINMAXINFO = 0x24
  WM_PAINTICON = 0x26
  WM_ICONERASEBKGND = 0x27
  WM_NEXTDLGCTL = 0x28
  WM_SPOOLERSTATUS = 0x2A
  WM_DRAWITEM = 0x2B
  WM_MEASUREITEM = 0x2C
  WM_DELETEITEM = 0x2D
  WM_VKEYTOITEM = 0x2E
  WM_CHARTOITEM = 0x2F
  WM_SETFONT = 0x30
  WM_GETFONT = 0x31
  WM_SETHOTKEY = 0x32
  WM_GETHOTKEY = 0x33
  WM_QUERYDRAGICON = 0x37
  WM_COMPAREITEM = 0x39
  WM_COMPACTING = 0x41
  WM_WINDOWPOSCHANGING = 0x46
  WM_WINDOWPOSCHANGED = 0x47
  WM_POWER = 0x48
  WM_COPYDATA = 0x4A
  WM_CANCELJOURNAL = 0x4B
  WM_NOTIFY = 0x4E
  WM_INPUTLANGCHANGEREQUEST = 0x50
  WM_INPUTLANGCHANGE = 0x51
  WM_TCARD = 0x52
  WM_HELP = 0x53
  WM_USERCHANGED = 0x54
  WM_NOTIFYFORMAT = 0x55
  WM_CONTEXTMENU = 0x7B
  WM_STYLECHANGING = 0x7C
  WM_STYLECHANGED = 0x7D
  WM_DISPLAYCHANGE = 0x7E
  WM_GETICON = 0x7F
  WM_SETICON = 0x80
  WM_NCCREATE = 0x81
  WM_NCDESTROY = 0x82
  WM_NCCALCSIZE = 0x83
  WM_NCHITTEST = 0x84
  WM_NCPAINT = 0x85
  WM_NCACTIVATE = 0x86
  WM_GETDLGCODE = 0x87
  WM_NCMOUSEMOVE = 0xA0
  WM_NCLBUTTONDOWN = 0xA1
  WM_NCLBUTTONUP = 0xA2
  WM_NCLBUTTONDBLCLK = 0xA3
  WM_NCRBUTTONDOWN = 0xA4
  WM_NCRBUTTONUP = 0xA5
  WM_NCRBUTTONDBLCLK = 0xA6
  WM_NCMBUTTONDOWN = 0xA7
  WM_NCMBUTTONUP = 0xA8
  WM_NCMBUTTONDBLCLK = 0xA9
  WM_KEYFIRST = 0x100
  WM_KEYDOWN = 0x100
  WM_KEYUP = 0x101
  WM_CHAR = 0x102
  WM_DEADCHAR = 0x103
  WM_SYSKEYDOWN = 0x104
  WM_SYSKEYUP = 0x105
  WM_SYSCHAR = 0x106
  WM_SYSDEADCHAR = 0x107
  WM_KEYLAST = 0x108
  WM_IME_STARTCOMPOSITION = 0x10D
  WM_IME_ENDCOMPOSITION = 0x10E
  WM_IME_COMPOSITION = 0x10F
  WM_IME_KEYLAST = 0x10F  
  WM_INITDIALOG = 0x110
  WM_COMMAND = 0x111
  WM_SYSCOMMAND = 0x112
  WM_TIMER = 0x113
  WM_HSCROLL = 0x114
  WM_VSCROLL = 0x115
  WM_INITMENU = 0x116
  WM_INITMENUPOPUP = 0x117
  WM_MENUSELECT = 0x11F
  WM_MENUCHAR = 0x120
  WM_ENTERIDLE = 0x121
  WM_CTLCOLORMSGBOX = 0x132
  WM_CTLCOLOREDIT = 0x133
  WM_CTLCOLORLISTBOX = 0x134
  WM_CTLCOLORBTN = 0x135
  WM_CTLCOLORDLG = 0x136
  WM_CTLCOLORSCROLLBAR = 0x137
  WM_CTLCOLORSTATIC = 0x138
  WM_MOUSEFIRST = 0x200
  WM_MOUSEMOVE = 0x200
  WM_LBUTTONDOWN = 0x201
  WM_LBUTTONUP = 0x202
  WM_LBUTTONDBLCLK = 0x203
  WM_RBUTTONDOWN = 0x204
  WM_RBUTTONUP = 0x205
  WM_RBUTTONDBLCLK = 0x206
  WM_MBUTTONDOWN = 0x207
  WM_MBUTTONUP = 0x208
  WM_MBUTTONDBLCLK = 0x209
  WM_MOUSELAST = 0x209
  WM_PARENTNOTIFY = 0x210
  WM_ENTERMENULOOP = 0x211
  WM_EXITMENULOOP = 0x212
  WM_NEXTMENU = 0x213
  WM_SIZING = 0x214
  WM_CAPTURECHANGED = 0x215
  WM_MOVING = 0x216
  WM_POWERBROADCAST = 0x218
  WM_DEVICECHANGE = 0x219  
  WM_MDICREATE = 0x220
  WM_MDIDESTROY = 0x221
  WM_MDIACTIVATE = 0x222
  WM_MDIRESTORE = 0x223
  WM_MDINEXT = 0x224
  WM_MDIMAXIMIZE = 0x225
  WM_MDITILE = 0x226
  WM_MDICASCADE = 0x227
  WM_MDIICONARRANGE = 0x228
  WM_MDIGETACTIVE = 0x229
  WM_MDISETMENU = 0x230
  WM_ENTERSIZEMOVE = 0x231
  WM_EXITSIZEMOVE = 0x232  
  WM_DROPFILES = 0x233
  WM_MDIREFRESHMENU = 0x234
  WM_IME_SETCONTEXT = 0x281
  WM_IME_NOTIFY = 0x282
  WM_IME_CONTROL = 0x283
  WM_IME_COMPOSITIONFULL = 0x284
  WM_IME_SELECT = 0x285
  WM_IME_CHAR = 0x286
  WM_IME_KEYDOWN = 0x290
  WM_IME_KEYUP = 0x291
  WM_MOUSEHOVER = 0x2A1
  WM_NCMOUSELEAVE = 0x2A2
  WM_MOUSELEAVE = 0x2A3  
  WM_CUT = 0x300
  WM_COPY = 0x301
  WM_PASTE = 0x302
  WM_CLEAR = 0x303
  WM_UNDO = 0x304
  WM_RENDERFORMAT = 0x305
  WM_RENDERALLFORMATS = 0x306
  WM_DESTROYCLIPBOARD = 0x307
  WM_DRAWCLIPBOARD = 0x308
  WM_PAINTCLIPBOARD = 0x309
  WM_VSCROLLCLIPBOARD = 0x30A
  WM_SIZECLIPBOARD = 0x30B
  WM_ASKCBFORMATNAME = 0x30C
  WM_CHANGECBCHAIN = 0x30D
  WM_HSCROLLCLIPBOARD = 0x30E
  WM_QUERYNEWPALETTE = 0x30F
  WM_PALETTEISCHANGING = 0x310
  WM_PALETTECHANGED = 0x311
  WM_HOTKEY = 0x312
  WM_PRINT = 0x317
  WM_PRINTCLIENT = 0x318
  WM_HANDHELDFIRST = 0x358
  WM_HANDHELDLAST = 0x35F
  WM_PENWINFIRST = 0x380
  WM_PENWINLAST = 0x38F
  WM_COALESCE_FIRST = 0x390
  WM_COALESCE_LAST = 0x39F
  WM_DDE_FIRST = 0x3E0
  WM_DDE_INITIATE = 0x3E0
  WM_DDE_TERMINATE = 0x3E1
  WM_DDE_ADVISE = 0x3E2
  WM_DDE_UNADVISE = 0x3E3
  WM_DDE_ACK = 0x3E4
  WM_DDE_DATA = 0x3E5
  WM_DDE_REQUEST = 0x3E6
  WM_DDE_POKE = 0x3E7
  WM_DDE_EXECUTE = 0x3E8
  WM_DDE_LAST = 0x3E8
  WM_USER = 0x400
  WM_APP = 0x8000
end

module Win
  ULONG = FFI::TypeDefs[:ulong]
  LONG = FFI::TypeDefs[:long]
  INT = FFI::TypeDefs[:int]
  BYTE = FFI::TypeDefs[:uint16]
  DWORD = FFI::TypeDefs[:ulong]
  BOOL = FFI::TypeDefs[:int]
  UINT = FFI::TypeDefs[:uint]
  POINTER = FFI::TypeDefs[:pointer]
  VOID = FFI::TypeDefs[:void]

  HWND = HICON = HCURSOR = HBRUSH = HINSTANCE = HGDIOBJ =
      HMENU = HMODULE = HANDLE = ULONG
  LPARAM = LONG
  WPARAM = ULONG
  LPCTSTR = LPMSG = POINTER
  LRESULT = LONG
  ATOM = BYTE

  WNDPROC = callback(:WindowProc, [HWND, UINT, WPARAM, LPARAM], LRESULT)
end

module Win
  def self._func(*args)
    attach_function *args
    case args.size
      when 3
        module_function args[0]
      when 4
        module_function args[0]
        alias_method(args[1], args[0])
        module_function args[1]
    end
  end
end

module Win
  ffi_lib('user32')
  _func(:CreateWindowEx, :CreateWindowExA, 
      [
        DWORD, LPCTSTR, LPCTSTR, DWORD, ULONG, ULONG, ULONG, ULONG, 
        HWND, HMENU, HINSTANCE, POINTER
      ], HWND
    )
  _func(:DefWindowProc, :DefWindowProcA, [HWND, UINT, WPARAM, LPARAM], LRESULT)
  _func(:DestroyWindow, [HWND], BOOL)
  _func(:DispatchMessage, :DispatchMessageA, [POINTER], BOOL)
  _func(:GetMessage, :GetMessageA, [LPMSG, HWND, UINT, UINT], BOOL)
  _func(:IsDialogMessage, :IsDialogMessageA, [HWND, LPMSG], LONG)
  _func(:PostQuitMessage, [INT], VOID)
  _func(:RegisterClassEx, :RegisterClassExA, [POINTER], ATOM)
  _func(:SendMessage, :SendMessageA, [HWND, LONG, LONG, LPMSG], LONG)
  _func(:ShowWindow, [HWND, INT], BOOL)
  _func(:TranslateMessage, [POINTER], BOOL)
  _func(:UpdateWindow, [HWND], BOOL)


  ffi_lib('kernel32')
  _func(:GetModuleHandle, :GetModuleHandleA, [LPCTSTR], HMODULE)
end

module Win
  class POINT < FFI::Struct
    layout :x, LONG, :y, LONG
  end

  class MSG < FFI::Struct
    layout :hwnd, HWND,
           :message, UINT,
           :wParam, WPARAM,
           :lParam, LPARAM,
           :time, DWORD,
           :pt, POINT
  end

  class WNDCLASSEX < FFI::Struct
    layout :cbSize, UINT,
           :style, UINT,
           :lpfnWndProc, WNDPROC,
           :cbClsExtra, INT,
           :cbWndExtra, INT,
           :hInstance, HANDLE,
           :hIcon, HICON,
           :hCursor, HCURSOR,
           :hbrBackground, HBRUSH,
           :lpszMenuName, LPCTSTR,
           :lpszClassName, LPCTSTR,
           :hIconSm, HICON

    def initialize(*args)
      super
      self[:cbSize] = self.size
      @atom = 0
    end
    def addr
      FFI::Pointer.new(@atom)
    end
    def register_class_ex
      #if (@atom = Win.RegisterClassEx(self)) != 0
      if (@atom = Win.RegisterClassEx(self)) != 0
        @atom
      else
        raise("RegisterClassEx error")
      end
    end
    def atom
      @atom != 0 ? @atom : register_class_ex
    end
  end
end

module Win
  HINST = GetModuleHandle(nil)

  def self.message_loop
    msg = MSG.new
    while Win.GetMessage(msg, 0, 0, 0) > 0
      Win.TranslateMessage(msg)
      Win.DispatchMessage(msg)
    end
  end


  class Point
    attr_accessor :x, :y
    def initialize(x = 0, y = 0)
      @x = x
      @y = y
    end
  end


  class Size
    attr_accessor :width, :height
    def initialize(width = 0, height = 0)
      @width = width
      @height = height
    end
  end

  class UIControl
    include Win

  private
    def initialize
      @wnd_style = 0
      @wnd_ex_style = 0
      @hwnd = 0
      @location = Point.new
      @size = Size.new(80, 24)
      @text = ""
    end

  public
    def create(hwnd_parent)
      @hwnd = CreateWindowEx(
          @wnd_ex_style, self.class.name, @text, @wnd_style, 
          @location.x, @location.y, @size.width, @size.height, 
          hwnd_parent, 0, HINST, nil
        )
      raise "CreateWindowEx error" if @hwnd == 0
    end
  end


  class Form < UIControl
  private
    def initialize
      super

      @location = Point.new(0, 0)
      @size = Size.new(300, 200)
      @text = "GUITest"
      @wnd_ex_style = WS_OVERLAPPED
      @wnd_style = WS_OVERLAPPEDWINDOW | WS_VISIBLE
    end
    def control_window_proc(hwnd, msg, wparam, lparam)
      retn = 0

      case msg
      when WM_CREATE
        puts "WM_CREATE"
        @hwnd = hwnd
        bb = ThisClassNameIsNotExist.new   # no exception raised
        retn = 0
      when WM_DESTROY
        puts "WM_DESTROY"
        bb = ThisClassNameIsNotExist.new   # no exception raised
        retn = 0
      when WM_CLOSE
        puts "WM_CLOSE"
        DestroyWindow(@hwnd)
        PostQuitMessage(0)
        @hwnd = 0
      when WM_SIZE
        puts "WM_SIZE"
        bb = ThisClassNameIsNotExist.new   # no exception raised
        retn = 0
      else
        retn = DefWindowProc(hwnd, msg, wparam, lparam)
      end

      retn
    end

  public
    def show(owner = nil, modal = false)
      @wnd_class                  = WNDCLASSEX.new
      @wnd_class[:lpfnWndProc]    = method(:control_window_proc)
      @wnd_class[:cbClsExtra]     = 0
      @wnd_class[:cbWndExtra]     = 0
      @wnd_class[:hInstance]      = HINST
      @wnd_class[:hbrBackground]  = COLOR_BTNFACE + COLOR_BACKGROUND
      @wnd_class[:lpszMenuName]   = 0
      @wnd_class[:lpszClassName]  = FFI::MemoryPointer.from_string(self.class.name)
      @wnd_class[:style]          = 0
      @wnd_class[:hIcon]          = 0
      @wnd_class[:hCursor]        = 0
      @wnd_class[:hIconSm]        = 0
      @wnd_class.register_class_ex

      create(0)

      Win.message_loop
    end
  end
end

Win::Form.new.show
ruby winforms winapi ffi
