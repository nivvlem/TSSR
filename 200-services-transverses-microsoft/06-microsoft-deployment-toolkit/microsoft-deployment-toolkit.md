# Microsoft Deployment Toolkit (MDT)
## 🧩 MDT en appui aux services de déploiement

- **MDT** complète WDS en apportant :
    
    - Gestion avancée des séquences de déploiement
        
    - Personnalisation fine des installations
        
    - Automatisation du post-installation (applications, GPO...)
        
    - Compatibilité avec **Windows 10 / 11**
        

---

## 🚀 Présentation du fonctionnement

### Architecture type

```text
MDT (Deployment Share) + WDS → Client PXE → LiteTouchPE → Séquence de tâches → Installation complète
```

### Modes de déploiement

- **Lite Touch Installation (LTI)** : semi-automatisé
    
- **Zero Touch Installation (ZTI)** : avec SCCM / MECM
    

---

## ⚙️ Prérequis

- **Windows Server** ou **Windows 10/11** pour héberger MDT
    
- Dernière version de **MDT** (>= 8456 pour Windows 11)
    
- **ADK Windows 11** (WinPE + SIM)
    
- Intégration possible avec **WDS**
    

### Spécificités Windows 11

- ADK Windows 11 obligatoire
    
- Séquences adaptées **UEFI / Secure Boot / TPM 2.0**
    

---

## 🗂️ Partage de déploiement

- **Deployment Share** : répertoire réseau partagé
    
- Contient :
    
    - OS (sources WIM)
        
    - Drivers
        
    - Applications
        
    - Scripts / Outils
        
    - Fichiers de réponse
        

---

## 🛠️ Windows PE

- Environnement WinPE personnalisé
    
- Généré par MDT → **LiteTouchPE.wim**
    
- Intégré à WDS comme **image de démarrage**
    

---

## 💻 Système d'exploitation

- Importer les **sources ISO** dans MDT
    
- Créer des **groupes logiques** (ex: Windows 10 / Windows 11)
    

---

## 🎬 Démonstration - Installation de MDT

### Étapes clés

1️⃣ Installation de MDT + ADK Windows 11  
2️⃣ Création du **Deployment Share**  
3️⃣ Configuration initiale (Bootstrap.ini / CustomSettings.ini)  
4️⃣ Génération de LiteTouchPE  
5️⃣ Publication sur WDS

---

## 📝 Les fichiers de configuration

### Fichiers clés

|Fichier|Rôle|
|---|---|
|Bootstrap.ini|Configure le **boot WinPE** (partage MDT, credential...)|
|CustomSettings.ini|Contrôle toute la **séquence de tâches** et l’automatisation|

---

## 📝 Le fichier Bootstrap.ini

### Exemple

```ini
[Settings]
Priority=Default
[Default]
DeployRoot=\\MDT-SRV\\DeploymentShare$
UserID=mdtuser
UserDomain=mondomaine.local
UserPassword=********
SkipBDDWelcome=YES
```

---

## 📝 Le fichier CustomSettings.ini

### Exemple basique

```ini
[Settings]
Priority=Default
Properties=MyCustomProperty

[Default]
OSInstall=Y
SkipCapture=YES
SkipAdminPassword=YES
SkipProductKey=YES
SkipComputerName=NO
JoinDomain=mondomaine.local
DomainAdmin=mdtjoin
DomainAdminPassword=********
```

---

## 🔒 Restreindre l'accès au partage de déploiement

- Restreindre les **droits NTFS** + partage
    
- Compte de service dédié (ex: `mdtuser`)
    

---

## 🗂️ Les séquences de tâches

### Rôle

- Définissent le **workflow complet** du déploiement
    

### Étapes typiques

1️⃣ Format / Partition du disque  
2️⃣ Installation OS  
3️⃣ Installation drivers  
4️⃣ Installation applications  
5️⃣ Configuration post-installation (domain join, GPO...)

---

## 🎬 Démonstration - Accès au partage et séquence de tâches

- Boot PXE avec LiteTouchPE
    
- Authentification sur le partage MDT
    
- Choix de la séquence de tâches
    

---

## 📝 Fichiers de réponses

- Unattend.xml généré automatiquement par MDT
    
- Possible de personnaliser (via Windows SIM)
    

---

## 🔍 Monitoring

- Console de **monitoring MDT**
    
- Suivi des déploiements en temps réel
    
- Logs détaillés dans : `\DeploymentShare$\Logs`
    

---

## 🔄 Bascule des mises à jour MDT vers WDS

- Générer LiteTouchPE à jour
    
- Publier dans WDS
    
- Mise à jour automatique ou manuelle selon scénario
    

---

## 🕵️ Problématiques et méthodes d'analyse

- Analyse des logs :
    
    - **BDD.log** (Bootstrap)
        
    - **SMSTS.log** (séquence de tâches)
        

---

## 📝 Journaux de déploiement

|Fichier|Emplacement|
|---|---|
|BDD.log|X:\MININT\SMSOSD\OSDLOGS|
|SMSTS.log|X:\WINDOWS\TEMP\SMSTSLOG\|
|Après reboot|C:\MININT\SMSOSD\OSDLOGS ou C:\WINDOWS\CCM\LOGS\|

---

## 🚀 Pour aller plus loin

### Déploiement d'applications

- Ajout dans MDT : **Application bundles**
    
- Intégration SCCM / Intune
    

### Gestion des pilotes

- Import par modèle ou par **Plug and Play ID**
    
- Gestion par **séquences conditionnelles** (CustomSettings.ini)
    

---

## 🎬 Démonstration - Monitoring et mise à jour LiteTouchPE.wim

- Génération d’une nouvelle image WinPE
    
- Publication sur WDS
    
- Test en boot PXE
    

---

## 🎯 Spécificités du déploiement de Windows 11 avec MDT

|Élément|Particularité / impact|
|---|---|
|ADK|ADK **Windows 11** requis|
|WinPE|Généré avec **ADK Windows 11**|
|Séquence UEFI|Obligatoire → GPT + UEFI + Secure Boot|
|TPM 2.0|Vérification automatique pendant la séquence|
|Secure Boot|Doit être activé|
|Fichiers de réponse|doivent être compatibles avec Windows 11|

### Commandes utiles

```powershell
# Vérification TPM
Get-WmiObject -Namespace root\cimv2\security\microsofttpm -Class Win32_Tpm

# Vérification Secure Boot
Confirm-SecureBootUEFI
```

### Conseils pro

- Prévoir des **séquences dédiées** pour Windows 11
    
- Maintenir un **Deployment Share** séparé si cohabitation Windows 10 / Windows 11
    
- Intégrer systématiquement les **derniers drivers Windows 11**
    
- Adapter le **CustomSettings.ini** aux besoins Windows 11
    

---

## ✅ À retenir pour les révisions

- MDT permet un déploiement **automatisé et flexible**
    
- S’appuie sur des **fichiers de configuration** et des **séquences de tâches**
    
- Le boot se fait en général via **WDS** (LiteTouchPE)
    
- Windows 11 impose :
    
    - UEFI + GPT
        
    - Secure Boot
        
    - TPM 2.0
        
    - Drivers et ADK compatibles
        

---

## 📌 Bonnes pratiques professionnelles

- **Documenter** le Deployment Share (version, contenu)
    
- Mettre à jour **régulièrement** ADK + MDT
    
- Séparer les séquences Windows 10 / Windows 11
    
- Restreindre l’accès au **partage MDT**
    
- Maintenir à jour **les drivers**
    
- Tester chaque séquence sur **modèles réels**
    
- Superviser le déploiement avec le **monitoring MDT**
    
- Automatiser l’intégration de nouvelles builds
    

---

Cours terminé → prêt pour **TP pratiques WDS + MDT** 🚀