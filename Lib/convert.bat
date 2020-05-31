@echo off

if "%1"=="" (
  echo Usage: %~n0 [source-file.exe]
  goto exit
)

"%~dp0..\Pet" -nologo -strip -trunc -dropsect .idata,.rsrc -rebase 0 -osver 0.7 -log brief -into %*
if errorlevel 1 goto exit

"%~dp0..\exe2kos" "%1"
if errorlevel 1 goto exit

%~dp0..\kpack "%~dp1%~n1"

:exit