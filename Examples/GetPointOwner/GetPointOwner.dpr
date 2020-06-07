program GetPointOwnerApp;

uses
  KolibriOS;

procedure UpdateInfo;
const
  CHAR_WIDTH = 8;
  CHAR_HEIGHT = 16;
var
  MousePos: TPoint;
  ID: LongWord;
  ThreadInfo: TThreadInfo;
  I: LongWord;
begin
  MousePos := GetMousePos;
  with MousePos do
    ID := GetPointOwner(X, Y);

  GetThreadInfo(ID, ThreadInfo);
  (* get length of current name *)
  I := 0;
  while ThreadInfo.Name[I] <> #0 do
    Inc(I);

  (* clear unnecessary part of possible previous name by white rectangle *)
  DrawRectangle(64 + I * CHAR_WIDTH, 16, (SizeOf(ThreadInfo.Name) - I) * CHAR_WIDTH, CHAR_HEIGHT, $00FFFFFF);
  (* draw current name *)
  DrawText(64, 16, ThreadInfo.Name, $00000000, $00FFFFFF, DT_CP866_8x16 + DT_FILL_OPAQUE + DT_ZSTRING, 0);
end;

const
  NO_EVENT = 0;

var
  Left, Top, Width, Height: Integer;
  Screen: TSize;

begin
  Screen := GetScreenSize;
  Width := 189;
  Height := 79;
  Left := (Screen.Width - Width) div 2;
  Top := (Screen.Height - Height) div 2;

  SetEventMask(EM_BUTTON + EM_REDRAW);

  while True do
    case WaitEventByTime(5) of
      REDRAW_EVENT:
        begin
          BeginDraw;
          DrawWindow(Left, Top, Width, Height, 'Get Point Owner', $00FFFFFF,
            WS_SKINNED_FIXED + WS_CLIENT_COORDS + WS_CAPTION, CAPTION_MOVABLE);
          DrawText(16, 16, 'Name:', $00000000, $00FFFFFF, DT_CP866_8x16 + DT_ZSTRING, 0);
          EndDraw;
        end;
      BUTTON_EVENT:
        if GetButton.ID = 1 then
          Break;
      NO_EVENT:
        UpdateInfo;
    end;
end.
