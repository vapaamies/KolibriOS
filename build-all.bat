@echo off

call "%~dp0build-examples.bat"
if errorlevel 1 goto exit

call "%~dp0build-my.bat"
if errorlevel 1 goto exit

call "%~dp0build-tools.bat"

:exit