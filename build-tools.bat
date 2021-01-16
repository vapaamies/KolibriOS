@echo off

for /d %%f in ("%~dp0Tools\*") do (
  if exist "%%f\build.bat" call "%%f\build.bat"
  if errorlevel 1 goto exit
)

:exit