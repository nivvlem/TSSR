# Synthèse – Réseaux & Sécurité
## 🧩 Principes fondamentaux du réseau

### Modèle OSI

- **7 couches** permettant de structurer les échanges réseau
- Aide à **localiser un problème réseau**

### Adressage

|Élément|Couches|Exemples|
|---|---|---|
|Adresse MAC|Couche 2|`00:1A:2B:3C:4D:5E`|
|Adresse IP|Couche 3|`192.168.1.10`|
|Ports|Couche 4|TCP/80, UDP/53|

### Flux réseau

- Défini par : IP source/destination + ports + protocole
- **Flux entrant / sortant / interne**

### Filtrage

- Politique par défaut : **deny all** → ouverture uniquement des flux nécessaires

---

## 🛡️ Pare-feu (pfSense)

### Rôle

- Contrôler les flux réseau entre différentes zones (LAN, DMZ, WAN)
- **Réduire la surface d’attaque**

### Configuration

- **Firewall > Rules**
- Critères : IP source/destination, ports, protocole
- **Ordre des règles important** : haut → bas

### Fonctionnalités avancées

- **Alias** : groupes d’IP ou ports pour simplifier la config
- **QoS** : gestion de la qualité de service
- **NAT** : translation d’adresses et redirection de ports

---

## 🔄 NAT (Network Address Translation)

### Objectifs

- Permettre l’accès Internet depuis des IP privées
- **Rediriger des flux entrants** (ex: accès à un serveur en DMZ)

### Types de NAT

|Type|Usage|
|---|---|
|NAT statique|Une IP publique → Une IP privée|
|NAT dynamique|Plusieurs IP privées → une IP publique|
|PAT|Translation d’adresse + ports (port forwarding)|

### pfSense

- **Firewall > NAT**
- Mode automatique / hybride / manuel pour le NAT sortant
- Redirection d’un port → service interne sécurisé

---

## 🏰 DMZ (Demilitarized Zone)

### Rôle

- Zone réseau intermédiaire **exposée à Internet**
- Hébergement des services accessibles publiquement :
    - Web, DNS, Mail, FTP…

### Règles typiques

|Flux|Politique|
|---|---|
|WAN → DMZ|NAT ciblé (port forwarding)|
|DMZ → WAN|Limité et tracé|
|DMZ → LAN|Strictement contrôlé ou interdit|

### Compléments sécurité

- **IDS/IPS**
- **EDR/XDR/MDR**
- **Zero Trust**
- **Bastion**

---

## 🌐 Sécurisation de la navigation Internet

### Proxy (Squid)

- Intermédiaire pour les requêtes HTTP/HTTPS
- Contrôle et **filtrage** des sites consultés
- Conservation des **logs de navigation** (obligation légale)

### SquidGuard

- Filtrage avancé par **catégories de sites**
- Blacklists : ex [UT Capitole](https://dsi.ut-capitole.fr/blacklists/)

### Portail captif

- Contrôle des accès sur un réseau public (Wi-Fi)
- Page d’authentification obligatoire

---

## 🔐 Gestion des certificats

### Concepts clés

- **Certificat = carte d’identité numérique**
- Chiffrement + authentification + intégrité
- PKI interne (ADCS) : délivrance de certificats de confiance en entreprise

### Usages

|Service|Exemple|
|---|---|
|HTTPS|Sites internes, DMZ|
|LDAPs|Authentification sécurisée|
|VPN|OpenVPN, WireGuard|

### Outils

- **OpenSSL** : génération manuelle de certificats (Linux)
- **ADCS** : PKI interne Microsoft
- **Cert Manager** sur pfSense

---

## 🏠 Télétravail sécurisé (VPN d’accès distant)

### OpenVPN

- Flexible, basé sur SSL/TLS
- Authentification par CA interne + LDAP/AD
- Tunnel sécurisé entre client et réseau interne

### WireGuard

- VPN moderne, très performant
- Simplicité de configuration
- Idéal pour les mobiles, postes nomades

### Points de vigilance

- Limiter les utilisateurs VPN autorisés
- Surveillance des **logs VPN**
- Mise à jour régulière des clients et protocoles

---

## 🌍 Interconnexion entre sites (VPN site à site)

### IPsec

- Tunnel chiffré entre 2 routeurs pfSense

### Phases

|Phase|Rôle|
|---|---|
|Phase 1 (IKE)|Authentification entre routeurs|
|Phase 2 (ESP)|Chiffrement des flux LAN ↔ LAN|

### Règles Firewall IPsec

- Autoriser uniquement les flux strictement nécessaires
- Surveillance active des logs et des tunnels actifs

---

## 🚦 Flux critiques à sécuriser en entreprise

|Flux|Mesure de sécurité recommandée|
|---|---|
|Administrations systèmes (SSH, RDP)|Limiter par IP, VPN, MFA|
|Services Web internes/exposés (HTTP/HTTPS)|Certificats valides, durcissement des serveurs|
|Accès base de données|Segmenter les réseaux, ACL strictes|
|Interconnexions inter-sites|VPN IPsec avec restrictions de flux|
|Flux LDAP/LDAPS|Chiffrement LDAPS uniquement|
|Accès Wi-Fi|Portail captif, segmentation VLAN|

---

## 🛠️ Audit basique de la sécurité réseau

1. Vérification des politiques de firewall → deny all par défaut
2. Revue des NAT et redirections de ports → limiter la surface d’exposition
3. Vérification des VPN (actifs, utilisateurs, logs)
4. Contrôle de l’expiration des certificats
5. Analyse des logs IDS/IPS → détection des comportements anormaux
6. Vérification de la segmentation des flux (DMZ, LAN, VPN)

---

## ✅ À retenir pour les révisions

- **Politiques de filtrage** : deny all par défaut, ouverture justifiée
- **Segmentation réseau** : LAN / DMZ / WAN / VPN
- **Proxy** : sécurisation de la navigation, conformité légale
- **Certificats** : élément central de la confiance numérique
- **VPN** : indispensable pour le télétravail et la communication inter-sites
- **Flux critiques** : bien les identifier et les surveiller en continu
- **Audit régulier** : indispensable pour maintenir le niveau de sécurité

---

## 📌 Bonnes pratiques professionnelles

- **Documenter systématiquement** les flux et règles configurées
- Réaliser des **revues régulières** de la configuration sécurité
- **Superviser activement** : IDS/IPS, logs VPN, logs proxy
- **Automatiser** les tâches récurrentes (renouvellement de certificats, génération de clés)
- Sensibiliser les utilisateurs à la sécurité (phishing, politique mot de passe, bonnes pratiques VPN)
- Tester régulièrement le plan de réponse à incident
- Maintenir à jour le pare-feu, les IDS/IPS, les composants VPN et proxy

---

## Commandes utiles

```bash
# Test DNS
nslookup www.google.com

# Test HTTPS avec certificat
openssl s_client -connect www.votredomaine.eni:443

# Test de flux ouvert
nmap -p 443 192.168.1.10

# Vérifier l’état du tunnel IPsec
cat /var/log/ipsec.log

# Vérifier les logs proxy
cat /var/squid/logs/access.log

# Vérification du VPN WireGuard
wg show

# Vérification des connexions OpenVPN
cat /var/log/openvpn.log

# Vérification IDS (ex Suricata)
cat /var/log/suricata/fast.log

# Liste des états de connexion firewall (pfSense)
pfctl -ss
```
