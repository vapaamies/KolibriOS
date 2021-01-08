program CharMap;

uses
  CRT;

var
  CharLine: array[$0..$F] of KolibriChar;
  Line, Ch: Byte;
begin
  InitConsole('CharMap', False, 20, 19, 20, 19);

  con_write_asciiz(#10);
  con_write_asciiz('   ');
  con_write_string(HexDigits, Length(HexDigits));
  con_write_asciiz(#10);

  for Line := Low(HexDigits) to High(HexDigits) do
  begin
    con_write_asciiz(' ');
    con_write_string(@HexDigits[Line], 1);
    con_write_asciiz(' ');
    for Ch := Low(CharLine) to High(CharLine) do
      CharLine[Ch] := Chr(Line shl 4 + Ch);
    con_set_flags(con_get_flags or CON_IGNORE_SPECIALS);
    con_write_string(CharLine, Length(CharLine));
    con_set_flags(con_get_flags and not CON_IGNORE_SPECIALS);
    con_write_asciiz(#10);
  end;
end.
