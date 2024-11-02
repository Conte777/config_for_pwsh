Set-PSReadLineKeyHandler -Chord Ctrl+v -Function Paste
Set-PSReadLineKeyHandler -Chord Ctrl+Delete -Function KillWord
Set-PSReadLineKeyHandler -Chord Ctrl+z -Function Undo
Set-PSReadLineKeyHandler -Chord Ctrl+c -Function Copy
Set-PSReadLineKeyHandler -Chord Ctrl+x -Function Cut
Set-PSReadLineKeyHandler -Chord Ctrl+Backspace -Function BackwardKillWord
Set-PSReadLineKeyHandler -Chord Ctrl+w -Function BackwardKillWord
Set-PSReadLineKeyHandler -Chord Ctrl+a -Function SelectAll
Set-PSReadLineKeyHandler -Chord Shift+Ctrl+RightArrow -Function SelectNextWord
Set-PSReadLineKeyHandler -Chord Shift+Ctrl+LeftArrow -Function SelectBackwardWord


oh-my-posh init pwsh --config 'amro.omp.json' | Invoke-Expression

Import-Module -Name PSReadLine
Set-PSReadLineOption -PredictionViewStyle ListView

Import-Module -Name Terminal-Icons

Write-Output "You can enter cdi to see a list of options"
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Set-Alias -Name cd -Value z -Option AllScope
Set-Alias -Name cdi -Value zi -Option AllScope
