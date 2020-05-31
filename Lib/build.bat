@echo off

set Source=%1

if "%Source%"=="" (
  echo Usage: %~n0 [source-file]
  goto exit
)

set Bin=%~dp0..\Bin
set Options=-$C- -$I- -$T+
set Target=%Bin%\%~n1
set Units=%~dp0..\RTL;%~dp0..\Lib

if not exist "%Bin%" mkdir "%Bin%"
if exist "%Source%.cfg" del "%Source%.cfg"

if not exist "%~dp0..\RTL\SysInit.dcu" call "%~dp0..\build-RTL.bat"
if errorlevel 1 goto exit

dcc32 "%Source%.dpr" -e"%Bin%" -u"%Units%" %Options%
if errorlevel 1 goto exit

"%~dp0..\Pet" -nologo -strip -trunc -dropsect .idata,.rsrc -rebase 0 -osver 0.7 -log brief -into "%Target%.exe"
if errorlevel 1 goto exit

"%~dp0..\exe2kos" "%Target%.exe" "%Target%"
if errorlevel 1 goto exit
del "%Target%.exe"

%~dp0..\kpack "%Target%"

:exit