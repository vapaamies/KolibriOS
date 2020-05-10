Unit Unit1;
(* -------------------------------------------------------- *)
Interface
(* -------------------------------------------------------- *)
Uses KolibriOS;
(* -------------------------------------------------------- *)
Const
  AppPath = PPChar(32);
(* -------------------------------------------------------- *)
Type
  TTargaFileHeader = Packed Record
    IDLength:        Byte;
    ColorMapType:    Byte;
    ImageType:       Byte;
    CMapStart:       Word;
    CMapLength:      Word;
    CMapDepth:       Byte;
    XOffset:         Word;
    YOffset:         Word;
    Width:           Word;
    Height:          Word;
    PixelDepth:      Byte;
    ImageDescriptor: Byte;
  End;

  TTargaFile = Packed Record
    TargaFileHeader: TTargaFileHeader;
  End;

  PTargaFile = ^TTargaFile;
(* -------------------------------------------------------- *)
Var
  Window: TRect;
  Screen: TSize;
  TargaFile: PTargaFile;
  Image: Pointer;
(* -------------------------------------------------------- *)
Procedure Main;
Procedure On_Key;
Procedure On_Button;
Procedure On_Redraw;
Procedure ExtractFileDirectory(Src, Dst: PChar); StdCall;
(* -------------------------------------------------------- *)
Implementation
(* -------------------------------------------------------- *)
Procedure Main;
Var
  FileSize: Dword;
Begin
  HeapCreate;

  ExtractFileDirectory(AppPath^, AppPath^);
  SetCurrentDirectory(AppPath^);

  TargaFile := LoadFile('Lena.tga', FileSize);

  With TargaFile^ Do
    With TargaFileHeader Do
      Image := Pointer(Dword(TargaFile) + SizeOf(TargaFileHeader) + IDLength);

  Screen := GetScreenSize();

  With Window Do Begin
    With Screen Do Begin
      Right  := Width  Shr 2;
      Bottom := Height Shr 2;
      Left   := (Width  - Right)  Shr 1;
      Top    := (Height - Bottom) Shr 1;
    End;
  End;

  While TRUE Do Begin
    Case WaitEvent() Of
      REDRAW_EVENT: On_Redraw;
      KEY_EVENT:    On_Key;
      BUTTON_EVENT: On_Button;
    End;
  End;
End;
(* -------------------------------------------------------- *)
Procedure On_Redraw;
Begin
  BeginDraw;

  With Window Do
    DrawWindow(Left, Top, Right, Bottom, 'DrawImage', $00FFFFFF, WS_SKINNED_FIXED + WS_COORD_CLIENT + WS_CAPTION, CAPTION_MOVABLE);

  With TargaFile^ Do
    With TargaFileHeader Do
      DrawImage(Image^, 30, 20, Width, Height);

  EndDraw;
End;
(* -------------------------------------------------------- *)
Procedure On_Key;
Begin
  GetKey;
End;
(* -------------------------------------------------------- *)
Procedure On_Button;
Begin
  Case GetButton().ID Of
    1: ThreadTerminate;
  End;
End;
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
End.