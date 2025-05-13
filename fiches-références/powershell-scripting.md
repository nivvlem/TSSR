# Scripting PowerShell (Windows)

## 📌 Présentation

PowerShell est un shell et un langage de script orienté objet, développé par Microsoft. Il permet de piloter Windows de façon fine et automatisée : gestion de fichiers, utilisateurs, services, Active Directory, GPO…

---

## 🧱 Structure d’un script PowerShell

```powershell
# Fichier .ps1
param (
  [string]$Nom = "inconnu"
)

function Bonjour {
  param($nom)
  Write-Output "Bonjour $nom !"
}

Bonjour $Nom
```

---

## 📦 Variables

```powershell
$prenom = "Alice"
Write-Host "Bienvenue $prenom"
```
- Toutes les variables commencent par `$`
- Typage dynamique (optionnellement fort : `[int]`, `[string]`...)

### 🧾 Arguments (via `$args` ou `param()`)

```powershell
param(
  [string]$Nom,
  [int]$Age
)

Write-Host "Nom : $Nom, Âge : $Age"
```

---

## 🔁 Structures de contrôle
### Conditions

```powershell
if ($Age -ge 18) {
  Write-Host "Adulte"
} elseif ($Age -ge 13) {
  Write-Host "Adolescent"
} else {
  Write-Host "Enfant"
}
```

### Boucles

```powershell
for ($i = 0; $i -lt 5; $i++) {
  Write-Output "Ligne $i"
}

foreach ($user in $liste) {
  Write-Output $user
}
```

---

## 🔧 Fonctions

```powershell
function Addition {
  param($a, $b)
  return $a + $b
}

$resultat = Addition 2 3
```

## 🚦 Codes de retour
- `$LASTEXITCODE` : code retour d’un programme externe
- `$?` : True/False selon le succès de la dernière commande

## 📁 Fichiers & tests

```powershell
if (Test-Path "C:\test\fichier.txt") {
  Write-Host "Fichier présent"
}
```

---

## ⚠️ Erreurs fréquentes

- Ne pas exécuter `Set-ExecutionPolicy RemoteSigned` pour autoriser les scripts
- Oublier d’utiliser `param()` pour les paramètres
- Confondre `Write-Host` (affichage) et `Write-Output` (retour de fonction)
- Ne pas gérer les erreurs (`try/catch` absent)

---

## ✅ Bonnes pratiques

- Toujours utiliser `param()` en tête de script
- Séparer logique et affichage (`Write-Output` vs `Write-Host`)
- Organiser les scripts en fonctions réutilisables
- Utiliser des messages clairs dans les erreurs (`throw`, `Write-Error`)

---

## 📚 Ressources complémentaires

- [Microsoft Learn – PowerShell](https://learn.microsoft.com/fr-fr/powershell/)
- `Get-Help`, `Get-Command`, `Get-ChildItem`
- [SS64 PowerShell](https://ss64.com/ps/)
