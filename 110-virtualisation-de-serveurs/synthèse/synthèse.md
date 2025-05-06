# 📄 Synthèse – Virtualisation de serveurs

Ce document regroupe les connaissances essentielles, bonnes pratiques, outils et commandes à connaître pour maîtriser l'administration d'une infrastructure virtualisée avec VMware Workstation, ESXi, vCenter et vSphere.

---

## 🛠️ Fondamentaux de la virtualisation

### Concepts clés

- **Hyperviseur** : logiciel permettant de créer et exécuter des machines virtuelles (VM).
- **ESXi** : hyperviseur de type 1 de VMware.
- **vCenter** : serveur d'administration centralisé pour plusieurs hôtes ESXi.
- **Datastore** : espace de stockage utilisé par les hyperviseurs.
- **Snapshot** : sauvegarde à un instant donné de l'état d'une VM.

### Types de virtualisation

|Type|Description|
|---|---|
|**Workstation**|Virtualisation sur poste client (type 2)|
|**ESXi**|Hyperviseur nu (type 1)|
|**vCenter/vSphere**|Gestion centralisée d’une ferme d’ESXi|

---

## 🌐 Réseau et stockage

### Composants réseau

- **vSwitch** (standard ou distribué)
- **Port Group** (Production, Gestion, Stockage…)
- **VMkernel** : interface réseau pour les services (vMotion, iSCSI, NFS)

### Types de stockage

|Protocole|Mode|Utilisation|
|---|---|---|
|**VMFS**|Bloc|Performant, ESXi|
|**NFS**|Fichier|Partage, flexibilité|
|**iSCSI**|Bloc|Cible + initiateur|

---

## 📃 Tâches courantes & commandes utiles

### Connexion SSH à un ESXi

```bash
ssh root@ip_esxi
```

### Liste des VM sur ESXi

```bash
vim-cmd vmsvc/getallvms
```

### Gestion DNS (SRV_2K19)

- Créer une zone directe
- Ajouter des enregistrements A pour chaque élément (esxi1, esxi2, vcenter)

### vMotion / Storage vMotion

- Migrer VM sans arrêt de service (CPU / RAM / Disque)

---

## ✅ À retenir pour les révisions

- OVF/OVA : formats d’export/import de VM
- DNS essentiel pour les communications ESXi/vCenter
- vMotion = déplacement à chaud de VM entre ESXi
- Storage vMotion = déplacement à chaud de fichiers VM
- Créer des modèles de VM pour standardiser les déploiements

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Raisonnement|
|---|---|
|Utiliser des IPs statiques|Évite les pannes de résolution de noms|
|Séparer réseaux (gestion, production, stockage)|Isolation, performance, sécurité|
|Documenter chaque composant|Maintenance facilitée, audit simplifié|
|Tester toute mise à jour ou migration|Réduire les risques sur l’environnement en production|
|Centraliser la gestion via vCenter|Supervision, sauvegardes, planification, HA/DRS|
