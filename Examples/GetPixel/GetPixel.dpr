program GetPixelApp;

uses
  KolibriOS;

var
  Window, Rectangle: TRect;
  Point: TPoint;
begin
  with Window, GetScreenSize do
  begin
    Right := Width div 4;
    Bottom := Height div 4;
    Left := (Width  - Right) div 2;
    Top := (Height - Bottom) div 2;
  end;

  with Rectangle do
  begin
    Left := 10;
    Top := 10;
    Right := Window.Right - 20;
    Bottom := Window.Bottom - 40;
  end;

  SetEventMask(EM_REDRAW + EM_BUTTON + EM_MOUSE);

  while True do
    case WaitEvent of
      REDRAW_EVENT:
        begin
          BeginDraw;

          with Window do
            DrawWindow(Left, Top, Right, Bottom, 'Get Pixel', $00FFFFFF,
              WS_SKINNED_FIXED + WS_CLIENT_COORDS + WS_CAPTION, CAPTION_MOVABLE);

          with Rectangle do
          begin
            DrawLine(Left, Top, Left, Bottom, 0);
            DrawLine(Right, Top, Right, Bottom, 0);
            DrawLine(Left, Top, Right, Top, 0);
            DrawLine(Left, Bottom, Right, Bottom, 0);
          end;

          EndDraw;
        end;
      MOUSE_EVENT:
        begin
          Point := GetMousePos;
          with Rectangle, Point do
            DrawRectangle(Left + 1, Top + 1, Right - Left - 1, Bottom - Top - 1, GetPixel(X, Y));
        end;
      BUTTON_EVENT:
        if GetButton.ID = 1 then
          Break;
    end;
end.
