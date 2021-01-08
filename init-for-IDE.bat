@echo off

set DCU=%~dp0Bin\DCU
set KoW=%~dp0Bin\KoW\DCU

if #%1#==## (
  call "%~dp0Tools\init.bat" -dDebug
  if errorlevel 1 goto exit

  if not exist "%KoW%" mkdir "%KoW%"
  move "%DCU%\SysInit.dcu" "%KoW%" >nul
  move "%DCU%\System.dcu" "%KoW%" >nul

  call %0 Examples Examples\Console
  if errorlevel 1 goto exit

  call %0 Examples Examples\GUI
  if errorlevel 1 goto exit

  call %0 My My
  goto exit
)

if exist "%~dp0%1\.dof" (
  for /d %%f in ("%~dp0%2\*") do (
    if not exist "%%f\%%~nf.dof" (
      if exist "%%f\%%~nf.dpr" (
        echo Initializing IDE settings for "%%f"
        copy "%~dp0%1\.dof" "%%f\%%~nf.dof" >nul
        if errorlevel 1 goto exit
      )
    )
    if exist "%%f\init.bat" (
      call "%%f\init.bat" KoW
      if errorlevel 1 goto exit
    )
  )
)

:exit