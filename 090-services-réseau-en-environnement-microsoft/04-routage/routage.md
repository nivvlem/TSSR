# Le Routage

## 🌐 Principe du routage

Le **routage** permet la communication entre plusieurs réseaux logiques distincts. Un équipement intermédiaire (routeur) est nécessaire lorsque deux machines ne sont pas sur le même sous-réseau.

### 🔸 Routage local vs inter-réseaux

- **Local** : communication dans le même sous-réseau (même masque, même réseau IP)
- **Routé** : communication via une **passerelle** si les réseaux sont différents

### 📋 Composants d’une route :

|Élément|Rôle|
|---|---|
|Adresse réseau de destination|Ex : 192.168.2.0|
|Masque de sous-réseau|Ex : 255.255.255.0 ou /24|
|Adresse de passerelle (gateway)|IP du routeur vers le prochain réseau|

---

## 🛠️ Configuration d’un routeur (pfSense)

### 🔹 Préparation de la VM pfSense :

- ISO téléchargée depuis : [https://archive.org/details/pfSense-CE-iso-2.7.2-RELEASE-amd64](https://archive.org/details/pfSense-CE-iso-2.7.2-RELEASE-amd64)
- Disques : 20 Go, 2 CPU, 2 interfaces réseau
    - **em0** : bridge (WAN)
    - **em1** : LAN (VMnet10)

### 🔹 Installation pas à pas :

- Suivre les écrans d'installation (choix clavier, disque, reboot)
- Affecter interfaces manuellement : `1` > `n` (pas de VLAN) > `em0` (WAN) > `em1` (LAN)
- Configuration IP LAN : IP manuelle, masque en CIDR (ex : 192.168.10.1/24)

### 🔹 Accès à l’interface web :

- URL dans navigateur client : `http://192.168.10.1`
- Identifiants initiaux : `admin` / `pfSense`
- Configuration guidée : nom d’hôte, mot de passe, timezone, etc.

---

## 📦 Fonctionnement des requêtes inter-réseaux

### 🔹 Comportement sans routeur

- Si A = 192.168.1.10 et C = 192.168.2.140 → pas de réponse
- Les machines ne savent pas comment joindre un réseau différent sans route

### 🔹 Comportement avec passerelle

- Si la machine A connaît une **passerelle par défaut** (ex : 192.168.1.254), elle envoie son paquet à cette IP si la destination n’est pas sur le même réseau
- Le **routeur** examine la destination et la **retransmet dans le bon réseau**

---

## 🔁 Table de routage

Chaque routeur possède une table qui liste les réseaux connus et les interfaces associées.

### 🔹 Visualisation sous Windows

```powershell
route print
```

### 🔹 Ajout d'une route statique

```powershell
route add 192.168.3.0 mask 255.255.255.0 192.168.2.254
```

> Cette commande ajoute une route vers le réseau `192.168.3.0/24` via le **prochain saut** `192.168.2.254`

---

## 🔄 NAT – Traduction d’adresses

### 🔹 Sans NAT

- Les IP privées (RFC1918) ne sont **pas routables sur Internet**
- Une tentative de ping sortant est **bloquée** ou rejetée

### 🔹 Avec NAT

- Le routeur **remplace l’adresse source privée** par une adresse publique (masquage)
- Il **enregistre l’association** dans une table de translation (port source, IP source...)

### 🔹 Exemple de translation

```
PC interne → 192.168.20.13:3008 → NAT → 90.83.78.224:49010 → Internet
Réponse ← 80.87.128.67:80 ← NAT ← 90.83.78.224:49010
```

---

## 🧠 À retenir pour les révisions

- Le routage permet à des machines de **réseaux différents** de communiquer
- Une **passerelle (gateway)** est nécessaire pour sortir du réseau local
- Les **requêtes ARP** permettent de retrouver l'adresse MAC associée à une IP locale
- La **table de routage** oriente chaque paquet vers sa destination
- Le **NAT** est indispensable pour la communication Internet depuis un réseau privé

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Toujours documenter le plan d’adressage|Facilite le dépannage, évite les conflits|
|Tester le routage entre segments|Valider les configurations avant mise en production|
|Séparer les réseaux logiques pour la sécurité|Meilleure segmentation, cloisonnement réseau|
|Utiliser pfSense pour simuler un routeur|Solution libre, robuste et pédagogique|
|Limiter les routes statiques en entreprise|Préférer les protocoles de routage dynamique dans les SI larges|
