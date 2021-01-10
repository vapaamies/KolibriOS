(*
    Image file format definitions for KolibriOS

    Copyright (c) 2017 0CodErr
*)

type
  PTargaFileHeader = ^TTargaFileHeader;
  TTargaFileHeader = packed record
    IDLength:        Byte;
    ColorMapType:    Byte;
    ImageType:       Byte;
    CMapStart:       Word;
    CMapLength:      Word;
    CMapDepth:       Byte;
    XOffset:         Word;
    YOffset:         Word;
    Width:           Word;
    Height:          Word;
    PixelDepth:      Byte;
    ImageDescriptor: Byte;
  end;

  TBitmapFileHeader = packed record
    bfType:      Word;
    bfSize:      LongWord;
    bfReserved1: Word;
    bfReserved2: Word;
    bfOffBits:   LongWord;
  end;

  TBitmapInfoHeader = packed record
    biSize:          LongWord;
    biWidth:         LongInt;
    biHeight:        LongInt;
    biPlanes:        Word;
    biBitCount:      Word;
    biCompression:   LongWord;
    biSizeImage:     LongWord;
    biXPelsPerMeter: LongInt;
    biYPelsPerMeter: LongInt;
    biClrUsed:       LongWord;
    biClrImportant:  LongWord;
  end;

  TRGBQuad = packed record
    Blue:     Byte;
    Green:    Byte;
    Red:      Byte;
    Reserved: Byte;
  end;

  PBitmapFile = ^TBitmapFile;
  TBitmapFile = packed record
    BitmapFileHeader: TBitmapFileHeader;
    BitmapInfoHeader: TBitmapInfoHeader;
    Palette: array[0..0] of TRGBQuad;
  end;
