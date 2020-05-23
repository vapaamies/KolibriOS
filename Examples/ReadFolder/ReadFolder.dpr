program ReadFolderApp;

uses
  KolibriOS;

type
  TInt64Rec = packed record
    Lo, Hi: LongWord;
  end;

var
  hConsole: Pointer;
  ConsoleInit:       procedure(WndWidth, WndHeight, ScrWidth, ScrHeight: LongWord; Caption: PKolibriChar); stdcall;
  ConsoleExit:       procedure(bCloseWindow: Cardinal); stdcall;
  printf:            function(const Format: PKolibriChar): Integer; cdecl varargs;

const
  FolderPath = '/sys';

var
  FolderInformation: TFolderInformation;
  BlocksRead: LongWord;
  Pos: LongWord;

begin
  hConsole          := LoadLibrary('/sys/lib/console.obj');
  ConsoleInit       := GetProcAddress(hConsole, 'con_init');
  ConsoleExit       := GetProcAddress(hConsole, 'con_exit');
  printf            := GetProcAddress(hConsole, 'con_printf');

  if ReadFolder(FolderPath, FolderInformation, 0, 0, 0, BlocksRead) = 0 then
    with FolderInformation do
    begin
      ConsoleInit($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, {11 printf In Loop}11 * FileCount + {2 printf below}2 + 1, 'ReadFolder');
      printf('Folder "%s" contains %u files and/or folders.'#10, FolderPath, FileCount);
      printf(#10);
    end
  else
  begin
    ConsoleInit($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, 'ReadFolder');
    printf('Folder "%s" can not be read.'#10, FolderPath);
  end;

  Pos := 0;
  while ReadFolder(FolderPath, FolderInformation, 1, Pos, 0, BlocksRead) = 0 do
  begin
    with FolderInformation, FileInformation[0] do
    begin
      printf('FileName     = %s'#10, Name);
      with Attributes do
      begin
        printf('SizeLo       = %u'#10, TInt64Rec(Size).Lo);
        printf('SizeHi       = %u'#10, TInt64Rec(Size).Hi);
        with Modify.Date   do printf('modifyDate   = %02d.%02d.%02d'#10, Day, Month, Year);
        with Modify.Time   do printf('modifyTime   = %02d:%02d:%02d'#10, Hours, Minutes, Seconds);
        with Access.Date   do printf('AccessDate   = %02d.%02d.%02d'#10, Day, Month, Year);
        with Access.Time   do printf('AccessTime   = %02d:%02d:%02d'#10, Hours, Minutes, Seconds);
        with Creation.Date do printf('CreationDate = %02d.%02d.%02d'#10, Day, Month, Year);
        with Creation.Time do printf('CreationTime = %02d:%02d:%02d'#10, Hours, Minutes, Seconds);
        printf('Attributes   = 0x%08x'#10, Attributes);
      end;
    end;
    printf(#10);
    Inc(Pos);
  end;

  ConsoleExit(0);
  TerminateThread;
end.
