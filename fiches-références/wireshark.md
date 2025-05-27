# Wireshark (Analyseur de paquets réseau)

## 📌 Présentation

**Wireshark** est un outil open source d’analyse de trames réseau. Il permet de **capturer, visualiser et filtrer** le trafic réseau en temps réel ou à partir d’un fichier `.pcap`. C’est un incontournable en diagnostic réseau, sécurité, formation et développement réseau.

---

## 🔧 Installation
### Linux (Debian/Ubuntu)

```bash
sudo apt install wireshark
```
### Windows / macOS

- Téléchargement depuis : [https://www.wireshark.org](https://www.wireshark.org)

> ⚠️ Sous Linux, ajouter l’utilisateur au groupe `wireshark` si nécessaire (`sudo usermod -aG wireshark <user>`)

---

## 🧰 Fonctions principales

| Fonction | Description |
|----------|-------------|
| Capture | Sur une ou plusieurs interfaces réseau |
| Filtres d'affichage | Pour extraire les paquets pertinents (`http`, `ip.addr == 192.168.1.1`, etc.) |
| Analyse des protocoles | TCP, UDP, DNS, HTTP, SIP, ARP, ICMP, TLS… |
| Suivi de flux | Reconstruction des conversations TCP |
| Export / Import | Fichiers `.pcap`, `.pcapng` partagés entre outils |

---

## 🔍 Filtres Wireshark utiles

| Filtre | Usage |
|--------|-------|
| `ip.addr == 192.168.1.10` | Voir tout le trafic d’une IP |
| `tcp.port == 443` | Voir tout le trafic HTTPS |
| `http.request` | Voir toutes les requêtes HTTP |
| `icmp` | Voir les ping (ICMP Echo Request / Reply) |
| `dns` | Affiche les requêtes DNS |
| `tcp.stream eq 1` | Affiche uniquement le flux TCP n°1 |

---

## 🔎 Cas d’usage courant

- Diagnostiquer une **perte de connectivité** ou lenteur
- Voir si un client tente de contacter un serveur DNS ou HTTP
- Analyser le contenu d’un échange HTTP, DNS, FTP, TLS
- Visualiser une **attaque réseau** (scan, flood, injection…)
- Suivre le **processus d’authentification** (Kerberos, NTLM…)

---

## ⚠️ Erreurs fréquentes

- Oublier de **lancer en root/admin** pour capturer (Linux)
- Ne pas utiliser les **bons filtres** : trop large = illisible, trop strict = vide
- Mal interpréter un SYN/ACK comme un échange complet
- Utiliser Wireshark sur un réseau en production **sans autorisation** → intrusion grave

---

## ✅ Bonnes pratiques

- Capturer **le moins de trafic possible** avec des filtres d’interface ou capture (`tcp port 443 and host 192.168.1.5`)
- Analyser le trafic **hors ligne** avec des fichiers `.pcap`
- Annoter et exporter les flux pour les réutiliser dans des rapports
- Coupler avec **tshark** en ligne de commande (scripts ou captures en headless)

---

## 📚 Ressources complémentaires

- [Site officiel Wireshark](https://www.wireshark.org/)
- `man tshark`, `wireshark -h`
