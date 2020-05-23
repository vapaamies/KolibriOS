program SetWindowPosApp;

uses
  KolibriOS;

const
  KS_UP    = #$48;
  KS_DOWN  = #$50;
  KS_LEFT  = #$4B;
  KS_RIGHT = #$4D;

  MOVE_STEP = 10;

  LEFT_CTRL_PRESSED  = 4;
  RIGHT_CTRL_PRESSED = 8; 

procedure OnKey;
var
  Key: TKeyboardInput;
  ThreadInfo: TThreadInfo;
  ControlKeyState: LongWord;
begin  
  GetThreadInfo($FFFFFFFF, ThreadInfo);
  ControlKeyState := GetControlKeyState;
  Key := GetKey;
  with ThreadInfo.Window do
  begin
    if Boolean(ControlKeyState and (RIGHT_CTRL_PRESSED or LEFT_CTRL_PRESSED)) then
      case Key.ScanCode of
        KS_UP:
          Dec(Bottom, MOVE_STEP);
        KS_DOWN:
          Inc(Bottom, MOVE_STEP);
        KS_LEFT:
          Dec(Right, MOVE_STEP);
        KS_RIGHT:
          Inc(Right, MOVE_STEP);
      end
    else
      case Key.ScanCode of
        KS_UP:
          Dec(Top, MOVE_STEP);
        KS_DOWN:
          Inc(Top, MOVE_STEP);
        KS_LEFT:
          Dec(Left, MOVE_STEP);
        KS_RIGHT:
          Inc(Left, MOVE_STEP);
      end;
    SetWindowPos(Left, Top, Right, Bottom);
  end;  
end;

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
          DrawWindow(Left, Top, Right, Bottom, 'Set Window Position', $00FFFFFF,
            WS_SKINNED_SIZABLE + WS_CLIENT_COORDS + WS_CAPTION, CAPTION_MOVABLE);
          DrawText(24, 26, 'Use arrow keys(Left, Right, Up, Down)', $00000000, $00FFFFFF, DT_ZSTRING, 0);
          DrawText(24, 35, 'to move the window.', $00000000, $00FFFFFF, DT_ZSTRING, 0);
          DrawText(24, 44, 'Use Ctrl+arrow keys to resize window.', $00000000, $00FFFFFF, DT_ZSTRING, 0);
          EndDraw;
        end;
      KEY_EVENT:
        OnKey;
      BUTTON_EVENT:
        if GetButton.ID = 1 then
          TerminateThread;
    end;
end.
