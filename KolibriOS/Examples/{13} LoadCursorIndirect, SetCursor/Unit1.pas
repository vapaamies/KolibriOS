Unit Unit1;
(* -------------------------------------------------------- *)
Interface
(* -------------------------------------------------------- *)
Uses KolibriOS;
(* -------------------------------------------------------- *)
Const
  AppPath = PPChar(32);

  ARROW_BUTTON = 2;
  POINT_BUTTON = 3;
  WAIT_BUTTON  = 4;

(* -------------------------------------------------------- *)
Type
  TBitmapFileHeader = Packed Record
    bfType:      Word;
    bfSize:      Dword;
    bfReserved1: Word;
    bfReserved2: Word;
    bfOffBits:   Dword;
  End;

  TBitmapInfoHeader = Packed Record
    biSize:          Dword;
    biWidth:         Longint;
    biHeight:        Longint;
    biPlanes:        Word;
    biBitCount:      Word;
    biCompression:   Dword;
    biSizeImage:     Dword;
    biXPelsPerMeter: Longint;
    biYPelsPerMeter: Longint;
    biClrUsed:       Dword;
    biClrImportant:  Dword;
  End;

  TBitmapFile = Packed Record
    BitmapFileHeader: TBitmapFileHeader;
    BitmapInfoHeader: TBitmapInfoHeader;
  End;

  PBitmapFile = ^TBitmapFile;
(* -------------------------------------------------------- *)
Var
  Window: TRect;
  Screen: TSize;

  ArrowBitmapFile,
  PointBitmapFile,
  WaitBitmapFile: PBitmapFile;

  ArrowBitmap,
  PointBitmap,
  WaitBitmap: Pointer;

  hArrowCursor,
  hPointCursor,
  hWaitCursor: Dword;

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

  ArrowBitmapFile := LoadFile('arrow.bmp', FileSize);
  PointBitmapFile := LoadFile('point.bmp', FileSize);
  WaitBitmapFile  := LoadFile('wait.bmp', FileSize);

  ArrowBitmap    := Pointer(Dword(ArrowBitmapFile) + ArrowBitmapFile^.BitmapFileHeader.bfOffBits);
  PointBitmap    := Pointer(Dword(PointBitmapFile) + PointBitmapFile^.BitmapFileHeader.bfOffBits);
  WaitBitmap     := Pointer(Dword(WaitBitmapFile)  + WaitBitmapFile^.BitmapFileHeader.bfOffBits);

  hArrowCursor := LoadCursorIndirect(ArrowBitmap^, 0, 0);
  hPointCursor := LoadCursorIndirect(PointBitmap^, 12, 0);
  hWaitCursor  := LoadCursorIndirect(WaitBitmap^, 0, 0);

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
    DrawWindow(Left, Top, Right, Bottom, 'LoadCursorIndirect', $00FFFFFF, WS_SKINNED_FIXED + WS_COORD_CLIENT + WS_CAPTION, CAPTION_MOVABLE);

  DrawText( 8, 8, 'Click on picture buttons', 0, $00FFFFFF, DT_CP866_8X16 + DT_FILL_OPAQUE + DT_ZSTRING, 0);
  DrawText( 8, 25, 'below to select cursor:', 0, $00FFFFFF, DT_CP866_8X16 + DT_FILL_OPAQUE + DT_ZSTRING, 0);

  DrawButton(8, 40, 32, 32, 0, BS_FILL_TRANSPARENT, ARROW_BUTTON);
  DrawButton(52, 40, 32, 32, 0, BS_FILL_TRANSPARENT, POINT_BUTTON);
  DrawButton(96, 40, 32, 32, 0, BS_FILL_TRANSPARENT, WAIT_BUTTON );

  Blit(ArrowBitmap^, 0, 0, 32, 32, 8, 40, 32, 32, 32*4, BLIT_CLIENT_RELATIVE);
  Blit(PointBitmap^, 0, 0, 32, 32, 52, 40, 32, 32, 32*4, BLIT_CLIENT_RELATIVE);
  Blit(WaitBitmap^, 0, 0, 32, 32, 96, 40, 32, 32, 32*4, BLIT_CLIENT_RELATIVE);

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
    1:            ThreadTerminate;
    ARROW_BUTTON: SetCursor(hArrowCursor);
    POINT_BUTTON: SetCursor(hPointCursor);
    WAIT_BUTTON:  SetCursor(hWaitCursor);
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