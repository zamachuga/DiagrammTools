@echo off
title PlantUML GUI - Factory Method

rem ============================================================
rem   SETTINGS - change these as needed
rem ============================================================

rem Path to folder containing plantuml*.jar
set "DISTRIB_DIR=%~dp0..\..\Distrib"

rem Path to the Examples folder or a specific .puml file
set "PUML_FILE=%~dp0..\..\Examples"

rem ============================================================

setlocal enabledelayedexpansion

for /f "usebackq delims=" %%f in (`dir "%DISTRIB_DIR%\plantuml*.jar" /b /o-n 2^>nul`) do set "JAR_NAME=%%f" & goto :run
echo plantuml*.jar not found in %DISTRIB_DIR%. Run Setup\Win\setup.cmd first.
pause & exit /b 1

:run
set "JAR_PATH=%DISTRIB_DIR%\%JAR_NAME%"
echo Opening PlantUML GUI in "%PUML_FILE%"...
echo Double-click factory-method.puml in the list.
start /B java -jar "%JAR_PATH%" -gui "%PUML_FILE%"
endlocal
exit