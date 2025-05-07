# Gestion avancée des espaces de stockage : LVM

## 🔧 Introduction à LVM

### 🧱 LVM structure les disques en 3 couches

|Élément|Rôle|
|---|---|
|**PV (Physical Volume)**|Partition formatée pour LVM (ex : `/dev/sdb1`)|
|**VG (Volume Group)**|Regroupe un ou plusieurs PV (ex : `vggroup1`)|
|**LV (Logical Volume)**|Espace logique de stockage (ex : `lvroot`, `lvhome`)|

> LVM permet une gestion souple, redimensionnable et modulaire des disques

---

## 🛠️ Création de volumes LVM

### 1. Créer une partition avec l’ID `8e` (Linux LVM)

Via `fdisk` :

```bash
fdisk /dev/sdb
# Commande : n → p → 1 → +10G
# Commande : t → 8e
# Commande : w
```

### 2. Initialiser les volumes physiques

```bash
pvcreate /dev/sdb1 /dev/sdc1
```

### 3. Créer un groupe de volumes

```bash
vgcreate vggroup1 /dev/sdb1 /dev/sdc1
```

### 4. Créer des volumes logiques

```bash
lvcreate -n lvdata -L 2G vggroup1
lvcreate -n lvlogs -L 512M vggroup1
```

### Accès :

- `/dev/vggroup1/lvdata`
- ou `/dev/mapper/vggroup1-lvdata`

---

## ✏️ Modifier les volumes LVM

### ➕ Ajouter un PV à un VG

```bash
vgextend vggroup1 /dev/sdd
```

### ➕ Agrandir un LV (et son FS en une commande)

```bash
lvextend -r -L +1G /dev/vggroup1/lvdata
```

- `-r` : resize2fs automatique

### ➖ Réduire un LV (avec précaution)

```bash
lvreduce -r -L 1G /dev/vggroup1/lvdata
```

- Nécessite un **check préalable du système de fichiers** (voir module suivant)

---

## 🔍 Afficher les infos LVM

### Informations synthétiques

```bash
pvs      # PV
vgs      # VG
lvs      # LV
```

### Informations détaillées

```bash
pvdisplay
vgdisplay
lvdisplay
```

### Exemple de structure

```
/dev/sdb1 + /dev/sdc1 ➝ vggroup1
vggroup1 ➝ lvdata (2G), lvlogs (512M)
```

---

## ✅ À retenir pour les révisions

- `pvcreate`, `vgcreate`, `lvcreate` sont les 3 commandes clés
- Un VG peut regrouper plusieurs PV, un LV est découpé dans un VG
- `lvextend -r` permet d’agrandir un volume **et** son système de fichiers
- Les volumes logiques sont vus comme des partitions classiques

---

## 📌 Bonnes pratiques professionnelles

- Toujours formater les partitions LVM avec l’ID `8e`
- Documenter la structure PV/VG/LV pour chaque machine
- Ne jamais réduire un LV sans **vérification complète du FS**
- Utiliser `lvs`, `vgs`, `pvs` régulièrement pour surveiller les volumes
- Prévoir des noms explicites pour les VG/LV (ex : `vgdata`, `lvbackup`)

---

## 🔗 Commandes utiles

```bash
fdisk /dev/sdX            # Partitionnement
pvcreate /dev/sdX1        # Init volume physique
vgcreate vgname /dev/sdX1 # Créer volume group
lvcreate -n nom -L taille vgname  # Créer volume logique
lvextend -r -L +1G /dev/vgname/lvname
lvdisplay, vgdisplay, pvdisplay
```

## Ressources complémentaires

- [Debian LVM wiki](https://wiki.debian.org/LVM)