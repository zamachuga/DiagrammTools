@echo off
title PlantUML Setup
setlocal enabledelayedexpansion

set "ROOT=%~dp0..\.."
set "DISTRIB=%ROOT%\Distrib"

echo ========================================
echo  PlantUML Setup Script - Windows
echo ========================================
echo.

REM === Step 1: Distrib folder ===
echo [1/3] Checking Distrib folder...
if not exist "%DISTRIB%" (
    mkdir "%DISTRIB%"
    if !errorlevel! neq 0 (
        echo   Failed to create Distrib folder.
        pause
        exit /b 1
    )
    echo   Created: %DISTRIB%
) else (
    echo   Already exists: %DISTRIB%
)
echo.

REM === Step 2: PlantUML jar ===
echo [2/3] Checking PlantUML jar...

set "HAS_JAR=0"
for %%f in ("%DISTRIB%\plantuml*.jar") do (
    if exist "%%f" set "HAS_JAR=1"
)

if !HAS_JAR! equ 1 (
    echo   PlantUML jar found.
) else (
    echo   No plantuml*.jar found in Distrib. Downloading latest...

    for /f "usebackq delims=" %%t in (`powershell -NoProfile -Command "try { $r = Invoke-RestMethod -Uri 'https://api.github.com/repos/plantuml/plantuml/releases/latest' -Headers @{ 'User-Agent' = 'MultiTool' }; Write-Output $r.tag_name } catch { Write-Output 'v1.2026.8' }"`) do set "TAG=%%t"

    set "VERSION=!TAG:v=!"
    set "JAR_URL=https://github.com/plantuml/plantuml/releases/download/!TAG!/plantuml-!VERSION!.jar"
    set "JAR_OUT=%DISTRIB%\plantuml-!VERSION!.jar"

    echo   Downloading: plantuml-!VERSION!.jar
    powershell -NoProfile -Command "Invoke-WebRequest -Uri '!JAR_URL!' -OutFile '!JAR_OUT!' -UseBasicParsing"

    if not exist "!JAR_OUT!" (
        echo   Download failed. Please download PlantUML manually from:
        echo     https://plantuml.com/download
        pause
        exit /b 1
    )
    echo   Download complete.
)
echo.

REM === Step 3: Java ===
echo [3/3] Checking Java...

java -version 2>&1 | find "version" >nul
if !errorlevel! equ 0 (
    echo   Java is installed.
    java -version 2>&1 | find "21." >nul
    if !errorlevel! neq 0 (
        echo   Note: PlantUML works best with Java 21+.
        echo   Your version:
        java -version 2>&1
    ) else (
        echo   Java 21 detected.
    )
    goto :java_done
)

echo   Java not found. Installing Eclipse Temurin JDK 21...
echo.
set "INSTALLER=%TEMP%\jdk21-installer.msi"
set "JAVA_URL=https://aka.ms/download-jdk/microsoft-jdk-21.0.3-windows-x64.msi"

powershell -NoProfile -Command "Invoke-WebRequest -Uri '%JAVA_URL%' -OutFile '%INSTALLER%' -UseBasicParsing"

if not exist "%INSTALLER%" (
    echo   Download failed. Please install Java manually from:
    echo     https://adoptium.net/temurin/releases/?version=21
    pause
    exit /b 1
)
echo   Installing JDK 21... (follow the installer wizard)
start /W msiexec /i "%INSTALLER%" /passive ADDLOCAL=FeatureJavaHome
echo   Java installation completed.

:java_done

echo.
echo ========================================
echo  Setup complete!
echo ========================================
echo.
echo Run Start/Win/plantuml-cli.cmd or plantuml-gui.cmd to get started.
echo.
pause