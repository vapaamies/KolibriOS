@echo off

call "%~dp0..\..\..\Tools\build.bat" "%~dp0DrawImageEx"
if errorlevel 1 goto exit

call "%~dp0init.bat"

:exit