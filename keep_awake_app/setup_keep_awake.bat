@echo off
setlocal

set REPO_URL=https://github.com/yourusername/keep-awake-app.git
set APP_DIR=%cd%\keep-awake-app
set PY_SCRIPT=keep_awake_tray.py
set INNO_SCRIPT=keep_awake.iss

echo ==================================================
echo   KeepAwake Setup Script
echo ==================================================

where git >nul 2>&1 || (
    echo Git is not installed. Please install Git and rerun this script.
    pause
    exit /b 1
)

if not exist "%APP_DIR%" (
    echo Cloning repo...
    git clone %REPO_URL%
) else (
    echo Repo already exists. Pulling latest changes...
    cd "%APP_DIR%"
    git pull
)

cd "%APP_DIR%"

where python >nul 2>&1 || (
    echo Python not found. Please install Python and rerun this script.
    pause
    exit /b 1
)

echo Installing Python packages...
python -m pip install --upgrade pip
python -m pip install pystray pillow pyinstaller

echo Building EXE with PyInstaller...
python -m PyInstaller --noconsole --onefile %PY_SCRIPT%

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
