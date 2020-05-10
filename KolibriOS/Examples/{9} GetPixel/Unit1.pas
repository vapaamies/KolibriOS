Unit Unit1;
(* -------------------------------------------------------- *)
Interface
(* -------------------------------------------------------- *)
Uses KolibriOS;
(* -------------------------------------------------------- *)
Var
  Window: TRect;
  Screen: TSize;
  Rectangle: TRect;
(* -------------------------------------------------------- *)
Procedure Main;
Procedure On_Button;
Procedure On_Redraw;
Procedure On_Mouse;
(* -------------------------------------------------------- *)
Implementation
(* -------------------------------------------------------- *)
Procedure Main;
Begin
  Screen := GetScreenSize();

  With Window Do Begin
    With Screen Do Begin
      Right  := Width  Shr 2;
      Bottom := Height Shr 2;
      Left   := (Width  - Right)  Shr 1;
      Top    := (Height - Bottom) Shr 1;
    End;
  End;

  With Rectangle Do Begin
    Left   := 10;
    Top    := 10;
    Right  := Window.Right - 20;
    Bottom := Window.Bottom - 40;
  End;

  SetEventMask(EM_REDRAW + EM_BUTTON + EM_MOUSE);

  While TRUE Do Begin
    Case WaitEvent() Of
      REDRAW_EVENT: On_Redraw;
      BUTTON_EVENT: On_Button;
      MOUSE_EVENT:  On_Mouse;
    End;
  End;
End;
(* -------------------------------------------------------- *)
Procedure On_Redraw;
Begin
  BeginDraw;

  With Window Do
    DrawWindow(Left, Top, Right, Bottom, 'GetPixel', $00FFFFFF, WS_SKINNED_FIXED + WS_COORD_CLIENT + WS_CAPTION, CAPTION_MOVABLE);

  With Rectangle Do Begin
    DrawLine(Left, Top, Left, Bottom, 0);
    DrawLine(Right, Top, Right, Bottom, 0);
    DrawLine(Left, Top, Right, Top, 0);
    DrawLine(Left, Bottom, Right, Bottom, 0);
  End;

  EndDraw;
End;
(* -------------------------------------------------------- *)
Procedure On_Button;
Begin
  Case GetButton().ID Of
    1: ThreadTerminate;
  End;
End;
(* -------------------------------------------------------- *)
Procedure On_Mouse;
Var
  Point: TPoint;
Begin
  Point := GetMousePos();

  With Rectangle Do
    With Point Do
      DrawRectangle(Left + 1, Top + 1, Right - Left - 1, Bottom - Top - 1, GetPixel(X, Y));

End;
(* -------------------------------------------------------- *)
End.