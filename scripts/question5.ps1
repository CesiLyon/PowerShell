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
    Write-Host "Compte '$($login)' supprime."
}

Write-LocaleUserAccount
$loginAdmin = [String] (New-Account -isAdmin $true)
Write-Host -login $loginAdmin
Write-LocaleUserAccount "apres creation compte admin"
$loginNonAdmin = [String] (New-Account)
Write-Host -login $loginNonAdmin
Write-LocaleUserAccount "apres creation compte non admin"
Remove-Account $loginAdmin
Write-LocaleUserAccount "apres suppression compte admin"
Remove-Account $loginNonAdmin
Write-LocaleUserAccount "apres suppression compte non admin"
