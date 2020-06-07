program ConsoleColors;

uses
  CRT;

begin
  ConsoleInit('Console Colors');

  TextBackground(Black);
  WriteLn('Black');
  TextBackground(Blue);
  WriteLn('Blue');
  TextBackground(Green);
  WriteLn('Green');
  TextBackground(Cyan);
  WriteLn('Cyan');
  TextBackground(Red);
  WriteLn('Red');
  TextBackground(Magenta);
  WriteLn('Magenta');
  TextBackground(Brown);
  WriteLn('Brown');
  TextBackground(LightGray);
  WriteLn('LightGray');
  TextBackground(DarkGray);
  WriteLn('DarkGray');
  TextBackground(LightBlue);
  WriteLn('LightBlue');
  TextBackground(LightGreen);
  WriteLn('LightGreen');
  TextBackground(LightCyan);
  WriteLn('LightCyan');
  TextBackground(LightRed);
  WriteLn('LightRed');
  TextBackground(LightMagenta);
  WriteLn('LightMagenta');
  TextBackground(Yellow);
  WriteLn('Yellow');
  TextBackground(White);
  WriteLn('White');

  ResetAttributes;

  TextColor(Black);
  WriteLn('Black');
  TextColor(Blue);
  WriteLn('Blue');
  TextColor(Green);
  WriteLn('Green');
  TextColor(Cyan);
  WriteLn('Cyan');
  TextColor(Red);
  WriteLn('Red');
  TextColor(Magenta);
  WriteLn('Magenta');
  TextColor(Brown);
  WriteLn('Brown');
  TextColor(LightGray);
  WriteLn('LightGray');
  TextColor(DarkGray);
  WriteLn('DarkGray');
  TextColor(LightBlue);
  WriteLn('LightBlue');
  TextColor(LightGreen);
  WriteLn('LightGreen');
  TextColor(LightCyan);
  WriteLn('LightCyan');
  TextColor(LightRed);
  WriteLn('LightRed');
  TextColor(LightMagenta);
  WriteLn('LightMagenta');
  TextColor(Yellow);
  WriteLn('Yellow');
  TextColor(White);
  WriteLn('White');

  ReadKey;

  ConsoleExit(True);
end.
