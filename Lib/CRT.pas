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

procedure ClrScr;

procedure Write(Str: PKolibriChar); overload;
procedure Write(Str: PKolibriChar; Length: LongWord); overload;
procedure Write(const Str: ShortString); overload;
function Write(Format: PKolibriChar; const Args: array of const): Integer; overload;

procedure WriteLn(LineBreaks: Integer = 1); overload;
procedure WriteLn(Str: PKolibriChar; LineBreaks: Integer = 1); overload;
procedure WriteLn(Str: PKolibriChar; Length: LongWord; LineBreaks: Integer = 1); overload;
procedure WriteLn(const Str: ShortString; LineBreaks: Integer = 1); overload;
function WriteLn(Format: PKolibriChar; const Args: array of const; LineBreaks: Integer = 1): Integer; overload;

function CursorBig: Integer;
function CursorHeight: Integer; overload;
function CursorHeight(Height: Integer): Integer; overload;
function CursorOff: Integer;
function CursorOn: Integer;

function KeyPressed: Boolean;
function ReadKey: KolibriChar;

function FontHeight: Integer;

procedure Delay(Milliseconds: LongWord); // absolute Sleep(Milliseconds);

implementation

var
  CloseWindow: Boolean;

  hConsole: Pointer;
  ClrScrProc: procedure; stdcall;
  ConsoleExit: procedure(CloseWindow: Boolean); stdcall;
  ConsoleInit: procedure(WndWidth, WndHeight, ScrWidth, ScrHeight: LongWord; Caption: PKolibriChar); stdcall;
  GetCursorHeight: function: Integer; stdcall;
  GetFlags: function: LongWord; stdcall;
  GetFontHeight: function: Integer; stdcall;
  GotoXYProc: procedure(X, Y: Integer); stdcall;
  KeyPressedFunc: function: Boolean;
  PrintF: function(const Str: PKolibriChar): Integer; cdecl varargs;
  ReadKeyFunc: function: KolibriChar; stdcall;
  SetFlags: function(Flags: LongWord): LongWord; stdcall;
  SetCursorHeight: function(Height: Integer): Integer; stdcall;
  WhereXYProc: procedure(var X, Y: Integer); stdcall;
  WritePChar: procedure(Str: PKolibriChar); stdcall;
  WritePCharLen: procedure(Str: PKolibriChar; Length: LongWord); stdcall;

procedure InitConsole(Caption: PKolibriChar; CloseWindowOnExit: Boolean;
  WndWidth, WndHeight, ScrWidth, ScrHeight: LongWord);
begin
  hConsole := LoadLibrary('/sys/lib/console.obj');
  ClrScrProc := GetProcAddress(hConsole, 'con_cls');
  ConsoleExit := GetProcAddress(hConsole, 'con_exit');
  ConsoleInit := GetProcAddress(hConsole, 'con_init');
  GetCursorHeight := GetProcAddress(hConsole, 'con_get_cursor_height');
  GetFlags := GetProcAddress(hConsole, 'con_get_flags');
  GetFontHeight := GetProcAddress(hConsole, 'con_get_font_height');
  GotoXYProc := GetProcAddress(hConsole, 'con_set_cursor_pos');
  KeyPressedFunc := GetProcAddress(hConsole, 'con_kbhit');
  PrintF := GetProcAddress(hConsole, 'con_printf');
  ReadKeyFunc := GetProcAddress(hConsole, 'con_getch');
  SetCursorHeight := GetProcAddress(hConsole, 'con_set_cursor_height');
  SetFlags := GetProcAddress(hConsole, 'con_set_flags');
  WhereXYProc := GetProcAddress(hConsole, 'con_get_cursor_pos');
  WritePChar := GetProcAddress(hConsole, 'con_write_asciiz');
  WritePCharLen := GetProcAddress(hConsole, 'con_write_string');

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

procedure ClrScr;
begin
  ClrScrProc;
end;

procedure Write(Str: PKolibriChar);
begin
  WritePChar(Str);
end;

procedure Write(Str: PKolibriChar; Length: LongWord);
begin
  WritePCharLen(Str, Length);
end;

procedure Write(const Str: ShortString);
begin
  WritePCharLen(@Str[1], Length(Str));
end;

function Write(Format: PKolibriChar; const Args: array of const): Integer;
const
  VarArgSize = SizeOf(TVarRec);
asm
        PUSH EBX
        MOV EBX, ESP

        INC ECX
        JZ @@call
@@arg:
        PUSH dword [EDX + ECX * VarArgSize - VarArgSize]
        LOOP @@arg
@@call:
        PUSH EAX
        CALL PrintF

        MOV ESP, EBX
        POP EBX
end;

procedure WriteLn(LineBreaks: Integer);
var
  I: Integer;
begin
  for I := 0 to LineBreaks - 1 do
    WritePCharLen(#10, 1);
end;

procedure WriteLn(Str: PKolibriChar; LineBreaks: Integer);
begin
  WritePChar(Str);
  WriteLn(LineBreaks);
end;

procedure WriteLn(Str: PKolibriChar; Length: LongWord; LineBreaks: Integer);
begin
  WritePCharLen(Str, Length);
  WriteLn(LineBreaks);
end;

procedure WriteLn(const Str: ShortString; LineBreaks: Integer);
begin
  WritePCharLen(@Str[1], Length(Str));
  WriteLn(LineBreaks);
end;

function WriteLn(Format: PKolibriChar; const Args: array of const; LineBreaks: Integer = 1): Integer;
begin
  Result := Write(Format, Args);
  WriteLn(LineBreaks);
end;

function KeyPressed: Boolean;
begin
  Result := KeyPressedFunc;
end;

function ReadKey: KolibriChar;
begin
  Result := ReadKeyFunc;
end;

function FontHeight: Integer;
begin
  Result := GetFontHeight;
end;

procedure Delay(Milliseconds: LongWord);
begin
  Sleep(Milliseconds div 10);
end;

initialization

finalization
  if hConsole <> nil then
    ConsoleExit(CloseWindow);

end.
