@echo off

call %~dp0KolibriOS\Examples\ColorButtons\build.bat
if errorlevel 1 goto exit

call %~dp0KolibriOS\Examples\DateTime\build.bat
if errorlevel 1 goto exit

call %~dp0KolibriOS\Examples\DrawImage\build.bat
if errorlevel 1 goto exit

call %~dp0KolibriOS\Examples\DrawImageEx\build.bat
if errorlevel 1 goto exit

call %~dp0KolibriOS\Examples\DrawText\build.bat
if errorlevel 1 goto exit

call %~dp0KolibriOS\Examples\GetCurrentDir\build.bat
if errorlevel 1 goto exit

call %~dp0KolibriOS\Examples\GetPixel\build.bat
if errorlevel 1 goto exit

call %~dp0KolibriOS\Examples\GetPointOwner\build.bat
if errorlevel 1 goto exit

call %~dp0KolibriOS\Examples\Hello\build.bat
if errorlevel 1 goto exit

call %~dp0KolibriOS\Examples\LoadFile\build.bat
if errorlevel 1 goto exit

call %~dp0KolibriOS\Examples\ReadFolder\build.bat
if errorlevel 1 goto exit

call %~dp0KolibriOS\Examples\Screenshot\build.bat
if errorlevel 1 goto exit

call %~dp0KolibriOS\Examples\SetCursor\build.bat
if errorlevel 1 goto exit

call %~dp0KolibriOS\Examples\SetPixel\build.bat
if errorlevel 1 goto exit

call %~dp0KolibriOS\Examples\SetWindowPos\build.bat

:exit