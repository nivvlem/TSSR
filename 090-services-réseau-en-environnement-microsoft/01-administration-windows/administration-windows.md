# Administration Windows

## 🪟 Panorama Windows : client vs serveur

### Systèmes clients :

- Windows 10, 8.1, 8, 7, Vista
- Destinés à être utilisés en station de travail par un utilisateur

### Systèmes serveurs :

- Windows Server 2008 à 2019
- Fournissent des **services réseau, stockage, virtualisation**, etc.

### Éditions de Windows Server :

|Édition|Virtualisation|Licence|
|---|---|---|
|Standard|2 VM + 1 hôte Hyper-V|Licence serveur|
|Datacenter|Illimité VM + 1 hôte Hyper-V|Licence serveur|
|Essentials|Pas d’Hyper-V|Simplifiée|

---

## 🔐 Rappels sur la gestion des licences

- La **licence client** permet d’installer le SE
- Les **CAL (Client Access License)** permettent l’accès à certains services (ex : RDS)
- L’accès à un rôle ou service peut nécessiter une licence complémentaire

---

## 🧰 Services réseau intégrés à Windows Server

|Service|Fonction principale|
|---|---|
|Active Directory DS|Gestion centralisée des identités et des ressources|
|AD CS / AD FS / RMS|PKI, fédération, gestion des droits (non abordés ici)|
|DNS / DHCP|Résolution de noms / Attribution automatique d’IP|
|Hyper-V|Virtualisation native|
|WDS / WSUS|Déploiement / gestion des mises à jour Microsoft|

> 📌 Ces services peuvent être ajoutés depuis le **Gestionnaire de serveur** ou via PowerShell

---

## 🖥️ Installation et modes de Windows Server

### Deux modes d’installation :

- **Server Core** (sans GUI) : plus sécurisé, plus léger
- **Installation avec interface graphique** (GUI) : plus conviviale

### Ajout de rôles/fonctionnalités :

- Via **Gestionnaire de serveur**
- Via PowerShell avec `Install-WindowsFeature`

### Outils d’administration :

- Gestionnaire de serveur
- Consoles MMC
- CMD, PowerShell, Server Manager

---

## 💾 Gestion du stockage et du RAID

### Types de table de partition :

|Format|Caractéristiques principales|
|---|---|
|MBR|Ancien format, limité à 2 To et 4 partitions primaires max|
|GPT|Moderne, supporte plus de 128 partitions, meilleure tolérance|

### Types de disque :

|Type|Description|
|---|---|
|De base|Données stockées dans des partitions|
|Dynamique|Permet volumes RAID, volumes étendus, fractionnés, etc.|

### Types de volumes et RAID :

|Type|Description|Tolérance panne|
|---|---|---|
|Volume simple|Données sur une partition unique|Non|
|Volume fractionné|Données réparties entre plusieurs disques|Non|
|RAID 0 (Bandes)|Performances accrues, aucune redondance|Non|
|RAID 1 (Miroir)|Données dupliquées sur 2 disques|Oui|
|RAID 5 (Bandes avec parité)|Données réparties + parité sur ≥3 disques|Oui|

> 📌 Le RAID est géré via **Disk Management**, `diskpart`, ou PowerShell

---

## ⚙️ Formatage et systèmes de fichiers

|Système de fichiers|Utilisation recommandée|
|---|---|
|FAT32|Ancien, compatible mais limité (4 Go max)|
|NTFS|Standard Windows, sécurisé|
|ReFS|Utilisé pour les espaces de stockage|

---

## ✅ À retenir pour les révisions

- Windows Server se décline en plusieurs **éditions**, avec des rôles, services et limitations différents
- Les **rôles** (AD DS, DNS, DHCP…) sont activés via le gestionnaire de serveur ou PowerShell
- Le **stockage** doit être anticipé : GPT pour les gros volumes, disques dynamiques pour RAID
- Le **RAID logiciel** offre des solutions de performance ou de tolérance à la panne sans matériel dédié

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Préférer Server Core quand possible|Moins d’exposition, moins de ressources|
|Documenter chaque ajout de rôle/fonction|Traçabilité et auditabilité|
|Choisir GPT pour tous les nouveaux disques|Compatibilité UEFI, meilleure tolérance aux pannes|
|Isoler les disques système / données|Sécurité et facilité de maintenance|
|Tester en VM avant déploiement physique|Éviter les erreurs irréversibles|
