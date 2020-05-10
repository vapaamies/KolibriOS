Unit Unit1;
(* -------------------------------------------------------- *)
Interface
(* -------------------------------------------------------- *)
Uses KolibriOS;
(* -------------------------------------------------------- *)
Const
  AppPath = PPChar(32);
  Picture1 = 'Flower(4bpp).bmp';
  Picture2 = 'Mario(1bpp).bmp';
  Picture3 = 'House(24bpp).bmp';
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

  TRGBQuad = Packed Record
    Blue:     Byte;
    Green:    Byte;
    Red:      Byte;
    reserved: Byte;
  end;

  TBitmapFile = Packed Record
    BitmapFileHeader: TBitmapFileHeader;
    BitmapInfoHeader: TBitmapInfoHeader;
    Palette:          Packed Array[0..0] Of TRGBQuad;
  End;

  PBitmapFile = ^TBitmapFile;
(* -------------------------------------------------------- *)
Var
  Window: TRect;
  Screen: TSize;
  BitmapFile1: PBitmapFile;
  BitmapFile2: PBitmapFile;
  BitmapFile3: PBitmapFile;
  Image1: Pointer;
  Image2: Pointer;
  Image3: Pointer;
  Padding1: Dword;
  Padding2: Dword;
  Padding3: Dword;
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
  BytesRead: Dword;
  FileAttributes: TFileAttributes;
Begin
  HeapCreate;

  ExtractFileDirectory(AppPath^, AppPath^);
  SetCurrentDirectory(AppPath^);


  GetFileAttributes(Picture1, FileAttributes);
  BitmapFile1 := HeapAllocate(FileAttributes.SizeLo);
  ReadFile(Picture1, BitmapFile1^, FileAttributes.SizeLo, 0, 0, BytesRead);

  With BitmapFile1^ Do
    With BitmapFileHeader Do
      With BitmapInfoHeader Do Begin
        Padding1 := (32 - biWidth * biBitCount Mod 32) And Not 32 Shr 3;
        Image1 := Pointer(Dword(BitmapFile1) + bfOffBits);
      End;


  GetFileAttributes(Picture2, FileAttributes);
  BitmapFile2 := HeapAllocate(FileAttributes.SizeLo);
  ReadFile(Picture2, BitmapFile2^, FileAttributes.SizeLo, 0, 0, BytesRead);

  With BitmapFile2^ Do
    With BitmapFileHeader Do
      With BitmapInfoHeader Do Begin
        Padding2 := (32 - biWidth * biBitCount Mod 32) And Not 32 Shr 3;
        Image2 := Pointer(Dword(BitmapFile2) + bfOffBits);
      End;


  GetFileAttributes(Picture3, FileAttributes);
  BitmapFile3 := HeapAllocate(FileAttributes.SizeLo);
  ReadFile(Picture3, BitmapFile3^, FileAttributes.SizeLo, 0, 0, BytesRead);

  With BitmapFile3^ Do
    With BitmapFileHeader Do
      With BitmapInfoHeader Do Begin
        Padding3 := (32 - biWidth * biBitCount Mod 32) And Not 32 Shr 3;
        Image3 := Pointer(Dword(BitmapFile3) + bfOffBits);
      End;

  Screen := GetScreenSize();

  With Window Do Begin
    With Screen Do Begin
      Right  := 340;
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
    DrawWindow(Left, Top, Right, Bottom, 'DrawImageEx', $00FFFFFF, WS_SKINNED_FIXED + WS_COORD_CLIENT + WS_CAPTION, CAPTION_MOVABLE);

  (* these image files was saved with 'flip row order' parameter *)
  (* therefore they have negative biHeight field *)
  (* also it is possible to use Nil instead of @Palette if you sure palette is absent *)

  With BitmapFile1^ Do
    With BitmapFileHeader Do
      With BitmapInfoHeader Do
        DrawImageEx(Image1^, 20, 35, biWidth, -biHeight, biBitCount, @Palette, Padding1);

  With BitmapFile2^ Do
    With BitmapFileHeader Do
      With BitmapInfoHeader Do
        DrawImageEx(Image2^, 120, 35, biWidth, -biHeight, biBitCount, @Palette, Padding2);

  With BitmapFile3^ Do
    With BitmapFileHeader Do
      With BitmapInfoHeader Do
        DrawImageEx(Image3^, 220, 45, biWidth, -biHeight, biBitCount, @Palette, Padding3);

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