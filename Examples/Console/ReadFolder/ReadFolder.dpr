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
      WriteLn('Folder "%s" contains %u files and/or folders.', [FolderPath, FileCount], 2)
  else
    WriteLn('Folder "%s" can not be read.', [FolderPath]);

  Pos := 0;
  while ReadFolder(FolderPath, FolderInformation, 1, Pos, 0, BlocksRead) = 0 do
  begin
    with FolderInformation, FileInformation[0] do
    begin
      WriteLn('FileName     = %s', [Name]);
      with Attributes do
      begin
        WriteLn(  'SizeLo        = %u', [TInt64Rec(Size).Lo]);
        WriteLn(  'SizeHi        = %u', [TInt64Rec(Size).Hi]);
        with Modify.Date do
          WriteLn('Modify Date   = %02d.%02d.%02d', [Day, Month, Year]);
        with Modify.Time do
          WriteLn('Modify Time   = %02d:%02d:%02d', [Hours, Minutes, Seconds]);
        with Access.Date do
          WriteLn('Access Date   = %02d.%02d.%02d', [Day, Month, Year]);
        with Access.Time do
          WriteLn('Access Time   = %02d:%02d:%02d', [Hours, Minutes, Seconds]);
        with Creation.Date do
          WriteLn('Creation Date = %02d.%02d.%02d', [Day, Month, Year]);
        with Creation.Time do
          WriteLn('Creation Time = %02d:%02d:%02d', [Hours, Minutes, Seconds]);
        WriteLn(  'Attributes    = 0x%08x', [Attributes]);
      end;
    end;
    WriteLn;
    Inc(Pos);
  end;
end.
