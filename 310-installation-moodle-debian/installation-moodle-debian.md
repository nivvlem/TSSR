# Installation de Moodle 5.1 sur Debian 12 (LAMP)

## 1. Préparation du système

```bash
sudo apt update
sudo apt full-upgrade -y
sudo apt install -y vim curl wget unzip htop
```

---

## 2. Installation d’Apache, MariaDB et PHP

### Apache et MariaDB

```bash
sudo apt install -y apache2 mariadb-server
```

### PHP 8.2 et extensions nécessaires

```bash
sudo apt install -y \
  php php-cli libapache2-mod-php \
  php-intl php-xml php-soap php-mysql php-zip \
  php-gd php-tidy php-mbstring php-curl php-bcmath
```

---

## 3. Configuration de MariaDB

### Sécurisation initiale

```bash
sudo mysql_secure_installation
```

### Paramètres utilisés sur la VM test

- Suppression des utilisateurs anonymes : oui
- Suppression de la base de test : oui
- Mot de passe root : déjà configuré

### Création de la base et de l’utilisateur

```bash
sudo mysql -u root -p
```

```sql
CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'moodleuser'@'localhost' IDENTIFIED BY 'MotDePasseTest123!';
GRANT ALL PRIVILEGES ON moodle.* TO 'moodleuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

---

## 4. Configuration des répertoires

### Dossier des données Moodle (dataroot)

```bash
sudo mkdir -p /var/moodledata
sudo chown -R www-data:www-data /var/moodledata
sudo chmod 770 /var/moodledata
```

---

## 5. Installation de Moodle 5.1

### Téléchargement et extraction

```bash
cd /tmp
wget https://download.moodle.org/download.php/direct/stable501/moodle-latest-501.tgz
sudo tar -xzf moodle-latest-501.tgz
sudo mv moodle /var/www/moodle
sudo chown -R www-data:www-data /var/www/moodle
```

### Permissions

```bash
sudo find /var/www/moodle -type d -exec chmod 750 {} \;
sudo find /var/www/moodle -type f -exec chmod 640 {} \;
```

---

## 6. Configuration de PHP

```bash
sudo vim /etc/php/8.2/apache2/php.ini
```

Paramètres recommandés :

```
memory_limit = 256M
max_execution_time = 300
max_input_vars = 5000
post_max_size = 128M
upload_max_filesize = 128M

opcache.enable = 1
opcache.memory_consumption = 128
opcache.max_accelerated_files = 4000
```

Redémarrage :

```bash
sudo systemctl restart apache2
```

---

## 7. VirtualHost Apache pour Moodle 5.1

```bash
sudo vim /etc/apache2/sites-available/moodle.conf
```

Contenu :

```apacheconf
<VirtualHost *:80>
    DocumentRoot /var/www/moodle/public

    <Directory /var/www/moodle/public>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/moodle_error.log
    CustomLog ${APACHE_LOG_DIR}/moodle_access.log combined
</VirtualHost>
```

Activation :

```bash
sudo a2ensite moodle.conf
sudo a2dissite 000-default.conf
sudo a2enmod rewrite
sudo systemctl reload apache2
```

---

## 8. Installation via navigateur

Accès sur la VM test via :

```
http://192.168.1.173
```

Paramètres utilisés :

### Chemins

- Code : `/var/www/moodle`
- Données : `/var/moodledata`

### Base de données

- Serveur : `localhost`
- Base : `moodle`
- Utilisateur : `moodleuser`
- Mot de passe : celui défini précédemment
- Préfixe : `mdl_`

Les avertissements suivants sont normaux en contexte de test :

- _Composer vendor directory not found_
- _site not https_

---

## 9. Cron Moodle

Édition de la crontab de www-data :

```bash
sudo -u www-data crontab -e
```

Ajout :

```cron
*/5 * * * * /usr/bin/php /var/www/moodle/admin/cli/cron.php >/dev/null 2>&1
```

---

## 10. Vérifications

### Logs Apache

```bash
sudo tail -f /var/log/apache2/moodle_error.log
```

### Tests fonctionnels

- Connexion à Moodle
- Création d’un cours
- Ajout d’un utilisateur
- Vérification de l’écriture dans `/var/moodledata`

---

## 11. Notes 

- Moodle 5.1 nécessite l’utilisation du sous-dossier `public/` comme DocumentRoot.
- Le répertoire `moodledata` doit impérativement être placé hors du webroot.
- Les avertissements Composer/HTTPS sont normaux en contexte de laboratoire.
#### Rôle du dataroot

Le répertoire `/var/moodledata` stocke les fichiers téléversés, les caches, les sessions et les données générées par Moodle. Il doit toujours être placé en dehors du répertoire web, afin d’éviter toute exposition accidentelle.

#### Rôle du cron Moodle

Le cron exécute les tâches planifiées : envois d’e‑mails, nettoyage, synchronisation, opérations des plugins, tâches automatiques. Sans lui, certaines fonctionnalités cessent de fonctionner et Moodle signale un retard du cron.

#### Usage du VirtualHost

Le VirtualHost définit la façon dont Apache expose Moodle. Dans Moodle 5.1, la racine publique est déplacée dans `public/`, ce qui renforce la sécurité en empêchant l’accès direct à certains fichiers internes.

---

## 12. Erreurs rencontrées et solutions

### Erreur HTTP 500 après installation

Causes possibles :

- `DocumentRoot` incorrect (`/var/www/moodle` au lieu de `/var/www/moodle/public`).
- Permissions insuffisantes sur `/var/www/moodle` ou `/var/moodledata`.

Solution : corriger le VirtualHost et vérifier propriétaires/droits.

### "Failed opening required 'config.php'"

Survient généralement lorsque les fichiers Moodle sont partiels ou lorsque `index.php` est exécuté depuis la mauvaise racine.

Solution : vérifier le contenu du répertoire et s’assurer que le VirtualHost pointe vers `public/`.

### Dataroot non valide

Moodle refuse tout répertoire placé sous `/var/www/`.

Solution : utiliser `/var/moodledata` avec propriétaire `www-data` et permissions `770`.

### Modules PHP manquants

Survient si une extension n’est pas installée.

Solution : s’assurer de l’installation complète des paquets PHP recommandés.

---

## 13. Script d’installation semi-automatisée

Le script suivant permet d’automatiser cette procédure sur une Debian 12 neuve. L’installation finale reste à terminer via le navigateur Web.

```bash
#!/usr/bin/env bash
set -euo pipefail

#################################
### 0. Contrôles préalables
#################################

if [[ "$EUID" -ne 0 ]]; then
  echo "Ce script doit être exécuté en root (sudo)."
  exit 1
fi

if ! command -v wget >/dev/null 2>&1; then
  echo "wget n'est pas installé. Installation..."
  apt update
  apt install -y wget
fi

#################################
### 1. Saisie des variables
#################################

read -rp "Nom de la base MariaDB (défaut : moodle) : " DB_NAME
DB_NAME=${DB_NAME:-moodle}

read -rp "Nom de l'utilisateur MariaDB (défaut : moodleuser) : " DB_USER
DB_USER=${DB_USER:-moodleuser}

read -rp "Mot de passe de l'utilisateur MariaDB : " DB_PASS
if [[ -z "$DB_PASS" ]]; then
  echo "Mot de passe MariaDB obligatoire."
  exit 1
fi

read -rp "IP ou nom d'hôte à utiliser dans l'URL (ex : 192.168.1.173) : " MOODLE_HOST
if [[ -z "$MOODLE_HOST" ]]; then
  echo "Valeur obligatoire."
  exit 1
fi

#################################
### 2. Mise à jour système + outils de base
#################################

echo "Mise à jour du système et installation des outils de base..."
apt update
apt full-upgrade -y
apt install -y vim curl wget unzip htop

#################################
### 3. Installation Apache, MariaDB, PHP
#################################

echo "Installation d'Apache, MariaDB et PHP..."
apt install -y apache2 mariadb-server

# PHP 8.2 + extensions nécessaires pour Moodle 5.1
apt install -y \
  php php-cli libapache2-mod-php \
  php-intl php-xml php-soap php-mysql php-zip \
  php-gd php-tidy php-mbstring php-curl php-bcmath

systemctl enable --now apache2
systemctl enable --now mariadb

#################################
### 4. Configuration MariaDB (base + utilisateur)
#################################

echo "Création de la base et de l'utilisateur MariaDB..."

mysql <<SQL
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
SQL

#################################
### 5. Répertoire de données Moodle (dataroot)
#################################

echo "Création du dataroot /var/moodledata..."
mkdir -p /var/moodledata
chown -R www-data:www-data /var/moodledata
chmod 770 /var/moodledata

#################################
### 6. Téléchargement et installation de Moodle 5.1
#################################

echo "Téléchargement de Moodle 5.1..."
cd /tmp
rm -f moodle-latest-501.tgz

wget https://download.moodle.org/download.php/direct/stable501/moodle-latest-501.tgz -O moodle-latest-501.tgz

echo "Vérification de l'archive..."
if ! file moodle-latest-501.tgz | grep -qi "gzip compressed data"; then
  echo "Le fichier téléchargé ne semble pas être une archive gzip valide."
  exit 1
fi

echo "Extraction de l'archive..."
tar -xzf moodle-latest-501.tgz

# Sauvegarde éventuelle d'un ancien répertoire
if [[ -d /var/www/moodle ]]; then
  echo "Un répertoire /var/www/moodle existe déjà. Sauvegarde sous /var/www/moodle.old.\$(date +%Y%m%d%H%M%S)"
  mv /var/www/moodle /var/www/moodle.old.$(date +%Y%m%d%H%M%S)
fi

mv /tmp/moodle /var/www/moodle
chown -R www-data:www-data /var/www/moodle

echo "Application des permissions sur le code Moodle..."
find /var/www/moodle -type d -exec chmod 750 {} \;
find /var/www/moodle -type f -exec chmod 640 {} \;

#################################
### 7. Configuration PHP spécifique Moodle
#################################

echo "Création du fichier de configuration PHP pour Moodle..."
MOODLE_PHP_CONF="/etc/php/8.2/apache2/conf.d/90-moodle.ini"

cat > "$MOODLE_PHP_CONF" <<'EOF'
; Paramètres recommandés pour Moodle 5.1
memory_limit = 256M
max_execution_time = 300
max_input_vars = 5000
post_max_size = 128M
upload_max_filesize = 128M

opcache.enable = 1
opcache.memory_consumption = 128
opcache.max_accelerated_files = 4000
EOF

systemctl restart apache2

#################################
### 8. VirtualHost Apache pour Moodle 5.1
#################################

echo "Configuration du VirtualHost Apache..."

MOODLE_VHOST="/etc/apache2/sites-available/moodle.conf"

cat > "$MOODLE_VHOST" <<EOF
<VirtualHost *:80>
    ServerName $MOODLE_HOST

    DocumentRoot /var/www/moodle/public

    <Directory /var/www/moodle/public>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/moodle_error.log
    CustomLog \${APACHE_LOG_DIR}/moodle_access.log combined
</VirtualHost>
EOF

a2ensite moodle.conf
a2dissite 000-default.conf || true
a2enmod rewrite
systemctl reload apache2

#################################
### 9. Cron Moodle (optionnel)
#################################

echo
echo "Souhait d'ajouter le cron Moodle dans la crontab de www-data ?"
echo "Ligne proposée :"
echo "*/5 * * * * /usr/bin/php /var/www/moodle/admin/cli/cron.php >/dev/null 2>&1"
read -rp "Ajouter automatiquement cette ligne au cron de www-data ? [o/N] : " ADD_CRON
ADD_CRON=${ADD_CRON:-N}

if [[ "$ADD_CRON" =~ ^[oOyY]$ ]]; then
  TMP_CRON=$(mktemp)
  # On récupère la crontab existante (s'il y en a une)
  (crontab -u www-data -l 2>/dev/null || true) > "$TMP_CRON"
  if ! grep -q "moodle/admin/cli/cron.php" "$TMP_CRON"; then
    echo "*/5 * * * * /usr/bin/php /var/www/moodle/admin/cli/cron.php >/dev/null 2>&1" >> "$TMP_CRON"
    crontab -u www-data "$TMP_CRON"
  fi
  rm -f "$TMP_CRON"
  echo "Cron Moodle configuré pour l'utilisateur www-data."
else
  echo "Cron Moodle à ajouter manuellement si nécessaire."
fi

#################################
### 10. Synthèse
#################################

echo
echo "Installation terminée (partie système)."
echo
echo "Résumé :"
echo "- Code Moodle : /var/www/moodle"
echo "- Dataroot     : /var/moodledata"
echo "- Base MariaDB : $DB_NAME"
echo "- Utilisateur  : $DB_USER"
echo
echo "Accès à l'installateur Web :"
echo "  -> http://$MOODLE_HOST/"
echo
echo "L'installation doit maintenant être terminée via le navigateur (choix de la langue, paramètres du site, création du compte administrateur, etc.)."
```

### 🔧 Rappel rapide d’utilisation

```bash
vim install_moodle51.sh
chmod +x install_moodle51.sh
sudo ./install_moodle51.sh
```

Script disponible dans le dépôt :
[`scripts/install_moodle51.sh`](https://github.com/nivvlem/TSSR/blob/main/scripts/install_moodle51.sh)
