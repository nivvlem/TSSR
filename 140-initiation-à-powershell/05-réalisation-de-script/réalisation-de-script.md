# Réalisation d’un script

## 🧠 Méthodologie de création d’un script

### Étapes préparatoires

1. **Définir l’objectif** du script
2. **Lister les actions** nécessaires (tests, vérifications, boucles…)
3. **Formaliser un algorithme** clair, exemple :

```txt
1. Vérifier l’existence d’un dossier
2. Créer s’il n’existe pas
3. Remplir avec des fichiers exemples
4. Archiver les fichiers selon la date
```

4. **Structurer et tester** chaque étape une à une

---

## 🛠️ Environnements de script (IDE)

### PowerShell ISE

- Inclus avec Windows PowerShell
- Console, éditeur, suggestions syntaxiques (IntelliSense)
- Parfait pour les débutants et scripts simples

### Visual Studio Code (VSCode)

- Multiplateforme, léger, extensible
- Supporte PowerShell 5.1 et Core
- Extensions : PowerShell, GitHub, JSON…
- Intégration Git et partage de scripts en dépôt (GitHub)

---

## 💬 Commentaires dans un script

### Commentaires simples

```powershell
# Ceci est un commentaire
Write-Host "Bonjour"  # commentaire en fin de ligne
```

### Bloc de commentaires (multiligne)

```powershell
<#
Ce bloc ne sera pas interprété
Toutes les lignes sont ignorées
#>
```

---

## 📏 Enchaînement des commandes et lisibilité

### Enchaîner sur une seule ligne

```powershell
Get-Service; Get-Process
```

### Commandes sur plusieurs lignes avec backtick

```powershell
Get-Process `
| Sort-Object CPU `
| Select-Object -First 10
```

---

## ❗ Gestion des erreurs

### Options de contrôle

- `-ErrorAction`: contrôle local à la commande
    - `Continue`, `SilentlyContinue`, `Stop`, `Ignore`, etc.
- `$ErrorActionPreference`: comportement global
- `-ErrorVariable` : redirige l’erreur dans une variable personnalisée

### Exemple :

```powershell
Get-Item C:\inexistant -ErrorAction SilentlyContinue -ErrorVariable errFichier
```

---

## 🧱 Structure Try / Catch / Finally

### Exemple simple

```powershell
Try {
  Get-Item C:\Fichier.txt -ErrorAction Stop
}
Catch {
  Write-Host "Erreur : $($_.Exception.Message)"
}
Finally {
  Write-Host "Bloc Finally exécuté."
}
```

- `Try` : code à tester
- `Catch` : exécuté en cas d’erreur bloquante
- `Finally` : toujours exécuté (qu’il y ait erreur ou non)

---

## 🔁 Fonctions et paramètres

### Création d’une fonction

```powershell
Function Hello {
  Write-Host "Bienvenue $env:USERNAME"
}
```

### Fonction avec paramètres

```powershell
Function Addition {
  Param(
    [int]$a,
    [int]$b
  )
  return ($a + $b)
}
Addition -a 2 -b 3
```

### Paramètre obligatoire

```powershell
Param(
  [Parameter(Mandatory=$true)]
  [string]$Nom
)
```

---

## 🌐 Remoting PowerShell

### Activation sur la machine distante

```powershell
Enable-PSRemoting -Force -SkipNetworkProfileCheck
```

### Ouvrir une session distante

```powershell
Enter-PSSession -ComputerName DC01
Exit-PSSession
```

### Utilisation de `New-PSSession`

```powershell
$session = New-PSSession -ComputerName DC01
Invoke-Command -Session $session -ScriptBlock { Get-Process }
Remove-PSSession -Session $session
```

---

## 📦 Exécution simultanée avec `Invoke-Command`

### Exécuter une commande sur plusieurs machines

```powershell
Invoke-Command -ComputerName SRV01,SRV02 -ScriptBlock {
  Get-Service -Name Spooler
}
```

### Passage de variable avec `$Using:`

```powershell
$NomService = "Spooler"
Invoke-Command -ComputerName SRV01 -ScriptBlock {
  Get-Service -Name $Using:NomService
}
```

---

## ✅ À retenir pour les révisions

- Un script structuré commence par un objectif et une logique claire (algorithme)
- ISE pour débuter, VSCode pour des projets plus complexes
- `Try/Catch/Finally` pour fiabiliser l’exécution
- Les fonctions rendent le code **modulaire et réutilisable**
- Le remoting permet de **gérer plusieurs machines à distance efficacement**

---

## 📌 Bonnes pratiques professionnelles

- Toujours **commenter** vos scripts
- Isoler les fonctions et réutiliser le code
- Éviter les erreurs bloquantes avec `Try/Catch`
- Utiliser le **Remoting** pour les tâches répétitives sur plusieurs serveurs
- Tester chaque bloc indépendamment avant mise en production

---

## 🔗 Commandes utiles

```powershell
Function Nom { Param(...) ... }
Try { ... } Catch { ... } Finally { ... }
Enable-PSRemoting -Force
Enter-PSSession / Exit-PSSession
Invoke-Command -ComputerName ...
```
