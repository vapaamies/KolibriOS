Unit Unit1;
(* -------------------------------------------------------- *)
Interface
(* -------------------------------------------------------- *)
Uses KolibriOS;
(* -------------------------------------------------------- *)
Const
  BORDER_SIZE = 5;
(* -------------------------------------------------------- *)
Type
  TRGBTriple = Packed Record
    Blue:  Byte;
    Green: Byte;
    Red:   Byte;
  End;

  TRGBTripleArray = Packed Array[0..0] Of TRGBTriple;

  PRGBTripleArray = ^TRGBTripleArray;
(* -------------------------------------------------------- *)
Var
  Window: TRect;
  Screen: TSize;
  Image, ImagePreview: PRGBTripleArray;
(* -------------------------------------------------------- *)
Procedure Main;
Procedure On_Key;
Procedure On_Button;
Procedure On_Redraw;
Procedure ImageResize;
Function  SrcR(a, b: Dword): Dword;
Function  SrcG(a, b: Dword): Dword;
Function  SrcB(a, b: Dword): Dword;
(* -------------------------------------------------------- *)
Implementation
(* -------------------------------------------------------- *)
Procedure Main;
Begin
  HeapCreate;

  Screen := GetScreenSize();

  With Window Do Begin
    With Screen Do Begin
      Right  := BORDER_SIZE * 2 + Width  Shr 1 - 1;
      Bottom := BORDER_SIZE + GetSkinHeight + Height Shr 1 - 1;
      Left   := (Width  - Right)  Shr 1;
      Top    := (Height - Bottom) Shr 1;
      
      Image        := HeapAllocate(Width * Height * 3);
      ImagePreview := HeapAllocate(Width * Height * 3 Shr 1);      
      
      GetScreenImage(Image^, 0, 0, Width, Height);
      ImageResize;
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
    DrawWindow(Left, Top, Right, Bottom, 'GetScreenImage', $00FFFFFF, WS_SKINNED_FIXED + WS_COORD_CLIENT + WS_CAPTION + WS_FILL_TRANSPARENT, CAPTION_MOVABLE);
    
  With Screen Do
    DrawImage(ImagePreview^, 0, 0, Width Shr 1, Height Shr 1);
    
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
Function SrcR(a, b: Dword): Dword;
Begin
  SrcR := Image[(Screen.Width * b  + a)].Red;
End;
Function SrcG(a, b: Dword): Dword;
Begin
  SrcG := Image[(Screen.Width * b  + a)].Green;
End;
Function SrcB(a, b: Dword): Dword;
Begin
  SrcB := Image[(Screen.Width * b  + a)].Blue;
End;
(* -------------------------------------------------------- *)
Procedure ImageResize;
Var
  a, b, i: Dword;
Begin
  a := 0;
  While a < Screen.Width Do Begin
    b := 0;
    While b < Screen.Height Do Begin
      i := ((Screen.Width Shr 1) * b + a) Shr 1;
      ImagePreview[i].Red   := (SrcR(a, b) + SrcR(a + 1, b) + SrcR(a, b + 1) + SrcR(a + 1, b + 1)) Shr 2;
      ImagePreview[i].Green := (SrcG(a, b) + SrcG(a + 1, b) + SrcG(a, b + 1) + SrcG(a + 1, b + 1)) Shr 2;
      ImagePreview[i].Blue  := (SrcB(a, b) + SrcB(a + 1, b) + SrcB(a, b + 1) + SrcB(a + 1, b + 1)) Shr 2;
      Inc(b, 2);
    End;
    Inc(a, 2);
  End;
End;
(* -------------------------------------------------------- *)
End.