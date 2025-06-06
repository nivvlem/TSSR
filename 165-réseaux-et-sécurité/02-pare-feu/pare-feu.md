# Le pare-feu
## 📃 Introduction au pare-feu

Un **pare-feu** (ou _firewall_) est un système de sécurité informatique qui contrôle et filtre le trafic réseau **entrant** et **sortant** selon des règles de sécurité prédéfinies.

Le pare-feu agit comme une barrière entre un réseau de confiance (interne) et un réseau non fiable (externe, typiquement Internet).

**Objectifs :**

- Protéger le réseau interne contre les attaques extérieures
- Contrôler les flux de données selon la politique de sécurité
- Appliquer le principe du **moindre privilège**

---

## 🔢 Avant de définir les règles de pare-feu

### 🔢 1. Analyser l'infrastructure réseau

- Cartographier la topologie du réseau existant
- Identifier les différents segments et zones de sécurité (LAN, DMZ, WAN, VLAN, etc.)

### 🔢 2. Schématiser

- Créer un diagramme visuel de l'architecture réseau
- Représenter les flux de données critiques (applications sensibles, services exposés)

### 🔢 3. Établir le contexte technique

- Inventorier les systèmes, applications et services utilisés
- Identifier les protocoles et ports requis

### 🔢 4. Définir la politique de sécurité

- Déterminer les **objectifs de sécurité** de l'entreprise
- Établir les règles d'accès et de restriction

### 🔢 5. Préparer la documentation

- Rédiger un document de stratégie de sécurité
- Créer des modèles de documentation pour les règles

---

## 🔧 Actions des règles de pare-feu

Chaque règle de pare-feu définit une **action** appliquée sur le trafic ciblé :

- **Permit (Allow)** : Laisse passer le trafic
- **Block (Drop)** : Bloque silencieusement le trafic
- **Reject** : Bloque le trafic et envoie un message de rejet à l'expéditeur

**Attention** : l'ordre des règles est essentiel, elles sont évaluées **de haut en bas**.

---

## 🔖 Pare-feu intégré aux OS

### Windows

- Pare-feu Windows : fonctionnalité native
- Gestion via **GUI** ou **PowerShell** / **netsh**

### Linux

- **iptables / nftables** : intégrés au noyau Linux (puissant mais complexe)
- **firewalld** : par défaut sur RedHat/CentOS
- **ufw** : par défaut sur Ubuntu, simplifié

---

## 📂 Fonctionnalités avancées des pare-feu (exemple pfSense)

### 📌 Alias

- Groupes d'objets (IP, ports, URL)
- Simplifie la gestion et la lisibilité des règles

### 📌 IPs virtuelles

- Ajouter plusieurs adresses IP sur une interface

**Types :**

- IP Alias : IPs additionnelles
- CARP : haute disponibilité (failover)
- Proxy ARP : pour IPs non directement résolues

### 📌 NAT (Network Address Translation)

- Masque les adresses internes
- Redirige les flux vers des services internes

### 📌 Plannings

- Activation / désactivation automatique des règles selon un calendrier

### 📌 Règles

- Filtres granulaires (IP, port, protocole)
- Spécifiques par interface
- Prise en compte de l'état des connexions
- Journalisation (logs)

### 📌 Régulateur de flux (QoS)

- Priorisation du trafic critique
- Gestion de la bande passante

---

## 📃 Services complémentaires du pare-feu (exemple pfSense)

|Service|Description|
|---|---|
|**DNS dynamique**|Mise à jour automatique DNS pour IPs dynamiques|
|**DNS Forwarder**|Relai DNS vers serveurs externes|
|**NTP**|Synchronisation de l'heure|
|**Portail Captif**|Authentification avant accès au réseau|
|**Proxy IGMP**|Gestion du multicast|
|**Relais DHCP/DHCPv6**|Transmission entre sous-réseaux|
|**DNS Resolver**|Serveur DNS local avec cache|
|**Sauvegarde**|Sauvegarde de la configuration|
|**Serveur DHCP**|Attribution automatique d'adresses IP|
|**SNMP**|Supervision à distance|
|**UPnP & NAT-PMP**|Ouverture automatique de ports|
|**Wake-on-LAN**|Réveil à distance des postes|

---

## ✅ À retenir pour les révisions

- Un **pare-feu** filtre le trafic **entrant et sortant** en appliquant des **règles**
- Les **règles de pare-feu** sont lues de **haut en bas** → l’ordre est essentiel
- Actions possibles : **Permit (Allow)**, **Block (Drop)**, **Reject**
- La configuration doit être basée sur une **analyse préalable des flux** et de la **politique de sécurité**
- Sur Linux : outils natifs → `iptables`, `nftables`, `ufw`
- Sur Windows : **Pare-feu Windows Defender** configurable via `netsh` ou interface graphique
- Sur pfSense : utilisation des fonctionnalités avancées → **alias**, **IPs virtuelles**, **NAT**, **plannings**, **QoS**
- Toujours vérifier les **logs** pour s’assurer du bon fonctionnement des règles appliquées

---

### 📌 Bonnes pratiques professionnelles

- Toujours **cartographier** le réseau avant de configurer le pare-feu
- Utiliser des **alias** pour maintenir des règles lisibles et évolutives
- Appliquer le principe du **moindre privilège** : bloquer par défaut, autoriser uniquement ce qui est nécessaire
- Documenter toutes les règles et flux
- Surveiller les logs pour détecter les comportements suspects
- Mettre en place des **plannings** pour les règles temporaires

---

### ⚠️ Pièges à éviter

- Ne pas oublier de définir l'ordre des règles : une règle permissive mal placée annule les suivantes
- Laisser des ports ouverts par oubli
- Ne pas tester les flux après modification des règles
- Mal utiliser les IPs virtuelles sans comprendre leur impact sur la redondance ou la publication de services

---

## ✅ Commandes utiles (exemples)

### Sous Windows

```powershell
# Ouvre l'interface graphique du pare-feu
wf.msc

# Liste les règles de pare-feu
netsh advfirewall firewall show rule name=all
```

### Sous Linux (exemple Ubuntu avec UFW)

```bash
# Activer le pare-feu
sudo ufw enable

# Lister les règles
sudo ufw status numbered

# Autoriser un port (exemple SSH)
sudo ufw allow 22/tcp

# Supprimer une règle
sudo ufw delete NUMERO
```
