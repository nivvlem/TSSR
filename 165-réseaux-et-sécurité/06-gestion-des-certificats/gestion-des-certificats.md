# La gestion des certificats
## 📃 Introduction aux certificats

Les **certificats numériques** sont des documents électroniques garantissant l'identité d'une entité et la sécurité des échanges.

Ils permettent de :

- Authentifier un serveur ou un utilisateur
- Assurer la **confidentialité** des communications
- Garantir l'**intégrité** des données

Ils sont utilisés dans de nombreux cas : **HTTPS**, **VPN**, **email chiffré**, **authentification**.

---

## 🛠️ Fonctionnement des serveurs Web (Apache / IIS)

- Les serveurs Web (**Apache**, **Nginx**, **IIS**) permettent l'hébergement de sites Web accessibles en HTTP/HTTPS.
- Modes d'accès à un site :
    - Par port
    - Par adresse IP
    - Par FQDN (Fully Qualified Domain Name)

### Rôle des certificats sur un serveur Web

- Permet d'utiliser **HTTPS** (chiffrement TLS)
- Assure aux clients qu'ils communiquent avec le bon serveur

---

## 🔢 Qu'est-ce qu'un certificat numérique ?

### Contenu typique :

- Numéro de série unique
- Autorité de certification (CA)
- Durée de validité
- Nom du titulaire
- Clé publique
- Algorithmes de chiffrement et de signature

### Protocoles associés :

- **SSL/TLS** (couche entre Transport et Application)
- HTTPS : port **443**
- Autres usages : SMTPS (465), IMAPS (993), LDAPS (636), VPN

---

## 🔄 SSL / TLS : évolution et bonnes pratiques

|Version|État|
|---|---|
|SSL 2.0 / 3.0|Obsolète|
|TLS 1.0 / 1.1|Obsolète|
|TLS 1.2|Recommandé|
|TLS 1.3|Recommandé (dernier standard)|

### Objectifs :

- **Authentification** du serveur/client
- **Confidentialité** des échanges
- **Intégrité** des données

### Algorithmes utilisés :

|Algo|Utilisation|Taille de clé|
|---|---|---|
|RSA|Chiffrement / signature|2048 / 4096 bits|
|DSA|Signature|Jusqu'à 3072 bits|
|ECDSA|Signature|256 bits (sécurité équivalente à RSA 3072)|
|ED25519|Signature|256 bits|

### Algorithmes de hachage :

|Algo|Statut|
|---|---|
|SHA-1|Obsolète|
|SHA-256|Recommandé|
|SHA-3|Très sûr|
|MD5|Obsolète|

---

## 🛡️ Obtention d'un certificat

3 méthodes principales :

1. **Certificat auto-signé** (pour usage interne / tests)
2. **CA interne** (PKI d'entreprise)
3. **CA publique** (Let's Encrypt, DigiCert, GlobalSign...)

---

## 🔒 Certificat auto-signé sous Linux (OpenSSL)

### Commandes clés :

```bash
# Génération de la clé privée
openssl genrsa -out private_key.pem 2048

# Création du certificat auto-signé
openssl req -new -x509 -key private_key.pem -out certificate.pem -days 365

# Test de la connexion SSL/TLS
openssl s_client -connect monsite.local:443
```

### Fichier de config : `default-ssl.conf`

Sections importantes :

- `<VirtualHost *:443>`
- `SSLEngine on`
- `SSLCertificateFile`
- `SSLCertificateKeyFile`

---

## 🛠️ Intégration PKI

### PKI interne (AD CS)

- **PKI** : Infrastructure à Clé Publique
- Sous Windows Server : **AD CS (Active Directory Certificate Services)**

### Hiérarchie :

|Niveau|Rôle|
|---|---|
|CA racine|Ancre de confiance|
|CA subordonnée|Délivre les certificats|
|Certificats finaux|Sur serveurs / postes / équipements|

### Modèles de certificats

- Duplicables et personnalisables
- Exemples : certificat serveur Web, authentification, signature de code

### Interface Web :

- `http://@IPduADCS/certsrv`
- Permet de demander un certificat en ligne

---

## 🛡️ Intégration PKI avec :

### IIS (Windows)

- Création et demande via **Gestionnaire IIS**
- Association du certificat au site sur port **443**

### Apache (Linux)

- Génération de la demande (CSR)
- Dépôt sur `certsrv`
- Récupération du certificat et déploiement
- Reload d'Apache

### pfSense

- Intégration d'un **CA** dans pfSense
- Création d'une demande de certificat (CSR)
- Dépôt sur `certsrv`, récupération du certificat
- Association dans pfSense pour l'administration HTTPS

---

## ✅ À retenir pour les révisions

- Un **certificat numérique** permet de garantir l’**identité** d’un serveur et de chiffrer les communications (HTTPS, VPN, etc.)
- Un certificat contient : **clé publique**, **autorité de certification (CA)**, **durée de validité**, **algorithmes** utilisés
- SSL est obsolète → utiliser **TLS 1.2** ou **TLS 1.3**
- Les **certificats auto-signés** servent pour les tests ou les usages internes, mais ne doivent pas être utilisés en production
- Une **PKI (Public Key Infrastructure)** permet de gérer les certificats en entreprise
    - Sous Windows : **AD CS (Active Directory Certificate Services)**
- L’intégration des certificats se fait sur :
    - **IIS** (Windows Server)
    - **Apache** (Linux)
    - **pfSense** (pour l’administration sécurisée)
- Il est essentiel de :
    - Suivre les **dates d’expiration** des certificats
    - Maintenir une **chaîne de confiance** complète
    - Automatiser le **renouvellement** lorsque possible (ex : Let's Encrypt)

---

## 📌 Bonnes pratiques professionnelles

- **Privilégier TLS 1.3 ou 1.2**
- **Abandonner SSL et TLS < 1.2**
- Utiliser des certificats signés par une autorité reconnue en production
- Mettre en place une PKI interne bien configurée
- Suivre les **dates d'expiration** des certificats
- Automatiser le déploiement et le renouvellement (ex : Let's Encrypt)

---

## ⚠️ Pièges à éviter

- Laisser en place un certificat auto-signé en production
- Utiliser des versions obsolètes de SSL/TLS
- Oublier de déployer la chaîne de confiance (intermédiaires)
- Ne pas tester la validité des certificats
- Configurer un serveur sans renouvellement automatique des certificats

---

## ✅ Commandes utiles (diagnostic certificats)

```bash
# Afficher les détails d'un certificat
openssl x509 -in certificate.pem -text -noout

# Tester la connexion SSL/TLS d'un site
openssl s_client -connect monsite.local:443

# Vérifier la chaîne de confiance
openssl verify -CAfile ca_bundle.pem certificate.pem
```
