# Sécurisation de la navigation internet
## 🧩 Rôle et fonctionnement d’un proxy

### Qu’est-ce qu’un proxy ?

- Intermédiaire entre les utilisateurs et Internet
- Filtre les requêtes **sortantes** (ex: HTTP/HTTPS)
- Applique des **règles de filtrage**
- Permet la **traçabilité** des accès (conservation des logs)
- Peut accélérer la navigation grâce à un **cache**

### Fonctionnement

```text
Client → Proxy → Internet
```

Le proxy contrôle si l’URL demandée est autorisée :

- Si oui → transmet la requête
- Si non → bloque l’accès et affiche un message

### Types de proxy

|Type|Fonctionnement|
|---|---|
|Transparent|L’utilisateur n’a pas à configurer le proxy (redirection automatique)|
|Manuel|Le proxy est configuré dans le navigateur (IP + port)|

### Obligations légales

- **Article L34-1 du Code des postes et communications électroniques** :
    - Conservation des **logs de navigation pendant 1 an**
    - Doit permettre d’identifier **qui a accédé à quoi et quand**

---

## ⚙️ Configuration de Squid Proxy sur pfSense

### Installation

- **System > Package Manager > Available Packages**
- Installer `squid`
- Installer `squidGuard` (pour le filtrage avancé)

### Configuration de Squid

**Services > Squid Proxy Server**

#### Onglet General

- `Enable Squid Proxy` : coché
- Interface : `LANCLIENT`
- Port : `3128`
- Transparent HTTP Proxy : activé (si besoin)

#### Onglet Local Cache

- Hard Disk Cache Size : 1024 Mo (ou plus)

#### Onglet ACLs

- Ajouter :
    - Réseau client autorisé
    - Domaines interdits (ex: `facebook.com`)

#### Certificat CA

- Importer le certificat CA sur les postes clients (HTTPS interception)

#### Règle de redirection HTTP

**Firewall > Rules > LAN**

- Action : Pass
- Source : LAN Net
- Destination port : HTTP → redirection vers `127.0.0.1:3128`

---

## 🛠️ Configuration de SquidGuard

### Fonctionnement

- Extension de Squid
- Filtrage par **catégories de sites** (blacklists)
- Application de **règles de contrôle d’accès**

### Installation

**Services > Proxy Filter > SquidGuard**

### Onglet General Settings

- Enable : coché
- Logs activés

### Téléchargement des blacklists

- Source recommandée : [https://dsi.ut-capitole.fr/blacklists/download/](https://dsi.ut-capitole.fr/blacklists/download/)
- Intégration : `wget` ou directement dans l’interface pfSense

### Configuration des ACLs

**Proxy Filter > SquidGuard > Common ACL**

- Règle pour **bloquer les sites adultes, gaming, astrology**
- Création d’une blacklist personnalisée `MyfirstBlackList`

### Mesures complémentaires

- **Do Not Allow IP Address in URL**
- **Use Safe Search Engine**

### Intégration avec Squid

**Services > Squid Proxy Server > General**

- Redirect Program : `/usr/local/bin/squidGuard`

### Vérification

**Status > Proxy Filter**

- Vérifier l’application des règles
- Consulter les logs

---

## 🌐 Portail captif (bonus)

### Qu’est-ce qu’un portail captif ?

- Page d’accueil obligatoire avant accès à Internet (ex: Wi-Fi public)
- Permet :
    - D’afficher des **conditions d’utilisation**
    - De demander une **authentification**
    - D’enregistrer les traces de connexion

### Configuration

**Services > Captive Portal**

#### Étape 1 : Activation

- Add → Zone : `LAN_Portal`
- Enable Captive Portal : coché
- Interface : LAN

#### Étape 2 : Paramétrage

- Durée de session : 60 min
- Reauthentification : toutes les 1 min
- Idle timeout : 15 min
- Enable logout popup

#### Étape 3 : Page personnalisée

- HTML de la page d’accueil : logo, message d’accueil

#### Étape 4 : Authentification

- Méthode : Local User Manager
- Création des utilisateurs dans **System > User Manager**

#### Étape 5 : Firewall

- Vérifier les règles permettant l’accès au portail

#### Étape 6 : Tests

- Depuis un client, vérifier l’apparition du portail captif
- Tester l’accès après authentification

---

## ✅ À retenir pour les révisions

- Le proxy permet de **filtrer les accès web** et de respecter la **réglementation**
- Squid + SquidGuard offrent un **contrôle avancé** des contenus accessibles
- Les logs doivent être **activés et conservés** 1 an
- Le portail captif est idéal pour contrôler les accès sur réseaux Wi-Fi publics

---

## 📌 Bonnes pratiques professionnelles

- **Centraliser** les listes de filtrage et les maintenir à jour
- Toujours **documenter** les ACLs mises en place
- **Vérifier régulièrement les logs** pour détecter des tentatives suspectes
- **Informer les utilisateurs** des règles de navigation
- Appliquer une politique **progressive et adaptée au contexte métier**
- Automatiser le déploiement du proxy sur les postes clients (GPO, script...)