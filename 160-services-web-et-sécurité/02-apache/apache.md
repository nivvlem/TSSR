# Installation, configuration et utilisation d’Apache
## 🔧 Installation d’Apache2 sous Debian/Ubuntu

### Installation

```bash
sudo apt update && sudo apt install apache2 -y
```

### Vérification

- Naviguer vers `http://localhost` ou `http://@IP` sur le serveur
- Vérifier que la **page par défaut** Apache s’affiche

---

## 📂 Structure des répertoires Apache

|Répertoire / Fichier|Rôle|
|---|---|
|`/etc/apache2/apache2.conf`|Fichier principal de configuration|
|`/etc/apache2/ports.conf`|Ports d’écoute définis (80/443)|
|`/etc/apache2/sites-available`|Config des vhosts (fichiers _.conf_)|
|`/etc/apache2/sites-enabled`|Liens symboliques des vhosts activés|
|`/etc/apache2/mods-available`|Modules Apache disponibles|
|`/etc/apache2/mods-enabled`|Modules actifs (liens symboliques)|
|`/etc/apache2/conf-available`|Configs additionnelles disponibles|
|`/etc/apache2/conf-enabled`|Configs activées au lancement|
|`/var/www/`|Répertoire par défaut des fichiers web|

---

## 🧠 Fichiers et directives importantes

### `DirectoryIndex`

- Définit les fichiers d’index à charger automatiquement
- Fichier : `/etc/apache2/mods-enabled/dir.conf`

### `Listen`

- Définit les ports et interfaces d’écoute dans `ports.conf`

```apache
Listen 80
Listen 443
Listen 192.168.1.10:80
```

---

## 🛠️ Commandes de gestion du service

### Systemd

```bash
sudo systemctl start|stop|restart|status|enable|disable apache2
```

### apache2ctl

```bash
apache2ctl start|stop|restart|graceful|status|configtest|-S|-l
```

- `graceful` = redémarrage sans couper les connexions en cours
- `configtest` = vérification syntaxique des fichiers de configuration
- `-S` = affiche les vhosts actifs
- `-l` = liste les modules statiquement compilés

---

## 🌐 Hébergement de sites multiples (VirtualHost)

### Répertoire par site

```bash
sudo mkdir -p /var/www/www.tssr.lcl
```

### Création du fichier de configuration

```bash
sudo nano /etc/apache2/sites-available/www.tssr.lcl.conf
```

```apache
<VirtualHost *:80>
    DocumentRoot /var/www/www.tssr.lcl
    ServerName www.tssr.lcl

    <Directory /var/www/www.tssr.lcl>
        Options Indexes FollowSymlinks
        AllowOverride None
        Require all granted
    </Directory>
</VirtualHost>
```

### Activation du site

```bash
a2ensite www.tssr.lcl.conf
systemctl reload apache2
```

---

## 🔐 Gestion des accès : directives `Require`

### Simples

```apache
Require all granted      # autorise tous les accès
Require all denied       # bloque tous les accès
Require ip 192.168.1     # autorise ce sous-réseau
Require host tssr.lcl    # autorise les machines de ce domaine
```

### Combinées

```apache
<RequireAll>
    Require ip 192.168.1
    Require not ip 192.168.1.200
</RequireAll>

<RequireAny>
    Require ip 192.168.1
    Require ip 192.168.2
</RequireAny>
```

---

## 🔒 Modules et activation

### Activer ou désactiver des modules

```bash
a2enmod rewrite
systemctl reload apache2
```

- Modules utiles : `ssl`, `rewrite`, `headers`, `status`

---

## 📜 Création d’un certificat SSL autosigné

### Préparation des dossiers

```bash
mkdir -p /etc/ssl/{private,certs-auto,reqs}
```

### Génération de la clé privée

```bash
openssl genrsa -des3 -out /etc/ssl/private/www.tssr.lcl.key 2048
```

### Demande de certificat (CSR)

```bash
openssl req -new -key /etc/ssl/private/www.tssr.lcl.key -out /etc/ssl/reqs/www.tssr.lcl.csr
```

### Génération du certificat autosigné

```bash
openssl x509 -req -days 90 -in /etc/ssl/reqs/www.tssr.lcl.csr -signkey /etc/ssl/private/www.tssr.lcl.key -out /etc/ssl/certs-auto/www.tssr.lcl.crt
```

### Intégration HTTPS dans le vhost

```apache
<VirtualHost *:443>
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs-auto/www.tssr.lcl.crt
    SSLCertificateKeyFile /etc/ssl/private/www.tssr.lcl.key
    DocumentRoot /var/www/www.tssr.lcl
    ServerName www.tssr.lcl
</VirtualHost>
```

```bash
a2enmod ssl
a2ensite default-ssl.conf
systemctl reload apache2
```

---

## ✅ À retenir pour les révisions

- `apache2.conf`, `ports.conf`, `sites-available/`, `mods-enabled/` = structure clé
- Utiliser `apache2ctl configtest` avant tout redémarrage
- Les **vhosts** permettent l’hébergement multi-sites
- `Require` gère les **accès** (par IP, domaine…)
- La gestion SSL implique : clé privée, CSR, certificat, activation du module

---

## 📌 Bonnes pratiques professionnelles

- Toujours **vérifier la syntaxe** avant de recharger Apache
- **Séparer les sites** dans des vhosts individuels
- Restreindre les accès avec `Require`, **ne pas tout autoriser par défaut**
- Favoriser l’usage de certificats **Let’s Encrypt** ou internes
- Documenter toute création de site dans `/etc/apache2/sites-available`
- Activer uniquement les **modules nécessaires**, désactiver les autres
- Mettre en place une supervision (mod_status, journalisation, fail2ban si nécessaire)