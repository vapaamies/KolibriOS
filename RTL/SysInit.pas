(*
    Minimal Delphi SysInit unit
*)

unit SysInit;

interface

procedure _InitExe;

var
  ModuleIsLib: Boolean;
  TLSIndex: Integer = -1;
  TLSLast: Byte;

const
  PtrToNil: Pointer = nil;

implementation

procedure _InitExe;
asm
end;

end.
