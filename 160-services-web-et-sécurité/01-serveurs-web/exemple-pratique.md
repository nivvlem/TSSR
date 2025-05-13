# TP – Installation de l'infrastructure Web (Windows/Linux)

## 🧠 Objectif

Installer et configurer une **infrastructure réseau complète simulée en environnement virtuel**, composée de :

- Plusieurs réseaux isolés : **Utilisateurs**, **Serveurs**, **DMZ**
- Machines Windows et Linux : **clients**, **serveurs web**, **contrôleur de domaine**, **pare-feu pfSense**
- Services actifs : **AD, DNS, IIS, Apache2**, résolution DNS et routage inter-réseaux

---

## 🧾 Réseaux et découpage IP

### Base réseau : `192.168.128.0/17`

- Découpée en 32 sous-réseaux en /22 (2048 adresses utilisables par sous-réseau)
- **8e sous-réseau sélectionné** : `192.168.156.0/22`

### Sous-réseaux affectés

|Réseau|Plage d’IP utilisables|Usage|
|---|---|---|
|`192.168.157.128/26`|.129 à .190|Réseau Utilisateurs (VMNet11)|
|`192.168.159.120/29`|.121 à .126|Réseau Serveurs (VMNet10)|
|`192.168.159.232/29`|.233 à .238|Réseau DMZ (VMNet12)|

> Remarque : choisir des IP fixes cohérentes dans chaque plage et réserver les adresses les plus hautes aux passerelles pfSense.

---

## 🧱 Machines virtuelles à déployer

| Nom            | OS                  | Rôle                        | Interface VMNet               | IP statique          |
| -------------- | ------------------- | --------------------------- | ----------------------------- | -------------------- |
| **CD-DNS**     | Windows Server 2019 | Contrôleur de domaine + DNS | VMNet10                       | `192.168.159.121`    |
| **SRV-IIS**    | Windows Server 2019 | Serveur web IIS             | VMNet10                       | `192.168.159.125`    |
| **DEB-SRV**    | Debian 12 sans GUI  | Serveur Apache web          | VMNet12                       | `192.168.159.233`    |
| **CLIENT-DEB** | Debian avec GUI     | Client Linux                | VMNet11                       | `192.168.157.129`    |
| **CLIENT-WIN** | Windows 10          | Client Windows              | VMNet11                       | `192.168.157.130`    |
| **pfSense**    | pfSense Firewall    | Routage/NAT/VLAN            | VMNet10/11/12 + Bridged (WAN) | Interfaces multiples |

---

## ⚙️ Étapes de mise en œuvre

### 1. Création et configuration des VM

- Créer chaque VM dans VMware Workstation/VirtualBox
- Attribuer la bonne interface VMNet à chaque carte réseau
- Installer les OS depuis ISO (Windows Eval + Debian Netinstall)
- Définir les IP statiques dans `/etc/network/interfaces` (Linux) ou dans les paramètres réseau Windows

### 2. Installation du contrôleur de domaine (CD-DNS)

- Lancer le **Gestionnaire de serveur** → Ajouter rôle **AD DS + DNS Server**
- Promouvoir en **contrôleur de domaine** :
    - Nom de domaine : `nivvlem.local` (adapté à votre prénom/nom)
    - Mot de passe DSRM sécurisé
- Vérifier la zone DNS créée automatiquement
- Ajouter une **entrée A** pour SRV-IIS (`srv-iis.nivvlem.local`)

### 3. Installation d’IIS (SRV-IIS)

- Dans **Server Manager** > Gérer les rôles > Ajouter rôle : IIS
- Accéder au site de test via navigateur : `http://localhost`
- Vérifier l’accès depuis les clients par IP et FQDN :
    - `http://192.168.159.125`
    - `http://srv-iis.nivvlem.local`

### 4. Intégration CLIENT-WIN au domaine

- Modifier DNS : `192.168.159.121`
- Nommer le poste : `ClientWin1`
- Intégrer au domaine : `nivvlem.local`
- Reboot et connexion avec un compte domaine : `nivvlem\utilisateur`

### 5. Installation Apache (DEB-SRV)

```bash
apt update
apt install apache2 -y
systemctl enable apache2
systemctl start apache2
```

- Tester depuis CLIENT-DEB : `http://192.168.159.233`

### 6. Configuration pfSense

- Interfaces attribuées :
    - WAN : Bridged (DHCP, accès internet)
    - LAN : `VMNet10`, IP : `192.168.159.126`
    - OPT1 : `VMNet11`, IP : `192.168.157.190`
    - OPT2 : `VMNet12`, IP : `192.168.159.238`
- Configuration via WebGUI `https://192.168.159.126`
- Créer **règles NAT et firewall** pour permettre :
    - L’accès HTTP/HTTPS depuis Utilisateurs vers Serveurs
    - L’accès Internet depuis Utilisateurs

---

## ✅ À retenir pour les révisions

- Les **zones réseau** (LAN, DMZ, utilisateurs) doivent être strictement isolées
- Le **contrôleur de domaine** simplifie la gestion centralisée
- IIS et Apache doivent répondre aux tests locaux ET distants
- pfSense joue un rôle essentiel de **routage, filtrage, NAT**
- La **résolution DNS** doit être cohérente (client → DNS local du domaine)

---

## 📌 Bonnes pratiques professionnelles

- Réserver les adresses hautes aux **passerelles/firewalls**
- Isoler les **services exposés (Apache)** en **DMZ**, protégés par règles firewall
- Tenir un **plan d’adressage clair** (tableau IPs, rôles, VLANs)
- **Sauvegarder les snapshots** de chaque VM à chaque jalon
- **Documenter** l’intégralité des étapes, configurations, et erreurs rencontrées
- Valider chaque étape par un **test de connectivité** (ping, nslookup, navigateur)