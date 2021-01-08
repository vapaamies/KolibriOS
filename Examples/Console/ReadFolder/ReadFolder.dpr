program ReadFolderApp;

uses
  KolibriOS, CRT, SysUtils;

const
  Path = '/sys';

var
  Info: TFolderInformation;
  BlocksRead: LongWord;
  Pos: LongWord;

begin
  InitConsole('Read Folder');

  if ReadFolder(Path, Info, 0, 0, 0, BlocksRead) = 0 then
    con_printf('Folder "%s" contains %u files and/or folders.'#10#10, Path, Info.FileCount)
  else
    con_printf('Folder "%s" cannot be read.'#10, Path);

  Pos := 0;
  while ReadFolder(Path, Info, 1, Pos, 0, BlocksRead) = 0 do
  begin
    with Info, FileInformation[0] do
    begin
      con_printf(    'File Name  = %s'#10, Name);
      with Attributes do
      begin
        with Int64Rec(Size) do
          con_printf('Size       = %u:%u'#10, Hi, Lo);
        with Creation, Date, Time do
          con_printf('Created    = %02d.%02d.%02d %02d:%02d:%02d'#10, Day, Month, Year, Hours, Minutes, Seconds);
        with Modify, Date, Time do
          con_printf('Modified   = %02d.%02d.%02d %02d:%02d:%02d'#10, Day, Month, Year, Hours, Minutes, Seconds);
        with Access, Date, Time do
          con_printf('Accessed   = %02d.%02d.%02d %02d:%02d:%02d'#10, Day, Month, Year, Hours, Minutes, Seconds);
        con_printf(  'Attributes = 0x%08x'#10#10, Attributes);
      end;
    end;
    Inc(Pos);
  end;
end.
