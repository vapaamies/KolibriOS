Unit Unit1;
(* -------------------------------------------------------- *)
Interface
(* -------------------------------------------------------- *)
Uses KolibriOS;
(* -------------------------------------------------------- *)
Var
  hConsole: Pointer;
  ConsoleInit:       Procedure(WndWidth, WndHeight, ScrWidth, ScrHeight: Dword; Caption: PChar); StdCall;
  ConsoleExit:       Procedure(bCloseWindow: Cardinal); StdCall;
  printf:            Function(Const Format: PChar): Integer; CDecl VarArgs;
(* -------------------------------------------------------- *)
Procedure Main;
(* -------------------------------------------------------- *)
Implementation
(* -------------------------------------------------------- *)
Procedure Main;
Const
  FolderPath = '/sys';
Var
  FolderInformation: TFolderInformation;
  BlocksRead: Dword;
  Pos: Dword;
Begin
  hConsole          := LoadLibrary('/sys/lib/console.obj');
  ConsoleInit       := GetProcAddress(hConsole, 'con_init');
  ConsoleExit       := GetProcAddress(hConsole, 'con_exit');
  printf            := GetProcAddress(hConsole, 'con_printf');

  If ReadFolder(FolderPath, FolderInformation, 0, 0, 0, BlocksRead) = 0 Then
  Begin
    With FolderInformation Do Begin
      ConsoleInit($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, {11 printf In Loop}11 * FileCount + {2 printf below}2 + 1, 'ReadFolder');
      printf('Folder "%s" contains %u files and/or folders.'#10, FolderPath, FileCount);
      printf(#10);
    End;
  End
  Else
  Begin
    ConsoleInit($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, 'ReadFolder');
    printf('Folder "%s" can not be read.'#10, FolderPath);
  End;

  Pos := 0;
  While ReadFolder(FolderPath, FolderInformation, 1, Pos, 0, BlocksRead) = 0 Do Begin
    With FolderInformation Do Begin
      With FileInformation[0] Do Begin
        printf('FileName     = %s'#10, FileName);
        With FileAttributes Do Begin
          printf('SizeHi       = %u'#10, SizeHi);
          printf('SizeLo       = %u'#10, SizeLo);
          With ModifyDate   Do printf('ModifyDate   = %02d.%02d.%02d'#10, Day, Month, Year);
          With ModifyTime   Do printf('ModifyTime   = %02d:%02d:%02d'#10, Hours, Minutes, Seconds);
          With AccessDate   Do printf('AccessDate   = %02d.%02d.%02d'#10, Day, Month, Year);
          With AccessTime   Do printf('AccessTime   = %02d:%02d:%02d'#10, Hours, Minutes, Seconds);
          With CreationDate Do printf('CreationDate = %02d.%02d.%02d'#10, Day, Month, Year);
          With CreationTime Do printf('CreationTime = %02d:%02d:%02d'#10, Hours, Minutes, Seconds);
          printf('Attributes   = 0x%08x'#10, Attributes);
        End;
      End;
      printf(#10);
    End;
    Inc(Pos);
  End;

  ConsoleExit(0);
  ThreadTerminate;
End;
(* -------------------------------------------------------- *)
End.