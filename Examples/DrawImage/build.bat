@echo off
call "%~dp0..\..\Lib\build.bat" "%~dp0DrawImage"
copy "%~dp0*.tga" "%~dp0..\..\Bin" >nul