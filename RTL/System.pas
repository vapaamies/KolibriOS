(*
    KolibriOS RTL System unit
*)

unit System;

interface

type
  PPAnsiChar = ^PAnsiChar;

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

  TVarType = (
    vtInteger, vtBoolean, vtAnsiChar, vtExtended, vtShortString, vtPointer, vtPAnsiChar,
    vtObject, vtClass, vtWideChar, vtPWideChar, vtAnsiString, vtCurrency, vtVariant, vtInterface,
    vtWideString, vtInt64
  );

  PVarRec = ^TVarRec;
  TVarRec = record { do not pack this record; it is compiler-generated }
    case TVarType of
      vtInteger:     (VarInteger: Integer; VarType: Byte);
      vtBoolean:     (VarBoolean: Boolean);
      vtAnsiChar:    (VarChar: AnsiChar);
      vtExtended:    (VarExtended: PExtended);
      vtShortString: (VarString: PShortString);
      vtPointer:     (VarPointer: Pointer);
      vtPAnsiChar:   (VarPChar: PAnsiChar);
      vtObject:      (VarObject: Pointer);
      vtClass:       (VarClass: Pointer);
      vtWideChar:    (VarWideChar: WideChar);
      vtPWideChar:   (VarPWideChar: PWideChar);
      vtAnsiString:  (VarAnsiString: PAnsiChar);
      vtCurrency:    (VarCurrency: PCurrency);
      vtVariant:     (VarVariant: PVariant);
      vtInterface:   (VarInterface: Pointer);
      vtWideString:  (VarWideString: PWideChar);
      vtInt64:       (VarInt64: PInt64);
  end;

procedure _Halt0;
procedure _HandleFinally;
procedure _StartExe(InitTable: PPackageInfo);

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

end.
