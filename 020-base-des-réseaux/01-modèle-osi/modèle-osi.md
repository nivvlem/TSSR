# 🌐 Le modèle OSI

## 🧱 Présentation du modèle OSI

### Définition

- **OSI** (Open System Interconnection) : modèle en 7 couches proposé par l’ISO
- Décrit **la communication entre systèmes interconnectés**
- Chaque couche **assure un rôle précis** et s’appuie sur la couche inférieure

### Vocabulaire associé

- **Protocole** : règles de communication entre équipements
- **PDU** (Protocol Data Unit) : unité de données au niveau de chaque couche
- **SDU** : données reçues de la couche supérieure
- **PCI** : informations de contrôle liées au protocole

---

## 🧬 Les 7 couches du modèle OSI

|Couche|Rôle principal|
|---|---|
|7. **Application**|Interface avec les logiciels (navigateur, client mail…)|
|6. **Présentation**|Formatage, chiffrement, compression|
|5. **Session**|Synchronisation, gestion des échanges|
|4. **Transport**|Transmission fiable ou non (TCP/UDP), segmentation|
|3. **Réseau**|Routage, adresses IP|
|2. **Liaison**|Adressage MAC, contrôle d’erreurs|
|1. **Physique**|Transmission des bits (câble, signal, modulation)|

### Encapsulation / Désencapsulation

- Chaque couche **ajoute** ses propres entêtes (encapsulation à l’envoi)
- À la réception, ces entêtes sont **retirés** (désencapsulation)

### Analogie

- Comme un **colis postal** : l’expéditeur emballe couche par couche, le destinataire déballe

---

## 📶 Détails par couche

### Couche 1 – Physique

- Support physique : **paire torsadée, fibre optique**
- Connectique, modulation des signaux
- Normes de câblage (ex : 568A/568B)

### Couche 2 – Liaison

- Adressage **MAC**, **contrôle d’erreurs CRC**
- Protocoles : ARP, DHCP, PXE
- Appareils associés : **switchs**

### Couche 3 – Réseau

- Adressage **logique** (IPv4, IPv6)
- Routage (choix du meilleur chemin)
- Appareils : **routeurs**

### Couche 4 – Transport

- Segmentation, numérotation
- Protocole **TCP** (fiable), **UDP** (rapide, sans vérification)
- Utilisation de **ports** pour différencier les services

### Couches 5 à 7

- **Session** : gestion de session (authentification, synchronisation)
- **Présentation** : chiffrement, compression, encodage
- **Application** : services réseau accessibles par l’utilisateur (HTTP, FTP, DNS…)

---

## 🧪 Exemple de communication : accès à un site web

1. Utilisateur tape une URL dans son navigateur
2. Résolution DNS (IP du site)
3. Envoi de la requête HTTP(S)
4. Le site web répond → affichage

Chaque étape passe **de haut en bas** côté client (encapsulation) puis **de bas en haut** côté serveur (désencapsulation).

---

## 🛠️ Utilisation de Packet Tracer (Cisco)

### Objectif

- Simuler un réseau, configurer du matériel (routeurs, PC, switchs…)

### Interface principale

- **Menu matériel** : routeurs, switchs, terminaux, connexions, etc.
- **Zone de travail** : glisser-déposer les équipements

### Paramétrage du matériel

- Onglet **Physique** : ajout de modules, allumage
- Onglet **Configuration** : IP, routage, interfaces
- Onglet **CLI** : interface en ligne de commande Cisco
- Onglet **Attributs** : personnalisation avancée

### Connexions

1. Choisir un type de lien (câble droit/croisé)
2. Sélectionner les interfaces à relier
3. Voyants verts = liaison établie

### Astuce :

- Toujours **éteindre un appareil avant d’ajouter des modules**
- Penser à **sauvegarder** après configuration

---

## 📘 À retenir pour les révisions

- Le modèle OSI est composé de **7 couches** hiérarchiques
- L’**encapsulation** = ajout d’informations protocolaires
- Chaque couche remplit un rôle : **physique à application**
- Les **protocole TCP/IP**, **DHCP**, **DNS**, etc. se placent selon la couche
- Il faut **maîtriser l’association entre couche, rôle, et matériel associé**

## 🧑‍💼 Bonnes pratiques professionnelles
- Toujours **documenter l’adressage IP et MAC** utilisé
- **Séparer les VLANs** au niveau 2 pour compartimenter les flux
- Surveiller les **tableaux ARP** et les **logs de routage** en entreprise
- Utiliser Packet Tracer ou GNS3 pour **tester des configurations sans risques**
