(*
    KolibriOS RTL System unit
*)

unit System;

interface

const
{$IF CompilerVersion < 15}
  RTLVersion = 14.2006;  // <---,
{$ELSE}                  //      June, 2020
  RTLVersion = 15.2006;  // <---'
{$IFEND}

  UnicodeCompiler = CompilerVersion >= 20.0;
  
type
  PPAnsiChar = ^PAnsiChar;

  KolibriChar = AnsiChar;
  PKolibriChar = PAnsiChar;
  PPKolibriChar = PPAnsiChar;

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
      vtChar:       (VChar: AnsiChar);
      vtExtended:   (VExtended: PExtended);
      vtString:     (VString: PShortString);
      vtPointer:    (VPointer: Pointer);
      vtPChar:      (VPChar: PAnsiChar);
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

  PConsoleInterface = ^TConsoleInterface;
  TConsoleInterface = record
    ClrScr: procedure; stdcall;
    GetCh: function: Integer; stdcall;
    GetCh2: function: Word; stdcall;
    GetS: function(Str: PKolibriChar; Length: Integer): PKolibriChar; stdcall;
    GetCursorHeight: function: Integer; stdcall;
    GetFlags: function: LongWord; stdcall;
    GetFontHeight: function: Integer; stdcall;
    GotoXY: procedure(X, Y: Integer); stdcall;
    KeyPressed: function: Boolean; stdcall;
    PrintF: function(Str: PKolibriChar): Integer; cdecl varargs;
    ReadKey: function: KolibriChar; stdcall;
    SetFlags: function(Flags: LongWord): LongWord; stdcall;
    SetCursorHeight: function(Height: Integer): Integer; stdcall;
    SetTitle: procedure(Title: PKolibriChar); stdcall;
    WhereXY: procedure(var X, Y: Integer); stdcall;
    WritePChar: procedure(Str: PKolibriChar); stdcall;
    WritePCharLen: procedure(Str: PKolibriChar; Length: LongWord); stdcall;
  end;

procedure _Halt0;
procedure _HandleFinally;
procedure _StartExe(InitTable: PPackageInfo);

var
  Default8087CW: Word = $1332; // for Extended type

procedure InitFPU;
function Get8087CW: Word;
procedure Set8087CW(Value: Word);

function UpCase(Ch: KolibriChar): KolibriChar;

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

procedure InitFPU;
asm
        FNINIT
        FWAIT
        FLDCW Default8087CW
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

function UpCase(Ch: KolibriChar): KolibriChar;
begin
  if Ch in ['a'..'z'] then
    Dec(Ch, Ord('a') - Ord('A'));
  Result := Ch;
end;

end.
