# DHCP (Dynamic Host Configuration Protocol)

## 📌 Présentation

DHCP est un protocole réseau permettant d’attribuer automatiquement une configuration IP à un client (adresse IP, masque, passerelle, DNS…). Il simplifie la gestion réseau en évitant les configurations manuelles et les conflits d’adresse.

---

## 🧱 Fonctionnement en 4 étapes (DORA)

| Étape | Description |
|-------|-------------|
| **Discover** | Le client envoie une requête de découverte DHCP (broadcast) |
| **Offer** | Le serveur DHCP propose une adresse IP disponible |
| **Request** | Le client demande officiellement cette IP |
| **Acknowledge** | Le serveur confirme l’attribution (ACK) |

---

## 📁 Fichier de configuration Linux (ISC DHCP)
Chemin : `/etc/dhcp/dhcpd.conf`

### Exemple minimal :

```conf
default-lease-time 600;
max-lease-time 7200;
subnet 192.168.52.0 netmask 255.255.255.0 {
  range 192.168.52.100 192.168.52.150;
  option routers 192.168.52.1;
  option domain-name-servers 192.168.52.1;
}
```

---

## 🧰 Commandes utiles

| Commande | Usage |
|----------|-------|
| `sudo systemctl start isc-dhcp-server` | Démarrer le service (Debian/Ubuntu) |
| `sudo systemctl status isc-dhcp-server` | Vérifier l’état du service |
| `journalctl -xe` | Voir les erreurs liées au démarrage |
| `ip a` | Vérifier l’attribution d’une IP client |
| `dhclient` | Forcer la demande DHCP côté client |

---

## 🔎 Cas d’usage courant

- Attribution automatique des adresses aux postes clients
- Segmentation réseau avec un serveur DHCP par VLAN
- Réservation d’IP fixes pour certains équipements (imprimantes, serveurs)
- Déploiement PXE pour l’installation réseau d’OS

---

## 💡 Réservation d’adresse IP fixe

```conf
host imprimante {
  hardware ethernet AA:BB:CC:DD:EE:FF;
  fixed-address 192.168.52.200;
}
```

---

## ⚠️ Erreurs fréquentes

- Mauvais plan d’adressage → conflits d’adresses
- DHCP non autorisé dans certains VLAN → clients non configurés
- Adresse statique en dehors du pool DHCP sans cohérence
- Oubli de démarrer le service ou mauvaise interface définie dans `/etc/default/isc-dhcp-server`

---

## ✅ Bonnes pratiques

- Toujours définir des réservations pour les équipements critiques
- Planifier le pool DHCP pour éviter les chevauchements
- Surveiller les baux DHCP (fichier `dhcpd.leases`)
- Protéger le serveur DHCP contre les intrusions ou faux serveurs (DHCP snooping sur switch manageable)
