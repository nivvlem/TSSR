# TP – Préparation des systèmes de fichiers 
# 🧱 Partie 1 – Création d’un FS ext4 avec label

### 📦 Créer un FS sur le volume logique `lvvar`

```bash
mkfs.ext4 -L VAR /dev/mapper/vggroup1-lvvar
```

> L’étiquette `VAR` est utilisée pour le montage futur

### 🔍 Vérifier l’étiquette

```bash
blkid /dev/mapper/vggroup1-lvvar
```

---

# 🧱 Partie 2 – Agrandir un système de fichiers

### 📐 Agrandir le FS de `lvhome` à 100% de l’espace logique disponible

```bash
resize2fs /dev/mapper/vggroup1-lvhome
```

> ❗ Si `lvextend -r` avait été utilisé précédemment, cette étape peut être déjà effectuée

---

# 🧱 Partie 3 – Migration de `/var` vers un volume logique dédié

### 🧷 Précautions préalables

- Créer un **snapshot VM** avant manipulation
- Vérifier l’activité de `/var`

```bash
lsof | grep /var
```

- Redémarrer en **mode rescue** si nécessaire (ou `systemctl isolate rescue.target`)

### 🔧 Monter `lvvar` temporairement

```bash
mkdir /mnt/var
mount /dev/mapper/vggroup1-lvvar /mnt/var
```

### 📁 Copier les données de `/var` vers `/mnt/var`

```bash
cp -rpv /var/* /mnt/var/
```

### 🔃 Remplacer le montage

```bash
umount /mnt/var
mount /dev/mapper/vggroup1-lvvar /var
```

> Vérifier que `/var/log` fonctionne normalement

---

# 🧱 Partie 4 – Montage automatique via `/etc/fstab`

### 📝 Ajouter au fichier `/etc/fstab`

```fstab
LABEL=VAR /var ext4 defaults 0 2
```

### 🧪 Tester le montage

```bash
umount /var
mount /var
```

> Si aucune erreur, le montage est fonctionnel via fstab

### 🔁 Redémarrer pour validation finale

```bash
reboot
```

---

## ✅ À retenir pour les révisions

- `mkfs.ext4 -L` permet d’ajouter une étiquette au FS
- `resize2fs` redimensionne un FS existant
- `lsof | grep /var` détecte les fichiers utilisés
- Le bon usage de `/etc/fstab` garantit la persistance du montage

---

## 📌 Bonnes pratiques professionnelles

- Toujours sauvegarder l’état de la VM avant migration critique
- Travailler en mode `rescue` pour limiter les accès à `/var`
- Utiliser `LABEL=` dans `/etc/fstab` pour fiabilité
- Valider les montages manuellement avant redémarrage

---

## 🔗 Commandes utiles

```bash
mkfs.ext4 -L VAR /dev/mapper/vggroup1-lvvar
blkid
resize2fs /dev/mapper/vggroup1-lvhome
lsof | grep /var
cp -rpv /var/* /mnt/var/
umount /var && mount /var
vi /etc/fstab
```
