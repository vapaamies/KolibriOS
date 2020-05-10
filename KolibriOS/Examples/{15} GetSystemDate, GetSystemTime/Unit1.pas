Unit Unit1;
(* -------------------------------------------------------- *)
Interface
(* -------------------------------------------------------- *)
Uses KolibriOS;
(* -------------------------------------------------------- *)
Var
  hConsole: Pointer;
  ConsoleInit:            Procedure(WndWidth, WndHeight, ScrWidth, ScrHeight: Dword; Caption: PChar); StdCall;
  ConsoleExit:            Procedure(bCloseWindow: Cardinal); StdCall;
  Printf:                 Function(Const Format: PChar): Integer; CDecl VarArgs;
  GetConsoleCursorPos:    Procedure(X, Y: PInteger); StdCall;
  SetConsoleCursorPos:    Procedure(X, Y: Integer); StdCall;
  kbhit:                  Function: Boolean;
  SetConsoleCursorHeight: Function(Height: Integer): Integer; StdCall;
  ConsoleCls:             Procedure;
(* -------------------------------------------------------- *)
Procedure Main;
(* -------------------------------------------------------- *)
Implementation
(* -------------------------------------------------------- *)
Procedure Main();
Var
   SystemDate: TSystemDate;
   SystemTime: TSystemTime;
   X, Y: Integer;
Begin

   hConsole               := LoadLibrary('/sys/lib/console.obj');
   ConsoleInit            := GetProcAddress(hConsole, 'con_init');
   ConsoleExit            := GetProcAddress(hConsole, 'con_exit');
   GetConsoleCursorPos    := GetProcAddress(hConsole, 'con_get_cursor_pos');
   SetConsoleCursorPos    := GetProcAddress(hConsole, 'con_set_cursor_pos');
   SetConsoleCursorHeight := GetProcAddress(hConsole, 'con_set_cursor_height');
   Printf                 := GetProcAddress(hConsole, 'con_printf');
   KBHit                  := GetProcAddress(hConsole, 'con_kbhit');

   ConsoleInit($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, 'Test');

   SetConsoleCursorHeight(0);
   SetConsoleCursorPos(27, 11);
   Printf('SystemDate and SystemTime'#10'                              ');
   GetConsoleCursorPos(@X, @Y);
   Repeat
     SystemDate := GetSystemDate();
     SystemTime := GetSystemTime();
     With SystemDate, SystemTime Do
     Begin
       Printf('%02x.%02x.%02x', Day, Month, Year);
       Printf(' - %02x:%02x:%02x', Hours, Minutes, Seconds);
     End;
     SetConsoleCursorPos(X, Y);
     Sleep(50);
   Until KBHit;

   ConsoleExit(1);
   ThreadTerminate;
End;
(* -------------------------------------------------------- *)
End.