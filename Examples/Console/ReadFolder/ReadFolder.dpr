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
      WriteLnEx('Folder "%s" contains %u files and/or folders.', [FolderPath, FileCount], 2)
  else
    WriteLnEx('Folder "%s" can not be read.', [FolderPath]);

  Pos := 0;
  while ReadFolder(FolderPath, FolderInformation, 1, Pos, 0, BlocksRead) = 0 do
  begin
    with FolderInformation, FileInformation[0] do
    begin
      WriteLnEx('FileName     = %s', [Name]);
      with Attributes do
      begin
        WriteLnEx(  'SizeLo        = %u', [Int64Rec(Size).Lo]);
        WriteLnEx(  'SizeHi        = %u', [Int64Rec(Size).Hi]);
        with Modify.Date do
          WriteLnEx('Modify Date   = %02d.%02d.%02d', [Day, Month, Year]);
        with Modify.Time do
          WriteLnEx('Modify Time   = %02d:%02d:%02d', [Hours, Minutes, Seconds]);
        with Access.Date do
          WriteLnEx('Access Date   = %02d.%02d.%02d', [Day, Month, Year]);
        with Access.Time do
          WriteLnEx('Access Time   = %02d:%02d:%02d', [Hours, Minutes, Seconds]);
        with Creation.Date do
          WriteLnEx('Creation Date = %02d.%02d.%02d', [Day, Month, Year]);
        with Creation.Time do
          WriteLnEx('Creation Time = %02d:%02d:%02d', [Hours, Minutes, Seconds]);
        WriteLnEx(  'Attributes    = 0x%08x', [Attributes]);
      end;
    end;
    WriteLnEx;
    Inc(Pos);
  end;
end.
