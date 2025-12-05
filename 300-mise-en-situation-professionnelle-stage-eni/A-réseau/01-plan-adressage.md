# 📘 Plan d’adressage réseau

## 🌐 Segmentation des réseaux

| Zone          | Réseau             | Masque            | Passerelle (OPNsense) | Remarques |
|---------------|--------------------|-------------------|-----------------------|-----------|
| **LAN Clients**   | 192.168.52.0/23     | 255.255.254.0      | 192.168.52.254        | Jusqu’à 400 hôtes (PC fixes, laptops, imprimantes, téléphones IP, smartphones). |
| **LAN Serveurs**  | 192.168.55.0/25     | 255.255.255.128    | 192.168.55.1          | Réservé aux serveurs Windows et Linux internes. |
| **DMZ**           | 192.168.56.248/29   | 255.255.255.248    | 192.168.56.249        | Serveurs exposés (Web, DNS cache). |
| **WAN**           | 192.168.1.0/24      | 255.255.255.0      | 192.168.1.80          | Sortie vers Internet via box domestique. |

---

## 🖥️ Adressage des serveurs

### 🔹 Serveurs Windows

| Nom      | Rôle                  | IP              | DNS Primaire | DNS Secondaire |
|----------|-----------------------|-----------------|--------------|----------------|
| SRV-DC1  | AD DS / DNS / PKI     | 192.168.55.20   | 55.20        | 55.21 |
| SRV-DC2  | AD DS secondaire      | 192.168.55.21   | 55.21        | 55.20 |
| SRV-ERP  | ERP (IIS/HTTPS)       | 192.168.55.22   | 55.20        | 55.21 |
| SRV-DFS  | DFS Namespace         | 192.168.55.23   | 55.20        | 55.21 |
| SRV-WSUS | WSUS (mises à jour)   | 192.168.55.24   | 55.20        | 55.21 |
| SRV-RDS  | Remote Desktop        | 192.168.55.25   | 55.20        | 55.21 |

### 🔹 Serveurs Linux

| Nom       | Rôle                  | IP              | DNS |
|-----------|-----------------------|-----------------|-----|
| SRV-FILES | Partages Samba        | 192.168.55.26   | 55.20 / 55.21 |
| SRV-DB    | MariaDB               | 192.168.55.27   | 55.20 / 55.21 |
| SRV-GLPI  | GLPI (Apache/PHP)     | 192.168.55.28   | 55.20 / 55.21 |
| SRV-ZABBIX| Supervision           | 192.168.55.29   | 55.20 / 55.21 |

### 🔹 DMZ

| Nom     | Rôle                   | IP              | DNS |
|---------|------------------------|-----------------|-----|
| SRV-DNS | DNS cache / redirecteur| 192.168.56.250  | 127.0.0.1 / 55.20 |
| SRV-WEB | Apache/PHP (WordPress) | 192.168.56.251  | 56.250 / 55.20 |

---

## 💻 Postes Clients

| Poste        | OS            | Zone        | IP (exemple)   | DNS |
|--------------|--------------|-------------|----------------|-----|
| CLIENTWIN11  | Windows 11    | LAN Clients | 192.168.52.10  | 55.20 / 55.21 |
| CLIENTROCKY  | Rocky Linux 10| LAN Clients | 192.168.52.11  | 55.20 / 55.21 |
| CLIENTDEBIAN | Debian 12     | LAN Clients | 192.168.52.12  | 55.20 / 55.21 |

---

## 📌 Réserves d’adressage

- **LAN Serveurs** : 192.168.55.30 – 55.126 (futurs rôles : WDS/MDT, Proxy, sauvegarde, etc.).
- **DMZ** : 192.168.56.252 – 56.254 (reverse proxy, supervision externe, etc.).
- **LAN Clients** : large réserve disponible grâce au /23 (imprimantes, téléphones IP, IoT futurs).

---

## ✅ Bonnes pratiques appliquées

- Segmentation stricte (Clients / Serveurs / DMZ).
- Réserves prévues pour évolutivité.
- Cohérence entre DNS AD et DNS cache (redirecteur en DMZ).
- Plan clair et documenté pour simplifier la supervision et le dépannage.
