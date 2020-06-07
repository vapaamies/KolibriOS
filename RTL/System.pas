(*
    Minimal Delphi System unit
*)

unit System;

interface

type
  PPAnsiChar = ^PAnsiChar;
  PInteger = ^Integer;

  THandle = LongWord;

  TGUID = record
    D1: LongWord;
    D2: Word;
    D3: Word;
    D4: array [0..7] of Byte;
  end;

  PInitContext = ^TInitContext;
  TInitContext = record
    OuterContext: PInitContext;
    ExceptionFrame, InitTable, InitCount: Integer;
    Module: Pointer;
    DLLSaveEBP, DLLSaveEBX, DLLSaveESI, DLLSaveEDI: Pointer;
    ExitProcessTLS: procedure;
    DLLInitState: byte;
  end;

procedure _Halt0;
procedure _HandleFinally;

implementation

uses
  SysInit;

procedure _Halt0;
asm
        XOR EAX, EAX
        DEC EAX
        INT $40
end;

procedure _HandleFinally;
asm
end;

end.
