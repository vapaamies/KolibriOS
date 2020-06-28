@echo off

if #%1#==## (
  call "%~dp0Tools\init.bat"
  if errorlevel 1 goto exit

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
      echo %%f\%%~nf.dof
      copy "%~dp0%1\.dof" "%%f\%%~nf.dof" >nul
      if errorlevel 1 goto exit
    )
  )
)

:exit