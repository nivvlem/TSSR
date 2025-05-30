# Le pare-feu
## 🧩 Rôle et fonctionnement d’un pare-feu

### Définition

Un **pare-feu** est un dispositif de sécurité réseau (matériel ou logiciel) qui **filtre le trafic** entre plusieurs zones de confiance (ex: LAN, DMZ, WAN).

Il permet :

- De **contrôler les flux autorisés**
- De **bloquer les flux indésirables**
- De segmenter le réseau pour **réduire la surface d’attaque**

### Exemple typique

|Flux|Action|
|---|---|
|HTTP (TCP/80) → internet|Permit|
|ICMP → vers serveur|Reject|
|SSH (TCP/22) depuis DMZ|Permit limité|

---

## ⚙️ Étapes de mise en place d’un pare-feu

### 1️⃣ Analyse des besoins

- Inventaire des équipements
- Cartographie des services (web, mail, DNS, applicatif...)
- Identification des flux nécessaires (vers internet, entre VLANs, etc.)

### 2️⃣ Schématisation

- Création de diagrammes de flux
- Identification des **zones critiques** (LAN, DMZ, WAN)

### 3️⃣ Politique de sécurité

- Collaboration avec les responsables métiers (DSI, Direction...)
- Définition de règles de filtrage cohérentes avec les besoins
- Politique par défaut : **deny all** + ouvertures ciblées

### 4️⃣ Documentation

- Rédaction des règles de sécurité
- Documentation versionnée et régulièrement mise à jour

### 5️⃣ Mise en place technique

- Configuration des règles sur le pare-feu (pfSense, iptables, etc.)
- Test et validation des flux

---

## 🔑 Critères d’application des règles de pare-feu

### Ordre des règles

- L’ordre est **prioritaire** : les règles sont lues de haut en bas.
- Une règle **deny** en haut annule les autorisations en dessous.

### Actions possibles

|Action|Description|
|---|---|
|Permit (pass)|Autoriser le flux|
|Block|Bloquer le flux sans réponse|
|Reject|Bloquer le flux avec message d’erreur|

---

## 🏢 Séparation des flux et segmentation réseau

### Pourquoi ?

- Limiter la propagation en cas d’attaque
- Appliquer des politiques de sécurité adaptées à chaque zone

### Typiquement

|Zone|Exemple de flux|
|---|---|
|LAN → WAN|Navigation web autorisée|
|DMZ → WAN|Restreint (mise à jour OS, services publics)|
|WAN → DMZ|Entrants autorisés (site web public)|
|WAN → LAN|Strictement interdit sauf exceptions contrôlées|

---

## 🚀 Fonctionnalités avancées de pfSense

### Les alias

- Groupes d’adresses IP ou de ports
- Simplifie la lecture et la maintenance des règles
- Exemples :
    - Alias `SRVDMZ` → IP 172.20.150.200
    - Alias `Ports-LDAP` → ports 389, 636

### Les IP virtuelles

- Permet d’attribuer plusieurs adresses IP à une interface
- Exemple : haute disponibilité (CARP), multi-hébergement web

### Planning horaire (schedules)

- Active des règles à certaines heures (ex: VPN activé en heures ouvrées)

### QoS (Quality of Service)

- Priorisation de la bande passante selon les services ou les clients

### Services intégrés

|Service|Exemple d’usage|
|---|---|
|DNS Resolver / Forwarder|Fournir la résolution DNS interne|
|NTP Server|Synchronisation horaire des clients|
|Captive portal|Gestion des accès invités (ex: Wi-Fi public)|

### Paramétrages système

- Nom d’hôte personnalisé
- DNS interne cohérent
- Passerelle correctement définie

---

## ✅ À retenir pour les révisions

- Le **pare-feu** est un composant essentiel de la sécurité réseau
- La politique de filtrage doit être **documentée** et fondée sur les besoins métiers
- La **séparation des flux** réduit la surface d’attaque
- Les fonctionnalités de pfSense (alias, QoS, IP virtuelles, planning) facilitent l’administration

---

## 📌 Bonnes pratiques professionnelles

- Toujours commencer par un **deny all** par défaut
- **Documenter** chaque flux autorisé
- **Segmenter** le réseau en zones cohérentes
- Utiliser les **alias** pour simplifier la maintenance
- **Tester** systématiquement après modification des règles
- Réaliser des **revues régulières de la politique de filtrage**