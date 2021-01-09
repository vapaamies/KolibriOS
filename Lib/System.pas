(*
    KolibriOS RTL System unit

    Copyright (c) 2020-2021 Delphi SDK for KolibriOS team
*)

unit System;

interface

const
  UnicodeCompiler = CompilerVersion >= 20;

  ERROR_OUT_OF_MEMORY   = 203;
  ERROR_INVALID_POINTER = 204;

type
  PPAnsiChar = ^PAnsiChar;
  PPWideChar = ^PWideChar;

  KolibriChar = AnsiChar;
  PKolibriChar = PAnsiChar;
  PPKolibriChar = PPAnsiChar;

  KolibriString = AnsiString;
{$IFNDEF UnicodeCompiler}
  UnicodeString = WideString;
{$ENDIF}

{$IF CompilerVersion < 15}
  UInt64 = Int64;
{$IFEND}

  THandle = LongWord;

  PShortInt = ^ShortInt;
  PSmallInt = ^SmallInt;
  PLongInt = ^LongInt;
  PInt64 = ^Int64;

  PByte = ^Byte;
  PWord = ^Word;
  PLongWord = ^LongWord;
{$IF CompilerVersion < 15}
  PUInt64 = PInt64;
{$ELSE}
  PUInt64 = ^UInt64;
{$IFEND}

  PCardinal = ^Cardinal;
  PInteger = ^Integer;

  PSingle = ^Single;
  PDouble = ^Double;
  PExtended = ^Extended;
  PCurrency = ^Currency;

  PShortString = ^ShortString;
  PAnsiString = ^AnsiString;
  PWideString = ^WideString;
{$IFDEF UnicodeCompiler}
  PUnicodeString = ^UnicodeString;
  PString = PUnicodeString;
{$ELSE}
  PUnicodeString = PWideString;
  PString = PAnsiString;
{$ENDIF}

  PVariant = ^Variant;

  PGUID = ^TGUID;
  TGUID = record
    D1: LongWord;
    D2: Word;
    D3: Word;
    D4: array[0..7] of Byte;
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

  PMemoryManager = ^TMemoryManager;
  TMemoryManager = record
    GetMem: function(Size: Integer): Pointer;
    FreeMem: function(P: Pointer): Integer;
    ReallocMem: function(P: Pointer; Size: Integer): Pointer;
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
procedure _Run0Error;
procedure _RunError(ErrorCode: Byte);
procedure _StartExe(InitTable: PPackageInfo);

procedure ErrorMessage(Msg: PKolibriChar; Count: Byte);

function _FreeMem(P: Pointer): Integer;
function _GetMem(Size: Integer): Pointer;
function _ReallocMem(var P: Pointer; NewSize: Integer): Pointer;

procedure _FillChar(var Dest; Count: Cardinal; Value: Byte);
procedure Move(const Src; var Dst; Count: Integer);

procedure GetMemoryManager(var Value: TMemoryManager);
procedure SetMemoryManager(const Value: TMemoryManager);
function IsMemoryManagerSet: Boolean;

function SysFreeMem(P: Pointer): Integer;
function SysGetMem(Size: Integer): Pointer;
function SysReallocMem(P: Pointer; Size: Integer): Pointer;

var
  Default8087CW: Word = $1332; // for Extended type

function Get8087CW: Word;
procedure Set8087CW(Value: Word);

procedure _Frac;
procedure _Int;
procedure _Round;
procedure _Trunc;

procedure _Exp;

procedure _Cos;
procedure _Sin;

var
  RandSeed: LongWord;
  RandCounter: LongWord;

function _RandInt(Range: LongInt): LongInt;
function _RandExt: Extended;
procedure Randomize;

const
  CP_KOLIBRIOS = 866;

function UpCase(Ch: KolibriChar): KolibriChar;

function _LStrLen(const S: KolibriString): Cardinal;
function _LStrToPChar(const S: KolibriString): PKolibriChar;

var
  IOResult: Integer;
  Input, Output: Text;
  IsConsole: Boolean;

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

const
  HexDigits: array[$0..$F] of KolibriChar = '0123456789ABCDEF';

var  
  AppPath, CmdLine: PKolibriChar;

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
  con_get_cursor_pos: procedure(var X, Y: Integer); stdcall = nil;
  con_get_cursor_height: function: Integer; stdcall = nil;
  con_get_flags: function: LongWord; stdcall = nil;
  con_get_font_height: function: Integer; stdcall = nil;
  con_getch: function: Integer; stdcall = nil;
  con_getch2: function: Word; stdcall = nil;
  con_gets: function(Str: PKolibriChar; Length: Integer): PKolibriChar; stdcall = nil;
  con_gets2: function(Callback: con_gets2_callback; Str: PKolibriChar; Length: Integer): PKolibriChar; stdcall = nil;
  con_init: procedure(WndWidth, WndHeight, ScrWidth, ScrHeight: LongWord; Title: PKolibriChar); stdcall = nil;
  con_kbhit: function: Boolean; stdcall = nil;
  con_printf: function(Fmt: PKolibriChar): Integer; cdecl varargs = nil;
  con_set_flags: function(Flags: LongWord): LongWord; stdcall = nil;
  con_set_cursor_height: function(Height: Integer): Integer; stdcall = nil;
  con_set_cursor_pos: procedure(X, Y: Integer); stdcall = nil;
  con_set_title: procedure(Title: PKolibriChar); stdcall = nil;
  con_write_asciiz: procedure(Str: PKolibriChar); stdcall = nil;
  con_write_string: procedure(Str: PKolibriChar; Length: LongWord); stdcall = nil;

{$IFNDEF KolibriOS}
  {$I KoW\SysAPI.inc}
{$ENDIF}

implementation

uses
  SysInit;

var
  InitContext: TInitContext;

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

{$IFDEF KolibriOS}
procedure _Halt0;
asm
        CALL FinalizeUnits
        OR EAX, -1
        INT $40
end;
{$ENDIF}

procedure _HandleFinally;
asm
        MOV EAX, 1
end;

procedure _Run0Error;
asm
        XOR EAX, EAX
        JMP _RunError
end;

procedure _RunError(ErrorCode: Byte);
const
  Msg: array[0..28] of KolibriChar = 'Runtime error 000 at 00000000';
asm
{$IFNDEF KolibriOS}
        PUSH EAX
{$ENDIF}

        MOV EDX, $20202020
        MOV CL, 10
        XOR CH, CH
@@next10:
        XOR AH, AH
        DIV CL
        SHL EDX, 8
        MOV DL, AH
        ADD DL, '0'
        INC CH
        OR AL, AL
        JNZ @@next10
        MOV EAX, offset Msg[14]
        MOV [EAX], EDX

        MOVZX ECX, CH
        MOV EDX, [EAX+3] // ' at '
        ADD EAX, ECX
        MOV [EAX], EDX
{$IFDEF KolibriOS}
        // volatile
{$ELSE}
        PUSH EBX
{$ENDIF}
        MOV EBX, EAX
        MOV CL, 4
        ADD EBX, ECX

@@next16:
        MOV CH, CL
        DEC CL
        SHL CL, 3

{$IFDEF KolibriOS}
        MOV EAX, [ESP]
{$ELSE}
        MOV EAX, [ESP+8]
{$ENDIF}
        ROR EAX, CL
        AND EAX, $0F
        MOV DH, [EAX+HexDigits]

{$IFDEF KolibriOS}
        MOV EAX, [ESP]
{$ELSE}
        MOV EAX, [ESP+8]
{$ENDIF}
        ROR EAX, CL
        MOVZX EAX, AL
        SHR EAX, 4
        MOV DL, [EAX+HexDigits]

        MOV [EBX], DX
        INC EBX
        INC EBX
        MOVZX ECX, CH
        LOOP @@next16

        MOV EAX, offset Msg
        MOV EDX, EBX
{$IFNDEF KolibriOS}
        POP EBX
{$ENDIF}
        SUB EDX, EAX
        CALL ErrorMessage

{$IFNDEF KolibriOS}
        POP EAX
{$ENDIF}
        JMP _Halt0
end;

{$IFDEF KolibriOS}
procedure ErrorMessage(Msg: PKolibriChar; Count: Byte);
asm
        PUSH EBX
        PUSH ESI

        MOV ESI, EAX
        ADD EDX, EAX
        MOV EAX, 63
        MOV EBX, 1
@@loop:
        CMP ESI, EDX
        JE @@exit
        MOV CL, [ESI]
        INT $40
        INC ESI
        JMP @@loop

@@exit:
        MOV CL, 10
        INT $40

        POP ESI
        POP EBX
end;
{$ENDIF}

var
  MemoryManager: TMemoryManager = (
    GetMem: SysGetMem;
    FreeMem: SysFreeMem;
    ReallocMem: SysReallocMem
  );

function _FreeMem(P: Pointer): Integer;
asm
        TEST EAX, EAX
        JZ @@exit
        CALL MemoryManager.FreeMem
        TEST EAX, EAX
        JZ @@exit
        MOV AL, ERROR_INVALID_POINTER
        JMP _RunError
@@exit:
end;

function _GetMem(Size: Integer): Pointer;
asm
        TEST EAX, EAX
        JZ @@exit
        CALL MemoryManager.GetMem
        TEST EAX, EAX
        JNZ @@exit
        MOV AL, ERROR_OUT_OF_MEMORY
        JMP _RunError
@@exit:
end;

function _ReallocMem(var P: Pointer; NewSize: Integer): Pointer;
begin
  if P <> nil then
    if NewSize <> 0 then
    begin
      Result := MemoryManager.ReallocMem(P, NewSize);
      if Result = nil then
        RunError(ERROR_OUT_OF_MEMORY);
    end
    else
    begin
      if MemoryManager.FreeMem(P) <> 0 then
        RunError(ERROR_INVALID_POINTER);
      Result := nil;
    end
  else
    Result := MemoryManager.GetMem(NewSize);
  P := Result;
end;

procedure GetMemoryManager(var Value: TMemoryManager);
begin
  Value := MemoryManager;
end;

procedure SetMemoryManager(const Value: TMemoryManager);
begin
  MemoryManager := Value;
end;

function IsMemoryManagerSet: Boolean;
begin
  with MemoryManager do
    Result := (@GetMem <> @SysGetMem) or (@FreeMem <> @SysFreeMem) or (@ReallocMem <> @SysReallocMem);
end;

{$IFDEF KolibriOS}
function SysFreeMem(P: Pointer): Integer;
asm
        PUSH EBX
        MOV ECX, EAX
        MOV EAX, 68
        MOV EBX, 13
        INT $40
        POP EBX
        DEC EAX
end;

function SysGetMem(Size: Integer): Pointer;
asm
        PUSH EBX
        MOV ECX, EAX
        MOV EAX, 68
        MOV EBX, 12
        INT $40
        POP EBX
end;

function SysReallocMem(P: Pointer; Size: Integer): Pointer;
asm
        PUSH EBX
        MOV ECX, EAX
        MOV EAX, 68
        MOV EBX, 20
        INT $40
        POP EBX
end;
{$ENDIF}

procedure _FillChar(var Dest; Count: Cardinal; Value: Byte);
asm
        TEST EDX, EDX
        JZ @@exit

        PUSH EDI

        MOV EDI, EAX
        MOV CH, CL
        MOV EAX, ECX
        SHL EAX, 16
        MOV AX, CX

        MOV ECX, EDX
        SHR ECX, 2
        REPNZ STOSD

        MOVZX ECX, DL
        AND CL, 3
        REPNZ STOSB

        POP EDI
@@exit:
end;

procedure Move(const Src; var Dst; Count: Integer);
var
  I: Integer;
begin
  if @Src <> @Dst then
    if (PKolibriChar(@Src) > PKolibriChar(@Dst)) or (PKolibriChar(@Dst) > PKolibriChar(@Src) + Count) then
      for I := 0 to Count - 1 do
        PKolibriChar(@Dst)[I] := PKolibriChar(@Src)[I]
    else
      for I := Count - 1 downto 0 do
        PKolibriChar(@Dst)[I] := PKolibriChar(@Src)[I];
end;

function Get8087CW: Word;
asm
        PUSH 0
        FNSTCW [ESP].Word
        POP EAX
end;

procedure Set8087CW(Value: Word);
asm
        MOV Default8087CW, AX
        FNCLEX
        FLDCW Default8087CW
end;

procedure _Frac;
asm
        FLD ST(0)
        SUB ESP, 4
        FNSTCW [ESP].Word
        FNSTCW [ESP+2].Word
        OR [ESP+2].Word, $0F00
        FLDCW [ESP+2].Word
        FRNDINT
        FLDCW [ESP].Word
        ADD ESP, 4
        FSUB
end;

procedure _Int;
asm
        SUB ESP, 4
        FNSTCW [ESP].Word
        FNSTCW [ESP+2].Word
        OR [ESP+2].Word, $0F00
        FLDCW [ESP+2].Word
        FRNDINT
        FLDCW [ESP].Word
        ADD ESP, 4
end;

procedure _Round;
asm
        SUB ESP, 8
        FISTP [ESP].LongWord
        POP EAX
        POP EDX
end;

procedure _Trunc;
asm
        SUB ESP, 12
        FNSTCW [ESP].Word
        FNSTCW [ESP+2].Word
        OR [ESP+2].Word, $0F00
        FLDCW [ESP+2].Word
        FISTP [ESP+4].LongWord
        FLDCW [ESP].Word
        POP ECX
        POP EAX
        POP EDX
end;

procedure _Exp;
asm
        FLDL2E
        FMUL
        FLD ST(0)
        FRNDINT
        FSUB ST(1), ST
        FXCH ST(1)
        F2XM1
        FLD1
        FADD
        FSCALE
        FSTP ST(1)
end;

procedure _Cos;
asm
        FCOS
end;

procedure _Sin;
asm
        FSIN
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

function _RandInt(Range: LongInt): LongInt;
begin
  Result := RandInt(0, Range - 1);
end;

function _RandExt: Extended;
begin
  Result := RandInt(0, $FFFFFFFE) / $FFFFFFFF;
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
    RefCount: Integer;
    Length: Cardinal;
  end;

function _LStrLen(const S: KolibriString): Cardinal;
asm
       TEST EAX, EAX
       JZ @@exit
       MOV EAX, [EAX-4]
@@exit:
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

{$IFNDEF KolibriOS}
  {$I KoW\__lldiv.inc}
  {$I KoW\System.inc}
{$ENDIF}

initialization

  asm
    // InitFPU
    FNINIT
    FLDCW Default8087CW

{$IFDEF KolibriOS}
    // HeapInit
    PUSH EBX
    MOV EAX, 68
    MOV EBX, 11
    INT $40
    POP EBX
{$ENDIF}
  end;

{$IFDEF KolibriOS}
  AppPath := PPKolibriChar(32)^ + 1;
  CmdLine := PPKolibriChar(28)^;
{$ELSE}
  InitKoW;
{$ENDIF}

end.
