@echo off
setlocal

pushd "%~dp0" >nul

set "PS_LAUNCHER=%~dp0..\PowerShell\Build-Launcher.ps1"
if not exist "%PS_LAUNCHER%" (
  echo [ERROR] Not found: "%PS_LAUNCHER%"
  echo.
  pause
  popd >nul
  exit /b 1
)

where pwsh >nul 2>&1
if %errorlevel%==0 (
  pwsh -NoProfile -ExecutionPolicy Bypass -File "%PS_LAUNCHER%"
  ) else (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_LAUNCHER%"
)

if not %errorlevel%==0 (
  echo.
  echo [ERROR] Launcher failed with exit code %errorlevel%
  echo.
  pause
)

popd >nul
endlocal
exit /b
