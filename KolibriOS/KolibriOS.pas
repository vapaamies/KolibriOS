(************************************************************

          KolibriOS system functions and definitions

 ************************************************************)
Unit KolibriOS;
(* -------------------------------------------------------- *)
Interface
(* -------------------------------------------------------- *)
Type

  Dword = LongWord;

  Qword = UInt64;

  TSize = Packed Record
    Height: Word;
    Width:  Word;
  End;

  TPoint = Packed Record
    Y: SmallInt;
    X: SmallInt;
  End;

  TRect = Packed Record
    Left:   LongInt;
    Top:    LongInt;
    Right:  LongInt;
    Bottom: LongInt;
  End;

  TBox = Packed Record
    Left:   LongInt;
    Top:    LongInt;
    Width:  Dword;
    Height: Dword;
  End;

  TSystemDate = Packed Record
    Year:  Byte;
    Month: Byte;
    Day:   Byte;
    Zero:  Byte;
  End;

  TSystemTime = Packed Record
    Hours:   Byte;
    Minutes: Byte;
    Seconds: Byte;
    Zero:    Byte;
  End;

  TThreadInfo = Packed Record
    CpuUsage:     Dword;
    WinStackPos:  Word;
    reserved0:    Word;
    reserved1:    Word;
    Name:         Packed Array[0..10] Of Char;
    reserved2:    Byte;
    MemAddress:   Dword;
    MemUsage:     Dword;
    Identifier:   Dword;
    Window:       TRect;
    ThreadState:  Word;
    reserved3:    Word;
    Client:       TRect;
    WindowState:  Byte;
    EventMask:    Dword;
    KeyboardMode: Byte;
    reserved4:    Packed Array[0..947] Of Byte;
  End;

  TKeyboardInputMode = (kmASCII, kmSCAN);
  
  TKeyboardInputFlag = (kfCode, kfEmpty, kfHotKey);

  TKeyboardInput = Packed Record
    Flag: TKeyboardInputFlag;
    Code: Char;
    Case TKeyboardInputMode Of
      kmASCII: (Scan: Char);
      kmSCAN:  (
                Case TKeyboardInputFlag Of 
                  kfCode:   ();
                  kfHotKey: (Control: Word);           
               );
  End;  
  
  TButtonInput = Packed Record
    MouseButton: Byte;
    ID:          Word;
    HiID:        Byte;
  End;
  
  TKernelVersion = Packed Record
    A, B, C, D: Byte;
    reserved:   Byte;
    Revision:   Dword;
  End;

  TRAMInfo = Packed Record
    AvailablePages:    Dword;
    FreePages:         Dword;
    PageFaults:        Dword;
    KernelHeapSize:    Dword;
    KernelHeapFree:    Dword;
    Blocks:            Dword;
    FreeBlocks:        Dword;
    MaxFreeBlock:      Dword;
    MaxAllocatedBlock: Dword;
  End;

  TKeyboardLayout = Packed Array[0..127] Of Char;

  TCtrlDriver = Packed Record
    Handle:         Dword;
    Func:           Dword;
    InputData:      Pointer;
    InputDataSize:  Dword;
    OutputData:     Pointer;
    OutputDataSize: Dword;
  End;

  TFileDate = Packed Record
    Day:   Byte;
    Month: Byte;
    Year:  Word;
  End;

  TFileTime = Packed Record
    Seconds: Byte;
    Minutes: Byte;
    Hours:   Byte;
    Zero:    Byte;
  End;

  TFileAttributes = Packed Record
    Attributes:   Dword;
    Flags:        Dword;
    CreationTime: TFileTime;
    CreationDate: TFileDate;
    AccessTime:   TFileTime;
    AccessDate:   TFileDate;
    ModifyTime:   TFileTime;
    ModifyDate:   TFileDate;
    SizeLo:       Dword;
    SizeHi:       Dword;
  End;

  TFileInformation = Packed Record
    FileAttributes: TFileAttributes;
    FileName:       Array[0..255] Of Char;
    reserved:       Array[0..7] Of Byte;
  End;
  
  TFileInformationW = Packed Record
    FileAttributes: TFileAttributes;
    FileName:       Array[0..255] Of WideChar;
    reserved:       Array[0..7] Of Byte;
  End;
  
  TFolderInformation = Packed Record
    Version:         Dword;
    BlockCount:      Dword;
    FileCount:       Dword;
    reserved:        Array[0..19] Of Byte;
    FileInformation: Array[0..0] Of TFileInformation;
  End;
  
  TFolderInformationW = Packed Record
    Version:         Dword;
    BlockCount:      Dword;
    FileCount:       Dword;
    reserved:        Array[0..19] Of Byte;
    FileInformation: Array[0..0] Of TFileInformationW;
  End;
  
  TStandardColors = Packed Record
    Frames:         Dword;
    Grab:           Dword;
    Work3DDark:     Dword;
    Work3DLight:    Dword;
    GrabText:       Dword;
    Work:           Dword;
    WorkButton:     Dword;
    WorkButtonText: Dword;
    WorkText:       Dword;
    WorkGraph:      Dword;
  End;

  TSockAddr = Packed Record
    Family: Word;
    Data:   Packed Array[0..13] Of Byte;
  End;

  TOptStruct = Packed Record
    Level:     Dword;
    OptName:   Dword;
    OptLength: Dword;
    Options:   Packed Array[0..0] Of Byte
  End;

  TThreadContext = Packed Record
    EIP:    Dword;
    EFlags: Dword;
    EAX:    Dword;
    ECX:    Dword;
    EDX:    Dword;
    EBX:    Dword;
    ESP:    Dword;
    EBP:    Dword;
    ESI:    Dword;
    EDI:    Dword;
  End;

  TSignalBuffer = Packed Record
    ID:   Dword;
    Data: Packed Array[0..19] Of Byte;
  End;

  TIPCMessage = Packed Record
    ID:     Dword;
    Length: Dword;
    Data:   Packed Array[0..0] Of Byte;
  End;

  TIPCBuffer = Packed Record
    Lock:        Dword;
    CurrentSize: Dword;
    Data:        Packed Array[0..0] Of TIPCMessage;
  End;

  TDebugMessage = Packed Record
    Code: Dword;
    ID:   Dword;
    Data: Dword;
  End;

  TDebugBuffer = Packed Record
    TotalSize:   Dword;
    CurrentSize: Dword;
    Buffer:      Packed Array[0..0] Of TDebugMessage;
  End;

(* -------------------------------------------------------- *)
Const

 (* Window styles *)
  WS_SKINNED_FIXED     =  $4000000;
  WS_SKINNED_SIZABLE   =  $3000000;
  WS_FIXED             =  $0000000;
  WS_SIZABLE           =  $2000000;
  WS_FILL_TRANSPARENT  = $40000000;
  WS_FILL_GRADIENT     = $80000000;
  WS_COORD_CLIENT      = $20000000;
  WS_CAPTION           = $10000000;

 (* Caption styles *)
  CAPTION_MOVABLE      = $00000000;
  CAPTION_NONMOVABLE   = $01000000;

 (* Events *)
  REDRAW_EVENT         = 1;
  KEY_EVENT            = 2;
  BUTTON_EVENT         = 3;
  BACKGROUND_EVENT     = 5;
  MOUSE_EVENT          = 6;
  IPC_EVENT            = 7;
  NETWORK_EVENT        = 8;
  DEBUG_EVENT          = 9;

 (* Event Mask Constants *)
  EM_REDRAW            = $001;
  EM_KEY               = $002;
  EM_BUTTON            = $004;
  EM_BACKGROUND        = $010;
  EM_MOUSE             = $020;
  EM_IPC               = $040;
  EM_NETWORK           = $080;
  EM_DEBUG             = $100;

 (* Size multipliers for DrawText *)
  DT_X1                =  $0000000;
  DT_X2                =  $1000000;
  DT_X3                =  $2000000;
  DT_X4                =  $3000000;
  DT_X5                =  $4000000;
  DT_X6                =  $5000000;
  DT_X7                =  $6000000;
  DT_X8                =  $7000000;

 (* Charset specifiers for DrawText *)
  DT_CP866_6X9         = $00000000;
  DT_CP866_8X16        = $10000000;
  DT_UTF_16LE_8X16     = $20000000;
  DT_UTF_8_8X16        = $30000000;

 (* Fill styles for DrawText *)
  DT_FILL_TRANSPARENT  = $00000000;
  DT_FILL_OPAQUE       = $40000000;

 (* Draw zero terminated string for DrawText *)
  DT_ZSTRING           = $80000000;

 (* Button styles *)
  BS_FILL_TRANSPARENT  = $40000000;
  BS_NO_FRAME          = $20000000;

 (* SharedMemoryOpen open\access flags *)
  SHM_OPEN             = $00;
  SHM_OPEN_ALWAYS      = $04;
  SHM_CREATE           = $08;
  SHM_READ             = $00;
  SHM_WRITE            = $01;

 (* KeyboardLayout flags *)
  KBL_NORMAL           = 1;
  KBL_SHIFT            = 2;
  KBL_ALT              = 3;

 (* SystemShutdown parameters *)
  SHUTDOWN_TURNOFF     = 2;
  SHUTDOWN_REBOOT      = 3;
  SHUTDOWN_RESTART     = 4;

 (* Blit flags *)  
  BLIT_CLIENT_RELATIVE = $20000000;

(* -------------------------------------------------------- *)
{-1}      Procedure ThreadTerminate; StdCall;
{0}       Procedure DrawWindow(Left, Top, Right, Bottom: Integer; Caption: PChar; BackColor, Style, CapStyle: Dword); StdCall;
{1}       Procedure SetPixel(X, Y: Integer; Color: Dword); StdCall;
{2}       Function  GetKey: TKeyboardInput; StdCall;
{3}       Function  GetSystemTime: TSystemTime; StdCall;
{4}       Procedure DrawText(X, Y: Integer; Text: PChar; ForeColor, BackColor, Flags, Count: Dword); StdCall;
{5}       Procedure Sleep(Time: Dword); StdCall;
{6}       {UNDEFINED}
{7}       Procedure DrawImage(Const Image; X, Y: Integer; Width, Height: Dword); StdCall;
{8}       Procedure DrawButton(Left, Top, Right, Bottom: Integer; BackColor, Style, ID: Dword); StdCall;
{8}       Procedure DeleteButton(ID: Dword); StdCall;
{9}       Function  GetThreadInfo(Slot: Dword; Var Buffer: TThreadInfo): Dword; StdCall;
{10}      Function  WaitEvent: Dword; StdCall;
{11}      Function  CheckEvent: Dword; StdCall;
{12.1}    Procedure BeginDraw; StdCall;
{12.2}    Procedure EndDraw; StdCall;
{13}      Procedure DrawRectangle(X, Y: Integer; Width, Height: Dword; Color: Dword); StdCall;
{14}      Function  GetScreenMax: TPoint; StdCall;
{15.1}    Procedure SetBackgroundSize(Width, Height: Dword); StdCall;
{15.2}    Procedure SetBackgroundPixel(X, Y: Integer; Color: Dword); StdCall;
{15.3}    Procedure DrawBackground; StdCall;
{15.4}    Procedure SetBackgroundDrawMode(DrawMode: Dword); StdCall;
{15.5}    Procedure DrawBackgroundImage(Const Image; X, Y: Integer; Width, Height: Dword); StdCall;
{15.6}    Function  MapBackground: Pointer; StdCall;
{15.7}    Function  UnMapBackground(Background: Pointer): Integer; StdCall;
{15.8}    Function  GetLastDrawnBackgroundRect: TRect; StdCall;
{15.9}    Procedure UpdateBackgroundRect(Left, Top, Right, Bottom: Integer); StdCall;
{16}      Function  FlushFloppyCache(FloppyNumber: Dword): Dword; StdCall;
{17}      Function  GetButton: TButtonInput; StdCall;
{18.1}    Procedure DeactivateWindow(Slot: Dword); StdCall;
{18.2}    Procedure ThreadTerminateBySlot(Slot: Dword); StdCall;
{18.3}    Procedure ActivateWindow(Slot: Dword); StdCall;
{18.4}    Function  GetIdleTime: Dword; StdCall;
{18.5}    Function  GetCPUClock: Dword; StdCall;
{18.6}    Function  SaveRamDisk(Path: PChar): Dword; StdCall;
{18.7}    Function  GetActiveWindow: Dword; StdCall;
{18.8.1}  Function  GetSpeakerState: Integer; StdCall;
{18.8.2}  Procedure SwitchSpeakerState; StdCall;
{18.9}    Function  SystemShutdown(Param: Dword): Integer; StdCall;
{18.10}   Procedure MinimizeActiveWindow; StdCall;
{18.11}   Procedure GetDiskSystemInfo(Var Buffer); StdCall;
{18.12}   {UNDEFINED}
{18.13}   Procedure GetKernelVersion(Var Buffer: TKernelVersion); StdCall;
{18.14}   Function  WaitRetrace: Integer; StdCall;
{18.15}   Function  CenterMousePointer: Integer; StdCall;
{18.16}   Function  GetFreeMemory: Dword; StdCall;
{18.17}   Function  GetAvailableMemory: Dword; StdCall;
{18.18}   Function  ThreadTerminateById(ID: Dword): Integer; StdCall;
{18.19.0} Function  GetMouseSpeed: Dword; StdCall;
{18.19.1} Procedure SetMouseSpeed(Speed: Dword); StdCall;
{18.19.2} Function  GetMouseSensitivity: Dword; StdCall;
{18.19.3} Procedure SetMouseSensitivity(Sensitivity: Dword); StdCall;
{18.19.4} Procedure SetMousePos(X, Y: Integer); StdCall;
{18.19.5} Procedure SetMouseButtons(State: Dword); StdCall;
{18.19.6} Function  GetDoubleClickTime: Dword; StdCall;
{18.19.7} Procedure SetDoubleClickTime(Time: Dword); StdCall;
{18.20}   Function  GetRAMInfo(Var Buffer: TRAMInfo): Integer; StdCall;
{18.21}   Function  GetSlotById(ID: Dword): Dword; StdCall;
{18.22.0} Function  MinimizeWindowBySlot(Slot: Dword): Integer; StdCall;
{18.22.1} Function  MinimizeWindowByID(ID: Dword): Integer; StdCall;
{18.22.2} Function  RestoreWindowBySlot(Slot: Dword): Integer; StdCall;
{18.22.3} Function  RestoreWindowByID(ID: Dword): Integer; StdCall;
{18.23}   Function  MinimizeAllWindows: Dword; StdCall;
{18.24}   Procedure SetScreenLimits(Width, Height: Dword); StdCall;
{18.25.1} Function  GetWindowZOrder(ID: Dword): Dword; StdCall;
{18.25.2} Function  SetWindowZOrder(ID, ZOrder: Dword): Integer; StdCall;
{19}      {UNDEFINED}
{20.1}    Function  ResetMidi: Integer; StdCall;
{20.2}    Function  OutputMidi(Data: Byte): Integer; StdCall;
{21.1}    Function  SetMidiBase(Port: Dword): Integer; StdCall;
{21.2}    Function  SetKeyboardLayout(Flags: Dword; Var Table: TKeyboardLayout): Integer; StdCall;
{21.2}    Function  SetKeyboardLayoutCountry(Country: Dword): Integer; StdCall;
{21.3}    {UNDEFINED}
{21.4}    {UNDEFINED}
{21.5}    Function  SetSystemLanguage(SystemLanguage: Dword): Integer; StdCall;
{21.6}    {UNDEFINED}
{21.7}    {UNDEFINED}
{21.8}    {UNDEFINED}
{21.9}    {UNDEFINED}
{21.10}   {UNDEFINED}
{21.11}   Function  SetHDAccess(Value: Dword): Integer; StdCall;
{21.12}   Function  SetPCIAccess(Value: Dword): Integer; StdCall;
{22.0}    Function  SetSystemTime(Time: TSystemTime): Integer; StdCall;
{22.1}    Function  SetSystemDate(Date: TSystemDate): Integer; StdCall;
{22.2}    Function  SetDayOfWeek(DayOfWeek: Dword): Integer; StdCall;
{22.3}    Function  SetAlarm(Time: TSystemTime): Integer; StdCall;
{23}      Function  WaitEventByTime(Time: Dword): Dword; StdCall;
{24.4}    Procedure OpenCDTray(Drive: Dword); StdCall;
{24.5}    Procedure CloseCDTray(Drive: Dword); StdCall;
{25}      Procedure DrawBackgroundLayerImage(Const Image; X, Y: Integer; Width, Height: Dword); StdCall;
{26.1}    Function  GetMidiBase: Dword; StdCall;
{26.2}    Procedure GetKeyboardLayout(Flags: Dword; Var Table: TKeyboardLayout); StdCall;
{26.2}    Function  GetKeyboardLayoutCountry: Dword; StdCall;
{26.3}    {UNDEFINED}
{26.4}    {UNDEFINED}
{26.5}    Function  GetSystemLanguage: Dword; StdCall;
{26.6}    {UNDEFINED}
{26.7}    {UNDEFINED}
{26.8}    {UNDEFINED}
{26.9}    Function  GetTickCount: Dword; StdCall;
{26.10}   Function  GetTickCount64: Qword; StdCall;
{26.11}   Function  IsHDAccessAllowed: Dword; StdCall;
{26.12}   Function  IsPCIAccessAllowed: Dword; StdCall;
{27}      {UNDEFINED}
{28}      {UNDEFINED}
{29}      Function  GetSystemDate: TSystemDate; StdCall;
{30.1}    Procedure SetCurrentDirectory(Path: PChar); StdCall;
{30.2}    Function  GetCurrentDirectory(Buffer: PChar; Count: Dword): Dword; StdCall;
{31}      {UNDEFINED}
{32}      {UNDEFINED}
{33}      {UNDEFINED}
{34}      Function  GetPointOwner(X, Y: Integer): Dword; StdCall;
{35}      Function  GetPixel(X, Y: Integer): Dword; StdCall;
{36}      Procedure GetScreenImage(Var Buffer; X, Y: Integer; Width, Height: Dword); StdCall;
{37.0}    Function  GetMousePos: TPoint; StdCall;
{37.1}    Function  GetWindowMousePos: TPoint; StdCall;
{37.2}    Function  GetMouseButtons: Dword; StdCall;
{37.3}    Function  GetMouseEvents: Dword; StdCall;
{37.4}    Function  LoadCursorFromFile(Path: PChar): Dword; StdCall;
{37.4}    Function  LoadCursorFromMemory(Const Buffer): Dword; StdCall;
{37.4}    Function  LoadCursorIndirect(Const Buffer; HotSpotX, HotSpotY: ShortInt): Dword; StdCall;
{37.5}    Function  SetCursor(Handle: Dword): Dword; StdCall;
{37.6}    Function  DeleteCursor(Handle: Dword): Dword; StdCall;
{37.7}    Function  GetMouseScroll: TPoint; StdCall;
{38}      Procedure DrawLine(X1, Y1, X2, Y2: Integer; Color: Dword); StdCall;
{39.1}    Function  GetBackgroundSize: TSize; StdCall;
{39.2}    Function  GetBackgroundPixel(X, Y: Integer): Dword; StdCall;
{39.3}    {UNDEFINED}
{39.4}    Function  GetBackgroundDrawMode: Dword; StdCall;
{40}      Function  SetEventMask(Mask: Dword): Dword; StdCall;
{41}      {UNDEFINED}
{42}      {UNDEFINED}
{43}      Function  InPort(Port: Dword; Var Data: Byte): Dword; StdCall;
{43}      Function  OutPort(Port: Dword; Data: Byte): Dword; StdCall;
{44}      {UNDEFINED}
{45}      {UNDEFINED}
{46}      Function  ReservePorts(First, Last: Dword): Dword; StdCall;
{46}      Function  FreePorts(First, Last: Dword): Dword; StdCall;
{47}      {DrawNumber}
{48.0}    Procedure ApplyStyleSettings; StdCall;
{48.1}    Procedure SetButtonStyle(ButtonStyle: Dword); StdCall;
{48.2}    Procedure SetStandardColors(Var ColorTable: TStandardColors; Size: Dword); StdCall;
{48.3}    Procedure GetStandardColors(Var ColorTable: TStandardColors; Size: Dword); StdCall;
{48.4}    Function  GetSkinHeight: Dword; StdCall;
{48.5}    Function  GetScreenWorkingArea: TRect; StdCall;
{48.6}    Procedure SetScreenWorkingArea(Left, Top, Right, Bottom: Integer); StdCall;
{48.7}    Function  GetSkinMargins: TRect; StdCall;
{48.8}    Function  SetSkin(Path: PChar): Integer; StdCall;
{48.9}    Function  GetFontSmoothing: Integer; StdCall;
{48.10}   Procedure SetFontSmoothing(Smoothing: Integer); StdCall;
{48.11}   Function  GetFontHeight: Dword; StdCall;
{48.12}   Procedure SetFontHeight(Height: Dword); StdCall;
{49}      {Advanced Power Management}
{50.0}    Procedure SetWindowShape(Const Data); StdCall;
{50.1}    Procedure SetWindowScale(Scale: Dword); StdCall;
{51.1}    Function  ThreadCreate(Entry, Stack: Pointer): Dword; StdCall;
{52}      {UNDEFINED}
{53}      {UNDEFINED}
{54.0}    Function  GetClipboardSlotCount: Integer; StdCall;
{54.1}    Function  GetClipboardData(Slot: Dword): Pointer; StdCall;
{54.2}    Function  SetClipboardData(Const Src; Count: Dword): Integer; StdCall;
{54.3}    Function  DeleteClipboardLastSlot: Integer; StdCall;
{54.4}    Function  ResetClipboard: Integer; StdCall;
{55}      Function  SpeakerPlay(Const Data): Dword; StdCall;
{56}      {UNDEFINED}
{57}      {PCI BIOS}
{58}      {UNDEFINED}
{59}      {UNDEFINED}
{60.1}    Function  IPCSetBuffer(Const Buffer: TIPCBuffer; Size: Dword): Integer; StdCall;
{60.2}    Function  IPCSendMessage(ID: Dword; Var Msg: TIPCMessage; Size: Dword): Integer; StdCall;
{61.1}    Function  GetScreenSize: TSize; StdCall;
{61.2}    Function  GetScreenBitsPerPixel: Dword; StdCall;
{61.3}    Function  GetScreenBytesPerScanLine: Dword; StdCall;
{62.0}    Function  GetPCIVersion: Dword; StdCall;
{62.1}    Function  GetLastPCIBus: Dword; StdCall;
{62.2}    Function  GetPCIAddressingMode: Dword; StdCall;
{62.3}    {UNDEFINED}
{62.4}    Function  ReadPCIByte(Bus, Device, Func, Reg: Byte): Byte; StdCall;
{62.5}    Function  ReadPCIWord(Bus, Device, Func, Reg: Byte): Word; StdCall;
{62.6}    Function  ReadPCIDword(Bus, Device, Func, Reg: Byte): Dword; StdCall;
{62.7}    {UNDEFINED}
{62.8}    Function  WritePCIByte(Bus, Device, Func, Reg: Byte; Data: Byte): Dword; StdCall;
{62.9}    Function  WritePCIWord(Bus, Device, Func, Reg: Byte; Data: Word): Dword; StdCall;
{62.10}   Function  WritePCIDword(Bus, Device, Func, Reg: Byte; Data: Dword): Dword; StdCall;
{63.1}    Procedure BoardWriteByte(Data: Byte); StdCall;
{63.2}    Function  BoardReadByte(Var Data: Byte): Dword; StdCall;
{64}      Function  ReallocAppMemory(Count: Dword): Integer; StdCall;
{65}      Procedure DrawImageEx(Const Image; Left, Top: Integer; Width, Height: Dword; BPP: Dword; Const Palette: Pointer; Padding: Dword); StdCall;
{66.1}    Procedure SetKeyboardInputMode(Mode: Dword); StdCall;
{66.2}    Function  GetKeyboardInputMode: Dword; StdCall;
{66.3}    Function  GetControlKeyState: Dword; StdCall;
{66.4}    Function  SetHotKey(ScanCode, Control: Dword): Integer; StdCall;
{66.5}    Function  ResetHotKey(ScanCode, Control: Dword): Integer; StdCall;
{66.6}    Procedure KeyboardLock; StdCall;
{66.7}    Procedure KeyboardUnlock; StdCall;
{67}      Procedure SetWindowPos(Left, Top, Right, Bottom: Integer); StdCall;
{68.0}    Function  GetTaskSwitchCount: Dword; StdCall;
{68.1}    Procedure SwitchThread; StdCall;
{68.2.0}  Function  EnableRDPMC: Dword; StdCall;
{68.2.1}  Function  IsCacheEnabled: Dword; StdCall;
{68.2.2}  Procedure EnableCache; StdCall;
{68.2.3}  Procedure DisableCache; StdCall;
{68.3}    {ReadMSR}
{68.4}    {WriteMSR}
{68.5}    {UNDEFINED}
{68.6}    {UNDEFINED}
{68.7}    {UNDEFINED}
{68.8}    {UNDEFINED}
{68.9}    {UNDEFINED}
{68.10}   {UNDEFINED}
{68.11}   Function  HeapCreate: Dword; StdCall;
{68.12}   Function  HeapAllocate(Bytes: Dword): Pointer; StdCall;
{68.13}   Function  HeapFree(MemPtr: Pointer): Dword; StdCall;
{68.14}   Procedure WaitSignal(Var Buffer: TSignalBuffer); StdCall;
{68.15}   {UNDEFINED}
{68.16}   Function  GetDriver(Name: PChar): Dword; StdCall;
{68.17}   Function  ControlDriver(Var CtrlStructure: TCtrlDriver): Dword; StdCall;
{68.18}   {UNDEFINED}
{68.19}   Function  LoadLibrary(Path: PChar): Pointer; StdCall;
{68.20}   Function  HeapReallocate(MemPtr: Pointer; Bytes: Dword): Pointer; StdCall;
{68.21}   Function  LoadDriver(Name, CmdLine: PChar): Dword; StdCall;
{68.22}   Function  SharedMemoryOpen(Name: PChar; Bytes: Dword; Flags: Dword): Pointer; StdCall;
{68.23}   Function  SharedMemoryClose(Name: PChar): Dword; StdCall;
{68.24}   Function  SetExceptionHandler(Handler: Pointer; Mask: Dword; Var OldMask: Dword): Pointer; StdCall;
{68.25}   Function  SetExceptionActivity(Signal, Activity: Dword): Integer; StdCall;
{68.26}   Procedure ReleaseMemoryPages(MemPtr: Pointer; Offset, Size: Dword); StdCall;
{68.27}   Function  LoadFile(Path: PChar; Var Size: Dword): Pointer; StdCall;
{69.0}    Procedure SetDebugBuffer(Const Buffer: TDebugBuffer); StdCall;
{69.1}    Procedure GetThreadContext(ID: Dword; Var Context: TThreadContext); StdCall;
{69.2}    Procedure SetThreadContext(ID: Dword; Const Context: TThreadContext); StdCall;
{69.3}    Procedure DetachThread(ID: Dword); StdCall;
{69.4}    Procedure SuspendThread(ID: Dword); StdCall;
{69.5}    Procedure ResumeThread(ID: Dword); StdCall;
{69.6}    Function  ReadProcessMemory(ID, Count: Dword; Const Src; Var Dst): Integer; StdCall;
{69.7}    Function  WriteProcessMemory(ID, Count: Dword; Const Src; Var Dst): Integer; StdCall;
{69.8}    Procedure DebugTerminate(ID: Dword); StdCall;
{69.9}    Function  SetBreakPoint(ID: Dword; Index, Flags: Byte; Address: Pointer): Integer; StdCall;
{69.9}    Function  ResetBreakPoint(ID: Dword; Index, Flags: Byte; Address: Pointer): Integer; StdCall;
{70.0}    Function  ReadFile(Path: PChar; Var Buffer; Count, LoPos, HiPos: Cardinal; Var BytesRead: Dword): Integer; StdCall;
{70.1}    Function  ReadFolder(Path: PChar; Var Buffer; Count, Start, Flags: Cardinal; Var BlocksRead: Dword): Integer; StdCall;
{70.2}    Function  CreateFile(Path: PChar): Integer; StdCall;
{70.3}    Function  WriteFile(Path: PChar; Const Buffer; Count, LoPos, HiPos: Cardinal; Var BytesWritten: Dword): Integer; StdCall;
{70.4}    Function  ResizeFile(Path: PChar; LoSize, HiSize: Cardinal): Integer; StdCall;
{70.5}    Function  GetFileAttributes(Path: PChar; Var Buffer: TFileAttributes): Integer; StdCall;
{70.6}    Function  SetFileAttributes(Path: PChar; Var Buffer: TFileAttributes): Integer; StdCall;
{70.7}    Function  RunFile(Path, CmdLine: PChar): Integer; StdCall;
{70.7}    Function  DebugFile(Path, CmdLine: PChar): Integer; StdCall;
{70.8}    Function  DeleteFile(Path: PChar): Integer; StdCall;
{70.9}    Function  CreateFolder(Path: PChar): Integer; StdCall;
{71.1}    Procedure SetWindowCaption(Caption: PChar); StdCall;
{72.1.2}  Function  SendActiveWindowKey(KeyCode: Dword): Integer; StdCall;
{72.1.3}  Function  SendActiveWindowButton(ButtonID: Dword): Integer; StdCall;
{73}      Procedure Blit(Const Src; SrcX, SrcY: Integer; SrcW, SrcH: Dword; DstX, DstY: Integer; DstW, DstH: Dword; Stride, Flags: Dword); StdCall;
{74.-1}   Function  GetActiveNetworkDevices: Dword; StdCall;
{74.0}    Function  GetNetworkDeviceType(Device: Byte): Integer; StdCall;
{74.1}    Function  GetNetworkDeviceName(Device: Byte; Var Buffer): Integer; StdCall;
{74.2}    Function  ResetNetworkDevice(Device: Byte): Integer; StdCall;
{74.3}    Function  StopNetworkDevice(Device: Byte): Integer; StdCall;
{74.4}    Function  GetNetworkDevicePointer(Device: Byte): Pointer; StdCall;
{74.5}    {UNDEFINED}
{74.6}    Function  GetSentPackets(Device: Byte): Integer; StdCall;
{74.7}    Function  GetReceivedPackets(Device: Byte): Integer; StdCall;
{74.8}    Function  GetSentBytes(Device: Byte): Integer; StdCall;
{74.9}    Function  GetReceivedBytes(Device: Byte): Integer; StdCall;
{74.10}   Function  GetLinkStatus(Device: Byte): Integer; StdCall;
{75.0}    Function  OpenSocket(Domain, Kind, Protocol: Dword): Dword; StdCall;
{75.1}    Function  CloseSocket(Socket: Dword): Integer; StdCall;
{75.2}    Function  SocketBind(Socket: Dword; Var SockAddr: TSockAddr): Integer; StdCall;
{75.3}    Function  SocketListen(Socket: Dword; Var BackLog): Integer; StdCall;
{75.4}    Function  SocketConnect(Socket: Dword; Var SockAddr: TSockAddr): Integer; StdCall;
{75.5}    Function  SocketAccept(Socket: Dword; Var SockAddr: TSockAddr): Dword; StdCall;
{75.6}    Function  SocketSend(Socket: Dword; Const Buffer; Size, Flags: Dword): Integer; StdCall;
{75.7}    Function  SocketReceive(Socket: Dword; Var Buffer; Size, Flags: Dword): Integer; StdCall;
{75.8}    Function  SetSocketOptions(Socket: Dword; Var OptStruct: TOptStruct): Integer; StdCall;
{75.9}    Function  GetSocketOptions(Socket: Dword; Var OptStruct: TOptStruct): Integer; StdCall;
{75.10}   Function  GetSocketPair(Var Socket1, Socket2: Dword): Integer; StdCall;
{76.0.0}  Function  GetMAC(Device: Byte): Dword; StdCall;
{76.1.0}  Function  GetIPv4SentPackets(Device: Byte): Dword; StdCall;
{76.1.1}  Function  GetIPv4ReceivedPackets(Device: Byte): Dword; StdCall;
{76.1.2}  Function  GetIPv4IP(Device: Byte): Dword; StdCall;
{76.1.3}  Function  SetIPv4IP(Device: Byte; IP: Dword): Dword; StdCall;
{76.1.4}  Function  GetIPv4DNS(Device: Byte): Dword; StdCall;
{76.1.5}  Function  SetIPv4DNS(Device: Byte; DNS: Dword): Dword; StdCall;
{76.1.6}  Function  GetIPv4Subnet(Device: Byte): Dword; StdCall;
{76.1.7}  Function  SetIPv4Subnet(Device: Byte; Subnet: Dword): Dword; StdCall;
{76.1.8}  Function  GetIPv4Gateway(Device: Byte): Dword; StdCall;
{76.1.9}  Function  SetIPv4Gateway(Device: Byte; Gateway: Dword): Dword; StdCall;
{76.2.0}  Function  GetICMPSentPackets(Device: Byte): Dword; StdCall;
{76.2.1}  Function  GetICMPReceivedPackets(Device: Byte): Dword; StdCall;
{76.3.0}  Function  GetUDPSentPackets(Device: Byte): Dword; StdCall;
{76.3.1}  Function  GetUDPReceivedPackets(Device: Byte): Dword; StdCall;
{76.4.0}  Function  GetTCPSentPackets(Device: Byte): Dword; StdCall;
{76.4.1}  Function  GetTCPReceivedPackets(Device: Byte): Dword; StdCall;
{76.5.0}  Function  GetARPSentPackets(Device: Byte): Dword; StdCall;
{76.5.1}  Function  GetARPReceivedPackets(Device: Byte): Dword; StdCall;
{76.5.2}  Function  GetARPEntrys(Device: Byte): Dword; StdCall;
{76.5.3}  Function  GetARPEntry(Device: Byte; Entry: Dword; Var Buffer): Dword; StdCall;
{76.5.4}  Function  AddARPEntry(Device: Byte; Const Buffer): Dword; StdCall;
{76.5.5}  Function  RemoveARPEntry(Device: Byte; Entry: Dword): Dword; StdCall;
{76.5.6}  Function  SendARPAnnounce(Device: Byte): Dword; StdCall;
{76.5.7}  Function  GetARPConflicts(Device: Byte): Dword; StdCall;
{77.0}    Function  CreateFutex(Futex: Pointer): Dword; StdCall;
{77.1}    Function  DestroyFutex(Handle: Dword): Dword; StdCall;
{77.2}    Function  WaitFutex(Handle, Value, Time: Dword): Dword; StdCall;
{77.3}    Function  WakeFutex(Handle, Waiters: Dword): Dword; StdCall;
          Function  GetProcAddress(hLib: Pointer; ProcName: PChar): Pointer; StdCall;
(* -------------------------------------------------------- *)
Implementation
(* -------------------------------------------------------- *)
{-1}      Procedure ThreadTerminate; StdCall;
          Asm
                  mov    eax, $FFFFFFFF
                  int    64
          End;
(* -------------------------------------------------------- *)
{0}       Procedure DrawWindow(Left, Top, Right, Bottom: Integer; Caption: PChar; BackColor, Style, CapStyle: Dword); StdCall;
          Asm
                  push   ebx
                  push   edi
                  push   esi
                  xor    eax, eax
                  mov    ebx, Left
                  mov    ecx, Top
                  shl    ebx, 16
                  shl    ecx, 16
                  or     ebx, Right
                  or     ecx, Bottom
                  mov    edx, Style
                  or     edx, BackColor
                  mov    edi, Caption
                  mov    esi, CapStyle
                  int    64
                  pop    esi
                  pop    edi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{1}       Procedure SetPixel(X, Y: Integer; Color: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 1
                  mov    ebx, X
                  mov    ecx, Y
                  mov    edx, Color
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{2}       Function  GetKey: TKeyboardInput; StdCall;
          Asm
                  mov    eax, 2
                  int    64
          End;
(* -------------------------------------------------------- *)
{3}       Function  GetSystemTime: TSystemTime; StdCall;
          Asm
                  mov    eax, 3
                  int    64
          End;
(* -------------------------------------------------------- *)
{4}       Procedure DrawText(X, Y: Integer; Text: PChar; ForeColor, BackColor, Flags, Count: Dword); StdCall;
          Asm
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
                  int    64
                  pop    esi
                  pop    edi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{5}       Procedure Sleep(Time: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 5
                  mov    ebx, Time
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{6}       {UNDEFINED}
(* -------------------------------------------------------- *)
{7}       Procedure DrawImage(Const Image; X, Y: Integer; Width, Height: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 7
                  mov    ebx, Image
                  mov    ecx, Width 
                  mov    edx, X     
                  shl    ecx, 16    
                  shl    edx, 16    
                  or     ecx, Height
                  or     edx, Y
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{8}       Procedure DrawButton(Left, Top, Right, Bottom: Integer; BackColor, Style, ID: Dword); StdCall;
          Asm
                  push   ebx
                  push   esi
                  mov    eax, 8
                  mov    ebx, Left
                  mov    ecx, Top
                  shl    ebx, 16
                  shl    ecx, 16
                  or     ebx, Right
                  or     ecx, Bottom
                  mov    edx, ID
                  or     edx, Style
                  mov    esi, BackColor
                  int    64
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{8}       Procedure DeleteButton(ID: Dword); StdCall;
          Asm
                  mov    eax, 8
                  mov    edx, ID
                  or     edx, $80000000
                  int    64
          End;
(* -------------------------------------------------------- *)
{9}       Function  GetThreadInfo(Slot: Dword; Var Buffer: TThreadInfo): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 9
                  mov    ebx, Buffer
                  mov    ecx, Slot
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{10}      Function  WaitEvent: Dword; StdCall;
          Asm
                  mov    eax, 10
                  int    64
          End;
(* -------------------------------------------------------- *)
{11}      Function  CheckEvent: Dword; StdCall;
          Asm
                  mov    eax, 11
                  int    64
          End;
(* -------------------------------------------------------- *)
{12.1}    Procedure BeginDraw; StdCall;
          Asm
                  push   ebx
                  mov    eax, 12
                  mov    ebx, 1
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{12.2}    Procedure EndDraw; StdCall;
          Asm
                  push   ebx
                  mov    eax, 12
                  mov    ebx, 2
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{13}      Procedure DrawRectangle(X, Y: Integer; Width, Height: Dword; Color: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 13
                  mov    ebx, X
                  mov    ecx, Y
                  mov    edx, Color
                  shl    ebx, 16
                  shl    ecx, 16
                  or     ebx, Width
                  or     ecx, Height
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{14}      Function  GetScreenMax: TPoint; StdCall;
          Asm
                  mov    eax, 14
                  int    64
          End;
(* -------------------------------------------------------- *)
{15.1}    Procedure SetBackgroundSize(Width, Height: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 15
                  mov    ebx, 1
                  mov    ecx, Width
                  mov    edx, Height
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{15.2}    Procedure SetBackgroundPixel(X, Y: Integer; Color: Dword); StdCall;
          Asm
                  push   ebx
          // at first need to know Background.Width
                  mov    eax, 39
                  mov    ebx, 1
                  int    64
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
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{15.3}    Procedure DrawBackground; StdCall;
          Asm
                  push   ebx
                  mov    eax, 15
                  mov    ebx, 3
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{15.4}    Procedure SetBackgroundDrawMode(DrawMode: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 15
                  mov    ebx, 4
                  mov    ecx, DrawMode
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{15.5}    Procedure DrawBackgroundImage(Const Image; X, Y: Integer; Width, Height: Dword); StdCall;
          Asm
                  push   ebx
                  push   esi
          // at first need to know Background.Width
                  mov    eax, 39
                  mov    ebx, 1
                  int    64
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
                  int    64
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{15.6}    Function  MapBackground: Pointer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 15
                  mov    ebx, 6
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{15.7}    Function  UnMapBackground(Background: Pointer): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 15
                  mov    ebx, 7
                  mov    ecx, Background
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{15.8}    Function  GetLastDrawnBackgroundRect: TRect; StdCall;
          Asm
                  push   ebx
                  push   edi
                  mov    edi, eax
                  mov    eax, 15
                  mov    ebx, 8
                  int    64
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
          End;
(* -------------------------------------------------------- *)
{15.9}    Procedure UpdateBackgroundRect(Left, Top, Right, Bottom: Integer); StdCall;
          Asm
                  push   ebx
                  mov    eax, 15
                  mov    ebx, 9
                  mov    ecx, Left
                  mov    edx, Top
                  shl    ecx, 16
                  shl    edx, 16
                  or     ecx, Right
                  or     edx, Bottom
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{16}      Function  FlushFloppyCache(FloppyNumber: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 15
                  mov    ebx, FloppyNumber
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{17}      Function  GetButton: TButtonInput; StdCall;
          Asm
                  mov    eax, 17
                  int    64
          End;
(* -------------------------------------------------------- *)
{18.1}    Procedure DeactivateWindow(Slot: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 1
                  mov    ecx, Slot
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.2}    Procedure ThreadTerminateBySlot(Slot: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 2
                  mov    ecx, Slot
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.3}    Procedure ActivateWindow(Slot: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 3
                  mov    ecx, Slot
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.4}    Function  GetIdleTime: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 4
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.5}    Function  GetCPUClock: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 5
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.6}    Function  SaveRamDisk(Path: PChar): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 1
                  mov    ecx, Path
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.7}    Function  GetActiveWindow: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 7
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.8.1}  Function  GetSpeakerState: Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 8
                  mov    ecx, 1
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.8.2}  Procedure SwitchSpeakerState; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 8
                  mov    ecx, 2
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.9}    Function  SystemShutdown(Param: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 9
                  mov    ecx, Param
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.10}   Procedure MinimizeActiveWindow; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 10
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.11}   Procedure GetDiskSystemInfo(Var Buffer); StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 11
                  mov    ecx, Buffer
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.12}   {UNDEFINED}
(* -------------------------------------------------------- *)
{18.13}   Procedure GetKernelVersion(Var Buffer: TKernelVersion); StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 13
                  mov    ecx, Buffer
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.14}   Function  WaitRetrace: Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 14
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.15}   Function  CenterMousePointer: Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 15
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.16}   Function  GetFreeMemory: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 16
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.17}   Function  GetAvailableMemory: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 17
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.18}   Function  ThreadTerminateById(ID: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 18
                  mov    ecx, ID
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.19.0} Function  GetMouseSpeed: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 19
                  mov    ecx, 0
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.19.1} Procedure SetMouseSpeed(Speed: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 19
                  mov    ecx, 1
                  mov    edx, Speed
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.19.2} Function  GetMouseSensitivity: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 19
                  mov    ecx, 2
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.19.3} Procedure SetMouseSensitivity(Sensitivity: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 19
                  mov    ecx, 3
                  mov    edx, Sensitivity
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.19.4} Procedure SetMousePos(X, Y: Integer); StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 19
                  mov    ecx, 4
                  mov    edx, X
                  shl    edx, 16
                  or     edx, Y
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.19.5} Procedure SetMouseButtons(State: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 19
                  mov    ecx, 5
                  mov    edx, State
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.19.6} Function  GetDoubleClickTime: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 19
                  mov    ecx, 6
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.19.7} Procedure SetDoubleClickTime(Time: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 19
                  mov    ecx, 7
                  mov    edx, Time
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.20}   Function  GetRAMInfo(Var Buffer: TRAMInfo): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 20
                  mov    ecx, Buffer
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.21}   Function  GetSlotById(ID: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 21
                  mov    ecx, ID
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.22.0} Function  MinimizeWindowBySlot(Slot: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 22
                  mov    ecx, 0
                  mov    edx, Slot
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.22.1} Function  MinimizeWindowByID(ID: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 22
                  mov    ecx, 1
                  mov    edx, ID
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.22.2} Function  RestoreWindowBySlot(Slot: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 22
                  mov    ecx, 2
                  mov    edx, Slot
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.22.3} Function  RestoreWindowByID(ID: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 22
                  mov    ecx, 3
                  mov    edx, ID
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.23}   Function  MinimizeAllWindows: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 23
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.24}   Procedure SetScreenLimits(Width, Height: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 24
                  mov    ecx, Width
                  mov    edx, Height
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.25.1} Function  GetWindowZOrder(ID: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 18
                  mov    ebx, 25
                  mov    ecx, 1
                  mov    edx, ID
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{18.25.2} Function  SetWindowZOrder(ID, ZOrder: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  push   esi
                  mov    eax, 18
                  mov    ebx, 25
                  mov    ecx, 2
                  mov    edx, ID
                  mov    esi, ZOrder
                  int    64
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{19}      {UNDEFINED}
(* -------------------------------------------------------- *)
{20.1}    Function  ResetMidi: Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 20
                  mov    ebx, 1
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{20.2}    Function  OutputMidi(Data: Byte): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 20
                  mov    ebx, 2
                  mov    cl, Data
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{21.1}    Function  SetMidiBase(Port: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 21
                  mov    ebx, 1
                  mov    ecx, Port
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{21.2}    Function  SetKeyboardLayout(Flags: Dword; Var Table: TKeyboardLayout): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 21
                  mov    ebx, 2
                  mov    ecx, Flags
                  mov    edx, Table
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{21.2}    Function  SetKeyboardLayoutCountry(Country: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 21
                  mov    ebx, 2
                  mov    ecx, 9
                  mov    edx, Country
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{21.3}    {UNDEFINED}
(* -------------------------------------------------------- *)
{21.4}    {UNDEFINED}
(* -------------------------------------------------------- *)
{21.5}    Function  SetSystemLanguage(SystemLanguage: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 21
                  mov    ebx, 5
                  mov    ecx, SystemLanguage
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{21.6}    {UNDEFINED}
(* -------------------------------------------------------- *)
{21.7}    {UNDEFINED}
(* -------------------------------------------------------- *)
{21.8}    {UNDEFINED}
(* -------------------------------------------------------- *)
{21.9}    {UNDEFINED}
(* -------------------------------------------------------- *)
{21.10}   {UNDEFINED}
(* -------------------------------------------------------- *)
{21.11}   Function  SetHDAccess(Value: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 21
                  mov    ebx, 11
                  mov    ecx, Value
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{21.12}   Function  SetPCIAccess(Value: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 21
                  mov    ebx, 12
                  mov    ecx, Value
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{22.0}    Function  SetSystemTime(Time: TSystemTime): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 22
                  mov    ebx, 0
                  mov    ecx, Time
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{22.1}    Function  SetSystemDate(Date: TSystemDate): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 22
                  mov    ebx, 1
                  mov    ecx, Date
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{22.2}    Function  SetDayOfWeek(DayOfWeek: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 22
                  mov    ebx, 2
                  mov    ecx, DayOfWeek
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{22.3}    Function  SetAlarm(Time: TSystemTime): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 22
                  mov    ebx, 3
                  mov    ecx, Time
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{23}      Function  WaitEventByTime(Time: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 23
                  mov    ebx, Time
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{24.4}    Procedure OpenCDTray(Drive: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 24
                  mov    ebx, 4
                  mov    ecx, Drive
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{24.5}    Procedure CloseCDTray(Drive: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 24
                  mov    ebx, 5
                  mov    ecx, Drive
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{25}      Procedure DrawBackgroundLayerImage(Const Image; X, Y: Integer; Width, Height: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 25
                  mov    ebx, Image
                  mov    ecx, Width
                  mov    edx, X
                  shl    ecx, 16
                  shl    edx, 16
                  or     ecx, Height
                  or     edx, Y
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{26.1}    Function  GetMidiBase: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 26
                  mov    ebx, 1
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{26.2}    Procedure GetKeyboardLayout(Flags: Dword; Var Table: TKeyboardLayout); StdCall;
          Asm
                  push   ebx
                  mov    eax, 26
                  mov    ebx, 2
                  mov    ecx, Flags
                  mov    edx, Table
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{26.2}    Function  GetKeyboardLayoutCountry: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 26
                  mov    ebx, 2
                  mov    ecx, 9
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{26.3}    {UNDEFINED}
(* -------------------------------------------------------- *)
{26.4}    {UNDEFINED}
(* -------------------------------------------------------- *)
{26.5}    Function  GetSystemLanguage: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 26
                  mov    ebx, 5
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{26.6}    {UNDEFINED}
(* -------------------------------------------------------- *)
{26.7}    {UNDEFINED}
(* -------------------------------------------------------- *)
{26.8}    {UNDEFINED}
(* -------------------------------------------------------- *)
{26.9}    Function  GetTickCount: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 26
                  mov    ebx, 9
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{26.10}   Function  GetTickCount64: Qword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 26
                  mov    ebx, 10
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{26.11}   Function  IsHDAccessAllowed: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 26
                  mov    ebx, 11
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{26.12}   Function  IsPCIAccessAllowed: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 26
                  mov    ebx, 12
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{27}      {UNDEFINED}
(* -------------------------------------------------------- *)
{28}      {UNDEFINED}
(* -------------------------------------------------------- *)
{29}      Function  GetSystemDate: TSystemDate; StdCall;
          Asm
                  mov    eax, 29
                  int    64
          End;
(* -------------------------------------------------------- *)
{30.1}    Procedure SetCurrentDirectory(Path: PChar); StdCall;
          Asm
                  push   ebx
                  mov    eax, 30
                  mov    ebx, 1
                  mov    ecx, Path
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{30.2}    Function  GetCurrentDirectory(Buffer: PChar; Count: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 30
                  mov    ebx, 2
                  mov    ecx, Buffer
                  mov    edx, Count
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{31}      {UNDEFINED}
(* -------------------------------------------------------- *)
{32}      {UNDEFINED}
(* -------------------------------------------------------- *)
{33}      {UNDEFINED}
(* -------------------------------------------------------- *)
{34}      Function  GetPointOwner(X, Y: Integer): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 34
                  mov    ebx, X
                  mov    ecx, Y
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{35}      Function  GetPixel(X, Y: Integer): Dword; StdCall;
          Asm
                  push   ebx
          // at first need to know Screen.Width
                  mov    eax, 61
                  mov    ebx, 1
                  int    64
          // at now eax = (Width << 16) | Height
          // need to make ebx = Y * Screen.Width + X
                  shr    eax, 16
                  mul    Y
                  add    eax, X
                  mov    ebx, eax
          // and now GetPixel
                  mov    eax, 35
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{36}      Procedure GetScreenImage(Var Buffer; X, Y: Integer; Width, Height: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 36
                  mov    ebx, Buffer
                  mov    ecx, Width
                  mov    edx, X
                  shl    ecx, 16
                  shl    edx, 16
                  or     ecx, Height
                  or     edx, Y
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{37.0}    Function  GetMousePos: TPoint; StdCall;
          Asm
                  push   ebx
                  mov    eax, 37
                  mov    ebx, 0
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{37.1}    Function  GetWindowMousePos: TPoint; StdCall;
          Asm
                  push   ebx
                  mov    eax, 37
                  mov    ebx, 1
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{37.2}    Function  GetMouseButtons: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 37
                  mov    ebx, 2
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{37.3}    Function  GetMouseEvents: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 37
                  mov    ebx, 3
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{37.4}    Function  LoadCursorFromFile(Path: PChar): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 37
                  mov    ebx, 4
                  mov    ecx, Path
                  mov    edx, 0
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{37.4}    Function  LoadCursorFromMemory(Const Buffer): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 37
                  mov    ebx, 4
                  mov    ecx, Buffer
                  mov    edx, 1
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{37.4}    Function  LoadCursorIndirect(Const Buffer; HotSpotX, HotSpotY: ShortInt): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 37
                  mov    ebx, 4
                  mov    ecx, Buffer
                  mov    dl, HotSpotY
                  mov    dh, HotSpotX
                  shl    edx, 16
                  or     edx, 2
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{37.5}    Function  SetCursor(Handle: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 37
                  mov    ebx, 5
                  mov    ecx, Handle
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{37.6}    Function  DeleteCursor(Handle: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 37
                  mov    ebx, 6
                  mov    ecx, Handle
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{37.7}    Function  GetMouseScroll: TPoint; StdCall;
          Asm
                  push   ebx
                  mov    eax, 37
                  mov    ebx, 7
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{38}      Procedure DrawLine(X1, Y1, X2, Y2: Integer; Color: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 38
                  mov    ebx, X1
                  mov    ecx, Y1
                  shl    ebx, 16
                  shl    ecx, 16
                  or     ebx, X2
                  or     ecx, Y2
                  mov    edx, Color
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{39.1}    Function  GetBackgroundSize: TSize; StdCall;
          Asm
                  push   ebx
                  mov    eax, 39
                  mov    ebx, 1
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{39.2}    Function  GetBackgroundPixel(X, Y: Integer): Dword; StdCall;
          Asm
                  push   ebx
          // at first need to know Background.Width
                  mov    eax, 39
                  mov    ebx, 1
                  int    64
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
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{39.3}    {UNDEFINED}
(* -------------------------------------------------------- *)
{39.4}    Function  GetBackgroundDrawMode: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 39
                  mov    ebx, 4
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{40}      Function  SetEventMask(Mask: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 40
                  mov    ebx, Mask
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{41}      {UNDEFINED}
(* -------------------------------------------------------- *)
{42}      {UNDEFINED}
(* -------------------------------------------------------- *)
{43}      Function  InPort(Port: Dword; Var Data: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 43
                  mov    ecx, Port
                  or     ecx, $80000000
                  int    64
                  mov    ecx, Data
                  mov    [ecx], bl
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{43}      Function  OutPort(Port: Dword; Data: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 43
                  mov    bl, Data
                  mov    ecx, Port
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{44}      {UNDEFINED}
(* -------------------------------------------------------- *)
{45}      {UNDEFINED}
(* -------------------------------------------------------- *)
{46}      Function  ReservePorts(First, Last: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 46
                  mov    ebx, 0
                  mov    ecx, First
                  mov    edx, Last
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{46}      Function  FreePorts(First, Last: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 46
                  mov    ebx, 1
                  mov    ecx, First
                  mov    edx, Last
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{47}      {DrawNumber}
(* -------------------------------------------------------- *)
{48.0}    Procedure ApplyStyleSettings; StdCall;
          Asm
                  push   ebx
                  mov    eax, 48
                  mov    ebx, 0
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{48.1}    Procedure SetButtonStyle(ButtonStyle: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 48
                  mov    ebx, 1
                  mov    ecx, ButtonStyle
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{48.2}    Procedure SetStandardColors(Var ColorTable: TStandardColors; Size: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 48
                  mov    ebx, 2
                  mov    ecx, ColorTable
                  mov    edx, Size
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{48.3}    Procedure GetStandardColors(Var ColorTable: TStandardColors; Size: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 48
                  mov    ebx, 3
                  mov    ecx, ColorTable
                  mov    edx, Size
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{48.4}    Function  GetSkinHeight: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 48
                  mov    ebx, 4
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{48.5}    Function  GetScreenWorkingArea: TRect; StdCall;
          Asm
                  push   ebx
                  push   edi
                  mov    edi, eax
                  mov    eax, 48
                  mov    ebx, 5
                  int    64
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
          End;
(* -------------------------------------------------------- *)
{48.6}    Procedure SetScreenWorkingArea(Left, Top, Right, Bottom: Integer); StdCall;
          Asm
                  push   ebx
                  mov    eax, 48
                  mov    ebx, 6
                  mov    ecx, Left
                  mov    edx, Top
                  shl    ecx, 16
                  shl    edx, 16
                  or     ecx, Right
                  or     edx, Bottom
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{48.7}    Function  GetSkinMargins: TRect; StdCall;
          Asm
                  push   ebx
                  push   edi
                  mov    edi, eax
                  mov    eax, 48
                  mov    ebx, 7
                  int    64
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
          End;
(* -------------------------------------------------------- *)
{48.8}    Function  SetSkin(Path: PChar): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 48
                  mov    ebx, 8
                  mov    ecx, Path
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{48.9}    Function  GetFontSmoothing: Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 48
                  mov    ebx, 9
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{48.10}   Procedure SetFontSmoothing(Smoothing: Integer); StdCall;
          Asm
                  push   ebx
                  mov    eax, 48
                  mov    ebx, 10
                  mov    ecx, Smoothing
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{48.11}   Function  GetFontHeight: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 48
                  mov    ebx, 11
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{48.12}   Procedure SetFontHeight(Height: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 48
                  mov    ebx, 12
                  mov    ecx, Height
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{49}      {Advanced Power Management}
(* -------------------------------------------------------- *)
{50.0}    Procedure SetWindowShape(Const Data); StdCall;
          Asm
                  push   ebx
                  mov    eax, 50
                  mov    ebx, 0
                  mov    ecx, Data
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{50.1}    Procedure SetWindowScale(Scale: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 50
                  mov    ebx, 1
                  mov    ecx, Scale
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{51.1}    Function  ThreadCreate(Entry, Stack: Pointer): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 51
                  mov    ebx, 1
                  mov    ecx, Entry
                  mov    edx, Stack
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{52}      {UNDEFINED}
(* -------------------------------------------------------- *)
{53}      {UNDEFINED}
(* -------------------------------------------------------- *)
{54.0}    Function  GetClipboardSlotCount: Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 54
                  mov    ebx, 0
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{54.1}    Function  GetClipboardData(Slot: Dword): Pointer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 54
                  mov    ebx, 1
                  mov    ecx, Slot
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{54.2}    Function  SetClipboardData(Const Src; Count: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 54
                  mov    ebx, 2
                  mov    ecx, Count
                  mov    edx, Src
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{54.3}    Function  DeleteClipboardLastSlot: Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 54
                  mov    ebx, 3
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{54.4}    Function  ResetClipboard: Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 54
                  mov    ebx, 4
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{55}      Function  SpeakerPlay(Const Data): Dword; StdCall;
          Asm
                  push   ebx
                  push   esi
                  mov    eax, 55
                  mov    ebx, 55
                  mov    esi, Data
                  int    64
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{56}      {UNDEFINED}
(* -------------------------------------------------------- *)
{57}      {PCI BIOS}
(* -------------------------------------------------------- *)
{58}      {UNDEFINED}
(* -------------------------------------------------------- *)
{59}      {UNDEFINED}
(* -------------------------------------------------------- *)
{60.1}    Function  IPCSetBuffer(Const Buffer: TIPCBuffer; Size: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 60
                  mov    ebx, 1
                  mov    ecx, Buffer
                  mov    edx, Size
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{60.2}    Function  IPCSendMessage(ID: Dword; Var Msg: TIPCMessage; Size: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  push   esi
                  mov    eax, 60
                  mov    ebx, 2
                  mov    ecx, ID
                  mov    edx, Msg
                  mov    esi, Size
                  int    64
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{61.1}    Function  GetScreenSize: TSize; StdCall;
          Asm
                  push   ebx
                  mov    eax, 61
                  mov    ebx, 1
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{61.2}    Function  GetScreenBitsPerPixel: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 61
                  mov    ebx, 2
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{61.3}    Function  GetScreenBytesPerScanLine: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 61
                  mov    ebx, 3
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{62.0}    Function  GetPCIVersion: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 62
                  mov    bl, 0
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{62.1}    Function  GetLastPCIBus: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 62
                  mov    bl, 1
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{62.2}    Function  GetPCIAddressingMode: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 62
                  mov    bl, 2
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{62.3}    {UNDEFINED}
(* -------------------------------------------------------- *)
{62.4}    Function  ReadPCIByte(Bus, Device, Func, Reg: Byte): Byte; StdCall;
          Asm
                  push   ebx
                  mov    eax, 62
                  mov    bl, 4
                  mov    bh, Bus
                  mov    cl, Reg
                  mov    ch, Device
                  shl    ch, 3
                  or     ch, Func
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{62.5}    Function  ReadPCIWord(Bus, Device, Func, Reg: Byte): Word; StdCall;
          Asm
                  push   ebx
                  mov    eax, 62
                  mov    bl, 5
                  mov    bh, Bus
                  mov    cl, Reg
                  mov    ch, Device
                  shl    ch, 3
                  or     ch, Func
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{62.6}    Function  ReadPCIDword(Bus, Device, Func, Reg: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 62
                  mov    bl, 6
                  mov    bh, Bus
                  mov    cl, Reg
                  mov    ch, Device
                  shl    ch, 3
                  or     ch, Func
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{62.7}    {UNDEFINED}
(* -------------------------------------------------------- *)
{62.8}    Function  WritePCIByte(Bus, Device, Func, Reg: Byte; Data: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 62
                  mov    bl, 8
                  mov    bh, Bus
                  mov    cl, Reg
                  mov    ch, Device
                  shl    ch, 3
                  or     ch, Func
                  mov    dl, Data
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{62.9}    Function  WritePCIWord(Bus, Device, Func, Reg: Byte; Data: Word): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 62
                  mov    bl, 9
                  mov    bh, Bus
                  mov    cl, Reg
                  mov    ch, Device
                  shl    ch, 3
                  or     ch, Func
                  mov    dx, Data
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{62.10}   Function  WritePCIDword(Bus, Device, Func, Reg: Byte; Data: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 62
                  mov    bl, 10
                  mov    bh, Bus
                  mov    cl, Reg
                  mov    ch, Device
                  shl    ch, 3
                  or     ch, Func
                  mov    edx, Data
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{63.1}    Procedure BoardWriteByte(Data: Byte); StdCall;
          Asm
                  push   ebx
                  mov    eax, 63
                  mov    ebx, 1
                  mov    cl, Data
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{63.2}    Function  BoardReadByte(Var Data: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 63
                  mov    ebx, 2
                  int    64
                  mov    ecx, Data
                  mov    [ecx], al
                  mov    eax, ebx
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{64}      Function  ReallocAppMemory(Count: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 64
                  mov    ebx, 1
                  mov    ecx, Count
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{65}      Procedure DrawImageEx(Const Image; Left, Top: Integer; Width, Height: Dword; BPP: Dword; Const Palette: Pointer; Padding: Dword); StdCall;
          Asm
                  push   ebx
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
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{66.1}    Procedure SetKeyboardInputMode(Mode: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 66
                  mov    ebx, 1
                  mov    ecx, Mode
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{66.2}    Function  GetKeyboardInputMode: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 66
                  mov    ebx, 2
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{66.3}    Function  GetControlKeyState: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 66
                  mov    ebx, 3
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{66.4}    Function  SetHotKey(ScanCode, Control: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 66
                  mov    ebx, 4
                  mov    ecx, ScanCode
                  mov    edx, Control
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{66.5}    Function  ResetHotKey(ScanCode, Control: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 66
                  mov    ebx, 4
                  mov    ecx, ScanCode
                  mov    edx, Control
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{66.6}    Procedure KeyboardLock; StdCall;
          Asm
                  push   ebx
                  mov    eax, 66
                  mov    ebx, 6
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{66.7}    Procedure KeyboardUnlock; StdCall;
          Asm
                  push   ebx
                  mov    eax, 66
                  mov    ebx, 7
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{67}      Procedure SetWindowPos(Left, Top, Right, Bottom: Integer); StdCall;
          Asm
                  push   ebx
                  push   esi
                  mov    eax, 67
                  mov    ebx, Left
                  mov    ecx, Top
                  mov    edx, Right
                  mov    esi, Bottom
                  int    64
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.0}    Function  GetTaskSwitchCount: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 68
                  mov    ebx, 0
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.1}    Procedure SwitchThread; StdCall;
          Asm
                  push   ebx
                  mov    eax, 68
                  mov    ebx, 1
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.2.0}  Function  EnableRDPMC: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 68
                  mov    ebx, 2
                  mov    ecx, 0
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.2.1}  Function  IsCacheEnabled: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 68
                  mov    ebx, 2
                  mov    ecx, 1
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.2.2}  Procedure EnableCache; StdCall;
          Asm
                  push   ebx
                  mov    eax, 68
                  mov    ebx, 2
                  mov    ecx, 2
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.2.3}  Procedure DisableCache; StdCall;
          Asm
                  push   ebx
                  mov    eax, 68
                  mov    ebx, 2
                  mov    ecx, 3
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.3}    {ReadMSR}
(* -------------------------------------------------------- *)
{68.4}    {WriteMSR}
(* -------------------------------------------------------- *)
{68.5}    {UNDEFINED}
(* -------------------------------------------------------- *)
{68.6}    {UNDEFINED}
(* -------------------------------------------------------- *)
{68.7}    {UNDEFINED}
(* -------------------------------------------------------- *)
{68.8}    {UNDEFINED}
(* -------------------------------------------------------- *)
{68.9}    {UNDEFINED}
(* -------------------------------------------------------- *)
{68.10}   {UNDEFINED}
(* -------------------------------------------------------- *)
{68.11}   Function  HeapCreate: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 68
                  mov    ebx, 11
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.12}   Function  HeapAllocate(Bytes: Dword): Pointer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 68
                  mov    ebx, 12
                  mov    ecx, Bytes
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.13}   Function  HeapFree(MemPtr: Pointer): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 68
                  mov    ebx, 13
                  mov    ecx, MemPtr
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.14}   Procedure WaitSignal(Var Buffer: TSignalBuffer); StdCall;
          Asm
                  push   ebx
                  mov    eax, 68
                  mov    ebx, 14
                  mov    ecx, Buffer
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.15}   {UNDEFINED}
(* -------------------------------------------------------- *)
{68.16}   Function  GetDriver(Name: PChar): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 68
                  mov    ebx, 16
                  mov    ecx, Name
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.17}   Function  ControlDriver(Var CtrlStructure: TCtrlDriver): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 68
                  mov    ebx, 17
                  mov    ecx, CtrlStructure
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.18}   {UNDEFINED}
(* -------------------------------------------------------- *)
{68.19}   Function  LoadLibrary(Path: PChar): Pointer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 68
                  mov    ebx, 19
                  mov    ecx, Path
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.20}   Function  HeapReallocate(MemPtr: Pointer; Bytes: Dword): Pointer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 68
                  mov    ebx, 20
                  mov    ecx, Bytes
                  mov    edx, MemPtr
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.21}   Function  LoadDriver(Name, CmdLine: PChar): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 68
                  mov    ebx, 21
                  mov    ecx, Name
                  mov    edx, CmdLine
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.22}   Function  SharedMemoryOpen(Name: PChar; Bytes: Dword; Flags: Dword): Pointer; StdCall;
          Asm
                  push   ebx
                  push   esi
                  mov    eax, 68
                  mov    ebx, 22
                  mov    ecx, Name
                  mov    edx, Bytes
                  mov    esi, Flags
                  int    64
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.23}   Function  SharedMemoryClose(Name: PChar): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 68
                  mov    ebx, 23
                  mov    ecx, Name
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.24}   Function  SetExceptionHandler(Handler: Pointer; Mask: Dword; Var OldMask: Dword): Pointer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 68
                  mov    ebx, 24
                  mov    ecx, Handler
                  mov    edx, Mask
                  int    64
                  mov    ecx, OldMask
                  mov    [ecx], ebx
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.25}   Function  SetExceptionActivity(Signal, Activity: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 68
                  mov    ebx, 25
                  mov    ecx, Signal
                  mov    edx, Activity
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.26}   Procedure ReleaseMemoryPages(MemPtr: Pointer; Offset, Size: Dword); StdCall;
          Asm
                  push   ebx
                  push   esi
                  mov    eax, 68
                  mov    ebx, 26
                  mov    ecx, MemPtr
                  mov    edx, &Offset
                  mov    esi, Size
                  int    64
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{68.27}   Function  LoadFile(Path: PChar; Var Size: Dword): Pointer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 68
                  mov    ebx, 27
                  mov    ecx, Path
                  int    64
                  mov    ecx, Size
                  mov    [ecx], edx
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{69.0}    Procedure SetDebugBuffer(Const Buffer: TDebugBuffer); StdCall;
          Asm
                  push   ebx
                  mov    eax, 69
                  mov    ebx, 0
                  mov    ecx, Buffer
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{69.1}    Procedure GetThreadContext(ID: Dword; Var Context: TThreadContext); StdCall;
          Const SIZEOF_TTHREADCONTEXT = SizeOf(TThreadContext);
          Asm
                  push   ebx
                  push   esi
                  mov    eax, 69
                  mov    ebx, 1
                  mov    ecx, ID
                  mov    edx, SIZEOF_TTHREADCONTEXT
                  mov    esi, Context
                  int    64
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{69.2}    Procedure SetThreadContext(ID: Dword; Const Context: TThreadContext); StdCall;
          Const SIZEOF_TTHREADCONTEXT = SizeOf(TThreadContext);
          Asm
                  push   ebx
                  push   esi
                  mov    eax, 69
                  mov    ebx, 2
                  mov    ecx, ID
                  mov    edx, SIZEOF_TTHREADCONTEXT
                  mov    esi, Context
                  int    64
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{69.3}    Procedure DetachThread(ID: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 69
                  mov    ebx, 3
                  mov    ecx, ID
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{69.4}    Procedure SuspendThread(ID: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 69
                  mov    ebx, 4
                  mov    ecx, ID
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{69.5}    Procedure ResumeThread(ID: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 69
                  mov    ebx, 5
                  mov    ecx, ID
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{69.6}    Function  ReadProcessMemory(ID, Count: Dword; Const Src; Var Dst): Integer; StdCall;
          Asm
                  push   ebx
                  push   esi
                  push   edi
                  mov    eax, 69
                  mov    ebx, 6
                  mov    ecx, ID
                  mov    edx, Count
                  mov    esi, Src
                  mov    edi, Dst
                  int    64
                  pop    edi
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{69.7}    Function  WriteProcessMemory(ID, Count: Dword; Const Src; Var Dst): Integer; StdCall;
          Asm
                  push   ebx
                  push   esi
                  push   edi
                  mov    eax, 69
                  mov    ebx, 7
                  mov    ecx, ID
                  mov    edx, Count
                  mov    esi, Dst
                  mov    edi, Src
                  int    64
                  pop    edi
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{69.8}    Procedure DebugTerminate(ID: Dword); StdCall;
          Asm
                  push   ebx
                  mov    eax, 69
                  mov    ebx, 8
                  mov    ecx, ID
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{69.9}    Function  SetBreakPoint(ID: Dword; Index, Flags: Byte; Address: Pointer): Integer; StdCall;
          Asm
                  push   ebx
                  push   esi
                  mov    eax, 69
                  mov    ebx, 9
                  mov    ecx, ID
                  mov    dl, Index
                  mov    dh, Flags
                  mov    esi, Address
                  int    64
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{69.9}    Function  ResetBreakPoint(ID: Dword; Index, Flags: Byte; Address: Pointer): Integer; StdCall;
          Asm
                  push   ebx
                  push   esi
                  mov    eax, 69
                  mov    ebx, 9
                  mov    ecx, ID
                  mov    dl, Index
                  mov    dh, Flags
                  or     dh, $80
                  mov    esi, Address
                  int    64
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{70.0}    Function  ReadFile(Path: PChar; Var Buffer; Count, LoPos, HiPos: Cardinal; Var BytesRead: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  push   Path
                  dec    esp
                  mov    byte[esp], 0
                  push   Buffer
                  push   Count
                  push   HiPos
                  push   LoPos
                  push   0
                  mov    ebx, esp
                  mov    eax, 70
                  int    64
                  add    esp, 25
                  mov    ecx, BytesRead
                  mov    [ecx], ebx
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{70.1}    Function  ReadFolder(Path: PChar; Var Buffer; Count, Start, Flags: Cardinal; Var BlocksRead: Dword): Integer; StdCall;
          Asm
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
                  int    64
                  add    esp, 25
                  mov    ecx, BlocksRead
                  mov    [ecx], ebx                  
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{70.2}    Function  CreateFile(Path: PChar): Integer; StdCall;
          Asm
                  push   ebx
                  push   Path
                  dec    esp
                  mov    byte[esp], 0
                  push   0
                  push   0
                  push   0
                  push   0
                  push   2
                  mov    ebx, esp
                  mov    eax, 70
                  int    64
                  add    esp, 25
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{70.3}    Function  WriteFile(Path: PChar; Const Buffer; Count, LoPos, HiPos: Cardinal; Var BytesWritten: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  push   Path
                  dec    esp
                  mov    byte[esp], 0
                  push   Buffer
                  push   Count
                  push   HiPos
                  push   LoPos
                  push   3
                  mov    ebx, esp
                  mov    eax, 70
                  int    64
                  add    esp, 25
                  mov    ecx, BytesWritten
                  mov    [ecx], ebx                     
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{70.4}    Function  ResizeFile(Path: PChar; LoSize, HiSize: Cardinal): Integer; StdCall;
          Asm
                  push   ebx
                  push   Path
                  dec    esp
                  mov    byte[esp], 0
                  push   0
                  push   0
                  push   HiSize
                  push   LoSize
                  push   4
                  mov    ebx, esp
                  mov    eax, 70
                  int    64
                  add    esp, 25
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{70.5}    Function  GetFileAttributes(Path: PChar; Var Buffer: TFileAttributes): Integer; StdCall;
          Asm
                  push   ebx
                  push   Path
                  dec    esp
                  mov    byte[esp], 0
                  push   Buffer
                  push   0
                  push   0
                  push   0
                  push   5
                  mov    ebx, esp
                  mov    eax, 70
                  int    64
                  add    esp, 25
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{70.6}    Function  SetFileAttributes(Path: PChar; Var Buffer: TFileAttributes): Integer; StdCall;
          Asm
                  push   ebx
                  push   Path
                  dec    esp
                  mov    byte[esp], 0
                  push   Buffer
                  push   0
                  push   0
                  push   0
                  push   6
                  mov    ebx, esp
                  mov    eax, 70
                  int    64
                  add    esp, 25
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{70.7}    Function  RunFile(Path, CmdLine: PChar): Integer; StdCall;
          Asm
                  push   ebx
                  push   Path
                  dec    esp
                  mov    byte[esp], 0
                  push   0
                  push   0
                  push   CmdLine
                  push   0
                  push   7
                  mov    ebx, esp
                  mov    eax, 70
                  int    64
                  add    esp, 25
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{70.7}    Function  DebugFile(Path, CmdLine: PChar): Integer; StdCall;
          Asm
                  push   ebx
                  push   Path
                  dec    esp
                  mov    byte[esp], 0
                  push   0
                  push   0
                  push   CmdLine
                  push   1
                  push   7
                  mov    ebx, esp
                  mov    eax, 70
                  int    64
                  add    esp, 25
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{70.8}    Function  DeleteFile(Path: PChar): Integer; StdCall;
          Asm
                  push   ebx
                  push   Path
                  dec    esp
                  mov    byte[esp], 0
                  push   0
                  push   0
                  push   0
                  push   0
                  push   8
                  mov    ebx, esp
                  mov    eax, 70
                  int    64
                  add    esp, 25
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{70.9}    Function  CreateFolder(Path: PChar): Integer; StdCall;
          Asm
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
                  int    64
                  add    esp, 25
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{71.1}    Procedure SetWindowCaption(Caption: PChar); StdCall;
          Asm
                  push   ebx
                  mov    eax, 71
                  mov    ebx, 1
                  mov    ecx, Caption
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{72.1.2}  Function  SendActiveWindowKey(KeyCode: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 72
                  mov    ebx, 1
                  mov    ecx, 2
                  mov    edx, KeyCode
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{72.1.3}  Function  SendActiveWindowButton(ButtonID: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 72
                  mov    ebx, 1
                  mov    ecx, 3
                  mov    edx, ButtonID
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{73}      Procedure Blit(Const Src; SrcX, SrcY: Integer; SrcW, SrcH: Dword; DstX, DstY: Integer; DstW, DstH: Dword; Stride, Flags: Dword); StdCall;
          Asm
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
                  int    64
                  add    esp, 40
          End;
(* -------------------------------------------------------- *)
{74.-1}   Function  GetActiveNetworkDevices: Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 74
                  mov    bl, -1
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{74.0}    Function  GetNetworkDeviceType(Device: Byte): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 74
                  mov    bl, 0
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{74.1}    Function  GetNetworkDeviceName(Device: Byte; Var Buffer): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 74
                  mov    bl, 1
                  mov    bh, Device
                  mov    ecx, Buffer
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{74.2}    Function  ResetNetworkDevice(Device: Byte): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 74
                  mov    bl, 2
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{74.3}    Function  StopNetworkDevice(Device: Byte): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 74
                  mov    bl, 3
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{74.4}    Function  GetNetworkDevicePointer(Device: Byte): Pointer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 74
                  mov    bl, 4
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{74.5}    {UNDEFINED}
(* -------------------------------------------------------- *)
{74.6}    Function  GetSentPackets(Device: Byte): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 74
                  mov    bl, 6
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{74.7}    Function  GetReceivedPackets(Device: Byte): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 74
                  mov    bl, 7
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{74.8}    Function  GetSentBytes(Device: Byte): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 74
                  mov    bl, 8
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{74.9}    Function  GetReceivedBytes(Device: Byte): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 74
                  mov    bl, 9
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{74.10}   Function  GetLinkStatus(Device: Byte): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 74
                  mov    bl, 10
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{75.0}    Function  OpenSocket(Domain, Kind, Protocol: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  push   esi
                  mov    eax, 75
                  mov    bl, 0
                  mov    ecx, Domain
                  mov    edx, Kind
                  mov    esi, Protocol
                  int    64
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{75.1}    Function  CloseSocket(Socket: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 75
                  mov    bl, 1
                  mov    ecx, Socket
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{75.2}    Function  SocketBind(Socket: Dword; Var SockAddr: TSockAddr): Integer; StdCall;
          Const SIZEOF_TSOCKADDR = SizeOf(TSockAddr);
          Asm
                  push   ebx
                  push   esi
                  mov    eax, 75
                  mov    bl, 2
                  mov    ecx, Socket
                  mov    edx, SockAddr
                  mov    esi, SIZEOF_TSOCKADDR
                  int    64
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{75.3}    Function  SocketListen(Socket: Dword; Var BackLog): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 75
                  mov    bl, 3
                  mov    ecx, Socket
                  mov    edx, BackLog
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{75.4}    Function  SocketConnect(Socket: Dword; Var SockAddr: TSockAddr): Integer; StdCall;
          Const SIZEOF_TSOCKADDR = SizeOf(TSockAddr);
          Asm
                  push   ebx
                  push   esi
                  mov    eax, 75
                  mov    bl, 4
                  mov    ecx, Socket
                  mov    edx, SockAddr
                  mov    esi, SIZEOF_TSOCKADDR
                  int    64
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{75.5}    Function  SocketAccept(Socket: Dword; Var SockAddr: TSockAddr): Dword; StdCall;
          Const SIZEOF_TSOCKADDR = SizeOf(TSockAddr);
          Asm
                  push   ebx
                  push   esi
                  mov    eax, 75
                  mov    bl, 5
                  mov    ecx, Socket
                  mov    edx, SockAddr
                  mov    esi, SIZEOF_TSOCKADDR
                  int    64
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{75.6}    Function  SocketSend(Socket: Dword; Const Buffer; Size, Flags: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  push   esi
                  push   edi
                  mov    eax, 75
                  mov    bl, 6
                  mov    ecx, Socket
                  mov    edx, Buffer
                  mov    esi, Size
                  mov    edi, Flags
                  int    64
                  pop    edi
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{75.7}    Function  SocketReceive(Socket: Dword; Var Buffer; Size, Flags: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  push   esi
                  push   edi
                  mov    eax, 75
                  mov    bl, 7
                  mov    ecx, Socket
                  mov    edx, Buffer
                  mov    esi, Size
                  mov    edi, Flags
                  int    64
                  pop    edi
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{75.8}    Function  SetSocketOptions(Socket: Dword; Var OptStruct: TOptStruct): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 75
                  mov    bl, 8
                  mov    ecx, Socket
                  mov    edx, OptStruct
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{75.9}    Function  GetSocketOptions(Socket: Dword; Var OptStruct: TOptStruct): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 75
                  mov    bl, 9
                  mov    ecx, Socket
                  mov    edx, OptStruct
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{75.10}   Function  GetSocketPair(Var Socket1, Socket2: Dword): Integer; StdCall;
          Asm
                  push   ebx
                  mov    eax, 75
                  mov    bl, 10
                  int    64
                  mov    ecx, Socket1
                  mov    edx, Socket2
                  mov    [ecx], eax
                  mov    [edx], ebx
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.0.0}  Function  GetMAC(Device: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00000000
                  mov    bl, 0
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.1.0}  Function  GetIPv4SentPackets(Device: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00010000
                  mov    bl, 0
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.1.1}  Function  GetIPv4ReceivedPackets(Device: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00010000
                  mov    bl, 1
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.1.2}  Function  GetIPv4IP(Device: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00010000
                  mov    bl, 2
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.1.3}  Function  SetIPv4IP(Device: Byte; IP: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00010000
                  mov    bl, 3
                  mov    bh, Device
                  mov    ecx, IP
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.1.4}  Function  GetIPv4DNS(Device: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00010000
                  mov    bl, 4
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.1.5}  Function  SetIPv4DNS(Device: Byte; DNS: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00010000
                  mov    bl, 5
                  mov    bh, Device
                  mov    ecx, DNS
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.1.6}  Function  GetIPv4Subnet(Device: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00010000
                  mov    bl, 6
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.1.7}  Function  SetIPv4Subnet(Device: Byte; Subnet: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00010000
                  mov    bl, 7
                  mov    bh, Device
                  mov    ecx, Subnet
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.1.8}  Function  GetIPv4Gateway(Device: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00010000
                  mov    bl, 8
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.1.9}  Function  SetIPv4Gateway(Device: Byte; Gateway: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00010000
                  mov    bl, 9
                  mov    bh, Device
                  mov    ecx, Gateway
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.2.0}  Function  GetICMPSentPackets(Device: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00020000
                  mov    bl, 0
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.2.1}  Function  GetICMPReceivedPackets(Device: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00020000
                  mov    bl, 1
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.3.0}  Function  GetUDPSentPackets(Device: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00030000
                  mov    bl, 0
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.3.1}  Function  GetUDPReceivedPackets(Device: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00030000
                  mov    bl, 1
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.4.0}  Function  GetTCPSentPackets(Device: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00040000
                  mov    bl, 0
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.4.1}  Function  GetTCPReceivedPackets(Device: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00040000
                  mov    bl, 1
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.5.0}  Function  GetARPSentPackets(Device: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00050000
                  mov    bl, 0
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.5.1}  Function  GetARPReceivedPackets(Device: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00050000
                  mov    bl, 1
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.5.2}  Function  GetARPEntrys(Device: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00050000
                  mov    bl, 2
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.5.3}  Function  GetARPEntry(Device: Byte; Entry: Dword; Var Buffer): Dword; StdCall;
          Asm
                  push   ebx
                  push   edi
                  mov    eax, 76
                  mov    ebx, $00050000
                  mov    bl, 3
                  mov    bh, Device
                  mov    ecx, Entry
                  mov    edi, Buffer
                  int    64
                  pop    edi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.5.4}  Function  AddARPEntry(Device: Byte; Const Buffer): Dword; StdCall;
          Asm
                  push   ebx
                  push   esi
                  mov    eax, 76
                  mov    ebx, $00050000
                  mov    bl, 4
                  mov    bh, Device
                  mov    esi, Buffer
                  int    64
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.5.5}  Function  RemoveARPEntry(Device: Byte; Entry: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00050000
                  mov    bl, 5
                  mov    bh, Device
                  mov    ecx, Entry
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.5.6}  Function  SendARPAnnounce(Device: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00050000
                  mov    bl, 6
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{76.5.7}  Function  GetARPConflicts(Device: Byte): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 76
                  mov    ebx, $00050000
                  mov    bl, 7
                  mov    bh, Device
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{77.0}    Function  CreateFutex(Futex: Pointer): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 77
                  mov    ebx, 0
                  mov    ecx, Futex
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{77.1}    Function  DestroyFutex(Handle: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 77
                  mov    ebx, 1
                  mov    ecx, Handle
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{77.2}    Function  WaitFutex(Handle, Value, Time: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  push   esi
                  mov    eax, 77
                  mov    ebx, 2
                  mov    ecx, Handle
                  mov    edx, Value
                  mov    esi, Time
                  int    64
                  pop    esi
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
{77.3}    Function  WakeFutex(Handle, Waiters: Dword): Dword; StdCall;
          Asm
                  push   ebx
                  mov    eax, 77
                  mov    ebx, 3
                  mov    ecx, Handle
                  mov    edx, Waiters
                  int    64
                  pop    ebx
          End;
(* -------------------------------------------------------- *)
          Function  GetProcAddress(hLib: Pointer; ProcName: PChar): Pointer; StdCall;
          Asm
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
          End;
(* -------------------------------------------------------- *)
End.