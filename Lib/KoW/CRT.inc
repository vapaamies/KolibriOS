(*
    KolibriOS on Windows (KoW) CRT unit

    Copyright (c) 2021 Delphi SDK for KolibriOS team
*)

var
  // Console.obj defaults
  ScrSize: TCoord = (X: 80; Y: 300);
  WndPos: TPoint = (X: 200; Y: 50);
  WndSize: TPoint = (X: 80; Y: 25);

  SaveInputCP, SaveOutputCP: Word;

procedure con_set_cursor_pos(X, Y: Integer); stdcall; forward; // call local proc from con_cls

procedure con_cls; stdcall;
var
  Info: TConsoleScreenBufferInfo;
  Point: TCoord;
  Written: LongWord;
begin
  if GetConsoleScreenBufferInfo(TTextRec(Output).Handle, Info) then
  begin
    Point.X := 0;
    Point.Y := 0;
    with Info.dwSize do
      FillConsoleOutputCharacter(TTextRec(Output).Handle, ' ', X * Y, Point, Written);
  end;
  con_set_cursor_pos(0, 0);
end;

procedure con_exit(CloseWindow: Boolean); stdcall;
begin
  if not CloseWindow then
  begin
    CursorOff;
    getch;
  end;

  SetConsoleCP(SaveInputCP);
  SetConsoleOutputCP(SaveOutputCP);

  TTextRec(Input).Handle := 0;
  TTextRec(Output).Handle := 0;
end;

procedure con_init(WndWidth, WndHeight, ScrWidth, ScrHeight: LongWord; Title: PKolibriChar); stdcall;
{$IFDEF Debug}
var
  Font: TConsoleFontInfo;
  R: TSmallRect;
{$ENDIF}
begin
{$IFDEF Debug}
  if not IsConsole then
    AllocConsole;
{$ENDIF}

  TTextRec(Input).Handle := GetStdHandle(STD_INPUT_HANDLE);
  TTextRec(Output).Handle := GetStdHandle(STD_OUTPUT_HANDLE);

{$IFDEF Debug}
  SaveInputCP := GetConsoleCP;
  SetConsoleCP(CP_KOLIBRIOS);
  SaveOutputCP := GetConsoleOutputCP;
  SetConsoleOutputCP(CP_KOLIBRIOS);

  SetConsoleTitle(Title);

  if WndWidth <> LongWord(-1) then
    WndSize.X := WndWidth;
  if WndHeight <> LongWord(-1) then
    WndSize.Y := WndHeight;

  MainWindow := GetConsoleWindow;
  GetCurrentConsoleFont(TTextRec(Output).Handle, False, Font);
{  SetWindowPos(MainWindow, 0, WndPos.X, WndPos.Y,
    Font.Size.X * WndSize.X + GetSystemMetrics(SM_CXVSCROLL), Font.Size.Y * WndSize.Y + GetSystemMetrics(SM_CYHSCROLL), 0);}

  if ScrWidth <> LongWord(-1) then
    ScrSize.X := ScrWidth;
  if ScrHeight <> LongWord(-1) then
    ScrSize.Y := ScrHeight;
  SetConsoleScreenBufferSize(TTextRec(Output).Handle, ScrSize);

  with R do
  begin
    Left := 0;
    Top := 0;
    Right := ScrSize.X - 1;
    Bottom := ScrSize.Y - 1;
  end;
  SetConsoleWindowInfo(TTextRec(Output).Handle, True, R);
{$ENDIF}
end;

function con_get_cursor_height: Integer; stdcall;
var
  Info: TConsoleCursorInfo;
begin
  GetConsoleCursorInfo(TTextRec(Output).Handle, Info);
  Result := Info.dwSize;
end;

procedure con_get_cursor_pos(var X, Y: Integer); stdcall;
var
  Info: TConsoleScreenBufferInfo;
begin
  GetConsoleScreenBufferInfo(TTextRec(Output).Handle, Info);
  with Info do
  begin
    X := dwCursorPosition.X;
    Y := dwCursorPosition.Y;
  end;
end;

function con_get_flags: LongWord; stdcall
var
  Info: TConsoleScreenBufferInfo;
begin
  GetConsoleScreenBufferInfo(TTextRec(Output).Handle, Info);
  Result := Info.wAttributes;
end;

function con_get_font_height: Integer; stdcall;
var
  Font: TConsoleFontInfo;
begin
  GetCurrentConsoleFont(TTextRec(Output).Handle, False, Font);
  Result := Font.dwFontSize.Y;
end;

function con_getch: KolibriChar; stdcall;
begin
  Result := getch;
end;

function con_gets(Str: PKolibriChar; Length: Integer): PKolibriChar; stdcall;
var
  LF: KolibriChar;
  Read: Cardinal;
begin
  cgets_s(Str, Length, Read);
  cgets_s(@LF, SizeOf(LF), Read);
  Result := Str;
end;

function con_gets2(Callback: con_gets2_callback; Str: PKolibriChar; Length: Integer): PKolibriChar; stdcall;
begin
  Result := con_gets(Str, Length);
end;

function con_kbhit: Boolean; stdcall;
begin
  Result := kbhit <> 0;
end;

function con_set_cursor_height(Height: Integer): Integer; stdcall;
var
  Info: TConsoleCursorInfo;
begin
  GetConsoleCursorInfo(TTextRec(Output).Handle, Info);
  Result := Info.dwSize;
  if Height <> 0 then
    Info.dwSize := Height;
  Info.bVisible := Height <> 0;
  SetConsoleCursorInfo (TTextRec(Output).Handle, Info);
end;

procedure con_set_cursor_pos(X, Y: Integer); stdcall;
var
  Coord: TCoord;
begin
  Coord.X := X;
  Coord.Y := Y;
  SetConsoleCursorPosition(TTextRec(Output).Handle, Coord);
end;

function con_set_flags(Flags: LongWord): LongWord; stdcall;
begin
  Result := con_get_flags;
  SetConsoleTextAttribute(TTextRec(Output).Handle, Flags and $FF);
end;

procedure con_write_string(Str: PKolibriChar; Length: LongWord); stdcall;
var
  Written: LongWord;
begin
  WriteFile(TTextRec(Output).Handle, Str^, Length, Written, nil);
end;

procedure con_write_asciiz(Str: PKolibriChar); stdcall;
begin
  cputs(Str);
end;

procedure Delay(Milliseconds: LongWord);
begin
  Sleep(Milliseconds);
end;

procedure InitKoW;
begin
  Pointer(@System.con_cls) := @con_cls;
  Pointer(@System.con_exit) := @con_exit;
  Pointer(@System.con_init) := @con_init;
  Pointer(@System.con_getch) := @con_getch;
  Pointer(@System.con_get_flags) := @con_get_flags;
  Pointer(@System.con_get_cursor_height) := @con_get_cursor_height;
  Pointer(@System.con_get_cursor_pos) := @con_get_cursor_pos;
  Pointer(@System.con_get_font_height) := @con_get_font_height;
  Pointer(@System.con_gets) := @con_gets;
  Pointer(@System.con_gets2) := @con_gets2;
  Pointer(@System.con_kbhit) := @con_kbhit;
  Pointer(@System.con_printf) := @cprintf;
  Pointer(@System.con_set_cursor_height) := @con_set_cursor_height;
  Pointer(@System.con_set_cursor_pos) := @con_set_cursor_pos;
  Pointer(@System.con_set_flags) := @con_set_flags;
  Pointer(@System.con_set_title) := @SetConsoleTitle;
  Pointer(@System.con_write_asciiz) := @con_write_asciiz;
  Pointer(@System.con_write_string) := @con_write_string;
end;
