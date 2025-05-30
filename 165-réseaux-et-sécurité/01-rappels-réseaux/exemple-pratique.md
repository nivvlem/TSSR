# 🛡️ TP - Étudier les besoins de l'entreprise en termes de flux de sorties vers Internet
## 🗺️ Analyse du réseau

| Segment réseau  | Adresse réseau                | Description                                  | Fonction principale                        |
| --------------- | ----------------------------- | -------------------------------------------- | ------------------------------------------ |
| **LANCLT**      | `172.20.200.0/26` (VMnet10)   | Réseau clients (Linux et Windows)            | Postes utilisateurs                        |
| **LANDMZ**      | `172.20.200.192/26` (VMnet12) | DMZ sécurisée                                | Serveur WEB (SRV-WEB)                      |
| **LAN SRV**     | `172.20.200.128/26` (VMnet11) | Réseau serveurs internes                     | SRV-AD (AD, DNS, PKI), SRV-MBR (DHCP, IIS) |
| **Bridge**      | `192.168.150.201/24`          | Interface vers routeur formateur et Internet | Accès contrôlé vers l’extérieur            |
| **CLT-NAT**     | NAT (client Linux NAT)        | VM de test d'accès NATé vers l'extérieur     | Dépannage/Validation flux NAT              |
| **Squid Proxy** | N/A                           | Proxy central pour navigation web sécurisée  | Filtrage et contrôle Web                   |

---

## 🔍 Besoins de communication

### **LANCLT → LAN SRV**

- **UDP 53** → DNS
- **UDP 67-68** → DHCP
- **TCP/UDP 88** → Kerberos
- **TCP/UDP 389, 636** → LDAP, LDAPS
- **TCP 445** → SMB (partages, GPO)

### **LANCLT → Internet**

- **HTTP/HTTPS (80/443)** → via **Proxy Squid uniquement**

### **LAN SRV → Internet**

- **HTTP/HTTPS (80/443)** → Téléchargements MAJ OS / Vérification CRL PKI / Temps NTP

### **LAN SRV → LANDMZ**

- **SSH (TCP 22)**, **RDP (TCP 3389)** → Maintenance serveur Web

### **LANDMZ → Internet**

- **HTTP/HTTPS (80/443)** → Publication site Web

---

## 🔐 Règles de pare-feu détaillées

| Source | Destination | Protocole/Port | Action | Justification |
|--------|-------------|----------------|--------|---------------|
| LANCLT | LAN SRV | UDP 53 | PERMIT | Résolution DNS |
| LANCLT | LAN SRV | UDP 67-68 | PERMIT | DHCP client |
| LANCLT | LAN SRV | TCP/UDP 88 | PERMIT | Kerberos authentification |
| LANCLT | LAN SRV | TCP/UDP 389, 636 | PERMIT | LDAP, LDAPS |
| LANCLT | LAN SRV | TCP 445 | PERMIT | SMB, GPO |
| LANCLT | Squid Proxy | TCP 3128 | PERMIT | Proxy HTTP/HTTPS |
| LANCLT | Internet | ANY | DENY | Forçage passage proxy |
| LAN SRV | LANDMZ | TCP 22, 3389 | PERMIT | Admin serveur Web |
| LANDMZ | LAN SRV | ANY | DENY sauf réponses | Sécurité "zéro trust" DMZ vers LAN interne |
| LANDMZ | Internet | TCP 80, 443 | PERMIT | Publication site Web |
| LAN SRV | Internet | TCP 80, 443 | PERMIT | MAJ systèmes, CRL PKI, NTP |
| Par défaut | Par défaut | ANY | DENY | Politique par défaut stricte |

---

## ✅ Bonnes pratiques

- **Principe de moindre privilège** : n’autoriser que les flux nécessaires.
- **Segmentation** réseau claire (Clients ↔ DMZ ↔ Serveurs ↔ Internet).
- **Proxy Squid obligatoire** pour navigation Internet des clients.
- **Journalisation (logging)** activée sur le pare-feu pour tracer les flux.
- **Tests de validation** des flux après déploiement des règles.
- **Blocage des flux non initiés** depuis la DMZ vers le LAN.

---

## ⚠️ Pièges à éviter

- ❌ Ne pas autoriser de flux "ANY ANY" par facilité.
- ⚠️ Ne pas oublier les **flux de réponse** (ex : DNS UDP réponse).
- ⚠️ Attention aux ports éphémères pour MAJ systèmes.
- ⚠️ La DMZ **ne doit jamais initier de connexions** vers le LAN interne.


