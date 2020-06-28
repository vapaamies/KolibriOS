@echo off

set Source=%1

if "%Source%"=="" (
  echo Usage: %~n0 [source-file]
  goto exit
)

set Bin=%~dp0..\Bin
set DCU=%~dp0..\Bin\DCU
set Options=-$C- -$I- -$T+
set Target=%Bin%\%~n1
set Units=%~dp0..\RTL;%~dp0..\Lib

if not exist "%Bin%" mkdir "%Bin%"
if not exist "%DCU%" mkdir "%DCU%"
if exist "%Source%.cfg" del "%Source%.cfg"

if not exist "%~dp0..\RTL\SysInit.dcu" call "%~dp0..\build-RTL.bat"
if errorlevel 1 goto exit

if not exist "%Bin%\convert.bat" (
  echo @%%~dp0..\Tools\convert.bat %%* >"%Bin%\convert.bat"
  if errorlevel 1 goto exit
)

dcc32 "%Source%.dpr" -e"%Bin%" -n"%DCU%" -u"%Units%" %Options%
if errorlevel 1 goto exit

call "%~dp0convert.bat" "%Target%.exe"
if errorlevel 1 goto exit

del "%Target%.exe"

:exit