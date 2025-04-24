# TP 1 & 2 – Le routage avec pfSense

## ✅ TP 1 : Mise en place du routeur RTR-00

### 🔹 1. Installation de pfSense

- Créer une VM avec :
    - 1 disque de 20 Go, 2 Go RAM, 2 CPU
    - 3 interfaces réseau :
        - **em0** : Bridge (WAN, accès Internet)
        - **em1** : Host-only VMnet1 (LAN 1 → 172.16.0.0/16)
        - **em2** : Host-only VMnet2 (LAN 2 → 192.168.0.0/24)

### 🔹 2. Affectation des interfaces

Dans la console pfSense :

```text
1 (assign interfaces)
n (no VLAN)
em0 → WAN
em1 → LAN
em2 → OPT1 (à renommer LAN2)
```

### 🔹 3. Configuration des interfaces LAN

- LAN : `172.16.0.1/16`
- LAN2 (OPT1) : `192.168.0.254/24`

Activer LAN2 depuis l’interface web (pfSense admin) > **Interfaces > OPT1 > Enable**

### 🔹 4. Désactiver les blocages RFC1918 / Bogon

- **Interfaces > LAN / LAN2 > décocher les options** :
    - "Block private networks"
    - "Block bogon networks"

### 🔹 5. Configuration de CLI-00

- Carte réseau sur VMnet2
- IP statique : `192.168.0.10`
- Masque : `255.255.255.0`
- Passerelle : `192.168.0.254`

### 🔹 6. Vérification

```powershell
ping 192.168.0.254   # ✔️ routeur accessible
tracert 172.16.0.1    # ✔️ routeur remonte bien à travers LAN2 > pfSense > LAN
```

---

## ✅ TP 2 : Le réseau global interconnecté

### 🔹 1. Topologie

- **RTR-00** ↔ **RTR-01** ↔ **RTR-02**
- **CLI-00** sur VMnet10 → RTR-00
- **CLI-01** sur VMnet20 → RTR-02

|Machine|Interfaces|IPs attribuées|
|---|---|---|
|CLI-00|VMnet10|192.168.0.10|
|RTR-00|LAN (em1)|192.168.0.1|
|RTR-00|LAN2 (em2)|4.4.4.1|
|RTR-01|LAN (em1)|4.4.4.2|
|RTR-01|LAN2 (em2)|8.8.8.1|
|RTR-02|LAN (em1)|8.8.8.2|
|RTR-02|LAN2 (em2)|172.16.0.1|
|CLI-01|VMnet20|172.16.0.10|

### 🔹 2. Configuration IPs statiques sur chaque routeur

- pfSense WebGUI > **Interfaces > [LAN] > Static IP**
- Exemple pour RTR-00 :
    - LAN : 192.168.0.1/24
    - LAN2 : 4.4.4.1/30

### 🔹 3. Table de routage à configurer

#### RTR-00 (via pfSense > System > Routing > Static Routes)

```text
Réseau : 172.16.0.0/24 → Gateway : 4.4.4.2
```

#### RTR-01

```text
Réseau : 192.168.0.0/24 → Gateway : 4.4.4.1
Réseau : 172.16.0.0/24 → Gateway : 8.8.8.2
```

#### RTR-02

```text
Réseau : 192.168.0.0/24 → Gateway : 8.8.8.1
```

### 🔹 4. Tests de connectivité

```powershell
ping 172.16.0.10     # depuis CLI-00 vers CLI-01 ✔️
ping 4.4.4.2         # depuis RTR-00 ✔️
tracert 172.16.0.10  # montre passage RTR-00 → RTR-01 → RTR-02 ✔️
```

---

## 🧠 À retenir pour les révisions

- pfSense permet de créer facilement des topologies multi-segments
- Chaque routeur doit connaître le **prochain saut** vers les réseaux qu’il ne connaît pas
- L’utilisation de **/30** permet des sous-réseaux point-à-point efficaces
- Le **ping, tracert et arp** sont indispensables pour diagnostiquer la connectivité

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Nommer clairement les interfaces|Facilite le suivi sur pfSense|
|Documenter chaque IP utilisée|Évite les conflits d’adressage|
|Tester chaque segment au fur et à mesure|Localiser rapidement les erreurs|
|Minimiser les routes par défaut|Meilleure visibilité et contrôle du routage|
|Sauvegarder la config pfSense|Permet de restaurer rapidement en cas d'erreur|
