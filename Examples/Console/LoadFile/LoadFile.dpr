program LoadFileApp;

uses
  KolibriOS, CRT;

const
{$IFDEF KolibriOS}
  FileName = '/sys/example.asm';
{$ELSE}
  FileName = '..\..\Lib\KoW\CRT.inc';
{$ENDIF}

var
  FileSize: LongWord;
  Buffer: PKolibriChar;

begin
  InitConsole('Load File');
  Buffer := LoadFile(FileName, FileSize);
  con_write_string(Buffer, FileSize);
end.
