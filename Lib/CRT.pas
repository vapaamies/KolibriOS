unit CRT;

interface

uses
  KolibriOS;

type
  TConsolePoint = record
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

function GetCursorPos: TConsolePoint;
procedure SetCursorPos(X, Y: Integer); overload;
procedure SetCursorPos(const Point: TConsolePoint); overload;

procedure ResetAttributes;
procedure TextAttribute(Color, Background: Integer);
procedure TextBackground(Color: Integer);
procedure TextColor(Color: Integer);

function WriteLn(LineBreaks: Integer = 1): LongInt; overload;
function WriteLn(Text: PKolibriChar; LineBreaks: Integer = 1): LongInt; overload;

var
  KeyPressed: function: Boolean;
  ReadKey: function: KolibriChar; stdcall;
  SetCursorHeight: function(Height: Integer): Integer; stdcall;
  Write: function(const Text: PKolibriChar): LongInt; cdecl varargs;
  WriteText: procedure(Text: PKolibriChar; Length: LongWord); stdcall;

implementation

var
  CloseWindow: Boolean;

procedure ResetAttributes;
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

var
  hConsole: Pointer;
  ConsoleExit: procedure(CloseWindow: Boolean); stdcall;
  ConsoleInit: procedure(WndWidth, WndHeight, ScrWidth, ScrHeight: LongWord; Caption: PKolibriChar); stdcall;
  GetCursorPosProc: procedure(var X, Y: Integer); stdcall;
  SetCursorPosProc: procedure(X, Y: Integer); stdcall;

procedure InitConsole(Caption: PKolibriChar; CloseWindowOnExit: Boolean;
  WndWidth, WndHeight, ScrWidth, ScrHeight: LongWord);
begin
  hConsole := LoadLibrary('/sys/lib/console.obj');
  ConsoleExit := GetProcAddress(hConsole, 'con_exit');
  ConsoleInit := GetProcAddress(hConsole, 'con_init');
  GetCursorPosProc := GetProcAddress(hConsole, 'con_get_cursor_pos');
  KeyPressed := GetProcAddress(hConsole, 'con_kbhit');
  ReadKey := GetProcAddress(hConsole, 'con_getch');
  SetCursorHeight := GetProcAddress(hConsole, 'con_set_cursor_height');
  SetCursorPosProc := GetProcAddress(hConsole, 'con_set_cursor_pos');
  Write := GetProcAddress(hConsole, 'con_printf');
  WriteText := GetProcAddress(hConsole, 'con_write_string');

  ConsoleInit(WndWidth, WndHeight, ScrWidth, ScrHeight, Caption);
  CloseWindow := CloseWindowOnExit;
end;

function GetCursorPos: TConsolePoint;
begin
  GetCursorPosProc(Result.X, Result.Y);
end;

procedure SetCursorPos(X, Y: Integer);
begin
  SetCursorPosProc(X, Y);
end;

procedure SetCursorPos(const Point: TConsolePoint);
begin
  with Point do
    SetCursorPosProc(X, Y);
end;

initialization

finalization
  if hConsole <> nil then
    ConsoleExit(CloseWindow);

end.
