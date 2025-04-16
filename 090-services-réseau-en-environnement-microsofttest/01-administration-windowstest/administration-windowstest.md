# 📘 01 – Administration Windows

## 🖥️ Familles de systèmes
### Systèmes clients
Windows 11, 10, 8.1, 8, 7, Vista...

### Systèmes serveurs
Windows Server 2019, 2016, 2012 R2, 2008 R2…

---

## ⚙️ Éditions Windows Server

| Édition     | RAM min. | CPU       | Stockage min. | Droits de virtualisation      |
|-------------|----------|-----------|---------------|-------------------------------|
| Standard    | 2 Go     | 1.4 GHz   | 160 Go        | 2 VM + 1 hôte Hyper-V         |
| Datacenter  | 2 Go     | 1.4 GHz   | 160 Go        | Illimité + 1 hôte Hyper-V     |
| Essentials  | 2 Go     | 1.4 GHz   | 160 Go        | Pas de Hyper-V intégré        |

> ⚠️ **Attention** :
>  **CAL (Client Access License)** : certains services nécessitent des licences d'accès client supplémentaires.
> 
> 🔧 **Bonnes pratiques** :  
> ✅ Privilégier **Datacenter** pour les environnements virtualisés.  
> ✅ Vérifier les **CAL (Client Access License)** pour les services comme RDS.

---

## 📌 Services réseau intégrés à Windows Server

| Service                  | Description                                                   |
| ------------------------ | ------------------------------------------------------------- |
| Active Directory (AD DS) | Gestion des utilisateurs, ordinateurs, politiques             |
| AD FS / RMS / CS         | Services d'identité, de droits et de certificats (hors cours) |
| DHCP / DNS               | Gestion d'adresses IP et résolution de noms                   |
| Hyper-V                  | Virtualisation (machines virtuelles)                          |
| WDS / WSUS               | Déploiement OS et mises à jour centralisées                   |

---

## 🛠️ Installation et gestion

- **Types d’installation** :
  - Server Core : interface minimaliste (ligne de commande)
  - Avec interface graphique (GUI)
>🔧 **Bonnes pratiques** :  
>✅ Utiliser **PowerShell** pour les installations automatisées (ex : `Install-WindowsFeature`)

- **Outils d’administration** :
  - Gestionnaire de serveur
  - PowerShell
  - `diskmgmt.msc`, `diskpart`

---

## 💾 Gestion du stockage

### 1. Tables de partition
- **MBR** (ancien) : 4 partitions primaires max
- **GPT** (moderne) : meilleur support UEFI + tolérance de panne
>🔧 **Bonnes pratiques** :  
>✅ **Préférer GPT** sur disques récents (SSD/UEFI

### 2. Types de disques
- **De base** : partitions simples
>⚠️ **Attention** : limité à 4 partitions principales
- **Dynamiques** : volumes étendus, RAID logiciel possible

### 3. Volumes RAID

| Type                  | RAID | Caractéristiques                                  |
|-----------------------|------|---------------------------------------------------|
| Volume agrégé par bandes | 0    | Performances ++, pas de tolérance de panne       |
| Volume en miroir         | 1    | Données copiées sur 2 disques                    |
| Volume avec parité       | 5    | 3 disques min, bon compromis sécurité/coût       |
>🔧 **Bonnes pratiques** :
> ✅ Utiliser **RAID-1 ou RAID-5** pour les données critiques  

---

## 🧩 Formatage et systèmes de fichiers

| Système  | Avantages | Inconvénients | Cas d'usage typique |
|----------|-----------|---------------|---------------------|
| **NTFS** | ✅ Sécurité avancée (ACL, chiffrement EFS)<br>✅ Journalisation intégrée<br>✅ Taille max fichier : 16 To<br>✅ Compression/quotas disque | ❌ Performances inférieures à ReFS sur très gros volumes<br>❌ Fragmentation possible | Serveurs de fichiers<br>Volumes système (OS)<br>Bases de données |
| **ReFS** | ✅ Résilience (vérification auto des corruptions)<br>✅ Performances élevées avec Storage Spaces<br>✅ Taille max fichier : 35 To | ❌ Incompatible avec BitLocker/démarrage OS<br>❌ Nécessite Windows Server 2016+ | Hyper-V (fichiers VHDX)<br>Stockage en cluster (SAN) |
| **FAT32** | ✅ Compatible avec tous les OS<br>✅ Léger et simple | ❌ Taille max fichier : 4 Go<br>❌ Pas de permissions ni journalisation | Clés USB/disques externes<br>Appareils embarqués |
>🔧 **Bonnes pratiques** :  
✅ **Toujours utiliser NTFS** pour les volumes avec gestion de droits  

---

## 🔧 Bonnes pratiques

1. **Sécurité** :  
   - Activer le chiffrement BitLocker pour les volumes sensibles.  
   - Utiliser **AGDLP** (Comptes → Groupes Globaux → DL → Permissions) pour gérer les accès.  

2. **Sauvegarde** :  
   - Planifier des sauvegardes régulières avec **Windows Server Backup** ou Veeam.  

3. **Monitoring** :  
   - Configurer des alertes **WSUS** pour les mises à jour critiques.  

4. **Documentation** :  
   - Maintenir un journal des modifications (ex: dates d'installation, configurations RAID).