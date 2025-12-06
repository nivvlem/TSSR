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