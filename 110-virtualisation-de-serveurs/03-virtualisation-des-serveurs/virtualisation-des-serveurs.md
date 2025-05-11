# La virtualisation des serveurs

## 🖥️ La machine hôte (host)

Le serveur physique hôte fournit les **ressources matérielles** (CPU, RAM, stockage, réseau) nécessaires à l’hébergement de machines virtuelles.

> Il doit être équipé de **processeurs compatibles** avec la virtualisation matérielle :

### Technologies supportées :

- **Intel VT-x**
- **AMD-V**
- **SLAT (Second Level Address Translation)** : EPT (Intel), NPT/RVI (AMD)

---

## 🧠 L’hyperviseur

L’hyperviseur est le **logiciel de virtualisation** installé sur l’hôte. Il est chargé :

- De gérer le matériel physique (accès au CPU, mémoire, disques, etc.)
- D’héberger et de faire fonctionner plusieurs VMs de manière isolée

### Exemples d’hyperviseurs :

- **Hyper-V** (Microsoft)
- **ESXi** (VMware)

---

## 🛠️ Outils de gestion intégrés : VMM

Chaque solution d’hyperviseur possède un **Virtual Machine Manager (VMM)**, outil graphique ou en ligne de commande permettant :

### Fonctions principales du VMM :

- Création / suppression de VMs
- Affectation de ressources matérielles
- Gestion des disques, réseaux, snapshots
- Configuration des fonctions de l’hyperviseur

### Exemples de VMM :

|Solution|Outil de gestion|
|---|---|
|Hyper-V (Windows)|Gestionnaire Hyper-V|
|vSphere (VMware)|vSphere Client (Web ou App)|

---

## 🧩 Les machines virtuelles (VM)

Une machine virtuelle est une **instance logicielle complète** d’un système d’exploitation, hébergée sur l’hyperviseur.

### Une VM contient :

- Un fichier de **configuration matérielle** (VMX, XML…)
- Un ou plusieurs **fichiers disques** (VHD, VMDK…)
- Des ressources **CPU, RAM** allouées
- Une ou plusieurs **interfaces réseau virtuelles**
- Une image de **l’état mémoire (RAM)** lors des snapshots

---

## 🗃️ Consolidation de plusieurs hyperviseurs

Dans une infrastructure professionnelle, plusieurs hôtes peuvent être **regroupés** dans un contexte de gestion centralisé :

### Exemple :

- En environnement Microsoft : intégration des serveurs Hyper-V dans un **domaine Active Directory**
- En environnement VMware : utilisation du **vCenter Server** pour gérer tous les ESXi

### Avantage :

Permet la **mutualisation de la gestion**, la haute disponibilité (HA), la migration à chaud (vMotion/Live Migration), la supervision centralisée.

---

## ✅ À retenir pour les révisions

- L’hyperviseur est le **cœur logiciel** qui fait tourner les VMs sur un hôte physique
- Les VMs sont **des fichiers**, instanciés à partir d’un stockage, avec des ressources allouées dynamiquement
- Le VMM (console de gestion) permet une **interface utilisateur complète** pour gérer les hôtes et les VMs
- Une infrastructure virtualisée peut regrouper plusieurs hôtes pour **simplifier l’administration et augmenter la résilience**

---

## 📌 Bonnes pratiques professionnelles

- Toujours **vérifier la compatibilité matérielle** (VT-x, AMD-V, SLAT) avant d’installer un hyperviseur
- Centraliser les VMs et les hôtes dans un outil d’administration (vCenter, SCVMM)
- Ne jamais affecter **plus de ressources que disponible** sur l’hôte (surprovisionnement = instabilité)
- Prévoir une **stratégie de sauvegarde et de supervision** adaptée
- Séparer clairement les rôles : hôte ≠ VM ≠ outil de gestion

---

## 🔗 Outils / concepts à connaître

- Hyperviseur = ESXi, Hyper-V
- VMM = Hyper-V Manager, vSphere Client
- VM = VHD/VMDK + config + RAM + réseau
- Concepts : consolidation, centralisation, allocation dynamique