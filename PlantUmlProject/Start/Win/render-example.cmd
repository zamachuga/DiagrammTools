@echo off
title PlantUML GUI - Factory Method

rem ============================================================
rem   SETTINGS - change these as needed
rem ============================================================

rem Path to folder containing plantuml*.jar
set "DISTRIB_DIR=%~dp0..\..\Distrib"

rem Folder with diagram files
set "PUML_DIR=%~dp0..\..\Examples"

rem Diagram file name to open
set "PUML_FILENAME=factory-method.puml"

rem Full path to the diagram file (built from PUML_DIR + PUML_FILENAME)
set "PUML_FILE=%PUML_DIR%\%PUML_FILENAME%"

rem Fixed working directory so the GUI file tree starts here
cd /d "%~dp0"

rem ============================================================

setlocal enabledelayedexpansion

for /f "usebackq delims=" %%f in (`dir "%DISTRIB_DIR%\plantuml*.jar" /b /o-n 2^>nul`) do set "JAR_NAME=%%f" & goto :run
echo plantuml*.jar not found in %DISTRIB_DIR%. Run Setup\Win\setup.cmd first.
pause & exit /b 1

:run
set "JAR_PATH=%DISTRIB_DIR%\%JAR_NAME%"
echo Opening PlantUML GUI in "%PUML_FILE%"...
echo Double-click %PUML_FILENAME% in the list.
pushd "%PUML_DIR%"
start /B java -jar "%JAR_PATH%" -gui "%PUML_FILE%"
popd
endlocal
exit