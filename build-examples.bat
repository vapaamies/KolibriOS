@echo off

for /d %%f in (%~dp0Examples\Console\*) do (
  call %%f\build.bat
  if errorlevel 1 goto exit
)

for /d %%f in (%~dp0Examples\GUI\*) do (
  call %%f\build.bat
  if errorlevel 1 goto exit
)

:exit