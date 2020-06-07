(*
    KolibriOS RTL System unit
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
