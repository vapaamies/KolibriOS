program LoadFileApp;

uses
  KolibriOS;

var
  hConsole: Pointer;
  ConsoleInit:       procedure(WndWidth, WndHeight, ScrWidth, ScrHeight: LongWord; Caption: PKolibriChar); stdcall;
  ConsoleExit:       procedure(bCloseWindow: Cardinal); stdcall;
  WriteN:            procedure(Str: PKolibriChar; Count: LongWord); stdcall;

  FileSize: LongWord;
  Buffer: Pointer;

begin
  hConsole          := LoadLibrary('/sys/lib/console.obj');
  ConsoleInit       := GetProcAddress(hConsole, 'con_init');
  ConsoleExit       := GetProcAddress(hConsole, 'con_exit');
  WriteN            := GetProcAddress(hConsole, 'con_write_string');

  ConsoleInit($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, 'Load File');

  Buffer := LoadFile('/sys/example.asm', FileSize);
  WriteN(Buffer, FileSize);

  ConsoleExit(0);
  TerminateThread;
end.
