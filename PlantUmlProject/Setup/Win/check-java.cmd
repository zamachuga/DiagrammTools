@echo off
echo Checking Java...
java -version 2>&1 || (
  echo ERROR: Java not found!
  echo.
  echo Run install-java.cmd to install Java automatically.
  pause
  exit /b 1
)
echo Java is available.
pause