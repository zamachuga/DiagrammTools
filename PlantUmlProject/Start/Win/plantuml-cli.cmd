@echo off
title PlantUML CLI
for /f "usebackq delims=" %%f in (`dir "%~dp0..\..\Distrib\plantuml*.jar" /b /o-n 2^>nul`) do set "JAR=%%f" & goto :run
echo plantuml*.jar not found in Distrib. Run Setup\Win\setup.cmd first.
pause & exit /b 1
:run
java -jar "%~dp0..\..\Distrib\%JAR%" %*