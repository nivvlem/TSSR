# TP – Installation, configuration et utilisation d’Apache
## 🧩 TP1 – Installation du serveur Apache

### 🎯 Objectif

Installer le serveur web Apache sur la VM « Deb-Srv » et vérifier son bon fonctionnement localement.

### 🛠 Étapes

1. **Installation d’Apache**

```bash
sudo apt update
sudo apt install apache2
```

💡 Alternative :

```bash
sudo apt install task-web-server
```

2. **Installation du navigateur en ligne de commande Lynx**

```bash
sudo apt install lynx
```

3. **Tester l’accès au site par défaut**

```bash
lynx 127.0.0.1
lynx localhost
lynx 192.168.159.233
```

✅ La page de test Apache2 par défaut doit s’afficher ("It works!").

---

## 🧩 TP2 – Création de sites web Apache

### 🎯 Objectif

Créer 3 sites web hébergés sur la même VM Apache avec des règles d'accès spécifiques.

### 🛠 Étapes

#### 1. Créer les répertoires des sites

```bash
sudo mkdir -p /var/www/wwa.nivvlem.md
sudo mkdir -p /var/www/internet.nivvlem.md
sudo mkdir -p /var/www/site_ip
```

#### 2. Créer une page d’accueil différente pour chaque site

```bash
echo "<h1>Site wwa</h1>" | sudo tee /var/www/wwa.nivvlem.md/index.html
echo "<h1>Site internet</h1>" | sudo tee /var/www/internet.nivvlem.md/index.html
echo "<h1>Site IP</h1>" | sudo tee /var/www/site_ip/index.html
```

#### 3. Créer les fichiers de configuration dans `/etc/apache2/sites-available/`

- **wwa.nivvlem.md.conf**

```apache
<VirtualHost *:80>
  ServerName wwa.nivvlem.md
  DocumentRoot /var/www/wwa.nivvlem.md
  <Directory /var/www/wwa.nivvlem.md>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
  </Directory>
</VirtualHost>
```

- **internet.nivvlem.md.conf**

```apache
<VirtualHost *:80>
  ServerName internet.nivvlem.md
  DocumentRoot /var/www/internet.nivvlem.md
  <Directory /var/www/internet.nivvlem.md>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
  </Directory>
</VirtualHost>
```

- **site_ip.conf** (accessible par l'adresse IP)

```apache
<VirtualHost *:80>
  DocumentRoot /var/www/site_ip
  <Directory /var/www/site_ip>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
  </Directory>
</VirtualHost>
```

#### 4. Activer les sites et recharger Apache

```bash
sudo a2ensite wwa.nivvlem.md.conf
sudo a2ensite internet.nivvlem.md.conf
sudo a2ensite site_ip.conf
sudo systemctl reload apache2
```

#### 5. Tester l’accès

- Modifier le fichier `/etc/hosts` sur les clients :

```bash
192.168.159.233 wwa.nivvlem.md
192.168.159.233 internet.nivvlem.md
```

- Accéder via navigateur ou `lynx` :
    

```bash
lynx http://wwa.nivvlem.md
lynx http://internet.nivvlem.md
lynx http://192.168.159.233
```

---

## 🧩 TP3 – Mise en place d’un certificat autosigné

### 🎯 Objectif

Sécuriser l’accès au site `wwa.nivvlem.md` via HTTPS avec un certificat autosigné.

### 🛠 Étapes

#### 1. Créer les répertoires pour les certificats

```bash
sudo mkdir /etc/ssl/certs-auto
sudo mkdir /etc/ssl/reqs
```

#### 2. Générer le certificat autosigné avec OpenSSL

```bash
sudo openssl req -new -nodes -x509 \
  -keyout /etc/ssl/private/wwa.nivvlem.md.key \
  -out /etc/ssl/certs-auto/wwa.nivvlem.md.cert \
  -days 365 -newkey rsa:4096
```

Renseigner les champs demandés (pays, ville, organisation, CN = `wwa.nivvlem.md`).

#### 3. Activer le module SSL et redémarrer Apache

```bash
sudo a2enmod ssl
sudo systemctl restart apache2
```

#### 4. Créer un virtualhost HTTPS pour `wwa.domaine.tld`

```apache
<VirtualHost *:443>
  DocumentRoot /var/www/wwa.nivvlem.md
  ServerName wwa.nivvlem.md
  <Directory /var/www/wwa.nivvlem.md>
    Options MultiViews FollowSymLinks
    AllowOverride None
    Require all granted
  </Directory>
  SSLEngine on
  SSLCertificateKeyFile /etc/ssl/private/wwa.nivvlem.md.key
  SSLCertificateFile /etc/ssl/certs-auto/wwa.nivvlem.md.cert
  SSLProtocol all -SSLv3
</VirtualHost>
```

#### 5. Activer le site HTTPS et redémarrer

```bash
sudo a2ensite wwa.nivvlem.md.conf
sudo systemctl reload apache2
```

#### 6. Tester en HTTPS

```bash
lynx https://wwa.nivvlem.md
```

Navigateur : ignorer l’avertissement du certificat non reconnu.

---

## ✅ Bonnes pratiques

- Toujours tester la syntaxe Apache : `apache2ctl configtest`
- Créer des noms explicites pour les sites et les répertoires
- Sauvegarder les certificats dans un dossier clair (`/etc/ssl/certs-auto`)
- Appliquer la séparation des rôles : 1 site = 1 fichier de conf

---

## ⚠️ Pièges à éviter

- Ne pas oublier d’activer les sites avec `a2ensite`
- Vérifier les permissions des répertoires `/var/www/`
- Bien définir `ServerName` pour éviter les erreurs de nom DNS
- Ne pas oublier `a2enmod ssl` avant le VirtualHost HTTPS
