# Rappels de notions sur le réseau
## 🧩 Modèle OSI et couches réseau

|Couche|Nom|Exemples|
|---|---|---|
|7|Application|HTTP, FTP, SMTP|
|6|Présentation|SSL/TLS, compression|
|5|Session|API, RPC|
|4|Transport|TCP, UDP|
|3|Réseau|IP, ICMP|
|2|Liaison de données|Ethernet, VLAN|
|1|Physique|Câbles, Wi-Fi, fibre|

### Utilité du modèle OSI

- Comprendre où se situe un problème réseau
- Séparer les responsabilités : matériel, configuration, applicatif

---

## 📡 Adressage et protocoles

### Adresse MAC

- Identifiant unique d’une interface physique
- Niveau 2 (couche liaison)

### Adresse IP

- Identifiant logique d’un équipement réseau
- IPv4 : 4 octets, format **x.x.x.x**
- IPv6 : 128 bits

### Port

- Point d’entrée logique d’un service (niveau Transport)
- Port TCP 80 → HTTP, Port 443 → HTTPS

---

## 🔐 Notions de flux

### Qu’est-ce qu’un flux ?

- Une **communication entre deux entités réseau**
- Défini par :
    - Adresse IP source + port source
    - Adresse IP destination + port destination
    - Protocole utilisé (TCP, UDP, ICMP)

### Types de flux

|Type|Exemple|
|---|---|
|Flux sortant|Client → Internet (ex: HTTP vers un site)|
|Flux entrant|Internet → serveur (ex: HTTPS sur serveur web)|
|Flux interne|Entre deux machines du réseau local|

---

## 🚦 Notions de filtrage

### Pourquoi filtrer ?

- Contrôler les accès autorisés
- **Limiter la surface d’attaque**
- Optimiser l’usage de la bande passante

### Où filtrer ?

|Équipement|Exemple|
|---|---|
|Pare-feu matériel|pfSense, Fortinet|
|Pare-feu logiciel|iptables, Windows Defender Firewall|
|Commutateur (niveau 2)|ACL VLAN|

### Critères de filtrage

- **IP source/destination**
- **Port source/destination**
- **Protocole**

### Politique par défaut (best practice)

- Politique **restrictive** par défaut : _deny all_
- Ouverture uniquement des flux nécessaires

---

## 🏢 Application en entreprise

### Analyse des besoins

- Identifier les services nécessaires : web, mail, DNS, VoIP, VPN…
- Catégoriser les flux : sortants, entrants, internes
- Analyser les risques associés à chaque flux

### Exemple de flux typique

|Service|Port/protocole|Sens|
|---|---|---|
|Navigation web|TCP 80/443|Sortant|
|Messagerie|TCP 25, 587, 993|Sortant / entrant|
|DNS|UDP 53|Sortant|
|Accès VPN|UDP 1194|Entrant|

---

## ✅ À retenir pour les révisions

- Le modèle **OSI** permet de localiser les problèmes réseau
- Un **flux** est défini par IP + port + protocole
- Le **filtrage** réseau protège l’infrastructure et doit être restrictif par défaut
- Une bonne analyse des besoins est essentielle pour définir les flux autorisés

---

## 📌 Bonnes pratiques professionnelles

- Toujours **documenter les flux ouverts**
- Appliquer une **politique de moindre privilège** (seulement les flux nécessaires)
- Réaliser des **revues régulières des règles de filtrage**
- **Tracer et journaliser** les flux pour pouvoir enquêter en cas d’incident
- Prévoir un **plan de bascule** en cas de coupure réseau (redondance DNS, VPN de secours…)