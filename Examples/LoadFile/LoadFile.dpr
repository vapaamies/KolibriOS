program LoadFileApp;

uses
  KolibriOS, CRT;

var
  FileSize: LongWord;
  Buffer: Pointer;

begin
  ConsoleInit('Load File');

  Buffer := LoadFile('/sys/example.asm', FileSize);
  WriteText(Buffer, FileSize);

  ConsoleExit(False);
end.
