# Mise en situation professionnelle : Systèmes clients

## Configuration du stockage et des partages

## 🧱 Objectif

Gérer le **stockage local avancé** sur Windows 10 et Debian 10 en respectant les consignes imposées : création et montage de partitions spécifiques, gestion des points de montage, application de droits d'accès adaptés, partages sécurisés et visibilité réseau.

---

## 💽 Windows 10 – Partitionnement avec DISKPART

### 🧾 Objectif

- Créer une partition `DATA` de 15 Go sur le 2e disque (40 Go), en MBR, montée en `D:`

### 🔧 Étapes DISKPART

1. Ouvrir `cmd` en tant qu'administrateur
2. Lancer :

```cmd
diskpart
```

3. Commandes :

```cmd
list disk
select disk 1
clean
convert mbr
create partition primary size=15360
format fs=ntfs label=DATA quick
assign letter=D
exit
```

> ⚠️ Attention : `disk 1` doit bien correspondre au **deuxième disque** de 40 Go.

### ✅ Vérifications

- Le volume `D:` existe
- Format : NTFS
- Espace utilisé : ~15 Go sur 40 Go

---

## 🐧 Debian 10 – Partitionnement manuel disque secondaire

### 🧾 Objectif

Créer et monter trois partitions :

- `PROFILS` → 15 Go en ext4
- `DATA` → 15 Go en ext4
- `LOGS` → reste (~10 Go) en xfs

### 🔧 Étapes :

1. Identifier le disque secondaire :

```bash
lsblk
```

(ici : `/dev/sdb`)

2. Créer les partitions avec `fdisk` :

```bash
sudo fdisk /dev/sdb
```

Créer 3 partitions primaires :

- `/dev/sdb1` → 15 Go
- `/dev/sdb2` → 15 Go
- `/dev/sdb3` → reste

3. Formater :

```bash
sudo mkfs.ext4 /dev/sdb1 -L PROFILS
sudo mkfs.ext4 /dev/sdb2 -L DATA
sudo apt install xfsprogs
sudo mkfs.xfs /dev/sdb3 -L LOGS
```

4. Créer les points de montage :

```bash
sudo mkdir /mnt/profils /mnt/data /mnt/logs
```

5. Monter temporairement :

```bash
sudo mount /dev/sdb1 /mnt/profils
sudo mount /dev/sdb2 /mnt/data
sudo mount /dev/sdb3 /mnt/logs
```

---

## 🐧 Debian 10 – Redéfinition de `/home` → `/mnt/profils`

### 🧾 Objectif

Remplacer `/home` par `/mnt/profils`, avec **transfert de données existantes** et **montage permanent**

### 🔧 Étapes :

```bash
sudo rsync -av /home/ /mnt/profils/
```

- Modifier `/etc/fstab` :

```bash
echo 'LABEL=PROFILS /home ext4 defaults 0 2' | sudo tee -a /etc/fstab
```

- Redémarrer et vérifier :

```bash
mount | grep /home
```

> 🔄 L’ancien `/home` peut être vidé ou renommé (`/home.old`) en cas de rollback nécessaire.

---

## 🐧 Debian 10 – Montage `/services` et structure par service

### Objectif

- Monter `DATA` sur `/services`
- Créer une structure par service avec droits restreints et hérités

### 🔧 Étapes

```bash
sudo mkdir /services
sudo mount /dev/sdb2 /services
sudo chown root:root /services
sudo chmod 755 /services
```

#### Arborescence :

```bash
sudo mkdir /services/{direction,commercial,comptabilite,informatique,logistique}
```

#### Groupes et droits

```bash
# Exemple pour commercial
sudo chgrp GG_Commercial /services/commercial
sudo chmod 770 /services/commercial
```

> 🔁 Appliquer la même logique pour chaque répertoire avec le groupe correspondant.

#### Sticky bit de groupe (SGID)

```bash
sudo chmod g+s /services/*
```

Permet de faire en sorte que tous les fichiers créés dans un dossier hérite du bon groupe.

---

## 🖥️ Windows 10 – Dossiers restreints par service

### Objectif

- Créer deux dossiers sur `D:`
    - `Commerciaux` → accessible uniquement par GG_Commercial
    - `Support_Info` → réservé aux informaticiens

### 🔧 Étapes

1. Créer les dossiers dans `D:`
2. Clic droit > Propriétés > Sécurité
3. Supprimer tous les groupes sauf :
    - Pour `Commerciaux` : ajouter `GG_Commercial` avec contrôle total
    - Pour `Support_Info` : ajouter `GG_Informatique` avec contrôle total

> 📌 Ne pas oublier d’appliquer les changements aux sous-dossiers et fichiers.

---

## 🖥️ Partage réseau `Support_Info`

### 🔧 Étapes de partage

1. Clic droit sur `D:\Support_Info` > Propriétés > Partage
2. Nom du partage : `Support_Info$` (le `$` le rend invisible)
3. Permissions :
    - `GG_Informatique` → Contrôle total

### ✅ Vérification des partages (cmd)

```cmd
net share
```

### 🔄 Partage scriptable en PowerShell

```powershell
New-SmbShare -Name "Support_Info$" -Path "D:\Support_Info" -FullAccess "GG_Informatique" -Description "Partage sécurisé"
```

---

## 📎 Connexion réseau depuis la machine du binôme

### Objectif : connecter un lecteur `U:` vers `\\W10-MD\Support_Info$`, automatiquement

#### 🅰 Méthode 1 : Script PowerShell au démarrage

```powershell
New-PSDrive -Name "U" -PSProvider FileSystem -Root "\\W10-MD\Support_Info$" -Persist
```

#### 🅱 Méthode 2 : Script batch + planificateur de tâches

```cmd
net use U: \\W10-MD\Support_Info$ /persistent:yes
```

> 💡 Toujours tester que l’utilisateur peut écrire un fichier dans le dossier cible.

---

## ✅ Résumé des validations

|Élément|Vérification attendue|
|---|---|
|Partition D: Windows avec DISKPART|15 Go / MBR, lettre D, nommée DATA|
|3 partitions Debian (ext4/xfs)|Labels : PROFILS, DATA, LOGS|
|Remontage de /home|`/home` pointant vers PROFILS|
|Structure /services|Dossiers par service, droits 770, SGID actifs|
|Dossiers D:\Support_Info et Commerciaux|Accès restreints par groupe|
|Partage Support_Info$|Invisible, contrôle total pour GG_Informatique|
|Accès depuis binôme|Montage automatique du lecteur réseau U:|
