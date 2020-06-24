program DateTime;

uses
  KolibriOS, CRT;

var
  CursorXY: TCursorXY;

begin
  InitConsole('Date/Time', True);

  CursorOff;
  GotoXY(27, 11);
  WriteEx(
    'System Date and System Time'#10 +
    '                              '
  );
  CursorXY := WhereXY;
  repeat
    with GetSystemDate do
      WriteEx('%02x.%02x.%02x', [Day, Month, Year]);
    with GetSystemTime do
      WriteEx('  -  %02x:%02x:%02x', [Hours, Minutes, Seconds]);
    GotoXY(CursorXY);
    Delay(500);
  until KeyPressed;
end.
