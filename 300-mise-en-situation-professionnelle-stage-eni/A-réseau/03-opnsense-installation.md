# 🔧 Installation d’OPNsense

## 📥 Téléchargement et préparation

1. Télécharger l’ISO OPNsense depuis le site officiel : [https://opnsense.org/download/](https://opnsense.org/download/).
2. Choisir l’architecture **amd64**, image **DVD ISO**, et un miroir proche.
3. Créer une nouvelle VM dans **VMware Workstation Pro** :
   - Type : **BSD → FreeBSD 64-bit** (compatible).
   - CPU : 2 vCPU.
   - RAM : 2 Go (minimum, prévoir 4 Go pour confort).
   - Disque : 20 Go (SCSI recommandé).
   - Réseau : **4 cartes** → WAN, LAN Clients, LAN Serveurs, DMZ.

---

## 🌐 Configuration des interfaces (VMware)

- **WAN** : mode **Bridged** sur carte physique → accès Internet (IP : 192.168.1.80/24).
- **LAN Clients** : VMnet3 (Host-Only) → 192.168.52.254/23.
- **LAN Serveurs** : VMnet2 (Host-Only) → 192.168.55.1/25.
- **DMZ** : VMnet4 (Host-Only) → 192.168.56.249/29.

💡 Astuce : nommer les cartes réseau dans VMware pour éviter toute confusion.

---

## 💽 Installation d’OPNsense

1. Démarrer la VM sur l’ISO.
2. Au menu, choisir **Install (UFS)**.
3. Suivre l’assistant :
   - Clavier : **French ISO-8859-1**.
   - Disque : auto (GPT/UEFI).
   - Utilisateur root : définir un mot de passe fort.
4. Redémarrer, retirer l’ISO.

---

## 🔧 Attribution des interfaces

Lors du premier boot :
- `em0` → WAN → 192.168.1.80/24, GW : 192.168.1.1 (box).
- `em1` → LAN Clients → 192.168.52.254/23.
- `em2` → LAN Serveurs → 192.168.55.1/25.
- `em3` → DMZ → 192.168.56.249/29.

Commande en console pour affecter :
```bash
assign interfaces
```

---

## 🌍 Accès web initial

- Depuis un poste client (ex. 192.168.52.10), ouvrir : `https://192.168.52.254:443`.
- Identifiants par défaut :
  - Utilisateur : `root`
  - Mot de passe : celui défini à l’installation.

---

## ⚙️ Configuration initiale (Wizard)

1. Accéder au menu **System → Wizard**.
2. Paramétrer :
   - Hostname : `opnsense`.
   - Domaine : `stage.eni`.
   - DNS servers : 192.168.55.20 (SRV-DC1), 192.168.55.21 (SRV-DC2).
   - Timezone : Europe/Paris.
3. Vérifier l’IP WAN (192.168.1.80/24, GW 192.168.1.1).
4. Appliquer.

---

## 🔐 Services activés

- **DHCP** : désactivé (IP fixes définies dans le plan d’adressage).
- **NTP** : activé, synchronisé avec les DCs.
- **SSH** : désactivé (sauf besoin d’admin avancée).

---

## ✅ Tests de validation

Depuis un poste client (192.168.52.10) :
- Ping passerelle LAN (192.168.52.254).
- Ping DC1 (192.168.55.20).
- `Resolve-DnsName google.com` → doit fonctionner via redirecteur DNS.
- Navigation web (TCP 80/443) → test accès Internet.
- `Test-NetConnection erp.stage.eni -Port 443` → vérifier NAT et accès interne.

---

## 📌 Bonnes pratiques appliquées

- **Segmentation stricte** : 4 interfaces séparées.
- **Désactivation DHCP** : cohérence avec plan IP statique.
- **Sécurité par défaut** : accès SSH limité, firewall deny interzones.
- **Accès via HTTPS** uniquement.
