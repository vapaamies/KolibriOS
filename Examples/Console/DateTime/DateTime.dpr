program DateTime;

uses
  KolibriOS, CRT;

var
  CursorXY: TCursorXY;

begin
  InitConsole('Date/Time', True);

  CursorOff;
  GotoXY(27, 11);
  Write(
    'System Date and System Time'#10 +
    '                              '
  );
  CursorXY := WhereXY;
  repeat
    with GetSystemDate, GetSystemTime do
    begin
      Write('%02x.%02x.%02x', [Day, Month, Year]);
      Write(' - %02x:%02x:%02x', [Hours, Minutes, Seconds]);
    end;
    GotoXY(CursorXY);
    Delay(500);
  until KeyPressed;
end.
