# Interagir avec Windows

## 🖥️ Tour d'horizon de Windows 10/11

### 🔹 Fonctionnalités graphiques principales

|Éléments clés|Description|
|---|---|
|Bureau|Personnalisable, contient icônes, widgets (Win11)|
|Menu Démarrer|Accès aux applications installées, Paramètres|
|Barre des tâches|Accès rapide aux programmes ouverts|
|Zones de notification|État réseau, batterie, son, actions rapides|
|Windows + Tab|Vue des tâches, gestion des bureaux multiples|
|Timeline (Windows 10)|Historique des activités (documents, applis ouvertes)|

> 📌 Le mode Tablette permet d’optimiser l'affichage pour les écrans tactiles.

### 🔹 Outils administratifs GUI

- **Panneau de configuration** (héritage Windows 7)
- **Paramètres Windows** (interface modernisée)
- **Consoles MMC** (préconfigurées ou personnalisées)

---

## 💻 Introduction à la CLI sous Windows

### 🔹 Shells disponibles

|Shell|Description|
|---|---|
|`cmd.exe`|Invite de commandes hérité de MS-DOS|
|`PowerShell`|Shell moderne orienté objet|

### 🔹 Commandes de base dans `cmd`

```bash
help                      # Liste des commandes disponibles
shutdown /r /t 0           # Redémarrer immédiatement
help shutdown              # Obtenir l'aide sur la commande shutdown
```

### 🔹 Principes de la CLI

- Une **commande** suivie de **paramètres**
- Options identifiées par `/`
- Utilisation de `>` ou `>>` pour rediriger la sortie
- Espaces = délimiteurs importants ➔ utiliser des quotes si besoin

Exemples :

```bash
copy fichier1.txt fichier2.txt      # Copie fichier1 vers fichier2
help > aide.txt                     # Redirige l’aide vers un fichier texte
```

---

## 🛠️ PowerShell – Présentation rapide

### 🔹 Qu'est-ce que PowerShell ?

- Interpréteur de commande **et** langage de script
- Basé sur les bibliothèques **.NET**
- Introduction native à partir de Windows Server 2008 / Windows 7

### 🔹 Versions principales

|Version|Périmètre|
|---|---|
|PowerShell 1.0|Windows Server 2008, XP SP2|
|PowerShell 2.0|Windows 7|
|PowerShell 5.0|Windows 10|
|PowerShell 7+|Open-source, multiplateforme (PowerShell Core)|

---

## ⚡ Les commandes PowerShell (cmdlets)

### 🔹 Syntaxe générale

- **Verbe-Nom**
- Exemples :

```powershell
Get-Process
Get-Service
Get-ChildItem -Path C:\Users
```

### 🔹 Caractéristiques

- Non sensibles à la casse
- Supporte la complétion automatique (`Tab`, `Ctrl+Espace`)
- Utilise les **pipes** `|` pour chaîner les commandes

Exemples :

```powershell
Get-ChildItem | Where-Object { $_.Length -gt 1MB }
```

> 📌 Les cmdlets sont conçues pour manipuler des **objets**, pas de simples textes.

---

## 📚 Utilisation de l’aide intégrée PowerShell

### 🔹 Commandes d’aide

```powershell
Get-Help Get-Process       # Aide complète sur une cmdlet
Get-Help Get-Process -Examples
Get-Help Get-Process -Online
Update-Help                # Met à jour l'aide localement (admin nécessaire)
```

### 🔹 Notations d’aide

| Notation | Signification                 |
| -------- | ----------------------------- |
| []       | Élément facultatif            |
| {}       | Choix entre plusieurs options |
| ...      | Eléments répétables           |

---

## 🧩 Gestion des objets sous PowerShell

|Concept|Exemple|
|---|---|
|Objet|Une carte réseau, un fichier, un service|
|Propriétés|Caractéristiques de l'objet (Nom, Taille, Statut)|
|Méthodes|Actions possibles (Stop, Start, Delete, etc.)|

### 🔹 Manipulations de base

```powershell
Get-Service | Select-Object Name, Status
(Get-Process)[0].Name                  # Affiche la propriété Name du 1er process
```

> 📌 PowerShell traite **nativement des objets complexes**, contrairement à cmd.

---

## ✅ À retenir pour les révisions

- Windows propose **GUI + CLI** pour interagir avec le système
- **cmd.exe** reste utile, mais **PowerShell** est désormais privilégié pour l’automatisation
- L’aide est **extrêmement précieuse** : utiliser `Get-Help`
- La manipulation des **objets PowerShell** est essentielle pour filtrer, modifier et exploiter les données
- La **complétion automatique** (`Tab`) et l'usage des **pipes** sont essentiels pour gagner en efficacité

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Utiliser PowerShell dès que possible|Modernité, automatisation, objectivité des commandes|
|Documenter les commandes utilisées|Favorise la reproductibilité des procédures|
|Ne jamais exécuter de commandes sans comprendre|Prévenir des erreurs critiques|
|Tester les cmdlets sur un environnement de lab|Limiter les risques sur les systèmes de production|
|Mettre à jour régulièrement l’aide PowerShell|Avoir accès aux dernières corrections et exemples|

