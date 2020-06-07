program GetCurrentDir;

uses
  KolibriOS;

const
  AppPath = PPKolibriChar(32);
  CmdLine = PPKolibriChar(28);

  BUFFER_SIZE = 256;

var
  hConsole: Pointer;
  ConsoleInit:       procedure(WndWidth, WndHeight, ScrWidth, ScrHeight: LongWord; Caption: PKolibriChar); stdcall;
  ConsoleExit:       procedure(bCloseWindow: Cardinal); stdcall;
  printf:            function(const Format: PKolibriChar): Integer; CDecl varargs;

  Buffer: array[0..BUFFER_SIZE - 1] of Char;

begin
  hConsole          := LoadLibrary('/sys/lib/console.obj');
  ConsoleInit       := GetProcAddress(hConsole, 'con_init');
  ConsoleExit       := GetProcAddress(hConsole, 'con_exit');
  printf            := GetProcAddress(hConsole, 'con_printf');

  ConsoleInit($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, 'Get Current Directory');

  GetCurrentDirectory(Buffer, BUFFER_SIZE);

  printf('AppPath is "%s"'#10, AppPath^);
  printf('CmdLine is "%s"'#10, CmdLine^);
  printf('CurrentDirectory is "%s"'#10, Buffer);

  ConsoleExit(0);
end.
