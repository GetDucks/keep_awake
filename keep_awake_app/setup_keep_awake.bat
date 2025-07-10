@echo off
setlocal
cd /d "%~dp0"

set "PY_SCRIPT=keep_awake_tray.py"
set "PYEXE=dist\keep_awake_tray.exe"
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "SHORTCUT_NAME=KeepAwake.lnk"

echo ==================================================
echo   KeepAwake Setup Script
echo ==================================================

:: STEP 1: Check for Python
where py >nul 2>&1 && (
    echo [OK] Python launcher found.
) || (
    echo [ERROR] Python launcher not found. Please install Python and retry.
    pause
    exit /b 1
)

:: STEP 2: Install dependencies
echo [INFO] Installing required Python packages...
py -m pip install --upgrade pip
py -m pip install pyinstaller pystray pillow
echo [OK] Python packages installed.

:: STEP 3: Build the EXE
echo [INFO] Building EXE with PyInstaller...
py -m PyInstaller --noconsole --onefile "%PY_SCRIPT%"
if exist "%PYEXE%" (
    echo [OK] Built: %PYEXE%
) else (
    echo [ERROR] EXE not created!
    pause
    exit /b 1
)

:: STEP 4: Create shortcut in Startup
echo [INFO] Creating startup shortcut...
powershell -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%STARTUP_FOLDER%\%SHORTCUT_NAME%'); $s.TargetPath='%CD%\%PYEXE%'; $s.Save()"

if exist "%STARTUP_FOLDER%\%SHORTCUT_NAME%" (
    echo [OK] Shortcut added to startup.
) else (
    echo [ERROR] Failed to create startup shortcut!
)

echo.
echo [SUCCESS] Setup complete. KeepAwake will launch at startup.
pause
