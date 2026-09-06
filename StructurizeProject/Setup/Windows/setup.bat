@echo off
title Structurizr Setup
setlocal enabledelayedexpansion
chcp 65001 >nul

set "ROOT=%~dp0..\.."
set "DISTRIB=%ROOT%\Distrib"

echo ==========================================
echo  Structurizr Setup Script - Windows
echo ==========================================
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

REM === Step 2: Fetch latest versions ===
echo [2/3] Checking Structurizr files...

REM Write and run tiny PowerShell snippet to get the latest tags
set "PS_TEMP=%TEMP%\structurizr_fetch_tags.ps1"
(
echo param($outpath^)
echo try { $r = Invoke-RestMethod -Uri 'https://api.github.com/repos/structurizr/lite/releases/latest' -Headers @{'User-Agent'='MultiTool'}; $lite = $r.tag_name } catch { $lite = 'v2025.11.08' }
echo try { $r = Invoke-RestMethod -Uri 'https://api.github.com/repos/structurizr/cli/releases/latest' -Headers @{'User-Agent'='MultiTool'}; $cli = $r.tag_name } catch { $cli = 'v2025.11.09' }
echo Set-Content -Path $outpath -Value ("LITE_TAG=" + $lite + "`nCLI_TAG=" + $cli^)
) > "%PS_TEMP%"

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_TEMP%" "%TEMP%\structurizr_tags.txt"

for /f "usebackq delims=" %%x in ("%TEMP%\structurizr_tags.txt") do set "%%x"

echo   Latest Lite: !LITE_TAG!
echo   Latest CLI:  !CLI_TAG!

REM === Step 3: Structurizr Lite .war ===
if exist "%DISTRIB%\structurizr-lite.war" (
    echo   Structurizr Lite .war found.
) else (
    echo   Downloading: structurizr-lite.war (!LITE_TAG!)
    powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://github.com/structurizr/lite/releases/download/!LITE_TAG!/structurizr-lite.war' -OutFile '%DISTRIB%\structurizr-lite.war' -UseBasicParsing"
    if not exist "%DISTRIB%\structurizr-lite.war" (
        echo   Download failed. Please download manually from:
        echo     https://github.com/structurizr/lite/releases
        pause
        exit /b 1
    )
    echo   Download complete.
)

REM === Step 4: Structurizr CLI zip ===
if exist "%DISTRIB%\structurizr-cli.zip" (
    echo   Structurizr CLI zip found.
) else (
    echo   Downloading: structurizr-cli.zip (!CLI_TAG!)
    powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://github.com/structurizr/cli/releases/download/!CLI_TAG!/structurizr-cli.zip' -OutFile '%DISTRIB%\structurizr-cli.zip' -UseBasicParsing"
    if not exist "%DISTRIB%\structurizr-cli.zip" (
        echo   Download failed. Please download manually from:
        echo     https://github.com/structurizr/cli/releases
        pause
        exit /b 1
    )
    echo   Download complete.
)
echo.

REM === Step 5: Java ===
echo [3/3] Checking Java...

java -version 2>&1 | find "version" >nul
if !errorlevel! equ 0 (
    echo   Java is installed.
    java -version 2>&1 | find "21." >nul
    if !errorlevel! neq 0 (
        echo   Note: Structurizr works best with Java 21+.
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
echo ==========================================
echo  Setup complete!
echo ==========================================
echo.
echo Run Start/start-structurizr-lite.bat to get started.
echo.
pause