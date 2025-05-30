# Gestion des certificats
## 🧩 Qu’est-ce qu’un certificat numérique ?

- C’est une **“carte d’identité” numérique** d’un serveur ou d’une entité
- Il contient :
    - Le **FQDN** du serveur
    - Une **clé publique**
    - La signature de l’autorité de certification (CA)
    - Une date de validité
    - Un numéro de série unique
- Les certificats sont utilisés dans les connexions sécurisées (HTTPS, LDAPs, VPN, etc.)

### SSL/TLS

- Protocole de sécurisation des communications (SSL devenu TLS 1.3)
- Fonctionne sur la base d’une **cryptographie asymétrique** (clé publique/clé privée)

### Objectifs

|But|Détail|
|---|---|
|Confidentialité|Chiffrement des échanges|
|Intégrité|Vérification que les données n’ont pas été altérées|
|Authentification|Vérification de l’identité du serveur|

---

## 🛠️ Création de certificats autosignés

### Sous Linux (Apache)

#### Génération de la clé privée

```bash
openssl genrsa -out intra.votredomaine.eni.key 2048
```

#### Création de la demande de certificat

```bash
openssl req -new -key intra.votredomaine.eni.key -out intra.votredomaine.eni.csr
```

#### Génération du certificat autosigné

```bash
openssl x509 -req -days 120 -in intra.votredomaine.eni.csr -signkey intra.votredomaine.eni.key -out intra.votredomaine.eni.crt
```

#### Configuration dans Apache

```text
/etc/apache2/sites-available/intra.votredomaine.eni.conf
```

```apacheconf
<VirtualHost *:443>
    ServerName intra.votredomaine.eni
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/intra.votredomaine.eni.crt
    SSLCertificateKeyFile /etc/ssl/private/intra.votredomaine.eni.key
</VirtualHost>
```

---

### Sous Windows (IIS)

- IIS permet de **générer un certificat autosigné** via son interface
- **Certificat de serveur** → “Créer un certificat auto-signé”
- Liaison HTTPS :
    - FQDN : `www.votredomaine.eni`
    - Port : 443
    - Association avec le certificat dans les “Liaisons du site”

### Sous pfSense

- Accès : **System > Cert Manager**
- Création d’un **certificat autosigné**
- Activation HTTPS avec ce certificat :
    - **System > Advanced > Admin Access > HTTPS**

---

## 🔐 Limites des certificats autosignés

|Avantage|Limite|
|---|---|
|Faciles à créer|Ne sont pas “reconnus” par les navigateurs|
|Gratuits|Avertissement de sécurité (non émis par une CA de confiance)|

Utilisation conseillée :

- **Intranet**
- **Tests**
- **Infrastructure interne**

Pour un site public → utiliser un certificat signé par une autorité reconnue (ex: Let’s Encrypt).

---

## 🏛️ Infrastructure à Clé Publique (PKI)

### Qu’est-ce qu’une PKI ?

- Ensemble de services permettant :
    - La **délivrance**
    - La **gestion**
    - La **révocation** des certificats numériques

### Rôle de l’ADCS (Active Directory Certificate Services)

- Autorité de Certification (CA) interne
- Permet de générer des certificats “**de confiance**” pour l’entreprise

### Hiérarchie PKI

|Niveau|Rôle|
|---|---|
|CA Racine|Signature ultime des certificats|
|CA Subordonnée|Délivrance des certificats aux serveurs|
|Serveurs|Utilisent ces certificats (HTTPS, LDAPs, VPN, etc.)|

---

## ✅ À retenir pour les révisions

- Les **certificats numériques** permettent de garantir la **sécurité** des communications
- Un certificat autosigné n’est pas reconnu publiquement
- Une **PKI interne** (ADCS) permet de délivrer des certificats de confiance pour l’entreprise
- Le processus standard = clé privée + demande de certificat (CSR) + signature par CA
- Les certificats sont utilisés pour : HTTPS, LDAPs, VPN, authentification forte

---

## 📌 Bonnes pratiques professionnelles

- Toujours utiliser **TLS 1.3** avec des algorithmes modernes (ECDSA / RSA 2048+)
- Automatiser la **gestion du cycle de vie des certificats** (expiration, renouvellement)
- Documenter tous les certificats déployés (périmètre, FQDN, dates de validité)
- Pour les sites publics, préférer des **CA reconnues** (Let’s Encrypt, DigiCert...)
- Pour les applications internes, mettre en place une **PKI interne proprement sécurisée**
- Auditer régulièrement les certificats déployés sur le parc
- Maintenir la **chaîne de confiance** : CA racine → sous-CA → certificats finaux