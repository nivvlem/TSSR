# TP – Apache : installation, multi-sites et certificat autosigné

## 🧠 Objectif

Déployer une **infrastructure Apache fonctionnelle et sécurisée** à travers trois TP distincts :

1. Installer Apache et tester le site par défaut
2. Héberger plusieurs sites avec VirtualHost
3. Sécuriser un site par un **certificat autosigné**

---

## 🧾 Environnement de travail

- Serveur Debian nommé `DEB-SRV` (en DMZ)
- Adresse IP du serveur : `192.168.159.233`
- Adresse secondaire (pour site IP) : `192.168.159.234`
- Clients Windows ou Linux situés sur le réseau Utilisateurs

---

## 🔧 TP 1 – Installation d’Apache

### 1. Installer Apache

```bash
apt install apache2
```

### 2. Installer un navigateur en ligne de commande

```bash
apt install lynx
```

### 3. Tester l’accès local

```bash
lynx localhost
```

- Vérifier que la page Apache par défaut s’affiche
- Alternative : `lynx 127.0.0.1` ou `lynx @IP`

---

## 🌐 TP 2 – Création de trois sites web

### 1. Créer les répertoires

```bash
mkdir /var/www/wwa.nivvlem.md
mkdir /var/www/internet.nivvlem.md
mkdir /var/www/siteip.nivvlem.md
```

### 2. Créer les fichiers d’accueil (index.html)

```bash
echo "Bienvenue sur le site wwa.domaine.tld" > /var/www/wwa.nivvlem.md/index.html
echo "Bienvenue sur le site internet.domaine.tld" > /var/www/internet.nivvlem.md/index.html
echo "Bienvenue sur le site SiteIP hébergé par Apache" > /var/www/siteip.nivvlem.md/index.html
```

### 3. Créer les VirtualHost

#### `wwa.nivvlem.md`

```bash
vi /etc/apache2/sites-available/wwa.nivvlem.md.conf
```

```apache
<VirtualHost *:80>
 DocumentRoot /var/www/wwa.nivvlem.md
 ServerName wwa.nivvlem.md
 <Directory /var/www/wwa.nivvlem.md>
  Options MultiViews FollowSymlinks
  AllowOverride None
  Require all granted
 </Directory>
</VirtualHost>
```

#### `internet.nivvlem.md`

Changer le nom/répertoire dans un fichier similaire.

#### `siteip.nivvlem.md`

> Attention : VirtualHost **lié à une IP spécifique** (IP secondaire)

```apache
<VirtualHost 192.168.159.234:80>
 DocumentRoot /var/www/siteip.nivvlem.md
 ServerName siteip.nivvlem.md
 <Directory /var/www/siteip.nivvlem.md>
  Options MultiViews FollowSymlinks
  AllowOverride None
  Require all granted
 </Directory>
</VirtualHost>
```

### 4. Configurer l’IP secondaire

```bash
vim /etc/network/interfaces
```

Ajouter :

```bash
iface ens33 inet static
 address 192.168.159.234/29
```

Puis :

```bash
systemctl restart networking
ip a
```

### 5. Activer les sites

```bash
a2ensite wwa.nivvlem.md.conf
a2ensite internet.nivvlem.md.conf
a2ensite siteip.nivvlem.md.conf
systemctl reload apache2
```

### 6. DNS côté client (CD-DNS)

Ajouter dans la zone `nivvlem.md` :

- `wwa A 192.168.159.233`
- `internet A 192.168.159.233`

### 7. Vérification

```bash
ping wwa.nivvlem.md
ping internet.nivvlem.md
```

Test dans navigateur :

- `http://wwa.nivvlem.md`
- `http://internet.nivvlem.md`
- `http://192.168.159.234`

---

## 🔒 TP 3 – Certificat autosigné (site wwa.nivvlem.md)

### 1. Créer les dossiers SSL

```bash
mkdir /etc/ssl/certs-auto
mkdir /etc/ssl/reqs
```

### 2. Créer la clé + certificat autosigné (en une commande)

```bash
openssl req -new -nodes -x509 -keyout /etc/ssl/private/wwa.nivvlem.md.key -out /etc/ssl/certs-auto/wwa.nivvlem.md.cert -days 365 -newkey rsa:4096
```

- Le **Common Name** doit être : `wwa.nivvlem.md`

### 3. Activer SSL

```bash
a2enmod ssl
```

### 4. Modifier le vhost HTTPS

```bash
vi /etc/apache2/sites-available/wwa.nivvlem.md-ssl.conf
```

```apache
<VirtualHost *:443>
 DocumentRoot /var/www/wwa.nivvlem.md
 ServerName wwa.nivvlem.md
 <Directory /var/www/wwa.nivvlem.md>
  Options MultiViews FollowSymlinks
  AllowOverride None
  Require all granted
 </Directory>
 SSLEngine on
 SSLCertificateKeyFile /etc/ssl/private/wwa.nivvlem.md.key
 SSLCertificateFile /etc/ssl/certs-auto/wwa.nivvlem.md.cert
 SSLProtocol all -SSLv3
</VirtualHost>
```

### 5. Activation et test

```bash
a2ensite wwa.domaine.tld-ssl.conf
systemctl reload apache2
```

Accès navigateur : `https://wwa.nivvlem.md`

- Avertissement : certificat non reconnu, mais connexion sécurisée

---

## ✅ À retenir pour les révisions

- Apache permet l’hébergement multi-site par **VirtualHost**
- Chaque site a son propre dossier, son propre fichier `index.html`, et sa conf
- Un **site lié à une IP** nécessite l’ajout d’une IP secondaire sur l’interface
- Un certificat autosigné permet de **chiffrer les échanges**, même sans autorité publique

---

## 📌 Bonnes pratiques professionnelles

- Vérifier la configuration avec `apache2ctl configtest` avant tout redémarrage
- Tenir un **tableau de suivi des vhosts** (nom, IP, port, certificat, état activé)
- Documenter l’arborescence `/etc/apache2/sites-available` et `/var/www/`
- Utiliser des **scripts de provisioning** pour automatiser la création de sites
- Préférer en production des certificats **Let’s Encrypt** ou **internes signés**