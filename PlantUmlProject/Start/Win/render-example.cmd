@echo off
title PlantUML GUI - Factory Method
for /f "usebackq delims=" %%f in (`dir "%~dp0..\..\Distrib\plantuml*.jar" /b /o-n 2^>nul`) do set "JAR=%%f" & goto :run
echo plantuml*.jar not found in Distrib. Run Setup\Win\setup.cmd first.
pause & exit /b 1
:run
set "EXAMPLES=%~dp0..\..\Examples"
echo Opening PlantUML GUI in Examples folder...
echo Double-click factory-method.puml in the list.
start /B java -jar "%~dp0..\..\Distrib\%JAR%" -gui "%EXAMPLES%"
exit