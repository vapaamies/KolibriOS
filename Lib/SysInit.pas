(*
    KolibriOS RTL SysInit unit

    Copyright (c) 2020 Delphi SDK for KolibriOS team
*)

unit SysInit;

interface

procedure _InitExe(InitTable: PPackageInfo);

var
  TLSIndex: Integer = -1;
  TLSLast: Byte;

const
  PtrToNil: Pointer = nil;

implementation

procedure _InitExe(InitTable: PPackageInfo);
begin
  _StartExe(InitTable);
end;

end.
