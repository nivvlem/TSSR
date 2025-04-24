# TP – Variables et structures PowerShell

## 📄 Énoncé synthétisé

> **Machine utilisée :** CLI01  

Ce TP contient 5 exercices concrets autour des variables, des structures conditionnelles et de boucles.

---

## ✅ Résolution structurée

### 🔹 1. Manipulation de journaux d’événements

**Stocker l’objet `Get-EventLog System` dans une variable** :

```powershell
$log = Get-EventLog -LogName System
```

**Afficher l’entrée n°10 et son index :**

```powershell
$log[9]  # car index commence à 0
$log[9].Index
```

**Addition des index 10 et 20 :**

```powershell
$add = $log[9].Index + $log[19].Index
$add
```

---

### 🔹 2. Jeu de devinette – Date de naissance

**Script `guess-date.ps1` :**

```powershell
$birthdate = Read-Host "Entrez votre date de naissance (format JJ/MM)"
$guess = ""
$attempts = 0

do {
    $guess = Read-Host "Devinez la date de naissance (JJ/MM)"
    $attempts++

    if ($guess -eq $birthdate) {
        Write-Host "Bravo ! Date correcte."
    } elseif ($guess -lt $birthdate) {
        Write-Host "C’est après."
    } else {
        Write-Host "C’est avant."
    }

} while ($guess -ne $birthdate)

Write-Host "Vous avez trouvé en $attempts tentative(s)."
```

---

### 🔹 3. Récupération des utilisateurs AD actifs/inactifs

```powershell
$UserActif = Get-ADUser -Filter 'Enabled -eq $true'
$UserInactif = Get-ADUser -Filter 'Enabled -eq $false'

"Utilisateurs actifs : $($UserActif.Count)"
"Utilisateurs inactifs : $($UserInactif.Count)"
```

---

### 🔹 4. Menu interactif à choix multiples

```powershell
do {
    Clear-Host
    Write-Host "Bienvenue dans l'outil d'inventaire, faites votre choix :"
    Write-Host "1) Affichage des ordinateurs du domaine"
    Write-Host "2) Affichage des groupes de domaine locaux"
    Write-Host "3) Importation des utilisateurs AD via CSV"
    Write-Host "4) Quitter"

    $choix = Read-Host "Entrez votre choix"

    switch ($choix) {
        '1' { Get-ADComputer -Filter * | Select Name, OperatingSystem }
        '2' { Get-ADGroup -Filter * | Where {$_.GroupScope -eq "DomainLocal"} }
        '3' {
            Import-Csv .\users.csv -Delimiter ";" | ForEach-Object {
                New-ADUser -Name $_.Nom -GivenName $_.Prenom -SamAccountName $_.SAM -AccountPassword (ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force) -Enabled $true
            }
        }
        '4' { Write-Host "Au revoir." }
        default { Write-Host "Erreur : choix invalide." }
    }
    Pause
} while ($choix -ne '4')
```

---

### 🔹 5. Réinitialisation et activation des comptes AD

```powershell
$users = Get-ADUser -Filter *

foreach ($user in $users) {
    $pwd = ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force
    Set-ADAccountPassword -Identity $user.SamAccountName -NewPassword $pwd -Reset

    if (-not $user.Enabled) {
        Enable-ADAccount -Identity $user.SamAccountName
    }
}
```

---

## 🧠 À retenir pour les révisions

- Toutes les structures (`if`, `do/while`, `switch`, `foreach`) sont combinables
- `ArrayList` utile si besoin d’un tableau dynamique
- `Pause`, `Clear-Host`, `Switch`, `Break` sont très pratiques pour créer des menus interactifs
- Penser à **tester les filtres AD avant toute action** (ex : `Disable-ADUser`)

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Isoler chaque logique dans un bloc|Meilleure lisibilité|
|Ajouter un compteur de tentatives|Pour retour utilisateur et statistique|
|Toujours initialiser ses variables|Évite erreurs inattendues dans les structures conditionnelles|
|Utiliser des variables parlantes|Ex : `$UserActif` et non `$ua`|
|Bien gérer les erreurs d’import|Pour éviter les doublons ou mauvaises données AD|
