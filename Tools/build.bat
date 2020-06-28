@echo off

set Source=%1

if #%Source%#==## (
  echo Usage: %~n0 [source-file]
  goto exit
)

call "%~dp0init.bat"

set Bin=%~dp0..\Bin
set DCU=%Bin%\DCU
set Options=-$C- -$I- -$T+
set Target=%Bin%\%~n1
set Units=%~dp0..\Lib;%DCU%

if exist "%Source%.cfg" del "%Source%.cfg"

dcc32 %Source%.dpr -e"%Bin%" -n"%DCU%" -u"%Units%" %Options%
if errorlevel 1 goto exit

call "%~dp0convert.bat" "%Target%.exe"
if errorlevel 1 goto exit

del "%Target%.exe"

:exit