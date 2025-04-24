# 🖥️ Les premières commandes réseau

## 🧾 Commande `IPCONFIG` (Windows)

### Rôles :

- Affiche la configuration IP des interfaces réseau
- Gère les baux DHCP

### Commandes utiles :

|Commande|Fonction|
|---|---|
|`ipconfig`|Affiche les infos réseau de base|
|`ipconfig /all`|Affiche toutes les infos (DNS, DHCP, passerelle…)|
|`ipconfig /renew`|Renouvelle un bail DHCP|
|`ipconfig /release`|Libère un bail DHCP|
|`ipconfig /displaydns`|Affiche le cache DNS|
|`ipconfig /flushdns`|Vide le cache DNS|

---

## 🧾 Commande `IP` (Debian)

### Commandes utiles :

|Commande|Fonction|
|---|---|
|`ip a` ou `ip addr`|Affiche les adresses IP|
|`ip -4 addr`|Affiche uniquement les adresses IPv4|
|`ip addr add @IP/CIDR dev eth0`|Attribue une IP à une interface|
|`ip link set dev eth0 up/down`|Active/désactive une interface|

---

## 📡 Commande `PING`

### Rôle : tester la **connectivité réseau** via ICMP

### Windows & Linux :

|Commande|Effet|
|---|---|
|`ping @IP`|Envoie 4 paquets ICMP par défaut|
|`ping -n X @IP` (Win)|Effectue X tentatives|
|`ping -t @IP` (Win)|Ping en continu|
|`ping -c X @IP` (Linux)|Effectue X tentatives (équivalent à -n sous Windows)|

### Cas d’erreurs fréquents :

- Pas de réponse → hôte indisponible / pare-feu actif / pas de route connue

---

## 🔍 Commande `ARP`

### Rôle : associer une **adresse IP à une adresse MAC**

### Windows :

|Commande|Fonction|
|---|---|
|`arp -a`|Affiche la table ARP|
|`arp -s IP MAC`|Ajoute une entrée statique|
|`arp -d`|Supprime toutes les entrées ARP|

### Debian :

|Commande|Fonction|
|---|---|
|`arp -n`|Affiche les IP/MAC|
|`arp -a -i eth0`|Affiche les entrées pour une interface|

---

## 🛰️ Commande `TRACERT` / `TRACEROUTE`

### But : déterminer le **chemin réseau** jusqu'à une destination

- `tracert @IP` (Windows)
- `traceroute @IP` (Linux)

📌 Affiche la liste des **routeurs traversés**

---

## 📊 Commandes `NETSTAT` et `SS`

### Windows – `netstat`

|Commande|Fonction|
|---|---|
|`netstat -a`|Connexions TCP/UDP actives et ports en écoute|
|`netstat -b`|Affiche les processus associés|
|`netstat -r`|Affiche la table de routage|
|`netstat -s`|Statistiques par protocole|

### Debian – `netstat` / `ss`

|Commande|Fonction|
|---|---|
|`netstat -i`|Statistiques Ethernet|
|`ss -t`|Affiche les connexions TCP|
|`ss -u`|Affiche les connexions UDP|

---

## 🧪 Démo Packet Tracer – Utilisation des commandes

1. **IPCONFIG** : observer l'absence ou la présence de config IP sur les PCs
2. **PING** : vérifier la connectivité, tester différentes plages
3. **ARP** : voir les entrées générées automatiquement après un ping
4. **TRACERT** : voir les routeurs traversés (ex : jusqu’au serveur DNS)
5. **NETSTAT** : observer les connexions actives (ex : lors de la navigation Web)

---

## 📘 À retenir pour les révisions

- `ipconfig`/`ip` = état de la config réseau
- `ping` = tester la **présence** d’un hôte (ICMP)
- `arp` = associe une IP à une **adresse MAC** connue
- `tracert`/`traceroute` = affiche les **sauts réseau**
- `netstat`/`ss` = analyse **ports ouverts**, connexions et table de routage

## 🧑‍💼 Bonnes pratiques professionnelles

- Tester la **boucle locale** d’un poste (`ping 127.0.0.1`) avant toute autre commande
- Utiliser `ping` → `tracert` → `arp` pour diagnostiquer un souci réseau
- Vérifier que les réponses ICMP sont **autorisées dans le pare-feu**
- Utiliser `netstat` ou `ss` pour **détecter les services actifs** sur une machine
