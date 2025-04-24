# Synthèse – Initiation à PowerShell

## 📌 Les notions clés par thème

### 💡 Syntaxe et principes de base

- PowerShell manipule des **objets**, pas du texte brut
- Cmdlets = **Verbe-Nom** (toujours au singulier)
- Objets = **propriétés** + **méthodes**
- Le **pipeline (`|`)** permet de chaîner les objets

### 🔍 Découverte et aide

```powershell
Get-Command        # Lister toutes les commandes disponibles
Get-Help NomCmdlet # Obtenir l’aide d’une commande
Get-Member         # Explorer les membres d’un objet
Update-Help        # Mettre à jour l’aide en ligne
```

### 🔁 Structures de contrôle

```powershell
if ($x -eq 1) { ... } elseif (...) { ... } else { ... }
do { ... } while ($x -ne 'q')
foreach ($item in $liste) { ... }
switch ($choix) { '1' { ... } default { ... } }
```

### 🧮 Variables et types

```powershell
$nom = "Riza"
$nb = 42
$array = @("un", "deux")
$list = New-Object System.Collections.ArrayList
$list.Add("PC1")
```

### 🔄 Manipulation d’objets

```powershell
Get-Process | Where-Object { $_.CPU -gt 100 }
Get-Service | Select Name, Status | Sort-Object Status
```

### 🖨️ Mise en forme et export

```powershell
Format-Table Name, Status
Export-Csv -Path fichier.csv -NoTypeInformation
ConvertTo-Html | Out-File services.html
```

### 🔒 Authentification sécurisée

```powershell
$cred = Get-Credential -UserName "domaine\admin"
Invoke-Command -ComputerName SRV -Credential $cred -ScriptBlock { Get-Process }
```

### 🧱 Fonctions et scripts

```powershell
function Get-SysInfo {
  Get-ComputerInfo | Select OSName, OSArchitecture
}
```

- Place les **fonctions en haut**, le **code principal en bas**
- Utilise `try/catch/finally` pour les erreurs
- Gère les scripts distants avec `Invoke-Command`

---

## ⚠️ Pièges fréquents à éviter

|Erreur fréquente|Solution ou prévention|
|---|---|
|Oublier les guillemets autour des chaînes|`$var = "texte"`|
|Ne pas initialiser une variable|Toujours la définir avant d’y appliquer un test|
|Confondre `Format-*` avec `Export-*`|`Format-*` = texte pour affichage uniquement|
|Mot de passe en dur dans le script|Toujours utiliser `Get-Credential`|
|Modifier une propriété système directe|Toujours passer par `Set-*`|

---

## ✅ Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Utiliser des noms explicites|Clarté dans les fonctions et variables|
|Documenter avec `<# ... #>`|Indispensable en production (usage, auteur, version)|
|Modulariser avec des fonctions|Réutilisable, testable, claire|
|Utiliser `try/catch` autour des opérations sensibles|Prévention des erreurs critiques|
|Utiliser `-WhatIf`, `-Confirm`|Tester les actions destructives avant exécution réelle|
|Gérer l’authentification dynamiquement|Sécuriser l’accès à distance et aux scripts|
|Travailler avec `VS Code` + Git|Pour la collaboration, la clarté, le versionnage|

