Unit Unit1;
(* -------------------------------------------------------- *)
Interface
(* -------------------------------------------------------- *)
Uses KolibriOS;
(* -------------------------------------------------------- *)
Const
  COLOR_BLUE          = $000000FF;
  COLOR_RED           = $00FF0000;
  COLOR_GREEN         = $0000FF00;
  COLOR_BLACK         = $00000000;

  BLUE_BUTTON        = 10050;
  GREEN_BUTTON       = 9000;
  RED_BUTTON         = 42;
  BLACK_BUTTON       = 0;

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
    DrawWindow(Left, Top, Right, Bottom, 'DrawButton', $00FFFFFF, WS_SKINNED_FIXED + WS_COORD_CLIENT + WS_CAPTION, CAPTION_MOVABLE);

  DrawButton(10, 20, 50, 30, COLOR_RED, 0, RED_BUTTON);
  DrawButton(70, 20, 50, 30, COLOR_GREEN, 0, GREEN_BUTTON);
  DrawButton(10, 60, 50, 30, COLOR_BLUE, 0, BLUE_BUTTON);
  DrawButton(70, 60, 50, 30, COLOR_BLACK, 0, BLACK_BUTTON);

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
    1: 	          ThreadTerminate;
    BLUE_BUTTON:  SetWindowCaption('Blue');
    GREEN_BUTTON: SetWindowCaption('Green');
    RED_BUTTON:   SetWindowCaption('Red');
    BLACK_BUTTON: SetWindowCaption('Black');
  End;
End;
(* -------------------------------------------------------- *)
End.