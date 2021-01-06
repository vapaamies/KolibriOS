program DrawImageApp;

uses
  KolibriOS;

type
  THeader = packed record
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
  end;

  PTargaFile = ^TTargaFile;
  TTargaFile = packed record
    Header: THeader;
  end;

procedure ExtractFileDirectory(Source, Dest: PKolibriChar); stdcall;
asm
        PUSH   ESI
        PUSH   EDI
        XOR    EAX, EAX
        MOV    EDI, Source
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
        MOV    EDI, Dest
        REP MOVSB
        MOV    byte [EDI], 0
        POP    EDI
        POP    ESI
end;

var
  WndLeft, WndTop, WndWidth, WndHeight: Integer;
  TargaFile: PTargaFile;
  Image: Pointer;
  FileSize: LongWord;

begin
  ExtractFileDirectory(AppPath, AppPath);
  SetCurrentDirectory(AppPath);

  TargaFile := LoadFile('Lena.tga', FileSize);

  with TargaFile^ do
    Image := Pointer(PKolibriChar(TargaFile) + SizeOf(Header) + Header.IDLength);

  with GetScreenSize do
  begin
    WndWidth := Width div 4;
    WndHeight := Height div 4;
    WndLeft := (Width  - WndWidth) div 2;
    WndTop := (Height - WndHeight) div 2;
  end;

  while True do
    case WaitEvent of
      REDRAW_EVENT:
        begin
          BeginDraw;
          DrawWindow(WndLeft, WndTop, WndWidth, WndHeight, 'Draw Image', $00FFFFFF,
            WS_SKINNED_FIXED + WS_CLIENT_COORDS + WS_CAPTION, CAPTION_MOVABLE);
          with TargaFile.Header do
            DrawImage(Image^, 30, 20, Width, Height);
          EndDraw;
        end;
      KEY_EVENT:
        GetKey;
      BUTTON_EVENT:
        if GetButton.ID = 1 then
          Break;
    end;
end.
