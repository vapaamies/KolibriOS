program GetCurrentDir;

uses
  KolibriOS;

const
  AppPath = PPChar(32);
  CmdLine = PPChar(28);

  BUFFER_SIZE = 256;

var
  hConsole: Pointer;
  ConsoleInit:       procedure(WndWidth, WndHeight, ScrWidth, ScrHeight: LongWord; Caption: PChar); stdcall;
  ConsoleExit:       procedure(bCloseWindow: Cardinal); stdcall;
  printf:            function(const Format: PChar): Integer; cdecl varargs;

  Buffer: array[0..BUFFER_SIZE - 1] of Char;

begin
  hConsole          := LoadLibrary('/sys/lib/console.obj');
  ConsoleInit       := GetProcAddress(hConsole, 'con_init');
  ConsoleExit       := GetProcAddress(hConsole, 'con_exit');
  printf            := GetProcAddress(hConsole, 'con_printf');

  ConsoleInit($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, 'Test');

  GetCurrentDirectory(Buffer, BUFFER_SIZE);

  printf('AppPath is "%s"'#10, AppPath^);
  printf('CmdLine is "%s"'#10, CmdLine^);
  printf('CurrentDirectory is "%s"'#10, Buffer);

  ConsoleExit(0);
  TerminateThread;
end.
