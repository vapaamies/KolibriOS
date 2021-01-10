@echo off

for %%f in ("%~dp0*.TXT") do (
  if not exist "%~dp0..\..\..\Bin\%1\%%~nxf" (
    echo Copying "%%f"
    copy "%%f" "%~dp0..\..\..\Bin\%1" >nul
    if errorlevel 1 goto exit
  )
)

:exit