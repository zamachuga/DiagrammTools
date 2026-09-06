@echo off
title PlantUML Watch
for /f "usebackq delims=" %%f in (`dir "%~dp0..\..\Distrib\plantuml*.jar" /b /o-n 2^>nul`) do set "JAR=%%f" & goto :run
echo plantuml*.jar not found in Distrib. Run Setup\Win\setup.cmd first.
pause & exit /b 1
:run
if "%~1"=="" (
  set "WATCH_DIR=."
) else (
  set "WATCH_DIR=%~1"
)
echo Watching %WATCH_DIR% for changes...
java -jar "%~dp0..\..\Distrib\%JAR%" -watch "%WATCH_DIR%" -duration 500
pause