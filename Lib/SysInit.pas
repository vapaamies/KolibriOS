(*
    KolibriOS RTL SysInit unit

    Copyright (c) 2020-2021 Delphi SDK for KolibriOS team
*)

unit SysInit;

interface

procedure _InitExe(InitTable: PPackageInfo);

var
  PtrToNil: Pointer;

  TLSIndex: Integer; // = -1;
  TLSLast: Byte;

implementation

procedure _InitExe(InitTable: PPackageInfo);
begin
  _StartExe(InitTable);
end;

end.
