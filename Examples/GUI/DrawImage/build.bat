@echo off
call "%~dp0..\..\..\Tools\build.bat" "%~dp0DrawImage"
copy "%~dp0*.tga" "%~dp0..\..\..\Bin" >nul