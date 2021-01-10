(*
    KolibriOS on Windows (KoW) RTL System unit

    Copyright (c) 2021 Delphi SDK for KolibriOS team
*)

const
  HEAP_NO_SERIALIZE = $00001;

var
  ModuleFileName: array[0..1023] of KolibriChar;
  HeapHandle: THandle;

procedure InitKoW;
begin
  GetModuleFileName(0, ModuleFileName, Length(ModuleFileName));
  AppPath := @ModuleFileName;

  CmdLine := GetCommandLine;

  if IsConsole then
    TTextRec(Output).Handle := GetStdHandle(LongWord(-11));

  HeapHandle := GetProcessHeap;
end;

procedure _Halt(ExitCode: Integer);
asm
        CALL FinalizeUnits
        PUSH ExitCode
        CALL ExitProcess
end;

procedure _Halt0;
asm
        MOV EAX, ExitCode
        JMP _Halt
end;

procedure ErrorMessage(Msg: PKolibriChar; Count: Byte);
const
  MB_ICONERROR = $0010;
  MB_TASKMODAL = $2000;
  EOL: array[0..1] of KolibriChar = #13#10;
var
  Buf: array[Low(Byte)..High(Byte) + 1] of KolibriChar;
{$IFNDEF Debug}
  BytesWritten: LongWord;
{$ENDIF}
  Flags: LongWord;
begin
{$IFNDEF Debug}
  if TTextRec(Output).Handle <> 0 then
  begin
    WriteFile(TTextRec(Output).Handle, Msg^, Count, BytesWritten, nil);
    WriteFile(TTextRec(Output).Handle, EOL, SizeOf(EOL), BytesWritten, nil);
    Exit;
  end;
{$ENDIF}
  if MainWindow <> 0 then
    Flags := MB_ICONERROR
  else
    Flags := MB_ICONERROR or MB_TASKMODAL;
  Move(Msg^, Buf, Count);
  Msg[Count] := #0;
  MessageBox(MainWindow, Msg, nil, Flags);
end;

function SysFreeMem(P: Pointer): Integer;
begin
  Result := Integer(not HeapFree(HeapHandle, HEAP_NO_SERIALIZE, P));
end;

function SysGetMem(Size: Integer): Pointer;
begin
  Result := HeapAlloc(HeapHandle, 2, Size);
end;

function SysReallocMem(P: Pointer; Size: Integer): Pointer;
begin
  Result := HeapReAlloc(HeapHandle, HEAP_NO_SERIALIZE, P, Size);
end;
