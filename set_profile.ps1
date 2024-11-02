# Получаем путь к текущей директории
$currentDir = Get-Location

# Путь к файлу профиля
$destinationPath = $PROFILE

# Извлекаем директорию из пути к файлу профиля
$destinationDir = [System.IO.Path]::GetDirectoryName($destinationPath)

# Формируем полный путь к файлу профиля в текущей директории
$sourceProfile = Join-Path $currentDir "Microsoft.PowerShell_profile.ps1"

$sourceSettings = Join-Path $currentDir "amro.omp.json"
$destinationSettings = Join-Path $destinationDir "amro.omp.json"

# Проверяем, существует ли файл в текущей директории
if (Test-Path $sourceProfile) {
    # Проверяем, существует ли директория назначения
    if (!(Test-Path $destinationDir)) {
        # Создаём директорию, если её нет
        New-Item -ItemType Directory -Path $destinationDir
    }

    # Копируем файл профиля в нужную директорию
    Copy-Item -Path $sourceProfile -Destination $destinationPath -Force
    Copy-Item -Path $sourceSettings -Destination $destinationSettings -Force

    Write-Output "Файл профиля успешно скопирован в: $destinationPath"
}
else {
    Write-Output "Файл для копирования не найден: $sourceProfile"
}

# Устанавливаем зависимости 
Install-Module -Name PSReadLine, Terminal-Icons -Force -AllowClobber
winget install --id junegunn.fzf 
winget install --id ajeetdsouza.zoxide
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))