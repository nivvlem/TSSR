# Présentation du langage PowerShell

## 🧠 Présentation et historique

- **PowerShell** est un shell Windows orienté objets, né en 2006 (V1.0).
- Depuis la version 5.1, il est intégré à Windows 10 et Server 2019.
- **PowerShell Core** (v6 à v7+) est multiplateforme, open source, basé sur .NET Core.

### 💡 Avantages de PowerShell Core :

- Compatible Windows, Linux, macOS
- Syntaxe identique mais avec quelques limitations côté Windows (pas de WMI, tâches planifiées...)
- Évolution continue : nouveaux modules, commandes mises à jour, performances accrues

---

## 🔧 Cmdlets : structure et usage

- Syntaxe standard : **Verbe-Nom** (toujours au singulier)

```powershell
Get-Process
Start-Service
Remove-Item
```

- Chaque Cmdlet peut recevoir des **paramètres** :

```powershell
Get-LocalUser -Name "Edward"
```

- Liste des verbes disponibles :

```powershell
Get-Verb
```

> 📌 Cmdlets = commandes puissantes + paramétrables + lisibles

---

## 🔍 Recherche de commandes avec `Get-Command`

- Lister toutes les commandes disponibles :

```powershell
Get-Command
```

- Filtrer par nom ou verbe :

```powershell
Get-Command -Name *Service
Get-Command -Verb Get
```

---

## 📚 4. Aide intégrée avec `Get-Help`

- Obtenir l’aide sur une commande :

```powershell
Get-Help -Name Get-Service
```

- Obtenir l’aide complète :

```powershell
Get-Help -Name Get-Service -Full
```

- Affichage dans une fenêtre dédiée (avec recherche) :

```powershell
Get-Help -Name Get-Service -ShowWindow
```

- Lister uniquement les exemples :

```powershell
Get-Help -Name Get-Service -Examples
```

- Accès à l’aide en ligne (navigateur) :

```powershell
Get-Help -Name Get-Service -Online
```

> 💡 Astuce : consulter aussi `Get-Help about_*` pour les concepts globaux (boucles, variables…)

---

## ♻️ Mise à jour de l’aide

- Mettre à jour tous les fichiers d’aide :

```powershell
Update-Help
```

- Source locale ou distante :

```powershell
Update-Help -SourcePath D:\PowerShell -UICulture en-US
```

> ⚠️ Requiert **droits administrateur**

---

## 🔒 Exécution des scripts et politiques de sécurité

- Vérifier la politique actuelle :

```powershell
Get-ExecutionPolicy
```

- Modifier la politique (ex : pour tests) :

```powershell
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
```

> ⚠️ Ne jamais laisser sur "Unrestricted" en production !

---

## 📦 Modules PowerShell

- Liste des modules disponibles :

```powershell
Get-Module -ListAvailable
```

- Importer un module :

```powershell
Import-Module AWS.Tools.S3
```

- Afficher les commandes d’un module :

```powershell
Get-Command -Module AWS.Tools.S3
```

- Chemin des modules disponibles :

```powershell
$env:PSModulePath
```

---

## 🎨 Personnalisation de la console

- Modifier l’apparence via clic droit → Propriétés
- Créer un **profil utilisateur** exécuté à chaque ouverture :

```powershell
New-Item -Path $PROFILE -Type File -Force
```

- Contenu possible : couleur, alias, bandeau de bienvenue…

---

## ✅ À retenir pour les révisions

- PowerShell est un shell orienté objets, multiplateforme avec Core
- Toutes les commandes suivent la forme **Verbe-Nom** et sont des **Cmdlets**
- Utilise `Get-Command`, `Get-Help`, `Update-Help` pour t’orienter
- Les modules ajoutent des fonctionnalités avancées (AWS, Azure, etc.)
- La sécurité des scripts est gérée par `Set-ExecutionPolicy`
- Tu peux personnaliser et étendre ta console selon ton environnement

---

## 📌 Bonnes pratiques

|Bonne pratique|Pourquoi ?|
|---|---|
|Toujours utiliser `Get-Help`|Comprendre une commande avant de l’utiliser|
|Tester une Cmdlet avec `-WhatIf`|Éviter les actions destructrices involontaires|
|Garder un prompt personnalisé|Gagner du temps avec des alias ou infos utiles visibles|
|Ne pas exécuter de scripts en mode "Unrestricted" permanent|Risques de sécurité élevés|
|Utiliser `Import-Module` proprement|Charger uniquement ce qui est nécessaire|
