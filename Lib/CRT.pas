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

  TKey = record
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

procedure Read(var Result: KolibriChar); overload;
procedure Read(var Result: TKey); overload;
procedure ReadLn(var Result: ShortString); 

function CursorBig: Integer;
function CursorHeight: Integer; overload;
function CursorHeight(Height: Integer): Integer; overload;
function CursorOff: Integer;
function CursorOn: Integer;

function KeyPressed: Boolean;
function ReadKey: KolibriChar;

function FontHeight: Integer;

procedure Delay(Milliseconds: LongWord);

implementation

uses
  SysUtils;

var
  ConsoleInterface: TConsoleInterface;
  CloseWindow: Boolean;

procedure InitConsole(Title: PKolibriChar; CloseWindowOnExit: Boolean;
  WndWidth, WndHeight, ScrWidth, ScrHeight: LongWord);
var
  hConsole: Pointer;
begin
  hConsole := LoadLibrary('/sys/lib/console.obj');
  with ConsoleInterface do
  begin
    Cls := GetProcAddress(hConsole, 'con_cls');
    ConsoleExit := GetProcAddress(hConsole, 'con_exit');
    ConsoleInit := GetProcAddress(hConsole, 'con_init');
    GetCh := GetProcAddress(hConsole, 'con_getch');
    GetCh2 := GetProcAddress(hConsole, 'con_getch2');
    GetCursorPos := GetProcAddress(hConsole, 'con_get_cursor_pos');
    GetCursorHeight := GetProcAddress(hConsole, 'con_get_cursor_height');
    GetFlags := GetProcAddress(hConsole, 'con_get_flags');
    GetFontHeight := GetProcAddress(hConsole, 'con_get_font_height');
    GetS := GetProcAddress(hConsole, 'con_gets');
    KbdHit := GetProcAddress(hConsole, 'con_kbhit');
    PrintF := GetProcAddress(hConsole, 'con_printf');
    SetCursorHeight := GetProcAddress(hConsole, 'con_set_cursor_height');
    SetCursorPos := GetProcAddress(hConsole, 'con_set_cursor_pos');
    SetFlags := GetProcAddress(hConsole, 'con_set_flags');
    SetTitle := GetProcAddress(hConsole, 'con_set_title');
    WriteASCIIZ := GetProcAddress(hConsole, 'con_write_asciiz');
    WriteString := GetProcAddress(hConsole, 'con_write_string');

    ConsoleInit(WndWidth, WndHeight, ScrWidth, ScrHeight, Title);
  end;
  CloseWindow := CloseWindowOnExit;
end;

procedure SetTitle(Title: PKolibriChar);
begin
  ConsoleInterface.SetTitle(Title);
end;

function NormVideo: LongWord;
begin
  with ConsoleInterface do
    Result := SetFlags(GetFlags and $300 or $07);
end;

function TextAttr: Byte;
begin
  Result := ConsoleInterface.GetFlags and $FF;
end;

function TextAttr(Attr: Byte): LongWord;
begin
  with ConsoleInterface do
    Result := SetFlags(GetFlags and $300 or Attr);
end;

function TextAttr(Color, Background: Byte): LongWord;
begin
  with ConsoleInterface do
    Result := SetFlags(GetFlags and $300 or Color and $0F or Background and $0F shl 4);
end;

function TextBackground: Byte;
begin
  Result := ConsoleInterface.GetFlags and $F0 shr 4;
end;

function TextBackground(Color: Byte): LongWord;
begin
  with ConsoleInterface do
    Result := SetFlags(GetFlags and $30F or Color and $0F shl 4);
end;

function TextColor: Byte;
begin
  Result := ConsoleInterface.GetFlags and $0F;
end;

function TextColor(Color: Byte): LongWord;
begin
  with ConsoleInterface do
    Result := SetFlags(GetFlags and $3F0 or Color and $0F);
end;

procedure GotoXY(X, Y: Integer);
begin
  ConsoleInterface.SetCursorPos(X, Y);
end;

procedure GotoXY(const Point: TCursorXY);
begin
  with Point do
    ConsoleInterface.SetCursorPos(X, Y);
end;

function WhereX: Integer;
var
  Y: Integer;
begin
  ConsoleInterface.GetCursorPos(Result, Y);
end;

function WhereY: Integer;
var
  X: Integer;
begin
  ConsoleInterface.GetCursorPos(X, Result);
end;

function WhereXY: TCursorXY;
begin
  ConsoleInterface.GetCursorPos(Result.X, Result.Y);
end;

function CursorBig: Integer;
begin
  Result := ConsoleInterface.SetCursorHeight(15);
end;

function CursorHeight: Integer;
begin
  Result := ConsoleInterface.GetCursorHeight;
end;

function CursorHeight(Height: Integer): Integer;
begin
  Result := ConsoleInterface.SetCursorHeight(Height);
end;

function CursorOff: Integer;
begin
  Result := ConsoleInterface.SetCursorHeight(0);
end;

function CursorOn: Integer;
begin
  Result := ConsoleInterface.SetCursorHeight(2);
end;

procedure ClrScr;
begin
  ConsoleInterface.Cls;
end;

procedure Write(Str: PKolibriChar);
begin
  ConsoleInterface.WriteASCIIZ(Str);
end;

procedure Write(Str: PKolibriChar; Length: LongWord);
begin
  ConsoleInterface.WriteString(Str, Length);
end;

procedure Write(const Str: ShortString);
begin
  ConsoleInterface.WriteString(@Str[1], Length(Str));
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
        CALL ConsoleInterface.PrintF

        MOV ESP, EBX
        POP EBX
end;

procedure WriteLn(LineBreaks: Integer);
var
  I: Integer;
begin
  for I := 0 to LineBreaks - 1 do
    ConsoleInterface.WriteString(#10, 1);
end;

procedure WriteLn(Str: PKolibriChar; LineBreaks: Integer);
begin
  ConsoleInterface.WriteASCIIZ(Str);
  WriteLn(LineBreaks);
end;

procedure WriteLn(Str: PKolibriChar; Length: LongWord; LineBreaks: Integer);
begin
  ConsoleInterface.WriteString(Str, Length);
  WriteLn(LineBreaks);
end;

procedure WriteLn(const Str: ShortString; LineBreaks: Integer);
begin
  ConsoleInterface.WriteString(@Str[1], Length(Str));
  WriteLn(LineBreaks);
end;

function WriteLn(Format: PKolibriChar; const Args: array of const; LineBreaks: Integer = 1): Integer;
begin
  Result := Write(Format, Args);
  WriteLn(LineBreaks);
end;

procedure Read(var Result: KolibriChar);
begin
  Result := Chr(ConsoleInterface.GetCh);
end;

procedure Read(var Result: TKey);
var
  K: Word;
begin
  K := ConsoleInterface.GetCh2;
  with WordRec(K), Result do
  begin
    CharCode := Chr(Lo);
    ScanCode := Chr(Hi);
  end;
end;

procedure ReadLn(var Result: ShortString);
var
  P, Limit: PKolibriChar;
begin
  P := PKolibriChar(@Result[1]);
  ConsoleInterface.GetS(P, High(Byte));
  Limit := P + High(Byte);
  while (P < Limit) and not (P^ in [#0, #10]) do
    Inc(P);
  PByte(@Result)^ := P - PKolibriChar(@Result[1]);
end;

function KeyPressed: Boolean;
begin
  Result := ConsoleInterface.KbdHit;
end;

function ReadKey: KolibriChar;
begin
  Result := Chr(ConsoleInterface.GetCh);
end;

function FontHeight: Integer;
begin
  Result := ConsoleInterface.GetFontHeight;
end;

procedure Delay(Milliseconds: LongWord);
begin
  Sleep((Milliseconds + 10 div 2) div 10);
end;

initialization

finalization
  with ConsoleInterface do
    if Assigned(ConsoleExit) then
      ConsoleExit(CloseWindow);

end.
