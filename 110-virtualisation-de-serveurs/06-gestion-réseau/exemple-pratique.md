# TP – Gestion Réseau d’une infrastructure vSphere

## 📝 Étapes

### 1. Préparation dans VMware Workstation

- Éteindre proprement les VMs `ESXi1` et `ESXi2`
- Ajouter **3 cartes réseau en mode bridge** supplémentaires à chaque VM ESXi (total : 4 vmnic)

---

## 🔧 Configuration sur ESXi1

### 2. Reconfiguration du vSwitch0

- Ne conserver que le port group `Management Network`
- Le renommer en `GRP-GESTION`

### 3. Création des vSwitchs et port groups

|vSwitch|Port Group|Type de ports|Fonction|Adresse IP VMKernel|Carte(s) réseau associée(s)|
|---|---|---|---|---|---|
|vSwitch1|GRP-VMNET|Machines virtuelles|Communication VM ↔ VM|-|vmnic2|
|vSwitch2|GRP-STORAGE-VMOTION|VMKernel|iSCSI + vMotion|192.168.xx.1/24|vmnic3|

> Ne pas modifier les identifiants de VLAN

### 4. Étapes détaillées dans vSphere Web Client

- Aller dans **Mise en réseau** > **Commutateurs virtuels**
- Ajouter les vSwitchs `vSwitch1` et `vSwitch2`
- Créer les port groups `GRP-VMNET` (sur vSwitch1) et `GRP-STORAGE-VMOTION` (sur vSwitch2)
- Créer une **interface VMKernel** sur `GRP-STORAGE-VMOTION` avec l’IP : `192.168.xx.1/24`

### 5. Modification de la VM SRV-1

- Modifier sa vNIC pour la connecter à `GRP-VMNET`
- Supprimer le port group `VM Network` une fois libéré

---

## 🔁 Configuration sur ESXi2

- Reproduire les mêmes étapes que sur ESXi1
- Pour l’interface VMKernel de `GRP-STORAGE-VMOTION`, utiliser l’adresse IP : `192.168.xx.2/24`

---

## ✅ À retenir pour les révisions

- La séparation des flux réseau se fait via plusieurs **vSwitchs** et **groupements de ports**
- Une **carte réseau physique (vmnic)** peut être dédiée à un type de trafic
- L’ajout d’un port group de type **VMKernel** permet l’usage de services comme **vMotion** ou **iSCSI**
- Le renommage des port groups améliore la lisibilité et l’administration réseau

---

## 📌 Bonnes pratiques professionnelles

- Documenter systématiquement l’affectation des vmnic aux vSwitchs et groupes de ports
- Préférer une **carte réseau physique par usage** (gestion, VM, stockage)
- Toujours modifier les affectations VM avant de supprimer un port group
- Configurer les **switchs physiques en trunk** pour supporter plusieurs VLAN si nécessaire

---

## 🔗 Actions et composants clés

- VMware Workstation (ajout de cartes réseau en bridge)
- vSphere Web Client (ESXi)
- Commutateurs virtuels (vSwitch0, vSwitch1, vSwitch2)
- Groupes de ports : `GRP-GESTION`, `GRP-VMNET`, `GRP-STORAGE-VMOTION`
- Interfaces VMKernel, IP statiques dédiées aux flux techniques