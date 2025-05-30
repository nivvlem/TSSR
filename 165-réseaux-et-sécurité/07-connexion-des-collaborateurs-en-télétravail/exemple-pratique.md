# 🛡️ TP - Connecter les collaborateurs pour le télétravail (VPN OpenVPN & WireGuard)
## 🛠️ PARTIE 1 — VPN OpenVPN
### 🔹 1.1 — Vérification réseau

- Depuis le client Windows :  
    👉 Vérifier la possibilité de **pinger l’IP WAN de pfSense**.

---

### 🔹 1.2 — Configuration de l’autorité de certification (CA)

Si le pfSense n’a pas de CA, alors :

1. Aller dans **System > Cert. Manager > CAs**.
2. Créer une nouvelle **CA interne** (ici : `CA-OpenVPN-nivvlem`).
3. Générer la CA.

---

### 🔹 1.3 — Génération d’un certificat serveur

1. Aller dans **System > Cert. Manager > Certificates**.
2. Créer un certificat de type **Server Certificate** pour OpenVPN.

---

### 🔹 1.4 — (Optionnel) Activation de l’authentification LDAP

Sur le **SRV-CD** avec AD :

1. Aller dans **System > User Manager > Authentication Servers**.
2. Ajouter un serveur **LDAP** pointant vers le SRV-CD.

💡 Ceci permettrait d’utiliser des comptes AD pour se connecter en VPN.

---

### 🔹 1.5 — Configuration du serveur OpenVPN

1. Aller dans **VPN > OpenVPN > Wizards**.
2. Suivre l’assistant :

| Étape              | Paramétrage                                   |
| ------------------ | --------------------------------------------- |
| Choose Type        | Local User Access (ou LDAP si configuré)      |
| CA                 | le CA créée précédemment                      |
| Server Certificate | le certificat serveur                         |
| Interface          | WAN                                           |
| Tunnel Network     | ici : `10.10.10.0/24`                         |
| Local Network(s)   | les réseaux internes (ex : `172.20.200.0/24`) |
| Compression        | Disabled                                      |
| TLS Encryption     | Enabled                                       |

3. Générer la configuration.

---

### 🔹 1.6 — Configuration des clients OpenVPN

1. Aller dans **VPN > OpenVPN > Client Export** (plugin à installer si besoin).
2. Télécharger le fichier d’installation + configuration pour le **binôme test**.

- Fichier `.ovpn` pour les clients.

---

### 🔹 1.7 — Installation et test sur client Windows

1. Installer **OpenVPN Connect** sur le client Windows.
2. Importer le fichier `.ovpn`.
3. Lancer la connexion VPN.
4. Tester :

|Test|Attendu|
|---|---|
|Ping réseau interne (LAN)|OK|
|Accès aux services (SRV-MBR, SRV-WEB…)|OK|

---

## 🛠️ PARTIE 2 — VPN WireGuard
### 🔹 2.1 — Configuration du serveur WireGuard (pfSense)

1. Aller dans **VPN > WireGuard**.
2. Créer un nouveau **Instance** :

| Paramètre      | Valeur                  |
| -------------- | ----------------------- |
| Name           | `WG-nivvlem`            |
| Listen Port    | `51820`                 |
| Interface Keys | Générer automatiquement |
| Tunnel Address | `10.20.20.1/24`         |

3. Appliquer.

---

### 🔹 2.2 — Ajout d’un Peer pour CLT-NAT

1. Aller dans **Peers**.
2. Ajouter un Peer :

| Paramètre   | Valeur                           |
| ----------- | -------------------------------- |
| Public Key  | Clé publique générée par CLT-NAT |
| Allowed IPs | `10.20.20.2/32`                  |
| Endpoint    | (laisser vide pour test)         |

---

### 🔹 2.3 — Sur **CLT-NAT**

#### a) Générer les clés WireGuard

```bash
umask 077
wg genkey | tee privatekey | wg pubkey > publickey
```

---

#### b) Créer le fichier de config WireGuard (wg0.conf)

```ini
[Interface]
PrivateKey = <clé privée>
Address = 10.20.20.2/32
DNS = 172.20.200.254

[Peer]
PublicKey = <clé publique de pfSense>
Endpoint = WAN_IP_PFSENSE:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
```

---

#### c) Activer le routage sur CLT-NAT

```bash
sudo sysctl -w net.ipv4.ip_forward=1
```

---

#### d) Démarrer WireGuard

```bash
sudo wg-quick up wg0
```

---

### 🔹 2.4 — Test de la connexion VPN WireGuard

- Depuis CLT-NAT → **ping les réseaux internes**.
- Connexion **SSH** vers **SRV-WEB** → doit fonctionner.

---

## ✅ Bonnes pratiques

- Toujours utiliser une **CA** de confiance (éviter les autosignés en production).
- Pour OpenVPN :
    - préférer l’auth LDAP pour les entreprises.
    - bien protéger les fichiers `.ovpn`.
- Pour WireGuard :
    - bien protéger les **clés privées**.
    - utiliser des ports aléatoires en production.

---

## ⚠️ Pièges courants

- Oublier d’ouvrir les ports VPN sur le firewall WAN.
- Mal configurer les routes (tunnel vs split tunneling).
- Erreur de clé publique/privée.
- Ne pas autoriser les réseaux internes dans les AllowedIPs.
