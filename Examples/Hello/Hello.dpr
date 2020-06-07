program Hello;

uses
  KolibriOS;

var
  Left, Right, Top, Bottom: Integer;

begin
  with GetScreenSize do
  begin
    Right := Width div 4;
    Bottom := Height div 4;
    Left := (Width - Right) div 2;
    Top := (Height - Bottom) div 2;
  end;

  while True do
    case WaitEvent of
      REDRAW_EVENT:
        begin
          BeginDraw;
          DrawWindow(Left, Top, Right, Bottom, 'Hello!', $00FFFFFF,
            WS_SKINNED_FIXED + WS_CLIENT_COORDS + WS_CAPTION, CAPTION_MOVABLE);
          EndDraw;
        end;
      KEY_EVENT:
        GetKey;
      BUTTON_EVENT:
        if GetButton.ID = 1 then
          Break;
    end;
end.
