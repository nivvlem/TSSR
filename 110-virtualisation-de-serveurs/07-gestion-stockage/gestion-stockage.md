# Gestion du stockage

## 🧱 Types de stockage

|Type|Description|Accès|Exemple d’usage|
|---|---|---|---|
|**DAS**|Stockage directement connecté à l’hôte|Mode bloc|Disque dur interne, USB|
|**SAN**|Réseau dédié pour accès bas-niveau à des blocs via SCSI/iSCSI/FC|Mode bloc|Stockage centralisé haute perf.|
|**NAS**|Serveur de fichiers via réseau (NFS, SMB/CIFS, AFP)|Mode fichier|Partage de fichiers pour VM|

---

## 📦 Protocole iSCSI

- iSCSI = SCSI encapsulé sur TCP/IP
- Utilisé pour connecter des volumes à un hôte ESXi via le réseau
- Composants clés :
    - **iSCSI Initiator** (côté ESXi)
    - **iSCSI Target** (côté stockage)

🔧 _Recommandation : créer un réseau dédié au stockage avec MTU 9000 (jumbo frames)_

---

## 🧠 Composants vSphere pour le stockage

|Composant|Rôle|
|---|---|
|**Adaptateurs de stockage**|Interfaces physiques ou logicielles connectant au SAN/NAS|
|**Banques de données (datastores)**|Conteneurs logiques pour stocker les fichiers de VM|

Types de datastores :

- **VMFS** : système de fichiers concurrent pour VM
- **NFS** : protocole fichier, utile pour certains partages
- **RDM (Raw Device Mapping)** : accès direct à un LUN physique

---

## 📁 Formats de disque pour VM

|Format|Avantages|Inconvénients|
|---|---|---|
|**VMDK**|Simplicité de gestion et backup|Limité à 2 To|
|**RDM**|Accès direct utile en cluster|Plus complexe à gérer|

### Provisionnement des disques

|Type|Allocation|Avantages|Risques|
|---|---|---|---|
|**Thick**|Fixe|Performances supérieures|Occupation immédiate du volume|
|**Thin**|À la demande|Économie d’espace, création rapide|Risque de surallocation|

---

## ✅ À retenir pour les révisions

- Le **SAN** fonctionne en mode **bloc**, le **NAS** en mode **fichier**
- Le **protocole iSCSI** permet l’accès réseau à un stockage bloc
- **VMFS** permet un accès simultané aux fichiers depuis plusieurs hôtes ESXi
- Il est crucial de dimensionner les besoins de stockage en amont (VM_PROD vs ISO…)
- **Thick** = performances, **Thin** = flexibilité

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Utiliser un réseau dédié pour le stockage|Évite la congestion réseau, améliore les performances|
|Activer MTU 9000 (jumbo frames) pour iSCSI|Optimisation des transferts de gros volumes|
|Préférer les adaptateurs HBA physiques au virtuels|Réduction de la charge CPU, meilleures performances|
|Créer des datastores par usage (PROD, TEST, ISO…)|Organisation et performance|
|Documenter les configurations de stockage|Facilite le diagnostic et les migrations|
