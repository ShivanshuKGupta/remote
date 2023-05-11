@echo off
cd %~dp0

echo Checking for installations required
check_dependencies && start python main.py