(************************************************************

          KolibriOS system functions and definitions

*************************************************************)

unit KolibriOS;

interface

type
  KolibriChar = AnsiChar;
  PKolibriChar = PAnsiChar;
  PPKolibriChar = PPAnsiChar;

{$IF CompilerVersion < 15}
  UInt64 = Int64;
{$IFEND}

  TSize = packed record
    Height: Word;
    Width:  Word;
  end;

  TPoint = packed record
    Y: SmallInt;
    X: SmallInt;
  end;

  TRect = packed record
    Left:   LongInt;
    Top:    LongInt;
    Right:  LongInt;
    Bottom: LongInt;
  end;

  TBox = packed record
    Left:   LongInt;
    Top:    LongInt;
    Width:  LongWord;
    Height: LongWord;
  end;

  TSystemDate = packed record
    Year:  Byte;
    Month: Byte;
    Day:   Byte;
    Zero:  Byte;
  end;

  TSystemTime = packed record
    Hours:   Byte;
    Minutes: Byte;
    Seconds: Byte;
    Zero:    Byte;
  end;

  TThreadInfo = packed record
    CpuUsage:     LongWord;
    WinStackPos:  Word;
    Reserved0:    Word;
    Reserved1:    Word;
    Name:         array[0..11] of KolibriChar;
    MemAddress:   LongWord;
    MemUsage:     LongWord;
    Identifier:   LongWord;
    Window:       TRect;
    ThreadState:  Word;
    Reserved2:    Word;
    Client:       TRect;
    WindowState:  Byte;
    EventMask:    LongWord;
    KeyboardMode: Byte;
    Reserved3:    array[0..947] of Byte;
  end;

  TKeyboardInputMode = (kmChar, kmScan);

  TKeyboardInputFlag = (kfCode, kfEmpty, kfHotKey);

  TKeyboardInput = packed record
    Flag: TKeyboardInputFlag;
    Code: KolibriChar;
    case TKeyboardInputMode of
      kmChar:
        (ScanCode: KolibriChar);
      kmScan:
        (case TKeyboardInputFlag of
          kfCode:
            ();
          kfHotKey:
            (Control: Word);
        );
  end;

  TButtonInput = packed record
    MouseButton: Byte;
    ID:          Word;
    HiID:        Byte;
  end;

  TKernelVersion = packed record
    A, B, C, D: Byte;
    Reserved:   Byte;
    Revision:   LongWord;
  end;

  TRAMInfo = packed record
    AvailablePages:    LongWord;
    FreePages:         LongWord;
    PageFaults:        LongWord;
    KernelHeapSize:    LongWord;
    KernelHeapFree:    LongWord;
    Blocks:            LongWord;
    FreeBlocks:        LongWord;
    MaxFreeBlock:      LongWord;
    MaxAllocatedBlock: LongWord;
  end;

  TKeyboardLayout = array[0..127] of KolibriChar;

  TDriverControl = packed record
    Handle:         THandle;
    Func:           LongWord;
    InputData:      Pointer;
    InputDataSize:  LongWord;
    OutputData:     Pointer;
    OutputDataSize: LongWord;
  end;

  TFileDate = packed record
    Day:   Byte;
    Month: Byte;
    Year:  Word;
  end;

  TFileTime = packed record
    Seconds: Byte;
    Minutes: Byte;
    Hours:   Byte;
    Zero:    Byte;
  end;

  TFileDateTime = packed record
    Time: TFileTime;
    Date: TFileDate;
  end;

  TFileAttributes = packed record
    Attributes:   LongWord;
    Flags:        LongWord;
    Creation:     TFileDateTime;
    Access:       TFileDateTime;
    Modify:       TFileDateTime;
    Size:         UInt64;
  end;

  TFileInformation = packed record
    Attributes: TFileAttributes;
    Name:       array[0..255] of KolibriChar;
    Reserved:   array[0..7] of Byte;
  end;

  TFileInformationW = packed record
    Attributes: TFileAttributes;
    Name:       array[0..255] of WideChar;
    Reserved:   array[0..7] of Byte;
  end;

  TFolderInformation = packed record
    Version:         LongWord;
    BlockCount:      LongWord;
    FileCount:       LongWord;
    Reserved:        array[0..19] of Byte;
    FileInformation: array[0..0] of TFileInformation;
  end;

  TFolderInformationW = packed record
    Version:         LongWord;
    BlockCount:      LongWord;
    FileCount:       LongWord;
    Reserved:        array[0..19] of Byte;
    FileInformation: array[0..0] of TFileInformationW;
  end;

  TStandardColors = packed record
    Frames:         LongWord;
    Grab:           LongWord;
    Work3DDark:     LongWord;
    Work3DLight:    LongWord;
    GrabText:       LongWord;
    Work:           LongWord;
    WorkButton:     LongWord;
    WorkButtonText: LongWord;
    WorkText:       LongWord;
    WorkGraph:      LongWord;
  end;

  TSockAddr = packed record
    Family: Word;
    Data:   array[0..13] of Byte;
  end;

  TOptStruct = packed record
    Level:     LongWord;
    OptName:   LongWord;
    OptLength: LongWord;
    Options:   array[0..0] of Byte
  end;

  TThreadContext = packed record
    EIP:    LongWord;
    EFlags: LongWord;
    EAX:    LongWord;
    ECX:    LongWord;
    EDX:    LongWord;
    EBX:    LongWord;
    ESP:    LongWord;
    EBP:    LongWord;
    ESI:    LongWord;
    EDI:    LongWord;
  end;

  TSignalBuffer = packed record
    ID:   LongWord;
    Data: array[0..19] of Byte;
  end;

  TIPCMessage = packed record
    ID:     LongWord;
    Length: LongWord;
    Data:   array[0..0] of Byte;
  end;

  TIPCBuffer = packed record
    Lock:        LongWord;
    CurrentSize: LongWord;
    Data:        array[0..0] of TIPCMessage;
  end;

  TDebugMessage = packed record
    Code: LongWord;
    ID:   LongWord;
    Data: LongWord;
  end;

  TDebugBuffer = packed record
    TotalSize:   LongWord;
    CurrentSize: LongWord;
    Buffer:      array[0..0] of TDebugMessage;
  end;

const
  INVALID_HANDLE = 0;

  // Window styles 
  WS_SKINNED_FIXED     =  $4000000;
  WS_SKINNED_SIZABLE   =  $3000000;
  WS_FIXED             =  $0000000;
  WS_SIZABLE           =  $2000000;
  WS_TRANSPARENT_FILL  = $40000000;
  WS_GRADIENT_FILL     = $80000000;
  WS_CLIENT_COORDS     = $20000000;
  WS_CAPTION           = $10000000;

  // Caption styles 
  CAPTION_MOVABLE      = $00000000;
  CAPTION_NONMOVABLE   = $01000000;

  // Events 
  REDRAW_EVENT         = 1;
  KEY_EVENT            = 2;
  BUTTON_EVENT         = 3;
  BACKGROUND_EVENT     = 5;
  MOUSE_EVENT          = 6;
  IPC_EVENT            = 7;
  NETWORK_EVENT        = 8;
  DEBUG_EVENT          = 9;

  // Event Mask constants 
  EM_REDRAW            = $001;
  EM_KEY               = $002;
  EM_BUTTON            = $004;
  EM_BACKGROUND        = $010;
  EM_MOUSE             = $020;
  EM_IPC               = $040;
  EM_NETWORK           = $080;
  EM_DEBUG             = $100;

  // Size multipliers for DrawText 
  DT_x1                =  $0000000;
  DT_x2                =  $1000000;
  DT_x3                =  $2000000;
  DT_x4                =  $3000000;
  DT_x5                =  $4000000;
  DT_x6                =  $5000000;
  DT_x7                =  $6000000;
  DT_x8                =  $7000000;

  // Charset specifiers for DrawText 
  DT_CP866_6x9         = $00000000;
  DT_CP866_8x16        = $10000000;
  DT_UTF16LE_8x16      = $20000000;
  DT_UTF8_8x16         = $30000000;

  // Fill styles for DrawText 
  DT_TRANSPARENT_FILL  = $00000000;
  DT_FILL_OPAQUE       = $40000000;

  // Draw zero terminated string for DrawText 
  DT_ZSTRING           = $80000000;

  // Button styles 
  BS_TRANSPARENT_FILL  = $40000000;
  BS_NO_FRAME          = $20000000;

  // OpenSharedMemory open\access flags
  SHM_OPEN             = $00;
  SHM_OPEN_ALWAYS      = $04;
  SHM_CREATE           = $08;
  SHM_READ             = $00;
  SHM_WRITE            = $01;

  // KeyboardLayout flags 
  KBL_NORMAL           = 1;
  KBL_SHIFT            = 2;
  KBL_ALT              = 3;

  // SystemShutdown parameters 
  SHUTDOWN_TURNOFF     = 2;
  SHUTDOWN_REBOOT      = 3;
  SHUTDOWN_RESTART     = 4;

  // Blit flags 
  BLIT_CLIENT_RELATIVE = $20000000;

{-1}      procedure TerminateThread; stdcall;
{0}       procedure DrawWindow(Left, Top, Width, Height: LongInt; Caption: PKolibriChar; BackColor, Style, CapStyle: LongWord); stdcall;
{1}       procedure SetPixel(X, Y: LongInt; Color: LongWord); stdcall;
{2}       function GetKey: TKeyboardInput; stdcall;
{3}       function GetSystemTime: TSystemTime; stdcall;
{4}       procedure DrawText(X, Y: LongInt; Text: PKolibriChar; ForeColor, BackColor, Flags, Count: LongWord); stdcall;
{5}       procedure Sleep(Time: LongWord); stdcall;
{6}       {UNDEFINED}
{7}       procedure DrawImage(const Image; X, Y: LongInt; Width, Height: LongWord); stdcall;
{8}       procedure DrawButton(Left, Top, Width, Height: LongInt; BackColor, Style, ID: LongWord); stdcall;
{8}       procedure DeleteButton(ID: LongWord); stdcall;
{9}       function GetThreadInfo(Slot: LongWord; var Buffer: TThreadInfo): LongWord; stdcall;
{10}      function WaitEvent: LongWord; stdcall;
{11}      function CheckEvent: LongWord; stdcall;
{12.1}    procedure BeginDraw; stdcall;
{12.2}    procedure EndDraw; stdcall;
{13}      procedure DrawRectangle(X, Y: LongInt; Width, Height: LongWord; Color: LongWord); stdcall;
{14}      function GetScreenMax: TPoint; stdcall;
{15.1}    procedure SetBackgroundSize(Width, Height: LongWord); stdcall;
{15.2}    procedure SetBackgroundPixel(X, Y: LongInt; Color: LongWord); stdcall;
{15.3}    procedure DrawBackground; stdcall;
{15.4}    procedure SetBackgroundDrawMode(DrawMode: LongWord); stdcall;
{15.5}    procedure DrawBackgroundImage(const Image; X, Y: LongInt; Width, Height: LongWord); stdcall;
{15.6}    function MapBackground: Pointer; stdcall;
{15.7}    function UnmapBackground(Background: Pointer): LongInt; stdcall;
{15.8}    function GetLastDrawnBackgroundRect: TRect; stdcall;
{15.9}    procedure UpdateBackgroundRect(Left, Top, Right, Bottom: LongInt); stdcall;
{16}      function FlushFloppyCache(FloppyNumber: LongWord): LongWord; stdcall;
{17}      function GetButton: TButtonInput; stdcall;
{18.1}    procedure DeactivateWindow(Slot: LongWord); stdcall;
{18.2}    procedure TerminateThreadBySlot(Slot: LongWord); stdcall;
{18.3}    procedure ActivateWindow(Slot: LongWord); stdcall;
{18.4}    function GetIdleTime: LongWord; stdcall;
{18.5}    function GetCPUClock: LongWord; stdcall;
{18.6}    function SaveRamDisk(FileName: PKolibriChar): LongWord; stdcall;
{18.7}    function GetActiveWindow: LongWord; stdcall;
{18.8.1}  function GetSpeakerState: LongInt; stdcall;
{18.8.2}  procedure SwitchSpeakerState; stdcall;
{18.9}    function SystemShutdown(Param: LongWord): LongInt; stdcall;
{18.10}   procedure MinimizeActiveWindow; stdcall;
{18.11}   procedure GetDiskSystemInfo(var Buffer); stdcall;
{18.12}   {UNDEFINED}
{18.13}   procedure GetKernelVersion(var Buffer: TKernelVersion); stdcall;
{18.14}   function WaitRetrace: LongInt; stdcall;
{18.15}   function CenterMousePointer: LongInt; stdcall;
{18.16}   function GetFreeMemory: LongWord; stdcall;
{18.17}   function GetAvailableMemory: LongWord; stdcall;
{18.18}   function TerminateThreadById(ID: LongWord): LongInt; stdcall;
{18.19.0} function GetMouseSpeed: LongWord; stdcall;
{18.19.1} procedure SetMouseSpeed(Speed: LongWord); stdcall;
{18.19.2} function GetMouseSensitivity: LongWord; stdcall;
{18.19.3} procedure SetMouseSensitivity(Sensitivity: LongWord); stdcall;
{18.19.4} procedure SetMousePos(X, Y: LongInt); stdcall;
{18.19.5} procedure SetMouseButtons(State: LongWord); stdcall;
{18.19.6} function GetDoubleClickTime: LongWord; stdcall;
{18.19.7} procedure SetDoubleClickTime(Time: LongWord); stdcall;
{18.20}   function GetRAMInfo(var Buffer: TRAMInfo): LongInt; stdcall;
{18.21}   function GetSlotById(ID: LongWord): LongWord; stdcall;
{18.22.0} function MinimizeWindowBySlot(Slot: LongWord): LongInt; stdcall;
{18.22.1} function MinimizeWindowByID(ID: LongWord): LongInt; stdcall;
{18.22.2} function RestoreWindowBySlot(Slot: LongWord): LongInt; stdcall;
{18.22.3} function RestoreWindowByID(ID: LongWord): LongInt; stdcall;
{18.23}   function MinimizeAllWindows: LongWord; stdcall;
{18.24}   procedure SetScreenLimits(Width, Height: LongWord); stdcall;
{18.25.1} function GetWindowZOrder(ID: LongWord): LongWord; stdcall;
{18.25.2} function SetWindowZOrder(ID, ZOrder: LongWord): LongInt; stdcall;
{19}      {UNDEFINED}
{20.1}    function ResetMidi: LongInt; stdcall;
{20.2}    function OutputMidi(Data: Byte): LongInt; stdcall;
{21.1}    function SetMidiBase(Port: LongWord): LongInt; stdcall;
{21.2}    function SetKeyboardLayout(Flags: LongWord; var Table: TKeyboardLayout): LongInt; stdcall;
{21.2}    function SetKeyboardLayoutCountry(Country: LongWord): LongInt; stdcall;
{21.3}    {UNDEFINED}
{21.4}    {UNDEFINED}
{21.5}    function SetSystemLanguage(SystemLanguage: LongWord): LongInt; stdcall;
{21.6}    {UNDEFINED}
{21.7}    {UNDEFINED}
{21.8}    {UNDEFINED}
{21.9}    {UNDEFINED}
{21.10}   {UNDEFINED}
{21.11}   function SetHDAccess(Value: LongWord): LongInt; stdcall;
{21.12}   function SetPCIAccess(Value: LongWord): LongInt; stdcall;
{22.0}    function SetSystemTime(Time: TSystemTime): LongInt; stdcall;
{22.1}    function SetSystemDate(Date: TSystemDate): LongInt; stdcall;
{22.2}    function SetDayOfWeek(DayOfWeek: LongWord): LongInt; stdcall;
{22.3}    function SetAlarm(Time: TSystemTime): LongInt; stdcall;
{23}      function WaitEventByTime(Time: LongWord): LongWord; stdcall;
{24.4}    procedure OpenCDTray(Drive: LongWord); stdcall;
{24.5}    procedure CloseCDTray(Drive: LongWord); stdcall;
{25}      procedure DrawBackgroundLayerImage(const Image; X, Y: LongInt; Width, Height: LongWord); stdcall;
{26.1}    function GetMidiBase: LongWord; stdcall;
{26.2}    procedure GetKeyboardLayout(Flags: LongWord; var Table: TKeyboardLayout); stdcall;
{26.2}    function GetKeyboardLayoutCountry: LongWord; stdcall;
{26.3}    {UNDEFINED}
{26.4}    {UNDEFINED}
{26.5}    function GetSystemLanguage: LongWord; stdcall;
{26.6}    {UNDEFINED}
{26.7}    {UNDEFINED}
{26.8}    {UNDEFINED}
{26.9}    function GetTickCount: LongWord; stdcall;
{26.10}   function GetTickCount64: UInt64; stdcall;
{26.11}   function IsHDAccessAllowed: LongWord; stdcall;
{26.12}   function IsPCIAccessAllowed: LongWord; stdcall;
{27}      {UNDEFINED}
{28}      {UNDEFINED}
{29}      function GetSystemDate: TSystemDate; stdcall;
{30.1}    procedure SetCurrentDirectory(Path: PKolibriChar); stdcall;
{30.2}    function GetCurrentDirectory(Buffer: PKolibriChar; Count: LongWord): LongWord; stdcall;
{31}      {UNDEFINED}
{32}      {UNDEFINED}
{33}      {UNDEFINED}
{34}      function GetPointOwner(X, Y: LongInt): LongWord; stdcall;
{35}      function GetPixel(X, Y: LongInt): LongWord; stdcall;
{36}      procedure GetScreenImage(var Buffer; X, Y: LongInt; Width, Height: LongWord); stdcall;
{37.0}    function GetMousePos: TPoint; stdcall;
{37.1}    function GetWindowMousePos: TPoint; stdcall;
{37.2}    function GetMouseButtons: LongWord; stdcall;
{37.3}    function GetMouseEvents: LongWord; stdcall;
{37.4}    function LoadCursorFromFile(FileName: PKolibriChar): THandle; stdcall;
{37.4}    function LoadCursorFromMemory(const Buffer): THandle; stdcall;
{37.4}    function LoadCursorIndirect(const Buffer; HotSpotX, HotSpotY: ShortInt): THandle; stdcall;
{37.5}    function SetCursor(Handle: LongWord = 0): THandle; stdcall;
{37.6}    procedure DeleteCursor(Handle: THandle); stdcall;
{37.7}    function GetMouseScroll: TPoint; stdcall;
{38}      procedure DrawLine(X1, Y1, X2, Y2: LongInt; Color: LongWord); stdcall;
{39.1}    function GetBackgroundSize: TSize; stdcall;
{39.2}    function GetBackgroundPixel(X, Y: LongInt): LongWord; stdcall;
{39.3}    {UNDEFINED}
{39.4}    function GetBackgroundDrawMode: LongWord; stdcall;
{40}      function SetEventMask(Mask: LongWord): LongWord; stdcall;
{41}      {UNDEFINED}
{42}      {UNDEFINED}
{43}      function InPort(Port: LongWord; var Data: Byte): LongWord; stdcall;
{43}      function OutPort(Port: LongWord; Data: Byte): LongWord; stdcall;
{44}      {UNDEFINED}
{45}      {UNDEFINED}
{46}      function ReservePorts(First, Last: LongWord): LongWord; stdcall;
{46}      function FreePorts(First, Last: LongWord): LongWord; stdcall;
{47}      {DrawNumber}
{48.0}    procedure ApplyStyleSettings; stdcall;
{48.1}    procedure SetButtonStyle(ButtonStyle: LongWord); stdcall;
{48.2}    procedure SetStandardColors(var ColorTable: TStandardColors; Size: LongWord); stdcall;
{48.3}    procedure GetStandardColors(var ColorTable: TStandardColors; Size: LongWord); stdcall;
{48.4}    function GetSkinHeight: LongWord; stdcall;
{48.5}    function GetScreenWorkingArea: TRect; stdcall;
{48.6}    procedure SetScreenWorkingArea(Left, Top, Right, Bottom: LongInt); stdcall;
{48.7}    function GetSkinMargins: TRect; stdcall;
{48.8}    function SetSkin(FileName: PKolibriChar): LongInt; stdcall;
{48.9}    function GetFontSmoothing: LongInt; stdcall;
{48.10}   procedure SetFontSmoothing(Smoothing: LongInt); stdcall;
{48.11}   function GetFontHeight: LongWord; stdcall;
{48.12}   procedure SetFontHeight(Height: LongWord); stdcall;
{49}      {Advanced Power Management (APM)}
{50.0}    procedure SetWindowShape(const Data); stdcall;
{50.1}    procedure SetWindowScale(Scale: LongWord); stdcall;
{51.1}    function CreateThread(Entry, Stack: Pointer): LongWord; stdcall;
{52}      {UNDEFINED}
{53}      {UNDEFINED}
{54.0}    function GetClipboardSlotCount: LongInt; stdcall;
{54.1}    function GetClipboardData(Slot: LongWord): Pointer; stdcall;
{54.2}    function SetClipboardData(const Src; Count: LongWord): LongInt; stdcall;
{54.3}    function DeleteClipboardLastSlot: LongInt; stdcall;
{54.4}    function ResetClipboard: LongInt; stdcall;
{55}      function SpeakerPlay(const Data): LongWord; stdcall;
{56}      {UNDEFINED}
{57}      {PCI BIOS}
{58}      {UNDEFINED}
{59}      {UNDEFINED}
{60.1}    function IPCSetBuffer(const Buffer: TIPCBuffer; Size: LongWord): LongInt; stdcall;
{60.2}    function IPCSendMessage(ID: LongWord; var Msg: TIPCMessage; Size: LongWord): LongInt; stdcall;
{61.1}    function GetScreenSize: TSize; stdcall;
{61.2}    function GetScreenBitsPerPixel: LongWord; stdcall;
{61.3}    function GetScreenBytesPerScanLine: LongWord; stdcall;
{62.0}    function GetPCIVersion: LongWord; stdcall;
{62.1}    function GetLastPCIBus: LongWord; stdcall;
{62.2}    function GetPCIAddressingMode: LongWord; stdcall;
{62.3}    {UNDEFINED}
{62.4}    function ReadPCIByte(Bus, Device, Func, Reg: Byte): Byte; stdcall;
{62.5}    function ReadPCIWord(Bus, Device, Func, Reg: Byte): Word; stdcall;
{62.6}    function ReadPCILongWord(Bus, Device, Func, Reg: Byte): LongWord; stdcall;
{62.7}    {UNDEFINED}
{62.8}    function WritePCIByte(Bus, Device, Func, Reg: Byte; Data: Byte): LongWord; stdcall;
{62.9}    function WritePCIWord(Bus, Device, Func, Reg: Byte; Data: Word): LongWord; stdcall;
{62.10}   function WritePCILongWord(Bus, Device, Func, Reg: Byte; Data: LongWord): LongWord; stdcall;
{63.1}    procedure DebugWrite(Data: Byte); stdcall;
{63.2}    function DebugRead(var Data: Byte): LongWord; stdcall;
{64}      function ReallocAppMemory(Count: LongWord): LongInt; stdcall;
{65}      procedure DrawImageEx(const Image; Left, Top: LongInt; Width, Height, BPP: LongWord; Palette: Pointer; Padding: LongWord); stdcall;
{66.1}    procedure SetKeyboardInputMode(Mode: LongWord); stdcall;
{66.2}    function GetKeyboardInputMode: LongWord; stdcall;
{66.3}    function GetControlKeyState: LongWord; stdcall;
{66.4}    function SetHotKey(ScanCode, Control: LongWord): LongInt; stdcall;
{66.5}    function ResetHotKey(ScanCode, Control: LongWord): LongInt; stdcall;
{66.6}    procedure LockKeyboard; stdcall;
{66.7}    procedure UnlockKeyboard; stdcall;
{67}      procedure SetWindowPos(Left, Top, Right, Bottom: LongInt); stdcall;
{68.0}    function GetTaskSwitchCount: LongWord; stdcall;
{68.1}    procedure SwitchThread; stdcall;
{68.2.0}  function EnableRDPMC: LongWord; stdcall;
{68.2.1}  function IsCacheEnabled: LongWord; stdcall;
{68.2.2}  procedure EnableCache; stdcall;
{68.2.3}  procedure DisableCache; stdcall;
{68.3}    {ReadMSR}
{68.4}    {WriteMSR}
{68.5}    {UNDEFINED}
{68.6}    {UNDEFINED}
{68.7}    {UNDEFINED}
{68.8}    {UNDEFINED}
{68.9}    {UNDEFINED}
{68.10}   {UNDEFINED}
{68.11}   function HeapInit: LongWord; stdcall;
{68.12}   function HeapAllocate(Bytes: LongWord): Pointer; stdcall;
{68.13}   function HeapFree(MemPtr: Pointer): LongWord; stdcall;
{68.14}   procedure WaitSignal(var Buffer: TSignalBuffer); stdcall;
{68.15}   {UNDEFINED}
{68.16}   function LoadDriver(Name: PKolibriChar): THandle; stdcall;
{68.17}   function ControlDriver(var CtrlStructure: TDriverControl): LongWord; stdcall;
{68.18}   {UNDEFINED}
{68.19}   function LoadLibrary(FileName: PKolibriChar): Pointer; stdcall;
{68.20}   function HeapReallocate(MemPtr: Pointer; Bytes: LongWord): Pointer; stdcall;
{68.21}   function LoadPEDriver(Name, CmdLine: PKolibriChar): THandle; stdcall;
{68.22}   function OpenSharedMemory(Name: PKolibriChar; Bytes: LongWord; Flags: LongWord): Pointer; stdcall;
{68.23}   function CloseSharedMemory(Name: PKolibriChar): LongWord; stdcall;
{68.24}   function SetExceptionHandler(Handler: Pointer; Mask: LongWord; var OldMask: LongWord): Pointer; stdcall;
{68.25}   function SetExceptionActivity(Signal, Activity: LongWord): LongInt; stdcall;
{68.26}   procedure ReleaseMemoryPages(MemPtr: Pointer; Offset, Size: LongWord); stdcall;
{68.27}   function LoadFile(FileName: PKolibriChar; var Size: LongWord): Pointer; stdcall;
{69.0}    procedure SetDebugBuffer(const Buffer: TDebugBuffer); stdcall;
{69.1}    procedure GetThreadContext(ID: LongWord; var Context: TThreadContext); stdcall;
{69.2}    procedure SetThreadContext(ID: LongWord; const Context: TThreadContext); stdcall;
{69.3}    procedure DetachThread(ID: LongWord); stdcall;
{69.4}    procedure SuspendThread(ID: LongWord); stdcall;
{69.5}    procedure ResumeThread(ID: LongWord); stdcall;
{69.6}    function ReadProcessMemory(ID, Count: LongWord; const Src; var Dst): LongInt; stdcall;
{69.7}    function WriteProcessMemory(ID, Count: LongWord; const Src; var Dst): LongInt; stdcall;
{69.8}    procedure DebugTerminate(ID: LongWord); stdcall;
{69.9}    function SetBreakPoint(ID: LongWord; Index, Flags: Byte; Address: Pointer): LongInt; stdcall;
{69.9}    function ResetBreakPoint(ID: LongWord; Index, Flags: Byte; Address: Pointer): LongInt; stdcall;
{70.0}    function ReadFile(FileName: PKolibriChar; var Buffer; Count: LongWord; Pos: UInt64; var BytesRead: LongWord): LongInt; stdcall;
{70.1}    function ReadFolder(Path: PKolibriChar; var Buffer; Count, Start, Flags: LongWord; var BlocksRead: LongWord): LongInt; stdcall;
{70.2}    function CreateFile(FileName: PKolibriChar): LongInt; stdcall;
{70.3}    function WriteFile(FileName: PKolibriChar; const Buffer; Count: LongWord; Pos: UInt64; var BytesWritten: LongWord): LongInt; stdcall;
{70.4}    function ResizeFile(FileName: PKolibriChar; Size: UInt64): LongInt; stdcall;
{70.5}    function GetFileAttributes(FileName: PKolibriChar; var Buffer: TFileAttributes): LongWord; stdcall;
{70.6}    function SetFileAttributes(FileName: PKolibriChar; var Buffer: TFileAttributes): LongWord; stdcall;
{70.7}    function RunFile(FileName, CmdLine: PKolibriChar): LongInt; stdcall;
{70.7}    function DebugFile(FileName, CommandLine: PKolibriChar): LongInt; stdcall;
{70.8}    function DeleteFile(FileName: PKolibriChar): LongInt; stdcall;
{70.9}    function CreateFolder(Path: PKolibriChar): LongInt; stdcall;
{71.1}    procedure SetWindowCaption(Caption: PKolibriChar); stdcall;
{72.1.2}  function SendActiveWindowKey(KeyCode: LongWord): LongInt; stdcall;
{72.1.3}  function SendActiveWindowButton(ButtonID: LongWord): LongInt; stdcall;
{73}      procedure Blit(const Src; SrcX, SrcY: LongInt; SrcW, SrcH: LongWord; DstX, DstY: LongInt; DstW, DstH, Stride, Flags: LongWord); stdcall;
{74.-1}   function GetActiveNetworkDevices: LongWord; stdcall;
{74.0}    function GetNetworkDeviceType(Device: Byte): LongInt; stdcall;
{74.1}    function GetNetworkDeviceName(Device: Byte; var Buffer): LongInt; stdcall;
{74.2}    function ResetNetworkDevice(Device: Byte): LongInt; stdcall;
{74.3}    function StopNetworkDevice(Device: Byte): LongInt; stdcall;
{74.4}    function GetNetworkDevicePointer(Device: Byte): Pointer; stdcall;
{74.5}    {UNDEFINED}
{74.6}    function GetSentPackets(Device: Byte): LongInt; stdcall;
{74.7}    function GetReceivedPackets(Device: Byte): LongInt; stdcall;
{74.8}    function GetSentBytes(Device: Byte): UInt64; stdcall;
{74.9}    function GetReceivedBytes(Device: Byte): UInt64; stdcall;
{74.10}   function GetLinkStatus(Device: Byte): LongInt; stdcall;
{75.0}    function SocketOpen(Domain, Kind, Protocol: LongWord): LongWord; stdcall; //////////////////////////
{75.1}    function SocketClose(Socket: LongWord): LongInt; stdcall;                                         //
{75.2}    function SocketBind(Socket: LongWord; var SockAddr: TSockAddr): LongInt; stdcall;                 //
{75.3}    function SocketListen(Socket: LongWord; var BackLog): LongInt; stdcall;                           //  BSD Sockets
{75.4}    function SocketConnect(Socket: LongWord; var SockAddr: TSockAddr): LongInt; stdcall;              //     API
{75.5}    function SocketAccept(Socket: LongWord; var SockAddr: TSockAddr): LongWord; stdcall;              //
{75.6}    function SocketSend(Socket: LongWord; const Buffer; Size, Flags: LongWord): LongInt; stdcall;     //
{75.7}    function SocketReceive(Socket: LongWord; var Buffer; Size, Flags: LongWord): LongInt; stdcall; /////
{75.8}    function SetSocketOptions(Socket: LongWord; var OptStruct: TOptStruct): LongInt; stdcall;
{75.9}    function GetSocketOptions(Socket: LongWord; var OptStruct: TOptStruct): LongInt; stdcall;
{75.10}   function GetSocketPair(var Socket1, Socket2: LongWord): LongInt; stdcall;
{76.0.0}  function GetMAC(Device: Byte): UInt64; stdcall;
{76.1.0}  function GetIPv4SentPackets(Device: Byte): LongWord; stdcall;
{76.1.1}  function GetIPv4ReceivedPackets(Device: Byte): LongWord; stdcall;
{76.1.2}  function GetIPv4IP(Device: Byte): LongWord; stdcall;
{76.1.3}  function SetIPv4IP(Device: Byte; IP: LongWord): LongWord; stdcall;
{76.1.4}  function GetIPv4DNS(Device: Byte): LongWord; stdcall;
{76.1.5}  function SetIPv4DNS(Device: Byte; DNS: LongWord): LongWord; stdcall;
{76.1.6}  function GetIPv4Subnet(Device: Byte): LongWord; stdcall;
{76.1.7}  function SetIPv4Subnet(Device: Byte; Subnet: LongWord): LongWord; stdcall;
{76.1.8}  function GetIPv4Gateway(Device: Byte): LongWord; stdcall;
{76.1.9}  function SetIPv4Gateway(Device: Byte; Gateway: LongWord): LongWord; stdcall;
{76.2.0}  function GetICMPSentPackets(Device: Byte): LongWord; stdcall;
{76.2.1}  function GetICMPReceivedPackets(Device: Byte): LongWord; stdcall;
{76.3.0}  function GetUDPSentPackets(Device: Byte): LongWord; stdcall;
{76.3.1}  function GetUDPReceivedPackets(Device: Byte): LongWord; stdcall;
{76.4.0}  function GetTCPSentPackets(Device: Byte): LongWord; stdcall;
{76.4.1}  function GetTCPReceivedPackets(Device: Byte): LongWord; stdcall;
{76.5.0}  function GetARPSentPackets(Device: Byte): LongWord; stdcall;
{76.5.1}  function GetARPReceivedPackets(Device: Byte): LongWord; stdcall;
{76.5.2}  function GetARPEntrys(Device: Byte): LongWord; stdcall;
{76.5.3}  function GetARPEntry(Device: Byte; Entry: LongWord; var Buffer): LongWord; stdcall;
{76.5.4}  function AddARPEntry(Device: Byte; const Buffer): LongWord; stdcall;
{76.5.5}  function RemoveARPEntry(Device: Byte; Entry: LongWord): LongWord; stdcall;
{76.5.6}  function SendARPAnnounce(Device: Byte): LongWord; stdcall;
{76.5.7}  function GetARPConflicts(Device: Byte): LongWord; stdcall;
{77.0}    function CreateFutex(Futex: Pointer): THandle; stdcall;
{77.1}    function DestroyFutex(Handle: THandle): LongInt; stdcall;
{77.2}    function WaitFutex(Handle: THandle; Value, Time: LongWord): LongInt; stdcall;
{77.3}    function WakeFutex(Handle: THandle; Waiters: LongWord): LongWord; stdcall;
          function GetProcAddress(hLib: Pointer; ProcName: PKolibriChar): Pointer; stdcall;

implementation

procedure TerminateThread; stdcall;
asm
        mov    eax, $FFFFFFFF
        int    $40
end;

procedure DrawWindow(Left, Top, Width, Height: LongInt; Caption: PKolibriChar; BackColor, Style, CapStyle: LongWord); stdcall;
asm
        push   ebx
        push   edi
        push   esi
        xor    eax, eax
        mov    ebx, Left
        mov    ecx, Top
        shl    ebx, 16
        shl    ecx, 16
        or     ebx, Width
        or     ecx, Height
        mov    edx, Style
        or     edx, BackColor
        mov    edi, Caption
        mov    esi, CapStyle
        int    $40
        pop    esi
        pop    edi
        pop    ebx
end;

procedure SetPixel(X, Y: LongInt; Color: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 1
        mov    ebx, X
        mov    ecx, Y
        mov    edx, Color
        int    $40
        pop    ebx
end;

function GetKey: TKeyboardInput; stdcall;
asm
        mov    eax, 2
        int    $40
end;

function GetSystemTime: TSystemTime; stdcall;
asm
        mov    eax, 3
        int    $40
end;

procedure DrawText(X, Y: LongInt; Text: PKolibriChar; ForeColor, BackColor, Flags, Count: LongWord); stdcall;
asm
        push   ebx
        push   edi
        push   esi
        mov    eax, 4
        mov    ebx, X
        shl    ebx, 16
        or     ebx, Y
        mov    ecx, Flags
        or     ecx, ForeColor
        mov    edx, Text
        mov    edi, BackColor
        mov    esi, Count
        int    $40
        pop    esi
        pop    edi
        pop    ebx
end;

procedure Sleep(Time: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 5
        mov    ebx, Time
        int    $40
        pop    ebx
end;

procedure DrawImage(const Image; X, Y: LongInt; Width, Height: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 7
        mov    ebx, Image
        mov    ecx, Width
        mov    edx, X
        shl    ecx, 16
        shl    edx, 16
        or     ecx, Height
        or     edx, Y
        int    $40
        pop    ebx
end;

procedure DrawButton(Left, Top, Width, Height: LongInt; BackColor, Style, ID: LongWord); stdcall;
asm
        push   ebx
        push   esi
        mov    eax, 8
        mov    ebx, Left
        mov    ecx, Top
        shl    ebx, 16
        shl    ecx, 16
        or     ebx, Width
        or     ecx, Height
        mov    edx, ID
        or     edx, Style
        mov    esi, BackColor
        int    $40
        pop    esi
        pop    ebx
end;

procedure DeleteButton(ID: LongWord); stdcall;
asm
        mov    eax, 8
        mov    edx, ID
        or     edx, $80000000
        int    $40
end;

function GetThreadInfo(Slot: LongWord; var Buffer: TThreadInfo): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 9
        mov    ebx, Buffer
        mov    ecx, Slot
        int    $40
        pop    ebx
end;

function WaitEvent: LongWord; stdcall;
asm
        mov    eax, 10
        int    $40
end;

function CheckEvent: LongWord; stdcall;
asm
        mov    eax, 11
        int    $40
end;

procedure BeginDraw; stdcall;
asm
        push   ebx
        mov    eax, 12
        mov    ebx, 1
        int    $40
        pop    ebx
end;

procedure EndDraw; stdcall;
asm
        push   ebx
        mov    eax, 12
        mov    ebx, 2
        int    $40
        pop    ebx
end;

procedure DrawRectangle(X, Y: LongInt; Width, Height: LongWord; Color: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 13
        mov    ebx, X
        mov    ecx, Y
        mov    edx, Color
        shl    ebx, 16
        shl    ecx, 16
        or     ebx, Width
        or     ecx, Height
        int    $40
        pop    ebx
end;

function GetScreenMax: TPoint; stdcall;
asm
        mov    eax, 14
        int    $40
end;

procedure SetBackgroundSize(Width, Height: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 15
        mov    ebx, 1
        mov    ecx, Width
        mov    edx, Height
        int    $40
        pop    ebx
end;

procedure SetBackgroundPixel(X, Y: LongInt; Color: LongWord); stdcall;
asm
        push   ebx
// at first need to know Background.Width
        mov    eax, 39
        mov    ebx, 1
        int    $40
// at now eax = (Width << 16) | Height
// need to make ecx = (X + Y * Background.Width) * 3
        shr    eax, 16
        mul    Y
        add    eax, X
        mov    ecx, eax
        add    ecx, eax
        add    ecx, eax
// and now SetBackgroundPixel
        mov    eax, 15
        mov    ebx, 2
        mov    edx, Color
        int    $40
        pop    ebx
end;

procedure DrawBackground; stdcall;
asm
        push   ebx
        mov    eax, 15
        mov    ebx, 3
        int    $40
        pop    ebx
end;

procedure SetBackgroundDrawMode(DrawMode: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 15
        mov    ebx, 4
        mov    ecx, DrawMode
        int    $40
        pop    ebx
end;

procedure DrawBackgroundImage(const Image; X, Y: LongInt; Width, Height: LongWord); stdcall;
asm
        push   ebx
        push   esi
// at first need to know Background.Width
        mov    eax, 39
        mov    ebx, 1
        int    $40
// at now eax = (Width << 16) | Height
// need to make edx = (X + Y * Background.Width) * 3
        shr    eax, 16
        mul    Y
        add    eax, X
        mov    edx, eax
        add    edx, eax
        add    edx, eax
// need to make esi = Width * Height * 3
        mov    eax, Width
        mul    Height
        mov    esi, eax
        add    esi, eax
        add    esi, eax
// and now DrawBackgroundImage
        mov    eax, 15
        mov    ebx, 5
        mov    ecx, Image
        int    $40
        pop    esi
        pop    ebx
end;

function MapBackground: Pointer; stdcall;
asm
        push   ebx
        mov    eax, 15
        mov    ebx, 6
        int    $40
        pop    ebx
end;

function UnmapBackground(Background: Pointer): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 15
        mov    ebx, 7
        mov    ecx, Background
        int    $40
        pop    ebx
end;

function GetLastDrawnBackgroundRect: TRect; stdcall;
asm
        push   ebx
        push   edi
        mov    edi, eax
        mov    eax, 15
        mov    ebx, 8
        int    $40
        movzx  edx, ax
        movzx  ecx, bx
        shr    eax, 16
        shr    ebx, 16
        mov    [edi].TRect.Left, eax
        mov    [edi].TRect.Right, edx
        mov    [edi].TRect.Top, ebx
        mov    [edi].TRect.Bottom, ecx
        pop    edi
        pop    ebx
end;

procedure UpdateBackgroundRect(Left, Top, Right, Bottom: LongInt); stdcall;
asm
        push   ebx
        mov    eax, 15
        mov    ebx, 9
        mov    ecx, Left
        mov    edx, Top
        shl    ecx, 16
        shl    edx, 16
        or     ecx, Right
        or     edx, Bottom
        int    $40
        pop    ebx
end;

function FlushFloppyCache(FloppyNumber: LongWord): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 15
        mov    ebx, FloppyNumber
        int    $40
        pop    ebx
end;

function GetButton: TButtonInput; stdcall;
asm
        mov    eax, 17
        int    $40
end;

procedure DeactivateWindow(Slot: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 1
        mov    ecx, Slot
        int    $40
        pop    ebx
end;

procedure TerminateThreadBySlot(Slot: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 2
        mov    ecx, Slot
        int    $40
        pop    ebx
end;

procedure ActivateWindow(Slot: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 3
        mov    ecx, Slot
        int    $40
        pop    ebx
end;

function GetIdleTime: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 4
        int    $40
        pop    ebx
end;

function GetCPUClock: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 5
        int    $40
        pop    ebx
end;

function SaveRamDisk(FileName: PKolibriChar): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 1
        mov    ecx, FileName
        int    $40
        pop    ebx
end;

function GetActiveWindow: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 7
        int    $40
        pop    ebx
end;

function GetSpeakerState: LongInt; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 8
        mov    ecx, 1
        int    $40
        pop    ebx
end;

procedure SwitchSpeakerState; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 8
        mov    ecx, 2
        int    $40
        pop    ebx
end;

function SystemShutdown(Param: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 9
        mov    ecx, Param
        int    $40
        pop    ebx
end;

procedure MinimizeActiveWindow; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 10
        int    $40
        pop    ebx
end;

procedure GetDiskSystemInfo(var Buffer); stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 11
        mov    ecx, Buffer
        int    $40
        pop    ebx
end;

procedure GetKernelVersion(var Buffer: TKernelVersion); stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 13
        mov    ecx, Buffer
        int    $40
        pop    ebx
end;

function WaitRetrace: LongInt; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 14
        int    $40
        pop    ebx
end;

function CenterMousePointer: LongInt; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 15
        int    $40
        pop    ebx
end;

function GetFreeMemory: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 16
        int    $40
        pop    ebx
end;

function GetAvailableMemory: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 17
        int    $40
        pop    ebx
end;

function TerminateThreadById(ID: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 18
        mov    ecx, ID
        int    $40
        pop    ebx
end;

function GetMouseSpeed: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 19
        mov    ecx, 0
        int    $40
        pop    ebx
end;

procedure SetMouseSpeed(Speed: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 19
        mov    ecx, 1
        mov    edx, Speed
        int    $40
        pop    ebx
end;

function GetMouseSensitivity: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 19
        mov    ecx, 2
        int    $40
        pop    ebx
end;

procedure SetMouseSensitivity(Sensitivity: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 19
        mov    ecx, 3
        mov    edx, Sensitivity
        int    $40
        pop    ebx
end;

procedure SetMousePos(X, Y: LongInt); stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 19
        mov    ecx, 4
        mov    edx, X
        shl    edx, 16
        or     edx, Y
        int    $40
        pop    ebx
end;

procedure SetMouseButtons(State: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 19
        mov    ecx, 5
        mov    edx, State
        int    $40
        pop    ebx
end;

function GetDoubleClickTime: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 19
        mov    ecx, 6
        int    $40
        pop    ebx
end;

procedure SetDoubleClickTime(Time: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 19
        mov    ecx, 7
        mov    edx, Time
        int    $40
        pop    ebx
end;

function GetRAMInfo(var Buffer: TRAMInfo): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 20
        mov    ecx, Buffer
        int    $40
        pop    ebx
end;

function GetSlotById(ID: LongWord): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 21
        mov    ecx, ID
        int    $40
        pop    ebx
end;

function MinimizeWindowBySlot(Slot: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 22
        mov    ecx, 0
        mov    edx, Slot
        int    $40
        pop    ebx
end;

function MinimizeWindowByID(ID: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 22
        mov    ecx, 1
        mov    edx, ID
        int    $40
        pop    ebx
end;

function RestoreWindowBySlot(Slot: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 22
        mov    ecx, 2
        mov    edx, Slot
        int    $40
        pop    ebx
end;

function RestoreWindowByID(ID: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 22
        mov    ecx, 3
        mov    edx, ID
        int    $40
        pop    ebx
end;

function MinimizeAllWindows: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 23
        int    $40
        pop    ebx
end;

procedure SetScreenLimits(Width, Height: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 24
        mov    ecx, Width
        mov    edx, Height
        int    $40
        pop    ebx
end;

function GetWindowZOrder(ID: LongWord): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 18
        mov    ebx, 25
        mov    ecx, 1
        mov    edx, ID
        int    $40
        pop    ebx
end;

function SetWindowZOrder(ID, ZOrder: LongWord): LongInt; stdcall;
asm
        push   ebx
        push   esi
        mov    eax, 18
        mov    ebx, 25
        mov    ecx, 2
        mov    edx, ID
        mov    esi, ZOrder
        int    $40
        pop    esi
        pop    ebx
end;

{UNDEFINED}

function ResetMidi: LongInt; stdcall;
asm
        push   ebx
        mov    eax, 20
        mov    ebx, 1
        int    $40
        pop    ebx
end;

function OutputMidi(Data: Byte): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 20
        mov    ebx, 2
        mov    cl, Data
        int    $40
        pop    ebx
end;

function SetMidiBase(Port: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 21
        mov    ebx, 1
        mov    ecx, Port
        int    $40
        pop    ebx
end;

function SetKeyboardLayout(Flags: LongWord; var Table: TKeyboardLayout): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 21
        mov    ebx, 2
        mov    ecx, Flags
        mov    edx, Table
        int    $40
        pop    ebx
end;

function SetKeyboardLayoutCountry(Country: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 21
        mov    ebx, 2
        mov    ecx, 9
        mov    edx, Country
        int    $40
        pop    ebx
end;

function SetSystemLanguage(SystemLanguage: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 21
        mov    ebx, 5
        mov    ecx, SystemLanguage
        int    $40
        pop    ebx
end;

function SetHDAccess(Value: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 21
        mov    ebx, 11
        mov    ecx, Value
        int    $40
        pop    ebx
end;

function SetPCIAccess(Value: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 21
        mov    ebx, 12
        mov    ecx, Value
        int    $40
        pop    ebx
end;

function SetSystemTime(Time: TSystemTime): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 22
        mov    ebx, 0
        mov    ecx, Time
        int    $40
        pop    ebx
end;

function SetSystemDate(Date: TSystemDate): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 22
        mov    ebx, 1
        mov    ecx, Date
        int    $40
        pop    ebx
end;

function SetDayOfWeek(DayOfWeek: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 22
        mov    ebx, 2
        mov    ecx, DayOfWeek
        int    $40
        pop    ebx
end;

function SetAlarm(Time: TSystemTime): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 22
        mov    ebx, 3
        mov    ecx, Time
        int    $40
        pop    ebx
end;

function WaitEventByTime(Time: LongWord): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 23
        mov    ebx, Time
        int    $40
        pop    ebx
end;

procedure OpenCDTray(Drive: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 24
        mov    ebx, 4
        mov    ecx, Drive
        int    $40
        pop    ebx
end;

procedure CloseCDTray(Drive: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 24
        mov    ebx, 5
        mov    ecx, Drive
        int    $40
        pop    ebx
end;

procedure DrawBackgroundLayerImage(const Image; X, Y: LongInt; Width, Height: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 25
        mov    ebx, Image
        mov    ecx, Width
        mov    edx, X
        shl    ecx, 16
        shl    edx, 16
        or     ecx, Height
        or     edx, Y
        int    $40
        pop    ebx
end;

function GetMidiBase: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 26
        mov    ebx, 1
        int    $40
        pop    ebx
end;

procedure GetKeyboardLayout(Flags: LongWord; var Table: TKeyboardLayout); stdcall;
asm
        push   ebx
        mov    eax, 26
        mov    ebx, 2
        mov    ecx, Flags
        mov    edx, Table
        int    $40
        pop    ebx
end;

function GetKeyboardLayoutCountry: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 26
        mov    ebx, 2
        mov    ecx, 9
        int    $40
        pop    ebx
end;

function GetSystemLanguage: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 26
        mov    ebx, 5
        int    $40
        pop    ebx
end;

function GetTickCount: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 26
        mov    ebx, 9
        int    $40
        pop    ebx
end;

function GetTickCount64: UInt64; stdcall;
asm
        push   ebx
        mov    eax, 26
        mov    ebx, 10
        int    $40
        pop    ebx
end;

function IsHDAccessAllowed: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 26
        mov    ebx, 11
        int    $40
        pop    ebx
end;

function IsPCIAccessAllowed: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 26
        mov    ebx, 12
        int    $40
        pop    ebx
end;

{UNDEFINED}

{UNDEFINED}

function GetSystemDate: TSystemDate; stdcall;
asm
        mov    eax, 29
        int    $40
end;

procedure SetCurrentDirectory(Path: PKolibriChar); stdcall;
asm
        push   ebx
        mov    eax, 30
        mov    ebx, 1
        mov    ecx, Path
        int    $40
        pop    ebx
end;

function GetCurrentDirectory(Buffer: PKolibriChar; Count: LongWord): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 30
        mov    ebx, 2
        mov    ecx, Buffer
        mov    edx, Count
        int    $40
        pop    ebx
end;

{UNDEFINED}

{UNDEFINED}

{UNDEFINED}

function GetPointOwner(X, Y: LongInt): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 34
        mov    ebx, X
        mov    ecx, Y
        int    $40
        pop    ebx
end;

function GetPixel(X, Y: LongInt): LongWord; stdcall;
asm
        push   ebx
// at first need to know Screen.Width
        mov    eax, 61
        mov    ebx, 1
        int    $40
// at now eax = (Width << 16) | Height
// need to make ebx = Y * Screen.Width + X
        shr    eax, 16
        mul    Y
        add    eax, X
        mov    ebx, eax
// and now GetPixel
        mov    eax, 35
        int    $40
        pop    ebx
end;

procedure GetScreenImage(var Buffer; X, Y: LongInt; Width, Height: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 36
        mov    ebx, Buffer
        mov    ecx, Width
        mov    edx, X
        shl    ecx, 16
        shl    edx, 16
        or     ecx, Height
        or     edx, Y
        int    $40
        pop    ebx
end;

function GetMousePos: TPoint; stdcall;
asm
        push   ebx
        mov    eax, 37
        mov    ebx, 0
        int    $40
        pop    ebx
end;

function GetWindowMousePos: TPoint; stdcall;
asm
        push   ebx
        mov    eax, 37
        mov    ebx, 1
        int    $40
        pop    ebx
end;

function GetMouseButtons: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 37
        mov    ebx, 2
        int    $40
        pop    ebx
end;

function GetMouseEvents: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 37
        mov    ebx, 3
        int    $40
        pop    ebx
end;

function LoadCursorFromFile(FileName: PKolibriChar): THandle; stdcall;
asm
        push   ebx
        mov    eax, 37
        mov    ebx, 4
        mov    ecx, FileName
        mov    edx, 0
        int    $40
        pop    ebx
end;

function LoadCursorFromMemory(const Buffer): THandle; stdcall;
asm
        push   ebx
        mov    eax, 37
        mov    ebx, 4
        mov    ecx, Buffer
        mov    edx, 1
        int    $40
        pop    ebx
end;

function LoadCursorIndirect(const Buffer; HotSpotX, HotSpotY: ShortInt): THandle; stdcall;
asm
        push   ebx
        mov    eax, 37
        mov    ebx, 4
        mov    ecx, Buffer
        mov    dl, HotSpotY
        mov    dh, HotSpotX
        shl    edx, 16
        or     edx, 2
        int    $40
        pop    ebx
end;

function SetCursor(Handle: THandle): THandle; stdcall;
asm
        push   ebx
        mov    eax, 37
        mov    ebx, 5
        mov    ecx, Handle
        int    $40
        pop    ebx
end;

procedure DeleteCursor(Handle: THandle); stdcall;
asm
        push   ebx
        mov    eax, 37
        mov    ebx, 6
        mov    ecx, Handle
        int    $40
        pop    ebx
end;

function GetMouseScroll: TPoint; stdcall;
asm
        push   ebx
        mov    eax, 37
        mov    ebx, 7
        int    $40
        pop    ebx
end;

procedure DrawLine(X1, Y1, X2, Y2: LongInt; Color: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 38
        mov    ebx, X1
        mov    ecx, Y1
        shl    ebx, 16
        shl    ecx, 16
        or     ebx, X2
        or     ecx, Y2
        mov    edx, Color
        int    $40
        pop    ebx
end;

function GetBackgroundSize: TSize; stdcall;
asm
        push   ebx
        mov    eax, 39
        mov    ebx, 1
        int    $40
        pop    ebx
end;

function GetBackgroundPixel(X, Y: LongInt): LongWord; stdcall;
asm
        push   ebx
// at first need to know Background.Width
        mov    eax, 39
        mov    ebx, 1
        int    $40
// at now eax = (Width << 16) | Height
// need to make ecx = (X + Y * Background.Width) * 3
        shr    eax, 16
        mul    Y
        add    eax, X
        mov    ecx, eax
        add    ecx, eax
        add    ecx, eax
// and now GetBackgroundPixel
        mov    eax, 39
        mov    ebx, 2
        int    $40
        pop    ebx
end;

function GetBackgroundDrawMode: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 39
        mov    ebx, 4
        int    $40
        pop    ebx
end;

function SetEventMask(Mask: LongWord): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 40
        mov    ebx, Mask
        int    $40
        pop    ebx
end;

{UNDEFINED}

{UNDEFINED}

function InPort(Port: LongWord; var Data: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 43
        mov    ecx, Port
        or     ecx, $80000000
        int    $40
        mov    ecx, Data
        mov    [ecx], bl
        pop    ebx
end;

function OutPort(Port: LongWord; Data: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 43
        mov    bl, Data
        mov    ecx, Port
        int    $40
        pop    ebx
end;

{UNDEFINED}

{UNDEFINED}

function ReservePorts(First, Last: LongWord): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 46
        mov    ebx, 0
        mov    ecx, First
        mov    edx, Last
        int    $40
        pop    ebx
end;

function FreePorts(First, Last: LongWord): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 46
        mov    ebx, 1
        mov    ecx, First
        mov    edx, Last
        int    $40
        pop    ebx
end;

{DrawNumber}

procedure ApplyStyleSettings; stdcall;
asm
        push   ebx
        mov    eax, 48
        mov    ebx, 0
        int    $40
        pop    ebx
end;

procedure SetButtonStyle(ButtonStyle: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 48
        mov    ebx, 1
        mov    ecx, ButtonStyle
        int    $40
        pop    ebx
end;

procedure SetStandardColors(var ColorTable: TStandardColors; Size: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 48
        mov    ebx, 2
        mov    ecx, ColorTable
        mov    edx, Size
        int    $40
        pop    ebx
end;

procedure GetStandardColors(var ColorTable: TStandardColors; Size: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 48
        mov    ebx, 3
        mov    ecx, ColorTable
        mov    edx, Size
        int    $40
        pop    ebx
end;

function GetSkinHeight: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 48
        mov    ebx, 4
        int    $40
        pop    ebx
end;

function GetScreenWorkingArea: TRect; stdcall;
asm
        push   ebx
        push   edi
        mov    edi, eax
        mov    eax, 48
        mov    ebx, 5
        int    $40
        movzx  edx, ax
        movzx  ecx, bx
        shr    eax, 16
        shr    ebx, 16
        mov    [edi].TRect.Left, eax
        mov    [edi].TRect.Right, edx
        mov    [edi].TRect.Top, ebx
        mov    [edi].TRect.Bottom, ecx
        pop    edi
        pop    ebx
end;

procedure SetScreenWorkingArea(Left, Top, Right, Bottom: LongInt); stdcall;
asm
        push   ebx
        mov    eax, 48
        mov    ebx, 6
        mov    ecx, Left
        mov    edx, Top
        shl    ecx, 16
        shl    edx, 16
        or     ecx, Right
        or     edx, Bottom
        int    $40
        pop    ebx
end;

function GetSkinMargins: TRect; stdcall;
asm
        push   ebx
        push   edi
        mov    edi, eax
        mov    eax, 48
        mov    ebx, 7
        int    $40
        movzx  edx, ax
        movzx  ecx, bx
        shr    eax, 16
        shr    ebx, 16
        mov    [edi].TRect.Left, eax
        mov    [edi].TRect.Right, edx
        mov    [edi].TRect.Top, ebx
        mov    [edi].TRect.Bottom, ecx
        pop    edi
        pop    ebx
end;

function SetSkin(FileName: PKolibriChar): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 48
        mov    ebx, 8
        mov    ecx, FileName
        int    $40
        pop    ebx
end;

function GetFontSmoothing: LongInt; stdcall;
asm
        push   ebx
        mov    eax, 48
        mov    ebx, 9
        int    $40
        pop    ebx
end;

procedure SetFontSmoothing(Smoothing: LongInt); stdcall;
asm
        push   ebx
        mov    eax, 48
        mov    ebx, 10
        mov    ecx, Smoothing
        int    $40
        pop    ebx
end;

function GetFontHeight: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 48
        mov    ebx, 11
        int    $40
        pop    ebx
end;

procedure SetFontHeight(Height: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 48
        mov    ebx, 12
        mov    ecx, Height
        int    $40
        pop    ebx
end;

{Advanced Power Management}

procedure SetWindowShape(const Data); stdcall;
asm
        push   ebx
        mov    eax, 50
        mov    ebx, 0
        mov    ecx, Data
        int    $40
        pop    ebx
end;

procedure SetWindowScale(Scale: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 50
        mov    ebx, 1
        mov    ecx, Scale
        int    $40
        pop    ebx
end;

function CreateThread(Entry, Stack: Pointer): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 51
        mov    ebx, 1
        mov    ecx, Entry
        mov    edx, Stack
        int    $40
        pop    ebx
end;

{UNDEFINED}

{UNDEFINED}

function GetClipboardSlotCount: LongInt; stdcall;
asm
        push   ebx
        mov    eax, 54
        mov    ebx, 0
        int    $40
        pop    ebx
end;

function GetClipboardData(Slot: LongWord): Pointer; stdcall;
asm
        push   ebx
        mov    eax, 54
        mov    ebx, 1
        mov    ecx, Slot
        int    $40
        pop    ebx
end;

function SetClipboardData(const Src; Count: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 54
        mov    ebx, 2
        mov    ecx, Count
        mov    edx, Src
        int    $40
        pop    ebx
end;

function DeleteClipboardLastSlot: LongInt; stdcall;
asm
        push   ebx
        mov    eax, 54
        mov    ebx, 3
        int    $40
        pop    ebx
end;

function ResetClipboard: LongInt; stdcall;
asm
        push   ebx
        mov    eax, 54
        mov    ebx, 4
        int    $40
        pop    ebx
end;

function SpeakerPlay(const Data): LongWord; stdcall;
asm
        push   ebx
        push   esi
        mov    eax, 55
        mov    ebx, 55
        mov    esi, Data
        int    $40
        pop    esi
        pop    ebx
end;

{UNDEFINED}

{PCI BIOS}

{UNDEFINED}

{UNDEFINED}

function IPCSetBuffer(const Buffer: TIPCBuffer; Size: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 60
        mov    ebx, 1
        mov    ecx, Buffer
        mov    edx, Size
        int    $40
        pop    ebx
end;

function IPCSendMessage(ID: LongWord; var Msg: TIPCMessage; Size: LongWord): LongInt; stdcall;
asm
        push   ebx
        push   esi
        mov    eax, 60
        mov    ebx, 2
        mov    ecx, ID
        mov    edx, Msg
        mov    esi, Size
        int    $40
        pop    esi
        pop    ebx
end;

function GetScreenSize: TSize; stdcall;
asm
        push   ebx
        mov    eax, 61
        mov    ebx, 1
        int    $40
        pop    ebx
end;

function GetScreenBitsPerPixel: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 61
        mov    ebx, 2
        int    $40
        pop    ebx
end;

function GetScreenBytesPerScanLine: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 61
        mov    ebx, 3
        int    $40
        pop    ebx
end;

function GetPCIVersion: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 62
        mov    bl, 0
        int    $40
        pop    ebx
end;

function GetLastPCIBus: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 62
        mov    bl, 1
        int    $40
        pop    ebx
end;

function GetPCIAddressingMode: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 62
        mov    bl, 2
        int    $40
        pop    ebx
end;

function ReadPCIByte(Bus, Device, Func, Reg: Byte): Byte; stdcall;
asm
        push   ebx
        mov    eax, 62
        mov    bl, 4
        mov    bh, Bus
        mov    cl, Reg
        mov    ch, Device
        shl    ch, 3
        or     ch, Func
        int    $40
        pop    ebx
end;

function ReadPCIWord(Bus, Device, Func, Reg: Byte): Word; stdcall;
asm
        push   ebx
        mov    eax, 62
        mov    bl, 5
        mov    bh, Bus
        mov    cl, Reg
        mov    ch, Device
        shl    ch, 3
        or     ch, Func
        int    $40
        pop    ebx
end;

function ReadPCILongWord(Bus, Device, Func, Reg: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 62
        mov    bl, 6
        mov    bh, Bus
        mov    cl, Reg
        mov    ch, Device
        shl    ch, 3
        or     ch, Func
        int    $40
        pop    ebx
end;

function WritePCIByte(Bus, Device, Func, Reg: Byte; Data: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 62
        mov    bl, 8
        mov    bh, Bus
        mov    cl, Reg
        mov    ch, Device
        shl    ch, 3
        or     ch, Func
        mov    dl, Data
        int    $40
        pop    ebx
end;

function WritePCIWord(Bus, Device, Func, Reg: Byte; Data: Word): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 62
        mov    bl, 9
        mov    bh, Bus
        mov    cl, Reg
        mov    ch, Device
        shl    ch, 3
        or     ch, Func
        mov    dx, Data
        int    $40
        pop    ebx
end;

function WritePCILongWord(Bus, Device, Func, Reg: Byte; Data: LongWord): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 62
        mov    bl, 10
        mov    bh, Bus
        mov    cl, Reg
        mov    ch, Device
        shl    ch, 3
        or     ch, Func
        mov    edx, Data
        int    $40
        pop    ebx
end;

procedure DebugWrite(Data: Byte); stdcall;
asm
        push   ebx
        mov    eax, 63
        mov    ebx, 1
        mov    cl, Data
        int    $40
        pop    ebx
end;

function DebugRead(var Data: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 63
        mov    ebx, 2
        int    $40
        mov    ecx, Data
        mov    [ecx], al
        mov    eax, ebx
        pop    ebx
end;

function ReallocAppMemory(Count: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 64
        mov    ebx, 1
        mov    ecx, Count
        int    $40
        pop    ebx
end;

procedure DrawImageEx(const Image; Left, Top: LongInt; Width, Height, BPP: LongWord; Palette: Pointer; Padding: LongWord); stdcall;
asm
        push   ebx
        push   esi
        push   edi
        mov    eax, 65
        mov    ebx, Image
        mov    ecx, Width
        mov    edx, Left
        shl    ecx, 16
        shl    edx, 16
        or     ecx, Height
        or     edx, Top
        mov    esi, BPP
        mov    edi, Palette
        mov    ebp, Padding
        int    $40
        pop    edi
        pop    esi
        pop    ebx
end;

procedure SetKeyboardInputMode(Mode: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 66
        mov    ebx, 1
        mov    ecx, Mode
        int    $40
        pop    ebx
end;

function GetKeyboardInputMode: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 66
        mov    ebx, 2
        int    $40
        pop    ebx
end;

function GetControlKeyState: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 66
        mov    ebx, 3
        int    $40
        pop    ebx
end;

function SetHotKey(ScanCode, Control: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 66
        mov    ebx, 4
        mov    ecx, ScanCode
        mov    edx, Control
        int    $40
        pop    ebx
end;

function ResetHotKey(ScanCode, Control: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 66
        mov    ebx, 4
        mov    ecx, ScanCode
        mov    edx, Control
        int    $40
        pop    ebx
end;

procedure LockKeyboard; stdcall;
asm
        push   ebx
        mov    eax, 66
        mov    ebx, 6
        int    $40
        pop    ebx
end;

procedure UnlockKeyboard; stdcall;
asm
        push   ebx
        mov    eax, 66
        mov    ebx, 7
        int    $40
        pop    ebx
end;

procedure SetWindowPos(Left, Top, Right, Bottom: LongInt); stdcall;
asm
        push   ebx
        push   esi
        mov    eax, 67
        mov    ebx, Left
        mov    ecx, Top
        mov    edx, Right
        mov    esi, Bottom
        int    $40
        pop    esi
        pop    ebx
end;

function GetTaskSwitchCount: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 68
        mov    ebx, 0
        int    $40
        pop    ebx
end;

procedure SwitchThread; stdcall;
asm
        push   ebx
        mov    eax, 68
        mov    ebx, 1
        int    $40
        pop    ebx
end;

function EnableRDPMC: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 68
        mov    ebx, 2
        mov    ecx, 0
        int    $40
        pop    ebx
end;

function IsCacheEnabled: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 68
        mov    ebx, 2
        mov    ecx, 1
        int    $40
        pop    ebx
end;

procedure EnableCache; stdcall;
asm
        push   ebx
        mov    eax, 68
        mov    ebx, 2
        mov    ecx, 2
        int    $40
        pop    ebx
end;

procedure DisableCache; stdcall;
asm
        push   ebx
        mov    eax, 68
        mov    ebx, 2
        mov    ecx, 3
        int    $40
        pop    ebx
end;

function HeapInit: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 68
        mov    ebx, 11
        int    $40
        pop    ebx
end;

function HeapAllocate(Bytes: LongWord): Pointer; stdcall;
asm
        push   ebx
        mov    eax, 68
        mov    ebx, 12
        mov    ecx, Bytes
        int    $40
        pop    ebx
end;

function HeapFree(MemPtr: Pointer): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 68
        mov    ebx, 13
        mov    ecx, MemPtr
        int    $40
        pop    ebx
end;

procedure WaitSignal(var Buffer: TSignalBuffer); stdcall;
asm
        push   ebx
        mov    eax, 68
        mov    ebx, 14
        mov    ecx, Buffer
        int    $40
        pop    ebx
end;

function LoadDriver(Name: PKolibriChar): THandle; stdcall;
asm
        push   ebx
        mov    eax, 68
        mov    ebx, 16
        mov    ecx, Name
        int    $40
        pop    ebx
end;

function ControlDriver(var CtrlStructure: TDriverControl): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 68
        mov    ebx, 17
        mov    ecx, CtrlStructure
        int    $40
        pop    ebx
end;

function LoadLibrary(FileName: PKolibriChar): Pointer; stdcall;
asm
        push   ebx
        mov    eax, 68
        mov    ebx, 19
        mov    ecx, FileName
        int    $40
        pop    ebx
end;

function HeapReallocate(MemPtr: Pointer; Bytes: LongWord): Pointer; stdcall;
asm
        push   ebx
        mov    eax, 68
        mov    ebx, 20
        mov    ecx, Bytes
        mov    edx, MemPtr
        int    $40
        pop    ebx
end;

function LoadPEDriver(Name, CmdLine: PKolibriChar): THandle; stdcall;
asm
        push   ebx
        mov    eax, 68
        mov    ebx, 21
        mov    ecx, Name
        mov    edx, CmdLine
        int    $40
        pop    ebx
end;

function OpenSharedMemory(Name: PKolibriChar; Bytes: LongWord; Flags: LongWord): Pointer; stdcall;
asm
        push   ebx
        push   esi
        mov    eax, 68
        mov    ebx, 22
        mov    ecx, Name
        mov    edx, Bytes
        mov    esi, Flags
        int    $40
        pop    esi
        pop    ebx
end;

function CloseSharedMemory(Name: PKolibriChar): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 68
        mov    ebx, 23
        mov    ecx, Name
        int    $40
        pop    ebx
end;

function SetExceptionHandler(Handler: Pointer; Mask: LongWord; var OldMask: LongWord): Pointer; stdcall;
asm
        push   ebx
        mov    eax, 68
        mov    ebx, 24
        mov    ecx, Handler
        mov    edx, Mask
        int    $40
        mov    ecx, OldMask
        mov    [ecx], ebx
        pop    ebx
end;

function SetExceptionActivity(Signal, Activity: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 68
        mov    ebx, 25
        mov    ecx, Signal
        mov    edx, Activity
        int    $40
        pop    ebx
end;

procedure ReleaseMemoryPages(MemPtr: Pointer; Offset, Size: LongWord); stdcall;
asm
        push   ebx
        push   esi
        mov    eax, 68
        mov    ebx, 26
        mov    ecx, MemPtr
        mov    edx, &Offset
        mov    esi, Size
        int    $40
        pop    esi
        pop    ebx
end;

function LoadFile(FileName: PKolibriChar; var Size: LongWord): Pointer; stdcall;
asm
        push   ebx
        mov    eax, 68
        mov    ebx, 27
        mov    ecx, FileName
        int    $40
        mov    ecx, Size
        mov    [ecx], edx
        pop    ebx
end;

procedure SetDebugBuffer(const Buffer: TDebugBuffer); stdcall;
asm
        push   ebx
        mov    eax, 69
        mov    ebx, 0
        mov    ecx, Buffer
        int    $40
        pop    ebx
end;

procedure GetThreadContext(ID: LongWord; var Context: TThreadContext); stdcall;
const
  SIZEOF_TTHREADCONTEXT = SizeOf(TThreadContext);
asm
        push   ebx
        push   esi
        mov    eax, 69
        mov    ebx, 1
        mov    ecx, ID
        mov    edx, SIZEOF_TTHREADCONTEXT
        mov    esi, Context
        int    $40
        pop    esi
        pop    ebx
end;

procedure SetThreadContext(ID: LongWord; const Context: TThreadContext); stdcall;
const
  SIZEOF_TTHREADCONTEXT = SizeOf(TThreadContext);
asm
        push   ebx
        push   esi
        mov    eax, 69
        mov    ebx, 2
        mov    ecx, ID
        mov    edx, SIZEOF_TTHREADCONTEXT
        mov    esi, Context
        int    $40
        pop    esi
        pop    ebx
end;

procedure DetachThread(ID: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 69
        mov    ebx, 3
        mov    ecx, ID
        int    $40
        pop    ebx
end;

procedure SuspendThread(ID: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 69
        mov    ebx, 4
        mov    ecx, ID
        int    $40
        pop    ebx
end;

procedure ResumeThread(ID: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 69
        mov    ebx, 5
        mov    ecx, ID
        int    $40
        pop    ebx
end;

function ReadProcessMemory(ID, Count: LongWord; const Src; var Dst): LongInt; stdcall;
asm
        push   ebx
        push   esi
        push   edi
        mov    eax, 69
        mov    ebx, 6
        mov    ecx, ID
        mov    edx, Count
        mov    esi, Src
        mov    edi, Dst
        int    $40
        pop    edi
        pop    esi
        pop    ebx
end;

function WriteProcessMemory(ID, Count: LongWord; const Src; var Dst): LongInt; stdcall;
asm
        push   ebx
        push   esi
        push   edi
        mov    eax, 69
        mov    ebx, 7
        mov    ecx, ID
        mov    edx, Count
        mov    esi, Dst
        mov    edi, Src
        int    $40
        pop    edi
        pop    esi
        pop    ebx
end;

procedure DebugTerminate(ID: LongWord); stdcall;
asm
        push   ebx
        mov    eax, 69
        mov    ebx, 8
        mov    ecx, ID
        int    $40
        pop    ebx
end;

function SetBreakPoint(ID: LongWord; Index, Flags: Byte; Address: Pointer): LongInt; stdcall;
asm
        push   ebx
        push   esi
        mov    eax, 69
        mov    ebx, 9
        mov    ecx, ID
        mov    dl, Index
        mov    dh, Flags
        mov    esi, Address
        int    $40
        pop    esi
        pop    ebx
end;

function ResetBreakPoint(ID: LongWord; Index, Flags: Byte; Address: Pointer): LongInt; stdcall;
asm
        push   ebx
        push   esi
        mov    eax, 69
        mov    ebx, 9
        mov    ecx, ID
        mov    dl, Index
        mov    dh, Flags
        or     dh, $80
        mov    esi, Address
        int    $40
        pop    esi
        pop    ebx
end;

function ReadFile(FileName: PKolibriChar; var Buffer; Count: LongWord; Pos: UInt64; var BytesRead: LongWord): LongInt; stdcall;
asm
        push   ebx
        push   FileName
        dec    esp
        mov    byte[esp], 0
        push   Buffer
        push   Count
        push   dword[Pos+4]
        push   dword[Pos]
        push   0
        mov    ebx, esp
        mov    eax, 70
        int    $40
        add    esp, 25
        mov    ecx, BytesRead
        mov    [ecx], ebx
        pop    ebx
end;

function ReadFolder(Path: PKolibriChar; var Buffer; Count, Start, Flags: LongWord; var BlocksRead: LongWord): LongInt; stdcall;
asm
        push   ebx
        push   Path
        dec    esp
        mov    byte[esp], 0
        push   Buffer
        push   Count
        push   Flags
        push   Start
        push   1
        mov    ebx, esp
        mov    eax, 70
        int    $40
        add    esp, 25
        mov    ecx, BlocksRead
        mov    [ecx], ebx
        pop    ebx
end;

function CreateFile(FileName: PKolibriChar): LongInt; stdcall;
asm
        push   ebx
        push   FileName
        dec    esp
        mov    byte[esp], 0
        push   0
        push   0
        push   0
        push   0
        push   2
        mov    ebx, esp
        mov    eax, 70
        int    $40
        add    esp, 25
        pop    ebx
end;

function WriteFile(FileName: PKolibriChar; const Buffer; Count: LongWord; Pos: UInt64; var BytesWritten: LongWord): LongInt; stdcall;
asm
        push   ebx
        push   FileName
        dec    esp
        mov    byte[esp], 0
        push   Buffer
        push   Count
        push   dword[Pos+4]
        push   dword[Pos]
        push   3
        mov    ebx, esp
        mov    eax, 70
        int    $40
        add    esp, 25
        mov    ecx, BytesWritten
        mov    [ecx], ebx
        pop    ebx
end;

function ResizeFile(FileName: PKolibriChar; Size: UInt64): LongInt; stdcall;
asm
        push   ebx
        push   FileName
        dec    esp
        mov    byte[esp], 0
        push   0
        push   0
        push   dword [Size+4]
        push   dword [Size]
        push   4
        mov    ebx, esp
        mov    eax, 70
        int    $40
        add    esp, 25
        pop    ebx
end;

function GetFileAttributes(FileName: PKolibriChar; var Buffer: TFileAttributes): LongWord; stdcall;
asm
        push   ebx
        push   FileName
        dec    esp
        mov    byte[esp], 0
        push   Buffer
        push   0
        push   0
        push   0
        push   5
        mov    ebx, esp
        mov    eax, 70
        int    $40
        add    esp, 25
        pop    ebx
end;

function SetFileAttributes(FileName: PKolibriChar; var Buffer: TFileAttributes): LongWord; stdcall;
asm
        push   ebx
        push   FileName
        dec    esp
        mov    byte[esp], 0
        push   Buffer
        push   0
        push   0
        push   0
        push   6
        mov    ebx, esp
        mov    eax, 70
        int    $40
        add    esp, 25
        pop    ebx
end;

function RunFile(FileName, CmdLine: PKolibriChar): LongInt; stdcall;
asm
        push   ebx
        push   FileName
        dec    esp
        mov    byte[esp], 0
        push   0
        push   0
        push   CmdLine
        push   0
        push   7
        mov    ebx, esp
        mov    eax, 70
        int    $40
        add    esp, 25
        pop    ebx
end;

function DebugFile(FileName, CommandLine: PKolibriChar): LongInt; stdcall;
asm
        push   ebx
        push   FileName
        dec    esp
        mov    byte[esp], 0
        push   0
        push   0
        push   CommandLine
        push   1
        push   7
        mov    ebx, esp
        mov    eax, 70
        int    $40
        add    esp, 25
        pop    ebx
end;

function DeleteFile(FileName: PKolibriChar): LongInt; stdcall;
asm
        push   ebx
        push   FileName
        dec    esp
        mov    byte[esp], 0
        push   0
        push   0
        push   0
        push   0
        push   8
        mov    ebx, esp
        mov    eax, 70
        int    $40
        add    esp, 25
        pop    ebx
end;

function CreateFolder(Path: PKolibriChar): LongInt; stdcall;
asm
        push   ebx
        push   Path
        dec    esp
        mov    byte[esp], 0
        push   0
        push   0
        push   0
        push   0
        push   9
        mov    ebx, esp
        mov    eax, 70
        int    $40
        add    esp, 25
        pop    ebx
end;

procedure SetWindowCaption(Caption: PKolibriChar); stdcall;
asm
        push   ebx
        mov    eax, 71
        mov    ebx, 1
        mov    ecx, Caption
        int    $40
        pop    ebx
end;

function SendActiveWindowKey(KeyCode: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 72
        mov    ebx, 1
        mov    ecx, 2
        mov    edx, KeyCode
        int    $40
        pop    ebx
end;

function SendActiveWindowButton(ButtonID: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 72
        mov    ebx, 1
        mov    ecx, 3
        mov    edx, ButtonID
        int    $40
        pop    ebx
end;

procedure Blit(const Src; SrcX, SrcY: LongInt; SrcW, SrcH: LongWord; DstX, DstY: LongInt; DstW, DstH, Stride, Flags: LongWord); stdcall;
asm
        push   ebx
        push   Stride
        push   Src
        push   SrcH
        push   SrcW
        push   SrcY
        push   SrcX
        push   DstH
        push   DstW
        push   DstY
        push   DstX
        mov    eax, 73
        mov    ebx, Flags
        mov    ecx, esp
        int    $40
        add    esp, 40
        pop    ebx
end;

function GetActiveNetworkDevices: LongWord; stdcall;
asm
        push   ebx
        mov    eax, 74
        mov    bl, -1
        int    $40
        pop    ebx
end;

function GetNetworkDeviceType(Device: Byte): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 74
        mov    bl, 0
        mov    bh, Device
        int    $40
        pop    ebx
end;

function GetNetworkDeviceName(Device: Byte; var Buffer): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 74
        mov    bl, 1
        mov    bh, Device
        mov    ecx, Buffer
        int    $40
        pop    ebx
end;

function ResetNetworkDevice(Device: Byte): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 74
        mov    bl, 2
        mov    bh, Device
        int    $40
        pop    ebx
end;

function StopNetworkDevice(Device: Byte): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 74
        mov    bl, 3
        mov    bh, Device
        int    $40
        pop    ebx
end;

function GetNetworkDevicePointer(Device: Byte): Pointer; stdcall;
asm
        push   ebx
        mov    eax, 74
        mov    bl, 4
        mov    bh, Device
        int    $40
        pop    ebx
end;

function GetSentPackets(Device: Byte): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 74
        mov    bl, 6
        mov    bh, Device
        int    $40
        pop    ebx
end;

function GetReceivedPackets(Device: Byte): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 74
        mov    bl, 7
        mov    bh, Device
        int    $40
        pop    ebx
end;

function GetSentBytes(Device: Byte): UInt64; stdcall;
asm
        push   ebx
        mov    eax, 74
        mov    bl, 8
        mov    bh, Device
        int    $40
        cmp    eax, -1
        jz     @error
        mov    edx, ebx
        jmp @end
@error:
        mov    edx, eax
@end:
        pop    ebx
end;

function GetReceivedBytes(Device: Byte): UInt64; stdcall;
asm
        push   ebx
        mov    eax, 74
        mov    bl, 9
        mov    bh, Device
        int    $40
        cmp    eax, -1
        jz     @error
        mov    edx, ebx
        jmp @end
@error:
        mov    edx, eax
@end:
        pop    ebx
end;

function GetLinkStatus(Device: Byte): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 74
        mov    bl, 10
        mov    bh, Device
        int    $40
        pop    ebx
end;

function SocketOpen(Domain, Kind, Protocol: LongWord): LongWord; stdcall;
asm
        push   ebx
        push   esi
        mov    eax, 75
        mov    bl, 0
        mov    ecx, Domain
        mov    edx, Kind
        mov    esi, Protocol
        int    $40
        pop    esi
        pop    ebx
end;

function SocketClose(Socket: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 75
        mov    bl, 1
        mov    ecx, Socket
        int    $40
        pop    ebx
end;

function SocketBind(Socket: LongWord; var SockAddr: TSockAddr): LongInt; stdcall;
const
  SIZEOF_TSOCKADDR = SizeOf(TSockAddr);
asm
        push   ebx
        push   esi
        mov    eax, 75
        mov    bl, 2
        mov    ecx, Socket
        mov    edx, SockAddr
        mov    esi, SIZEOF_TSOCKADDR
        int    $40
        pop    esi
        pop    ebx
end;

function SocketListen(Socket: LongWord; var BackLog): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 75
        mov    bl, 3
        mov    ecx, Socket
        mov    edx, BackLog
        int    $40
        pop    ebx
end;

function SocketConnect(Socket: LongWord; var SockAddr: TSockAddr): LongInt; stdcall;
const
  SIZEOF_TSOCKADDR = SizeOf(TSockAddr);
asm
        push   ebx
        push   esi
        mov    eax, 75
        mov    bl, 4
        mov    ecx, Socket
        mov    edx, SockAddr
        mov    esi, SIZEOF_TSOCKADDR
        int    $40
        pop    esi
        pop    ebx
end;

function SocketAccept(Socket: LongWord; var SockAddr: TSockAddr): LongWord; stdcall;
const SIZEOF_TSOCKADDR = SizeOf(TSockAddr);
asm
        push   ebx
        push   esi
        mov    eax, 75
        mov    bl, 5
        mov    ecx, Socket
        mov    edx, SockAddr
        mov    esi, SIZEOF_TSOCKADDR
        int    $40
        pop    esi
        pop    ebx
end;

function SocketSend(Socket: LongWord; const Buffer; Size, Flags: LongWord): LongInt; stdcall;
asm
        push   ebx
        push   esi
        push   edi
        mov    eax, 75
        mov    bl, 6
        mov    ecx, Socket
        mov    edx, Buffer
        mov    esi, Size
        mov    edi, Flags
        int    $40
        pop    edi
        pop    esi
        pop    ebx
end;

function SocketReceive(Socket: LongWord; var Buffer; Size, Flags: LongWord): LongInt; stdcall;
asm
        push   ebx
        push   esi
        push   edi
        mov    eax, 75
        mov    bl, 7
        mov    ecx, Socket
        mov    edx, Buffer
        mov    esi, Size
        mov    edi, Flags
        int    $40
        pop    edi
        pop    esi
        pop    ebx
end;

function SetSocketOptions(Socket: LongWord; var OptStruct: TOptStruct): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 75
        mov    bl, 8
        mov    ecx, Socket
        mov    edx, OptStruct
        int    $40
        pop    ebx
end;

function GetSocketOptions(Socket: LongWord; var OptStruct: TOptStruct): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 75
        mov    bl, 9
        mov    ecx, Socket
        mov    edx, OptStruct
        int    $40
        pop    ebx
end;

function GetSocketPair(var Socket1, Socket2: LongWord): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 75
        mov    bl, 10
        int    $40
        mov    ecx, Socket1
        mov    edx, Socket2
        mov    [ecx], eax
        mov    [edx], ebx
        pop    ebx
end;

function GetMAC(Device: Byte): UInt64; stdcall;
asm
        push   ebx
        mov    eax, 76
        xor    ebx, ebx
        mov    bh, Device
        int    $40
        cmp    ebx, -1
        je     @error
        movzx  edx, bx
        jmp    @end
@error:
        mov    edx, eax
@end:
        pop    ebx
end;

function GetIPv4SentPackets(Device: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00010000
        mov    bl, 0
        mov    bh, Device
        int    $40
        pop    ebx
end;

function GetIPv4ReceivedPackets(Device: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00010000
        mov    bl, 1
        mov    bh, Device
        int    $40
        pop    ebx
end;

function GetIPv4IP(Device: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00010000
        mov    bl, 2
        mov    bh, Device
        int    $40
        pop    ebx
end;

function SetIPv4IP(Device: Byte; IP: LongWord): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00010000
        mov    bl, 3
        mov    bh, Device
        mov    ecx, IP
        int    $40
        pop    ebx
end;

function GetIPv4DNS(Device: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00010000
        mov    bl, 4
        mov    bh, Device
        int    $40
        pop    ebx
end;

function SetIPv4DNS(Device: Byte; DNS: LongWord): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00010000
        mov    bl, 5
        mov    bh, Device
        mov    ecx, DNS
        int    $40
        pop    ebx
end;

function GetIPv4Subnet(Device: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00010000
        mov    bl, 6
        mov    bh, Device
        int    $40
        pop    ebx
end;

function SetIPv4Subnet(Device: Byte; Subnet: LongWord): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00010000
        mov    bl, 7
        mov    bh, Device
        mov    ecx, Subnet
        int    $40
        pop    ebx
end;

function GetIPv4Gateway(Device: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00010000
        mov    bl, 8
        mov    bh, Device
        int    $40
        pop    ebx
end;

function SetIPv4Gateway(Device: Byte; Gateway: LongWord): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00010000
        mov    bl, 9
        mov    bh, Device
        mov    ecx, Gateway
        int    $40
        pop    ebx
end;

function GetICMPSentPackets(Device: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00020000
        mov    bl, 0
        mov    bh, Device
        int    $40
        pop    ebx
end;

function GetICMPReceivedPackets(Device: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00020000
        mov    bl, 1
        mov    bh, Device
        int    $40
        pop    ebx
end;

function GetUDPSentPackets(Device: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00030000
        mov    bl, 0
        mov    bh, Device
        int    $40
        pop    ebx
end;

function GetUDPReceivedPackets(Device: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00030000
        mov    bl, 1
        mov    bh, Device
        int    $40
        pop    ebx
end;

function GetTCPSentPackets(Device: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00040000
        mov    bl, 0
        mov    bh, Device
        int    $40
        pop    ebx
end;

function GetTCPReceivedPackets(Device: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00040000
        mov    bl, 1
        mov    bh, Device
        int    $40
        pop    ebx
end;

function GetARPSentPackets(Device: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00050000
        mov    bl, 0
        mov    bh, Device
        int    $40
        pop    ebx
end;

function GetARPReceivedPackets(Device: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00050000
        mov    bl, 1
        mov    bh, Device
        int    $40
        pop    ebx
end;

function GetARPEntrys(Device: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00050000
        mov    bl, 2
        mov    bh, Device
        int    $40
        pop    ebx
end;

function GetARPEntry(Device: Byte; Entry: LongWord; var Buffer): LongWord; stdcall;
asm
        push   ebx
        push   edi
        mov    eax, 76
        mov    ebx, $00050000
        mov    bl, 3
        mov    bh, Device
        mov    ecx, Entry
        mov    edi, Buffer
        int    $40
        pop    edi
        pop    ebx
end;

function AddARPEntry(Device: Byte; const Buffer): LongWord; stdcall;
asm
        push   ebx
        push   esi
        mov    eax, 76
        mov    ebx, $00050000
        mov    bl, 4
        mov    bh, Device
        mov    esi, Buffer
        int    $40
        pop    esi
        pop    ebx
end;

function RemoveARPEntry(Device: Byte; Entry: LongWord): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00050000
        mov    bl, 5
        mov    bh, Device
        mov    ecx, Entry
        int    $40
        pop    ebx
end;

function SendARPAnnounce(Device: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00050000
        mov    bl, 6
        mov    bh, Device
        int    $40
        pop    ebx
end;

function GetARPConflicts(Device: Byte): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 76
        mov    ebx, $00050000
        mov    bl, 7
        mov    bh, Device
        int    $40
        pop    ebx
end;

function CreateFutex(Futex: Pointer): THandle; stdcall;
asm
        push   ebx
        mov    eax, 77
        mov    ebx, 0
        mov    ecx, Futex
        int    $40
        pop    ebx
end;

function DestroyFutex(Handle: THandle): LongInt; stdcall;
asm
        push   ebx
        mov    eax, 77
        mov    ebx, 1
        mov    ecx, Handle
        int    $40
        pop    ebx
end;

function WaitFutex(Handle: THandle; Value, Time: LongWord): LongInt; stdcall;
asm
        push   ebx
        push   esi
        mov    eax, 77
        mov    ebx, 2
        mov    ecx, Handle
        mov    edx, Value
        mov    esi, Time
        int    $40
        pop    esi
        pop    ebx
end;

function WakeFutex(Handle: THandle; Waiters: LongWord): LongWord; stdcall;
asm
        push   ebx
        mov    eax, 77
        mov    ebx, 3
        mov    ecx, Handle
        mov    edx, Waiters
        int    $40
        pop    ebx
end;

function GetProcAddress(hLib: Pointer; ProcName: PKolibriChar): Pointer; stdcall;
asm
        push   esi
        push   edi
        push   ebx
        mov    edx, hLib
        xor    eax, eax
        test   edx, edx
        jz     @end
        mov    edi, ProcName
        mov    ecx, $FFFFFFFF
        repne scasb
        mov    ebx, ecx
        not    ebx
@next:
        mov    esi, [edx]
        test   esi, esi
        jz     @end
        mov    ecx, ebx
        mov    edi, ProcName
        add    edx, 8
        repe cmpsb
        jne    @next
        mov    eax, [edx - 4]
@end:
        pop    ebx
        pop    edi
        pop    esi
end;

end.
