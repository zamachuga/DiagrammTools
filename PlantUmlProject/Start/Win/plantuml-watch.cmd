@echo off
title PlantUML Watch

rem ============================================================
rem   SETTINGS - change these as needed
rem ============================================================

rem Path to folder containing plantuml*.jar
set "DISTRIB_DIR=%~dp0..\..\Distrib"

rem Directory to watch for changes (leave empty to use . or pass as argument)
set "WATCH_DIR=."

rem ============================================================

setlocal enabledelayedexpansion

for /f "usebackq delims=" %%f in (`dir "%DISTRIB_DIR%\plantuml*.jar" /b /o-n 2^>nul`) do set "JAR_NAME=%%f" & goto :run
echo plantuml*.jar not found in %DISTRIB_DIR%. Run Setup\Win\setup.cmd first.
pause & exit /b 1

:run
set "JAR_PATH=%DISTRIB_DIR%\%JAR_NAME%"
if not "%~1"=="" set "WATCH_DIR=%~1"
echo Watching %WATCH_DIR% for changes...
java -jar "%JAR_PATH%" -watch "%WATCH_DIR%" -duration 500
endlocal
pause