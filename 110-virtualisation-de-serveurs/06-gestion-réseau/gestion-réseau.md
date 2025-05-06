# Gestion du réseau vSphere

## 📊 Concepts de base : VLAN

### Qu'est-ce qu'un VLAN ?

- **VLAN** = Virtual LAN : réseau logique isolé dans un même réseau physique
- Permet de séparer les flux pour :
    - Améliorer la **sécurité**
    - Limiter les domaines de diffusion (**performances**)
    - Prioriser certains flux (**QoS**)

### Prise en charge : norme **802.1Q**

- Ajoute un tag VLAN dans l'entête Ethernet (4 octets)
- Identifiant VLAN : valeur de **1 à 4094**
- Modes de configuration :
    - **Port Access** : un seul VLAN (terminaux)
    - **Port Trunk** : plusieurs VLAN (entre switchs)

### Affectation possible :

- **Niveau 1** : par port physique (switch)
- **Niveau 2** : par adresse MAC
- **Niveau 3** : par adresse IP

---

## 🚧 Composants réseau d'ESXi

### 🔌 vSwitch Standard (VSS)

- Créé par défaut : `vSwitch0`
- Géré localement par chaque hôte ESXi
- Connecté à une ou plusieurs **VMNIC** (interfaces physiques)
- Utilisable pour :
    - Le réseau de gestion (VMkernel)
    - Les réseaux VM (Virtual Machine)

### 🪡 vSwitch Distribué (VDS)

- Un objet commun à plusieurs hôtes ESXi (via vCenter)
- Géré depuis l'interface vCenter
- Assure la **continuité de service** en cas de migration de VM
- Requiert **vSphere Enterprise Plus**

### 🛋️ Groupements de ports (Port Groups)

- Définissent un usage réseau
- Types :
    - **VM Network** : pour les VM
    - **VMkernel** : pour les besoins d'infrastructure (vMotion, gestion, stockage)
- Supportent la **segmentation VLAN**

### 🚄 VMNIC / pNIC

- Cartes réseau **physiques** de l'hôte ESXi
- Une VMNIC peut être liée à un seul vSwitch
- Plusieurs VMNIC peuvent être agrégées (teaming)

### 🪙 vNIC

- Cartes réseau **virtuelles** présentées aux VMs
- Connectées à un port group Virtual Machine
- Peuvent recevoir une configuration VLAN

---

## ⚖️ Teaming (regroupement de cartes)

- Objectif :
    - **Tolérance de pannes** (actif/passif)
    - **Répartition de charge** (actif/actif)
- Modes de répartition :
    - Par VM (round-robin)
    - Par adresse MAC source
    - Par paquet (hash source/destination)
- Prérequis : ≥2 VMNIC sur le même vSwitch

---

## 🔗 Intégration des VLAN dans vSphere

|Niveau de configuration|Effet|
|---|---|
|vSwitch|Affecte tous les ports par défaut|
|Port Group|Affectation granulaire par rôle|
|vNIC (VM)|Gestion directe depuis l'OS si compatible 802.1Q|

⚠️ Dans tous les cas, les **ports physiques doivent être en mode trunk** pour accepter les VLAN taggés.

---

## ✅ À retenir pour les révisions

- `vSwitch0` est le commutateur par défaut sur chaque hôte
- **VDS** permet une configuration réseau centralisée (via vCenter)
- Les **VMNIC** sont les cartes physiques liées aux vSwitch
- Les **vNIC** sont les interfaces réseau des VMs
- Le **teaming** permet redondance et répartition de charge
- VLAN = isolement logique, géré par norme 802.1Q

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Séparer les flux : gestion, VMs, stockage, vMotion|Sécurité, performances et supervision claire|
|Utiliser les VLANs pour isoler les rôles réseaux|Évite les interférences et simplifie les ACL|
|Toujours documenter les correspondances VMNIC <=> usage|Maintenabilité du réseau et diagnostic facilité|
|Exploiter le teaming actif/passif pour la résilience|Continuité de service en cas de défaillance|
|Privilégier l'usage de VDS dans les environnements critiques|Uniformité de configuration et centralisation via vCenter|
