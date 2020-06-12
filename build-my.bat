@echo off

for /d %%f in (%~dp0My\*) do (
  call %%f\build.bat
  if errorlevel 1 goto exit
)

:exit