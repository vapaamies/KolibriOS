program SetCursorApp;

uses
  KolibriOS;

const
  ARROW_BUTTON = 2;
  POINT_BUTTON = 3;
  WAIT_BUTTON  = 4;

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

  PBitmapFile = ^TBitmapFile;
  TBitmapFile = packed record
    BitmapFileHeader: TBitmapFileHeader;
    BitmapInfoHeader: TBitmapInfoHeader;
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

  ArrowBitmapFile, PointBitmapFile, WaitBitmapFile: PBitmapFile;
  ArrowBitmap, PointBitmap, WaitBitmap: Pointer;
  hArrowCursor, hPointCursor, hWaitCursor: THandle;

  FileSize: LongWord;

begin
  HeapInit;

  ExtractFileDirectory(AppPath, AppPath);
  SetCurrentDirectory(AppPath);

  ArrowBitmapFile := LoadFile('arrow.bmp', FileSize);
  PointBitmapFile := LoadFile('point.bmp', FileSize);
  WaitBitmapFile  := LoadFile('wait.bmp', FileSize);

  ArrowBitmap    := Pointer(LongWord(ArrowBitmapFile) + ArrowBitmapFile.BitmapFileHeader.bfOffBits);
  PointBitmap    := Pointer(LongWord(PointBitmapFile) + PointBitmapFile.BitmapFileHeader.bfOffBits);
  WaitBitmap     := Pointer(LongWord(WaitBitmapFile)  + WaitBitmapFile.BitmapFileHeader.bfOffBits);

  hArrowCursor := LoadCursorIndirect(ArrowBitmap^, 0, 0);
  hPointCursor := LoadCursorIndirect(PointBitmap^, 12, 0);
  hWaitCursor  := LoadCursorIndirect(WaitBitmap^, 0, 0);

  with GetScreenSize do
  begin
    WndWidth := Width div 4;
    WndHeight := Height div 4;
    WndLeft := (Width - WndWidth) div 2;
    WndTop := (Height - WndHeight) div 2;
  end;

  while True do
    case WaitEvent of
      REDRAW_EVENT:
        begin
          BeginDraw;

          DrawWindow(WndLeft, WndTop, WndWidth, WndHeight, 'Set Cursor', $00FFFFFF,
            WS_SKINNED_FIXED + WS_CLIENT_COORDS + WS_CAPTION, CAPTION_MOVABLE);

          DrawText( 8, 8, 'Click on picture buttons', 0, $00FFFFFF, DT_CP866_8x16 + DT_FILL_OPAQUE + DT_ZSTRING, 0);
          DrawText( 8, 25, 'below to select cursor:', 0, $00FFFFFF, DT_CP866_8x16 + DT_FILL_OPAQUE + DT_ZSTRING, 0);

          DrawButton(8, 40, 32, 32, 0, BS_TRANSPARENT_FILL, ARROW_BUTTON);
          DrawButton(52, 40, 32, 32, 0, BS_TRANSPARENT_FILL, POINT_BUTTON);
          DrawButton(96, 40, 32, 32, 0, BS_TRANSPARENT_FILL, WAIT_BUTTON );

          Blit(ArrowBitmap^, 0, 0, 32, 32, 8, 40, 32, 32, 32*4, BLIT_CLIENT_RELATIVE);
          Blit(PointBitmap^, 0, 0, 32, 32, 52, 40, 32, 32, 32*4, BLIT_CLIENT_RELATIVE);
          Blit(WaitBitmap^, 0, 0, 32, 32, 96, 40, 32, 32, 32*4, BLIT_CLIENT_RELATIVE);

          EndDraw;
        end;
      KEY_EVENT:
        GetKey;
      BUTTON_EVENT:
        case GetButton.ID of
          ARROW_BUTTON:
            SetCursor(hArrowCursor);
          POINT_BUTTON:
            SetCursor(hPointCursor);
          WAIT_BUTTON:
            SetCursor(hWaitCursor);
          1:
            Break;
        end;
    end;
end.
