# TP – Gestion de la configuration réseau d’un poste
# 🧱 Partie 1 – Serveur Debian **sans interface graphique**

### 📁 Modifier l’adresse IP de la carte `ens33`

```ini
# /etc/network/interfaces
auto lo
iface lo inet loopback

auto ens33
iface ens33 inet static
  address 10.107.200.1
  netmask 255.255.0.0
  gateway 10.107.255.254
```

### 📁 Modifier les DNS

```ini
# /etc/resolv.conf
search ad.campus-eni.fr eni-ecole.net
nameserver 10.1.2.20
nameserver 10.1.2.21
```

### 🔁 Redémarrer le service réseau

```bash
sudo systemctl restart networking.service
```

### 📶 Vérification

```bash
ip a
ip r
ping -c 2 dc44-far
ping -c 2 dc35-cdb1
ping -c 2 repos
```

---

## 🧾 Modifier le nom d’hôte

### 🧩 Modifier `/etc/hostname`

```
deb-melvin-01
```

### 🧩 Modifier `/etc/hosts`

```
127.0.1.1    deb-melvin-01    deb-melvin-01
```

### 🔧 Appliquer immédiatement (optionnel)

```bash
hostname deb-melvin-01
```

---

# 🧱 Partie 2 – Ajouter une 2e carte réseau (mode Host-only)

### 🎛️ Paramétrer la carte `ens35` avec une IP statique

```ini
# /etc/network/interfaces
auto ens35
iface ens35 inet static
  address 192.168.100.1
  netmask 255.255.255.0
```

> Pas de passerelle pour cette interface !

### 🔁 Redémarrer le service

```bash
sudo systemctl restart networking.service
```

### 📶 Vérification

```bash
ip a
```

---

# 🧱 Partie 3 – Configuration réseau sous interface graphique (Gnome)

### 1. Basculer en mode graphique

```bash
sudo systemctl isolate graphical.target
```

### 2. Paramétrer l’adresse IP statique de `ens33`

- Aller dans Paramètres > Réseau > engrenage > IPv4
- Choisir le mode **Manuel**
- Renseigner IP (compatible avec `ens33` sur l’autre VM)
- Laisser la passerelle vide

### 3. Renseigner les DNS si nécessaire

- Utiliser la commande :

```bash
nmtui
```

- Désactiver / réactiver l’interface pour prise en compte

### 4. Vérification de la connectivité

```bash
ping -c 2 10.107.200.1       # Vers la 1re VM
ping -c 2 dc44-far           # Vers un hôte ENI
```

---

## ✅ À retenir pour les révisions

- Le fichier `/etc/network/interfaces` configure les interfaces réseau en mode CLI
- `/etc/resolv.conf` permet de définir les serveurs DNS et les domaines recherchés
- `/etc/hostname` et `/etc/hosts` définissent le nom de la machine
- `nmtui` est utile pour configurer NetworkManager en ligne de commande

---

## 📌 Bonnes pratiques professionnelles

- Utiliser une **adresse IP statique sur les serveurs**
- Toujours **vérifier le routage et la résolution DNS** après configuration
- Éviter de mélanger DHCP et IP statique sur une même interface
- Documenter les adresses IP et les noms d’hôte utilisés en salle

---

## 🔗 Commandes utiles

```bash
ip a             # Affiche les interfaces réseau
ip r             # Affiche la table de routage
hostname         # Affiche ou change le nom d’hôte
systemctl restart networking.service
nmtui            # Outil semi-graphique pour config réseau
ping -c 2 nom    # Vérifie la connectivité
```

