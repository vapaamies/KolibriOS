program DrawTextApp;

uses
  KolibriOS;

var
  WndLeft, WndTop, WndWidth, WndHeight, CurX, CurY: Integer;
  Key: TKeyboardInput;

begin
  with GetScreenSize do
  begin
    WndWidth := Width div 4;
    WndHeight := Height div 4;
    WndLeft := (Width  - WndWidth) div 2;
    WndTop := (Height - WndHeight) div 2;
  end;

  CurX := 0;
  CurY := 0;

  while True do
    case WaitEvent of
      REDRAW_EVENT:
        begin
          CurX := 0;
          CurY := 0;
          BeginDraw;
          DrawWindow(WndLeft, WndTop, WndWidth, WndHeight, 'Please type text to draw', $00FFFFFF,
            WS_SKINNED_FIXED + WS_CLIENT_COORDS + WS_CAPTION, CAPTION_MOVABLE);
          EndDraw;
        end;
      KEY_EVENT:
        begin
          Key := GetKey;
          DrawText(CurX, CurY, @Key.Code, $00000000, $00FFFFFF, 0, 1);
          Inc(CurX, 6);
          if CurX > 100 then
          begin
            Inc(CurY, 10);
            CurX := 0;
          end;
        end;
      BUTTON_EVENT:
        if GetButton.ID = 1 then
          Break;
    end;
end.
