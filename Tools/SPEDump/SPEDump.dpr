(*
    Stripped PE File Dumper

    Copyright (c) 2018 0CodErr
    Copyright (c) 2021 Delphi SDK for KolibriOS team
*)

program SPEDump;

{$IFNDEF KolibriOS}
  {$APPTYPE Console}
{$ENDIF}

uses
  KolibriOS, CRT;

var
  FileName: PKolibriChar;
  I, BytesRead: LongWord;
  Buffer: PStrippedImageFileHeader;
  Section: PStrippedImageSectionHeader;
  DataDir: PDataDirectoryArray;
  Imp: PImportDescriptor;
  Exp: PExportDescriptor;
  Thunk: PLongWord;

procedure WriteLn(Str: PKolibriChar = nil);
begin
  con_write_asciiz(Str);
  con_write_asciiz(#10);
end;

function FileIsValid: Boolean;
begin
  Result := False;
  with Buffer^ do
  begin
    if BytesRead < SizeOf(TStrippedImageFileHeader) then
      Exit;
    if Signature <> STRIPPED_PE_SIGNATURE then
      Exit;
  end;
  Result := True;
end;

function RVA2Offset(RVA: LongWord; Header: PStrippedImageFileHeader): LongWord;
var
  I: LongWord;
  SectionHeader: PStrippedImageSectionHeader;
begin
  with Header^ do
  begin
    SectionHeader := PStrippedImageSectionHeader(PKolibriChar(Header) + SizeOf(TStrippedImageFileHeader) + NumberOfRvaAndSizes * SizeOf(TImageDataDirectory));
    for I := 0 to NumberOfSections do
    begin
      with SectionHeader^ do
      begin
        if (RVA >= VirtualAddress) And (RVA < VirtualAddress + SizeOfRawData) then
        begin
          Result := PointerToRawData + RVA - VirtualAddress;
          Exit;
        end;
      end;
      Inc(SectionHeader);
    end;
  end;
  Result := 0;
end;

function StrNLen(Src: PKolibriChar; MaxLen: LongWord): LongWord;
begin
  Result := 0;
  while (Src^ <> #0) and (Result <> MaxLen) do
  begin
    Inc(Src);
    Inc(Result);
  end;
end;

begin
{$IF defined(KolibriOS) or defined(Debug)}
  InitConsole('Stripped PE File Dumper', False, LongWord(-1), 30);
{$IFEND}

{$IFDEF KolibriOS}
  FileName := nil;
{$ELSE}
  FileName := 'EHCI.SYS';
{$ENDIF}

  WriteLn('Stripped PE File Dumper version 0.2.1');
  WriteLn('Copyright (c) 2018 0CodErr');
  WriteLn('Copyright (c) 2021 Delphi SDK for KolibriOS team');

  if (FileName = nil) or (FileName^ = #0) then
  begin
    WriteLn('Usage: SPEDump [<file>]');
    Exit;
  end;

  WriteLn;
  con_printf('Dump of "%s"'#10#10, FileName);

  Buffer := LoadFile(FileName, BytesRead);
  if Buffer = nil then
  begin
    WriteLn('ReadFile Error');
    Exit;
  end;

  if not FileIsValid then
  begin
    WriteLn('File corrupted or invalid');
    Exit;
  end;

  WriteLn('File Header');
  WriteLn('-----------');

  with Buffer^ do
  begin
    con_printf('  Signature             = %04Xh'#10, Signature);
    con_printf('  Characteristics       = %04Xh'#10, Characteristics);
    con_printf('  AddressOfEntryPoint   = %08Xh'#10, AddressOfEntryPoint);
    con_printf('  ImageBase             = %08Xh'#10, ImageBase);
    con_printf('  SectionAlignmentLog2  = %u (%08Xh)'#10, SectionAlignmentLog2, 1 shl SectionAlignmentLog2);
    con_printf('  FileAlignmentLog2     = %u (%08Xh)'#10, FileAlignmentLog2, 1 shl FileAlignmentLog2);
    con_printf('  MajorOSVersion        = %u'#10, MajorOSVersion);
    con_printf('  MinorOSVersion        = %u'#10, MinorOSVersion);
    con_printf('  SizeOfImage           = %08Xh'#10, SizeOfImage);
    con_printf('  SizeOfStackReserve    = %08Xh'#10, SizeOfStackReserve);
    con_printf('  SizeOfHeapReserve     = %08Xh'#10, SizeOfHeapReserve);
    con_printf('  SizeOfHeaders         = %08Xh'#10, SizeOfHeaders);
    con_printf('  Subsystem             = %02Xh'#10, Subsystem);
    con_printf('  NumberOfRvaAndSizes   = %u'#10, NumberOfRvaAndSizes);
    con_printf('  NumberOfSections      = %u'#10, NumberOfSections);

    WriteLn;

    if NumberOfSections > 0 then
    begin
      I := 1;
      Section := PStrippedImageSectionHeader(PKolibriChar(Buffer) + SizeOf(TStrippedImageFileHeader) +
        NumberOfRvaAndSizes * SizeOf(TImageDataDirectory));
      repeat
        con_printf('Section #%u'#10, I);
        WriteLn('-----------');
        with Section^ do
        begin
          con_write_asciiz(
                     '  Name                  = '); con_write_string(Name, StrNLen(Name, 8));
          WriteLn;
          con_printf('  VirtualSize           = %08Xh'#10, VirtualSize);
          con_printf('  VirtualAddress        = %08Xh'#10, VirtualAddress);
          con_printf('  SizeOfRawData         = %08Xh'#10, SizeOfRawData);
          con_printf('  PointerToRawData      = %08Xh'#10, PointerToRawData);
          con_printf('  Flags                 = %08Xh'#10#10, Characteristics);
        end;
        Inc(Section);
        Inc(I);
      until I > NumberOfSections;

      DataDir := PDataDirectoryArray(PKolibriChar(Buffer) + SizeOf(TStrippedImageFileHeader));

      if (NumberOfRvaAndSizes > SPE_DIRECTORY_IMPORT) and (DataDir[SPE_DIRECTORY_IMPORT].VirtualAddress <> 0) then
      begin
        WriteLn('Imports');
        WriteLn('-------');
        Imp := PImportDescriptor(PKolibriChar(Buffer) + RVA2Offset(DataDir[SPE_DIRECTORY_IMPORT].VirtualAddress, Buffer));
        while Imp.Name <> 0 do
        begin
          with Imp^ do
          begin
            con_printf('  OriginalFirstThunk    = %08Xh'#10, OriginalFirstThunk);
            con_printf('  TimeDateStamp         = %08Xh'#10, TimeDateStamp);
            con_printf('  ForwarderChain        = %08Xh'#10, ForwarderChain);
            con_printf('  Name                  = %s'#10, PKolibriChar(Buffer) + RVA2Offset(Name, Buffer));
            con_printf('  FirstThunk            = %08Xh'#10, FirstThunk);
          end;
          Thunk := PLongWord(PKolibriChar(Buffer) + RVA2Offset(Imp.FirstThunk, Buffer));
          while Thunk^ <> 0 do
          begin
            con_printf('    %s'#10, PKolibriChar(Buffer) + RVA2Offset(Thunk^, Buffer) + SizeOf(Word));
            Inc(Thunk);
          end;
          WriteLn;
          Inc(Imp);
        end;
      end;

      if (NumberOfRvaAndSizes > SPE_DIRECTORY_EXPORT) and (DataDir[SPE_DIRECTORY_EXPORT].VirtualAddress <> 0) then
      begin
        WriteLn('Exports');
        WriteLn('-------');
        Exp := PExportDescriptor(RVA2Offset(DataDir[SPE_DIRECTORY_EXPORT].VirtualAddress, Buffer) + LongWord(Buffer));
        with Exp^ do
        begin
          con_printf('  Characteristics       = %08Xh'#10, Characteristics);
          con_printf('  TimeDateStamp         = %08Xh'#10, TimeDateStamp);
          con_printf('  MajorVersion          = %u'#10, MajorVersion);
          con_printf('  MinorVersion          = %u'#10, MinorVersion);
          con_printf('  Name                  = %s'#10, PKolibriChar(Buffer) + RVA2Offset(Name, Buffer));
          con_printf('  Base                  = %08Xh'#10, Base);
          con_printf('  NumberOfFunctions     = %u'#10, NumberOfFunctions);
          con_printf('  NumberOfNames         = %u'#10, NumberOfNames);
          con_printf('  AddressOfFunctions    = %08Xh'#10, AddressOfFunctions);
          con_printf('  AddressOfNames        = %08Xh'#10, AddressOfNames);
          con_printf('  AddressOfNameOrdinals = %08Xh'#10, AddressOfNameOrdinals);
          for I := 0 to NumberOfNames - 1 do
            con_printf('    %s'#10, PKolibriChar(Buffer) +
              RVA2Offset(PLongWordArray(PKolibriChar(Buffer) + RVA2Offset(AddressOfNames, Buffer))[I], Buffer));
        end;
      end;
    end;
  end;
end.
