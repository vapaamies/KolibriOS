program GetCurrentDir;

uses
  KolibriOS, CRT;

const
  AppPath = PPKolibriChar(32);
  CmdLine = PPKolibriChar(28);

  BUFFER_SIZE = 256;

var
  Buffer: array[0..BUFFER_SIZE - 1] of Char;

begin
  InitConsole('Get Current Directory', False);

  GetCurrentDirectory(Buffer, BUFFER_SIZE);

  Write('AppPath is "%s"'#10, AppPath^);
  Write('CmdLine is "%s"'#10, CmdLine^);
  Write('Current Directory is "%s"'#10, Buffer);
end.
