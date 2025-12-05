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
