program LoadFileApp;

uses
  KolibriOS, CRT;

var
  FileSize: LongWord;
  Buffer: Pointer;

begin
  InitConsole('Load File', False);
  Buffer := LoadFile('/sys/example.asm', FileSize);
  WriteText(Buffer, FileSize);
end.
