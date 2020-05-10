Unit Unit1;
(* -------------------------------------------------------- *)
Interface
(* -------------------------------------------------------- *)
Uses KolibriOS;
(* -------------------------------------------------------- *)
Const
  NO_EVENT = 0;
(* -------------------------------------------------------- *)
Var
  Window: TBox;
  Screen: TSize;
(* -------------------------------------------------------- *)
Procedure Main;
Procedure On_Button;
Procedure On_Redraw;
Procedure UpdateInfo;
(* -------------------------------------------------------- *)
Implementation
(* -------------------------------------------------------- *)
Procedure Main;
Begin
  Screen := GetScreenSize();

  With Window Do Begin
    Width  := 189;
    Height := 79;
    Left   := (Screen.Width  - Width)  Shr 1;
    Top    := (Screen.Height - Height) Shr 1;
  End;

  SetEventMask(EM_BUTTON + EM_REDRAW);

  While TRUE Do Begin
    Case WaitEventByTime(5) Of
      REDRAW_EVENT: On_Redraw;
      BUTTON_EVENT: On_Button;
      NO_EVENT:     UpdateInfo;
    End;
  End;
End;
(* -------------------------------------------------------- *)
Procedure On_Redraw;
Begin
  BeginDraw;
  With Window Do
    DrawWindow(Left, Top, Width, Height, 'GetPointOwner', $00FFFFFF, WS_SKINNED_FIXED + WS_COORD_CLIENT + WS_CAPTION, CAPTION_MOVABLE);
  DrawText(16, 16, 'Name:', $00000000, $00FFFFFF, DT_CP866_8X16 + DT_ZSTRING, 0);
  EndDraw;
End;
(* -------------------------------------------------------- *)
Procedure UpdateInfo;
Const
  CHAR_WIDTH = 8;
  CHAR_HEIGHT = 16;
Var
  MousePos: TPoint;
  ID: Dword;
  ThreadInfo: TThreadInfo;
  i: Dword;
Begin
  MousePos := GetMousePos;
  With MousePos Do
    ID := GetPointOwner(X, Y);
  GetThreadInfo(ID, ThreadInfo);
  (* get length of current name *)
  i := 0;
  While ThreadInfo.Name[i] <> #0 Do Inc(i);
  (* clear unnecessary part of possible previous name by white rectangle *)
  DrawRectangle(64 + i * CHAR_WIDTH, 16, (SizeOf(ThreadInfo.Name) - i) * CHAR_WIDTH, CHAR_HEIGHT, $00FFFFFF);
  (* draw current name *)
  DrawText(64, 16, ThreadInfo.Name, $00000000, $00FFFFFF, DT_CP866_8X16 + DT_FILL_OPAQUE + DT_ZSTRING, 0);
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