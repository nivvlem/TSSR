# Connexion des collaborateurs entre sites
## 🧩 Qu’est-ce qu’un VPN site à site ?

### Définition

- Un VPN site à site permet de **relier deux réseaux LAN distants** via un tunnel chiffré sur Internet.
- Chaque site utilise un **routeur VPN** (ex: pfSense) qui établit le tunnel VPN.
- Les utilisateurs peuvent accéder aux ressources du site distant **comme s’ils étaient en local**.

### Avantages

- Chiffrement des données
- Isolation des flux VPN
- Simplicité d’usage pour les collaborateurs (aucune action requise côté client)
- Compatible avec des **réseaux multi-sites**

### Illustration

```text
LAN Site A ↔ VPN tunnel IPsec ↔ LAN Site B
```

---

## 🔄 Fonctionnement d’un tunnel IPsec

### Phases

#### Phase 1 (IKE - Internet Key Exchange)

- Authentifie les routeurs (pfSense A ↔ pfSense B)
- Établit la **clé de session** pour chiffrer la Phase 2
- Utilise des protocoles : **IKEv2** recommandé
- Méthodes d’authentification : **PSK** (Pre-Shared Key) ou certificats

#### Phase 2 (IPsec ESP - Encapsulating Security Payload)

- Chiffre réellement les données des réseaux LAN ↔ LAN
- Définit :
    - **Réseau local** (LAN Site A)
    - **Réseau distant** (LAN Site B)
    - Méthodes de chiffrement (AES-GCM, SHA256...)

---

## ⚙️ Configuration d’un VPN site à site sur pfSense

### 1️⃣ Pré-requis

- Chaque site dispose :
    - d’un pfSense connecté à Internet (interface WAN)
    - d’un LAN interne
- Adresse IP publique fixe ou DynDNS pour les WAN
- Définir les réseaux à interconnecter (ex: `192.168.10.0/24` ↔ `192.168.20.0/24`)

### 2️⃣ Configuration de la Phase 1 (IKE)

**VPN > IPsec > Tunnels** → Add P1

|Paramètre|Valeur recommandée|
|---|---|
|Key Exchange version|IKEv2|
|Interface|WAN|
|Remote Gateway|IP publique du site distant|
|Authentication Method|Mutual PSK|
|Pre-Shared Key|Clé partagée forte|
|Encryption Algorithms|AES-256, SHA256|
|Lifetime|28800s (défaut)|

### 3️⃣ Configuration de la Phase 2 (IPsec ESP)

Sous la Phase 1 → Add P2

|Paramètre|Valeur recommandée|
|---|---|
|Mode|Tunnel IPv4|
|Local Network|LAN réseau local (ex: 192.168.10.0/24)|
|Remote Network|LAN distant (ex: 192.168.20.0/24)|
|Encryption Algorithms|AES-GCM-256|
|PFS Group|14 (modp2048) ou plus|

### 4️⃣ Règles firewall

**Firewall > Rules > IPsec**

- **Source** : `LAN distant`
- **Destination** : `LAN local`
- **Action** : Pass

**Firewall > Rules > LAN**

- Si besoin, autoriser les flux vers le LAN distant

---

## 🔍 Vérification de la connexion VPN

### 1️⃣ État du tunnel

**Status > IPsec**

- Vérifier que la Phase 1 et la Phase 2 sont **established**
- Logs supplémentaires :

```bash
/var/log/ipsec.log
```

### 2️⃣ Tests de connectivité

- **Ping** entre les deux LAN (ex: `ping 192.168.20.X` depuis le site A)
- **Traceroute** pour vérifier le chemin VPN
- **Accès applicatifs** (ex: partage de fichiers, RDP...)

### 3️⃣ Analyse des logs

- **System Logs > IPsec**
- Vérification des négociations, déconnexions, relances

---

## ✅ À retenir pour les révisions

- Le VPN **site à site IPsec** relie deux réseaux LAN en toute sécurité
- **Phase 1 IKE** = négociation et authentification
- **Phase 2 IPsec** = chiffrement des données entre les LANs
- Les **règles firewall IPsec** contrôlent les flux autorisés
- Une surveillance régulière des **logs IPsec** est indispensable

---

## 📌 Bonnes pratiques professionnelles

- Toujours utiliser **IKEv2** et des algorithmes de chiffrement modernes (AES-256, SHA256)
- Générer des **clés PSK robustes** (32+ caractères)
- Documenter les **réseaux connectés** et les **flux autorisés**
- Restreindre les flux IPsec aux stricts besoins métiers
- Activer le **logging** pour tracer les activités VPN
- Planifier des **tests réguliers** de continuité inter-sites
- Mettre en place des **alertes sur les déconnexions VPN**