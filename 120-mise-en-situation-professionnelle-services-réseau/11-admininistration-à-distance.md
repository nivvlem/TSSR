# Mise en situation professionnelle : Services réseau

## Administration à distance

## 🔧 1. Accès SSH aux serveurs Linux

### 🚀 Sur SRV-LNX-MD

```bash
sudo apt update && sudo apt install openssh-server -y
```

Vérifier que le service est actif :

```bash
sudo systemctl status ssh
```

### 🌐 Depuis CLT-WIN-MD

- Ouvrir **PowerShell** ou **cmd** puis :

```powershell
ssh nivvlem@192.168.55.111
```

### 🚫 Si la connexion échoue :

- Vérifier que le pare-feu sur Debian autorise le port 22
- Vérifier que pfSense n’interdit pas le trafic SSH

---

## 🔧 2. Accès RDP aux serveurs Windows

### 🚀 Sur chaque serveur Windows (SRV-AD-MD, SRV-SVC-MD)

1. Ouvrir **Paramètres > Système > Bureau à distance**
2. Activer le bureau à distance
3. Ajouter le groupe `GG_Informatique` dans les utilisateurs autorisés

### 🔒 Securisation :

- Activer le **NLA (authentification au niveau du réseau)**
- Bloquer les connexions non chiffrées si possible

### 🚪 Depuis CLT-WIN-MD

- Lancer `mstsc`
- Adresse : `192.168.55.101` (SRV-AD-MD) ou `.102` (SRV-SVC-MD)

---

## 🔧 3. Installation des outils RSAT

Sur CLT-WIN-MD, depuis **Paramètres > Applications > Fonctionnalités facultatives** :

- Installer :
    - **RSAT: Gestionnaire de serveur**
    - **RSAT: Utilisateurs et ordinateurs Active Directory**
    - **RSAT: DHCP**
    - **RSAT: DNS**

### 🌐 Une fois installé :

- Lancer `dsa.msc` (ADUC)
- Lancer `dnsmgmt.msc` (DNS)
- Lancer `dhcpmgmt.msc` (DHCP)

> Permet de tout administrer à distance depuis le client !

---

## 🪧 4. Windows Admin Center (WAC)

### 🚀 Sur SRV-SVC-MD

1. [Télécharger WAC](https://learn.microsoft.com/fr-fr/windows-server/manage/windows-admin-center/overview)
2. Installer avec les options par défaut (port 443)
3. Autoriser WAC dans le pare-feu Windows

### 🔓 Accès depuis CLT-WIN-MD

- Naviguer vers : `https://srv-svc-md` (ou IP)
- Ajouter les autres serveurs à l'interface
- Tester les fonctionnalités : performances, services, gestion des partages…

> Peut être utilisé comme alternative visuelle à RSAT

---

## 📄 Synthèse

|Fonction|Accès depuis CLT-WIN-MD|Outils utilisés|
|---|---|---|
|Administration Debian|SSH vers SRV-LNX-MD|OpenSSH / PowerShell|
|Administration Windows|RDP vers SRV-AD-MD/SVC|mstsc / Bureau à distance|
|Gestion AD/DNS/DHCP|RSAT|`dsa.msc`, `dnsmgmt.msc`, `dhcpmgmt.msc`|
|Supervision globale|Windows Admin Center (WAC)|Navigateur web HTTPS|
