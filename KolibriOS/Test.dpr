Program Test;
(* -------------------------------------------------------- *)
Uses KolibriOS;
(* -------------------------------------------------------- *)
Type
  PPChar = ^PChar;
(* -------------------------------------------------------- *)
Const
  AppPath                = PPChar(32);
  CmdLine                = PPChar(28);
  CURRENT_DIRECTORY_SIZE = 1024;
(* -------------------------------------------------------- *)
Var
  hConsole:         Pointer;
  ConsoleInit:      Procedure(WndWidth, WndHeight, ScrWidth, ScrHeight: Dword; Caption: PChar); StdCall;
  ConsoleExit:      Procedure(bCloseWindow: Boolean); StdCall;
  Printf:           Function(Const Format: PChar): Integer; CDecl VarArgs;
  GetCh:            Function(): Char; StdCall;
  CurrentDirectory: Array[0..CURRENT_DIRECTORY_SIZE - 1] Of Char;
  BytesRead:        Dword;
  BytesWritten:     Dword;
  FileAttributes:   TFileAttributes;
  FileBuffer:       Pointer;
  Res:              LongInt;
(* -------------------------------------------------------- *)
Procedure ExtractFileDirectory(Src, Dst: PChar); StdCall;
Asm
        push   esi
        push   edi
        xor    eax, eax
        mov    edi, Src
        mov    esi, edi
        mov    ecx, $FFFFFFFF
        repne scasb
        mov    al, '/'
        std
        repne scasb
        cld
        sub    edi, esi
        mov    ecx, edi
        inc    ecx
        mov    edi, Dst
        rep movsb
        mov    byte [edi], 0
        pop    edi
        pop    esi
End;
(* -------------------------------------------------------- *)
Procedure WaitKeyAndExit;
Begin
  Printf(#10'Press key to exit ...');
  GetCh;
  ConsoleExit(TRUE);
  ThreadTerminate;
End;
(* -------------------------------------------------------- *)
Begin
   hConsole    := LoadLibrary('/sys/lib/console.obj');
   ConsoleInit := GetProcAddress(hConsole, 'con_init');
   ConsoleExit := GetProcAddress(hConsole, 'con_exit');
   Printf      := GetProcAddress(hConsole, 'con_printf');
   GetCh       := GetProcAddress(hConsole, 'con_getch');

   ConsoleInit($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, AppPath^);

   GetCurrentDirectory(CurrentDirectory, CURRENT_DIRECTORY_SIZE);

   Printf('AppPath = "%s"'#10, AppPath^);
   Printf('CmdLine = "%s"'#10, CmdLine^);
   Printf('CurrentDirectory = "%s"'#10, CurrentDirectory);

   ExtractFileDirectory(AppPath^, CurrentDirectory);
   SetCurrentDirectory(CurrentDirectory);

   Printf('Set current directory to "%s"'#10, CurrentDirectory);

   GetCurrentDirectory(CurrentDirectory, CURRENT_DIRECTORY_SIZE);
   Printf('CurrentDirectory = "%s"'#10, CurrentDirectory);

   Res := GetFileAttributes(AppPath^, FileAttributes);
   If Res = 0 Then
     Printf('File size = %d bytes'#10, FileAttributes.SizeLo)
   Else Begin
     Printf('GetFileAttributes error = %d'#10, Res);
     WaitKeyAndExit;
   End;

   FileBuffer := HeapAllocate(FileAttributes.SizeLo);

   Res := ReadFile(AppPath^, FileBuffer^, FileAttributes.SizeLo, 0, 0, BytesRead);
   If Res = 0 Then
     Printf('ReadFile success, BytesRead = %d bytes'#10, BytesRead)
   Else Begin
     Printf('ReadFile error = %d'#10, Res);
     WaitKeyAndExit;
   End;

   Res := CreateFolder('NewFolder');
   If Res = 0 Then
     Printf('CreateFolder success.'#10)
   Else Begin
     Printf('CreateFolder error = %d'#10, Res);
     WaitKeyAndExit;
   End;

   SetCurrentDirectory('./NewFolder');

   Res := CreateFile('CopyOfProgramFile.kex');
   If Res = 0 Then
     Printf('CreateFile success.'#10)
   Else Begin
     Printf('CreateFile error = %d'#10, Res);
     WaitKeyAndExit;
   End;

   Res := WriteFile('CopyOfProgramFile.kex', FileBuffer^, FileAttributes.SizeLo, 0, 0, BytesWritten);
   If Res = 0 Then
     Printf('WriteFile success, BytesWritten = %d bytes'#10, BytesWritten)
   Else Begin
     Printf('WriteFile error = %d'#10, Res);
     WaitKeyAndExit;
   End;

   HeapFree(FileBuffer);

   WaitKeyAndExit;
End.