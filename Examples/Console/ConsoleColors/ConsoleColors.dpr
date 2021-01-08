program ConsoleColors;

uses
  CRT;

const
  ColorName: array[Black..White] of PKolibriChar = (
    'Black', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Brown', 'Light Gray',
    'Dark Gray', 'Light Blue', 'Light Green', 'Light Cyan', 'Light Red', 'Light Magenta', 'Yellow', 'White'
  );

var
  Color: Byte;

begin
  InitConsole('Console Colors', False, 30, 33, 30, 33);

  for Color := Low(ColorName) to High(ColorName) do
  begin
    TextBackground(Color);
    WriteLn(ColorName[Color]);
  end;

  NormVideo;

  for Color := Low(ColorName) to High(ColorName) do
  begin
    TextColor(Color);
    WriteLn(ColorName[Color]);
  end;
end.
