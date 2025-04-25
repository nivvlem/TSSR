# Adressage réseau (Linux / Debian)

## 🧭 Nommage des interfaces réseau

### 🔹 Nouveau nommage (via `systemd`)

- Loopback : `lo`
- Interfaces réseau : `ensX`, `enpXsY`, etc.
- Ancien format : `ethX`

> 🔧 Le nom dépend du matériel détecté (BIOS, PCI, etc.)

---

## 🛠️ Méthodes de configuration réseau

### 🔹 A. Commande `ip`

- Méthode **temporaire** (non persistante)
- Commandes principales :

```bash
ip a                # Affiche les interfaces et IP
ip link set ens33 up/down   # Active/désactive une interface
ip addr add 192.168.0.10/24 dev ens33   # Ajoute une IP
```

- Supprimer une IP : `ip addr del ...`
- Table de routage : `ip r`

### 🔹 B. Fichier `/etc/network/interfaces`

- Méthode **persistante** (active au redémarrage)
- Exemple de configuration statique :

```bash
auto ens33
iface ens33 inet static
  address 192.168.0.10/24
  gateway 192.168.0.1
```

- Pour un DHCP :

```bash
auto ens37
iface ens37 inet dhcp
```

- Redémarrer le réseau :

```bash
sudo systemctl restart networking
```

### 🔹 C. NetworkManager (nmcli / nmtui)

- Interface moderne pour la configuration réseau
- Outils :

```bash
nmcli device status
nmcli connection show
nmtui   # Interface semi-graphique (console)
```

- Exemple d’attribution IP avec nmcli :

```bash
nmcli con mod ens33 ipv4.addresses 192.168.1.20/24
nmcli con mod ens33 ipv4.gateway 192.168.1.1
nmcli con up ens33
```

---

## 🌐 Passerelle par défaut

- Visualiser : `ip r`
- Définir via :
    - `gateway` dans `/etc/network/interfaces`
    - `nmcli con mod ... ipv4.gateway ...`
    - `ip route add default via 192.168.1.1`

---

## 🖥️ Nom d’hôte (hostname)

### 🔹 Définition

- Le nom court ou FQDN de la machine
- Doit être **résolvable localement**

### 🔹 Fichiers à modifier

- `/etc/hostname` : contient le nom court
- `/etc/hosts` : associe le nom à l’IP locale

### 🔹 Commandes utiles

```bash
hostname        # Affiche le nom courant
hostnamectl set-hostname srv1
```

---

## 🧩 Client DNS

### 🔹 Méthodes de configuration

- Fichier `/etc/resolv.conf`

```bash
nameserver 8.8.8.8
search mondomaine.local
```

- Paramétré aussi par DHCP ou `nmcli`
- Attention : DHCP peut **écraser `/etc/resolv.conf`**

### 🔹 Ordre de résolution : `/etc/nsswitch.conf`

```bash
hosts: files mdns4_minimal dns myhostname
```

- Ordre :
    1. `/etc/hosts`
    2. mDNS (.local)
    3. Serveurs DNS classiques
    4. Nom local de la machine

---
## ✅ À retenir pour les révisions

- `ip` : outil de configuration **temporaire** pour tester rapidement sans reboot
- `/etc/network/interfaces` : configuration **persistante** (Debian/Ubuntu server)
- `nmcli`, `nmtui` : outils modernes compatibles NetworkManager (Desktop/GUI)
- Toujours valider les fichiers de configuration avant redémarrage
- `hostname`, `resolv.conf`, `nsswitch.conf` : indispensables pour une résolution correcte
- La passerelle est indispensable pour accéder à d’autres réseaux

---
## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Nommer clairement chaque interface et config|Facilite la documentation et le support|
|Tester chaque méthode indépendamment|Évite les conflits entre méthodes concurrentes|
|Sauvegarder `/etc/network/interfaces` avant modification|Revenir rapidement en cas d’erreur|
|Maîtriser `ip`, `nmcli`, et les fichiers clés|Flexibilité selon le contexte et la distribution|
|Contrôler le DNS via `dig`, `nslookup`, `ping`|Valider la résolution de noms à chaque étape|
