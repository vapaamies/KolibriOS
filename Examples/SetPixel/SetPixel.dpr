program SetPixelApp;

uses
  KolibriOS;

var
  Left, Right, Top, Bottom: Integer;
  X, Y: Integer;

begin
  with GetScreenSize do
  begin
    Right := 180;
    Bottom := 180;
    Left := (Width - Right) div 2;
    Top := (Height - Bottom) div 2;
  end;

  while True do
    case WaitEvent of
      REDRAW_EVENT:
        begin
          BeginDraw;

          DrawWindow(Left, Top, Right, Bottom, 'Set Pixel', $00FFFFFF,
            WS_SKINNED_FIXED + WS_CLIENT_COORDS + WS_CAPTION, CAPTION_MOVABLE);

          for Y := 0 to 50 do
            for X := 0 to 50 do
              if ((X mod 2) = 0) or ((Y mod 2) = 0) then
                SetPixel(X, Y, $00FF0000);

          for Y := 50 to 100 do
            for X := 50 to 100 do
              if ((X mod 3) = 0) or ((Y mod 3) = 0) then
                SetPixel(X, Y, $00007F00);

          for Y := 100 to 150 do
            for X := 100 to 150 do
              if ((X mod 4) = 0) or ((Y mod 4) = 0) then
                SetPixel(X, Y, $000000FF);

          EndDraw;
        end;
      KEY_EVENT:
        GetKey;
      BUTTON_EVENT:
        if GetButton.ID = 1 then
          TerminateThread;
    end;
end.
