# 📘 01 – Administration Windows

## 🎯 Objectifs
- Comprendre l'environnement Microsoft Server
- Gérer le stockage serveur (disques, partitions, RAID)

---

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

> 💡 **CAL (Client Access License)** : certains services nécessitent des licences d'accès client supplémentaires.

---

## 📌 Services réseau intégrés à Windows Server

| Service                  | Description                                               |
|--------------------------|-----------------------------------------------------------|
| Active Directory (AD DS) | Gestion des utilisateurs, ordinateurs, politiques         |
| AD FS / RMS / CS         | Services d'identité, de droits et de certificats (hors cours) |
| DHCP / DNS               | Gestion d'adresses IP et résolution de noms               |
| Hyper-V                  | Virtualisation (machines virtuelles)                      |
| WDS / WSUS               | Déploiement OS et mises à jour centralisées              |

---

## 🛠️ Installation et gestion

- **Types d’installation** :
  - Server Core : interface minimaliste (ligne de commande)
  - Avec interface graphique (GUI)

- **Outils d’administration** :
  - Gestionnaire de serveur
  - PowerShell
  - `diskmgmt.msc`, `diskpart`

---

## 💾 Gestion du stockage

### 1. Tables de partition
- **MBR** (ancien) : 4 partitions primaires max
- **GPT** (moderne) : meilleur support UEFI + tolérance de panne

### 2. Types de disques
- **De base** : partitions simples
- **Dynamiques** : volumes multiples, RAID logiciel possible

### 3. Volumes RAID

| Type                  | RAID | Caractéristiques                                  |
|-----------------------|------|---------------------------------------------------|
| Volume agrégé par bandes | 0    | Performances ++, pas de tolérance de panne       |
| Volume en miroir         | 1    | Données copiées sur 2 disques                    |
| Volume avec parité       | 5    | 3 disques min, bon compromis sécurité/coût       |

---

## 🧩 Formatage et systèmes de fichiers

| Système | Description                   |
|---------|-------------------------------|
| FAT32   | Ancien, pas de sécurité       |
| NTFS    | Sécurisé, utilisé par défaut  |
| ReFS    | Pour espaces de stockage (2012+) |

---

## 🔧 Bonnes pratiques pro

✅ **Toujours utiliser NTFS** pour les volumes avec gestion de droits  
✅ **Préférer GPT** sur disques récents (SSD/UEFI)  
✅ Utiliser **RAID-1 ou RAID-5** pour les données critiques  
✅ Utiliser **PowerShell** pour les installations automatisées (ex : `Install-WindowsFeature`)  
