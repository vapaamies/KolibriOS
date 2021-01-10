(*
    KolibriOS on Windows (KoW) RTL definitions

    Copyright (c) 2021 Delphi SDK for KolibriOS team
*)

type
  HRESULT = type LongInt;

  HINST = THandle;
  HMODULE = THandle;
  HRSRC = THandle;

var
  ExitCode: Integer;
  MainWindow: THandle;

const
  kernel32 = 'kernel32.dll';
  user32 = 'user32.dll';

procedure _Halt(ExitCode: Integer);  

procedure ExitProcess(ExitCode: Cardinal); stdcall;
  external kernel32 name 'ExitProcess';
function GetCommandLine: PKolibriChar; stdcall;
  external kernel32 name 'GetCommandLineA';
function GetModuleFileName(hModule: THandle; Buffer: PKolibriChar; Count: Cardinal): Cardinal; stdcall;
  external kernel32 name 'GetModuleFileNameA';
function GetProcessHeap: THandle; stdcall;
  external kernel32 name 'GetProcessHeap';
function GetStdHandle(Code: LongWord): THandle; stdcall;
  external kernel32 name 'GetStdHandle';
function HeapAlloc(hHeap: THandle; Flags, Bytes: Cardinal): Pointer; stdcall;
  external kernel32 name 'HeapAlloc';
function HeapReAlloc(hHeap: THandle; Flags: Cardinal; Mem: Pointer; Bytes: Cardinal): Pointer; stdcall;
  external kernel32 name 'HeapReAlloc';
function HeapFree(hHeap: THandle; Flags: Cardinal; Mem: Pointer): LongBool; stdcall;
  external kernel32 name 'HeapFree';
function WriteFile(hFile: THandle; const Buffer; Count: Cardinal; var BytesWritten: Cardinal; Overlapped: Pointer): LongBool; stdcall;
  external kernel32 name 'WriteFile';

procedure MessageBox(Wnd: THandle; Text, Caption: PKolibriChar; Flags: Cardinal); stdcall;
  external user32 name 'MessageBoxA';

procedure __lldiv;
