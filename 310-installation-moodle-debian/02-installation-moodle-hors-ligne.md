# Installation de Moodle 5.1 hors ligne (clé USB)

## 1. Pré requis et contexte

### 1.1. Hypothèses

- **Machine A** : Debian disposant d’un accès Internet (préparation des ressources).
- **Machine B** : Debian **sans accès Internet** (installation finale).
- Une clé USB destinée à transporter les paquets et le script.

> Il est recommandé que les deux machines utilisent la **même version de Debian** et la même architecture (ex : amd64). Toute divergence peut entraîner des incompatibilités de dépendances.

---

## 2. Préparation de la structure sur Machine A

Créer une arborescence de travail :

```bash
mkdir -p ~/moodle-offline/debs
mkdir -p ~/moodle-offline/moodle
```

La clé USB contiendra ensuite :

```text
/usb/
 ├── debs/                      # Paquets .deb + index Packages.gz
 ├── moodle/                    # Archive de Moodle
 │    └── moodle-latest-501.tgz
 └── install-moodle.sh          # Script d’installation hors ligne
```

---

## 3. Téléchargement de Moodle 5.1 (Machine A)

Récupération de l’archive officielle :

```bash
cd ~/moodle-offline/moodle
wget "https://download.moodle.org/download.php/direct/stable501/moodle-latest-501.tgz" \
     -O moodle-latest-501.tgz
```

Vérification de la présence du fichier :

```bash
ls -lh ~/moodle-offline/moodle
```

---

## 4. Téléchargement des paquets Debian nécessaires

### 4.1. Paquets requis

```text
apache2
mariadb-server
php php-cli libapache2-mod-php
php-intl php-xml php-soap php-mysql php-zip
php-gd php-tidy php-mbstring php-curl php-bcmath
vim curl wget unzip htop
```

### 4.2. Téléchargement avec dépendances

La commande suivante télécharge les paquets **ainsi que toutes leurs dépendances** :

```bash
sudo apt-get update
sudo apt-get --download-only install \
  apache2 mariadb-server \
  php php-cli libapache2-mod-php \
  php-intl php-xml php-soap php-mysql php-zip \
  php-gd php-tidy php-mbstring php-curl php-bcmath \
  vim curl wget unzip htop
```

Les `.deb` téléchargés sont disponibles dans :

```text
/var/cache/apt/archives/
```

Copie vers le répertoire de travail :

```bash
sudo cp /var/cache/apt/archives/*.deb ~/moodle-offline/debs/
```

> **Bonne pratique :** éviter toute exécution de `apt-get clean` avant la copie des paquets, sous peine d’effacer l’intégralité du cache.

---

## 5. Construction du dépôt APT local

### 5.1. Installation des outils nécessaires

```bash
sudo apt-get install dpkg-dev
```

### 5.2. Génération de l’index `Packages.gz`

```bash
cd ~/moodle-offline/debs
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
```

L’index est indispensable pour que `apt` puisse utiliser les paquets hors ligne.

---

## 6. Copie vers la clé USB

Montage de la clé USB :

```bash
sudo mkdir -p /mnt/usb
sudo mount /dev/sdb1 /mnt/usb
```

Copie :

```bash
sudo rsync -av ~/moodle-offline/ /mnt/usb/
```

Démontage sécurisé :

```bash
sudo umount /mnt/usb
```

---

## 7. Préparation de la machine cible (Machine B, hors ligne)

### 7.1. Montage de la clé USB

```bash
sudo mkdir -p /mnt/usb
sudo mount /dev/sdb1 /mnt/usb      # Adapter au besoin avec lsblk
```

Affichage du contenu pour vérification :

```bash
ls -R /mnt/usb
```

### 7.2. Déclaration du dépôt local

Création du fichier source :

```bash
echo "deb [trusted=yes] file:///mnt/usb/debs ./" | \
  sudo tee /etc/apt/sources.list.d/moodle-usb.list
```

Mise à jour de l’index APT :

```bash
sudo apt-get update
```

### 7.3. Vérification de la disponibilité des paquets

Exécution d’une installation simulée :

```bash
sudo apt-get install --simulate apache2
```

Si aucune erreur n'apparaît, le dépôt hors ligne est fonctionnel.

---

## 8. Exécution du script d'installation

Rendre le script exécutable et l’exécuter :

```bash
sudo chmod +x /mnt/usb/install-moodle.sh
sudo /mnt/usb/install-moodle.sh
```

Toutes les commandes `apt install` utiliseront automatiquement :

- le dépôt USB (`file:///mnt/usb/debs`),
- l’archive Moodle locale.

---

## 9. Pièges rencontrés et bonnes pratiques

### 9.1. Différences de versions Debian

- **Problème potentiel :** incohérences de dépendances.
- **Recommandation :** utiliser la même version Debian pour les machines A et B.

### 9.2. Nettoyage prématuré du cache APT

- **Problème :** suppression des `.deb` avant copie.
- **Recommandation :** copier les paquets avant tout nettoyage.

### 9.3. Dépendances manquantes

- **Problème :** utilisation de `apt-get download`, insuffisant.
- **Recommandation :** utiliser `apt-get --download-only install`.

### 9.4. Erreurs de chemin dans `file:///`

- **Problème :** oubli du troisième `/`.
- **Bonne forme :** `file:///mnt/usb/debs`.

### 9.5. Dépôt non signé

- **Problème :** APT refuse l’utilisation.
- **Recommandation :** ajouter `trusted=yes` dans la ligne du dépôt.

### 9.6. Absence de tests préalables

- **Problème :** découverte de dépendances manquantes le jour de l’installation.
- **Recommandation :** effectuer une installation complète hors ligne dans une VM de test.
