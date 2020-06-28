@echo off

for /d %%f in ("%~dp0Examples\Console\*") do (
  if exist "%%f\build.bat" call "%%f\build.bat"
  if errorlevel 1 goto exit
)

for /d %%f in ("%~dp0Examples\GUI\*") do (
  if exist "%%f\build.bat" call "%%f\build.bat"
  if errorlevel 1 goto exit
)

:exit