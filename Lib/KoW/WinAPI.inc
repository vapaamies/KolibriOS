type
  HModule = type THandle;
  HWnd = type THandle;

  PCoord = ^TCoord;
  TCoord = packed record
    X, Y: SmallInt;
  end;

  PPoint = ^TPoint;
  TPoint = packed record
    X, Y: LongInt;
  end;

  PSmallRect = ^TSmallRect;
  TSmallRect = packed record
    Left, Top, Right, Bottom: SmallInt;
  end;

  PConsoleCursorInfo = ^TConsoleCursorInfo;
  TConsoleCursorInfo = packed record
    dwSize: LongWord;
    bVisible: LongBool;
  end;

  PConsoleFontInfo = ^TConsoleFontInfo;
  TConsoleFontInfo = packed record
    nFont: LongWord;
    dwFontSize: TCoord;
  end;

  PConsoleScreenBufferInfo = ^TConsoleScreenBufferInfo;
  TConsoleScreenBufferInfo = packed record
    dwSize: TCoord;
    dwCursorPosition: TCoord;
    wAttributes: Word;
    srWindow: TSmallRect;
    dwMaximumWindowSize: TCoord;
  end;

  PSystemTime = ^TSystemTime;
  TSystemTime = record
    wYear, wMonth, wDayOfWeek, wDay, wHour, wMinute, wSecond, wMilliseconds: Word;
  end;

  TOSVersionInfo = packed record
    dwOSVersionInfoSize, dwMajorVersion, dwMinorVersion, dwBuildNumber, dwPlatformId: LongWord;
    szCSDVersion: array[0..127] of AnsiChar;
  end;

const
  kernel32 = 'kernel32.dll';
  user32 = 'user32.dll';
  msvcrt = 'msvcrt.dll';

  INVALID_HANDLE_VALUE = THandle(-1);

  STD_INPUT_HANDLE  = LongWord(-10);
  STD_OUTPUT_HANDLE = LongWord(-11);

  GENERIC_READ  = LongWord($80000000);
  GENERIC_WRITE = LongWord($40000000);

  FILE_SHARE_READ  = LongWord($1);
  FILE_SHARE_WRITE = LongWord($2);

  OPEN_EXISTING = 3;
  OPEN_ALWAYS   = 4;

  FILE_BEGIN   = 0;
  FILE_CURRENT = 1;
  FILE_END     = 2;

  HEAP_NO_SERIALIZE = LongWord($00001);

  MB_ICONERROR = LongWord($0010);
  MB_TASKMODAL = LongWord($2000);

function AllocConsole: LongBool; stdcall;
  external kernel32 name 'AllocConsole';
function CreateFile(FileName: PAnsiChar; Access, ShareMode: LongWord; SecurityAttributes: Pointer; Disposition, FlagsAndAttributes: LongWord; hTemplateFile: THandle): THandle; stdcall;
  external kernel32 name 'CreateFileA';
procedure ExitProcess(ExitCode: Cardinal); stdcall;
  external kernel32 name 'ExitProcess';
function FillConsoleOutputCharacter(hConsoleOutput: THandle; Ch: AnsiChar; Count: LongWord; Coord: TCoord; var CharsWritten: LongWord): LongBool; stdcall;
  external kernel32 name 'FillConsoleOutputCharacterA';
function GetCommandLine: PAnsiChar; stdcall;
  external kernel32 name 'GetCommandLineA';
function GetConsoleCP: Cardinal; stdcall;
  external kernel32 name 'GetConsoleCP';
function GetConsoleCursorInfo(hConsoleOutput: THandle; var Info: TConsoleCursorInfo): LongBool; stdcall;
  external kernel32 name 'GetConsoleCursorInfo';
function GetConsoleOutputCP: Cardinal; stdcall;
  external kernel32 name 'GetConsoleOutputCP';
function GetConsoleScreenBufferInfo(hConsoleOutput: THandle; var Info: TConsoleScreenBufferInfo): LongBool; stdcall;
  external kernel32 name 'GetConsoleScreenBufferInfo';
function GetConsoleWindow: HWnd; stdcall;
  external kernel32 name 'GetConsoleWindow';
function GetCurrentConsoleFont(hConsoleOutput: THandle; MaximumWindow: LongBool; var Info: TConsoleFontInfo): LongBool; stdcall;
  external kernel32 name 'GetCurrentConsoleFont';
function GetCurrentDirectory(Count: LongWord; Buffer: PAnsiChar): LongWord; stdcall;
  external kernel32 name 'GetCurrentDirectoryA';
function GetFileSizeEx(hFile: THandle; var FileSize: UInt64): LongBool; stdcall;
  external kernel32 name 'GetFileSizeEx';
procedure GetLocalTime(var Time: TSystemTime); stdcall;
  external kernel32 name 'GetLocalTime';
function GetModuleFileName(hModule: HModule; Buffer: PAnsiChar; Count: Cardinal): Cardinal; stdcall;
  external kernel32 name 'GetModuleFileNameA';
function GetProcessHeap: THandle; stdcall;
  external kernel32 name 'GetProcessHeap';
function GetStdHandle(Code: LongWord): THandle; stdcall;
  external kernel32 name 'GetStdHandle';
function GetTickCount: LongWord; stdcall;
  external kernel32 name 'GetStdHandle';
function GetVersionEx(var Info: TOSVersionInfo): LongBool; stdcall;
  external kernel32 name 'GetVersionExA';
function HeapAlloc(hHeap: THandle; Flags, Bytes: Cardinal): Pointer; stdcall;
  external kernel32 name 'HeapAlloc';
function HeapReAlloc(hHeap: THandle; Flags: Cardinal; Mem: Pointer; Bytes: Cardinal): Pointer; stdcall;
  external kernel32 name 'HeapReAlloc';
function HeapFree(hHeap: THandle; Flags: Cardinal; Mem: Pointer): LongBool; stdcall;
  external kernel32 name 'HeapFree';
function ReadFile(hFile: THandle; var Buffer; Count: LongWord; var BytesRead: LongWord; lpOverlapped: Pointer): LongBool; stdcall;
  external kernel32 name 'ReadFile';
function SetConsoleCP(CodePage: Cardinal): LongBool; stdcall;
  external kernel32 name 'SetConsoleCP';
function SetConsoleCursorInfo(hConsoleOutput: THandle; const Info: TConsoleCursorInfo): LongBool; stdcall;
  external kernel32 name 'SetConsoleCursorInfo';
function SetConsoleCursorPosition(hConsoleOutput: THandle; Pos: TCoord): LongBool; stdcall;
  external kernel32 name 'SetConsoleCursorPosition';
function SetConsoleOutputCP(CodePage: Cardinal): LongBool; stdcall;
  external kernel32 name 'SetConsoleOutputCP';
function SetConsoleScreenBufferSize(hConsoleOutput: THandle; Size: TCoord): LongBool; stdcall;
  external kernel32 name 'SetConsoleScreenBufferSize';
function SetConsoleTextAttribute(hConsoleOutput: THandle; Attr: Word): LongBool; stdcall;
  external kernel32 name 'SetConsoleTextAttribute';
function SetConsoleTitle(Title: PAnsiChar): LongBool; stdcall;
  external kernel32 name 'SetConsoleTitleA';
function SetConsoleWindowInfo(hConsoleOutput: THandle; Abs: LongBool; const Window: TSmallRect): LongBool; stdcall;
  external kernel32 name 'SetConsoleWindowInfo';
function SetCurrentDirectory(Path: PAnsiChar): LongBool; stdcall;
  external kernel32 name 'SetCurrentDirectoryA';
function SetFilePointerEx(hFile: THandle; Distance: Int64; NewFilePtr: PUInt64; Method: LongWord): LongBool; stdcall;
  external kernel32 name 'SetFilePointerEx';
procedure Sleep(Milliseconds: LongWord); stdcall;
  external kernel32 name 'Sleep';
function WriteFile(hFile: THandle; const Buffer; Count: LongWord; var BytesWritten: LongWord; Overlapped: Pointer): LongBool; stdcall;
  external kernel32 name 'WriteFile';

procedure MessageBox(Wnd: HWnd; Text, Caption: PAnsiChar; Flags: Cardinal); stdcall;
  external user32 name 'MessageBoxA';

function cgets_s(Buffer: PAnsiChar; Count: Cardinal; var Read: Cardinal): PAnsiChar; cdecl;
  external msvcrt name '_cgets_s';
function cputs(Str: PAnsiChar): Integer; cdecl;
  external msvcrt name '_cputs';
function getch: AnsiChar; cdecl;
  external msvcrt name '_getch';
function gets: PAnsiChar; cdecl;
  external msvcrt name 'gets';
function kbhit: Integer; cdecl;
  external msvcrt name '_kbhit';
function cprintf(Fmt: PAnsiChar): Integer; cdecl varargs;
  external msvcrt name '_cprintf';
