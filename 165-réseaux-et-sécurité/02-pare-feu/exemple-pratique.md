# 🛡️ TP - Configuration du pare-feu Pfsense
## 🏗️ Étape 1 — Installation de l’infrastructure

### 🔸 1.1 — Installation du serveur **SRV-CD** (Contrôleur de domaine)

**Procédure :**

1️⃣ Importer la VM `Base-SRV-WIN2022.ovf` dans VMware.  
2️⃣ Connecter la VM sur le réseau `VMnet11` (correspondant à **LAN SRV**).  
3️⃣ Attribuer à la VM l’adresse IP et la passerelle définies dans le schéma réseau du TP précédent.  
4️⃣ Renommer la VM : `SRV-CD`.  
5️⃣ Installer les rôles suivants :

- **AD DS** (Active Directory Domain Services)
- **DNS Server**  
    6️⃣ Créer un domaine : `nivvlem.eni`
    7️⃣ Exécuter les scripts dans l’ordre suivant depuis `D:/scripts` :
- `Install-DNS-ADDS.ps1`
- `DNS-Zone-Inversées.ps1`
- `OU.ps1`
- **Modifier `Users.csv` et `Groups.csv`** avec le bon nom de domaine.
- `Users.ps1`
- `Groups.ps1`
- `AdduseronGroups.ps1`  
    8️⃣ Dans le gestionnaire DNS, créer un **redirecteur DNS** vers le serveur DNS de la box

---

### 🔸 1.2 — Installation du serveur **SRV-MBR** (Serveur DHCP et autres rôles)

**Procédure :**

1️⃣ Importer la VM `Base-SRV-WIN2022.ovf`.  
2️⃣ Réseau : `VMnet11`.  
3️⃣ Attribuer IP `172.20.200.128`.  
4️⃣ Renommer la VM : `SRV-MBR`.  
5️⃣ Joindre ce serveur au domaine créé précédemment.  
6️⃣ Installer le rôle **DHCP Server**.  
7️⃣ Créer une **étendue DHCP** pour le réseau **LAN CLIENT** (VMnet10).

---

### 🔸 1.3 — Installation du routeur **pfSense**

**Procédure :**

1️⃣ Importer la VM `Routeur-Stagiaire.ovf`.  
2️⃣ Réseau :

- `WAN` : Bridge ou NAT (accès Internet)
- `LAN SRV` : `VMnet11`
- `LAN CLIENT` : `VMnet10`
- `DMZ` (si présente) : `VMnet12`  
    3️⃣ Démarrer la VM pfSense.  
    4️⃣ Accéder à l’interface Web de pfSense via son IP LAN :
- `https://192.168.150.100`
    5️⃣ Dans les **Paramètres Généraux** :
- Nom de domaine : `nivvlem.eni`
- DNS : adresse IP de `SRV-CD`  
    6️⃣ **Activer le DHCP Relay** sur pfSense pour le réseau LAN CLIENT :
- Relayer vers le serveur `SRV-MBR`.

---

### 🔸 1.4 — Installation des clients

#### Client **Windows 10**

1️⃣ Créer une VM avec l’ISO Windows 10.  
2️⃣ Paramétrage :

- RAM : 3 Go
- CPU : 2
- Réseau : `VMnet10` (LAN CLIENT)  
    3️⃣ Démarrer la VM, vérifier que l’IP est obtenue via DHCP.  
    4️⃣ Créer une **réservation DHCP** pour ce client sur `SRV-MBR`.  
    5️⃣ Désactiver le pare-feu Windows pour les tests initiaux.  
    6️⃣ Joindre la VM au domaine `votre_nom.eni`.

#### Client **Debian 12**

1️⃣ Créer une VM avec l’ISO Debian 12.  
2️⃣ Paramétrage :

- RAM : 2 Go
- CPU : 1
- Réseau : `VMnet10`.  
    3️⃣ Vérifier attribution DHCP.  
    4️⃣ Créer réservation DHCP.

---

## 🔐 Étape 2 — Implémentation des règles dans pfSense

### 🔸 2.1 — Politique de base

**Principe** : Transcrire dans pfSense la **matrice de flux définie au TP1** :

✅ Par défaut → **tout bloqué**  
✅ On autorise uniquement les flux nécessaires

---

### 🔸 2.2 — Règles par interface

#### Interface **LANCLIENT** (VMnet10)

|Source|Destination|Protocole/Port|Action|Commentaire|
|---|---|---|---|---|
|LANCLIENT|LAN SRV|UDP 53|Pass|DNS vers SRV-CD|
|LANCLIENT|LAN SRV|UDP 67-68|Pass|DHCP|
|LANCLIENT|LAN SRV|TCP/UDP 88|Pass|Kerberos|
|LANCLIENT|LAN SRV|TCP/UDP 389, 636|Pass|LDAP, LDAPS|
|LANCLIENT|LAN SRV|TCP 445|Pass|SMB (partages, GPO)|
|LANCLIENT|Internet|Any|Block|Obligation de passer par Proxy|

---

#### Interface **LANSERVER** (VMnet11)

|Source|Destination|Protocole/Port|Action|Commentaire|
|---|---|---|---|---|
|LAN SRV|Internet|TCP 80, 443|Pass|MAJ systèmes, CRL PKI, NTP|
|LAN SRV|LANDMZ|TCP 22, 3389|Pass|Maintenance serveur Web|
|LANDMZ|LAN SRV|Any|Block sauf réponses|Politique Zéro Trust DMZ →|

---

#### Interface **DMZ**

|Source|Destination|Protocole/Port|Action|Commentaire|
|---|---|---|---|---|
|LANDMZ|Internet|TCP 80, 443|Pass|Publication site Web|

---

## 🧪 Étape 3 — Tests de validation

### 🔸 Plan de test

|Test|Objectif|Résultat attendu|
|---|---|---|
|Client Windows → DNS|Résolution DNS|OK|
|Client Windows → Authentification domaine|Login réussi|OK|
|Client Windows → Internet direct|Bloqué|OK|
|Client Windows → Proxy|Navigation possible via proxy|OK|
|SRV-MBR → Internet|MAJ système|OK|
|SRV-CD → Internet|MAJ système, CRL PKI|OK|
|SRV-CD → DMZ|SSH/RDP vers serveur Web|OK|
|DMZ → Internet|Publication du site Web|OK|

---

## ✅ Bonnes pratiques

- Toujours **appliquer le principe de moindre privilège**.
- Tester **chaque règle** après déploiement.
- Activer la **journalisation (logging)** sur les règles importantes.
- Documenter précisément les flux autorisés.
- Garder une politique **"tout bloqué par défaut"**.

---

## ⚠️ Pièges courants à éviter

- Ne pas oublier d’activer le **DHCP Relay** sur pfSense pour le LAN CLIENT.
- Vérifier la correspondance entre **interfaces VMware ↔ interfaces pfSense**.
- Ne pas autoriser de règles trop larges (ANY ANY).
- Penser à désactiver le pare-feu Windows pour les tests initiaux.
- Vérifier que les flux de réponses sont bien permis.