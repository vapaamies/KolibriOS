program FractalTree;

uses
  KolibriOS;

var
  WndLeft, WndTop: LongInt;
  WndHeight, WndWidth: LongWord;

procedure BoldLine(X1, Y1, X2, Y2: LongInt; Color: LongWord);
begin
  DrawLine(X1, Y1, X2, Y2, Color);
  DrawLine(X1 + 1, Y1, X2 + 1, Y2, Color);
  DrawLine(X1 - 1, Y1, X2 - 1, Y2, Color);
  DrawLine(X1, Y1 + 1, X2, Y2 + 1, Color);
  DrawLine(X1, Y1 - 1, X2, Y2 - 1, Color);
end;

procedure Tree(X, Y, Size: LongInt; Angle: Extended);
var
  X2, Y2: Integer;
  Color: LongWord;
begin
  case Size of
    0..2:   Color := $FFFF00;
    3..4:   Color := $00FF00;
    5..8:   Color := $808000;
    9..16:  Color := $008000;
    17..32: Color := $2C5400;
  else
    Color := $562A00;
  end;

  X2 := Round(X + Size * Sin(Angle));
  Y2 := Round(Y + Size * Cos(Angle));

  if Size < 8 then
    DrawLine(X, Y, X2, Y2, Color)
  else
    BoldLine(X, Y, X2, Y2, Color);

  if Size > 0 then
  begin
    Tree(X2, Y2, Size * 3 div 4, Angle + Pi / 5 / (Random + 1));
    Tree(X2, Y2, Size * 3 div 4, Angle - Pi / 5 / (Random + 1));
  end
end;

procedure Redraw;
begin
  BeginDraw;
  DrawWindow(WndLeft, WndTop, WndWidth, WndHeight, 'Press ENTER to generate new tree', $00A0A0A0,
    WS_SKINNED_FIXED + WS_CLIENT_COORDS + WS_CAPTION, CAPTION_MOVABLE);
  Tree(WndWidth div 2, WndHeight - WINDOW_BORDER_SIZE - GetSkinHeight, WndHeight div 4, Pi);
  EndDraw;
end;

begin
  Randomize;

  with GetScreenSize do
  begin
    WndHeight := Height - Height div 4;
    WndWidth := Width - Width div 4;
    WndLeft := (Width - WndWidth) div 2;
    WndTop := (Height - WndHeight) div 2;
  end;

  while True do
    case WaitEvent of
      REDRAW_EVENT:
        Redraw;
      KEY_EVENT:
        if GetKey.Code = #13 then
          Redraw;
      BUTTON_EVENT:
        Break;
    end;
end.
