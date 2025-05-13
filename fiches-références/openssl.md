# OpenSSL (certificats SSL/TLS)

## 📌 Présentation

OpenSSL est une boîte à outils en ligne de commande permettant de gérer les certificats numériques (X.509), les clés privées/publiques, les CSR (Certificate Signing Requests) et bien plus. C’est un outil indispensable pour sécuriser les communications sur le web (HTTPS), les VPN ou les serveurs mail.

---

## 🔧 Commandes utiles

### 🔐 Génération d'une clé privée

```bash
openssl genrsa -out serveur.key 2048
```
- `2048` : taille en bits de la clé (souvent 2048 ou 4096)


### 📝 Génération d’une CSR (demande de signature de certificat)

```bash
openssl req -new -key serveur.key -out serveur.csr
```
- Utilisée pour soumettre une demande à une autorité de certification (CA)


### 🏢 Création d’un certificat auto-signé (pour tests)

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout serveur.key -out serveur.crt
```
- `-x509` : génère un certificat sans CA externe
- `-nodes` : sans mot de passe sur la clé privée (non recommandé en prod)


### 🔍 Affichage d’un certificat

```bash
openssl x509 -in serveur.crt -noout -text
```


### 📁 Conversion de formats

| Commande | Description |
|---------|-------------|
| `openssl pkcs12 -export` | Convertit `.crt + .key` en `.p12` (PKCS#12) |
| `openssl x509 -in cert.der -inform der -out cert.pem -outform pem` | Convertit DER → PEM |


### 🔐 Comparaison de hachage (pour vérifier intégrité)

```bash
openssl dgst -sha256 fichier.txt
```

---

## 🔎 Cas d’usage courant

- Créer un certificat auto-signé pour serveur web (Apache, Nginx)
- Générer des certificats pour OpenVPN ou serveur mail
- Vérifier les informations ou la validité d’un certificat (date, sujet, usage)
- Préparer une CSR pour Let’s Encrypt ou une autorité interne

---

## ⚠️ Erreurs fréquentes

- Oublier d’indiquer les bons champs dans le CSR (`CN`, `SAN`, etc.)
- Mot de passe oublié sur une clé privée sans sauvegarde
- Générer des certificats auto-signés pour de la production (non reconnus)
- Oublier d’adapter la date d’expiration (`-days`) à l’usage

---

## ✅ Bonnes pratiques

- Protéger les fichiers `.key` (droits restreints : `chmod 600`)
- Toujours générer une CSR pour les certificats en production
- Stocker séparément les certificats, clés et CSR
- Sauvegarder les clés privées dans un coffre sécurisé
- Vérifier la validité du certificat avant déploiement

---

## 📚 Ressources complémentaires

- [Documentation OpenSSL](https://www.openssl.org/docs/)
- `man openssl`, `man req`, `man x509`
- [Cheat sheet OpenSSL](https://www.sslshopper.com/article-most-common-openssl-commands.html)
