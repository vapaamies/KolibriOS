# Delphi SDK for KolibriOS
This package contains [Delphi SDK](https://github.com/vapaamies/KolibriOS) with all programs and scripts needed to complile Delphi programs for [KolibriOS](http://kolibrios.org). Many examples are also included, GUI and console. You can compile programs either from Delphi IDE and command-line compiler `dcc32.exe`.

## Versions of Delphi
Theoretically, any version of Delphi for Windows can be used, since Delphi 4. In practice, only Delphi 6, 7 and 2007 were tested. You can try any other version yourself, modern or ancient.

## Getting started
Unpack downloaded archive to a directory you want. You will open `.dpr` files and run `.bat` scripts from this directory.

## Compiling examples
To compile all SDK examples, just run `build-examples.bat`. This script uses command-line Delphi compiler. That means the compiler should be available by a path from the `PATH` environment variable. If you installed Delphi using standard installation program from Borland/Embarcadero, no else steps needed.

KolibriOS executables will appear in `Bin` directory with additional files needed for some GUI examples.

## Hello, world!
Simple “Hello, world!” program looks like:
````pascal
program Hello;

uses
  CRT;

begin
  InitConsole('Hello');
  WriteLn('Hello, world!');
end.
````

## Compiling from Delphi IDE
First, you need to build RTL for you version of Delphi. Please run `build-RTL.bat` script to do it. Compiled DCUs will appear in `RTL` directory.

Open program in the IDE, press `Ctrl+F9`. Compiled `.exe` file will appear in `Bin` directory. Use `convert.bat` to convert it to KolibriOS executable:
````
convert hello.exe
````

To automate this process, you can add `Build` item to Delphi `Tools` menu:

![How to add Build item to Delphi Tools menu](http://forum.cantorsys.com/misc.php?action=pun_attachment&item=38&download=0)

For your projects, please ensure if you have correct `build.bat` script.

## Compiling from command line
To compile an example, use `build.bat` script included to its directory. If RTL not built yet, it will build automatically. Build script automates all compling and converting operations, so `Bin` directory will contain KolibriOS executable immediately after the run.

## Running programs in KolibriOS
There are many ways to prepare your programs to run under KolibriOS using either on real PC or virtual machine. On real PC, just copy programs to the flash drive you use to boot KolibriOS. For virtual machines, use ISO image to boot KolibriOS and diskette image for your programs.

To write KolibriOS executables into a diskette image, you can use any program which supports diskette images, like WinImage or UltraISO. Those programs are not free. We recommend you to use [ImDisk Virtual Disk Driver](http://www.ltr-data.se/opencode.html/#ImDisk) by Olof Lagerkvist, which is open source and free. Create an image, format it, mount, then copy your programs to the virtual diskette. Now you ready to mount this image into virtual machine and run programs under KolibriOS. Don't forget to dismount the diskette before use it in KolibriOS.

Please download latest [nightly build](http://kolibrios.org/download) of KolibriOS to run programs. If you prefer full-featured distributives, use [KolibriN](http://kolibri-n.org/download) instead.

We have also prepared a pre-built diskette with all compiled programs, named `delphi.img`. There is about 1.33 MB of free space, so you can use it to copy your programs too.

## Writing own programs
We have written templates for your programs, `My\Console\Program1.dpr` and `My\GUI\Program2.dpr`. Open one of them them in Delphi IDE, then save into the directory you want under the name of your program. That's all to start coding. Use `Bin\convert.bat` script to convert your program to KolibriOS format as written [above](#compiling-from-delphi-ide).

If you want to complile your program from command line, copy `build.bat` script to your directory, then edit it and change `ProgramX` to the name of your program. Compiled `.exe` will be put to `Bin` directory.

## Code pages
Default KolibriOS code page is [CP866](https://en.wikipedia.org/wiki/Code_page_866) (Russian OEM). If you want to use string constants in the language other than English, you should save your sources in that CP866. Unfortunately, Delphi IDE does not support CP866 natively. The future versions of SDK will support other encodings for sources, including [Windows-1251](https://en.wikipedia.org/wiki/Windows-1251) and [UTF-8](https://en.wikipedia.org/wiki/UTF-8), with automated conversion for KolibriOS.

## Programs and scripts included to SDK
* **Programs**
  * `exe2kos.exe` – Windows executable to KolibriOS executable conversion utility.
  * `kpack.exe` – KolibriOS executables packer.
  * `kunpack.exe` – KolibriOS executables unpacker.
  * `Pet.exe` – universal Windows executables rebuilder, you can use it outside of this SDK.
* **Shell scripts**
  * `build-all.bat` – builds RTL and all programs, including your programs.
  * `build-examples.bat` – builds example programs.
  * `build-my.bat` – builds your programs have put to the subdirectories of `My` directory.
  * `build-RTL.bat` – builds Delphi RTL for KolibriOS.
  * `Bin\convert.bat` – helper script to convert manually compiled programs to KolibriOS format.
  * `Lib\build.bat` – library build script calling by other ones when builings programs.
  * `Lib\convert.bat` – library conversion script calling by other ones when builings or converting programs compiled manually.

## Tips and Tricks
Release archive contains `.dof` files with correct Delphi IDE settings, especially paths. If you want to use latest [hot version](https://github.com/vapaamies/KolibriOS) of SDK from the `master` branch on GitHub, download the latest release archive before, unpack it. Then unpack the archive of hot version to same directory with file overwriting. It gives you correctly prepared environment to compile hot versions of programs.

If particular program not yet exist in SDK release, copy existing `.dof` file from the directory of other program was included to the release, for example `GUI\ColorButtons.dof`.

## See also
* **Programs not included to SDK**
  * [2048 Game](http://forum.cantorsys.com/viewtopic.php?id=123)
  * [Console Tetris](http://forum.cantorsys.com/viewtopic.php?id=122)
  * [Sierpinski Carpet](http://forum.cantorsys.com/viewtopic.php?pid=672#p672)
* **[KolibriOS forum](http://board.kolibrios.org)**
  * [Delphi for KolibriOS](http://board.kolibrios.org/viewtopic.php?p=74639)
  * [Delphi 7 examples](http://board.kolibrios.org/viewtopic.php?p=68254)
  * [Delphi SDK для Колибри](http://board.kolibrios.org/viewtopic.php?p=11789)