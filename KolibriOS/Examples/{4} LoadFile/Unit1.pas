Unit Unit1;
(* -------------------------------------------------------- *)
Interface
(* -------------------------------------------------------- *)
Uses KolibriOS;
(* -------------------------------------------------------- *)
Var
  hConsole: Pointer;
  ConsoleInit:       Procedure(WndWidth, WndHeight, ScrWidth, ScrHeight: Dword; Caption: PChar); StdCall;
  ConsoleExit:       Procedure(bCloseWindow: Cardinal); StdCall;
  WriteN:            Procedure(Str: PChar; Count: Dword); StdCall;
(* -------------------------------------------------------- *)
Procedure Main;
(* -------------------------------------------------------- *)
Implementation
(* -------------------------------------------------------- *)
Procedure Main;
Var
  FileSize: Dword;
  Buffer: Pointer;
Begin
  hConsole          := LoadLibrary('/sys/lib/console.obj');
  ConsoleInit       := GetProcAddress(hConsole, 'con_init');
  ConsoleExit       := GetProcAddress(hConsole, 'con_exit');
  WriteN            := GetProcAddress(hConsole, 'con_write_string');

  ConsoleInit($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, 'Test');

  Buffer := LoadFile('/sys/example.asm', FileSize);
  WriteN(Buffer, FileSize);

  ConsoleExit(0);
  ThreadTerminate;
End;
(* -------------------------------------------------------- *)
End.