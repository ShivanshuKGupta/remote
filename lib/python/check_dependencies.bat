@echo off

echo Checking for Chocolatey...
choco -? >nul 2>&1
if errorlevel 1 (
    echo Chocolatey is not installed
    echo Installing Chocolatey...
    set "ChocolateyInstall=%SystemDrive%\ProgramData\Chocolatey"
    if not exist "%ChocolateyInstall%" mkdir "%ChocolateyInstall%"
    powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) -y -noexit"
)

echo Checking for Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo Python is not installed
    echo Installing Python...
    choco install python -y
)

echo Checking for mss and pyautogui packages...
python -c "import mss" >nul 2>&1
if errorlevel 1 (
    echo Installing mss package...
    pip install mss
)

python -c "import pyautogui" >nul 2>&1
if errorlevel 1 (
    echo Installing pyautogui package...
    pip install pyautogui
)

echo Done.
