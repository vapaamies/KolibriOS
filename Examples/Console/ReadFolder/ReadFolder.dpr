program ReadFolderApp;

uses
  KolibriOS, CRT, SysUtils;

const
  FolderPath = '/sys';

var
  FolderInformation: TFolderInformation;
  BlocksRead: LongWord;
  Pos: LongWord;

begin
  InitConsole('Read Folder');

  if ReadFolder(FolderPath, FolderInformation, 0, 0, 0, BlocksRead) = 0 then
    with FolderInformation do
      con_printf('Folder "%s" contains %u files and/or folders.'#10#10, FolderPath, FileCount)
  else
    con_printf('Folder "%s" can not be read.'#10, FolderPath);

  Pos := 0;
  while ReadFolder(FolderPath, FolderInformation, 1, Pos, 0, BlocksRead) = 0 do
  begin
    with FolderInformation, FileInformation[0] do
    begin
      con_printf(    'File Name     = %s'#10, Name);
      with Attributes do
      begin
        con_printf(  'SizeLo        = %u'#10, Int64Rec(Size).Lo);
        con_printf(  'SizeHi        = %u'#10, Int64Rec(Size).Hi);
        with Modify.Date do
          con_printf('Modify Date   = %02d.%02d.%02d'#10, Day, Month, Year);
        with Modify.Time do
          con_printf('Modify Time   = %02d:%02d:%02d'#10, Hours, Minutes, Seconds);
        with Access.Date do
          con_printf('Access Date   = %02d.%02d.%02d'#10, Day, Month, Year);
        with Access.Time do
          con_printf('Access Time   = %02d:%02d:%02d'#10, Hours, Minutes, Seconds);
        with Creation.Date do
          con_printf('Creation Date = %02d.%02d.%02d'#10, Day, Month, Year);
        with Creation.Time do
          con_printf('Creation Time = %02d:%02d:%02d'#10, Hours, Minutes, Seconds);
        con_printf(  'Attributes    = 0x%08x'#10#10, Attributes);
      end;
    end;
    Inc(Pos);
  end;
end.
