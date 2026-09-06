@echo off
setlocal
echo ==========================================
echo   Install Java 21 (Temurin) for Structurizr
echo   Windows x64
echo ==========================================
echo.
echo This script will open the Java 21 download page.
echo Download and install the .msi installer, then reopen your terminal.
echo.
start "" "https://adoptium.net/temurin/releases/?version=21&os=windows&arch=x64"
endlocal
