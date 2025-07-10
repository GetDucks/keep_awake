@echo off
setlocal

:: Configuration
set REPO_URL=https://github.com/yourusername/keep-awake-app.git
set APP_DIR=%cd%\keep-awake-app
set PY_SCRIPT=keep_awake_tray.py
set INNO_URL=https://jrsoftware.org/download.php/is.exe
set INNO_INSTALLER=is.exe
set INNO_SCRIPT=keep_awake.iss

echo ==================================================
echo   KeepAwake Setup Script
echo ==================================================

:: Check for Git
where git >nul 2>&1 || (
    echo Git is not installed. Please install Git and rerun this script.
    pause
    exit /b 1
)

:: Clone repo
if not exist "%APP_DIR%" (
    echo Cloning repo...
    git clone %REPO_URL%
) else (
    echo Repo already exists. Pulling latest changes...
    cd "%APP_DIR%"
    git pull
)

cd "%APP_DIR%"

:: Check Python
where python >nul 2>&1 || (
    echo Python not found. Please install Python and rerun this script.
    pause
    exit /b 1
)

:: Install dependencies
echo Installing Python packages...
python -m pip install --upgrade pip
python -m pip install pystray pillow pyinstaller

:: Build EXE
echo Building EXE with PyInstaller...
python -m PyInstaller --noconsole --onefile %PY_SCRIPT%

:: Download Inno Setup if not installed
echo.
echo Checking Inno Setup...
where iscc >nul 2>&1
if errorlevel 1 (
    echo Inno Setup not found. Downloading...
    curl -L -o %INNO_INSTALLER% %INNO_URL%
    start /wait %INNO_INSTALLER%
)

:: Build installer
echo Building Windows Installer...
if exist "%INNO_SCRIPT%" (
    "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" %INNO_SCRIPT%
) else (
    echo ERROR: %INNO_SCRIPT% not found.
    pause
    exit /b 1
)

echo.
echo ✅ Setup complete! Your installer should be in Output\KeepAwakeInstaller.exe
pause
