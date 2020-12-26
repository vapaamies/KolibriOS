program GetCurrentDir;

uses
  KolibriOS, CRT;

const
  AppPath = PPKolibriChar(32);
  CmdLine = PPKolibriChar(28);

  BUFFER_SIZE = 256;

var
  Buffer: array[0..BUFFER_SIZE - 1] of KolibriChar;

begin
  InitConsole('Get Current Directory');

  GetCurrentDirectory(Buffer, BUFFER_SIZE);

  con_printf('AppPath is "%s"'#10, AppPath^);
  con_printf('CmdLine is "%s"'#10, CmdLine^);
  con_printf('Current Directory is "%s"'#10, Buffer);
end.
