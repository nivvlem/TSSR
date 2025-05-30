# Connexion des collaborateurs pour le télétravail
## 🧩 Introduction aux VPN (Virtual Private Network)

### Définition

Un **VPN** permet de créer un **tunnel sécurisé** sur Internet entre un utilisateur distant et le réseau de l’entreprise.

### Fonctionnement général

- Chiffrement du trafic réseau
- Authentification des utilisateurs
- Attribution d’une adresse IP interne à distance
- Possibilité d’accéder aux **ressources internes** de manière sécurisée

### Types de VPN

|Type|Usage|
|---|---|
|VPN site à site|Relier 2 sites distants de manière permanente|
|VPN d’accès distant|Connexion ponctuelle d’un utilisateur en télétravail|

### Avantages

- **Confidentialité** des données échangées (chiffrement)
- **Authentification** des utilisateurs
- Accès **depuis n’importe où**
- **Adresse IP interne** héritée pour un fonctionnement transparent

---

## 🔄 Protocoles VPN courants

|Protocole|Caractéristiques|
|---|---|
|**OpenVPN**|Open-source, flexible, basé sur SSL/TLS, recommandé|
|**WireGuard**|Moderne, léger, très performant, basé sur UDP|
|**IKEv2/IPsec**|Bon support de la mobilité, compatible multi-plateforme|
|**SSTP**|Intégration forte avec Windows|
|**L2TP/IPsec**|Sécurité correcte mais un peu datée|
|**PPTP**|Obsolète et non sécurisé, à éviter|

---

## ⚙️ Configuration d’OpenVPN sur pfSense

### 1️⃣ Préparation

- **Installer le package** : `OpenVPN Client Export` sur pfSense

### 2️⃣ Création de la PKI interne

- **System > Cert Manager**
- Créer une **CA interne** : `CA-OpenVPN`
- Créer un **certificat serveur** signé par la CA : `cert-OpenVPN`

### 3️⃣ Configuration de l’authentification LDAP (optionnelle)

- Ajouter un **serveur LDAP** dans **System > User Manager > Authentication Servers**
- Utiliser l’AD interne pour authentifier les utilisateurs VPN

### 4️⃣ Assistant OpenVPN

- **VPN > OpenVPN > Wizards**

- Sélectionner :
    - Authentification : LDAP ou local
    - CA : `CA-OpenVPN`
    - Certificat : `cert-OpenVPN`
    - Protocole : UDP / IPv4 / port 1194 (modifiable)
    - Tunnel network : `172.30.200.0/24`
    - Nombre de connexions max : ex: 100
    - DNS : serveur DNS interne (SRV-CD)

### 5️⃣ Règles de pare-feu

- **WAN** : ouvrir UDP 1194 vers pfSense (adresse WAN)
- **OpenVPN** : ouvrir les flux nécessaires vers LAN / DMZ

### 6️⃣ Export client

- **VPN > OpenVPN > Client Export**
- Exporter un **installeur complet** pour les clients Windows (fichier `.exe` ou `.ovpn`)
- Options :
    - `Microsoft Certificate Storage`
    - `Password Protect Certificate`
    - Option : `auth-nocache`

### 7️⃣ Installation côté client Windows

- Installer le package exporté
- Lancer OpenVPN GUI → **Connecter** → Saisir les identifiants LDAP (ou locaux)
- Vérifier la connexion (cadenas vert)
- Commande de vérification :

```bash
ipconfig /all
```

---

## ⚙️ Configuration de WireGuard sur pfSense

### 1️⃣ Installation

- Installer le package `WireGuard`

### 2️⃣ Création du tunnel WireGuard

- **VPN > WireGuard**
- Créer un **Tunnel** : `Tunnel_TP8`
    - Générer les clés (clé privée/clé publique)
    - Tunnel network : `172.40.200.0/24`

### 3️⃣ Configuration des peers (clients)

- Ajouter un **peer** par client distant
    - Associer la clé publique du client
    - Définir la plage IP du tunnel attribuée au client (ex: `172.40.200.2/32`)

### 4️⃣ Côté client Linux (CLT-NAT)

- Installer `wireguard-tools`
- Générer :

```bash
wg genkey > privatekey
wg pubkey < privatekey > publickey
```

- Créer le fichier `/etc/wireguard/wg0.conf` :

```text
[Interface]
PrivateKey = ...
Address = 172.40.200.2/32

[Peer]
PublicKey = ...
Endpoint = [WAN_IP_pfSense]:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
```

### 5️⃣ Vérification

- Activer le tunnel :

```bash
wg-quick up wg0
```

- Vérifier :

```bash
wg show
ip a
```

- Tester la connexion : SSH sur SRV-WEB dans la DMZ

### 6️⃣ Règles de pare-feu

- **WAN** : ouvrir UDP 51820
- Créer un onglet WireGuard dans Firewall si nécessaire

---

## ✅ À retenir pour les révisions

- Le VPN permet un **télétravail sécurisé** en chiffrant les flux
- **OpenVPN** et **WireGuard** sont les solutions les plus adaptées actuellement
- La **PKI interne** permet d’assurer l’identité des serveurs
- Le VPN d’accès distant doit être correctement **filtré** et **contrôlé**
- Il faut toujours **vérifier les logs** et surveiller les connexions VPN actives

---

## 📌 Bonnes pratiques professionnelles

- Limiter le nombre d’utilisateurs autorisés à utiliser le VPN
- Appliquer une politique de **mot de passe fort**
- Désactiver les comptes inactifs
- Utiliser des **protocoles récents** (TLS 1.3 pour OpenVPN, WireGuard pour les clients modernes)
- Automatiser la **revocation** des certificats si un poste est perdu ou compromis
- **Tracer** toutes les connexions VPN (logs horodatés)
- Réaliser des **tests de connectivité réguliers** pour s’assurer que le service VPN fonctionne correctement