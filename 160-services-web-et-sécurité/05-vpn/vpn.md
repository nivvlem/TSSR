# Installation et gestion d’un VPN (avec pfSense)
## 🔐 Qu’est-ce qu’un VPN ?

- Un **VPN** est un **tunnel chiffré** qui garantit la **confidentialité** des données
- Deux cas d’usage principaux :
    - **VPN site à site** : relie deux sites distants via tunnel IPSec
    - **VPN nomade** : permet à un utilisateur distant d'accéder aux ressources internes de l'entreprise

---

## 📶 Protocoles VPN

### PPTP (Point to Point Tunneling Protocol)

- Port : TCP 1723
- Authentification simple (mot de passe)
- Obsolète, non recommandé (failles connues)

### SSL (via OpenVPN)

- Port : TCP ou UDP 443
- Fonctionne sur la couche session
- Aucun logiciel tiers requis, client via navigateur ou export OpenVPN

### L2TP / IPSec

- Ports : UDP 1701 (L2TP), UDP 500 et ESP 50 (IPSec)
- Double encapsulation, couche 2 et 3 du modèle OSI
- Peut être bloqué sur certains réseaux publics

---

## 🔧 Paramétrage VPN nomade dans pfSense (OpenVPN)

### Préparation : création d’une autorité de certification (AC)

- **Système > Cert. Manager > Authorities** > Ajouter
- Remplir les champs : Nom, durée, algorithmes, pays, etc.

### Configuration LDAP (connexion à l’AD)

- **Système > Gestionnaire d’utilisateurs > Serveurs d’authentification** > Ajouter
- Type : LDAP
- Adresse IP du contrôleur de domaine (AD)
- Port : 389 (LDAP standard)
- Base DN : `dc=domaine,dc=tld`
- Liaison : utiliser un compte avec lecture sur AD (DN + mot de passe)
- Attributs :
    - Utilisateur : `sAMAccountName`
    - Groupe : `cn`
    - Membres : `memberOf`

### Test LDAP

- **Diagnostics > Authentification**
- Choisir le serveur, entrer un utilisateur + mot de passe
- Si le test passe : configuration LDAP valide

### Paramétrage DNS dans pfSense

- **Système > Configuration générale**
    - Nom de domaine : `domaine.tld`
    - DNS : IP du serveur AD-DNS (ex : `192.168.159.121`)
    - Décocher : "Utiliser les serveurs DNS fournis par le FAI"

### Assistant OpenVPN (mode nomade)

- **VPN > OpenVPN > Assistants** > Lancer l’assistant
- Choix du backend : **LDAP**
- Choisir l’AC créée précédemment
- Générer un **certificat serveur**
- Interface : WAN / Protocole : UDP ou TCP / Port : 1194 ou 443

### Paramètres OpenVPN

- Tunnel : `10.0.8.0/24`
- Local Network : `192.168.159.0/24` (réseau LAN interne)
- Cocher : **Rediriger la passerelle par défaut** (tout le trafic passe dans le VPN)
- Authentification des clients : via LDAP
- Topologie : **Subnet**
- DNS : spécifier IP AD-DNS + serveur de temps WINS si souhaité

### Règles Firewall

- **Interface WAN** : autoriser les connexions entrantes sur le port VPN
- **Interface OpenVPN** : autoriser trafic vers LAN

---

## 🔐 Aspects sécurité

### Certificats et authentification

- AC interne permet de générer les certificats client/serveur
- Possibilité d’ajouter **double authentification** : certificat + LDAP

---

## ✅ À retenir pour les révisions

- Le VPN **crée un tunnel sécurisé** permettant l’accès distant comme en local
- OpenVPN est largement préféré pour sa **souplesse, sécurité et compatibilité**
- pfSense permet une **intégration LDAP/AD** et une gestion centralisée des accès
- Le mode "redirect gateway" permet de **forcer tout le trafic** via le tunnel

---

## 📌 Bonnes pratiques professionnelles

- Ne pas utiliser PPTP en production (protocole vulnérable)
- Limiter les accès VPN aux **groupes utilisateurs AD dédiés**
- **Documenter toutes les configurations LDAP, AC et VPN** (ports, IP, certificats)
- Surveiller les connexions VPN via les logs pfSense
- Automatiser la distribution des profils OpenVPN (export depuis pfSense)
- Régénérer périodiquement les **certificats client**
- Tester le VPN depuis **réseaux externes simulés** (mode hotspot/public)