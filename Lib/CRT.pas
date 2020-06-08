(*
    KolibriOS CRT unit
*)

unit CRT;

interface

uses
  KolibriOS;

type
  TCursorXY = record
    X, Y: LongWord;
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

procedure NormVideo; // reset text attributes
procedure TextAttribute(Color, Background: Integer);
procedure TextBackground(Color: Integer);
procedure TextColor(Color: Integer);

function WriteLn(LineBreaks: Integer = 1): LongInt; overload;
function WriteLn(Text: PKolibriChar; LineBreaks: Integer = 1): LongInt; overload;

function CursorBig: LongWord;
function CursorOff: LongWord;
function CursorOn: LongWord;

procedure Delay(Milliseconds: LongWord); // absolute Sleep(Milliseconds);

var
  CursorHeight: function(Height: LongWord): LongWord; stdcall;
  KeyPressed: function: Boolean;
  ReadKey: function: KolibriChar; stdcall;
  Write: function(const Text: PKolibriChar): LongInt; cdecl varargs;
  WriteText: procedure(Text: PKolibriChar; Length: LongWord); stdcall;

implementation

var
  CloseWindow: Boolean;

procedure NormVideo;
begin
  Write(#27'[0m');
end;

procedure TextAttribute(Color, Background: Integer);
begin
  TextColor(Color);
  TextBackground(Background);
end;

procedure TextBackground(Color: Integer);
const
  Light = #27'[5m';
  Colors: array[Black..LightGray] of PKolibriChar = (
    #27'[40m', // Black
    #27'[44m', // Blue
    #27'[42m', // Green
    #27'[46m', // Cyan
    #27'[41m', // Red
    #27'[45m', // Magenta
    #27'[43m', // Brown
    #27'[47m'  // LightGray
  );
begin
  case Color of
    Black..LightGray:
      Write(Colors[Color]);
    DarkGray..White:
      begin
        Write(Colors[Color - 8]);
        Write(Light);
      end;
  end;
end;

procedure TextColor(Color: Integer);
const
  Light = #27'[1m';
  Colors: array[Black..LightGray] of PKolibriChar = (
    #27'[30m', // Black
    #27'[34m', // Blue
    #27'[32m', // Green
    #27'[36m', // Cyan
    #27'[31m', // Red
    #27'[35m', // Magenta
    #27'[33m', // Brown
    #27'[37m'  // LightGray
  );
begin
  case Color of
    Black..LightGray:
      Write(Colors[Color]);
    DarkGray..White:
      begin
        Write(Colors[Color - 8]);
        Write(Light);
      end;
  end;
end;

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
  GotoXYProc: procedure(X, Y: LongWord); stdcall;
  WhereXYProc: procedure(var X, Y: LongWord); stdcall;

procedure InitConsole(Caption: PKolibriChar; CloseWindowOnExit: Boolean;
  WndWidth, WndHeight, ScrWidth, ScrHeight: LongWord);
begin
  hConsole := LoadLibrary('/sys/lib/console.obj');
  ConsoleExit := GetProcAddress(hConsole, 'con_exit');
  ConsoleInit := GetProcAddress(hConsole, 'con_init');
  CursorHeight := GetProcAddress(hConsole, 'con_set_cursor_height');
  KeyPressed := GetProcAddress(hConsole, 'con_kbhit');
  ReadKey := GetProcAddress(hConsole, 'con_getch');
  GotoXYProc := GetProcAddress(hConsole, 'con_set_cursor_pos');
  WhereXYProc := GetProcAddress(hConsole, 'con_get_cursor_pos');
  Write := GetProcAddress(hConsole, 'con_printf');
  WriteText := GetProcAddress(hConsole, 'con_write_string');

  ConsoleInit(WndWidth, WndHeight, ScrWidth, ScrHeight, Caption);
  CloseWindow := CloseWindowOnExit;
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

function CursorBig: LongWord;
begin
  Result := CursorHeight(15);
end;

function CursorOff: LongWord;
begin
  Result := CursorHeight(0);
end;

function CursorOn: LongWord;
begin
  Result := CursorHeight(2);
end;

initialization

finalization
  if hConsole <> nil then
    ConsoleExit(CloseWindow);

end.
