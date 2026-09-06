@echo off
title PlantUML Web Server
for /f "usebackq delims=" %%f in (`dir "%~dp0..\..\Distrib\plantuml*.jar" /b /o-n 2^>nul`) do set "JAR=%%f" & goto :run
echo plantuml*.jar not found in Distrib. Run Setup\Win\setup.cmd first.
pause & exit /b 1
:run
echo Starting PlantUML web server on http://localhost:8080
echo Press Ctrl+C to stop.
java -jar "%~dp0..\..\Distrib\%JAR%" -picoweb:8080 %*
pause