program ReadFolderApp;

uses
  KolibriOS, CRT;

type
  TInt64Rec = packed record
    Lo, Hi: LongWord;
  end;

const
  FolderPath = '/sys';

var
  FolderInformation: TFolderInformation;
  BlocksRead: LongWord;
  Pos: LongWord;

begin
  InitConsole('Read Folder', False);

  if ReadFolder(FolderPath, FolderInformation, 0, 0, 0, BlocksRead) = 0 then
    with FolderInformation do
      Write('Folder "%s" contains %u files and/or folders.'#10#10, FolderPath, FileCount)
  else
    Write('Folder "%s" can not be read.'#10, FolderPath);

  Pos := 0;
  while ReadFolder(FolderPath, FolderInformation, 1, Pos, 0, BlocksRead) = 0 do
  begin
    with FolderInformation, FileInformation[0] do
    begin
      Write('FileName     = %s'#10, Name);
      with Attributes do
      begin
        Write(  'SizeLo        = %u'#10, TInt64Rec(Size).Lo);
        Write(  'SizeHi        = %u'#10, TInt64Rec(Size).Hi);
        with Modify.Date do
          Write('Modify Date   = %02d.%02d.%02d'#10, Day, Month, Year);
        with Modify.Time do
          Write('Modify Time   = %02d:%02d:%02d'#10, Hours, Minutes, Seconds);
        with Access.Date do
          Write('Access Date   = %02d.%02d.%02d'#10, Day, Month, Year);
        with Access.Time do
          Write('Access Time   = %02d:%02d:%02d'#10, Hours, Minutes, Seconds);
        with Creation.Date do
          Write('Creation Date = %02d.%02d.%02d'#10, Day, Month, Year);
        with Creation.Time do
          Write('Creation Time = %02d:%02d:%02d'#10, Hours, Minutes, Seconds);
        Write(  'Attributes    = 0x%08x'#10, Attributes);
      end;
    end;
    Write(#10);
    Inc(Pos);
  end;
end.
