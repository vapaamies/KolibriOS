program DateTime;

uses
  KolibriOS, CRT;

var
  CursorXY: TCursorXY;

begin
  InitConsole('Date/Time', True, 80, 25, 80, 25);

  CursorOff;
  GotoXY(27, 12);
  Write(
    'System Date and System Time'#10 +
    '                             '
  );
  CursorXY := WhereXY;
  repeat
    with GetSystemDate, GetSystemTime do
      con_printf('%02x.%02x.%02x  -  %02x:%02x:%02x', Day, Month, Year, Hours, Minutes, Seconds);
    GotoXY(CursorXY);
    Delay(500);
  until KeyPressed;
end.
