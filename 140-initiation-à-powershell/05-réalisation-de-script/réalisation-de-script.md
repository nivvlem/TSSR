# Réalisation de scripts PowerShell

## 🛠️ Environnements de développement (IDE)

### PowerShell ISE (Windows)

- Intégré à Windows
- Coloration syntaxique, exécution ligne par ligne, débogage
- Limité aux scripts Windows (non Core, pas multiplateforme)

### Visual Studio Code

- Léger, multiplateforme, riche en extensions (PowerShell, PSScriptAnalyzer...)
- Intégration avec Git, Terminal, Auto-complétion intelligente
- **Recommandé** pour le scripting PowerShell moderne

---

## 🧾 Commentaires et documentation

### Commentaire sur une ligne :

```powershell
# Ceci est un commentaire
```

### Bloc de commentaires :

```powershell
<#
Script : install.ps1
Auteur : Niv
Description : Installe les outils nécessaires
#>
```

> 💡 Utilise les commentaires pour documenter la structure, les paramètres et la logique

---

## 🔗 Enchaînement des commandes

- Les commandes s’enchaînent naturellement via `;`

```powershell
mkdir D:\Test; cd D:\Test
```

- Mais il est **préférable de séparer les blocs** logiques sur plusieurs lignes pour la lisibilité.

---

## 🧨 Gestion des erreurs

### Mode silencieux avec `-ErrorAction`

```powershell
Get-Item 'C:\toto' -ErrorAction SilentlyContinue
```

### Récupérer l'erreur :

```powershell
$Error[0]  # dernière erreur
```

---

## 🛡️ Bloc `Try / Catch / Finally`

### Structure :

```powershell
try {
  # Code sensible
  Get-Item 'C:\toto'
} catch {
  Write-Host "Erreur détectée : $_"
} finally {
  Write-Host "Nettoyage ou confirmation"
}
```

> Utiliser `try/catch` permet de gérer les exceptions de façon claire et professionnelle

---

## 🧱 Créer et appeler des fonctions

```powershell
function Get-InfoSystem {
  Get-ComputerInfo | Select OSName, OSArchitecture, CsName
}

# Appel de la fonction
Get-InfoSystem
```

> ✅ Mettre les fonctions **en haut de script ou dans un fichier externe**

---

## 🌐 Exécution distante (Remoting)

### Activation :

```powershell
Enable-PSRemoting -Force
```

### Utiliser `Invoke-Command`

```powershell
Invoke-Command -ComputerName CLI02 -ScriptBlock { Get-Process }
```

### Lancer un script distant :

```powershell
Invoke-Command -ComputerName CLI02 -FilePath .\audit.ps1
```

> ⚠️ Les sessions distantes nécessitent **WinRM activé et configuré**

---

## ✅ À retenir pour les révisions

- Utiliser VS Code avec l’extension PowerShell pour une meilleure expérience
- Documenter les scripts avec des commentaires de bloc `#` ou `<# ... #>`
- Utiliser `try/catch/finally` pour capter et gérer les erreurs critiques
- Organiser son script : **fonctions en haut, corps du script en bas**
- Le remoting permet d’exécuter des scripts à distance avec `Invoke-Command`

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Nommer les scripts clairement|Facilite la maintenance et l’audit|
|Documenter chaque script avec bloc `<#>`|Clarté pour les collègues, auditabilité|
|Isoler les fonctions réutilisables|Encourage la modularité|
|Utiliser `try/catch` autour des commandes sensibles|Prévention des plantages en production|
|Utiliser `VS Code` + Git|Travail collaboratif, versionnage intégré|
