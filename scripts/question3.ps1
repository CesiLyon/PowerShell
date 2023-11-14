$nombreSecret = Get-Random -Minimum 0 -Maximum 101

$nombreEssais = 0

function Get-Essai {
    return Read-Host "Devinez le nombre (entre 0 et 100)"
}

do {
    $essaiUtilisateur = Get-Essai
    $nombreEssais++

    if ($essaiUtilisateur -gt $nombreSecret) {
        Write-Host "Trop haut ! Mon nombre est plus bas." -ForegroundColor Red
    }
    elseif ($essaiUtilisateur -lt $nombreSecret) {
        Write-Host "Trop bas ! Mon nombre est superieur." -ForegroundColor Blue
    }
    else {
        Write-Host "Bravo, vous avez trouve en $nombreEssais essais !" -ForegroundColor Green
    }
} while ($essaiUtilisateur -ne $nombreSecret)
