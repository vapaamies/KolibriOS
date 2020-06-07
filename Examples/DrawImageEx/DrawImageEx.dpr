program DrawImageExApp;

uses
  KolibriOS;

const
  AppPath = PPKolibriChar(32);

  Picture1 = 'Flower(4bpp).bmp';
  Picture2 = 'Mario(1bpp).bmp';
  Picture3 = 'House(24bpp).bmp';

type
  TBitmapFileHeader = packed record
    bfType:      Word;
    bfSize:      LongWord;
    bfReserved1: Word;
    bfReserved2: Word;
    bfOffBits:   LongWord;
  end;

  TBitmapInfoHeader = packed record
    biSize:          LongWord;
    biWidth:         LongInt;
    biHeight:        LongInt;
    biPlanes:        Word;
    biBitCount:      Word;
    biCompression:   LongWord;
    biSizeImage:     LongWord;
    biXPelsPerMeter: LongInt;
    biYPelsPerMeter: LongInt;
    biClrUsed:       LongWord;
    biClrImportant:  LongWord;
  end;

  TRGBQuad = packed record
    Blue:     Byte;
    Green:    Byte;
    Red:      Byte;
    Reserved: Byte;
  end;

  PBitmapFile = ^TBitmapFile;
  TBitmapFile = packed record
    BitmapFileHeader: TBitmapFileHeader;
    BitmapInfoHeader: TBitmapInfoHeader;
    Palette: array[0..0] of TRGBQuad;
  end;

procedure ExtractFileDirectory(Src, Dst: PKolibriChar); stdcall;
asm
        PUSH   ESI
        PUSH   EDI
        XOR    EAX, EAX
        MOV    EDI, Src
        MOV    ESI, EDI
        MOV    ECX, $FFFFFFFF
        REPNE SCASB
        MOV    AL, '/'
        STD
        REPNE SCASB
        CLD
        SUB    EDI, ESI
        MOV    ECX, EDI
        INC    ECX
        MOV    EDI, Dst
        REP MOVSB
        MOV    BYTE [EDI], 0
        POP    EDI
        POP    ESI
end;

var
  WndLeft, WndTop, WndWidth, WndHeight: Integer;
  BitmapFile1, BitmapFile2, BitmapFile3: PBitmapFile;
  Image1, Image2, Image3: Pointer;
  Padding1, Padding2, Padding3: LongWord;
  BytesRead: LongWord;
  FileAttributes: TFileAttributes;

begin
  HeapInit;

  ExtractFileDirectory(AppPath^, AppPath^);
  SetCurrentDirectory(AppPath^);

  GetFileAttributes(Picture1, FileAttributes);
  BitmapFile1 := HeapAllocate(FileAttributes.Size);
  ReadFile(Picture1, BitmapFile1^, FileAttributes.Size, 0, BytesRead);

  with BitmapFile1^, BitmapFileHeader, BitmapInfoHeader do
  begin
    Padding1 := (32 - biWidth * biBitCount mod 32) and not 32 div 8;
    Image1 := Pointer(LongWord(BitmapFile1) + bfOffBits);
  end;

  GetFileAttributes(Picture2, FileAttributes);
  BitmapFile2 := HeapAllocate(FileAttributes.Size);
  ReadFile(Picture2, BitmapFile2^, FileAttributes.Size, 0, BytesRead);

  with BitmapFile2^, BitmapFileHeader, BitmapInfoHeader do
  begin
    Padding2 := (32 - biWidth * biBitCount mod 32) and not 32 div 8;
    Image2 := Pointer(LongWord(BitmapFile2) + bfOffBits);
  end;

  GetFileAttributes(Picture3, FileAttributes);
  BitmapFile3 := HeapAllocate(FileAttributes.Size);
  ReadFile(Picture3, BitmapFile3^, FileAttributes.Size, 0, BytesRead);

  with BitmapFile3^, BitmapFileHeader, BitmapInfoHeader do
  begin
    Padding3 := (32 - biWidth * biBitCount mod 32) and not 32 div 8;
    Image3 := Pointer(LongWord(BitmapFile3) + bfOffBits);
  end;

  with GetScreenSize do
  begin
    WndWidth := 340;
    WndHeight := Height div 4;
    WndLeft := (Width  - WndWidth) div 2;
    WndTop := (Height - WndHeight) div 2;
  end;

  while True do
    case WaitEvent of
      REDRAW_EVENT:
        begin
          BeginDraw;

          DrawWindow(WndLeft, WndTop, WndWidth, WndHeight, 'Draw Image Extended', $00FFFFFF,
            WS_SKINNED_FIXED + WS_CLIENT_COORDS + WS_CAPTION, CAPTION_MOVABLE);

          (* these image files was saved with 'flip row order' parameter *)
          (* therefore they have negative biHeight field *)
          (* also it is possible to use Nil instead of @Palette if you sure palette is absent *)

          with BitmapFile1^, BitmapFileHeader, BitmapInfoHeader do
            DrawImageEx(Image1^, 20, 35, biWidth, -biHeight, biBitCount, @Palette, Padding1);
          with BitmapFile2^, BitmapFileHeader, BitmapInfoHeader do
            DrawImageEx(Image2^, 120, 35, biWidth, -biHeight, biBitCount, @Palette, Padding2);
          with BitmapFile3^, BitmapFileHeader, BitmapInfoHeader do
            DrawImageEx(Image3^, 220, 45, biWidth, -biHeight, biBitCount, @Palette, Padding3);

          EndDraw;
        end;
      KEY_EVENT:
        GetKey;
      BUTTON_EVENT:
        if GetButton.ID = 1 then
          Break;
    end;
end.
