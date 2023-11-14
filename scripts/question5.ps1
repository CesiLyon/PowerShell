function Write-LocaleUserAccount {
    $comptesLocaux = Get-WmiObject Win32_UserAccount | Where-Object { $_.LocalAccount -eq $true }

    Write-Host "Comptes utilisateurs locaux :"
    foreach ($compte in $comptesLocaux) {
        Write-Host $compte.Name
    }
}

Write-LocaleUserAccount
