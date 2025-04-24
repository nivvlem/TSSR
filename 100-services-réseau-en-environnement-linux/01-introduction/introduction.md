Introduction aux services réseau en environnement Linux

## 🧭 Contexte général

Les utilisateurs d’une entreprise accèdent aux **services informatiques** :

- depuis différents appareils : ordinateurs, smartphones, tablettes…
- depuis différents lieux : bureau, télétravail, mobilité…

Ces services sont assurés par :

- l’équipe système de l’entreprise
- ou des sous-traitants (infogérance, hébergement, cloud…)

📌 **Les services sont le cœur du système d'information.**

---

## 🛠️ Services abordés dans ce cours

Ce module introduit les **services fondamentaux** :

- Mise en place du **réseau IP**
- **Routage** (interconnexion de réseaux)
- **DNS** (résolution de noms)
- **DHCP** (attribution dynamique d’adresses IP)

Ces services seront configurés dans un **bac à sable virtualisé** sous Linux/Debian et pfSense.

---

## 🧪 Environnement de test (maquette)

### 🔹 Plateforme de virtualisation :

- VMware Workstation
- Machines virtuelles sous :
    - **pfSense** (routage, pare-feu)
    - **Debian 12 (serveurs de service réseau)

### 🔹 Réseaux logiques (VMNet)

- Réseaux isolés pour simuler les différents segments d’un SI
- Utilisation de plusieurs VMNet pour cloisonner les services

### 🔹 Exemples de sous-réseaux

| Réseau           | Utilisation          |
| ---------------- | -------------------- |
| 172.18.100.0/24  | Clients (LAN 1)      |
| 192.168.100.0/24 | DHCP                 |
| 172.30.100.0/24  | DNS                  |
| 192.168.1.0/24   | Simulation WAN (FAI) |


---

## 🔍 Points de vigilance

|Élément|À adapter|
|---|---|
|Adresse du réseau FAI|Ex : `192.168.1.0/24`|
|Adresse de la passerelle|Ex : `192.168.1.1` ou `.254`|
|Interfaces VMware|Vérifier VMNet, bridge, NAT, etc.|

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Cloisonner les réseaux de test|Évite les conflits IP avec ton réseau personnel|
|Identifier chaque interface réseau|Facilite les tests et le diagnostic réseau|
|Utiliser des adresses statiques bien documentées|Cohérence lors de la configuration des services|
|Tester chaque service indépendamment|Valider étape par étape|
