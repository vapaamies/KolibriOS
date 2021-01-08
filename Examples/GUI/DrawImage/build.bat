@echo off

call "%~dp0..\..\..\Tools\build.bat" "%~dp0DrawImage"
if errorlevel 1 goto exit

call "%~dp0init.bat"

:exit