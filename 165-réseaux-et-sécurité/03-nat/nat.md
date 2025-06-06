# Le NAT
## 📃 Introduction au NAT

Le **NAT** (_Network Address Translation_ ou _Translation d'adresses IP_) est une technique réseau permettant de modifier les adresses IP contenues dans les en-têtes des paquets transitant entre différents réseaux.

### Objectifs principaux :

- **Masquer les adresses IP privées** des réseaux internes
- **Réduire la consommation d'adresses IPv4 publiques**
- **Renforcer la sécurité** en limitant l'exposition des hôtes internes

### Fonctionnement

- S'opère au niveau de la **couche Réseau** (couche 3) du modèle OSI
- Traduit les adresses IP **source et/ou destination** des paquets

### Avantages

- Résolution de la pénurie d'adresses IPv4
- Amélioration de la sécurité (masquage de l'architecture interne)
- Simplification de la gestion des changements de FAI / plages d'IP publiques

---

## 📊 Rappel : RFC 1918 et RFC 4291

### RFC 1918 : Adresses privées IPv4 (non routables sur Internet)

|Type|Plage|
|---|---|
|A|10.0.0.0 → 10.255.255.255|
|B|172.16.0.0 → 172.31.255.255|
|C|192.168.0.0 → 192.168.255.255|

### RFC 4291 : Adresses locales uniques IPv6 (ULA)

- **fc00::/7** (non routables sur Internet)

**Remarque :**

- Le NAT est **moins nécessaire en IPv6** grâce à la très grande disponibilité d'adresses.

---

## 🔢 Types de NAT

### 📌 NAPT statique (_Destination NAT_ ou _DNAT_)

- Redirige les requêtes arrivant sur une IP publique vers un hôte interne spécifique (port et adresse).

**Exemple d'usage :** publication d'un serveur Web interne.

### 📌 NAPT dynamique (_Source NAT_ ou _SNAT_)

- Modifie les adresses IP et/ou les ports **source** pour permettre aux hôtes internes d'accéder à Internet en utilisant une adresse publique partagée.

**Exemple d'usage :** navigation Web des postes clients.

---

## 🛏️ NAT sur pfSense

### 📌 Port forwarding (redirection de port)

- Redirige le trafic entrant sur un **port spécifique** vers un serveur interne.
- Utilisé pour exposer des services internes (ex : serveur Web, serveur FTP).

### 📌 NAT 1:1

- Associe une **IP publique** à une **IP privée unique**.
- Permet de rendre totalement accessible un hôte interne via une IP publique.

### 📌 NAT sortant (Outbound NAT)

- Contrôle la façon dont le trafic sortant est traduit.
- Permet par exemple d'utiliser différentes adresses publiques selon les VLANs.

---

## ✅ À retenir pour les révisions

- Le **NAT (Network Address Translation)** modifie les adresses IP dans les paquets réseau
- Il fonctionne en **couche 3** (réseau) du modèle OSI
- Objectifs :
    - Masquer les **adresses IP privées**
    - Économiser les **adresses IPv4 publiques**
    - Renforcer la **sécurité** du réseau interne
- **RFC 1918** → plages d’adresses IPv4 privées
- Deux types principaux :
    - **SNAT (Source NAT)** : pour l’accès **sortant** des clients internes (navigation Internet)
    - **DNAT (Destination NAT)** ou **Port forwarding** : pour publier un service interne vers l’extérieur
- Sur pfSense : 3 types de NAT → **Port forwarding**, **NAT 1:1**, **NAT sortant**
- Les **règles NAT** doivent être documentées et testées → attention à la **cohérence avec les règles de pare-feu**

---

## 📌 Bonnes pratiques professionnelles

- Toujours documenter les règles NAT mises en place.
- Restreindre le NAT aux flux nécessaires.
- Contrôler et limiter les redirections de ports pour minimiser la surface d'attaque.
- Tester systématiquement les règles de NAT après déploiement.
- Éviter de dépendre inutilement du NAT en IPv6.

---

## ⚠️ Pièges à éviter

- Créer des redirections trop larges ("any-any")
- Oublier de mettre à jour les règles NAT lors de modifications du réseau interne.
- Mal comprendre le comportement de NAT sortant automatique vs manuel.
- Ne pas vérifier les **retours de flux** (asymétrie de routage).

---

## ✅ Commandes utiles (diagnostic NAT)

### Sous pfSense (menu Web / Diagnostics)

- **Diagnostic → States** : Visualiser les connexions NATées.
- **Diagnostic → Packet Capture** : Analyser le trafic NATé.
- **Diagnostics → NAT Table** : Voir les translations actives.

### En ligne de commande (exemple Linux)

```bash
# Afficher les connexions NAT (iptables)
sudo iptables -t nat -L -v -n

# Sur un pfSense (console root)
pfctl -sn    # Affiche les règles NAT
pfctl -si    # Statistiques NAT
```
