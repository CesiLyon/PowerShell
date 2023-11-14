function Test-AdminPrivileges {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator
    return $currentUser.IsInRole($adminRole)
}

if (-not (Test-AdminPrivileges)) {
    Write-Host "Le script doit etre execute en tant qu'administrateur. Veuillez relancer le script en tant qu'administrateur."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Exit
}

function Write-LocaleUserAccount {
    param([String]$moment = "actuellement")
    $comptesLocaux = Get-WmiObject Win32_UserAccount | Where-Object { $_.LocalAccount -eq $true }

    Write-Host "Comptes utilisateurs locaux $($moment) :"
    foreach ($compte in $comptesLocaux) {
        Write-Host $compte.Name
    }
}

function Get-SecurePassword {
    param([String]$compte)
    $securePassword = Read-Host -Prompt "Entrez le mot de passe pour '$($compte)'" -AsSecureString
    return $securePassword
}

function Compare-Password {
    param([System.Security.SecureString]$password, [System.Security.SecureString]$verifyPassword)
    return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)) -eq [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($verifyPassword))
}

function New-Account {
    param([bool]$isAdmin = $false)
    $login = Read-Host -Prompt "Entrez le login du nouveau compte $('non ' * (-not $isAdmin))administrateur"
    $password = Get-SecurePassword $login
    $verifyPassword = $null
    do {
        $verifyPassword = Get-SecurePassword $login
        if (-not (Compare-Password -password $password -verifyPassword $verifyPassword)) {
            Write-Host "Les mots de passe ne correspondent pas. Veuillez reessayer."
        }
    } while (-not (Compare-Password -password $password -verifyPassword $verifyPassword))

    New-LocalUser $login -password $password -PasswordNeverExpires
    if ($isAdmin) {
        Add-LocalGroupMember "Administrateurs" $login
    }
    Write-Host "Nouveau compte $('non ' * (-not $isAdmin))administrateur '$($login)' cree."

    return $login
}

function Remove-Account {
    param([String]$login)
    Remove-LocalUser -Name $login.Split(" ")[0]
    Write-Host "Compte '$($login.Split(" ")[0])' supprime."
}

function Show-Menu {
    Write-Host "Bienvenue dans le gestionnaire de comptes utilisateurs."
    Write-Host "Veuillez choisir une action :"
    Write-Host "1. Creer un compte administrateur"
    Write-Host "2. Creer un compte utilisateur"
    Write-Host "3. Afficher les comptes utilisateurs locaux"
    Write-Host "4. Supprimer un compte utilisateur"
    Write-Host "5. Afficher ce menu d'aide"
    Write-Host "6. Quitter"
}

do {
    Show-Menu
    $userChoice = Read-Host -Prompt "Entrez votre choix"
    switch ($userChoice) {
        "1" {
            $loginAdmin = [String] (New-Account -isAdmin $true)
            Write-Host -login $loginAdmin
            Break
        }
        "2" {
            $loginNonAdmin = [String] (New-Account)
            Write-Host -login $loginNonAdmin
            Break
        }
        "3" {
            Write-LocaleUserAccount
            Break
        }
        "4" {
            $login = Read-Host -Prompt "Entrez le login du compte a supprimer"
            Remove-Account $login
            Break
        }
        "5" {
            Show-Menu
            Break
        }
        "6" {
            Write-Host "Au revoir."
            Exit
        }
        Default {
            Write-Host "Choix invalide. Veuillez reessayer."
        }
    }
} while ($true)
