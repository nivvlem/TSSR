# Introduction aux réseaux et à la téléphonie IP

## 🧱 Le modèle OSI (Open Systems Interconnection)

### Définition

- Standard de communication proposé par l’ISO
- Organisation en **7 couches** communicantes et indépendantes

### Les 7 couches du modèle OSI

|Couches|Rôle principal|
|---|---|
|**7. Application**|Interface utilisateur / application réseau|
|**6. Présentation**|Formatage, chiffrement, compression|
|**5. Session**|Synchronisation, authentification|
|**4. Transport**|Transmission de bout en bout, segmentation (TCP/UDP)|
|**3. Réseau**|Routage, adressage logique (IPv4/IPv6)|
|**2. Liaison**|Transmission entre nœuds, contrôle d’erreurs (MAC)|
|**1. Physique**|Transmission des bits sur le support physique|

### PDU : Protocol Data Unit

- Donnée échangée à chaque couche
- Composée d’un **PCI (Protocol Control Information)** et d’un **SDU (Service Data Unit)**

---

## 📦 Encapsulation et désencapsulation

- **Encapsulation** : chaque couche ajoute ses en-têtes propres lors de l’émission
- **Désencapsulation** : chaque couche retire l’en-tête lors de la réception
- Observables via **Wireshark**

---

## 🔍 Analyse d’une trame Ethernet

### Trame Ethernet II

|Champ|Description|
|---|---|
|MAC dest / MAC source|Adressage physique|
|EtherType|Protocole de couche 3 utilisé (IP, ARP...)|
|Données|Charge utile transportée|
|CRC|Contrôle d’intégrité|

### Trame Ethernet 802.1Q (VLAN)

- Ajout de champs TPID (802.1Q), TCI (priorité, ID VLAN)
- Utilisé pour **marquage VLAN** sur réseau commuté

### Domaine de collision / broadcast

- Collision : dans un segment partagé (hub)
- Broadcast : tous les hôtes du même réseau logique

---

## 🌐 Paquet IPv4

### Champs d’un en-tête IPv4

- Version, longueur d’en-tête, TTL, protocole
- Adresse source / destination
- Options + checksum

### Adresses et sous-réseaux

- Notation CIDR : ex. `192.168.0.0/29`
- Masque : `255.255.255.248`
- Nombre d’IP valides = 2^nb_bits_hôtes – 2
- Découpage possible en plusieurs sous-réseaux plus petits

---

## 📡 Routage

### Principes

- Si l’IP de destination est sur le même réseau logique : ARP puis envoi direct
- Sinon : envoi via la **passerelle par défaut** (GW)
- Chaque routeur consulte sa table de routage
- Décrémentation du **TTL** à chaque saut

### Routage statique

- Routes définies manuellement
- Nécessite **configuration complète des routes** sur chaque routeur

### Routage dynamique

- Échanges automatiques entre routeurs
- Protocoles : **RIP, OSPF, EIGRP...**

---

## 🕸️ Architecture réseau

### Modèle hiérarchique en 3 couches

|Couche|Rôle|
|---|---|
|**Access**|Connexion des utilisateurs (PC, imprimantes…)|
|**Distribution**|Agrégation et contrôle du trafic (VLAN, ACLs)|
|**Core**|Transit rapide vers data center, WAN, internet|

> Possibilité d’inclure **réseaux redondants**, **centres de données**, **cloud**, etc.

---

## ✅ À retenir pour les révisions

- Le modèle OSI permet de **structurer la communication réseau**
- La **trame Ethernet** et le **paquet IP** sont les structures de base des données échangées
- L’**encapsulation** ajoute des en-têtes à chaque couche
- Le **routage statique** repose sur des routes manuelles et des règles précises

---

## 📌 Bonnes pratiques professionnelles

- Utiliser **Wireshark** pour analyser le comportement réseau en profondeur
- Vérifier les **masques et plans d’adressage** pour éviter les erreurs de routage
- **Segmenter le réseau** pour réduire les domaines de broadcast
- Définir un **plan de routage cohérent** (statique ou dynamique)
- Documenter les **interfaces, routes et VLANs** pour faciliter la maintenance