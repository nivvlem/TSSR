# TP – Manipuler les disques et LVM 
# 🧱 Étapes du TP

## 1. Ajouter un nouveau disque de 40 Go

- Depuis les paramètres VMware, ajouter un disque virtuel de 40 Go

## 2. Vérifier la détection du disque

### a. Trouver la chaîne SCSI associée

```bash
udevadm info --query=path --name=sda
```

Résultat :

```
/devices/pci0000:00/0000:00:10.0/host2/target2:0:0/2:0:0:0/block/sda
```

➡️ Host SCSI = `host2`

### b. Scanner le bus SCSI

```bash
echo "- - -" > /sys/class/scsi_host/host2/scan
```

➡️ Le nouveau disque apparaît sous `/dev/sdb`

---

## 3. Créer une partition LVM avec `fdisk`

```bash
fdisk /dev/sdb
# n → p → 1 → valeurs par défaut
# t → 8e (Linux LVM)
# w (écriture)
```

---

## 4. Préparer et intégrer la partition au VG

### a. Créer le volume physique

```bash
pvcreate /dev/sdb1
```

### b. Étendre le VG existant

```bash
vgextend vggroup1 /dev/sdb1
```

---

## 5. Créer un volume logique `lvvar`

```bash
lvcreate -n lvvar -L 20G vggroup1
```

---

## 6. Agrandir un volume logique existant (`lvhome`)

```bash
lvextend -l +100%FREE /dev/vggroup1/lvhome
```

> `-l` permet d’indiquer une taille en nombre d’extents (ici, tout l’espace restant)

> 📌 Le redimensionnement du système de fichiers se fera avec `resize2fs` (voir module suivant)

---

## ✅ À retenir pour les révisions

- `pvcreate`, `vgextend`, `lvcreate`, `lvextend` sont les commandes clés de manipulation LVM
- `fdisk` permet de créer une partition `8e` pour LVM
- Le scan dynamique de disques SCSI évite un redémarrage
- `100%FREE` est utile pour exploiter tout l’espace disponible dans un VG

---

## 📌 Bonnes pratiques professionnelles

- Vérifier la détection de nouveaux disques avant toute opération
- Utiliser des noms cohérents pour les VG et LV (ex : `vggroup1`, `lvvar`)
- Documenter les opérations effectuées et les tailles allouées
- Redimensionner le système de fichiers après modification du LV

---

## 🔗 Commandes utiles

```bash
fdisk /dev/sdb
pvcreate /dev/sdb1
vgextend vggroup1 /dev/sdb1
lvcreate -n lvvar -L 20G vggroup1
lvextend -l +100%FREE /dev/vggroup1/lvhome
```

## Ressources complémentaires

- [https://wiki.debian.org/LVM](https://wiki.debian.org/LVM)