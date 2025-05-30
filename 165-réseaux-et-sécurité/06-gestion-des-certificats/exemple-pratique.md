# 🛡️ TP - La gestion des certificats autosignés
## 🛠️ Étape 1 — Sur **SRV-MBR** (Windows Server / IIS)
### 🔸 1.1 — Ajout d’une seconde IP

✅ Ajouter l’adresse **172.20.200.153/26** sur l’interface Ethernet0.

---

### 🔸 1.2 — Installation du rôle **IIS**

1️⃣ Ouvrir le **Server Manager**.  
2️⃣ Ajouter le rôle **Web Server (IIS)**.

---

### 🔸 1.3 — Création de 2 sites

| Site   | IP               | Port | URL                           |
| ------ | ---------------- | ---- | ----------------------------- |
| Site 1 | IP principale    | 80   | `http://www.nivvlem.eni`      |
| Site 2 | `172.20.200.153` | 80   | `http://intranet.nivvlem.eni` |

---

### 🔸 1.4 — Test d’accès aux sites

✅ Depuis les clients, tester l’accès aux sites via navigateur.

---

### 🔸 1.5 — Création d’un **certificat autosigné**

1️⃣ Aller dans **IIS Manager** → Server Certificates.  
2️⃣ Créer un **Self-Signed Certificate**.  
3️⃣ Associer le certificat aux 2 sites :

- Modifier le **binding** → HTTPS → choisir le certificat.

---

### 🔸 1.6 — Vérification

✅ Depuis les clients :

- Accéder en `https://www.nivvlem.eni`
- Accéder en `https://intranet.nivvlem.eni`  
    ✅ Vérifier le chiffrement des communications.

---

## 🛠️ Étape 2 — Sur **SRV-WEB** (Linux / Apache)
### 🔸 2.1 — Ajout d’une IP supplémentaire

✅ Ajouter l’IP `172.20.200.202/26` à l’interface **ens33**.

---

### 🔸 2.2 — Installation d’Apache

```bash
sudo apt update 
sudo apt install apache2 -y
```

---

### 🔸 2.3 — Installation de **lynx** (navigateur en ligne de commande)

```bash
sudo apt install lynx -y
```

---

### 🔸 2.4 — Création de 2 sites Apache

| Site   | IP                  | URL                           |
| ------ | ------------------- | ----------------------------- |
| Site 1 | N’importe quelle IP | `http://intra.nivvlem.eni`    |
| Site 2 | `172.20.200.202`    | `http://internet.nivvlem.eni` |

---

### 🔸 2.5 — Création de **certificats autosignés** sous Linux

```bash
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/votre_site.key -out /etc/ssl/certs/votre_site.crt
```

---

### 🔸 2.6 — Configuration des sites pour HTTPS

✅ Modifier les fichiers de config Apache :  
`/etc/apache2/sites-available/votre_site.conf`

👉 Activer HTTPS avec les chemins des certificats.

---

### 🔸 2.7 — Vérification avec lynx et depuis clients

```bash
lynx https://intra.nivvlem.eni
lynx https://internet.nivvlem.eni
```

---

## 🛠️ Étape 3 — Sur **pfSense**
### 🔸 3.1 — Sécurisation de l’interface pfSense

1️⃣ Aller dans **System > Cert. Manager > Certificates**.  
2️⃣ Créer ou utiliser un certificat autosigné pour pfSense.  
3️⃣ Associer le certificat à l’interface Web :

- **System > Advanced > Admin Access > SSL Certificate** → choisir le certificat.

---

### 🔸 3.2 — Enregistrement DNS

✅ Créer un enregistrement DNS sur SRV-CD :  
`routeur.nivvlem.eni` pointant vers l’IP LAN de pfSense.

---

### 🔸 3.3 — Vérification

✅ Accéder à :  
`https://routeur.nivvlem.eni`

---

## ✅ Bonnes pratiques

- Les **certificats autosignés** servent pour des tests ou des environnements internes.
- En production, préférer des **certificats émis par une autorité de certification (CA)**.
- Toujours vérifier :
    - Date de validité.
    - Usage du certificat (serveur web, client…).
    - Chaîne de certification (trusted root CA).

---

## ⚠️ Pièges courants

- Oublier de configurer le **binding HTTPS**.
- Ne pas créer les bons enregistrements DNS → erreurs de nom commun.
- Oublier d’ajouter les **exceptions** de sécurité dans les navigateurs.

---
---

# 🛡️ TP - Certificats émanant d’une Private-KI (PKI ADCS)
## 🛠️ Étape 1 — Mise en place de la PKI sur SRV-CD
### 🔸 1.1 — Installation du rôle ADCS

1️⃣ Connectez-vous sur **SRV-CD**.  
2️⃣ Ouvrez **Server Manager** → "Manage" → "Add Roles and Features".  
3️⃣ Ajouter le rôle :  
✅ **Active Directory Certificate Services (ADCS)**.  
4️⃣ Valider les prérequis → Suivre l’assistant.  
5️⃣ Choisir les services à installer :

- **Certification Authority (CA)**
- (Optionnel : Certification Authority Web Enrollment)

6️⃣ Finaliser l’installation.

---

### 🔸 1.2 — Configuration de la CA

1️⃣ Après l’installation → cliquer sur **Configure Active Directory Certificate Services**.  
2️⃣ Choisir :

- **Certification Authority**.  
    3️⃣ Type de CA :
- **Enterprise CA**.  
    4️⃣ Type :
- **Root CA** (autorité racine).  
    5️⃣ Génération d’une nouvelle clé privée :
- Algorithme par défaut (RSA 2048 ou plus).  
    6️⃣ Remplir les informations du certificat CA (Common Name = `CA-votrenom.eni`).  
    7️⃣ Valider la configuration.

---

### 🔸 1.3 — Vérification du site **certsrv**

1️⃣ Ouvrir **IIS Manager** → vérifier que le site **certsrv** est présent.  
2️⃣ Accéder depuis un client interne :  
`http://srv-cd/certsrv`

✅ Vérifier que le site fonctionne.  
✅ **Le cadenas HTTPS est requis → passer au point suivant**.

---

### 🔸 1.4 — Sécuriser le site **certsrv** en HTTPS

1️⃣ Créer un certificat pour `srv-cd`.  
2️⃣ Associer ce certificat au binding HTTPS du site **certsrv**.  
3️⃣ Tester depuis les clients :  
`https://srv-cd/certsrv`  
→ ✅ Le cadenas doit être présent.

---

## 🛠️ Étape 2 — Génération et déploiement de certificats sur les serveurs
### 🔸 2.1 — Sur SRV-MBR (IIS)
#### a) Préparation

1️⃣ Connectez-vous à **SRV-MBR**.  
2️⃣ Ouvrez **IIS Manager**.  
3️⃣ Créez un **Certificate Signing Request (CSR)** pour le site :  
`www.votrenom.eni`.

---

#### b) Génération du CSR

1️⃣ Aller dans **Server Certificates** → "Create Certificate Request".  
2️⃣ Renseigner :

- Common Name : `www.nivvlem.eni`
- Organization, Unit, Locality : vos infos
- Key Size : **2048 bits** ou plus.

3️⃣ Sauvegarder le CSR (`nivvlem.csr`).

---

#### c) Soumission à la CA

1️⃣ Aller sur `https://srv-cd/certsrv`.  
2️⃣ "Request a Certificate" → "Advanced Certificate Request".  
3️⃣ Copier le contenu du CSR.  
4️⃣ Valider la demande.

---

#### d) Récupération du certificat

1️⃣ Une fois la demande approuvée → télécharger le certificat au format **Base64**.  
2️⃣ Installer le certificat dans **IIS** (Server Certificates → "Complete Certificate Request").  
3️⃣ Associer le certificat HTTPS au site `www.nivvlem.eni`.

---

#### e) Vérification

✅ Tester depuis un client :  
`https://www.nivvlem.eni`  
✅ Vérifier le **cadenas** et la **chaîne de certification**.

---

### 🔸 2.2 — Sur SRV-WEB (Apache)
#### a) Génération du CSR

Sur SRV-WEB :

```bash
openssl req -new -newkey rsa:2048 -nodes -keyout extranet.key -out extranet.csr
```

---

#### b) Soumission du CSR

1️⃣ Copier le contenu de `extranet.csr`.  
2️⃣ Aller sur `https://srv-cd/certsrv`.  
3️⃣ Soumettre une demande avancée.

---

#### c) Récupération et installation

1️⃣ Télécharger le certificat signé en **Base64**.  
2️⃣ Copier sur SRV-WEB.  
3️⃣ Modifier la config Apache :

```bash
SSLEngine on SSLCertificateFile /etc/ssl/certs/extranet.crt
SSLCertificateKeyFile /etc/ssl/private/extranet.key
SSLCertificateChainFile /etc/ssl/certs/ca-chain.crt
```

---

#### d) Vérification

✅ Tester :  
`https://extranet.nivvlem.eni`

---

### 🔸 2.3 — Sur pfSense
#### a) Génération du CSR

1️⃣ Aller dans **System > Cert. Manager > Certificates**.  
2️⃣ "Add" → "Create a Certificate Signing Request".  
3️⃣ Common Name : `routeur.nivvlem.eni`.

---

#### b) Soumission à la CA

1️⃣ Télécharger le CSR.  
2️⃣ Soumettre à `https://srv-cd/certsrv`.  
3️⃣ Télécharger le certificat signé.

---

#### c) Installation du certificat

1️⃣ Importer le certificat signé dans pfSense → **Cert. Manager**.  
2️⃣ Associer ce certificat à l’interface Web :

- **System > Advanced > Admin Access**.

---

#### d) Vérification

✅ Tester :  
`https://routeur.nivvlem.eni`  
✅ Vérifier le **cadenas**.

---

## ✅ Bonnes pratiques

- Ne jamais utiliser de **certificats autosignés** en production.
- La **PKI privée** permet de :
    - Centraliser la gestion des certificats.
    - Automatiser le déploiement avec GPO.
    - Gérer les révocations (CRL).

---

## ⚠️ Pièges courants

- Ne pas installer la **chaîne de certification** sur les clients.
- Oublier de définir le **nom commun (CN)** correct lors de la CSR.
- Mal associer le certificat dans les services (IIS, Apache, pfSense).