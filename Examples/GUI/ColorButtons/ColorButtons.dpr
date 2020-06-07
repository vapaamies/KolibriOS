program ColorButtons;

uses
  KolibriOS;

const
  COLOR_BLUE    = $000000FF;
  COLOR_RED     = $00FF0000;
  COLOR_GREEN   = $0000FF00;
  COLOR_BLACK   = $00000000;

  BLACK_BUTTON  = 1000;
  BLUE_BUTTON   = 2000;
  GREEN_BUTTON  = 3000;
  RED_BUTTON    = 4000;

var
  WndLeft, WndTop, WndWidth, WndHeight: Integer;

begin
  with GetScreenSize do
  begin
    WndWidth := Width div 4;
    WndHeight := Height div 4;
    WndLeft := (Width - WndWidth) div 2;
    WndTop := (Height - WndHeight) div 2;
  end;

  while True do
    case WaitEvent of
      REDRAW_EVENT:
        begin
          BeginDraw;
          DrawWindow(WndLeft, WndTop, WndWidth, WndHeight, 'Color Buttons', $00FFFFFF,
            WS_SKINNED_FIXED + WS_CLIENT_COORDS + WS_CAPTION, CAPTION_MOVABLE);
          DrawButton(10, 20, 50, 30, COLOR_RED, 0, RED_BUTTON);
          DrawButton(70, 20, 50, 30, COLOR_GREEN, 0, GREEN_BUTTON);
          DrawButton(10, 60, 50, 30, COLOR_BLUE, 0, BLUE_BUTTON);
          DrawButton(70, 60, 50, 30, COLOR_BLACK, 0, BLACK_BUTTON);
          EndDraw;
        end;
      KEY_EVENT:
        GetKey;
      BUTTON_EVENT:
        case GetButton.ID of
          BLUE_BUTTON:
            SetWindowCaption('Blue');
          GREEN_BUTTON:
            SetWindowCaption('Green');
          RED_BUTTON:
            SetWindowCaption('Red');
          BLACK_BUTTON:
            SetWindowCaption('Black');
          1:
            Break;
        end;
    end;
end.
