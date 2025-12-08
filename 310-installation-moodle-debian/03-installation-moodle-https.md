# Installation de Moodle 5.1 avec HTTPS (certificat auto-signé)

## 1. Pré requis techniques

- Paquets :
    - `apache2`
    - `mariadb-server`
    - `php` + extensions nécessaires
    - `openssl`
    - modules Apache : `ssl`, `headers`, `rewrite`
- Nom d’hôte ou adresse IP utilisé dans l’URL Moodle, par exemple :
    - `moodle.local` (recommandé en environnement de test) ;
    - ou `192.168.x.y`.

**Bonne pratique :** privilégier un nom d’hôte (FQDN interne) pour se rapprocher d’un contexte de production.

---

## 2. Principes de la mise en place HTTPS

1. Génération d’un certificat auto-signé avec `openssl`, stocké dans `/etc/apache2/ssl`.
2. Création d’un VirtualHost HTTPS (`*:443`) pointant sur `/var/www/moodle/public`.
3. Mise en place d’un VirtualHost HTTP (`*:80`) redirigeant vers HTTPS (selon le script choisi).
4. Activation des modules Apache nécessaires (`ssl`, `headers`, `rewrite`).
5. Test de la configuration Apache avant rechargement.

**Piège fréquent :** oublier d’activer le module `ssl` (`a2enmod ssl`), ce qui empêche Apache d’écouter sur le port 443.

---

## 3. Génération du certificat auto-signé

Emplacement recommandé : `/etc/apache2/ssl`.

Création du répertoire :

```bash
mkdir -p /etc/apache2/ssl
```

Génération du certificat et de la clé privée :

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/apache2/ssl/moodle.key \
  -out /etc/apache2/ssl/moodle.crt \
  -subj "/C=FR/ST=Lab/L=Local/O=SR/OU=Test/CN=MOODLE_HOST"
```

`MOODLE_HOST` doit être remplacé par la valeur réellement utilisée (ex. `moodle.local`).

**Erreur courante : CN incorrect**  
Lorsque le champ `CN` ne correspond pas au nom utilisé dans l’URL (par exemple certificat pour `moodle.local` mais accès via `192.168.0.10`), des avertissements supplémentaires apparaissent dans le navigateur. Dans un laboratoire, un avertissement est attendu pour un certificat auto-signé, mais l’alignement du CN reste recommandé.

---

## 4. VirtualHost HTTPS pour Moodle 5.1

Pour Moodle 5.1, les requêtes doivent pointer vers le sous-dossier `public/`.

Exemple de VirtualHost HTTPS :

```apache
<VirtualHost *:443>
    ServerName MOODLE_HOST

    DocumentRoot /var/www/moodle/public

    <Directory /var/www/moodle/public>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/moodle.crt
    SSLCertificateKeyFile /etc/apache2/ssl/moodle.key

    Header always set Strict-Transport-Security "max-age=31536000"

    ErrorLog ${APACHE_LOG_DIR}/moodle_ssl_error.log
    CustomLog ${APACHE_LOG_DIR}/moodle_ssl_access.log combined
</VirtualHost>
```

**Bonne pratique :** positionner explicitement `DocumentRoot` sur `.../public` pour respecter la structure moderne de Moodle.

---

## 5. VirtualHost HTTP et redirection vers HTTPS

### 5.1. HTTPS forcé

Pour forcer l’utilisation de HTTPS, un VirtualHost HTTP minimal est utilisé afin de rediriger toute requête vers HTTPS :

```apache
<VirtualHost *:80>
    ServerName MOODLE_HOST
    Redirect / https://MOODLE_HOST/
</VirtualHost>
```

### 5.2. HTTP uniquement

En cas d’installation en HTTP seul (version avec choix), un VirtualHost HTTP desservant directement Moodle est utilisé :

```apache
<VirtualHost *:80>
    ServerName MOODLE_HOST

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

**Piège fréquent :** laisser actif le VirtualHost `000-default.conf` d’Apache, conduisant au service du contenu par défaut (`/var/www/html`) au lieu de Moodle.

---

## 6. Activation des sites et modules Apache

- Activation des sites : `moodle.conf` (HTTP) et, le cas échéant, `moodle-ssl.conf` (HTTPS).
- Activation des modules indispensables :

```bash
a2ensite moodle.conf
a2ensite moodle-ssl.conf    # si HTTPS activé
a2dissite 000-default.conf || true

a2enmod ssl
A2ENMOD headers
a2enmod rewrite
```

**Bonne pratique :** exécuter la commande suivante avant tout rechargement :

```bash
apachectl configtest
```

En cas de `Syntax OK`, rechargement du service :

```bash
systemctl reload apache2
```

---

## 7. Erreurs communes et bonnes pratiques

### 7.1. Modules Apache non activés

- Effet : le site HTTPS ne démarre pas ou les redirections ne fonctionnent pas.
- Vérifications :
    - `a2enmod ssl`
    - `a2enmod headers`
    - `a2enmod rewrite`

### 7.2. Mauvais DocumentRoot

- Effet : pages vides, erreurs 404 ou exécution incorrecte du code.
- Recommandation : `DocumentRoot /var/www/moodle/public` pour Moodle 5.1.

### 7.3. VirtualHost par défaut actif

- Effet : affichage de la page Apache par défaut au lieu de Moodle.
- Recommandation : `a2dissite 000-default.conf`.

### 7.4. CN du certificat non cohérent

- Effet : avertissements supplémentaires dans le navigateur.
- Recommandation : cohérence du CN avec l’URL d’accès.

### 7.5. Absence de test de configuration

- Effet : Apache ne redémarre pas correctement après modification.
- Recommandation : `apachectl configtest` systématique avant `reload`.

---

## 8. Script d'installation Moodle 5.1 avec HTTPS forcé

Script de base modifié pour générer un certificat auto-signé, activer HTTPS et rediriger HTTP vers HTTPS.

```bash
#!/usr/bin/env bash
set -euo pipefail

##############################
### 0. Contrôles préalables
##############################

if [[ "$EUID" -ne 0 ]]; then
  echo "Ce script doit être exécuté en root (sudo)."
  exit 1
fi

if ! command -v wget >/dev/null 2>&1; then
  echo "wget n'est pas installé. Installation..."
  apt update
  apt install -y wget
fi

##############################
### 1. Saisie des variables
##############################

read -rp "Nom de la base MariaDB (défaut : moodle) : " DB_NAME
DB_NAME=${DB_NAME:-moodle}

read -rp "Nom de l'utilisateur MariaDB (défaut : moodleuser) : " DB_USER
DB_USER=${DB_USER:-moodleuser}

read -rp "Mot de passe de l'utilisateur MariaDB : " DB_PASS
if [[ -z "$DB_PASS" ]]; then
  echo "Mot de passe MariaDB obligatoire."
  exit 1
fi

read -rp "IP ou nom d'hôte à utiliser dans l'URL : " MOODLE_HOST
if [[ -z "$MOODLE_HOST" ]]; then
  echo "Valeur obligatoire."
  exit 1
fi

##############################
### 2. Mise à jour système + outils de base
##############################

echo "Mise à jour du système et installation des outils de base..."
apt update
apt full-upgrade -y
apt install -y vim curl wget unzip htop

##############################
### 3. Installation Apache, MariaDB, PHP
##############################

echo "Installation d'Apache, MariaDB et PHP..."
apt install -y apache2 mariadb-server openssl

apt install -y \
  php php-cli libapache2-mod-php \
  php-intl php-xml php-soap php-mysql php-zip \
  php-gd php-tidy php-mbstring php-curl php-bcmath

systemctl enable --now apache2
systemctl enable --now mariadb

##############################
### 4. Création base + utilisateur MariaDB
##############################

echo "Création de la base et de l'utilisateur MariaDB..."

mysql <<SQL
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
SQL

##############################
### 5. Durcissement MariaDB (optionnel)
##############################

SECURE_BIN=""
if command -v mysql_secure_installation >/dev/null 2>&1; then
  SECURE_BIN="mysql_secure_installation"
elif command -v mariadb-secure-installation >/dev/null 2>&1; then
  SECURE_BIN="mariadb-secure-installation"
fi

if [[ -n "$SECURE_BIN" ]]; then
  echo
  echo "Un assistant de sécurisation MariaDB est disponible : $SECURE_BIN"
  echo "Il permet de configurer le compte root, supprimer les utilisateurs anonymes,"
  echo "désactiver le login root distant et supprimer la base de test."
  read -rp "Souhait d'exécuter cet assistant maintenant ? [o/N] : " RUN_SECURE
  RUN_SECURE=${RUN_SECURE:-N}
  if [[ "$RUN_SECURE" =~ ^[oOyY]$ ]]; then
    "$SECURE_BIN"
  else
    echo "Étape de sécurisation MariaDB ignorée à la demande de l'administrateur."
  fi
else
  echo "Aucun script mysql_secure_installation / mariadb-secure-installation trouvé."
  echo "Durcissement MariaDB éventuel à effectuer manuellement."
fi

##############################
### 6. Répertoire de données Moodle (dataroot)
##############################

echo "Création du dataroot /var/moodledata..."
mkdir -p /var/moodledata
chown -R www-data:www-data /var/moodledata
chmod 770 /var/moodledata

##############################
### 7. Téléchargement et installation de Moodle 5.1
##############################

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

if [[ -d /var/www/moodle ]]; then
  echo "Un répertoire /var/www/moodle existe déjà. Sauvegarde sous /var/www/moodle.old.$(date +%Y%m%d%H%M%S)"
  mv /var/www/moodle /var/www/moodle.old.$(date +%Y%m%d%H%M%S)
fi

mv /tmp/moodle /var/www/moodle
chown -R www-data:www-data /var/www/moodle

echo "Application des permissions sur le code Moodle..."
find /var/www/moodle -type d -exec chmod 750 {} \;
find /var/www/moodle -type f -exec chmod 640 {} \;

##############################
### 8. Configuration PHP spécifique Moodle
##############################

echo "Création du fichier de configuration PHP pour Moodle..."

PHP_SHORT_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
PHP_SAPI_DIR="/etc/php/${PHP_SHORT_VERSION}/apache2"
MOODLE_PHP_CONF="${PHP_SAPI_DIR}/conf.d/90-moodle.ini"

mkdir -p "${PHP_SAPI_DIR}/conf.d"

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

##############################
### 9. Génération du certificat SSL auto-signé
##############################

echo "Création du certificat SSL auto-signé pour $MOODLE_HOST..."

mkdir -p /etc/apache2/ssl

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/apache2/ssl/moodle.key \
  -out /etc/apache2/ssl/moodle.crt \
  -subj "/C=FR/ST=Lab/L=Local/O=SR/OU=Test/CN=$MOODLE_HOST"

##############################
### 10. VirtualHost Apache HTTP + HTTPS pour Moodle 5.1
##############################

echo "Configuration des VirtualHost Apache (HTTP + HTTPS)..."

MOODLE_VHOST_HTTP="/etc/apache2/sites-available/moodle.conf"
MOODLE_VHOST_SSL="/etc/apache2/sites-available/moodle-ssl.conf"

cat > "$MOODLE_VHOST_HTTP" <<EOF
<VirtualHost *:80>
    ServerName $MOODLE_HOST
    Redirect / https://$MOODLE_HOST/
</VirtualHost>
EOF

cat > "$MOODLE_VHOST_SSL" <<EOF
<VirtualHost *:443>
    ServerName $MOODLE_HOST

    DocumentRoot /var/www/moodle/public

    <Directory /var/www/moodle/public>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/moodle.crt
    SSLCertificateKeyFile /etc/apache2/ssl/moodle.key

    Header always set Strict-Transport-Security "max-age=31536000"

    ErrorLog \${APACHE_LOG_DIR}/moodle_ssl_error.log
    CustomLog \${APACHE_LOG_DIR}/moodle_ssl_access.log combined
</VirtualHost>
EOF

a2ensite moodle.conf
a2ensite moodle-ssl.conf
a2dissite 000-default.conf || true
a2enmod ssl
a2enmod headers
a2enmod rewrite

apachectl configtest
systemctl reload apache2

##############################
### 11. Cron Moodle
##############################

echo
echo "Souhait d'ajouter le cron Moodle dans la crontab de www-data ?"
echo "Ligne proposée :"
echo "*/5 * * * * /usr/bin/php /var/www/moodle/admin/cli/cron.php >/dev/null 2>&1"
read -rp "Ajouter automatiquement cette ligne au cron de www-data ? [o/N] : " ADD_CRON
ADD_CRON=${ADD_CRON:-N}

if [[ "$ADD_CRON" =~ ^[oOyY]$ ]]; then
  TMP_CRON=$(mktemp)
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

##############################
### 12. Synthèse
##############################

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
echo "  -> https://$MOODLE_HOST/"
echo
echo "L'installation doit maintenant être terminée via le navigateur (choix de la langue, paramètres du site, création du compte administrateur, etc.)."
```

---

## 10. Script d'installation Moodle 5.1 avec choix HTTP / HTTPS

Nouvelle itération du script ajoutant une question initiale permettant de sélectionner un déploiement HTTP simple ou HTTPS avec certificat auto-signé.

```bash
#!/usr/bin/env bash
set -euo pipefail

##############################
### 0. Contrôles préalables
##############################

if [[ "$EUID" -ne 0 ]]; then
  echo "Ce script doit être exécuté en root (sudo)."
  exit 1
fi

if ! command -v wget >/dev/null 2>&1; then
  echo "wget n'est pas installé. Installation..."
  apt update
  apt install -y wget
fi

##############################
### 1. Saisie des variables
##############################

read -rp "Nom de la base MariaDB (défaut : moodle) : " DB_NAME
DB_NAME=${DB_NAME:-moodle}

read -rp "Nom de l'utilisateur MariaDB (défaut : moodleuser) : " DB_USER
DB_USER=${DB_USER:-moodleuser}

read -rp "Mot de passe de l'utilisateur MariaDB : " DB_PASS
if [[ -z "$DB_PASS" ]]; then
  echo "Mot de passe MariaDB obligatoire."
  exit 1
fi

read -rp "IP ou nom d'hôte à utiliser dans l'URL : " MOODLE_HOST
if [[ -z "$MOODLE_HOST" ]]; then
  echo "Valeur obligatoire."
  exit 1
fi

echo "Souhait d'activer HTTPS avec certificat auto-signé ? [o/N] : "
read -r ENABLE_HTTPS
ENABLE_HTTPS=${ENABLE_HTTPS:-N}

if [[ "$ENABLE_HTTPS" =~ ^[oOyY]$ ]]; then
  USE_SSL=true
else
  USE_SSL=false
fi

##############################
### 2. Mise à jour système + outils de base
##############################

echo "Mise à jour du système et installation des outils de base..."
apt update
apt full-upgrade -y
apt install -y vim curl wget unzip htop

##############################
### 3. Installation Apache, MariaDB, PHP
##############################

echo "Installation d'Apache, MariaDB et PHP..."
apt install -y apache2 mariadb-server openssl

apt install -y \
  php php-cli libapache2-mod-php \
  php-intl php-xml php-soap php-mysql php-zip \
  php-gd php-tidy php-mbstring php-curl php-bcmath

systemctl enable --now apache2
systemctl enable --now mariadb

##############################
### 4. Création base + utilisateur MariaDB
##############################

echo "Création de la base et de l'utilisateur MariaDB..."

mysql <<SQL
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
SQL

##############################
### 5. Durcissement MariaDB (optionnel)
##############################

SECURE_BIN=""
if command -v mysql_secure_installation >/dev/null 2>&1; then
  SECURE_BIN="mysql_secure_installation"
elif command -v mariadb-secure-installation >/dev/null 2>&1; then
  SECURE_BIN="mariadb-secure-installation"
fi

if [[ -n "$SECURE_BIN" ]]; then
  echo
  echo "Un assistant de sécurisation MariaDB est disponible : $SECURE_BIN"
  echo "Il permet de configurer le compte root, supprimer les utilisateurs anonymes,"
  echo "désactiver le login root distant et supprimer la base de test."
  read -rp "Souhait d'exécuter cet assistant maintenant ? [o/N] : " RUN_SECURE
  RUN_SECURE=${RUN_SECURE:-N}
  if [[ "$RUN_SECURE" =~ ^[oOyY]$ ]]; then
    "$SECURE_BIN"
  else
    echo "Étape de sécurisation MariaDB ignorée à la demande de l'administrateur."
  fi
else
  echo "Aucun script mysql_secure_installation / mariadb-secure-installation trouvé."
  echo "Durcissement MariaDB éventuel à effectuer manuellement."
fi

##############################
### 6. Répertoire de données Moodle (dataroot)
##############################

echo "Création du dataroot /var/moodledata..."
mkdir -p /var/moodledata
chown -R www-data:www-data /var/moodledata
chmod 770 /var/moodledata

##############################
### 7. Téléchargement et installation de Moodle 5.1
##############################

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

if [[ -d /var/www/moodle ]]; then
  echo "Un répertoire /var/www/moodle existe déjà. Sauvegarde sous /var/www/moodle.old.$(date +%Y%m%d%H%M%S)"
  mv /var/www/moodle /var/www/moodle.old.$(date +%Y%m%d%H%M%S)
fi

mv /tmp/moodle /var/www/moodle
chown -R www-data:www-data /var/www/moodle

echo "Application des permissions sur le code Moodle..."
find /var/www/moodle -type d -exec chmod 750 {} \;
find /var/www/moodle -type f -exec chmod 640 {} \;

##############################
### 8. Configuration PHP spécifique Moodle
##############################

echo "Création du fichier de configuration PHP pour Moodle..."

PHP_SHORT_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
PHP_SAPI_DIR="/etc/php/${PHP_SHORT_VERSION}/apache2"
MOODLE_PHP_CONF="${PHP_SAPI_DIR}/conf.d/90-moodle.ini"

mkdir -p "${PHP_SAPI_DIR}/conf.d"

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

##############################
### 9. VirtualHost Apache (HTTP / HTTPS)
##############################

echo "Configuration des VirtualHost Apache..."

MOODLE_VHOST_HTTP="/etc/apache2/sites-available/moodle.conf"
MOODLE_VHOST_SSL="/etc/apache2/sites-available/moodle-ssl.conf"

if [[ "$USE_SSL" = true ]]; then
  echo "Activation du mode HTTPS avec certificat auto-signé..."

  mkdir -p /etc/apache2/ssl

  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/apache2/ssl/moodle.key \
    -out /etc/apache2/ssl/moodle.crt \
    -subj "/C=FR/ST=Lab/L=Local/O=SR/OU=Test/CN=$MOODLE_HOST"

  cat > "$MOODLE_VHOST_HTTP" <<EOF
<VirtualHost *:80>
    ServerName $MOODLE_HOST
    Redirect / https://$MOODLE_HOST/
</VirtualHost>
EOF

  cat > "$MOODLE_VHOST_SSL" <<EOF
<VirtualHost *:443>
    ServerName $MOODLE_HOST

    DocumentRoot /var/www/moodle/public

    <Directory /var/www/moodle/public>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/moodle.crt
    SSLCertificateKeyFile /etc/apache2/ssl/moodle.key

    Header always set Strict-Transport-Security "max-age=31536000"

    ErrorLog \${APACHE_LOG_DIR}/moodle_ssl_error.log
    CustomLog \${APACHE_LOG_DIR}/moodle_ssl_access.log combined
</VirtualHost>
EOF

  a2ensite moodle.conf
  a2ensite moodle-ssl.conf
  a2dissite 000-default.conf || true
  a2enmod ssl
  a2enmod headers
  a2enmod rewrite
else
  echo "Configuration en HTTP uniquement..."

  cat > "$MOODLE_VHOST_HTTP" <<EOF
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
fi

apachectl configtest
systemctl reload apache2

##############################
### 10. Cron Moodle
##############################

echo
echo "Souhait d'ajouter le cron Moodle dans la crontab de www-data ?"
echo "Ligne proposée :"
echo "*/5 * * * * /usr/bin/php /var/www/moodle/admin/cli/cron.php >/dev/null 2>&1"
read -rp "Ajouter automatiquement cette ligne au cron de www-data ? [o/N] : " ADD_CRON
ADD_CRON=${ADD_CRON:-N}

if [[ "$ADD_CRON" =~ ^[oOyY]$ ]]; then
  TMP_CRON=$(mktemp)
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

##############################
### 11. Synthèse
##############################

echo
echo "Installation terminée (partie système)."
echo
echo "Résumé :"
echo "- Code Moodle : /var/www/moodle"
echo "- Dataroot     : /var/moodledata"
echo "- Base MariaDB : $DB_NAME"
echo "- Utilisateur  : $DB_USER"
echo

if [[ "$USE_SSL" = true ]]; then
  echo "Accès à l'installateur Web :"
  echo "  -> https://$MOODLE_HOST/"
else
  echo "Accès à l'installateur Web :"
  echo "  -> http://$MOODLE_HOST/"
fi

echo
echo "L'installation doit maintenant être terminée via le navigateur (choix de la langue, paramètres du site, création du compte administrateur, etc.)."
```
