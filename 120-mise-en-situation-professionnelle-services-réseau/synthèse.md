# Mise en situation professionnelle : Services réseau

## Synthèse

## 🧱 Structure de l'infrastructure

|🌐 Réseau|Adresse|Interface VMNet|
|---|---|---|
|LAN Clients|192.168.52.0/24|VMNet3|
|LAN Serveurs|192.168.55.0/24|VMNet2|
|WAN (ENI)|10.107.0.0/16|Bridged (VMNet0)|

Routeur pfSense : `ROUTEUR-MD` avec IPs .254 sur chaque LAN

---

## 📊 Services déployés

|Rôle|Serveur|OS|Adresse IP|
|---|---|---|---|
|Contrôleur de domaine|SRV-AD-MD|Windows Server|192.168.55.101|
|DNS principal|SRV-SVC-MD|Windows Server|192.168.55.102|
|DNS secondaire|SRV-LNX-MD|Debian|192.168.55.111|
|DHCP principal|SRV-LNX-MD|Debian|192.168.55.111|
|DHCP secondaire|SRV-SVC-MD|Windows Server|192.168.55.102|
|Partages & stockage|SRV-SVC-MD|Windows Server|192.168.55.102|

---

## ⚖️ Bonnes pratiques appliquées

- Utilisation de **pfSense** avec 3 interfaces séparées
- Application du modèle **AGDLP** :
    - `GG_*` : groupes globaux utilisateurs
    - `DL_*` : groupes locaux appliqués sur les ressources partagées
- Application des **GPO filtrées** (sécurité, productivité)
- Configuration DNS avec **zones secondaires + redirecteurs**
- Redondance des services critiques (AD, DHCP, DNS)
- Centralisation de l'administration : RSAT, RDP, WAC

---

## 🕹️ Commandes utiles par service

### 🌐 pfSense (Web)

- Diagnostics > Ping / NAT / DHCP Relay

### 🪧 Debian

```bash
# Adresse IP statique (interfaces classiques)
/etc/network/interfaces

# Restart réseau (Debian)
systemctl restart networking

# DNS : Bind9 zone secondaire
apt install bind9
sudo systemctl restart bind9
```

### 🔧 Windows Server (PowerShell)

```powershell
# Installer des rôles
Install-WindowsFeature DHCP -IncludeManagementTools
Install-WindowsFeature DNS -IncludeManagementTools
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Promouvoir un contrôleur de domaine
dcpromo ou assistant dans le Gestionnaire de serveur

# Tester la réplication AD
repadmin /replsummary

# Tester la résolution DNS
Resolve-DnsName nomdomaine

# GPO
gpupdate /force
gpresult /r
```

---

## ⚠️ Pièges courants à éviter

- **Oublier de créer des règles "any to any"** sur pfSense pour permettre la communication LAN <-> LAN
- **Ne pas définir le serveur DNS correct** avant de joindre une machine au domaine
- **Ne pas définir le redirecteur conditionnel** pour `melvin13.domaine.tssr`
- **Appliquer des GPO à tous les utilisateurs**, y compris les admins → filtrer !
- **Mauvais ordre des groupes dans les ACL NTFS** → toujours appliquer via `DL_*`

---

## 🛍️ Outils d'administration à utiliser depuis le poste client

|Nom|Utilité|
|---|---|
|`dsa.msc`|Utilisateurs et ordinateurs AD|
|`dnsmgmt.msc`|Console DNS|
|`dhcpmgmt.msc`|Console DHCP|
|`rsop.msc`|Résultat des stratégies|
|`mstsc`|Accès RDP|
|`ssh`|Connexion à Linux|
|**Windows Admin Center**|Supervision graphique centralisée|
