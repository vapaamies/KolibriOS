@echo off

set Source=%1

if #%Source%#==## (
  echo Usage: %~n0 [source-file]
  goto exit
)

call "%~dp0init.bat" -dKolibriOS

set Bin=%~dp0..\Bin
set DCU=%Bin%\DCU
set Options=-$C- -$I- -$T+
set Target=%Bin%\%~n1
set Units=%~dp0..\Lib;%DCU%

if exist "%Source%.cfg" del "%Source%.cfg"

dcc32 -b %Source%.dpr -e"%Bin%" -n"%DCU%" -u"%Units%" %Options% -dKolibriOS
if errorlevel 1 goto exit

"%~dp0..\Pet" -nologo -strip -trunc -dropsect .idata,.rsrc -rebase 0 -osver 0.7 -log brief -into "%Target%.exe"
if errorlevel 1 goto exit

"%~dp0..\exe2kos" "%Target%.exe"
if errorlevel 1 goto exit

"%~dp0..\kpack" "%Target%"
if errorlevel 1 goto exit

del "%Target%.exe"

:exit