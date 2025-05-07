# Gestion du réseau sur Debian GNU/Linux

## 🌐 Prise d’informations réseau (CLI)

### 📡 Affichage des interfaces et IPs

```bash
ip a      # ou ip address
```

### 📍 Affichage des routes

```bash
ip r      # ou ip route
```

### 🔎 Résolution DNS

```bash
cat /etc/resolv.conf
```

Exemple de contenu :

```ini
search mondomaine.fr
nameserver 10.1.2.20
nameserver 10.1.2.21
```

---

## 🧱 Configuration réseau sans interface graphique (serveur)

### 📁 Fichier de configuration : `/etc/network/interfaces`

#### 📦 DHCP (configuration automatique)

```ini
# Boucle locale
auto lo
iface lo inet loopback

# Interface Ethernet
auto ens33
allow-hotplug ens33
iface ens33 inet dhcp
```

#### 📦 Statique (configuration manuelle)

```ini
auto lo
iface lo inet loopback

auto ens33
iface ens33 inet static
  address 10.1.1.10
  netmask 255.255.0.0
  gateway 10.1.255.254
```

### 📁 Configuration des DNS (résolveur)

```ini
# /etc/resolv.conf
search mondomaine.fr
nameserver 10.1.2.20
nameserver 10.1.2.21
```

### 🛠️ Redémarrer le service réseau

```bash
systemctl restart networking.service
```

Autres commandes : `stop`, `start`

---

## 🖥️ Configuration réseau avec interface graphique (Desktop)

### 🧩 NetworkManager (outil de gestion réseau)

- Présent dans Gnome, KDE, XFCE…
- Gestion graphique ou via ligne de commande

### 🛠️ Relancer NetworkManager

```bash
systemctl restart NetworkManager
```

---

## ✅ À retenir pour les révisions

- `ip a`, `ip r` : commandes modernes pour l’info IP/réseau
- `/etc/network/interfaces` : config réseau manuelle (mode serveur)
- `/etc/resolv.conf` : config DNS
- `systemctl restart networking.service` : prise en compte des modifications
- NetworkManager gère le réseau sur les postes graphiques

---

## 📌 Bonnes pratiques professionnelles

- Toujours vérifier les interfaces actives avant modification (`ip a`)
- Utiliser des IP statiques sur les serveurs (cohérence et disponibilité)
- Sauvegarder les fichiers `/etc/network/interfaces` avant modification
- Documenter la structure réseau (IP, masque, passerelle, DNS)
- Redémarrer les services plutôt que l’ensemble de la machine

---

## 🔗 Commandes utiles

```bash
ip a           # Affiche les interfaces IP
ip r           # Affiche la table de routage
systemctl restart networking.service   # Redémarre la configuration réseau
cat /etc/resolv.conf   # Affiche la config DNS
```

## Ressources complémentaires

- [Debian Network Configuration](https://wiki.debian.org/NetworkConfiguration)