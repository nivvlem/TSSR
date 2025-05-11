# La redondance de données : RAID

## 🔄 La redondance de données : principe général

### Définition

> **Redondance** = duplication des composants ou données critiques pour assurer la continuité de service.

Elle peut s’appliquer à :

- Des **disques durs** via le **RAID** (matériel ou logiciel)
- Des **serveurs** via **clustering ou réplication temps réel**
- Des **sites géographiques** via une redondance multisite

> Objectif : **tolérance aux pannes** et meilleure **fiabilité globale**

---

## 🧱 Qu’est-ce que le RAID ?

**RAID** = _Redundant Array of Independent Disks_

> Technique de répartition des données sur plusieurs disques pour améliorer :

- Tolérance aux pannes
- Sécurité
- Performance (lecture/écriture)

Deux modes d’implémentation :

- **RAID matériel** : contrôleur dédié (meilleures performances)
- **RAID logiciel** : géré par le système d’exploitation (moins coûteux)

---

## 🧪 Niveaux de RAID – Vue d’ensemble

|Niveau RAID|Min disques|Tolérance de panne|Lecture|Écriture|Capacité utile|
|---|---|---|---|---|---|
|RAID 0|2|❌ aucune|🔼 haute|🔼 haute|100%|
|RAID 1|2|✅ 1 disque|🔼 haute|⚠️ moyenne|50%|
|RAID 5|3|✅ 1 disque|🔼 haute|🔽 faible|~67–94%|
|RAID 10|4|✅ 1 disque par sous-RAID1|🔼 haute|🔼 haute|50%|

---

## 🧩 Détail des niveaux RAID

### 🔹 RAID 0 – Striping

- Entrelacement des blocs sur plusieurs disques (A1, A2, A3… répartis)
- **Pas de redondance**
- Très **performant**, mais **fragile** (panne d’un disque = perte totale)

### 🔹 RAID 1 – Mirroring

- Chaque donnée est **dupliquée** sur deux disques
- Bonne **tolérance aux pannes**, mais **capacité divisée par 2**

### 🔹 RAID 5 – Parité répartie

- Données + parité réparties sur tous les disques
- Bonne **lecture**, **écriture plus lente**
- Tolérance à la **panne d’un disque**

### 🔹 RAID 10 – Combinaison de RAID 1 et 0

- Association de grappes RAID 1 en RAID 0
- Excellente **performance + tolérance**
- Minimum 4 disques requis

---

## 🧠 Autres points de vigilance

- Le RAID **ne remplace pas une sauvegarde** !
- Une panne **logique** (fichier supprimé, ransomware) affecte tous les disques
- Toujours coupler RAID + **plan de sauvegarde externe**

---

## ✅ À retenir pour les révisions

- RAID 0 = performance sans sécurité
- RAID 1 = sécurité sans gain de capacité
- RAID 5 = compromis équilibré (capacité, tolérance, coût)
- RAID 10 = performance + sécurité mais 50% de capacité utile

---

## 📌 Bonnes pratiques professionnelles

- **Choisir le niveau RAID** selon les priorités métier (performance, sécurité, coût)
- Toujours **documenter la configuration RAID** (type, disques, tolérance)
- Tester les **procédures de reconstruction RAID** régulièrement
- Coupler toute solution RAID avec une **politique de sauvegarde indépendante**

---

## 🔗 Notions clés à connaître

- RAID 0 / 1 / 5 / 10
- Striping, Mirroring, Parité
- RAID logiciel vs matériel
- Capacité utile, tolérance, performance