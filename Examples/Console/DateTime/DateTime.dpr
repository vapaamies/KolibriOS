program DateTime;

uses
  KolibriOS, CRT;

var
  SystemDate: TSystemDate;
  SystemTime: TSystemTime;
  CursorPos: TConsolePoint;

begin
  InitConsole('Date/Time');

  SetCursorHeight(0);
  SetCursorPos(27, 11);
  Write(
    'System Date and System Time'#10 +
    '                              '
  );
  CursorPos := GetCursorPos;
  repeat
    SystemDate := GetSystemDate;
    SystemTime := GetSystemTime;
    with SystemDate, SystemTime do
    begin
      Write('%02x.%02x.%02x', Day, Month, Year);
      Write(' - %02x:%02x:%02x', Hours, Minutes, Seconds);
    end;
    SetCursorPos(CursorPos);
    Sleep(50);
  until KeyPressed;
end.
