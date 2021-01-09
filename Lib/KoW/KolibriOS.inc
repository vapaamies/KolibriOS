(*
    KolibriOS on Windows (KoW) unit

    Copyright (c) 2021 Delphi SDK for KolibriOS team
*)

type
  TOSVersionInfoA = packed record
    dwOSVersionInfoSize: LongWord;
    dwMajorVersion: LongWord;
    dwMinorVersion: LongWord;
    dwBuildNumber: LongWord;
    dwPlatformId: LongWord;
    szCSDVersion: array[0..127] of KolibriChar;
  end;

function GetFileSizeEx(hFile: THandle; var FileSize: UInt64): LongBool; stdcall;
  external kernel32 name 'GetFileSizeEx';
function GetVersionExA(var Info: TOSVersionInfoA): LongBool; stdcall;
  external kernel32 name 'GetVersionExA';

procedure ExitThread; stdcall;
begin
  Windows.ExitProcess(0);
end;

function GetCurrentDirectory(Buffer: PKolibriChar; Count: LongWord): LongWord; 
begin
  Result := GetCurrentDirectoryA(Count, Buffer);
end;

procedure GetKernelVersion(var Buffer: TKernelVersion);
var
  Info: TOSVersionInfoA;
begin
  FillChar(Buffer, SizeOf(Buffer), 0);
  Info.dwOSVersionInfoSize := SizeOf(Info);
  if GetVersionExA(Info) then
    with Buffer, Info do
    begin
      A := dwMajorVersion;
      B := dwMinorVersion;
      Revision := dwBuildNumber;
    end;
end;

function GetSystemDate: KolibriOS.TSystemDate; 
var
  Date: Windows.TSystemTime;
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

function GetSystemTime: KolibriOS.TSystemTime; 
var
  Time: Windows.TSystemTime;
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
        JMP Windows.GetTickCount
end;

function GetTickCount64: UInt64; stdcall;
asm
        CALL Windows.GetTickCount
        XOR EDX, EDX
end;

function LoadFile(FileName: PKolibriChar; var Size: LongWord): Pointer;
var
  hFile: THandle;
  QSize: UInt64;
begin
  hFile := CreateFileA(FileName, GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  if (hFile <> INVALID_HANDLE_VALUE) and GetFileSizeEx(hFile, QSize) then
  begin
    Size := QSize;
    GetMem(Result, Size);
    Windows.ReadFile(hFile, Result^, Size, Size, nil);
    Exit;
  end;
  Size := 0;
  Result := nil;
end;

procedure SetCurrentDirectory(Path: PKolibriChar);
begin
  SetCurrentDirectoryA(Path);
end;

procedure Sleep(Time: LongWord); 
begin
  Windows.Sleep(Time * 10);
end;