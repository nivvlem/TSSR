# TP – Configurer le serveur DHCP avec isc-dhcp-server (Linux)

## 🧪 Étape 1 – Installation du relai DHCP sur RouTux

### 🔹 Recherche et installation du paquet

```bash
apt search ^isc-dhcp
apt install isc-dhcp-relay
```

### 🔹 Identification des interfaces réseau

```bash
ip a
# ens33 = LAN Clients (ex : 172.18.100.0/24)
# ens36 = LAN Serveurs
```

### 🔹 Configuration via dpkg-reconfigure

```bash
dpkg-reconfigure isc-dhcp-relay
```

Réponses attendues :

- Adresse du serveur DHCP : `192.168.100.12` (IP de DEB-S1)
- Interfaces d’écoute : `ens33 ens36`

✔️ Le service est désormais prêt à relayer les requêtes vers le serveur DHCP.

---

## 🧩 Étape 2 – Configuration du service isc-dhcp-server sur DEB-S1

### 🔹 Installation

```bash
apt install isc-dhcp-server
```

### 🔹 Configuration des interfaces à écouter

Fichier : `/etc/default/isc-dhcp-server`

```bash
INTERFACESv4="ens33"
```

### 🔹 Configuration du fichier `/etc/dhcp/dhcpd.conf`

```bash
ddns-update-style none;
default-lease-time 345600;
max-lease-time 691200;
log-facility local7;
authoritative;

option domain-name-servers 192.168.100.12;

# Plage LAN Clients
subnet 172.18.100.0 netmask 255.255.255.0 {
  range 172.18.100.100 172.18.100.200;
  option routers 172.18.100.254;
}

# LAN Serveurs (pas de distribution DHCP)
subnet 192.168.100.0 netmask 255.255.255.0 {}
```

### 🔹 Configuration des logs DHCP dans rsyslog

Fichier : `/etc/rsyslog.conf`

```bash
local7.*    /var/log/dhcpd.log
```

Redémarrer rsyslog :

```bash
systemctl restart rsyslog
```

---

## 🐞 Étape 3 – Mode debug et validation des échanges DHCP

### 🔹 Arrêter les services

```bash
systemctl stop isc-dhcp-relay.service
systemctl stop isc-dhcp-server.service
```

### 🔹 Lancer les services en mode debug

```bash
# Sur RouTux (relai)
dhcrelay -d -iu ens36 -id ens33 192.168.100.12

# Sur DEB-S1 (serveur DHCP)
dhcpd -d
```

### 🔹 Configurer `CLI-DB-12` en client DHCP

- Via nmtui ou :

```bash
nmcli con mod "Wired connection 1" ipv4.method auto
nmcli con up "Wired connection 1"
```

- Vérifier qu’il reçoit :
    - Une IP dans la plage `172.18.100.100 – .200`
    - Une passerelle : `172.18.100.254`
    - Un DNS : `192.168.100.12`

### 🔹 Observation du dialogue DISCOVER → OFFER → REQUEST → ACK

Sur les terminaux debug de RouTux et DEB-S1 : ✔️

### 🔹 Nettoyage et redémarrage normal des services

```bash
systemctl start isc-dhcp-server
systemctl start isc-dhcp-relay
```

⚠️ Supprimer `/var/run/dhcpd.pid` si le redémarrage du service DHCP échoue.

### 🔹 Activer le démarrage automatique

```bash
systemctl enable isc-dhcp-server
systemctl enable isc-dhcp-relay
```

---

## ✅ Vérifications finales

- `CLI-DB-12` reçoit bien une configuration IP dynamique complète
- Les logs DNS (`/var/log/dhcpd.log`) montrent les échanges standard DHCP
- Le relai achemine bien les paquets DISCOVER/REQUEST → serveur → ACK
- Les services sont actifs, fonctionnels et persistent au reboot

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Toujours tester la configuration avec `dhcpd -t`|Éviter les erreurs au lancement du service DHCP|
|Séparer les plages DHCP des adresses IP statiques|Éviter les conflits d’adresses dans le LAN|
|Journaliser dans un fichier dédié (local7)|Facile à tracer / superviser|
|Redémarrer les services après debug|Assurer le retour à un état nominal|
|Activer les services au démarrage|Éviter les oublis lors d’un redémarrage serveur|
