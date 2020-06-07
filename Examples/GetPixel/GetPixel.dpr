program GetPixelApp;

uses
  KolibriOS;

var
  WndLeft, WndTop, WndWidth, WndHeight: Integer;
  Rect: TRect;
  Point: TPoint;
begin
  with GetScreenSize do
  begin
    WndWidth := Width div 4;
    WndHeight := Height div 4;
    WndLeft := (Width - WndWidth) div 2;
    WndTop := (Height - WndHeight) div 2;
  end;

  with Rect do
  begin
    Left := 10;
    Top := 10;
    Right := WndWidth - 20;
    Bottom := WndHeight - 40;
  end;

  SetEventMask(EM_REDRAW + EM_BUTTON + EM_MOUSE);

  while True do
    case WaitEvent of
      REDRAW_EVENT:
        begin
          BeginDraw;

          DrawWindow(WndLeft, WndTop, WndWidth, WndHeight, 'Get Pixel', $00FFFFFF,
            WS_SKINNED_FIXED + WS_CLIENT_COORDS + WS_CAPTION, CAPTION_MOVABLE);

          with Rect do
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
          with Rect, Point do
            DrawRectangle(Left + 1, Top + 1, Right - Left - 1, Bottom - Top - 1, GetPixel(X, Y));
        end;
      BUTTON_EVENT:
        if GetButton.ID = 1 then
          Break;
    end;
end.
