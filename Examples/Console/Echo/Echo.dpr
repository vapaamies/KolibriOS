program Echo;

uses
  CRT;

var
  S: ShortString;
begin
  InitConsole('Echo');
  repeat
    Write('> ');
    ReadLn(S);
    if Length(S) <> 0 then
      WriteLn(S);
  until False;
end.
