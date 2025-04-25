# Mise en situation professionnelle : Services réseau

## Services DHCP & DNS

## 🔧 Rappel de la règle de parité (D impair = 13)

|Service|Serveur d'hébergement|Nom de la VM|
|---|---|---|
|DHCP|Debian|`SRV-LNX-MD`|
|DNS|Windows Server 2|`SRV-SVC-MD`|

---

# 💡 1. Installation du service DHCP (sur Debian)

### 📁 Installation

Sur `SRV-LNX-MD` :

```bash
sudo apt update && sudo apt install isc-dhcp-server -y
```

### 🛠 Configuration du service

* Fichier `/etc/dhcp/dhcpd.conf` :

```bash
# Option de base
option domain-name "infra.tld";
option domain-name-servers 192.168.55.102;
default-lease-time 600;
max-lease-time 7200;

# Réseau LAN Clients
subnet 192.168.52.0 netmask 255.255.255.0 {
  range 192.168.52.100 192.168.52.199;
  option routers 192.168.52.254;
  option subnet-mask 255.255.255.0;
  option broadcast-address 192.168.52.255;
  option domain-name-servers 192.168.55.102;
}
```

* Interface à écouter : Fichier `/etc/default/isc-dhcp-server` :

```bash
INTERFACESv4="ens33"
```

Redémarrage du service :

```bash
sudo systemctl restart isc-dhcp-server
```

### 🚧 Vérifications

- Depuis le client Linux ou Windows, configuration de l’interface en DHCP.
- Redémarrer la carte ou la machine.
- Vérification de l’attribution :

```bash
ip a          # ou ipconfig sous Windows
```

- Vérification dans les logs du serveur :

```bash
journalctl -u isc-dhcp-server
```

---

# 💡 2. Installation du service DNS (sur SRV-SVC-MD)

### 📁 Installation via PowerShell

Sur le serveur `SRV-SVC-MD`, depuis une session administrateur PowerShell :

```powershell
Install-WindowsFeature DNS -IncludeManagementTools
```

### 🛠 Configuration du redirecteur inconditionnel

1. Console **DNS**.
2. Clic droit sur le nom du serveur > **Propriétés**.
3. Onglet **Redirecteurs** > **Modifier**.
4. Ajouter le DNS de l’ENI (trouvé via la commande) :

```powershell
Get-DnsClientServerAddress
```

5. Applique et redémarre le service DNS si besoin.

---

## 📲 3. Configuration DNS sur l'infrastructure

### Serveurs & clients

- Tous les serveurs et clients doivent pointer vers **192.168.55.102** (SRV-SVC-MD)

> Pour les clients DHCP, c’est fourni via `option domain-name-servers`.

### Test de résolution DNS

- Depuis un client :

```bash
dig google.fr
```

ou sous Windows :

```powershell
Resolve-DnsName google.fr
```

- Le résultat doit venir du serveur DNS `192.168.55.102`, qui lui-même redirige vers ENI.

---

# 🌐 4. Création d'une zone DNS interne

### Nom de zone : `melvin13.infra.tld`

1. Dans la console DNS > clic droit sur **Zones de recherche directe** > **Nouvelle zone**.
2. Type de zone : **Principale**, stockée localement.
3. Nom : `melvin13.infra.tld`
4. Ajoute des enregistrements A pour :
    - `srv-ad-md` → 192.168.55.101
    - `srv-svc-md` → 192.168.55.102
    - `srv-lnx-md` → 192.168.55.111

### Test depuis un client Windows

```powershell
Resolve-DnsName srv-ad-md.melvin13.infra.tld
```

### Créer la zone de recherche inversée

1. Console DNS > clic droit sur **Zones de recherche inversée** > **Nouvelle zone**.
2. Choisir IPv4.
3. Nom du réseau : `55.168.192.in-addr.arpa`
4. Ajout d'un enregistrement PTR pour chaque serveur.


### Test de résolution inverse

```powershell
Resolve-DnsName 192.168.55.102 -Type PTR
```

---

## 📄 Synthèse

| Service  | Hébergé sur        | Adresse IP     | Particularité                       |
| -------- | ------------------ | -------------- | ----------------------------------- |
| DHCP     | SRV-LNX-MD         | 192.168.55.111 | Pour le LAN Clients uniquement      |
| DNS      | SRV-SVC-MD         | 192.168.55.102 | Redirecteur vers DNS ENI            |
| Zone DNS | melvin13.infra.tld | DNS interne    | Nommage local et résolution inverse |
