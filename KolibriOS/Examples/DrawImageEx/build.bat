@echo off
call "%~dp0..\build.bat" "%~dp0DrawImageEx"
copy "%~dp0*.bmp" "%~dp0..\..\..\Bin"