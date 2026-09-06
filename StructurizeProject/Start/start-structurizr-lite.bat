@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
echo ==========================================
echo   Structurizr Lite - Start (Windows)
echo ==========================================
echo.

rem Find structurizr-lite*.war dynamically
set "WAR="
for /f "usebackq delims=" %%f in (`dir "%~dp0..\Distrib\structurizr-lite*.war" /b /o-n 2^>nul`) do set "WAR=%%f" & goto :war_found
echo [ERROR] structurizr-lite*.war not found in Distrib.
echo Run Setup\Windows\setup.bat first.
pause
exit /b 1
:war_found
set "WAR=%~dp0..\Distrib\%WAR%"

rem Port for the local web server
set "PORT=8080"

rem Path to the diagram file workspace.dsl (absolute or relative to this script).
rem Leave EMPTY to let Structurizr Lite find "workspace.dsl" in the current folder.
set "WORKSPACE="

rem ============================================================

if not exist "%WAR%" (
    echo [ERROR] File not found: %WAR%
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
        echo Fix the WORKSPACE variable in the script.
        pause
        exit /b 1
    )
)

echo [2/2] Starting Structurizr Lite on port %PORT%...
echo       Open http://localhost:%PORT% in your browser
echo       Press Ctrl+C to stop
echo.
if not "%WORKSPACE%"=="" (
    java -Dserver.port=%PORT% -Dstructurizr.workspacePath="%WORKSPACE%" -jar "%WAR%"
) else (
    java -Dserver.port=%PORT% -jar "%WAR%"
)

endlocal
