# Le service DHCP (Linux / isc-dhcp-server)

## 🔁 Fonctionnement du DHCP (IPv4)

### 🔹 Objectifs du protocole DHCP

- Fournir dynamiquement une **configuration réseau complète** à un client : IP, masque, gateway, DNS…
- Faciliter l’administration réseau en centralisant l’attribution des adresses IP
- Optimiser l’utilisation d’une plage IP

### 🔹 Échanges DHCP

1. **Discover** → Le client diffuse une demande de configuration IP (broadcast)
2. **Offer** → Le serveur propose une configuration
3. **Request** → Le client accepte l’offre
4. **Ack** → Le serveur valide l’attribution

---

## 🛠️ Mise en place d’un serveur DHCP

### 🔹 Serveur utilisé : `isc-dhcp-server`

- Avantage : **simple à configurer**, largement utilisé
- Inconvénient : **plus maintenu activement**, mais toujours fonctionnel

### 🔹 Fichiers et services associés

|Élément|Chemin / nom|
|---|---|
|Paquet|`isc-dhcp-server`|
|Fichier de configuration principal|`/etc/dhcp/dhcpd.conf`|
|Interface(s) d’écoute|Configurable dans `/etc/default/isc-dhcp-server`|
|Fichier de baux|`/var/lib/dhcp/dhcpd.leases`|
|Journal|`/var/log/syslog`|
|Service|`isc-dhcp-server` (systemd)|

### 🔹 Exemple de configuration (`/etc/dhcp/dhcpd.conf`)

```bash
ddns-update-style none;
default-lease-time 600;
max-lease-time 7200;
authoritative;

subnet 192.168.100.0 netmask 255.255.255.0 {
  range 192.168.100.100 192.168.100.200;
  option routers 192.168.1.254;
  option domain-name "monreseau.local";
  option domain-name-servers 192.168.100.12;
}

host poste1 {
  hardware ethernet 08:00:27:12:34:56;
  fixed-address 192.168.100.10;
}
```

### 🔹 Vérifications

```bash
dhcpd -t                 # Teste la configuration
systemctl restart isc-dhcp-server
systemctl status isc-dhcp-server
```

---

## 🌐 Mise en place d’un relai DHCP

### 🔹 Pourquoi un relai ?

Le relai DHCP permet aux clients situés **dans un autre domaine de broadcast** de recevoir une IP.

### 🔹 Paquet et fichier de conf

```bash
apt install isc-dhcp-relay
```

Fichier de configuration : `/etc/default/isc-dhcp-relay`

### 🔹 Exemple de configuration

```bash
SERVERS="192.168.100.12"            # IP du serveur DHCP
INTERFACES="ens33 ens36"           # Interfaces côté clients
OPTIONS=""
```

Redémarrage :

```bash
systemctl restart isc-dhcp-relay
```

---

## ✅ À retenir pour les révisions

- Le DHCP fonctionne sur le principe **DISCOVER → OFFER → REQUEST → ACK**
- Le fichier principal est `/etc/dhcp/dhcpd.conf`
- Chaque sous-réseau est défini dans une **section `subnet`** avec ses propres options
- Les **réservations IP** se font via la section `host`, avec adresse MAC et IP fixée
- Le service **isc-dhcp-relay** permet d’atteindre les clients au-delà du domaine local

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Ne pas mélanger DHCP et IP statiques|Éviter les conflits d’adresses|
|Utiliser des plages cohérentes|Répartition logique des postes par rôle ou par zone|
|Commenter chaque bloc `subnet` ou `host`|Faciliter la lecture et la maintenance du fichier|
|Sauvegarder les baux régulièrement|Pour pouvoir récupérer les affectations existantes|
|Surveiller `/var/log/syslog`|Détecter les échecs ou collisions d’attribution|
