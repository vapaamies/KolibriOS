program Screenshot;

uses
  KolibriOS;

const
  BORDER_SIZE = 5;

type
  TRGBTriple = packed record
    Blue:  Byte;
    Green: Byte;
    Red:   Byte;
  end;

  PRGBTripleArray = ^TRGBTripleArray;
  TRGBTripleArray = array[0..0] of TRGBTriple;

var
  Left, Right, Top, Bottom: Integer;
  Screen: TSize;
  Image, Preview: PRGBTripleArray;

function Red(A, B: LongWord): LongWord;
begin
  Red := Image[(Screen.Width * B  + A)].Red;
end;

function Green(A, B: LongWord): LongWord;
begin
  Green := Image[(Screen.Width * B  + A)].Green;
end;

function Blue(A, B: LongWord): LongWord;
begin
  Blue := Image[(Screen.Width * B  + A)].Blue;
end;

procedure ResizeImage;
var
  A, B, I: LongWord;
begin
  A := 0;
  while A < Screen.Width do
  begin
    B := 0;
    while B < Screen.Height do
    begin
      I := ((Screen.Width div 2) * B + A) div 2;
      Preview[i].Red := (Red(A, B) + Red(B + 1, B) + Red(A, B + 1) + Red(A + 1, B + 1)) div 4;
      Preview[i].Green := (Green(A, B) + Green(A + 1, B) + Green(A, B + 1) + Green(A + 1, B + 1)) div 4;
      Preview[i].Blue := (Blue(A, B) + Blue(A + 1, B) + Blue(A, B + 1) + Blue(A + 1, B + 1)) div 4;
      Inc(B, 2);
    end;
    Inc(B, 2);
  end;
end;

begin
  HeapCreate;

  Screen := GetScreenSize;

  with Screen do
  begin
    Right := BORDER_SIZE * 2 + Width  div 2 - 1;
    Bottom := BORDER_SIZE + GetSkinHeight + Height div 2 - 1;
    Left := (Width  - Right) div 2;
    Top  := (Height - Bottom) div 2;

    Image := HeapAllocate(Width * Height * 3);
    Preview := HeapAllocate(Width * Height * 3 div 2);

    GetScreenImage(Image^, 0, 0, Width, Height);
    ResizeImage;
  end;

  while True do
    case WaitEvent of
      REDRAW_EVENT:
        begin
          BeginDraw;
          DrawWindow(Left, Top, Right, Bottom, 'Screenshot', $00FFFFFF,
            WS_SKINNED_FIXED + WS_COORD_CLIENT + WS_CAPTION + WS_FILL_TRANSPARENT, CAPTION_MOVABLE);
          with Screen do
            DrawImage(Preview^, 0, 0, Width div 2, Height div 2);
          EndDraw;
        end;
      KEY_EVENT:
        GetKey;
      BUTTON_EVENT:
        if GetButton.ID = 1 then
          TerminateThread;
    end;
end.
