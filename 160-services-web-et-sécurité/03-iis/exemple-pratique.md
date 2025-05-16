# TP – IIS : installation, multi-sites et certificat autosigné

## 🧠 Objectif

Mettre en œuvre une infrastructure **IIS fonctionnelle et sécurisée** à travers trois TP :

1. Installer IIS et tester le site par défaut
2. Créer et publier plusieurs sites web
3. Sécuriser un site avec un **certificat autosigné**

---

## 🧾 Environnement de travail

- Serveur Windows nommé `SRV-IIS`, sur le réseau LAN Serveur : `192.168.159.125`
- Répertoire personnalisé des sites : `E:\sites_web`
- Clients intégrés au domaine `nivvlem.md`
- Serveur DNS : `CD-DNS`, hébergeant la zone `nivvlem.md`

---

## 🛠️ TP 1 – Installation de IIS

### 1. Installation du rôle IIS

- Ouvrir le **Gestionnaire de serveur** > **Gérer > Ajouter des rôles et fonctionnalités**
- Choisir l’installation basée sur un rôle
- Rôle à sélectionner : **Serveur Web (IIS)**
- Accepter les fonctionnalités proposées (gestion Web, compatibilité HTTP, etc.)

### 2. Vérification

- Accéder à `http://127.0.0.1` ou `http://192.168.159.125`
- La **page par défaut IIS** doit s’afficher : logo IIS et mentions "Welcome"
- Vérifier également la présence de : `C:\inetpub\wwwroot\iisstart.htm`

---

## 🌐 TP 2 – Création et publication de plusieurs sites web

### 1. Préparation du disque et des dossiers

- Ajouter un second disque virtuel à la VM (dans Hyper-V ou VMware)
- Initialiser et formater le disque depuis `diskmgmt.msc`
- Attribuer la lettre `E:`

### 2. Création des répertoires des sites

```powershell
mkdir E:\sites_web\wwi
mkdir E:\sites_web\intranet
mkdir E:\sites_web\siteIP
```

- Créer un fichier `index.html` dans chaque dossier avec du contenu spécifique (testez l’affichage en local ensuite)

### 3. Création des sites dans IIS Manager

Ouvrir **IIS Manager > Sites > Ajouter un site Web**

#### Site 1 : wwi.nivvlem.md

- Nom : `wwi`
- Répertoire physique : `E:\sites_web\wwi`
- Liaison : IP = Toutes non attribuées, Port = 80, Nom d’hôte = `wwi.nivvlem.md`

#### Site 2 : intranet.nivvlem.md

- Nom : `intranet`
- Répertoire physique : `E:\sites_web\intranet`
- Liaison : Port 80, Hôte = `intranet.nivvlem.md`

#### Site 3 : siteIP (accès par IP uniquement)

- Nom : `siteIP`
- Répertoire : `E:\sites_web\siteIP`
- Liaison : IP = `192.168.159.124`, Port = 80, Pas de nom d’hôte

### 4. Ajout d’une IP secondaire sur la carte réseau

- `ncpa.cpl` > clic droit sur carte réseau > Propriétés > IPv4 > **Avancé** > Ajouter :
    - IP : `192.168.159.124`
    - Masque : `255.255.255.248` (ou selon plan réseau)

### 5. Configuration du DNS (CD-DNS)

- Zone : `nivvlem.md`
- Ajouter des enregistrements de type A :

```txt
wwi     A     192.168.159.125
intranet A    192.168.159.125
```

### 6. Vérification depuis un client

```cmd
ping wwi.nivvlem.md
ping intranet.nivvlem.md
```

- Navigateur (depuis un client) :
    - `http://wwi.nivvlem.md`
    - `http://intranet.nivvlem.md`
    - `http://192.168.159.124`

---

## 🔒 TP 3 – Certificat autosigné IIS

### 1. Création d’un certificat SSL autosigné

- Ouvrir **IIS Manager** > clic sur le nom du serveur (racine)
- Aller dans **Certificats de serveur**
- Cliquer sur **Créer un certificat auto-signé**
- Nom commun = `wwi.nivvlem.md`
- Stockage : **Hébergement Web**

### 2. Configuration HTTPS dans le site `wwi`

- Aller dans `Sites > wwi` > clic droit > **Modifier les liaisons**
- Ajouter une nouvelle liaison :
    - Type : `https`
    - IP : Toutes ou spécifique
    - Port : `443`
    - Certificat : `wwi.nivvlem.md`

### 3. Redémarrage d’IIS et test HTTPS

```powershell
iisreset
```

- Depuis navigateur client : `https://wwi.nivvlem.md`
- Un **avertissement de sécurité** s’affichera (certificat non reconnu)
- Accepter l’exception de sécurité pour accéder au site chiffré

---

## ✅ À retenir pour les révisions

- Chaque site IIS repose sur une **liaison (IP, port, hôte)** unique
- L’ajout d’une **IP secondaire** est indispensable si l’on veut lier un site à une IP dédiée
- La création d’un **certificat autosigné** permet de tester HTTPS en environnement contrôlé
- Le DNS doit correspondre aux noms des sites configurés dans IIS

---

## 📌 Bonnes pratiques professionnelles

- Préférer un répertoire dédié (ex : `E:\sites_web`) plutôt que `C:\inetpub`
- Ajouter une **entrée DNS par site web** dans l’AD DNS
- Nommer clairement chaque site, port, certificat et répertoire
- Documenter toutes les liaisons dans un tableau de suivi (Nom, IP, Port, SSL, Répertoire)
- Prévoir l’usage de certificats **signés (Let’s Encrypt ou AC interne)** pour un usage réel
- Redémarrer IIS via `iisreset` ou via le gestionnaire uniquement si `apache2ctl configtest` (Apache) ou journalisation ne détectent pas d’erreurs