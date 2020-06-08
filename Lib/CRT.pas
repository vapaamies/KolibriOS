(*
    KolibriOS CRT unit
*)

unit CRT;

interface

uses
  KolibriOS;

type
  TCursorXY = record
    X, Y: Integer;
  end;

const
  Black         = 0;
  Blue          = 1;
  Green         = 2;
  Cyan          = 3;
  Red           = 4;
  Magenta       = 5;
  Brown         = 6;
  LightGray     = 7;
  DarkGray      = 8; 
  LightBlue     = 9;
  LightGreen    = 10;
  LightCyan     = 11;
  LightRed      = 12;
  LightMagenta  = 13;
  Yellow        = 14;
  White         = 15;

procedure InitConsole(Caption: PKolibriChar; CloseWindowOnExit: Boolean = True;
  WndWidth: LongWord = $FFFFFFFF; WndHeight: LongWord = $FFFFFFFF; ScrWidth: LongWord = $FFFFFFFF; ScrHeight: LongWord = $FFFFFFFF);

procedure GotoXY(X, Y: Integer); overload;
procedure GotoXY(const Point: TCursorXY); overload;
function WhereX: Integer;
function WhereY: Integer;
function WhereXY: TCursorXY;

function NormVideo: LongWord; // reset text attributes
function TextAttribute: Byte; overload;
function TextAttribute(Color, Background: Byte): LongWord; overload;
function TextBackground: Byte; overload;
function TextBackground(Color: Byte): LongWord; overload;
function TextColor: Byte; overload;
function TextColor(Color: Byte): LongWord; overload;

function WriteLn(LineBreaks: Integer = 1): LongInt; overload;
function WriteLn(Text: PKolibriChar; LineBreaks: Integer = 1): LongInt; overload;

function CursorBig: Integer;
function CursorHeight: Integer; overload;
function CursorHeight(Height: Integer): Integer; overload;
function CursorOff: Integer;
function CursorOn: Integer;

procedure Delay(Milliseconds: LongWord); // absolute Sleep(Milliseconds);

var
  ClrScr: procedure; stdcall;
  KeyPressed: function: Boolean;
  ReadKey: function: KolibriChar; stdcall;
  Write: function(const Text: PKolibriChar): LongInt; cdecl varargs;
  WriteText: procedure(Text: PKolibriChar; Length: LongWord); stdcall;

implementation

var
  CloseWindow: Boolean;

function WriteLn(LineBreaks: Integer): LongInt;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to LineBreaks - 1 do
    Inc(Result, Write(#10));
end;

function WriteLn(Text: PKolibriChar; LineBreaks: Integer): LongInt;
begin
  Result := Write(Text) + WriteLn(LineBreaks);
end;

procedure Delay(Milliseconds: LongWord);
begin
  Sleep(Milliseconds div 10);
end;

var
  hConsole: Pointer;
  ConsoleExit: procedure(CloseWindow: Boolean); stdcall;
  ConsoleInit: procedure(WndWidth, WndHeight, ScrWidth, ScrHeight: LongWord; Caption: PKolibriChar); stdcall;
  GetCursorHeight: function: Integer; stdcall;
  GetFlags: function: LongWord; stdcall;
  GotoXYProc: procedure(X, Y: Integer); stdcall;
  SetFlags: function(Flags: LongWord): LongWord; stdcall;
  SetCursorHeight: function(Height: Integer): Integer; stdcall;
  WhereXYProc: procedure(var X, Y: Integer); stdcall;

procedure InitConsole(Caption: PKolibriChar; CloseWindowOnExit: Boolean;
  WndWidth, WndHeight, ScrWidth, ScrHeight: LongWord);
begin
  hConsole := LoadLibrary('/sys/lib/console.obj');
  ClrScr := GetProcAddress(hConsole, 'con_cls');
  ConsoleExit := GetProcAddress(hConsole, 'con_exit');
  ConsoleInit := GetProcAddress(hConsole, 'con_init');
  GetCursorHeight := GetProcAddress(hConsole, 'con_get_cursor_height');
  GetFlags := GetProcAddress(hConsole, 'con_get_flags');
  GotoXYProc := GetProcAddress(hConsole, 'con_set_cursor_pos');
  KeyPressed := GetProcAddress(hConsole, 'con_kbhit');
  ReadKey := GetProcAddress(hConsole, 'con_getch');
  SetCursorHeight := GetProcAddress(hConsole, 'con_set_cursor_height');
  SetFlags := GetProcAddress(hConsole, 'con_set_flags');
  WhereXYProc := GetProcAddress(hConsole, 'con_get_cursor_pos');
  Write := GetProcAddress(hConsole, 'con_printf');
  WriteText := GetProcAddress(hConsole, 'con_write_string');

  ConsoleInit(WndWidth, WndHeight, ScrWidth, ScrHeight, Caption);
  CloseWindow := CloseWindowOnExit;
end;

function NormVideo: LongWord;
begin
  Result := SetFlags(GetFlags and $300 or $07);
end;

function TextAttribute: Byte;
begin
  Result := GetFlags and $FF;
end;

function TextAttribute(Color, Background: Byte): LongWord;
begin
  Result := SetFlags(GetFlags and $300 or Color and $0F or Background and $0F shl 4);
end;

function TextBackground: Byte;
begin
  Result := GetFlags and $F0 shr 4;
end;

function TextBackground(Color: Byte): LongWord;
begin
  Result := SetFlags(GetFlags and $30F or Color and $0F shl 4);
end;

function TextColor: Byte;
begin
  Result := GetFlags and $0F;
end;

function TextColor(Color: Byte): LongWord;
begin
  Result := SetFlags(GetFlags and $3F0 or Color and $0F);
end;

procedure GotoXY(X, Y: Integer);
begin
  GotoXYProc(X, Y);
end;

procedure GotoXY(const Point: TCursorXY);
begin
  with Point do
    GotoXYProc(X, Y);
end;

function WhereX: Integer;
begin
  Result := WhereXY.X;
end;

function WhereY: Integer;
begin
  Result := WhereXY.Y;
end;

function WhereXY: TCursorXY;
begin
  WhereXYProc(Result.X, Result.Y);
end;

function CursorBig: Integer;
begin
  Result := SetCursorHeight(15);
end;

function CursorHeight: Integer;
begin
  Result := GetCursorHeight;
end;

function CursorHeight(Height: Integer): Integer;
begin
  Result := SetCursorHeight(Height);
end;

function CursorOff: Integer;
begin
  Result := SetCursorHeight(0);
end;

function CursorOn: Integer;
begin
  Result := SetCursorHeight(2);
end;

initialization

finalization
  if hConsole <> nil then
    ConsoleExit(CloseWindow);

end.
