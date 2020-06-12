# Frequently Asked Questions

## I know only Pascal. How can I use Delphi for programming for KolibriOS?
Delphi is a dialect of Pascal. You can see familiar statements and unit names in our examples. Unlike other Pascal implementations, Delphi has a concept of project. Project files are named with `.dpr` extension, and can contain used units with their relative paths. It allows Delphi IDE to show them in Units window. You can use project file to put your code too. For simple programs, project file is enough. Don't afraid to code, you will not break a nuclear power plant with it.

## What types of strings can I use?
For now, you can use only short strings (`string[255]`) with limited support. Long strings (ANSI strings) are not supported yet. We're working on it.

## Why do I need to initialize console manually when writing console programs?
KolibriOS is completely graphical operation system without built-in console. Console is supported by external library. When you initializing console using `CRT.InitConsole` procedure, it loads `console.obj` library and calls  initialization procedure from it.

## How to debug Delphi programs under KolibriOS?
Nikolay Burshtyn aka **amber8706** has written a [short guide](http://forum.cantorsys.com/viewtopic.php?id=121) ([Google Translate](https://translate.google.as/translate?sl=ru&tl=en&u=http%3A%2F%2Fforum.cantorsys.com%2Fviewtopic.php%3Fid%3D121)\).

## I want to have visual programming for KolibriOS!
We also want to. Corresponding subproject codenamed with [Visual Kolibri Library (VKL)](http://forum.cantorsys.com/viewtopic.php?id=110) ([Google Translate](https://translate.google.as/translate?sl=ru&tl=en&u=http%3A%2F%2Fforum.cantorsys.com%2Fviewtopic.php%3Fid%3D110)\). For now it's only on designing stage. You can [contribute](contribute.md) to it. Please read [MCK Help](http://kolmck.000webhostapp.com/docs/mckhlp.zip) from [KOL project](http://kolmck.000webhostapp.com) to know how it could be done.

## Are you rly write all the code by yourselves?
Yes, we are. Delphi is proprientary compiler copyrighted by Borland and Embarcadero. It's prohibited to copy their code to open source projects and distribute on GitHub. To make our SDK clear, we don't have other way than write code by ourselves.

## Your forum is in Russian! I can't read this moonspeak!
We are three Russian developers for now, working on Delphi SDK. It's logical to discuss topics in native language. Feel free to ask us [in English](http://forum.cantorsys.com/viewtopic.php?id=114), we will respond you in English too. If you want to read our topics, please use [Google Translate](https://translate.google.as/translate?sl=auto&tl=en&u=http%3A%2F%2Fforum.cantorsys.com%2Fviewforum.php%3Fid%3D12).
