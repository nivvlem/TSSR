# 🩺 Procédures de diagnostics utiles

# 1. Diagnostic général du système

## 🔍 1.1. Vérification des services essentiels

```bash
systemctl status apache2
systemctl status mariadb
```

⚠️ _Erreurs fréquentes_ :

- Apache en "failed" à cause d’un VirtualHost cassé.
- MariaDB ne démarre pas après une mauvaise configuration.

✅ _Bonne pratique_ : toujours exécuter un `systemctl status` avant d’aller plus loin.

---

## 🔍 1.2. Vérification des ports ouverts

```bash
ss -tlnp | grep -E "80|443|3306"
```

Ports attendus :

- 80 → HTTP
- 443 → HTTPS
- 3306 → MariaDB

⚠️ _Piège classique_ : Apache ne démarre pas si un autre service occupe 80/443 (ex : Nginx).

---

# 2. Diagnostic Apache

## 🔍 2.1. Vérification de la configuration générale

```bash
apachectl configtest
```

Sortie attendue :

```
Syntax OK
```

⚠️ _Erreur fréquente_ : `Invalid command` ou `DocumentRoot does not exist`.

💡 _Bonnes pratiques_ :

- Exécuter systématiquement avant `systemctl reload apache2`.

---

## 🔍 2.2. Vérification des VirtualHost actifs

```bash
apache2ctl -S
```

Informations obtenues :

- Sites activés
- Ordre de priorité
- Chemin des fichiers de conf
- Correspondance avec le ServerName

⚠️ _Problèmes courants_ :

- `000-default.conf` encore actif → Moodle n’est pas servi.
- Mauvais `ServerName` → redirection incorrecte.

---

## 🔍 2.3. Vérification des modules Apache nécessaires

```bash
apache2ctl -M | grep -E "ssl|rewrite|headers|php"
```

Modules requis pour Moodle :

- `php_module`
- `rewrite_module`
- `ssl_module` (si HTTPS)
- `headers_module`

⚠️ _Erreur fréquente_ : module `rewrite` non activé → impossibilité d’utiliser `.htaccess`.

---

## 🔍 2.4. Analyse des logs Apache

```bash
tail -f /var/log/apache2/error.log
```

Erreurs utiles à retrouver :

- Problèmes de droits
- Problème PHP manquant
- Certificat SSL invalide

💡 _Bonne pratique_ : utiliser `tail -f` en parallèle d’un accès web pour voir l’erreur en direct.

---

# 3. Diagnostic PHP

## 🔍 3.1. Vérification de la version PHP en place

```bash
php -v
```

⚠️ _Problème fréquent_ : PHP 8.4 installé mais incompatible avec certains plugins.

---

## 🔍 3.2. Vérification des modules PHP nécessaires à Moodle

```bash
php -m | grep -E "intl|xml|curl|gd|zip|mbstring|soap|bcmath|mysqli"
```

Modules indispensables :

- xml
- intl
- mbstring
- curl
- zip
- soap
- gd
- mysqli

⚠️ _Page blanche Moodle_ → souvent causée par `php-xml` manquant.

---

## 🔍 3.3. Vérification de la configuration personnalisée (moodle.ini)

```bash
grep -E "memory_limit|max_execution_time|upload_max_filesize" /etc/php/*/apache2/conf.d/90-moodle.ini
```

Paramètres attendus :

- memory_limit = 256M
- max_execution_time = 300
- upload_max_filesize = 128M

⚠️ _Fichier absent_ → Moodle affiche des avertissements.

---

# 4. Diagnostic MariaDB

## 🔍 4.1. Connexion locale

```bash
mysql -u root -p
```

⚠️ _Erreur fréquente_ : mot de passe root défini mais non communiqué.

---

## 🔍 4.2. Vérification de la base Moodle

```sql
SHOW DATABASES;
```

Base attendue : `moodle`.

---

## 🔍 4.3. Vérification de l’utilisateur Moodle

```sql
SELECT User, Host FROM mysql.user;
```

Ligne attendue :

```
moodleuser | localhost
```

⚠️ _Problème fréquent_ : utilisateur créé avec un mauvais Host (`%`).

---

## 🔍 4.4. Vérification des privilèges

```sql
SHOW GRANTS FOR 'moodleuser'@'localhost';
```

Permissions attendues :

```
GRANT ALL PRIVILEGES ON `moodle`.*
```

⚠️ _Erreur fréquente_ : oubli du `FLUSH PRIVILEGES;`.

---

# 5. Diagnostic des fichiers et permissions

## 🔍 5.1. Vérification des droits sur Moodle

```bash
ls -ld /var/www/moodle
ls -l /var/www/moodle
```

Propriétaire attendu : `www-data`.

---

## 🔍 5.2. Vérification du dataroot

```bash
ls -ld /var/moodledata
```

Droits recommandés :

```
770 (drwxrwx---)
www-data:www-data
```

⚠️ _Piège majeur_ : `moodledata` accessible depuis le web → faille de sécurité.

---

# 6. Vérifications finales après installation Moodle

## 🔍 6.1. Navigation et installation Web

Points à vérifier :

- accès à `http(s)://MOODLE_HOST`
- absence d’erreurs PHP
- absence d’erreur "environment check"

⚠️ _Erreurs fréquentes_ : modules manquants → affichés dans l’installeur.

---

## 🔍 6.2. Vérification du cron Moodle

```bash
crontab -u www-data -l
```

Ligne attendue :

```
*/5 * * * * /usr/bin/php /var/www/moodle/admin/cli/cron.php >/dev/null 2>&1
```

⚠️ _Piège classique_ : cron non exécuté → problèmes d’envoi mail, indexing, tâches planifiées.

---

## 🔍 6.3. Vérification HTTPS (si activé)

```bash
openssl x509 -in /etc/apache2/ssl/moodle.crt -text -noout
```

Points à valider :

- CN correspond à l’URL utilisée
- validité du certificat

---

## 🔍 6.4. Purge des caches Moodle

```bash
php /var/www/moodle/admin/cli/purge_caches.php
```

Utile après :

- modification du thème
- ajout de plugins
- modification php.ini
