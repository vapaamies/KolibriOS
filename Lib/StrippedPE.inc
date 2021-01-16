(*
    Stripped PE file format definition

    Copyright (c) 2018 0CodErr
    Copyright (c) 2021 Delphi SDK for KolibriOS team
*)

const
  STRIPPED_PE_SIGNATURE   = $4503; // 'PE' xor 'S'

  SPE_DIRECTORY_IMPORT    = 0;
  SPE_DIRECTORY_EXPORT    = 1;
  SPE_DIRECTORY_BASERELOC = 2;

  SPE_MAX_DIRECTORY_ENTRIES = SPE_DIRECTORY_BASERELOC;

type
  PLongWordArray = ^TLongWordArray;
  TLongWordArray = array[0..0] of LongWord;

  PStrippedImageFileHeader = ^TStrippedImageFileHeader;
  TStrippedImageFileHeader = packed record
    Signature:              Word;
    Characteristics:        Word;
    AddressOfEntryPoint:    LongWord;
    ImageBase:              LongWord;
    SectionAlignmentLog2:   Byte;
    FileAlignmentLog2:      Byte;
    MajorOSVersion:         Byte;
    MinorOSVersion:         Byte;
    SizeOfImage:            LongWord;
    SizeOfStackReserve:     LongWord;
    SizeOfHeapReserve:      LongWord;
    SizeOfHeaders:          LongWord;
    Subsystem:              Byte;
    NumberOfRvaAndSizes:    Byte;
    NumberOfSections:       Word;
  end;

  PStrippedImageSectionHeader = ^TStrippedImageSectionHeader;
  TStrippedImageSectionHeader = packed record
    Name:                  array[0..7] of KolibriChar;
    VirtualSize:           LongWord;
    VirtualAddress:        LongWord;
    SizeOfRawData:         LongWord;
    PointerToRawData:      LongWord;
    Characteristics:       LongWord;
  end;

  PImageDataDirectory = ^TImageDataDirectory;
  TImageDataDirectory = packed record
    VirtualAddress:        LongWord;
    Size:                  LongWord;
  end;

  PDataDirectoryArray = ^TDataDirectoryArray;
  TDataDirectoryArray = array[0..SPE_MAX_DIRECTORY_ENTRIES] of TImageDataDirectory;

  PImportDescriptor = ^TImportDescriptor;
  TImportDescriptor = packed record
    OriginalFirstThunk:    LongWord;
    TimeDateStamp:         LongWord;
    ForwarderChain:        LongWord;
    Name:                  LongWord;
    FirstThunk:            LongWord;
  end;

  PExportDescriptor = ^TExportDescriptor;
  TExportDescriptor = packed record
    Characteristics:       LongWord;
    TimeDateStamp:         LongWord;
    MajorVersion:          Word;
    MinorVersion:          Word;
    Name:                  LongWord;
    Base:                  LongWord;
    NumberOfFunctions:     LongWord;
    NumberOfNames:         LongWord;
    AddressOfFunctions:    LongWord;
    AddressOfNames:        LongWord;
    AddressOfNameOrdinals: LongWord;
  end;
