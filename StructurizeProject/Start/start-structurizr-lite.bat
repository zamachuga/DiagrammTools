@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

rem ============================================================
rem   SETTINGS - change these as needed
rem ============================================================

rem Path to folder containing structurizr-lite*.war
set "DISTRIB_DIR=%~dp0..\Distrib"

rem Port for the local web server
set "PORT=8080"

rem Folder containing the workspace file (leave EMPTY to use current folder)
set "WORKSPACE_DIR="

rem Workspace file name
set "WORKSPACE_FILENAME=workspace.dsl"

rem Full path to the workspace file (built from WORKSPACE_DIR + WORKSPACE_FILENAME)
set "WORKSPACE="
if not "%WORKSPACE_DIR%"=="" set "WORKSPACE=%WORKSPACE_DIR%\%WORKSPACE_FILENAME%"

rem ============================================================

echo ==========================================
echo   Structurizr Lite - Start (Windows)
echo ==========================================
echo.

rem Find structurizr-lite*.war dynamically
set "WAR_NAME="
for /f "usebackq delims=" %%f in (`dir "%DISTRIB_DIR%\structurizr-lite*.war" /b /o-n 2^>nul`) do set "WAR_NAME=%%f" & goto :war_found
echo [ERROR] structurizr-lite*.war not found in %DISTRIB_DIR%.
echo Run Setup\Windows\setup.bat first.
pause
exit /b 1

:war_found
set "WAR_PATH=%DISTRIB_DIR%\%WAR_NAME%"

if not exist "%WAR_PATH%" (
    echo [ERROR] File not found: %WAR_PATH%
    pause
    exit /b 1
)

echo [1/2] Checking Java...
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

if not "%WORKSPACE%"=="" (
    if not exist "%WORKSPACE%" (
        echo [ERROR] Workspace file not found: %WORKSPACE%
        pause
        exit /b 1
    )
)

echo [2/2] Starting Structurizr Lite on port %PORT%...
echo       Open http://localhost:%PORT% in your browser
echo       Press Ctrl+C to stop
echo.
if not "%WORKSPACE%"=="" (
    java -Dserver.port=%PORT% -Dstructurizr.workspacePath="%WORKSPACE%" -jar "%WAR_PATH%"
) else (
    java -Dserver.port=%PORT% -jar "%WAR_PATH%"
)

endlocal