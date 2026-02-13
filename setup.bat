@echo off
setlocal EnableDelayedExpansion

:: Set encoding to UTF-8
chcp 65001 >nul 2>&1

:: --- PREMIUM COLOR INITIALIZATION ---
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "C_RST=%ESC%[0m"
set "C_CYN=%ESC%[36m"
set "C_BCYN=%ESC%[96m"
set "C_MAG=%ESC%[35m"
set "C_BMAG=%ESC%[95m"
set "C_GRN=%ESC%[32m"
set "C_RED=%ESC%[31m"
set "C_YLW=%ESC%[33m"
set "C_GRAY=%ESC%[90m"

cd /d "%~dp0"
title ⚡ ZYRON ASSISTANT — PREMIUM SETUP ⚡

cls
:: Render Big Zyron Logo using single-line stable PowerShell call
powershell -NoProfile -Command "Write-Host ' '; Write-Host '   .──────────────────────────────────────────────────────────.' -ForegroundColor Magenta; Write-Host '   │                                                          │' -ForegroundColor Magenta; Write-Host '   │   ███████╗██╗   ██╗██████╗  ██████╗ ███╗   ██╗           │' -ForegroundColor Magenta; Write-Host '   │   ╚══███╔╝╚██╗ ██╔╝██╔══██╗██╔═══██╗████╗  ██║           │' -ForegroundColor Magenta; Write-Host '   │     ███╔╝  ╚████╔╝ ██████╔╝██║   ██║██╔██╗ ██║           │' -ForegroundColor Magenta; Write-Host '   │    ███╔╝    ╚██╔╝  ██╔══██╗██║   ██║██║╚██╗██║           │' -ForegroundColor Magenta; Write-Host '   │   ███████╗   ██║   ██║  ██║╚██████╔╝██║ ╚████║           │' -ForegroundColor Magenta; Write-Host '   │   ╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝           │' -ForegroundColor Magenta; Write-Host '   │                                                          │' -ForegroundColor Magenta; Write-Host '   │            ⚡ Z Y R O N   A S S I S T A N T ⚡             │' -ForegroundColor Cyan; Write-Host '   │                                                          │' -ForegroundColor Magenta; Write-Host '   .──────────────────────────────────────────────────────────.' -ForegroundColor Magenta"


echo.
echo   !C_CYN!  ══════════════════════════════════════════════════
echo            !C_BCYN!⚡ SYSTEM INITIALIZATION ENGAGED ⚡!C_CYN!
echo     ══════════════════════════════════════════════════!C_RST!
echo.

:: ===================== STEP 1 - PYTHON CHECK =====================
echo   !C_CYN![1/6]!C_RST! Scanning for Python Environment...

:: Check for Python 3.11 specifically as it's the target
py -3.11 --version >nul 2>&1
if not errorlevel 1 (
    set "PYTHON_CMD=py -3.11"
    echo     !C_GRN![✓] Found Python 3.11 ^(via Launcher^)!C_RST!
    goto :FoundPython
)

for /f "tokens=2 delims= " %%v in ('python --version 2^>nul') do set CUR_VER=%%v
if "!CUR_VER:~0,4!"=="3.11" (
    set "PYTHON_CMD=python"
    echo     !C_GRN![✓] Default Python is 3.11!C_RST!
    goto :FoundPython
)

if "!CUR_VER:~0,4!"=="3.10" set "PYTHON_CMD=python" & goto :FoundPython
if "!CUR_VER:~0,4!"=="3.12" set "PYTHON_CMD=python" & goto :FoundPython

echo.
echo     !C_RED![X] CRITICAL: Python 3.11 not discovered!!C_RST!
echo.
pause
exit /b 1

:FoundPython
echo.

:: ===================== STEP 2 - ENVIRONMENT SETUP =====================
echo   !C_![2/6]!C_! Configuring Workspace...

if exist venv (
    echo     !C_![i] Closing active processes...!C_!
    taskkill /f /im python.exe /t >nul 2>&1
    taskkill /f /im pythonw.exe /t >nul 2>&1
    timeout /t 1 /nobreak >nul
    echo     !C_![i] Refreshing old files...!C_!
    rmdir /s /q venv >nul 2>&1
    if exist venv (
        echo.
        echo     !C_![!] ERROR: Access Denied to 'venv' folder.!C_!
        echo     !C_!Please close VS Code or any other terminal using this folder.!C_!
        echo.
        pause
        exit /b 1
    )
)

echo     !C_![+] Building virtual environment...!C_!
%PYTHON_CMD% -m venv venv

if errorlevel 1 (
    echo.
    echo     !C_![X] Workspace creation FAILED!!C_!
    echo.
    pause
    exit /b 1
)
echo     !C_![✓] Workspace ready.!C_!
echo.

:: ===================== STEP 3 - DEPENDENCIES =====================
echo   !C_![3/6]!C_! Deploying Neural Modules...
call venv\Scripts\activate
python -m pip install --upgrade pip --quiet
pip install -e .

if errorlevel 1 (
    echo.
    echo     !C_![X] Submodule installation FAILED!!C_!
    echo.
    pause
    exit /b 1
)
echo     !C_![✓] Systems online.!C_!
echo.

:: ===================== STEP 4 - OLLAMA CHECK =====================
echo   !C_![4/6]!C_! Verifying AI Engine (Ollama)...
ollama --version >nul 2>&1
if errorlevel 1 (
    echo     !C_![!] Ollama disconnected. Local AI suspended.!C_!
    echo     !C_!Install manually from ollama.com for full capability.!C_!
) else (
    echo     !C_![✓] Neural engine linked.!C_!
)
echo.

:: ===================== STEP 5 - SILENT LAUNCHER =====================
echo   !C_![5/6]!C_! Configuring Stealth Protocols...

if not exist .env (
    (
        echo TELEGRAM_TOKEN=PASTE_TOKEN_HERE
        echo MODEL_NAME=qwen2.5-coder:7b
    ) > .env
    echo     !C_![!] .env generated. TELEGRAM_TOKEN REQUIRED.!C_!
)

(
    echo Set WshShell = CreateObject^("WScript.Shell"^)
    echo WshShell.Run chr^(34^) ^& "%~dp0start_zyron.bat" ^& chr^(34^), 0
    echo Set WshShell = Nothing
) > run_silent.vbs

echo     !C_![✓] Stealth launcher primed.!C_!
echo.

:: ===================== STEP 6 - AUTO-START SETUP =====================
echo   !C_![6/6]!C_! Finalizing Startup Sequence...

set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

:: Cleanup old entries
if exist "%STARTUP_FOLDER%\PikachuAgent.lnk" del "%STARTUP_FOLDER%\PikachuAgent.lnk" >nul 2>&1
if exist "%STARTUP_FOLDER%\ZyronAssistant.lnk" del "%STARTUP_FOLDER%\ZyronAssistant.lnk" >nul 2>&1

echo.
echo     !C_![?] SYSTEM PROMPT:!C_!
echo     !C_!Activate automatic resonance on PC boot?!C_!
echo.
choice /c YN /m "     Enable Autostart? "

if errorlevel 2 (
    echo.
    echo     !C_![-] Startup resonance bypassed.!C_!
    goto :FinishSetup
)

echo.
echo     !C_![+] Deploying startup artifact...!C_!

(
    echo Set WshShell = WScript.CreateObject^("WScript.Shell"^)
    echo Set oShellLink = WshShell.CreateShortcut^("%STARTUP_FOLDER%\ZyronAssistant.lnk"^)
    echo oShellLink.TargetPath = "%~dp0run_silent.vbs"
    echo oShellLink.WorkingDirectory = "%~dp0"
    echo oShellLink.Description = "Zyron Desktop Assistant - Auto Start"
    echo oShellLink.IconLocation = "shell32.dll,137"
    echo oShellLink.Save
) > create_startup_shortcut.vbs

cscript //nologo create_startup_shortcut.vbs
del create_startup_shortcut.vbs

if exist "%STARTUP_FOLDER%\ZyronAssistant.lnk" (
    echo     !C_![✓] Autostart successfully armed!!C_!
) else (
    echo     !C_![!] Warning: Shortcut deployment failed.!C_!
)

:FinishSetup
echo.
echo   !C_!  ══════════════════════════════════════════════════
echo                !C_!✅ SYSTEM READY — ZYRON ACTIVE!C_!
echo     ══════════════════════════════════════════════════!C_!
echo.
echo   !C_!  🎯 MISSION PARAMETERS:!C_!
echo   !C_!  ──────────────────────────────────────────────────!C_!

call :Typewriter "   - Credentials: Check .env for Telegram Token"
call :Typewriter "   - Quick Launch: Run run_silent.vbs"
call :Typewriter "   - Management: Rerun setup to reconfigure"

echo   !C_!  ──────────────────────────────────────────────────!C_!
echo.
pause
exit /b

:Typewriter
set "text=%~1"
powershell -NoProfile -Command "$text='%text%'; for ($i=0; $i -lt $text.Length; $i++) { Write-Host $text[$i] -ForegroundColor Cyan -NoNewline; Start-Sleep -Milliseconds 15 }"
echo.
exit /b

