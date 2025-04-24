# TP – Adressage réseau (Debian 12)

## 🧪 Étape 1 – Configuration du LAN Clients

### 🔹 VM : `Cli-db-12`

| Paramètre | Valeur                             |
| --------- | ---------------------------------- |
| OS        | Debian 12 avec interface graphique |
| Réseau    | VMNet4                             |
| IP        | 172.18.100.10/24                   |

### 🔹 Actions réalisées

1. **Installation Debian 12** :
    - Version Desktop
    - Interface réseau non configurée à l’installation
2. **Configuration IP avec NetworkManager**

```bash
nmcli con mod "Wired connection 1" ipv4.addresses 172.18.10.10/24 ipv4.method manual
nmcli con up "Wired connection 1"
```

3. **Vérification / modification du hostname**

```bash
nmcli general hostname cli-db-12
```

Ou via `nmtui` → Configuration > Hostname

4. **Vérification IP et connectivité**

```bash
ip a
ping 172.18.10.10
```

---

## 🖥️ Étape 2 – Configuration du LAN Serveurs

### 🔹 VMs : `DEB-S1`, `DEB-S2`

| Paramètre | Valeur               |
| --------- | -------------------- |
| OS        | Debian 12 sans GUI   |
| Réseau    | VMNet6               |
| IPs       | 192.168.100.11 & .12 |

### 🔹 Configuration temporaire avec `ip`

```bash
# Sur DEB-S1
ip addr add 192.168.100.11/24 dev ens33

# Sur DEB-S2
ip addr add 192.168.100.12/24 dev ens33
```

### 🔹 Vérification de la communication

```bash
ping 192.168.100.12   # depuis DEB-S1
```

### 🔹 Nettoyage des interfaces

```bash
ip addr flush dev ens33
```

### 🔹 Configuration persistante

```bash
# Sur DEB-S1
vi /etc/network/interfaces

auto ens33
iface ens33 inet static
  address 192.168.100.11
  netmask 255.255.255.0
```

Même chose pour DEB-S2 avec l’adresse .12

### 🔹 Redémarrage service réseau

```bash
systemctl restart networking.service
```

### 🔹 Configuration hostname

```bash
# Sur DEB-S1
echo "deb-s1" > /etc/hostname
hostname -F /etc/hostname

# Modifier aussi /etc/hosts :
127.0.1.1 deb-s1
```

Même chose sur DEB-S2

---

## 🚧 Étape 3 – Préparation d’un futur routeur (RouTux)

### 🔹 VM : `RouTux`

| Paramètre | Valeur                 |
| --------- | ---------------------- |
| OS        | Debian 12 sans GUI     |
| Réseau    | Aucune carte au départ |

### 🔹 Installation Debian minimal sans GUI

- Ne pas configurer le réseau
- Modifier le hostname :

```bash
echo "routux" > /etc/hostname
hostname -F /etc/hostname
```

---

## ✅ Vérifications finales

- Chaque poste a bien une IP et un nom cohérent
- Les machines dans le **même LAN** communiquent entre elles (ping OK)
- Le hostname est bien défini et reflété dans `/etc/hostname` et `/etc/hosts`
- Le fichier `/etc/network/interfaces` est correct et la config persiste après reboot

---

## 📌 Bonnes pratiques

|Pratique|Pourquoi ?|
|---|---|
|Utiliser `nmcli` pour les postes avec GUI|Interface plus intuitive pour Debian Desktop|
|Tester les IP avant d’écrire dans les fichiers|Évite les redémarrages pour rien|
|Flusher l’interface avant écriture|Pour éviter des doublons lors de la reconfiguration|
|Nommer les postes dès l’installation|Pour clarté des tests et configuration future (DNS...)|
