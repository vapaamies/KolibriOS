@echo off

for %%f in ("%~dp0*.exe") do (
  call "%~dp0..\Tools\convert.bat" "%%f" %*
  if errorlevel 1 goto exit
)

:exit