program DrawImageApp;

uses
  KolibriOS;

const
  AppPath = PPChar(32);

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

procedure ExtractFileDirectory(Source, Dest: PChar); stdcall;
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
  Left, Right, Top, Bottom: Integer;
  TargaFile: PTargaFile;
  Image: Pointer;
  FileSize: LongWord;

begin
  HeapCreate;

  ExtractFileDirectory(AppPath^, AppPath^);
  SetCurrentDirectory(AppPath^);

  TargaFile := LoadFile('Lena.tga', FileSize);

  with TargaFile^ do
    Image := Pointer(PChar(TargaFile) + SizeOf(Header) + Header.IDLength);

  with GetScreenSize do
  begin
    Right := Width div 4;
    Bottom := Height div 4;
    Left := (Width  - Right) div 2;
    Top := (Height - Bottom) div 2;
  end;

  while True do
    case WaitEvent of
      REDRAW_EVENT:
        begin
          BeginDraw;
          DrawWindow(Left, Top, Right, Bottom, 'Draw Image', $00FFFFFF,
            WS_SKINNED_FIXED + WS_COORD_CLIENT + WS_CAPTION, CAPTION_MOVABLE);
          with TargaFile.Header do
            DrawImage(Image^, 30, 20, Width, Height);
          EndDraw;
        end;
      KEY_EVENT:
        GetKey;
      BUTTON_EVENT:
        if GetButton.ID = 1 then
          TerminateThread;
    end;
end.
