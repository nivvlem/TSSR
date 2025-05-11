# Gestion du stockage dans vSphere

## 🧱 Types de stockage

### 🔹 Stockage local (DAS)

- Directement connecté au serveur (SATA, SAS, SSD)
- Dépendant de la connectique et du protocole
- Accès rapide mais peu flexible

### 🔹 NAS (Network Attached Storage)

- Stockage partagé via le réseau, mode fichier
- Protocoles : NFS, CIFS/SMB, AFP
- Autonome, utilisé comme serveur de fichiers

### 🔹 SAN (Storage Area Network)

- Réseau dédié au stockage en mode bloc
- Protocoles : Fibre Channel, iSCSI
- Volumes présentés aux hôtes comme des disques locaux (LUN)

---

## 🔌 Protocoles d’accès

### SCSI (mode bloc)

- Protocole natif des disques virtuels (VMDK, RDM)
- Utilisé dans SAN avec Fibre Channel ou iSCSI

### iSCSI

- Permet d’accéder à un stockage en mode bloc via le réseau IP
- Composants :
    - **Initiator** : côté hôte ESXi
    - **Target** : côté baie de stockage

### Recommandations réseau iSCSI

- Réseau dédié
- Carte réseau dédiée (VMNIC)
- MTU 9000 (si matériel compatible)

---

## 📦 Composants de stockage dans vSphere

### 🔹 Adaptateurs de stockage

- Lient les solutions de stockage aux hôtes
- Types :
    - **HBA physiques** (FC, iSCSI, FCoE)
    - **Adaptateurs logiciels** (iSCSI ou FCoE virtualisés)

> Les HBA matériels sont recommandés pour de meilleures performances

### 🔹 Banques de données (datastores)

- Conteneurs logiques hébergeant les fichiers VMs (disques, ISO, snapshots...)
- Formats : VMFS (mode bloc), NFS (mode fichier)

---

## 🧠 VMFS – Système de fichiers vSphere

|Version|Max taille volume|Bloc|Format|OS supportés|
|---|---|---|---|---|
|VMFS3|64 To|1 Mo|MBR|vSphere 4-5|
|VMFS5|64 To|1 Mo|GPT|vSphere 5+|
|VMFS6|64 To|1 Mo|GPT|vSphere 6.5+|

> VMFS permet l’accès **concurrent en lecture/écriture** depuis plusieurs hôtes ESXi

---

## 🔧 Gestion des datastores

- Création & formatage initial
- Suivi de l’espace utilisé / disponible
- Élargissement à chaud
- Import / export de fichiers ISO, VM, etc.
- Suppression / démontage

> Certains fichiers ne sont visibles que via SSH + `ls` (ex. fichiers de swap, snapshots masqués)

---

## 💾 Disques VM : VMDK vs RDM

### VMDK (Virtual Machine Disk)

- Format courant, simple à manipuler et sauvegarder
- Limité à **2 To** par disque

### RDM (Raw Device Mapping)

- Permet un accès direct à un LUN physique
- Utilisé dans cas spécifiques : clustering, sauvegardes SAN, etc.

> Écart de performance minime entre VMDK et RDM

---

## ⚙️ Modes de provisionnement VMDK

|Mode|Description|Avantages|Inconvénients|
|---|---|---|---|
|**Thick**|Réserve tout l’espace dès création|Performances élevées|Temps de création long|
|**Thin**|Alloue l’espace à la volée selon besoin|Gain de place / création rapide|Risque de **surallocation**|

---

## ✅ À retenir pour les révisions

- Le stockage peut être **local (DAS)** ou **réseau (NAS/SAN)**, avec protocoles adaptés
- **iSCSI** permet l’accès bloc via IP, mais nécessite un réseau dédié stable
- **VMFS** est le format standard pour datastores en mode bloc sur ESXi
- Le choix entre **VMDK et RDM** dépend des usages spécifiques

---

## 📌 Bonnes pratiques professionnelles

- Prévoir un **réseau dédié iSCSI** avec tolérance de panne (multi-path)
- Choisir le **bon format de disque (VMDK/RDM)** en fonction des contraintes applicatives
- Dimensionner les **datastores selon la criticité** : PROD, TEST, ISO, etc.
- Séparer les flux réseau (gestion, stockage, VM) sur des **VMNICs distinctes**
- Toujours monitorer les **taux d’utilisation** et **performances** des datastores

---

## 🔗 Outils / concepts à connaître

- Adaptateurs de stockage : HBA, iSCSI Initiator
- Datastore, VMFS, LUN
- Disques : VMDK, RDM
- Provisionnement : Thin / Thick
- Commande SSH ESXi : `ls`, `du`, `esxcli storage`