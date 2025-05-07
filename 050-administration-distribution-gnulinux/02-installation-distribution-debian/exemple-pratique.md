# TP – Installation de Debian GNU/Linux (Module 02)

# 🖥️ TP1 – Installation de Debian **avec** interface graphique

### 📥 Récupération de l’image ISO

```bash
# Exemple : depuis le serveur ENI ou miroir Debian
cp /mnt/partage/debian-11.x.x-amd64-netinst.iso ~/ISOs/
```

### ⚙️ Paramétrage de la machine virtuelle (VM)

- **Disque dur** : 40 Go (dynamique)
- **Mémoire vive** : 4096 Mo
- **Réseau** : mode **Bridged**
- **ISO** monté comme CD-ROM

### 🧭 Options d’installation

- Mode : **Graphique**
- Langue : Français
- Localisation : France
- Clavier : Français

### 👤 Création des comptes

- Saisie du mot de passe root
- Création d’un utilisateur personnel

### 💽 Partitionnement **manuel** avec LVM

|Type|Taille|Format|Point de montage|
|---|---|---|---|
|LVM|2048 Mo|swap|—|
|LVM|20 Go|ext4|`/`|
|LVM|5 Go|FAT32|`/windows`|
|LVM|reste|ext4|`/home`|

### 🧰 Configuration des dépôts

- **Miroir** : ftp.fr.debian.org
- **Proxy** : Aucun
- **Popularity contest** : Non

### 📦 Logiciels à installer

- Environnement de bureau Debian
- Utilitaires usuels du système

### 🔃 GRUB

- Installer sur : `/dev/sda`

---

# 🖥️ TP2 – Installation de Debian **sans** interface graphique (serveur)

### 📥 Récupération de l’image ISO

```bash
cp /mnt/partage/debian-11.x.x-amd64-dvd.iso ~/ISOs/
```

### ⚙️ Paramétrage de la machine virtuelle

- **Disque dur** : 10 Go (dynamique)
- **Mémoire vive** : 2048 Mo
- **Réseau** : mode **Bridged**

### 🧭 Options d’installation

- Mode : Graphique par défaut
- Langue / localisation / clavier : France
- Domaine : `ad.campus-eni.fr`
- Création du mot de passe root + utilisateur standard

### 💽 Partitionnement **assisté** avec LVM (automatique)

- Partition `/home`, `/var`, `/tmp` séparées créées automatiquement

### 🧰 Configuration des paquets

- **Pas d’utilisation de miroirs**
- **No CD/DVD supplémentaire**
- **Popularity contest** : Non

### 📦 Logiciels à installer

- Serveur SSH
- Utilitaires usuels du système

### 🔃 GRUB

- Installer sur : `/dev/sda`

---

## ✅ À retenir pour les révisions

- LVM facilite la gestion et l’extension des volumes
- Une **installation serveur** ne nécessite **aucun environnement graphique**
- Le choix du partitionnement impacte la sécurité et la modularité
- On utilise le **Netinstall** pour obtenir des paquets à jour, et les **ISOs DVD** pour des installations hors-ligne

---

## 📌 Bonnes pratiques professionnelles

- Toujours adapter la VM au rôle cible : client ou serveur
- Privilégier le partitionnement **manuel** pour les systèmes critiques
- Ne jamais exposer une machine sans mise à jour de sécurité post-installation
- Documenter les étapes d’installation pour pouvoir les répliquer

---

## 🔗 Ressources utiles

- [Documentation Debian officielle](https://www.debian.org/releases/stable/installmanual)
- [Ventoy – ISO boot multi-OS](https://www.ventoy.net/)
