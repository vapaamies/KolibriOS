program Screenshot;

uses
  KolibriOS;

type
  TRGBTriple = packed record
    Blue:  Byte;
    Green: Byte;
    Red:   Byte;
  end;

  PRGBTripleArray = ^TRGBTripleArray;
  TRGBTripleArray = array[0..0] of TRGBTriple;

var
  WndLeft, WndTop, WndWidth, WndHeight: Integer;
  ScreenSize: TSize;
  Image, Preview: PRGBTripleArray;

function Red(A, B: LongWord): LongWord;
begin
  Red := Image[(ScreenSize.Width * B  + A)].Red;
end;

function Green(A, B: LongWord): LongWord;
begin
  Green := Image[(ScreenSize.Width * B  + A)].Green;
end;

function Blue(A, B: LongWord): LongWord;
begin
  Blue := Image[(ScreenSize.Width * B  + A)].Blue;
end;

procedure ResizeImage;
var
  A, B, I: LongWord;
begin
  A := 0;
  while A < ScreenSize.Width do
  begin
    B := 0;
    while B < ScreenSize.Height do
    begin
      I := ((ScreenSize.Width div 2) * B + A) div 2;
      Preview[i].Red := (Red(A, B) + Red(A+ 1, B) + Red(A, B + 1) + Red(A + 1, B + 1)) div 4;
      Preview[i].Green := (Green(A, B) + Green(A + 1, B) + Green(A, B + 1) + Green(A + 1, B + 1)) div 4;
      Preview[i].Blue := (Blue(A, B) + Blue(A + 1, B) + Blue(A, B + 1) + Blue(A + 1, B + 1)) div 4;
      Inc(B, 2);
    end;
    Inc(A, 2);
  end;
end;

begin
  HeapInit;

  ScreenSize := GetScreenSize;

  with ScreenSize do
  begin
    WndWidth := WINDOW_BORDER_SIZE * 2 + Width  div 2 - 1;
    WndHeight := WINDOW_BORDER_SIZE + GetSkinHeight + Height div 2 - 1;
    WndLeft := (Width  - WndWidth) div 2;
    WndTop  := (Height - WndHeight) div 2;

    Image := HeapAllocate(Width * Height * 3);
    Preview := HeapAllocate(Width * Height * 3 div 4);

    GetScreenImage(Image^, 0, 0, Width, Height);
    ResizeImage;
  end;

  while True do
    case WaitEvent of
      REDRAW_EVENT:
        begin
          BeginDraw;
          DrawWindow(WndLeft, WndTop, WndWidth, WndHeight, 'Screenshot', $00FFFFFF,
            WS_SKINNED_FIXED + WS_CLIENT_COORDS + WS_CAPTION + WS_TRANSPARENT_FILL, CAPTION_MOVABLE);
          with ScreenSize do
            DrawImage(Preview^, 0, 0, Width div 2, Height div 2);
          EndDraw;
        end;
      KEY_EVENT:
        GetKey;
      BUTTON_EVENT:
        if GetButton.ID = 1 then
          Break;
    end;
end.
