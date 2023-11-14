# PowerShell

Membres du groupe :

- Josselin (GMSI) ;
- Sylvain (GMSI) ;
- Florent (GMSI) ;
- Mathis (DI).

## Question 1

**Donnez 7 caractéristiques d'une variable en programmation (pas uniquement PowerShell, mais programmation en général).**

1. Nom

        C'est le nom de la variable, il doit être unique dans sa portée, ne pas commencer par un chiffre, ne pas contenir d'espace et ne pas être un mot réservé du langage. En fonction du langage, il peut être sensible à la casse.

2. Type

        C'est le type de la variable, il peut être de type primitif (entier, flottant, booléen, caractère, chaîne de caractères) ou de type complexe (tableau, liste, dictionnaire, objet, etc.). En fonction du langage, il peut être implicite ou explicite.

3. Valeur

        C'est la valeur dans la case mémoire de la variable, elle peut être modifiée directement ou indirectement en fonction du langage.

4. Portée

        C'est la zone du programme dans laquelle la variable est accessible, elle peut être globale (accessible partout), locale (accessible uniquement dans une fonction, une classe ou une boucle). Dans le cas d'un langage orienté objet, la portée peut être privée (accessible uniquement dans la classe), protégée (accessible dans la classe et ses enfants) ou publique (accessible partout).

5. Durée de vie

        C'est la durée pendant laquelle la variable est accessible, elle peut être temporaire (accessible uniquement dans une fonction, une classe ou une boucle) ou permanente (accessible partout). Dans certains langages, la durée de vie peut être définie par l'utilisateur, tandis que dans d'autres, elle est définie par le langage, et celui-ci se charge de la gestion de la mémoire. En java, le garbage collector se charge de la gestion de la mémoire en supprimant les variables inutilisées.

6. Mutabilité

        C'est la possibilité de modifier la valeur de la variable, elle peut être mutable (modifiable) ou immuable (non modifiable). En fonction du langage, la mutabilité peut être définie par l'utilisateur ou par le langage. Une variable immuable est appelée constante et ne peut être modifiée après son initialisation.

7. Initialisation

        C'est la valeur initiale de la variable, elle peut être définie par l'utilisateur ou par le langage. En fonction du langage, la variable peut être initialisée à sa déclaration ou à un autre moment. Par exemple, en java, l'attribut d'une classe peut être initialisé dans le constructeur de la classe, mais déclaré en dehors.

## Question 2

[Script question 2](scripts/question2.ps1)

```powershell
$nomUtilisateur = Read-Host -Prompt "Veuillez saisir votre prenom"

$ageUtilisateur = Read-Host -Prompt "Veuillez saisir votre age"

Write-Host "Bonjour $nomUtilisateur, vous avez $ageUtilisateur ans."
```

## Question 3

[Script question 3](scripts/question3.ps1)

```powershell
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
```

## Question 4

[Script question 4](scripts/question4.ps1)

```powershell
$notepadProcess = Get-Process -Name notepad -ErrorAction SilentlyContinue

if (-not $notepadProcess) {
    Start-Process notepad
    Write-Host "Notepad a ete lance."
} else {
    Write-Host "Notepad est deja en cours d'execution."
}
```

## Question 5