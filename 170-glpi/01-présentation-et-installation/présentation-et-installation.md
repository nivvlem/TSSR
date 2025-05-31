# Présentation et installation de GLPI
## 🧩 Présentation de GLPI

### Qu’est-ce que GLPI ?

**GLPI** = Gestion Libre de Parc Informatique

- Logiciel **ITSM** (IT Service Management) conforme **ITIL**
- Licence **GPL** (logiciel libre)
- Application **web** multi-langues
- Gestion complète de :
    - Parc matériel et logiciel
    - Tickets d’incident et demandes de service
    - Gestion documentaire
    - Suivi des contrats
    - Interfaces avec d’autres outils (OCS, FusionInventory...)

### Usage

- Pour **PME** et **grandes entreprises**
- Déploiement **Linux** (Apache2 / Nginx / PHP / MariaDB)
- Évolutif avec de nombreux **plugins**

---

## 🛠️ Environnement d’installation

### Environnement du TP

|Machine|Rôle|IP|Interface|
|---|---|---|---|
|`srv-glpi`|Serveur GLPI|`192.168.1.X`|VMNET 18|
|`srv-CD01`|Contrôleur de domaine|`192.168.1.Y`|VMNET 18|
|`pfSense`|Routeur/DHCP|`192.168.1.254`|VMNET 18|

### Composants nécessaires

|Composant|Détail|
|---|---|
|SGBD|MySQL / MariaDB (recommandé)|
|Serveur web|Apache2 (ou Nginx)|
|PHP|PHP 7.4 minimum + extensions|
|Application|GLPI (version actuelle recommandée)|

---

## 🔑 Installation de MariaDB

### Installation

```bash
apt install mariadb-server mariadb-client
```

### Sécurisation

```bash
mysql_secure_installation
```

Réponses recommandées :

|Question|Réponse|
|---|---|
|Root password|Y (définir un mot de passe fort)|
|Remove anonymous users|Y|
|Disallow root remote login|Y|
|Remove test database|Y|
|Reload privilege tables|Y|

### Création de la base GLPI

```bash
mysql -u root -p
mysql> CREATE DATABASE glpidata;
mysql> GRANT ALL PRIVILEGES ON glpidata.* TO 'root'@'localhost' IDENTIFIED BY 'MotDePasseFort';
```

---

## 🔧 Installation du serveur web et PHP

### Apache2

```bash
apt install apache2
```

### PHP et extensions requises

```bash
apt install php php-mysql php-mbstring php-curl php-gd php-xml php-ldap php-imap php-intl php-zip php-bz2 php-apcu-bc php-cas
```

### Vérification version PHP

```bash
php -v
```

---

## 📥 Installation de GLPI

### Téléchargement

- Télécharger l’archive officielle : [https://glpi-project.org/fr/](https://glpi-project.org/fr/)

### Déploiement

```bash
cd /var/www/
tar -xvzf glpi-x.x.x.tgz
chown -R www-data:www-data /var/www/glpi
```

### Accès web

```text
http://@ipSrvGLPI/glpi
```

---

## ⚙️ Configuration post-installation

### 1️⃣ Choix de la langue

- Français ou autre langue souhaitée

### 2️⃣ Installation ou mise à jour

- Choisir “Installation” pour une première installation

### 3️⃣ Vérification des prérequis

- GLPI valide la version de PHP, les extensions, droits d’écriture

### 4️⃣ Paramétrage base de données

|Paramètre|Valeur|
|---|---|
|Hôte|127.0.0.1|
|Utilisateur|root|
|Mot de passe|MotDePasseFort|
|Base de données|glpidata|

### 5️⃣ Initialisation

- Création des tables

### 6️⃣ Comptes par défaut

|Compte|Login / mot de passe initial|
|---|---|
|Super Admin|glpi / glpi|
|Technicien|tech / tech|
|Utilisateur normal|normal / normal|
|Post-only|post-only / postonly|

### 7️⃣ Sécurisation finale

- **Changer immédiatement les mots de passe** des comptes par défaut
- **Supprimer le fichier** `install/install.php`

```bash
rm -rf /var/www/glpi/install/install.php
```

- Définir un **nom d’hôte fiable** pour accéder à GLPI

---

## ✅ À retenir pour les révisions

- GLPI est un **logiciel ITSM complet et libre**
- Installation sur un stack **LAMP** (Linux, Apache, MariaDB, PHP)
- La sécurisation de MariaDB est **essentielle**
- Il est crucial de **changer les mots de passe par défaut**
- Le fichier `install.php` doit être supprimé pour sécuriser le déploiement

---

## 📌 Bonnes pratiques professionnelles

- Documenter toutes les étapes d’installation et de sécurisation
- Vérifier régulièrement la **conformité de l’environnement** (versions PHP, MariaDB)
- Mettre à jour GLPI **très régulièrement** (nombreuses failles corrigées dans les dernières versions)
- Utiliser un **reverse proxy** ou un **certificat HTTPS** valide en production
- Restreindre les **accès réseau** au serveur GLPI (firewall pfSense)
- Sauvegarder régulièrement la **base de données glpidata** et les fichiers `/var/www/glpi/files`

---

## Commandes utiles

```bash
# Installation de MariaDB
apt install mariadb-server mariadb-client

# Sécurisation de MariaDB
mysql_secure_installation

# Installation du serveur Apache + PHP + extensions GLPI
apt install apache2 php php-mysql php-mbstring php-curl php-gd php-xml php-ldap php-imap php-intl php-zip php-bz2 php-apcu-bc php-cas

# Droits sur le répertoire GLPI
chown -R www-data:www-data /var/www/glpi

# Suppression de install.php
rm -rf /var/www/glpi/install/install.php
```
