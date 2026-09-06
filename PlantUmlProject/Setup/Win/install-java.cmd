@echo off
title Java Installer for PlantUML
setlocal enabledelayedexpansion

echo Checking Java...
java -version 2>&1 | find "version" >nul
if %errorlevel% equ 0 (
  echo Java is already installed.
  java -version 2>&1
  pause
  exit /b 0
)

echo Java not found.
echo.
echo ========================================
echo  Downloading Eclipse Temurin JDK 21...
echo ========================================
echo.

set "URL=https://aka.ms/download-jdk/microsoft-jdk-21.0.3-windows-x64.msi"
set "INSTALLER=%TEMP%\jdk21-installer.msi"

echo Downloading...
powershell -Command "& {Invoke-WebRequest -Uri '%URL%' -OutFile '%INSTALLER%' -UseBasicParsing}"

if not exist "%INSTALLER%" (
  echo Download failed. Please install Java manually from:
  echo   https://adoptium.net/temurin/releases/?version=21
  pause
  exit /b 1
)

echo Installing JDK 21... (follow the installer wizard)
start /W msiexec /i "%INSTALLER%" /passive ADDLOCAL=FeatureJavaHome

echo.
echo Installation completed. Opening Adoptium page for double-check...
start https://adoptium.net/temurin/releases/?version=21
echo.
echo If Java was installed correctly, run any Start script.
pause