# TP – Outils pour le scripting PowerShell

## 📄 Énoncé synthétisé

> **Machine utilisée :** CLI01 (client) et CD01 (serveur)  

### Consignes principales :

1. Créer un **script** qui teste plusieurs noms de services transmis en paramètre
    - Aucun message affiché si le service n’existe pas, mais le consigner dans une variable
    - Un message final s'affiche à la fin du traitement
2. Transformer ce script en **fonction** prenant le nom du service en paramètre
3. **Créer une session distante PowerShell** vers le serveur CD01 et la stocker dans une variable
4. Créer un **script** pour rechercher les ordinateurs dans l’AD
    - Si ce ne sont pas des **contrôleurs de domaine**, alors déclencher leur extinction
5. Transformer ce script en **fonction** avec le nom du domaine en paramètre
6. Modifier le comportement de PowerShell ISE :
    - Stocker les erreurs dans une variable
    - Ne plus afficher les erreurs dans la console

---

## ✅ Résolution structurée

### 🔹 1. Tester la présence de services

```powershell
$Services = @("Spooler", "NonExistant", "BITS")
$Missing = @()

foreach ($svc in $Services) {
    try {
        Get-Service -Name $svc -ErrorAction Stop > $null
    } catch {
        $Missing += $svc
    }
}

Write-Host "Tous les services ont été vérifiés."
Write-Host "Services introuvables : $($Missing -join ", ")"
```

### 🔹 2. Transformation en fonction

```powershell
function Test-ServiceExistence {
    param ([string[]]$Services)
    $Missing = @()
    foreach ($svc in $Services) {
        try {
            Get-Service -Name $svc -ErrorAction Stop > $null
        } catch {
            $Missing += $svc
        }
    }
    return $Missing
}

# Exemple d’appel :
Test-ServiceExistence -Services @("WSearch", "FakeService")
```

---

### 🔹 3. Créer une session distante vers CD01

```powershell
$session = New-PSSession -ComputerName CD01
```

---

### 🔹 4. Éteindre les machines non contrôleurs de domaine

```powershell
$computers = Get-ADComputer -Filter * -Property *
foreach ($comp in $computers) {
    if ($comp.PrimaryGroupID -ne 516) {
        Stop-Computer -ComputerName $comp.Name -Force -WhatIf
    }
}
```

> ✅ L’ID 516 correspond aux contrôleurs de domaine (à valider selon contexte AD)

> Utilise `-WhatIf` pour simuler avant de déployer

---

### 🔹 5. Version fonction avec domaine en paramètre

```powershell
function Stop-NonDC {
    param ([string]$Domain)
    $computers = Get-ADComputer -Filter * -Server $Domain -Property *
    foreach ($comp in $computers) {
        if ($comp.PrimaryGroupID -ne 516) {
            Stop-Computer -ComputerName $comp.Name -Force -WhatIf
        }
    }
}
```

---

### 🔹 6. Modifier durablement le comportement de PowerShell ISE

```powershell
$ErrorActionPreference = 'SilentlyContinue'
$global:LastErrors = @()
Register-EngineEvent PowerShell.OnError -Action {
    $global:LastErrors += $Event.MessageData
}
```

> À placer dans le **profil ISE** : `$PROFILE.CurrentUserCurrentHost`

---

## 🧠 À retenir pour les révisions

- Utiliser `try/catch` pour capter les erreurs de service
- Le remoting avec `New-PSSession` permet d’exécuter des scripts sur un serveur distant
- Tester les machines AD selon leur rôle avant de les administrer
- ISE peut être personnalisé via `$PROFILE` pour adapter son comportement

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Toujours encapsuler le code dans des fonctions|Meilleure lisibilité et réutilisabilité|
|Utiliser `try/catch` pour tous les accès système|Éviter les plantages silencieux|
|Tester avec `-WhatIf` avant de déployer|Pour simuler sans danger|
|Centraliser les erreurs dans une variable globale|Permet de les logguer ou afficher plus tard|
|Isoler le code d’extinction dans une fonction|Empêche les erreurs de déploiement massif involontaire|
