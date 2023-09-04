@echo off
cd %~dp0

echo Checking for installations required
call check_dependencies
:starting
python main.py %1
set return_value=%errorlevel%
echo Remote server exited with error code %return_value%
echo The server will restart after you press a key
pause
goto starting