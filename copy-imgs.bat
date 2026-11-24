@echo off
setlocal EnableExtensions

if "%~1"=="" goto usage
if "%~2"=="" goto usage

set "SOURCE=%~f1"
set "DEST=%~f2"

if not exist "%SOURCE%\NUL" (
  echo Source directory not found: "%SOURCE%" 1>&2
  exit /b 2
)

if /I "%SOURCE%"=="%DEST%" (
  echo Source and destination must be different directories. 1>&2
  exit /b 2
)

if not exist "%DEST%\NUL" mkdir "%DEST%" 2>nul
if not exist "%DEST%\NUL" (
  echo Could not create destination directory: "%DEST%" 1>&2
  exit /b 2
)

if not exist "%SOURCE%\*.img" (
  echo No .img files found in "%SOURCE%".
  exit /b 0
)

set "FAILED=0"
for %%F in ("%SOURCE%\*.img") do if exist "%%~fF" (
  if exist "%DEST%\%%~nxF" (
    echo Skipping existing file: "%%~nxF"
  ) else (
    copy /B "%%~fF" "%DEST%\%%~nxF" >nul
    if errorlevel 1 (
      echo Failed to copy: "%%~nxF" 1>&2
      set "FAILED=1"
    ) else (
      echo Copied: "%%~nxF"
    )
  )
)

if "%FAILED%"=="1" exit /b 1
exit /b 0

:usage
echo Usage: %~nx0 ^<source-directory^> ^<destination-directory^> 1>&2
echo Copies top-level .img files without overwriting existing destination files. 1>&2
exit /b 2
