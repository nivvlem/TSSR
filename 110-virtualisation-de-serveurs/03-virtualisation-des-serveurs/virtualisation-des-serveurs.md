# La virtualisation des serveurs

## 🧱 Architecture d'une infrastructure virtualisée

Une infrastructure de virtualisation repose sur plusieurs couches :

|Élément|Rôle principal|
|---|---|
|**Hôte (machine physique)**|Fournit les ressources matérielles : CPU, RAM, disques, cartes réseau…|
|**Hyperviseur**|Plateforme logicielle qui gère les VMs et accède aux ressources matérielles|
|**VMM (Virtual Machine Manager)**|Outil d’administration : création, configuration, suivi des VMs|
|**Machines virtuelles (VM)**|Systèmes invités simulés, exécutés sur l’hyperviseur|

---

## ⚙️ Hyperviseurs serveurs (type 1)

|Solution|Éditeur|Particularités|
|---|---|---|
|**Hyper-V**|Microsoft|Intégré à Windows Server, s’administre avec Hyper-V Manager ou PowerShell|
|**VMware ESXi**|VMware|Version gratuite disponible, nécessite vSphere pour gestion centralisée|
|**KVM**|Communauté Linux|Intégré au noyau Linux, utilisé avec Proxmox, virt-manager…|
|**XenServer**|Citrix|Moins courant, mais historique sur certains systèmes|

---

## 🧠 Processeurs et virtualisation matérielle

Les hôtes doivent prendre en charge :

|Technologie Intel|Technologie AMD|Rôle|
|---|---|---|
|Intel VT-x|AMD-V|Virtualisation bas-niveau (instructions processeur)|
|EPT|NPT / RVI|Second Level Address Translation → meilleures performances|

🎯 Vérifier ces options dans le BIOS/UEFI du serveur physique.

---

## 🛠️ Composants d’une VM

Une VM comprend :

- Un ou plusieurs **fichiers de disque** (VHDX, VMDK…)
- Un **fichier de configuration matérielle**
- Des ressources attribuées : CPU, RAM, interfaces réseau virtuelles
- Une **image mémoire** en cours d’exécution

---

## 🗃️ Outils de gestion

|Environnement|Outil de gestion principal|
|---|---|
|Hyper-V|Gestionnaire Hyper-V, PowerShell|
|VMware ESXi|vSphere Client / Web Client|

Les VMM permettent :

- La création et gestion de VMs
- Le suivi des ressources (CPU, RAM, stockage)
- La gestion réseau et snapshots

---

## 🔄 Consolidation et administration centralisée

Les infrastructures peuvent être **gérées individuellement** ou **regroupées** pour centralisation :

- **Hyper-V** : intégration des hôtes dans un domaine Active Directory
- **vSphere** : ajout des hôtes ESXi dans un **vCenter Server**

Avantages :

- Déploiement automatisé
- Supervision unifiée
- Haute disponibilité (vMotion, clustering)

---

## ✅ À retenir pour les révisions

- L’hyperviseur **type 1** est installé directement sur le serveur physique
- **Hyper-V** (Microsoft) et **VMware ESXi** sont les plus courants en entreprise
- Le **VMM** (Hyper-V Manager, vSphere) est essentiel à l’administration
- Une VM repose sur des fichiers (disques, configuration, snapshots…)

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Vérifier la compatibilité CPU (VT-x, AMD-V…)|Indispensable pour la prise en charge de l’hyperviseur|
|Déployer les VMs sur du **stockage dédié performant**|Optimiser la disponibilité et les temps d’accès|
|Nommer clairement les hôtes et VMs|Faciliter la supervision et l’automatisation|
|Sauvegarder régulièrement les VMs|Prévention en cas de corruption ou de panne|
|Isoler les VLANs de gestion, VM et stockage|Meilleure sécurité et performance réseau|
