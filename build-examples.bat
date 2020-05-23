@echo off

call %~dp0Examples\ColorButtons\build.bat
if errorlevel 1 goto exit

call %~dp0Examples\DateTime\build.bat
if errorlevel 1 goto exit

call %~dp0Examples\DrawImage\build.bat
if errorlevel 1 goto exit

call %~dp0Examples\DrawImageEx\build.bat
if errorlevel 1 goto exit

call %~dp0Examples\DrawText\build.bat
if errorlevel 1 goto exit

call %~dp0Examples\GetCurrentDir\build.bat
if errorlevel 1 goto exit

call %~dp0Examples\GetPixel\build.bat
if errorlevel 1 goto exit

call %~dp0Examples\GetPointOwner\build.bat
if errorlevel 1 goto exit

call %~dp0Examples\Hello\build.bat
if errorlevel 1 goto exit

call %~dp0Examples\LoadFile\build.bat
if errorlevel 1 goto exit

call %~dp0Examples\ReadFolder\build.bat
if errorlevel 1 goto exit

call %~dp0Examples\Screenshot\build.bat
if errorlevel 1 goto exit

call %~dp0Examples\SetCursor\build.bat
if errorlevel 1 goto exit

call %~dp0Examples\SetPixel\build.bat
if errorlevel 1 goto exit

call %~dp0Examples\SetWindowPos\build.bat

:exit