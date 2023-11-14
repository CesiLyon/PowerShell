$notepadProcess = Get-Process -Name notepad -ErrorAction SilentlyContinue

if (-not $notepadProcess) {
    Start-Process notepad
    Write-Host "Notepad a ete lance."
} else {
    Write-Host "Notepad est deja en cours d'execution."
}