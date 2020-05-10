Unit Unit1;
(* -------------------------------------------------------- *)
Interface
(* -------------------------------------------------------- *)
Uses KolibriOS;
(* -------------------------------------------------------- *)
Const
  AppPath = PPChar(32);
  CmdLine = PPChar(28);
Var
  hConsole: Pointer;
  ConsoleInit:       Procedure(WndWidth, WndHeight, ScrWidth, ScrHeight: Dword; Caption: PChar); StdCall;
  ConsoleExit:       Procedure(bCloseWindow: Cardinal); StdCall;
  printf:            Function(Const Format: PChar): Integer; CDecl VarArgs;
(* -------------------------------------------------------- *)
Procedure Main;
(* -------------------------------------------------------- *)
Implementation
(* -------------------------------------------------------- *)
Procedure Main;
Const
   BUFFER_SIZE = 256;
Var
   Buffer: Array[0..BUFFER_SIZE - 1] Of Char;
Begin
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
   ThreadTerminate;
End;
(* -------------------------------------------------------- *)
End.