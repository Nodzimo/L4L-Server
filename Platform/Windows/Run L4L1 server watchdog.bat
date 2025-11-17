@echo off
setlocal

color 0E
set name=L4L1
title %name% server watchdog

:loop

echo [%date% %time%] %name% server is up and running, GL ^& HF!
start /wait Servers/L4L1/srcds -console -game left4dead2 +map c1m2_streets

echo.
echo [%date% %time%] %name% server has stopped (crashed or shut down)

echo.
echo Restart it?
pause
echo.

goto loop