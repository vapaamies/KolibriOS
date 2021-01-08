@echo off

set Bin=%~dp0..\Bin
set DCU=%Bin%\DCU

if not exist "%Bin%" mkdir "%Bin%"
if not exist "%DCU%" mkdir "%DCU%"

dcc32 -m -y -z "%~dp0..\Lib\System" -n"%DCU%" %*