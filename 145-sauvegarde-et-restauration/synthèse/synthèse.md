# 📘 Synthèse – Sauvegarde et Restauration
## 🧱 Concepts fondamentaux

### Définitions clés

|Terme|Définition|
|---|---|
|**Sauvegarde**|Copie des données pour prévenir la perte ou les incidents|
|**Restauration**|Récupération des données sauvegardées en cas de besoin|
|**Archivage**|Stockage à long terme, souvent réglementaire|
|**Réplication**|Copie instantanée ou régulière (≠ sauvegarde)|
|**PCA / PRA**|Continuité ou reprise d’activité post-incident|

### Règle **3–2–1**

- **3 copies** des données (originale + 2 sauvegardes)
- **2 supports** différents
- **1 copie hors site** (cloud, NAS distant, bande externalisée)

---

## 🔁 Types de sauvegarde

|Type|Avantage|Inconvénient|
|---|---|---|
|**Complète**|Fiable, facile à restaurer|Gourmande en espace/temps|
|**Différentielle**|Sauvegarde rapide, restauration simple|Taille augmente avec le temps|
|**Incrémentale**|Économe en ressources|Restauration plus longue et plus complexe|

> Utilise le **bit d’archive** (Windows) ou la **date de modif.** (Unix) pour savoir quoi sauvegarder

### Méthode GFS (Grand-Père, Père, Fils)

|Niveau|Fréquence|Nombre de supports requis|
|---|---|---|
|Fils|Quotidienne|5 à 7|
|Pères|Hebdomadaire|5|
|Grands-Pères|Mensuelle|12 ou plus|

---

## 💽 Supports de stockage

|Support|Utilisation|Atout principal|Limite principale|
|---|---|---|---|
|Disques durs (HDD)|Sauvegarde locale|Faible coût|Fragilité physique|
|SSD|Performance, VM|Rapide|Coût élevé|
|Bandes LTO|Archivage long terme|Longévité|Manipulation, lenteur|
|RDX|Sauvegarde physique|Transportable|Limité|
|NAS|Sauvegarde réseau|Accessible, RAID|Dépend réseau local|
|SAN|Haute dispo, VM|Performance, redondance|Complexité|
|Cloud|Externalisation|Résilience géographique|Coût, bande passante|

---

## 🧰 Outils logiciels

### Veritas Backup Exec

- Interface claire, utilisée pour la sauvegarde Windows
- Permet **sauvegardes différentielles, complètes, duplications**
- Sauvegarde/restauration granulaire (AD, fichiers)

### Veeam Backup & Replication

- Pour VM (Hyper-V, ESXi)
- **Sauvegarde complète, incrémentale, restauration full ou partielle**
- Gestion du **volume shadow copy (VSS)** pour cohérence applicative
- Duplication possible sur partages CIFS/SMB ou stockage secondaire

---

## ⚙️ Redondance RAID

|Type|Min. disques|Tolérance pannes|Capacité utile|Performance|
|---|---|---|---|---|
|RAID 0|2|❌ aucune|100%|🔼 🔼|
|RAID 1|2|✅ 1 disque|50%|🔼 moyenne|
|RAID 5|3|✅ 1 disque|N - 1 disques|🔼/🔽|
|RAID 10|4|✅ 1/sous-groupe|50%|🔼 🔼|

> **RAID ≠ sauvegarde** : une corruption logique touche tous les disques

### Implémentation RAID logiciel

- Possible sous **Windows Server**
- Miroir RAID 1 via **diskmgmt.msc**
- RAID 5 logiciel possible avec gestion avancée
- Gestionnaire de serveur : alternative avec création de **pools de stockage**

---

## ✅ À retenir pour les révisions

- La **sauvegarde complète** est la plus fiable, mais la plus lourde
- La **règle 3–2–1** est incontournable pour garantir la sécurité
- Le **RAID** assure la **disponibilité**, pas la récupération
- Des outils comme **Veeam** ou **Backup Exec** assurent des **sauvegardes planifiées, duplicables et restaurables**

---

## 📌 Bonnes pratiques professionnelles

- Ne jamais sauvegarder **uniquement localement**
- Tester la **restauration régulièrement** (mensuelle recommandée)
- Documenter l’**arborescence des supports**, des jobs, des volumes RAID
- Nommer clairement les jobs, volumes, et tâches (`SVGD-AD`, `RAID1_VOL`, `RSTR-FIC1`...)
- Coupler **RAID + sauvegarde externe + réplication cloud** pour un maximum de résilience

---

## 🔗 Commandes et outils utiles

```bash
# MySQL – Dump et restauration
mysqldump -u utilisateur -p mot_de_passe base > dump.sql
mysql -u utilisateur -p base < dump.sql

# Oracle – RMAN
rman> backup incremental level 0 section size 512m database plus archivelog;

# Active Directory (restauration granulaire Backup Exec)
- Interface graphique intégrée

# Windows
diskmgmt.msc    # Gestionnaire de disques
wbadmin         # Sauvegarde/restore système (cmd)
```
