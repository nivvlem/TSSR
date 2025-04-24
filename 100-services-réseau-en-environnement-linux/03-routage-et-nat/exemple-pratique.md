# TP 1 & 2 – Routage et NAT sous Debian & pfSense

## ✅ TP 1 – Mise en place d’un routeur sous Debian

### 🔹 Contexte

Création d’un routeur Linux appelé **RouTux**, équipé de 3 interfaces connectées à 3 réseaux :

- **ens33** : VMNet4 – Réseau des clients `172.18.10.0/24`
- **ens36** : VMNet6 – Réseau des serveurs `192.168.10.0/24`
- **ens37** : VMNet2 – Réseau d’interconnexion vers pfSense `172.30.10.0/24`

### 🔹 Étapes de configuration

#### 1. Configuration IP statique persistante

Fichier : `/etc/network/interfaces`

```bash
# VMNet4 – LAN clients
auto ens33
iface ens33 inet static
  address 172.18.10.254
  netmask 255.255.255.0

# VMNet6 – LAN serveurs
auto ens36
iface ens36 inet static
  address 192.168.10.254
  netmask 255.255.255.0

# VMNet2 – Lien vers pfSense
auto ens37
iface ens37 inet static
  address 172.30.10.254
  netmask 255.255.255.0
```

#### 2. Redémarrage du service réseau

```bash
systemctl restart networking
```

#### 3. Activation du routage IP

```bash
# Modifier sysctl.conf pour rendre le routage permanent
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sysctl -p
```

#### 4. Configuration des machines clientes/serveurs

- **CLI-DB-12** → Passerelle : `172.18.10.254`
- **DEB-S1 / DEB-S2** → Passerelle : `192.168.10.254`

#### 5. Vérifications

```bash
ping 192.168.10.11      # depuis le client vers serveur
ping 172.18.10.10       # depuis le serveur vers client
```

✔️ Les machines sont désormais capables de communiquer inter-réseaux grâce au routage Debian.

---

## ✅ TP 2 – Intégration d’un routeur NAT avec pfSense

### 🔹 Objectif

Permettre l’accès à un réseau simulé (Internet) via un **routeur NAT pfSense**, en lien avec RouTux.

### 🔹 Étapes de mise en œuvre

#### 1. Étendre la connectivité du poste client

- Ajouter à `CLI-DB-12` une **2e interface sur VMNet2**
- IP statique attribuée : `172.30.10.10/24`

#### 2. Déploiement et configuration de pfSense

- 2 interfaces :
    - **LAN (VMNet2)** → `172.30.10.1`
    - **WAN (bridge ou NAT)** → IP locale fournie par le FAI (ou box)

#### 3. Accès à l’interface Web pfSense

```bash
https://172.30.10.1   # depuis CLI-DB-12
```

#### 4. Ajout des routes statiques

Dans pfSense :

- **System > Routing > Static Routes**

```text
Réseau : 172.18.10.0/24 → via 172.30.10.254
Réseau : 192.168.10.0/24 → via 172.30.10.254
```

#### 5. Vérification du NAT (automatique par défaut)

- Vérifier dans **Firewall > NAT > Outbound** : Mode = Automatic
- Vérifier dans **Firewall > Rules > LAN** : Autoriser le trafic (source : any)

#### 6. Configuration DNS sur les postes clients

```bash
nameserver 9.9.9.9
```

#### 7. Routage par défaut côté RouTux

Dans l’interface `ens37` :

```bash
post-up ip route add default via 172.30.10.1
```

Redémarrer :

```bash
systemctl restart networking
```

#### 8. Tests de connectivité et résolution DNS

```bash
ping 9.9.9.9                  # Test NAT
ping ftp.fr.debian.org        # Test DNS
```

✔️ L’ensemble du LAN accède désormais à Internet via pfSense.

---

## ✅ Vérifications finales

- Routage inter-réseaux : ✅ entre clients et serveurs
- Sortie Internet simulée via pfSense : ✅
- Résolution DNS opérationnelle sur chaque machine
- Passerelles et routes par défaut correctement configurées

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Activer `ip_forward` dans `/etc/sysctl.conf`|Pour transformer un hôte Debian en routeur complet|
|Vérifier le routage avec `traceroute`|Permet de localiser une rupture dans le chemin réseau|
|Sauvegarder les configs pfSense régulièrement|Reprise rapide en cas de corruption / redémarrage|
|Utiliser des IP cohérentes et documentées|Facilite le débogage et la gestion du parc|
|Tester chaque segment séparément|Identification claire de l’origine d’un dysfonctionnement|
