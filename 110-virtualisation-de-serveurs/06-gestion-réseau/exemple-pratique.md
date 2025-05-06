# TP – Gestion réseau d’une infrastructure vSphere
## 🛠️ Prérequis

- Deux hôtes ESXi (ESXi1 et ESXi2) opérationnels
- VMware Workstation installé

---

## 🔧 Étapes de réalisation

### 1. Préparation dans VMware Workstation

- Éteindre proprement ESXi1 et ESXi2
- Ajouter **trois cartes réseau en mode « bridge »** à chaque hôte
- Redémarrer ESXi1 et ESXi2

### 2. Configuration réseau sur ESXi1

#### a. Renommer le port group par défaut

- Aller dans **Mise en réseau > Groupes de ports**
- Renommer `Management Network` en `GRP-GESTION`

#### b. Créer deux nouveaux vSwitch

|vSwitch|Port Group lié|Type de port|Fonction|VMNIC associée|
|---|---|---|---|---|
|vSwitch1|GRP-VMNET|Virtual Machine|Communication inter-VM|vmnic2|
|vSwitch2|GRP-STORAGE-VMOTION|VMKernel|Stockage (iSCSI) + vMotion|vmnic3|

#### c. Ajouter les éléments dans l’interface Web d’ESXi1

1. **Ajout de vSwitch1** :
    - Menu **Mise en réseau > Commutateurs virtuels > Ajouter**
    - Nom : `vSwitch1` → Ajouter **vmnic2**
2. **Ajout de vSwitch2** :
    - Menu **Commutateurs virtuels > Ajouter**
    - Nom : `vSwitch2` → Ajouter **vmnic3**
3. **Création du Port Group `GRP-VMNET`**
    - Menu **Groupes de ports > Ajouter**
    - Nom : `GRP-VMNET` → vSwitch : `vSwitch1`
4. **Ajout d’une interface VMkernel pour GRP-STORAGE-VMOTION**
    - Menu **NIC VMkernel > Ajouter**
    - Port Group : `GRP-STORAGE-VMOTION`
    - IP statique : `192.168.10.1/24`
5. **Modifier la VM SRV-1 pour utiliser le port group `GRP-VMNET`**
    - Aller sur la VM `SRV-1`, modifier la vNIC → l’associer à `GRP-VMNET`
    - Supprimer l’ancien port group `VM Network`

### 3. Répéter les étapes sur ESXi2

- Même structure réseau
- Adresse VMkernel pour `GRP-STORAGE-VMOTION` : `192.168.10.2/24`

---

## ✅ À retenir pour les révisions

- Un **vSwitch standard** est propre à chaque hôte ESXi
- Les **Port Groups** permettent de délimiter les usages (gestion, VM, vMotion…)
- Les **interfaces VMkernel** sont nécessaires pour des services spécifiques (vMotion, iSCSI, NFS…)
- L’**ajout de cartes réseau bridgées** permet une séparation logique des flux même dans un environnement de test

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Séparer les flux (VM, stockage, gestion) sur des vSwitchs dédiés|Améliore la performance et la sécurité|
|Nommer clairement chaque port group et vSwitch|Facilite la maintenance et la supervision|
|Associer les VMNIC à des usages spécifiques|Permet un diagnostic réseau plus rapide|
|Appliquer des IP fixes sur les interfaces VMkernel|Nécessaire pour des services comme vMotion ou iSCSI|
|Documenter la topologie réseau virtuelle|Essentiel pour les environnements multi-hôtes et la scalabilité|
