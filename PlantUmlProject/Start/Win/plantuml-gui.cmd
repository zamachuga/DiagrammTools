@echo off
title PlantUML GUI

rem ============================================================
rem   SETTINGS - change these as needed
rem ============================================================

rem Path to folder containing plantuml*.jar
set "DISTRIB_DIR=%~dp0..\..\Distrib"

rem Full path to .puml file or folder to open (leave empty to use default)
set "PUML_FILE="

rem ============================================================

setlocal enabledelayedexpansion

for /f "usebackq delims=" %%f in (`dir "%DISTRIB_DIR%\plantuml*.jar" /b /o-n 2^>nul`) do set "JAR_NAME=%%f" & goto :run
echo plantuml*.jar not found in %DISTRIB_DIR%. Run Setup\Win\setup.cmd first.
pause & exit /b 1

:run
set "JAR_PATH=%DISTRIB_DIR%\%JAR_NAME%"
if not "%PUML_FILE%"=="" (
    java -jar "%JAR_PATH%" -gui "%PUML_FILE%" %*
) else (
    java -jar "%JAR_PATH%" -gui %*
)
endlocal
pause