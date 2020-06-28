@echo off

set Bin=%~dp0..\Bin
set DCU=%Bin%\DCU

if not exist "%Bin%" mkdir "%Bin%"
if not exist "%DCU%" mkdir "%DCU%"

echo @call "%%~dp0..\Tools\convert.bat" %%* >"%Bin%\convert.bat"
if errorlevel 1 goto exit

copy "%~dp0convert-all.bat" "%Bin%" >nul
if errorlevel 1 goto exit

dcc32 -m -y -z "%~dp0..\Lib\System" -n"%DCU%"
if errorlevel 1 goto exit

:exit