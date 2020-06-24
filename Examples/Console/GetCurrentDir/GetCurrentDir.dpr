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

  WriteLnEx('AppPath is "%s"', [AppPath^]);
  WriteLnEx('CmdLine is "%s"', [CmdLine^]);
  WriteLnEx('Current Directory is "%s"', [Buffer]);
end.
