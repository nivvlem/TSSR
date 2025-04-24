# TP – Premières commandes PowerShell

## 📄 Énoncé du TP

Ce TP se déroule sur deux machines virtuelles : `CLI01` et `CD01`, dans un environnement de test fourni par le formateur.

### Étapes principales :

- Lancer PowerShell et PowerShell Core en mode administrateur
- Utiliser `Get-Command`, `Get-Verb`, `Get-Help`
- Rechercher des commandes spécifiques (user, group, services...)
- Créer un utilisateur, modifier sa description
- Gérer les modules, l’aide, et la politique d’exécution
- Créer un profil PowerShell et personnaliser la console

---

## ✅ Résolution structurée

### 🔹 Découverte et commandes de base

```powershell
Get-Command | Measure   # Affiche le nombre total de commandes
Get-Verb                  # Liste les verbes disponibles
Get-Command -Verb New     # Liste toutes les cmdlets avec le verbe New
Get-Command -Noun *User*  # Recherche les cmdlets contenant 'User'
Get-Command -Noun *localuser*  # Trouver la commande de création de compte
Get-LocalUser | Select -First 5  # Afficher les 5 premiers utilisateurs
```

### 🔹 Modifier un utilisateur (bonus)

```powershell
Set-LocalUser -Name "FerdinandMorse" -Description "TP"
Get-LocalUser -Name "FerdinandMorse"
```

### 🔹 Utilisation de l’aide

```powershell
Get-Help Get-Service                    # Aide simple
Get-Help Get-Service -ShowWindow       # Fenêtre interactive
Get-Help Get-Service -Full             # Aide détaillée
Get-Help Get-Service -Online           # Version web
```

### 🔹 Mise à jour de l’aide

```powershell
Update-Help -SourcePath \\CD01\Partage\Depot\CLI01 -UICulture EN-US
Update-Help -SourcePath \\CD01\Partage\Depot\CLI01 -UICulture fr-FR
```

> Remarque : certaines aides ne sont pas disponibles, surtout en français.

### 🔹 Modules PowerShell

```powershell
Get-Module -ListAvailable              # Liste tous les modules
Get-Module | Measure                   # Compte les modules disponibles
Get-Command Get-LocalUser | Select Module # Voir le module lié à la cmdlet
$env:PSModulePath                      # Emplacement des modules
```

### 🔹 Installer un module personnalisé

```powershell
# Après avoir copié l’archive depuis le partage
Import-Module AWSPowerShell            # Importer le module
# Si erreur :
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
# Exemples de cmdlets AWS :
Get-AWSCredential
New-EC2Instance
Get-S3Bucket
```

### 🔹 Créer un profil utilisateur PowerShell

```powershell
New-Item -Path $PROFILE -ItemType File -Force
notepad $PROFILE
# Exemple de contenu :
Get-Help Get-Command
```

### 🔹 Modifier le prompt (bonus)

```powershell
function Get-Time {
    return (Get-Date).ToLongTimeString()
}

function prompt {
    $time = Get-Time
    $path = $(Get-Location).Path.Replace($HOME, "~")

    Write-Host "[" -NoNewline
    Write-Host $time -ForegroundColor DarkYellow -NoNewline
    Write-Host "] " -NoNewline
    Write-Host $path -ForegroundColor DarkGreen -NoNewline
    Write-Host $(if ($nestedpromptlevel -ge 1) { '>>' }) -NoNewline
    return "> "
}

function IsAdmin {
    $CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($CurrentUser)
    return $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Couleur de fond selon les droits
if (IsAdmin) {
    $ElevationMode = 'Privilégiée'
    $host.UI.RawUI.BackgroundColor = 'DarkRed'
    Clear-Host
} else {
    $ElevationMode = 'Non Privilégiée'
    $host.UI.RawUI.BackgroundColor = 'DarkMagenta'
    Clear-Host
}

# Message d’accueil au lancement
$time = Get-Time
$CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()

Write-Host '+---------------------------------------------------+'
Write-Host ("+- Bonjour {0}, il est {1}" -f ($CurrentUser.Name).Split('\')[1], $time)
Write-Host '+---------------------------------------------------+'
```

---

## 🧠 À retenir pour les révisions

- `Get-Command`, `Get-Verb` et `Get-Help` sont les outils clés pour débuter
- PowerShell est très modulaire → chaque Cmdlet est liée à un module
- L’aide est téléchargeable et multilingue (selon disponibilité)
- La console est personnalisable (profil, couleurs, prompt)
- Les scripts ne sont pas autorisés par défaut : `Set-ExecutionPolicy` est indispensable

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Lancer PowerShell en admin|Certaines commandes nécessitent des droits élevés|
|Utiliser `-ShowWindow` pour l’aide|Recherche + confort de lecture|
|Mettre à jour régulièrement l’aide|Pour bénéficier des exemples et descriptions à jour|
|Ne pas laisser la politique sur Unrestricted|Risque de sécurité|
|Isoler les scripts de test dans des profils utilisateurs|Évite d'impacter l'environnement global|
