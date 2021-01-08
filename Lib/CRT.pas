(*
    KolibriOS CRT unit

    Copyright (c) 2020-2021 Delphi SDK for KolibriOS team
*)

unit CRT;

interface

type
  TCursorXY = record
    X, Y: Integer;
  end;

  TKey = packed record
    CharCode, ScanCode: KolibriChar;
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

procedure InitConsole(Title: PKolibriChar; CloseWindowOnExit: Boolean = False;
  WndWidth: LongWord = $FFFFFFFF; WndHeight: LongWord = $FFFFFFFF; ScrWidth: LongWord = $FFFFFFFF; ScrHeight: LongWord = $FFFFFFFF);
procedure SetTitle(Title: PKolibriChar);

procedure GotoXY(X, Y: Integer); overload;
procedure GotoXY(const Point: TCursorXY); overload;
function WhereX: Integer;
function WhereY: Integer;
function WhereXY: TCursorXY;

function NormVideo: LongWord; // reset text attributes
function TextAttr: Byte; overload;
function TextAttr(Attr: Byte): LongWord; overload;
function TextAttr(Color, Background: Byte): LongWord; overload;
function TextBackground: Byte; overload;
function TextBackground(Color: Byte): LongWord; overload;
function TextColor: Byte; overload;
function TextColor(Color: Byte): LongWord; overload;

procedure ClrEOL;
procedure ClrScr;

function CursorBig: Integer;
function CursorHeight: Integer; overload;
function CursorHeight(Height: Integer): Integer; overload;
function CursorOff: Integer;
function CursorOn: Integer;

function KeyPressed: Boolean;
function ReadKey: KolibriChar;
function ReadKeyEx: TKey;

function FontHeight: Integer;

procedure Delay(Milliseconds: LongWord);

implementation

uses
{$IFDEF KolibriOS}
  KolibriOS;
{$ELSE}
  Windows;
{$ENDIF}

var
  ClrEOLWidth: Integer = 80;
  CloseWindow: Boolean;

procedure InitConsole(Title: PKolibriChar; CloseWindowOnExit: Boolean;
  WndWidth, WndHeight, ScrWidth, ScrHeight: LongWord);
begin
  CloseWindow := CloseWindowOnExit;
  con_init(WndWidth, WndHeight, ScrWidth, ScrHeight, Title);
  if ScrWidth <> LongWord(-1) then
    ClrEOLWidth := ScrWidth;
end;

procedure SetTitle(Title: PKolibriChar);
begin
  con_set_title(Title);
end;

function NormVideo: LongWord;
begin
  Result := con_set_flags(con_get_flags and $300 or $07);
end;

function TextAttr: Byte;
begin
  Result := con_get_flags and $FF;
end;

function TextAttr(Attr: Byte): LongWord;
begin
  Result := con_set_flags(con_get_flags and $300 or Attr);
end;

function TextAttr(Color, Background: Byte): LongWord;
begin
  Result := con_set_flags(con_get_flags and $300 or Color and $0F or Background and $0F shl 4);
end;

function TextBackground: Byte;
begin
  Result := con_get_flags and $F0 shr 4;
end;

function TextBackground(Color: Byte): LongWord;
begin
  Result := con_set_flags(con_get_flags and $30F or Color and $0F shl 4);
end;

function TextColor: Byte;
begin
  Result := con_get_flags and $0F;
end;

function TextColor(Color: Byte): LongWord;
begin
  Result := con_set_flags(con_get_flags and $3F0 or Color and $0F);
end;

procedure GotoXY(X, Y: Integer);
begin
  con_set_cursor_pos(X - 1, Y - 1);
end;

procedure GotoXY(const Point: TCursorXY);
begin
  con_set_cursor_pos(Point.X - 1, Point.Y - 1);
end;

function WhereX: Integer;
var
  Y: Integer;
begin
  con_get_cursor_pos(Result, Y);
  Inc(Result);
end;

function WhereY: Integer;
var
  X: Integer;
begin
  con_get_cursor_pos(X, Result);
  Inc(Result);
end;

function WhereXY: TCursorXY;
begin
  with Result do
  begin
    con_get_cursor_pos(X, Y);
    Inc(X);
    Inc(Y);
  end;
end;

function CursorBig: Integer;
begin
  Result := con_set_cursor_height(15);
end;

function CursorHeight: Integer;
begin
  Result := con_get_cursor_height;
end;

function CursorHeight(Height: Integer): Integer;
begin
  Result := con_set_cursor_height(Height);
end;

function CursorOff: Integer;
begin
  Result := con_set_cursor_height(0);
end;

function CursorOn: Integer;
begin
  Result := con_set_cursor_height(2);
end;

procedure ClrEOL;
var
  I, X, Y, Count: Integer;
  Buf: array[0..127] of KolibriChar;
begin
  con_get_cursor_pos(X, Y);
  Count := ClrEOLWidth - X - 1;
  if Count <> 0 then
  begin
    FillChar(Buf, SizeOf(Buf), ' ');
    for I := 0 to Count div Length(Buf) - 1 do
      con_write_string(Buf, Length(Buf));
    con_write_string(Buf, Count mod Length(Buf));
  end;
end;

procedure ClrScr;
begin
  con_cls;
end;

function KeyPressed: Boolean;
begin
  Result := con_kbhit;
end;

function ReadKey: KolibriChar;
begin
  Result := Chr(con_getch);
end;

function ReadKeyEx: TKey;
begin
  Word(Result) := con_getch2;
end;

function FontHeight: Integer;
begin
  Result := con_get_font_height;
end;

{$IFDEF KolibriOS}
procedure Delay(Milliseconds: LongWord);
begin
  Sleep((Milliseconds + 10 div 2) div 10);
end;

var
  hConsole: Pointer;
{$ELSE}
  {$I KoW\CRT.inc}
{$ENDIF}

initialization
{$IFDEF KolibriOS}
  hConsole := LoadLibrary('/sys/lib/console.obj');

  Pointer(@con_cls) := GetProcAddress(hConsole, 'con_cls');
  Pointer(@con_exit) := GetProcAddress(hConsole, 'con_exit');
  Pointer(@con_get_cursor_pos) := GetProcAddress(hConsole, 'con_get_cursor_pos');
  Pointer(@con_get_cursor_height) := GetProcAddress(hConsole, 'con_get_cursor_height');
  Pointer(@con_get_flags) := GetProcAddress(hConsole, 'con_get_flags');
  Pointer(@con_get_font_height) := GetProcAddress(hConsole, 'con_get_font_height');
  Pointer(@con_getch) := GetProcAddress(hConsole, 'con_getch');
  Pointer(@con_getch2) := GetProcAddress(hConsole, 'con_getch2');
  Pointer(@con_gets) := GetProcAddress(hConsole, 'con_gets');
  Pointer(@con_init) := GetProcAddress(hConsole, 'con_init');
  Pointer(@con_kbhit) := GetProcAddress(hConsole, 'con_kbhit');
  Pointer(@con_printf) := GetProcAddress(hConsole, 'con_printf');
  Pointer(@con_set_cursor_height) := GetProcAddress(hConsole, 'con_set_cursor_height');
  Pointer(@con_set_cursor_pos) := GetProcAddress(hConsole, 'con_set_cursor_pos');
  Pointer(@con_set_flags) := GetProcAddress(hConsole, 'con_set_flags');
  Pointer(@con_set_title) := GetProcAddress(hConsole, 'con_set_title');
  Pointer(@con_write_asciiz) := GetProcAddress(hConsole, 'con_write_asciiz');
  Pointer(@con_write_string) := GetProcAddress(hConsole, 'con_write_string');
{$ELSE}
  InitKoW;
{$ENDIF}

{$IF defined(KolibriOS) or defined(Debug)}
  if IsConsole then
    InitConsole(AppPath);

finalization
  if Assigned(System.con_exit) then
    con_exit(CloseWindow);
{$IFEND}

end.
