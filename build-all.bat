@echo off

call %~dp0build-RTL.bat
if errorlevel 1 goto exit

call %~dp0build-apps.bat

:exit