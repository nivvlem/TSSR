# Le NAT (Network Address Translation)
## 🧩 Qu’est-ce que le NAT ?

### Définition

Le **NAT** (Network Address Translation) est une technique permettant de **faire correspondre des adresses IP privées internes avec des adresses IP publiques** pour permettre la communication entre un réseau privé et Internet.

Utilisé pour :

- **Masquer les adresses internes**
- Permettre l’accès à Internet depuis des adresses privées (RFC1918)
- **Économiser des adresses IPv4 publiques**
- Protéger l’architecture interne

### Adresses privées IPv4 (RFC1918)

|Classe|Plage d’adresses|CIDR|
|---|---|---|
|A|10.0.0.0 – 10.255.255.255|/8|
|B|172.16.0.0 – 172.31.255.255|/12|
|C|192.168.0.0 – 192.168.255.255|/16|

---

## 🔄 Types de NAT

### 1️⃣ NAT statique

- **Association fixe** entre une adresse IP publique et une adresse privée
- Exemple :

```text
WAN IP 92.66.31.250:443 → LAN SRV-WEB:443
```

- Utilisé pour **exposer un service précis** à l’extérieur (Web, RDP, Mail…)

### 2️⃣ NAT dynamique

- Association temporaire d’une adresse privée à une adresse publique
- Plusieurs IP privées peuvent partager une même IP publique

### 3️⃣ PAT (Port Address Translation)

- Variante de NAT dynamique
- Traduction de l’adresse ET des **ports** :

```text
LAN IP 192.168.1.10:55555 → WAN IP 92.66.31.250:12345
```

- Permet à plusieurs machines internes d’utiliser **la même IP publique**

---

## 🚦 Fonctionnement du NAT

### Flux sortant (NAT source)

- La machine interne envoie une requête → translation par le routeur pfSense → Internet
- Au retour, pfSense redirige la réponse vers la bonne machine privée

### Flux entrant (Port forwarding)

- Requête Internet (ex: HTTPS) reçue sur pfSense → redirection vers le serveur privé concerné

### NAT WAN-WAN

- Association directe : IP publique → IP interne, sans changer les ports
- Sert pour du **multi-IP** ou du **multi-service** sur des IP distinctes

### NAT sortant

- Par défaut **automatique** sur pfSense : tout le LAN sort avec l’IP WAN
- Peut être personnalisé (hybride ou manuel)

---

## 🛠️ Configuration du NAT sur pfSense

### Interface

**Firewall > NAT**

### Transfert de port (Port Forward)

1. Interface : généralement WAN
2. Protocole : TCP, UDP, ou les deux
3. Destination : Adresse WAN
4. Redirection vers IP privée (SRV interne) + port

### Exemple : Redirection RDP (TP)

|Paramètre|Valeur|
|---|---|
|Interface|WAN|
|Protocole|TCP|
|Port externe|3389|
|IP interne|SRV-MBR (alias)|
|Port interne|3389|

### Alias pfSense

- Groupes d’IP, de ports ou de réseaux utilisés pour simplifier les règles NAT et Firewall
- Exemple : `Alias_SRV-MBR` → IP du serveur SRV-MBR

### NAT WAN-WAN

**Firewall > NAT > 1:1 NAT**

- Permet de mapper directement IP publique → IP privée

### NAT sortant

**Firewall > NAT > Outbound**

- Mode automatique (défaut)
- Mode hybride → permet d’ajouter des règles manuelles en plus de l’automatique
- Mode manuel → gestion 100% manuelle des règles NAT sortant

---
### Commandes utiles (Linux)

```bash
# Test connectivité NAT sortant
traceroute 8.8.8.8

# Vérification port ouvert (depuis client externe)
nmap -p 3389 [WAN IP]
```

---

## ✅ À retenir pour les révisions

- Le NAT permet de **connecter des réseaux privés au WAN** tout en contrôlant les flux
- Le **NAT statique** sert à exposer des services spécifiques
- Le **PAT** optimise l’usage des IP publiques
- **pfSense** simplifie grandement la gestion des NAT : Port Forward, NAT 1:1, NAT sortant
- Bien **documenter les redirections** est essentiel pour le maintien de la sécurité

---

## 📌 Bonnes pratiques professionnelles

- Toujours commencer par un **schéma réseau clair**
- Utiliser des **alias** pour simplifier la maintenance
- Ne rediriger que les **ports et services nécessaires**
- **Limiter les IP sources autorisées** sur les redirections WAN
- Tester systématiquement après chaque modification (interne + externe)
- **Documenter** toute règle de NAT et de FW en parallèle pour cohérence
- Prévoir une **revue régulière des NAT configurés** pour éviter les configurations obsolètes ou inutiles