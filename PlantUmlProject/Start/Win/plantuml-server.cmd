@echo off
title PlantUML Web Server

rem ============================================================
rem   SETTINGS - change these as needed
rem ============================================================

rem Path to folder containing plantuml*.jar
set "DISTRIB_DIR=%~dp0..\..\Distrib"

rem Port for the web server
set "SERVER_PORT=8080"

rem ============================================================

setlocal enabledelayedexpansion

for /f "usebackq delims=" %%f in (`dir "%DISTRIB_DIR%\plantuml*.jar" /b /o-n 2^>nul`) do set "JAR_NAME=%%f" & goto :run
echo plantuml*.jar not found in %DISTRIB_DIR%. Run Setup\Win\setup.cmd first.
pause & exit /b 1

:run
set "JAR_PATH=%DISTRIB_DIR%\%JAR_NAME%"
echo Starting PlantUML web server on http://localhost:%SERVER_PORT%
echo Press Ctrl+C to stop.
java -jar "%JAR_PATH%" -picoweb:%SERVER_PORT% %*
endlocal
pause