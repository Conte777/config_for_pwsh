@echo off
setlocal EnableDelayedExpansion

:: ============================================
:: Script for creating symbolic links
:: ============================================

echo.
echo ========================================
echo   PowerShell Profile and Windows Terminal Setup
echo ========================================
echo.

:: ============================================
:: 1. Check administrator rights
:: ============================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Administrator rights required!
    echo.
    echo Restarting with administrator rights...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo [OK] Administrator rights confirmed
echo.

:: ============================================
:: 2. Define paths
:: ============================================
set "SOURCE_DIR=d:\Projects\config_for_pwsh"
set "PROFILE_SOURCE=%SOURCE_DIR%\Microsoft.PowerShell_profile.ps1"
set "SETTINGS_SOURCE=%SOURCE_DIR%\settings.json"
set "OMP_SOURCE=%SOURCE_DIR%\amro.omp.json"

set "PWSH_PROFILE_DIR=%USERPROFILE%\Documents\PowerShell"
set "PWSH_PROFILE_TARGET=%PWSH_PROFILE_DIR%\Microsoft.PowerShell_profile.ps1"
set "OMP_TARGET=%PWSH_PROFILE_DIR%\amro.omp.json"

set "WT_SETTINGS_DIR=%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
set "WT_SETTINGS_TARGET=%WT_SETTINGS_DIR%\settings.json"

:: ============================================
:: 3. Check source files existence
:: ============================================
echo Checking source files...
set "MISSING_FILES="

if not exist "%PROFILE_SOURCE%" (
    echo [ERROR] File not found: %PROFILE_SOURCE%
    set "MISSING_FILES=1"
)

if not exist "%SETTINGS_SOURCE%" (
    echo [ERROR] File not found: %SETTINGS_SOURCE%
    set "MISSING_FILES=1"
)

if not exist "%OMP_SOURCE%" (
    echo [ERROR] File not found: %OMP_SOURCE%
    set "MISSING_FILES=1"
)

if defined MISSING_FILES (
    echo.
    echo [CRITICAL ERROR] Source files not found!
    echo Make sure all files are in the directory:
    echo %SOURCE_DIR%
    echo.
    pause
    exit /b 1
)

echo [OK] All source files exist
echo.

:: ============================================
:: 4. Create directories for profiles
:: ============================================
echo Creating directories for profiles...

if not exist "%PWSH_PROFILE_DIR%" (
    mkdir "%PWSH_PROFILE_DIR%"
    echo [OK] Created directory: %PWSH_PROFILE_DIR%
)

echo.

:: ============================================
:: 5. Install dependencies
:: ============================================
echo Installing dependencies...
echo.

echo Installing PowerShell modules (PSReadLine, Terminal-Icons)...
powershell -ExecutionPolicy Bypass -Command "Install-Module -Name PSReadLine, Terminal-Icons -Force -AllowClobber"
if %errorLevel% equ 0 (
    echo [OK] PowerShell modules installed
) else (
    echo [WARNING] Failed to install PowerShell modules
)
echo.

echo Installing fzf...
winget install --id junegunn.fzf --accept-package-agreements --accept-source-agreements
if %errorLevel% equ 0 (
    echo [OK] fzf installed
) else (
    echo [WARNING] Failed to install fzf
)
echo.

echo Installing zoxide...
winget install --id ajeetdsouza.zoxide --accept-package-agreements --accept-source-agreements
if %errorLevel% equ 0 (
    echo [OK] zoxide installed
) else (
    echo [WARNING] Failed to install zoxide
)
echo.

echo Installing Oh My Posh...
powershell -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))"
if %errorLevel% equ 0 (
    echo [OK] Oh My Posh installed
) else (
    echo [WARNING] Failed to install Oh My Posh
)
echo.

echo [OK] Dependencies installation completed
echo.

:: ============================================
:: 6. Check target locations
:: ============================================
echo Checking target locations...
set "CONFLICTS="

if exist "%PWSH_PROFILE_TARGET%" (
    echo [WARNING] File already exists: %PWSH_PROFILE_TARGET%
    set "CONFLICTS=1"
)

if exist "%OMP_TARGET%" (
    echo [WARNING] File already exists: %OMP_TARGET%
    set "CONFLICTS=1"
)

if defined CONFLICTS (
    echo.
    echo ========================================
    echo [CRITICAL ERROR] Conflicts detected!
    echo ========================================
    echo.
    echo PowerShell profile files already exist in target locations.
    echo Please remove or move these files manually,
    echo then run this script again.
    echo.
    echo WARNING: Do not delete files if you are not sure!
    echo It is recommended to create a backup before deletion.
    echo.
    pause
    exit /b 2
)

:: For Windows Terminal settings - automatic deletion and replacement
if exist "%WT_SETTINGS_TARGET%" (
    echo [WARNING] File already exists: %WT_SETTINGS_TARGET%
    del /F /Q "%WT_SETTINGS_TARGET%" >nul 2>&1
    if !errorLevel! equ 0 (
        echo [OK] Deleted existing settings.json file
    )
)

echo [OK] Target locations prepared
echo.

:: ============================================
:: 7. Create symbolic links
:: ============================================
echo Creating symbolic links...
echo.

:: PowerShell Core profile
mklink "%PWSH_PROFILE_TARGET%" "%PROFILE_SOURCE%"
if %errorLevel% equ 0 (
    echo [OK] Created symlink for PowerShell Core profile
) else (
    echo [ERROR] Failed to create symlink for PowerShell Core profile
)

:: Oh My Posh theme
mklink "%OMP_TARGET%" "%OMP_SOURCE%"
if %errorLevel% equ 0 (
    echo [OK] Created symlink for Oh My Posh theme
) else (
    echo [ERROR] Failed to create symlink for Oh My Posh theme
)

:: Windows Terminal settings
if exist "%WT_SETTINGS_DIR%" (
    mklink "%WT_SETTINGS_TARGET%" "%SETTINGS_SOURCE%"
    if %errorLevel% equ 0 (
        echo [OK] Created symlink for Windows Terminal settings
    ) else (
        echo [ERROR] Failed to create symlink for Windows Terminal settings
    )
) else (
    echo [WARNING] Windows Terminal not found, skipping settings.json symlink creation
)

:: ============================================
:: 8. Completion
:: ============================================
echo.
echo ========================================
echo   Setup completed successfully!
echo ========================================
echo.
echo Symbolic links created:
echo - PowerShell Core: %PWSH_PROFILE_TARGET%
echo - Oh My Posh theme: %OMP_TARGET%
if exist "%WT_SETTINGS_TARGET%" echo - Windows Terminal: %WT_SETTINGS_TARGET%
echo.
pause
