# MDT (Microsoft Deployment Toolkit)

## 📌 Présentation

**MDT (Microsoft Deployment Toolkit)** est un outil gratuit de Microsoft permettant de créer des **déploiements automatisés et personnalisés de Windows**.

Il est souvent couplé à **WDS** pour automatiser entièrement l’installation de postes de travail, avec :
- Installation de Windows
- Intégration des pilotes
- Installation de logiciels
- Personnalisation (nom machine, domaine, compte…)

C’est l’outil de choix pour automatiser la création de **master** et le déploiement en masse en entreprise.

---

## 🔧 Prérequis

- Windows Server ou Windows 10/11
- Rôle WDS recommandé (mais optionnel)
- Windows ADK + WinPE Add-on (nécessaire pour MDT)
- MDT (Microsoft Deployment Toolkit) → [téléchargement Microsoft](https://learn.microsoft.com/en-us/mem/configmgr/mdt/)

---

## ⚙️ Architecture typique

```
[MDT Server] + [Deployment Share] + [ADK / WinPE] → Clients PXE boot via WDS
```

### Déploiement

1. Le client démarre en PXE (WDS)
2. Il charge un **boot WIM personnalisé par MDT**
3. MDT exécute un **task sequence** (séquence de tâches)
4. Windows est installé, drivers + apps ajoutés automatiquement

---

## 🗂️ Dossiers clés

| Dossier | Rôle |
|---------|------|
| DeploymentShare | Racine de MDT (structure de déploiement) |
| Control | Séquences de tâches, règles (customsettings.ini) |
| Scripts | Scripts PowerShell/Batch personnalisés |
| Operating Systems | Sources Windows (ISO déployées) |
| Applications | Logiciels à installer post-déploiement |
| Out-of-Box Drivers | Pilotes injectés automatiquement |
| Packages | Mises à jour (ex : .NET, Visual C++) |

---

## ✏️ Exemples de fichiers de configuration

### `CustomSettings.ini` (exemple pour déploiement en domaine)

```ini
[Settings]
Priority=Default
Properties=MyCustomProperty

[Default]
OSInstall=Y
SkipCapture=YES
SkipAdminPassword=YES
SkipProductKey=YES
SkipComputerBackup=YES
SkipBitLocker=YES
SkipSummary=YES
SkipFinalSummary=YES
SkipLocaleSelection=YES
SkipTimeZone=YES
TimeZoneName=Romance Standard Time

JoinDomain=ADDOMAINE.LOCAL
DomainAdmin=MDTAdmin
DomainAdminDomain=ADDOMAINE
DomainAdminPassword=MotDePasseIci

ComputerName=PC-%SerialNumber%

SkipApplications=NO
SkipPackageDisplay=YES
SkipAppsOnUpgrade=YES

; Mapping automatique des drivers
DriverSelectionProfile=Windows10-Drivers

; Configuration de l'utilisateur
SkipUserData=YES
UserDataLocation=NONE

; Configuration de la langue
KeyboardLocale=040c:0000040c
InputLocale=040c:0000040c
UILanguage=fr-FR
UserLocale=fr-FR
SystemLocale=fr-FR
```

### `Bootstrap.ini` (exemple basique)

```ini
[Settings]
Priority=Default

[Default]
DeployRoot=\\MDT-SERVER\DeploymentShare$
UserDomain=ADDOMAINE
UserID=MDTAdmin
UserPassword=MotDePasseIci
KeyboardLocale=040c:0000040c
```

---

## 🧰 Cas d’usage courant

- Déploiement en masse de Windows + apps + drivers
- Création d’un **master personnalisé** (image de référence sysprep)
- Maintenance de parc homogène (réinstallation rapide)
- Migration vers une nouvelle version de Windows

---

## ⚠️ Erreurs fréquentes

- Oublier d’intégrer les drivers réseau au boot.wim MDT → PXE boot bloqué
- Mauvaise configuration de `customsettings.ini` → déploiement interactif au lieu de full unattended
- Problèmes de droits NTFS sur le DeploymentShare → client ne récupère pas les séquences
- Intégration incorrecte des applications (paquets MSI mal référencés)

---

## ✅ Bonnes pratiques

- Créer des **séquences de tâches claires et modulaires**
- Documenter et versionner `customsettings.ini` + `bootstrap.ini`
- Automatiser le maximum d’actions pour réduire le besoin d’intervention
- Tester chaque build dans une VM avant déploiement réel
- Intégrer les **derniers drivers et updates** dans l’image master régulièrement
- Coupler avec WDS pour permettre un boot réseau sans clé USB

---

## 📚 Ressources complémentaires

- [MDT Documentation officielle](https://learn.microsoft.com/en-us/mem/configmgr/mdt/)
- [Community tools: PSD, Modern Driver Management](https://www.scconfigmgr.com/)
