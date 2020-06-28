@echo off
call "%~dp0..\..\..\Tools\build.bat" "%~dp0SetCursor"
copy "%~dp0*.bmp" "%~dp0..\..\..\Bin" >nul