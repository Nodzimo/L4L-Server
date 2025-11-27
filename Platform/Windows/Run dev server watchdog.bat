@echo off
setlocal

color 0E
set name=Dev
title %name% server watchdog

@REM Windows cannot find 'Servers/Dev/srcds'. Make sure you typed the name correctly, and then try again.
set "BASE_DIR=%~dp0"
@REM Полный путь к папке, где лежит этот .bat, чтобы запускать его из любого места.

:loop

echo [%date% %time%] %name% server is up and running, GL ^& HF!
start "" /wait "%BASE_DIR%Servers/%name%/srcds" -console -game left4dead2 +map "c1m2_streets realism" -dev +servercfgfile custom/server9

echo(
echo [%date% %time%] %name% server has stopped (crashed or shut down)

echo(
echo Restart it?
pause
echo(

goto loop