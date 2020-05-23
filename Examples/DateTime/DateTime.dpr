program DateTime;

uses
  KolibriOS;

var
  hConsole: Pointer;
  ConsoleInit:            procedure(WndWidth, WndHeight, ScrWidth, ScrHeight: LongWord; Caption: PKolibriChar); stdcall;
  ConsoleExit:            procedure(bCloseWindow: Cardinal); stdcall;
  Printf:                 function(const Format: PKolibriChar): Integer; cdecl varargs;
  GetConsoleCursorPos:    procedure(X, Y: PInteger); stdcall;
  SetConsoleCursorPos:    procedure(X, Y: Integer); stdcall;
  kbhit:                  function: Boolean;
  SetConsoleCursorHeight: function(Height: Integer): Integer; stdcall;
//  ConsoleCls:             procedure;

  SystemDate: TSystemDate;
  SystemTime: TSystemTime;
  X, Y: Integer;

begin
  hConsole               := LoadLibrary('/sys/lib/console.obj');
  ConsoleInit            := GetProcAddress(hConsole, 'con_init');
  ConsoleExit            := GetProcAddress(hConsole, 'con_exit');
  GetConsoleCursorPos    := GetProcAddress(hConsole, 'con_get_cursor_pos');
  SetConsoleCursorPos    := GetProcAddress(hConsole, 'con_set_cursor_pos');
  SetConsoleCursorHeight := GetProcAddress(hConsole, 'con_set_cursor_height');
  Printf                 := GetProcAddress(hConsole, 'con_printf');
  KBHit                  := GetProcAddress(hConsole, 'con_kbhit');

  ConsoleInit($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, 'Date/Time');

  SetConsoleCursorHeight(0);
  SetConsoleCursorPos(27, 11);
  Printf(
   'SystemDate and SystemTime'#10 +
   '                              '
  );
  GetConsoleCursorPos(@X, @Y);
  repeat
    SystemDate := GetSystemDate;
    SystemTime := GetSystemTime;
    with SystemDate, SystemTime do
    begin
      Printf('%02x.%02x.%02x', Day, Month, Year);
      Printf(' - %02x:%02x:%02x', Hours, Minutes, Seconds);
    end;
    SetConsoleCursorPos(X, Y);
    Sleep(50);
  until KBHit;

  ConsoleExit(1);
  TerminateThread;
end.
