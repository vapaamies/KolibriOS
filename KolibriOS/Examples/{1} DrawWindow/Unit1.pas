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
      Right  := Width  Shr 2;
      Bottom := Height Shr 2;
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
Begin
  BeginDraw;

  With Window Do
    DrawWindow(Left, Top, Right, Bottom, 'Hello!', $00FFFFFF, WS_SKINNED_FIXED + WS_COORD_CLIENT + WS_CAPTION, CAPTION_MOVABLE);

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