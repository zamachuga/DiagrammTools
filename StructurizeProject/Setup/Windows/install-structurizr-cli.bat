@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
echo ==========================================
echo   Structurizr CLI - Installation (Windows)
echo ==========================================
echo.

set "ZIP=%~dp0..\..\Distrib\structurizr-cli.zip"
set "DEST=%~dp0..\..\Distrib\structurizr-cli"

if not exist "%ZIP%" (
    echo [ERROR] File not found: %ZIP%
    echo Place structurizr-cli.zip in the Distrib folder.
    pause
    exit /b 1
)

echo [1/3] Checking Java...
where java >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Java not found.
    echo Install Java 21 from Setup\Windows\install-java.bat
    pause
    exit /b 1
)
for /f "tokens=3" %%v in ('java -version 2^>^&1') do (
    set "JAVA_VERSION=%%v"
    goto :java_ok
)
:java_ok
echo       Java version detected: %JAVA_VERSION%

echo [2/3] Extracting %ZIP%...
if exist "%DEST%" (
    echo       Target folder already exists, removing: %DEST%
    rmdir /s /q "%DEST%"
)
powershell -NoProfile -Command "Expand-Archive -Path '%ZIP%' -DestinationPath '%DEST%' -Force"
if errorlevel 1 (
    echo [ERROR] Failed to extract the archive.
    pause
    exit /b 1
)
if not exist "%DEST%\structurizr.bat" (
    echo [ERROR] structurizr.bat not found after extraction.
    pause
    exit /b 1
)

echo [3/3] Verifying installation...
"%DEST%\structurizr.bat" version
if errorlevel 1 (
    echo [ERROR] CLI did not start correctly.
    pause
    exit /b 1
)

echo.
echo ==========================================
echo   Installation complete.
echo   Usage (from any folder):
echo     "%DEST%\structurizr.bat" --help
echo   Example:
echo     "%DEST%\structurizr.bat" pull -w workspace.dsl -r remote
echo ==========================================
pause
endlocal
