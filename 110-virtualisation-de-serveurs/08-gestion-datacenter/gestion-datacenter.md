# Gestion du datacenter

## 📊 Gestion des ressources et pools

|Fonction|Définition / Intérêt|
|---|---|
|**Sur-allocation**|Affecter plus de ressources que le physique disponible|
|**Réservations**|Garantir des ressources pour des VM critiques|
|**Pool de ressources**|Regroupement logique avec restrictions ou réservations|
|**VM de production**|Prioritaires à protéger avec réservations ou priorité accrue|

---

## 🚀 vCenter et environnement de datacenter

|Fonctionnalité|Détails|
|---|---|
|**Création d'un datacenter**|Regrouper des hôtes ESXi, définir des réseaux et stockages partagés|
|**vMotion / Storage vMotion**|Déplacement à chaud des VM ou stockage|
|**Clustering / HA**|Non abordé ici, mais disponible avec vCenter|

### ✨ Implémentations possibles de vCenter

- **VCSA (vCenter Server Appliance)** : recommandé (facile, performant)
- **vCenter sur Windows Server** : plus rare, lourd à maintenir

### ⚖️ Comparatif

|Implémentation|Nb hôtes max|Nb VM max|Points forts|
|---|---|---|---|
|**VCSA**|1000|10 000|Simplicité, performances|
|**vCenter Win**|5|50|À éviter si possible|

---

## 🛄 Gestion des utilisateurs, privilèges et rôles

|Elément|Fonction / Règle|
|---|---|
|**Utilisateurs locaux**|Créés sur vCenter ou ESXi, accès limité à la portée de création|
|**Groupes / Rôles**|Regrouper utilisateurs et privilèges. Favoriser les groupes plutôt que individuels|
|**Attribution héritée**|Affecter les privilèges au plus haut niveau souhaité (datacenter, etc.)|
|**Principe du moindre privilège**|Toujours restreindre au strict nécessaire|

---

## 🔹 Modèles de machines virtuelles (Templates)

### Types :

|Format|Compatibilité / Utilisation|
|---|---|
|**OVF/OVA**|Standard multi-hyperviseurs (VMware, VirtualBox, XenServer...)|
|**VMTX**|Spécifique vSphere, permet personnalisation et déploiement rapide|

### Actions possibles avec un VMTX :

- **Convertir** une VM en template ou inversement
- **Cloner** une VM vers un template sans modification de l'original
- **Déployer** une nouvelle VM depuis le template
- **Personnaliser** post-déploiement (nom, IP, SID)

### ⚠️ Prérequis pour personnalisation :

- VMware Tools installés
- SYSPREP disponible si Windows

---

## 🚶️ vMotion et Storage vMotion

|Fonction|Utilité|
|---|---|
|**vMotion**|Déplacer une VM entre deux hôtes ESXi sans interruption|
|**Storage vMotion**|Déplacer le stockage d'une VM entre deux datastores à chaud|

### Prérequis techniques

- vMotion activé sur au moins un vSwitch par hôte
- Mêmes plages de diffusions IP entre hôtes source et destination
- Datastores accessibles par les deux hôtes

---

## ✅ À retenir pour les révisions

- vCenter permet la gestion **centralisée** d'une infrastructure VMware
- Préférer **VCSA** à vCenter Windows
- Les **templates VMTX** permettent un déploiement rapide et personnalisable
- **vMotion / Storage vMotion** = déplacement à chaud de VM ou stockage
- Favoriser les **groupes** + **rôles** pour la gestion des privilèges

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Documenter les pools, utilisateurs et privilèges|Assure la clarté et facilite la maintenance|
|Toujours appliquer le **principe du moindre privilège**|Réduction du risque d'erreurs ou d'abus|
|Utiliser des **templates VMTX** préconfigurés|Gain de temps et standardisation|
|Activer les journaux d'audit dans vCenter|Suivi des actions critiques|
|Mettre en place une **redondance pour vCenter**|Continuité d'activité et haute disponibilité|
