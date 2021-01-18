program DateTime;

uses
  KolibriOS, CRT;

var
  CursorXY: TCursorXY;

begin
  InitConsole('Date/Time');

  CursorOff;
  GotoXY(27, 11);
  Write(
    'System Date and System Time'#10 +
    '                              '
  );
  CursorXY := WhereXY;
  repeat
    with GetSystemDate do
      con_printf('%02x.%02x.%02x', Day, Month, Year);
    with GetSystemTime do
      con_printf('  -  %02x:%02x:%02x', Hours, Minutes, Seconds);
    GotoXY(CursorXY);
    Delay(500);
  until KeyPressed;
end.
