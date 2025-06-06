# Rappels de notions sur le réseau
## 📚 Modèle OSI

Le modèle **OSI (Open Systems Interconnection)** est un modèle théorique en 7 couches qui sert à représenter et standardiser les communications entre systèmes en réseau. Il est proposé par l'**ISO** (_International Organization for Standardization_).

### Les 7 couches OSI

|Couches|Rôle principal|Protocoles / Matériels associés|
|---|---|---|
|**Application**|Point d'accès au réseau. Communication entre applications / utilisateur.|FTP, HTTP, HTTPS, SMTP, SSH, IMAP, LDAP, RDP, DNS, DHCP, SNMP|
|**Présentation**|Traduction, (dé)chiffrement, (dé)compression.|-|
|**Session**|Authentification, synchronisation, création de points de contrôle.|-|
|**Transport**|Communication de bout en bout entre applications. Contrôle de flux, segmentation.|TCP, UDP|
|**Réseau**|Routage, adressage logique (IPv4 / IPv6).|Protocoles IP, routeurs|
|**Liaison**|Communication entre nœuds adjacents. Contrôle d'erreurs. Adressage physique (MAC).|Switchs|
|**Physique**|Transmission du signal. Conversion en bits.|Câbles, fibres optiques, hubs|

### Protocol Data Unit (PDU)

- Une **PDU** est une unité de données échangées sur un réseau.
- Elle contient :
    - **PCI** (Protocol Control Information)
    - **SDU** (Service Data Unit)

---

## 🛠️ Rappel de commandes utiles

### Windows (netstat, tracert, telnet)

#### `netstat`

|Commande|Description|
|---|---|
|`netstat -a`|Connexions TCP actives + ports en écoute|
|`netstat -b`|Connexions avec processus associés|
|`netstat -p proto`|Connexions d'un protocole spécifique|
|`netstat -E`|Statistiques Ethernet|
|`netstat -r`|Table de routage|
|`netstat -s`|Statistiques par protocole|

#### `tracert`

|Commande|Description|
|---|---|
|`tracert <IP/nom>`|Trace le chemin des paquets|
|`tracert -4 <IP/nom>`|Force l'utilisation d'IPv4|

#### `telnet`

|Commande|Description|
|---|---|
|`telnet <IP/nom> <port>`|Tester la connectivité sur un port|
|Exemples : `telnet www.exemple.com 80`||

### Linux (ss, traceroute, telnet, nmap)

#### `ss` (remplaçant de netstat)

|Commande|Description|
|---|---|
|`ss -ut`|Connexions TCP et UDP actives|
|`ss -a`|Toutes les connexions en écoute et établies|
|`ss -n`|Adresses IP et ports numériques|
|`ss -p`|Processus liés aux connexions|
|`ss -l`|Sockets en écoute uniquement|

#### `traceroute`

|Commande|Description|
|---|---|
|`traceroute <IP/nom>`|Trace le chemin des paquets|
|`traceroute -4 <IP/nom>`|Force IPv4|

#### `nmap`

|Commande|Description|
|---|---|
|`nmap <IP>`|Scan de base|
|`nmap -p 80,443 <IP>`|Scan de ports spécifiques|
|`nmap -p- <IP>`|Scan de tous les ports|
|`nmap -O <IP>`|Détection de l'OS|

---

## 🌐 Notions de flux réseau

### Définition d'un flux

Un **flux** est un ensemble de trafic réseau partageant des caractéristiques communes :

- Source
- Destination
- Protocole
- Port

### Exemple de socket TCP/IP

|Client|Serveur|
|---|---|
|IP source : 192.168.5.55Port : 52519 (dynamique)|IP destination : 185.42.28.200Port : 443 (HTTPS)|

### Matrice de flux (bonnes pratiques ANSSI)

- Segmenter le réseau en zones de confiance.
- Utiliser une DMZ pour les services exposés.
- Filtrer les flux interzones avec des pare-feux.
- Documenter les flux dans une **matrice de flux**.
- Appliquer le principe du moindre privilège.
- Chiffrer les flux sensibles.
- Surveiller et analyser les logs.
- Maintenir à jour les équipements réseau.

### Ressource complémentaire

[**SecNumAcademie - MOOC ANSSI**](https://secnumacademie.gouv.fr/auth/register/fr) : formation gratuite en cybersécurité.

---

## ✅ À retenir pour les révisions

- Le modèle **OSI** décompose la communication réseau en **7 couches** distinctes
- Les **adresses IP** identifient logiquement les machines, les **adresses MAC** identifient physiquement les interfaces réseau
- Un **flux réseau** est défini par la combinaison **IP source/destination + protocole + ports**
- La **matrice de flux** sert à documenter les communications autorisées entre les zones du réseau
- Les commandes essentielles pour diagnostiquer un réseau :
    - `netstat` et `ss` (visualisation des connexions)
    - `traceroute` / `tracert` (chemin emprunté par les paquets)
    - `telnet` / `nmap` (test de connectivité et scan de ports)

---

## 📌 Bonnes pratiques professionnelles

- Toujours documenter les flux (**matrice de flux**).
- Appliquer le **moindre privilège** sur les flux réseau.
- Mettre en place une **DMZ** pour les services exposés.
- Chiffrer les flux sensibles (HTTPS, VPN).
- Maintenir à jour les équipements réseau et surveiller les logs.

---

## ⚠️ Pièges à éviter

- Confondre **adresse IP** et **adresse MAC**.
- Oublier de documenter les flux lors de la mise en place de nouvelles règles.
- Laisser des **ports ouverts** inutilement.
- Mal configurer les pare-feux interzones.

---

## ✅ Commandes utiles

### Sous Windows

```powershell
# Affiche les connexions TCP actives + ports en écoute
netstat -a

# Affiche les connexions avec les processus associés
netstat -b

# Affiche la table de routage
netstat -r

# Trace le chemin réseau en IPv4
tracert -4 www.google.fr

# Teste la connectivité sur le port 80
telnet www.example.com 80
```

### Sous Linux

```bash
# Affiche les connexions TCP et UDP actives
ss -ut

# Affiche toutes les connexions en écoute et établies
ss -a

# Affiche les adresses IP et ports en format numérique
ss -n

# Trace le chemin réseau en IPv4
traceroute -4 www.google.fr

# Détecte l'OS de la cible
nmap -O 192.168.100.100
```
