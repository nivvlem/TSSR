# Gestion des espaces de stockage : Systèmes de fichiers (File System)

## 🧱 Structure des systèmes de fichiers Unix/Linux

### Composants internes clés

|Élément|Rôle principal|
|---|---|
|**Superbloc**|Métadonnées vitales (taille, dates, pointeurs, etc.)|
|**Inodes**|Métadonnées des fichiers (type, UID, GID, droits, dates, liens, etc.)|
|**Blocs de données**|Données réelles des fichiers|
|**Tables**|Blocs/inodes libres, redirections, etc.|

> Un fichier n’est **pas identifié par son nom**, mais par son inode. Le nom est géré par le répertoire parent.

---

## 🧬 Systèmes de fichiers supportés

### Ext2 / Ext3 / Ext4 (par défaut sur Debian)

|Type|Particularités|
|---|---|
|`ext2`|Pas de journalisation|
|`ext3`|Journalisation + rétrocompatibilité ext2|
|`ext4`|Préallocation des blocs (moins de fragmentation), fiable et moderne|

### Caractéristiques ext4

- Fichier max : 16 Tio
- Volume max : 1 Eio (limité à 16 Tio par `e2fsprogs`)
- Nom de fichier max : 255 caractères
- Jusqu’à 4 milliards de fichiers

> Autres systèmes : `xfs`, `btrfs`, `ntfs` (via `ntfs-3g`), `fat`…

---

## ⚙️ Création et gestion de systèmes de fichiers

### 🔧 Formater une partition ou un volume

```bash
mkfs.ext4 /dev/sdb1              # Partition classique
mkfs.ext4 /dev/vggroup1/lv1      # Volume logique LVM
mkfs.ntfs /dev/sde1              # Système NTFS (nécessite ntfs-3g)
```

> `mkfs.ext4` appelle `mke2fs` en arrière-plan

---

## 🛠️ Outils complémentaires

### 📌 Modifier un système de fichiers (ext)

```bash
tune2fs -L "LABEL" /dev/sdX       # Changer l’étiquette
 tune2fs -l /dev/sdX              # Lire le superbloc
 tune2fs -i 0 -c 10 /dev/sdX      # Fréquence vérif. auto
```

### 🔁 Redimensionner un FS (après lvextend ou lvreduce)

```bash
resize2fs /dev/vggroup1/lv1
```

### 🔍 Vérifier l’intégrité

```bash
fsck.ext4 /dev/sdX
```

---

## 📄 Informations sur les FS et disques

### 🧭 Identifier et explorer les volumes

```bash
blkid        # UUID, LABEL, TYPE
lsblk        # Vue arborescente
lsblk -f     # Vue filtrée : FS et points de montage
```

### 📊 Occupation des volumes

```bash
df -h        # Occupation disques
 df -i        # Inodes
 du -hs /dir  # Taille d’un répertoire
```

### 🔍 Points de montage actifs

```bash
mount        # Liste des montages actuels
findmnt      # Vue lisible et ciblée
findmnt /mnt
```

---

## 📌 Monter et démonter un système de fichiers

### 🔃 Montage manuel

```bash
mount -t ext4 /dev/sdc1 /mnt
```

- Options : `ro`, `rw`, `exec`, `noexec`, `suid`, `nosuid`, `remount`, etc.

### ❌ Démontage

```bash
umount /mnt
```

---

## ⚙️ Montage automatique – `/etc/fstab`

### 📝 Syntaxe générale

```
# <fs> <mnt point> <type> <options> <dump> <pass>
/dev/vgsys/lvhome /home ext4 defaults 0 2
UUID=… /boot ext2 defaults 0 2
/dev/sr0 /media/cdrom0 udf,iso9660 user,noauto 0 0
```

> Le montage automatique est déclenché **au démarrage**, via `systemd`

### 🧪 Tester avant redémarrage

```bash
mount /mnt/test    # Teste la ligne `/mnt/test` dans fstab
```

---

## ✅ À retenir pour les révisions

- Le système de fichiers est **obligatoire** pour stocker des données utilisables
- `ext4` est le plus courant et fiable aujourd’hui
- Les UUID ou LABEL sont préférés dans `/etc/fstab` (évite les conflits avec `/dev/sdX`)
- Toujours vérifier un redimensionnement avec `resize2fs` ou `fsck`

---

## 📌 Bonnes pratiques professionnelles

- Toujours formater **après** création de la partition ou du volume logique
- Tester les lignes `fstab` **avant redémarrage** avec `mount /chemin`
- Ne jamais démonter un point utilisé (erreur `device is busy`)
- Documenter les UUID, LABEL, points de montage et tailles

---

## 🔗 Commandes utiles

```bash
mkfs.ext4 /dev/sdX
mount /dev/sdX1 /mnt
umount /mnt
resize2fs /dev/mapper/vg-lv
lsblk, blkid, df, du, findmnt, tune2fs, fsck
```

## Ressources complémentaires

- [https://wiki.debian.org/FileSystems](https://wiki.debian.org/FileSystems)