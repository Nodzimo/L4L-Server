@echo off
setlocal

color 0E
set name=Dev
title %name% server watchdog

:loop

echo [%date% %time%] %name% server is up and running, GL ^& HF!
start /wait Servers/%name%/srcds -console -game left4dead2 +map c1m2_streets

echo(
echo [%date% %time%] %name% server has stopped (crashed or shut down)

echo(
echo Restart it?
pause
echo(

goto loop