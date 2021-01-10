(*
    KolibriOS on Windows (KoW) unpacker (KPCK) support unit

    Copyright (c) 2021 Delphi SDK for KolibriOS team
*)

const
  KPCK = $4B43504B;

type
  PPackedFileHeader = ^TPackedFileHeader;
  TPackedFileHeader = packed record
    Signature:    LongWord; // KPCK
    UnpackedSize: LongWord;
    PackMethod:   LongWord; // LZMA, CallTrick, NoCallTrick
  end;

  PPackedFile = ^TPackedFile;
  TPackedFile = packed record
    Header: TPackedFileHeader;
    Data:   array[0..0] of Byte;
  end;

procedure Unpack(const Source: TPackedFile; var Dest); stdcall; external;
{$L KoW\unpacker.obj}
