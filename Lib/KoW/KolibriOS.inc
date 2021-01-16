(*
    KolibriOS on Windows (KoW) unit

    Copyright (c) 2021 Delphi SDK for KolibriOS team
*)

const
  BoardLog = 'BOARDLOG.TXT';

var
  hBoard: THandle;
  DebugReadPos: UInt64;

function InitBoard: Boolean;
begin
  if hBoard = 0 then
  begin
    hBoard := CreateFile(BoardLog, GENERIC_READ or GENERIC_WRITE,
      FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_ALWAYS, 0, 0);
    Result := hBoard <> INVALID_HANDLE_VALUE;
  end
  else
    Result := True;
end;

function DebugRead(var Data: KolibriChar): Boolean; stdcall;
var
  BytesRead: LongWord;
begin
  Result := InitBoard and SetFilePointerEx(hBoard, DebugReadPos, @DebugReadPos, FILE_BEGIN) and
    ReadFile(hBoard, Data, SizeOf(Data), BytesRead, nil) and (BytesRead <> 0);
  Inc(DebugReadPos, BytesRead);
end;

procedure DebugWrite(Data: KolibriChar); stdcall;
var
  BytesWritten: LongWord;
begin
  if not InitBoard or not SetFilePointerEx(hBoard, 0, nil, FILE_END) or
    not WriteFile(hBoard, Data, SizeOf(Data), BytesWritten, nil) or (BytesWritten = 0)
  then
    RunError(ERROR_ACCESS_DENIED);
end;

procedure ExitThread; stdcall;
begin
  ExitProcess(0);
end;

function GetCurrentDirectory(Buffer: PKolibriChar; Count: LongWord): LongWord; 
begin
  Result := System.GetCurrentDirectory(Count, Buffer);
end;

procedure GetKernelVersion(var Buffer: TKernelVersion);
var
  Info: TOSVersionInfo;
begin
  FillChar(Buffer, SizeOf(Buffer), 0);
  Info.dwOSVersionInfoSize := SizeOf(Info);
  if GetVersionEx(Info) then
    with Buffer, Info do
    begin
      A := dwMajorVersion;
      B := dwMinorVersion;
      Revision := dwBuildNumber;
    end;
end;

function GetSystemDate: TSystemDate;
var
  Date: System.TSystemTime;
begin
  GetLocalTime(Date);
  with Result, Date do
  begin
    Year := wYear mod 100;
    Year := Year div 10 shl 4 or Year mod 10;
    Month := wMonth div 10 shl 4 or wMonth mod 10;
    Day := wDay div 10 shl 4 or wDay mod 10;
  end;
end;

function GetSystemTime: TSystemTime;
var
  Time: System.TSystemTime;
begin
  GetLocalTime(Time);
  with Result, Time do
  begin
    Hours := wHour div 10 shl 4 or wHour mod 10;
    Minutes := wMinute div 10 shl 4 or wMinute mod 10;
    Seconds := wSecond div 10 shl 4 or wSecond mod 10;
  end;
end;

function GetTickCount: LongWord; stdcall;
asm
        JMP System.GetTickCount
end;

function GetTickCount64: UInt64; stdcall;
asm
        CALL System.GetTickCount
        XOR EDX, EDX
end;

function LoadFile(FileName: PKolibriChar; var Size: LongWord): Pointer;
var
  hFile: THandle;
  QSize: UInt64;
  Unpacked: Pointer;
begin
  hFile := CreateFile(FileName, GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  if (hFile <> INVALID_HANDLE_VALUE) and GetFileSizeEx(hFile, QSize) then
  begin
    Size := QSize;
    GetMem(Result, Size);
    System.ReadFile(hFile, Result^, Size, Size, nil);
    if PPackedFileHeader(Result).Signature = KPCK then
    begin
      Size := PPackedFileHeader(Result).UnpackedSize;
      GetMem(Unpacked, Size);
      Unpack(PPackedFile(Result)^, Unpacked^);
      FreeMem(Result);
      Result := Unpacked;
    end;
    Exit;
  end;
  Size := 0;
  Result := nil;
end;

procedure SetCurrentDirectory(Path: PKolibriChar);
asm
        JMP System.SetCurrentDirectory
end;

procedure Sleep(Time: LongWord);
begin
  System.Sleep(Time * 10);
end;
