@echo off
cd %~dp0

:starting
python main.py %1
set return_value=%errorlevel%
echo Remote server exited with error code %return_value%
echo Checking for required installations
call check_dependencies
if %errorlevel% equ 1 (
    echo Dependencies installed. The server will restart automatically.
    cls
) else (
    echo No dependencies related issue found.
    echo The server will restart after you press a key.
    pause
)
goto starting