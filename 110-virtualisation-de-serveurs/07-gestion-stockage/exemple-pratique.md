# TP – Gestion du stockage d'une infrastructure vSphere

## 🧰 Pré-requis

- 2 hyperviseurs **ESXi** configurés avec VMkernel réseau de stockage
- 1 VM **SRV_2K19** (Windows Server 2019) déployée, snapshot "Fin Atelier 1"
- Les configurations réseau issues des ateliers précédents doivent être fonctionnelles

---

## 🧪 Partie I – Configuration iSCSI (mode bloc)

### 🔧 Sur la VM **SRV_2K19**

1. **Adresse IP statique** : `192.168.20.12/24` 
2. Contrôle de connectivité :

```bash
ping 192.168.20.1
ping 192.168.20.2
```

3. Ajout d’un **disque virtuel** de 150 Go nommé `STOCKAGE`, formaté en NTFS.
4. Ajout du rôle **Serveur de fichiers et services de stockage** > **Cible iSCSI**.
5. Création d’un **disque virtuel iSCSI** de 80 Go nommé `LUN1`, associé à une nouvelle cible `iSCSI`.
6. Autoriser les IPs des hyperviseurs ESXi en tant qu’**initiators**.

### 🖥️ Sur **ESXi1**

1. Activer l’adaptateur logiciel iSCSI dans _Stockage > Adaptateurs_
2. Lier l’adaptateur au **VMkernel** `GRP-STORAGE-VMOTION`
3. Ajouter l’IP de SRV_2K19 (`192.168.20.12`) comme **cible dynamique**
4. Lancer une **réanalyse** → détecter le périphérique `MSFT iSCSI`
5. Créer un **datastore VMFS** :
    - Nom : `DS-ISCSI`
    - Disque : `LUN1`
    - Utilisation : totale

### 🖥️ Sur **ESXi2**

1. Activer et configurer le même adaptateur logiciel iSCSI
2. Vérifier l’accessibilité du **datastore DS-ISCSI**

---

## 🧪 Partie II – Configuration NFS (mode fichier)

### 🔧 Sur **SRV_2K19**

1. Créer un dossier `NFS` dans `D:\STOCKAGE\DS`
2. Ajouter le rôle **Serveur pour NFS**
3. Créer un **partage NFS** du dossier `DS\NFS` avec options :
    - Pas d’authentification serveur
    - Accès des utilisateurs non mappés : activé
    - Lecture/écriture pour ESXi1 et ESXi2 (par IP)
    - Version NFS v3

### 🖥️ Sur **ESXi1 et ESXi2**

1. Créer un **datastore de type NFS** :
    - Nom : `DS-NFS`
    - Hôte : `192.168.20.12`
    - Dossier : `/DS/NFS`
    - Droits : lecture/écriture
2. Vérifier que le **datastore DS-NFS** est monté et accessible dans l’inventaire

---

## ✅ À retenir pour les révisions

- iSCSI = stockage **bloc**, nécessite une cible + initiator
- NFS = stockage **fichier**, accessible via partage réseau
- **Datastores VMFS** = performants pour VM, **NFS** = flexibles
- iSCSI doit être associé à une carte VMkernel dédiée (réseau isolé)

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Séparer le réseau de stockage du trafic de production|Optimise la sécurité et la performance|
|Utiliser MTU 9000 (jumbo frames) sur le réseau iSCSI|Améliore les performances de transfert|
|Sauvegarder les configurations des cibles et partages|Facilite les restaurations et la documentation|
|Documenter les IP, rôles, et chemins d’accès|Maintien de la cohérence dans l’infrastructure|
|Nommer clairement les datastores et cibles|Simplifie la supervision et l’exploitation|
