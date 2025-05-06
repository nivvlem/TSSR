# TP – Gestion du datacenter avec vSphere et vCenter

## 💼 Prérequis

- 2 hôtes **ESXi1** et **ESXi2** en fonctionnement
- VM **SRV_2K19** (Windows Server 2019) configurée avec interface graphique
- DNS fonctionnel (serveur sur SRV_2K19)
- VMs **SRV-1** (sur ESXi1) et **SRV-2** (sur ESXi2) préexistantes

---

## 📚 Partie 1 – Exporter et importer une VM au format OVF

### ➔ Exporter depuis ESXi1

1. Se connecter à l'interface Web de **ESXi1**.
2. Repérer la VM **SRV-1**.
3. Effectuer clic droit > **Exporter**.
4. Choisir le format **OVF + VMDK** (fichiers `.ovf`, `.vmdk`, `.mf`).
5. Sauvegarder ces fichiers sur le poste local ou sur SRV_2K19.

### ➔ Importer sur ESXi2

1. Se connecter à **ESXi2** via navigateur.
2. Aller dans **Machines virtuelles > Créer / Enregistrer une VM** > _Déployer un modèle OVF_.
3. Choisir les fichiers exportés.
4. Nommer la nouvelle VM : `SRV-2-ovf`
5. Sélectionner le **datastore DS-ISCSI**.
6. Terminer le déploiement, vérifier le bon démarrage de la VM.

---

## 📂 Partie 2 – Mise en place du serveur DNS et configuration réseau

### 🛠️ SRV_2K19

1. Ajouter une deuxième interface réseau (VMNet3) avec IP statique `10.5.20.21/16`.
2. Ajouter le suffixe DNS : `vmwareMD.lab`
3. Renommer le poste : `SRV-2K19.vmwareMD.lab`
4. Installer le **rôle DNS**.
5. Créer une **zone de recherche directe** : `vmwareMD.lab`
6. Ajouter les enregistrements A :
    - `esxi1.vmwareMD.lab` → `10.5.20.11`
    - `esxi2.vmwareMD.lab` → `10.5.20.12`
    - `vcenter.vmwareMD.lab` → `10.5.20.10`

### 🚄 Configuration DNS sur ESXi

Sur **ESXi1** et **ESXi2** :

1. Aller dans Configuration > Système > DNS et routage
2. Renseigner le serveur DNS : `10.5.20.21`
3. Ajouter le suffixe DNS : `vmwareMD.lab`

Test : depuis chaque ESXi, tester la résolution de nom avec `ping vcenter.vmwareMD.lab`

---

## 🚀 Partie 3 – Déploiement de vCenter Server Appliance (vCSA)

### ➔ Déploiement de vCSA (depuis SRV_2K19)

1. Lancer l'installateur OVA de vCenter (fichier fournis en `.ova` ou `.iso`).
2. Suivre les étapes via VMware Workstation ou vSphere Client (selon environnement).
3. Paramètres de base :
    - Nom DNS : `vcenter.vmwareMD.lab`
    - IP statique : `10.5.20.10`
    - Gateway : `10.5.255.254`
    - DNS : `10.5.20.21`
4. Créer un domaine SSO : `vsphere.local`
5. Finaliser l'installation via `https://vcenter.vmwareMD.lab:5480`

### ➔ Accès vSphere

1. Se connecter à l'interface : `https://vcenter.vmwareMD.lab`
2. Créer un **Datacenter** nommé : `DCPROD`
3. Ajouter les deux hôtes ESXi au datacenter (login root + IP)
4. Vérifier l’état "Connecté" et la synchronisation de l'heure

---

## 🔄 Partie 4 – vMotion et Storage vMotion

### ➔ Prérequis

- La même réseau VMKernel "vMotion" configuré sur ESXi1 et ESXi2
- Le Datastore **DS-ISCSI** accessible par les deux ESXi

### 🌐 vMotion

1. Démarrer **SRV-2** sur ESXi2
2. Clic droit > **Migrer** > _Ressources de calcul uniquement_
3. Sélectionner **ESXi1** comme hôte de destination
4. Valider : la VM doit migrer sans interruption

### 💾 Storage vMotion

1. Démarrer **SRV-1**
2. Clic droit > **Migrer** > _Stockage uniquement_
3. Sélectionner le Datastore **DS-NFS**
4. Lancer la migration et vérifier que les fichiers sont déplacés sans arrêt de service

---

## ✅ À retenir pour les révisions

- Le format OVF permet d’exporter/importer facilement des VM
- vCenter est essentiel pour la gestion centralisée de VMware
- Le DNS est indispensable pour une infrastructure VMware stable
- vMotion déplace la charge de travail, Storage vMotion les données
- Le déploiement de VM via modèles (VMTX) permet gain de temps et cohérence

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Affecter des IPs statiques à tous les éléments critiques|Garantit une résolution DNS fiable|
|Toujours tester les migrations sur VMs non critiques|Réduire les risques de pannes|
|Utiliser des modèles standardisés pour les déploiements|Accélère la mise en production|
|Documenter toutes les IPs, noms DNS et chemins de stockage|Simplifie la maintenance|
|Séparer les réseaux de production, gestion et stockage|Améliore performances et sécurité|
