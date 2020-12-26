(*
    KolibriOS RTL System unit
*)

unit System;

interface

const
  RTLVersion = CompilerVersion;
  UnicodeCompiler = CompilerVersion >= 20;
  
type
  PPAnsiChar    = ^PAnsiChar;

  KolibriChar   = AnsiChar;
  PKolibriChar  = PAnsiChar;
  PPKolibriChar = PPAnsiChar;

  KolibriString = AnsiString;

{$IF CompilerVersion < 15}
  UInt64 = Int64;
{$IFEND}

  THandle = LongWord;

  PByte = ^Byte;
  PWord = ^Word;
  PLongWord = ^LongWord;
  PLongInt = ^LongInt;
  PInt64 = ^Int64;
{$IF CompilerVersion >= 15}
  PUInt64 = ^UInt64;
{$IFEND}

  PCardinal = ^Cardinal;
  PInteger = ^Integer;

  PExtended = ^Extended;
  PCurrency = ^Currency;

  PShortString = ^ShortString;

  PVariant = ^Variant;

  TGUID = record
    D1: LongWord;
    D2: Word;
    D3: Word;
    D4: array [0..7] of Byte;
  end;

  PProcedure = procedure;

  TPackageUnitEntry = packed record
    Init, Finalize: PProcedure;
  end;

  PUnitEntryTable = ^TUnitEntryTable;
  TUnitEntryTable = array [0..99999999] of TPackageUnitEntry;

  PPackageInfo = ^TPackageInfo;
  TPackageInfo = packed record
    UnitCount: Integer;
    UnitInfo: PUnitEntryTable;
  end;

  PInitContext = ^TInitContext;
  TInitContext = record
    InitTable: PPackageInfo;
    InitCount: Integer;
    OuterContext: PInitContext;
  end;

const  
  vtInteger    = 0;
  vtBoolean    = 1;
  vtChar       = 2;
  vtExtended   = 3;
  vtString     = 4;
  vtPointer    = 5;
  vtPChar      = 6;
  vtObject     = 7;
  vtClass      = 8;
  vtWideChar   = 9;
  vtPWideChar  = 10;
  vtAnsiString = 11;
  vtCurrency   = 12;
  vtVariant    = 13;
  vtInterface  = 14;
  vtWideString = 15;
  vtInt64      = 16;
{$IFDEF UnicodeCompiler}
  vtUnicodeString = 17;
{$ENDIF}

type
  PVarRec = ^TVarRec;
  TVarRec = record
    case Byte of
      vtInteger:    (VInteger: Integer; VType: Byte);
      vtBoolean:    (VBoolean: Boolean);
      vtChar:       (VChar: KolibriChar);
      vtExtended:   (VExtended: PExtended);
      vtString:     (VString: PShortString);
      vtPointer:    (VPointer: Pointer);
      vtPChar:      (VPChar: PKolibriChar);
      vtObject:     (VObject: Pointer);
      vtClass:      (VClass: Pointer);
      vtWideChar:   (VWideChar: WideChar);
      vtPWideChar:  (VPWideChar: PWideChar);
      vtAnsiString: (VAnsiString: Pointer);
      vtCurrency:   (VCurrency: PCurrency);
      vtVariant:    (VVariant: PVariant);
      vtInterface:  (VInterface: Pointer);
      vtWideString: (VWideString: Pointer);
      vtInt64:      (VInt64: PInt64);
    {$IFDEF UnicodeCompiler}
      vtUnicodeString: (VUnicodeString: Pointer);
    {$ENDIF}    
  end;

  PTextBuf = ^TTextBuf;
  TTextBuf = array[0..127] of KolibriChar;

  TTextRec = packed record
    Handle: THandle;
    Mode, Flags: Word;
    BufSize, BufPos, BufEnd: Cardinal;
    BufPtr: PKolibriChar;
    OpenFunc, InOutFunc, FlushFunc, CloseFunc: Pointer;
    UserData: array[1..32] of Byte;
    Name: array[0..259] of Char;
    Buffer: TTextBuf;
  end;

procedure _Halt0;
procedure _HandleFinally;
procedure _StartExe(InitTable: PPackageInfo);

var
  Default8087CW: Word = $1332; // for Extended type

function Get8087CW: Word;
procedure Set8087CW(Value: Word);

var
  RandSeed: LongWord;
  RandCounter: LongWord;

function _RandInt(Range: LongWord): LongWord;
function _RandExt: Extended;
procedure Randomize;

function UpCase(Ch: KolibriChar): KolibriChar;

function _LStrLen(const S: KolibriString): LongInt;
function _LStrToPChar(const S: KolibriString): PKolibriChar;

var
  IOResult: Integer;
  Input, Output: Text;

function _Flush(var T: TTextRec): Integer;
procedure __IOTest;

function _ReadChar(var T: TTextRec): KolibriChar;
procedure _ReadCString(var T: TTextRec; Str: PKolibriChar; MaxLength: LongInt);
procedure _ReadString(var T: TTextRec; Str: PShortString; MaxLength: LongInt);
procedure _ReadLn(var T: TTextRec);

procedure _Write0Bool(var T: TTextRec; Value: Boolean);
procedure _Write0Char(var T: TTextRec; Ch: KolibriChar);
procedure _Write0Long(var T: TTextRec; Value: LongInt);
procedure _Write0String(var T: TTextRec; const S: ShortString);
procedure _Write0CString(var T: TTextRec; S: PKolibriChar);
procedure _Write0LString(var T: TTextRec; const S: KolibriString);
procedure _WriteBool(var T: TTextRec; Value: Boolean; Width: LongInt);
procedure _WriteChar(var T: TTextRec; Ch: KolibriChar; Width: LongInt);
procedure _WriteCString(var T: TTextRec; S: PKolibriChar; Width: LongInt);
procedure _WriteLong(var T: TTextRec; Value, Width: LongInt);
procedure _WriteString(var T: TTextRec; const S: ShortString; Width: LongInt);
procedure _WriteLString(var T: TTextRec; const S: KolibriString; Width: LongInt);
procedure _WriteLn(var T: TTextRec);

{ Console Library API }

type
  con_gets2_callback = function(KeyCode: Integer; var Str: PKolibriChar; var Count, Pos: Integer): Integer; stdcall;

const
  CON_COLOR_BLUE      = $01;
  CON_COLOR_GREEN     = $02;
  CON_COLOR_RED       = $04;
  CON_COLOR_BRIGHT    = $08;

  CON_BGR_BLUE        = $10;
  CON_BGR_GREEN       = $20;
  CON_BGR_RED         = $40;
  CON_BGR_BRIGHT      = $80;

  CON_IGNORE_SPECIALS = $100;
  CON_WINDOW_CLOSED   = $200;

  // TODO: con_gets2_callback constants

  con_cls: procedure; stdcall = nil;
  con_exit: procedure(CloseWindow: Boolean); stdcall = nil;
  con_getch: function: Integer; stdcall = nil;
  con_getch2: function: Word; stdcall = nil;
  con_get_cursor_pos: procedure(var X, Y: Integer); stdcall = nil;
  con_get_cursor_height: function: Integer; stdcall = nil;
  con_get_flags: function: LongWord; stdcall = nil;
  con_get_font_height: function: Integer; stdcall = nil;
  con_gets: function(Str: PKolibriChar; Length: Integer): PKolibriChar; stdcall = nil;
  con_gets2: function(Callback: con_gets2_callback; Str: PKolibriChar; Count: Integer): PKolibriChar; stdcall = nil;
  con_init: procedure(WndWidth, WndHeight, ScrWidth, ScrHeight: LongWord; Title: PKolibriChar); stdcall = nil;
  con_kbhit: function: Boolean; stdcall = nil;
  con_printf: function(Str: PKolibriChar): Integer; cdecl varargs = nil;
  con_set_flags: function(Flags: LongWord): LongWord; stdcall = nil;
  con_set_cursor_height: function(Height: Integer): Integer; stdcall = nil;
  con_set_cursor_pos: procedure(X, Y: Integer); stdcall = nil;
  con_set_title: procedure(Title: PKolibriChar); stdcall = nil;
  con_write_asciiz: procedure(Str: PKolibriChar); stdcall = nil;
  con_write_string: procedure(Str: PKolibriChar; Length: LongWord); stdcall = nil;

implementation

uses
  SysInit;

var
  InitContext: TInitContext;

procedure _HandleFinally;
asm
end;

procedure InitUnits;
var
  Idx: Integer;
begin
  if InitContext.InitTable <> nil then
    with InitContext.InitTable^ do
    begin
      Idx := 0;
      while Idx < UnitCount do
      begin
        with UnitInfo[Idx] do
        begin
          if Assigned(Init) then
            Init;
        end;
        Inc(Idx);
        InitContext.InitCount := Idx;
      end;
    end;
end;

procedure FinalizeUnits;
begin
  if InitContext.InitTable <> nil then
  begin
    with InitContext do
    begin
      while InitCount > 0 do
      begin
        Dec(InitCount);
        with InitTable.UnitInfo[InitCount] do
          if Assigned(Finalize) then
            Finalize;
      end;
    end;
  end;
end;

procedure _StartExe(InitTable: PPackageInfo);
begin
  InitContext.InitTable := InitTable;
  InitContext.InitCount := 0;
  InitUnits;
end;

procedure _Halt0;
begin
  FinalizeUnits;
  asm
    OR EAX, -1
    INT $40
  end;
end;

function Get8087CW: Word;
asm
        PUSH 0
        FNSTCW [ESP].Word
        POP EAX
end;

procedure Set8087CW(Value: Word);
begin
  Default8087CW := Value;
  asm
    FNCLEX
    FLDCW Default8087CW
  end;
end;

// Produce random values in a given range [MinValue..MaxValue]
// Note: Always return 0 if range = [0..$FFFFFFFF]
// cause (MaxValue - MinValue + 1) * eax + MinValue = 0
// uses variation of XorShift based algorithm
function RandInt(MinValue, MaxValue: LongWord): LongWord; stdcall;
asm
        MOV EAX, RandSeed
        MOV ECX, EAX
        SHL EAX, 13
        XOR ECX, EAX
        MOV EAX, ECX
        SHR EAX, 17
        XOR ECX, EAX
        MOV EAX, ECX
        SHL EAX, 5
        XOR EAX, ECX
        ADD RandCounter, 361275
        MOV RandSeed, EAX
        ADD EAX, RandCounter
        MOV EDX, MaxValue
        SUB EDX, MinValue
        INC EDX
        MUL EDX
        MOV EAX, EDX
        ADD EAX, MinValue
end;

function _RandInt(Range: LongWord): LongWord;
begin
  Result := RandInt(0, Range - 1);
end;

function _RandExt: Extended;
begin
  Result := 1 / RandInt(2, $FFFFFFFF);
end;

procedure Randomize;
asm
        RDTSC
        MOV RandSeed, EAX
end;

function UpCase(Ch: KolibriChar): KolibriChar;
begin
  if Ch in ['a'..'z'] then
    Dec(Ch, Ord('a') - Ord('A'));
  Result := Ch;
end;

type
  PStrRec = ^TStrRec;
  TStrRec = packed record
  {$IFDEF UnicodeCompiler}
    CodePage, CharSize: Word;
  {$ENDIF}
    RefCount, Length: LongInt;
  end;

function _LStrLen(const S: KolibriString): LongInt;
begin
  Result := PStrRec(PKolibriChar(Pointer(S)) - SizeOf(TStrRec)).Length;
end;

function _LStrToPChar(const S: KolibriString): PKolibriChar;
const
  EmptyString = '';
begin
  if Pointer(S) = nil then
    Result := EmptyString
  else
    Result := Pointer(S);
end;

function _Flush(var T: TTextRec): Integer;
asm
end;

procedure __IOTest;
asm
  // TODO: I/O error call
end;

const
  Booleans: array[Boolean] of PKolibriChar = ('False', 'True');

function _ReadChar(var T: TTextRec): KolibriChar;
begin
  Result := Chr(con_getch);
end;

procedure _ReadCString(var T: TTextRec; Str: PKolibriChar; MaxLength: LongInt);
var
  P, Limit: PKolibriChar;
begin
  con_gets(Str, MaxLength);
  P := Str;
  Limit := P + MaxLength;
  while (P < Limit) and not (P^ in [#0, #10]) do
    Inc(P);
  P^ := #0;
end;

procedure _ReadString(var T: TTextRec; Str: PShortString; MaxLength: LongInt);
var
  P, Limit: PKolibriChar;
begin
  P := PKolibriChar(Str) + 1;
  con_gets(P, MaxLength);
  Limit := P + MaxLength;
  while (P < Limit) and not (P^ in [#0, #10]) do
    Inc(P);
  PByte(Str)^ := P - PKolibriChar(Str) - 1;
end;

procedure _ReadLn(var T: TTextRec);
asm
end;

procedure _Write0Bool(var T: TTextRec; Value: Boolean);
begin
  con_write_asciiz(Booleans[Value]);
end;

procedure _Write0Char(var T: TTextRec; Ch: KolibriChar);
begin
  con_write_string(@Ch, 1);
end;

procedure _Write0Long(var T: TTextRec; Value: LongInt);
begin
  con_printf('%d', Value);
end;

procedure _Write0String(var T: TTextRec; const S: ShortString);
begin
  con_write_string(@S[1], Length(S));
end;

procedure _Write0CString(var T: TTextRec; S: PKolibriChar);
begin
  con_write_asciiz(S);
end;

procedure _Write0LString(var T: TTextRec; const S: KolibriString);
begin
  con_write_string(Pointer(S), Length(S));
end;

procedure _WriteBool(var T: TTextRec; Value: Boolean; Width: LongInt);
begin
  con_printf('%*s', Width, Booleans[Value]);
end;

procedure _WriteChar(var T: TTextRec; Ch: KolibriChar; Width: LongInt);
begin
  con_printf('%*c', Width, Ch);
end;

procedure _WriteCString(var T: TTextRec; S: PKolibriChar; Width: LongInt);
begin
  con_printf('%*s', Width, S);
end;

procedure _WriteLong(var T: TTextRec; Value, Width: LongInt);
begin
  con_printf('%*d', Width, Value);
end;

procedure _WriteString(var T: TTextRec; const S: ShortString; Width: LongInt);
begin
  con_printf('%*s', Width, @S[1]);
end;

procedure _WriteLString(var T: TTextRec; const S: KolibriString; Width: LongInt);
begin
  con_printf('%*s', Width, Pointer(S));
end;

procedure _WriteLn(var T: TTextRec);
begin
  con_write_string(#10, 1);
end;

initialization

asm // InitFPU
  FNINIT
  FWAIT
  FLDCW Default8087CW
end;

end.
