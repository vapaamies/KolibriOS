@echo off
call "%~dp0..\..\Lib\build.bat" "%~dp0DrawImageEx"
copy "%~dp0*.bmp" "%~dp0..\..\Bin" >nul