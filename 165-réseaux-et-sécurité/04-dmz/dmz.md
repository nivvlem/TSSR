# La DMZ (Demilitarized Zone)
## 🧩 Définition et rôle de la DMZ

### Qu’est-ce qu’une DMZ ?

- **Zone Démilitarisée** dans l’architecture réseau
- Sous-réseau isolé où l’on héberge les services **accessibles depuis Internet**
- Fait le lien entre le WAN (Internet) et le LAN (réseau interne sécurisé)

### Objectif

- **Protéger le réseau interne** des attaques venant d’Internet
- Offrir un **espace tampon** pour les services publics (web, mail, DNS, FTP…)

### Illustration typique

```text
Internet → Routeur WAN → [DMZ] → Serveur WEB
                         ↘ LAN (protégé)
```

---

## 🚀 Avantages de la DMZ

|Avantage|Détail|
|---|---|
|Isolation des services|Empêche l’accès direct au LAN|
|Réduction de la surface d’attaque|Moins de risques sur les services critiques internes|
|Gestion fine des flux|Politiques firewall séparées DMZ ↔ LAN|
|Meilleure visibilité|Surveillance spécifique des flux DMZ|

---

## ⚠️ Impacts et limites

- L’ajout d’une DMZ augmente la **complexité** de l’architecture
- Légère **latence** possible due au filtrage supplémentaire
- Nécessite une bonne **gestion des règles firewall** pour éviter les erreurs (trop ouvert / trop fermé)

---

## 🛠️ Services typiquement hébergés en DMZ

|Service|Exemple|
|---|---|
|Web|Serveurs HTTP/HTTPS public|
|DNS|Serveur DNS autoritaire pour les zones publiques|
|FTP|Serveur de dépôt externe|
|Mail|Relai SMTP entrant/sortant|
|Proxy|Reverse Proxy (ex: Nginx)|

> Ces services doivent être **durcis** et régulièrement **mis à jour**.

---

## 🔐 Configuration d’une DMZ avec pfSense

### 1️⃣ Architecture

- Interface dédiée sur pfSense (ex: OPT1 / LAN2 / DMZ)
- VLAN dédié possible
- Schéma réseau clair documenté

### 2️⃣ Règles de filtrage typiques

|Sens|Action|
|---|---|
|WAN → DMZ|Redirection NAT vers services autorisés (port forwarding)|
|DMZ → WAN|Flux sortants strictement limités|
|DMZ → LAN|**Interdit** ou très contrôlé (ex: logs vers serveur interne)|

### 3️⃣ NAT et redirection

- NAT **port forwarding** pour les services exposés :

```text
WAN IP :443 → SRV-WEB DMZ IP :443
```

### 4️⃣ Alias

- Utilisation d’**alias** pfSense pour simplifier les règles
    - Exemple : alias `SRV-DMZ-WEB` → IP SRV-WEB

---

## 🛡️ Systèmes de détection et de protection complémentaires

### IDS / IPS

|Système|Fonction|
|---|---|
|IDS (Intrusion Detection System)|Détecte les anomalies, alerte|
|IPS (Intrusion Prevention System)|Bloque les flux malveillants en temps réel|

### EDR / XDR / MDR

|Système|Fonction|
|---|---|
|EDR (Endpoint Detection and Response)|Protection avancée des postes client|
|XDR (Extended Detection and Response)|Vue croisée des équipements (endpoint, réseau, cloud)|
|MDR (Managed Detection and Response)|Service managé externe (SOC-as-a-Service)|

### Bastion

- Serveur d’accès sécurisé pour les flux d’administration
- Point d’entrée unique contrôlé
- Exemples : SSH Jump Host, Bastion RDP

### Zero Trust Network Access (ZTNA)

- Approche “**ne jamais faire confiance**”, vérification systématique
- Réduction des risques liés aux accès internes/externes

---

## ✅ À retenir pour les révisions

- La DMZ est une **zone tampon** entre Internet et le LAN
- Les flux entre DMZ ↔ LAN doivent être **très contrôlés**
- Le placement des services en DMZ doit être **justifié** et documenté
- pfSense permet de gérer efficacement DMZ, NAT, alias et filtrage
- IDS/IPS, EDR, ZTNA et bastion renforcent cette approche

---

## 📌 Bonnes pratiques professionnelles

- **Documenter** l’architecture DMZ et ses flux autorisés
- Toujours adopter une **politique restrictive**
- **Segmenter physiquement** ou logiquement la DMZ (interface/vlan dédié)
- Mettre en place une **supervision spécifique** des services DMZ
- Appliquer les mises à jour **régulièrement** sur les serveurs exposés
- Journaliser tous les accès DMZ et surveiller les logs IDS/IPS
- Auditer régulièrement la **cohérence entre documentation et configuration réelle**