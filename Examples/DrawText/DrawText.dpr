program DrawTextApp;

uses
  KolibriOS;

var
  Left, Right, Top, Bottom, CurX, CurY: Integer;
  Key: TKeyboardInput;

begin
  with GetScreenSize do
  begin
    Right := Width div 4;
    Bottom := Height div 4;
    Left := (Width  - Right) div 2;
    Top := (Height - Bottom) div 2;
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
          DrawWindow(Left, Top, Right, Bottom, 'Get Key', $00FFFFFF,
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
          TerminateThread;
    end;
end.
