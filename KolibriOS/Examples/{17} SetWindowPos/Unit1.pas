Unit Unit1;
(* -------------------------------------------------------- *)
Interface
(* -------------------------------------------------------- *)
Uses KolibriOS;
(* -------------------------------------------------------- *)
Const
  KS_UP    = #$48;
  KS_DOWN  = #$50;
  KS_LEFT  = #$4B;
  KS_RIGHT = #$4D;
  MOVE_STEP = 10;
  LEFT_CTRL_PRESSED  = 4;
  RIGHT_CTRL_PRESSED = 8; 
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

  With Window, Screen Do Begin
    Right  := Width  Shr 2;
    Bottom := Height Shr 2;
    Left   := (Width  - Right)  Shr 1;
    Top    := (Height - Bottom) Shr 1;
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
    DrawWindow(Left, Top, Right, Bottom, 'SetWindowPos', $00FFFFFF, WS_SKINNED_SIZABLE + WS_COORD_CLIENT + WS_CAPTION, CAPTION_MOVABLE);
  DrawText(24, 26, 'Use arrow keys(Left, Right, Up, Down)', $00000000, $00FFFFFF, DT_ZSTRING, 0);
  DrawText(24, 35, 'to move window.', $00000000, $00FFFFFF, DT_ZSTRING, 0);
  DrawText(24, 44, 'Use Ctrl+arrow keys to resize window.', $00000000, $00FFFFFF, DT_ZSTRING, 0);
  EndDraw;
End;
(* -------------------------------------------------------- *)
Procedure On_Key;
Var
  Key: TKeyboardInput;
  ThreadInfo: TThreadInfo;
  ControlKeyState: Dword;
Begin  
  GetThreadInfo($FFFFFFFF, ThreadInfo);
  ControlKeyState := GetControlKeyState;
  Key := GetKey;
  With ThreadInfo.Window Do
  Begin
    If Boolean(ControlKeyState And (RIGHT_CTRL_PRESSED Or LEFT_CTRL_PRESSED)) Then Begin
      Case Key.Scan Of
        KS_UP:    Dec(Bottom, MOVE_STEP);    
        KS_DOWN:  Inc(Bottom, MOVE_STEP); 
        KS_LEFT:  Dec(Right, MOVE_STEP);
        KS_RIGHT: Inc(Right, MOVE_STEP);
      End;    
    End
    Else Begin
      Case Key.Scan Of
        KS_UP:    Dec(Top, MOVE_STEP);
        KS_DOWN:  Inc(Top, MOVE_STEP);
        KS_LEFT:  Dec(Left, MOVE_STEP);
        KS_RIGHT: Inc(Left, MOVE_STEP); 
      End;
    End;
    SetWindowPos(Left, Top, Right, Bottom);
  End;  
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