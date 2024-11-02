# Установка всех зависимостей
```
Install-Module -Name PSReadLine, Terminal-Icons -Force -AllowClobber
winget install --id junegunn.fzf 
winget install --id ajeetdsouza.zoxide
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
```

# Плагины 

**oh-my-posh**

Для красивого вывода строки состояния

**PSReadLine**

Для подсказок при вводе команды

**Terminal-Icons**

Для красивых иконок 

**zoxide**

Улучшение команды cd
