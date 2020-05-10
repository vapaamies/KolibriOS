Unit Unit1;
(* -------------------------------------------------------- *)
Interface
(* -------------------------------------------------------- *)
Uses KolibriOS;
(* -------------------------------------------------------- *)
Var
  Window: TRect;
  Screen: TSize;
(* -------------------------------------------------------- *)
Procedure Main;
Procedure On_Key;
Procedure On_Button;
Procedure On_Redraw;
(* -------------------------------------------------------- *)
Implementation
(* -------------------------------------------------------- *)
Procedure Main;
Begin
  Screen := GetScreenSize();

  With Window Do Begin
    With Screen Do Begin
      Right  := 180;
      Bottom := 180;
      Left   := (Width  - Right)  Shr 1;
      Top    := (Height - Bottom) Shr 1;
    End;
  End;

  While TRUE Do Begin
    Case WaitEvent() Of
      REDRAW_EVENT: On_Redraw;
      KEY_EVENT:    On_Key;
      BUTTON_EVENT: On_Button;
    End;
  End;
End;
(* -------------------------------------------------------- *)
Procedure On_Redraw;
Var
  X, Y: Integer;
Begin
  BeginDraw;

  With Window Do
    DrawWindow(Left, Top, Right, Bottom, 'SetPixel', $00FFFFFF, WS_SKINNED_FIXED + WS_COORD_CLIENT + WS_CAPTION, CAPTION_MOVABLE);

  For Y := 0 To 50 Do
    For X := 0 To 50 Do
      If ((X Mod 2) = 0) Or ((Y Mod 2) = 0) Then
        SetPixel(X, Y, $00FF0000);

  For Y := 50 To 100 Do
    For X := 50 To 100 Do
      If ((X Mod 3) = 0) Or ((Y Mod 3) = 0) Then
        SetPixel(X, Y, $00007F00);

  For Y := 100 To 150 Do
    For X := 100 To 150 Do
      If ((X Mod 4) = 0) Or ((Y Mod 4) = 0) Then
        SetPixel(X, Y, $000000FF);

  EndDraw;
End;
(* -------------------------------------------------------- *)
Procedure On_Key;
Begin
  GetKey;
End;
(* -------------------------------------------------------- *)
Procedure On_Button;
Begin
  Case GetButton().ID Of
    1: ThreadTerminate;
  End;
End;
(* -------------------------------------------------------- *)
End.