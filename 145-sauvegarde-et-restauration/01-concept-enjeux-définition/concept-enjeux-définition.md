# Concepts, enjeux et définitions (Sauvegarde & Restauration)
## 🧱 Définitions clés

### 🔹 Sauvegarde

Processus de **copie régulière de données** dans un but de restauration en cas de perte (incident, erreur humaine, sinistre, ransomware…)

### 🔹 Restauration

Processus de **récupération des données** sauvegardées afin de les rendre de nouveau accessibles et utilisables (fichiers, OS, base de données…)

### 🔹 Archivage

Stockage de données **à valeur probante ou réglementaire** sur le long terme, souvent hors production

---

## ⚠️ Enjeux d'une politique de sauvegarde

- Pérenniser les données essentielles de l’entreprise
- Répondre à des obligations légales de conservation (RGPD, CNIL, etc.)
- Prévenir la perte de données en cas de panne matérielle ou attaque
- Permettre une reprise rapide d’activité
- Protéger contre l’erreur humaine, l’incendie, l’intrusion

---

## ✅ Bonnes pratiques

- Créer un **compte de service dédié** (AD) pour la sauvegarde
    - Moins de privilèges = meilleure sécurité
    - Traçabilité dans les journaux (logs)
- Utiliser le **groupe “Opérateur de sauvegarde”** sous Windows
- Documenter et appliquer un **plan de sauvegarde structuré**

---

## 🔁 Règle 3-2-1

|Élément|Explication|
|---|---|
|**3 copies**|Données d’origine + 2 sauvegardes|
|**2 supports différents**|Par exemple : disque local + bande ou NAS|
|**1 copie hors site**|Pour prévenir les sinistres ou ransomwares (cloud, site distant, coffre…)|

---

## 🔄 PCA & PRA

### PCA – Plan de Continuité d’Activité

- Ensemble de procédures mises en œuvre **avant, pendant et après** une crise
- Concerne : SI, sécurité, communication, repli, gouvernance

### PRA – Plan de Reprise d’Activité

- Ensemble des **moyens et procédures** permettant de redémarrer le SI après un incident
- Inclut : politique de sauvegarde, supports, procédures de restauration, licences, etc.

> Le PRA est **une composante du PCA**

---

## 📄 Plan de sauvegarde : éléments clés

- Périmètre des ressources à sauvegarder
- Contraintes (ex : volumétrie, réseau, fenêtre horaire)
- Types de sauvegarde (full, diff, incrémentale)
- Fréquence/périodicité
- Emplacement des fichiers de sauvegarde
- Procédures de test et de restauration
- Politique de conservation et destruction des supports

---

## 💽 Outils du marché (éditeurs)

|Éditeurs/solutions|Notes clés|
|---|---|
|Veritas Backup Exec|Utilisé dans la suite du cours|
|Veeam Backup & Replication|Populaire pour VMware/Hyper-V, réplication intégrée|
|Atempo, Arcserve, Cohesity...|Existent en version pro / entreprise / SaaS|

---

## 🧰 Présentation de Veritas Backup Exec

- Sauvegarde/restauration locales et à distance
- Interface claire (ruban, volets de sélection, état, gestion des jobs)

## 🧰 Présentation de Veeam Backup & Replication

- Sauvegarde complète de VMs avec restauration **full ou granulaire**
- Gestion des réplications (RTO optimisé)
- Prise en charge des **protocoles VSS** pour bases MS SQL / Exchange
- Sauvegardes : **incrémentales, reverse-incrémentales**
- Support : disques, partages réseau (CIFS/SMB/NFS), disques externes
- Création de jobs planifiés et alertes mail intégrées

> Important : un **réplica** ne doit pas être démarré manuellement, uniquement via Veeam

---

## ✅ À retenir pour les révisions

- La sauvegarde est **essentielle à la pérennité** du système d’information
- Le PRA fait partie du PCA, qui couvre l’organisation globale en cas de crise
- La **règle 3-2-1** est un standard incontournable
- Outils majeurs : **Veeam**, **Backup Exec**, **Veritas**, etc.

---

## 📌 Bonnes pratiques professionnelles

- Centraliser les sauvegardes dans un référentiel documenté
- Tester régulièrement la restauration (simulation de crash, VM lab, sandbox)
- Planifier la rotation et la vérification des supports
- Vérifier l’intégrité post-sauvegarde automatiquement
- Gérer les accès par des **comptes de service restreints**

---

## 🔗 Notions et outils à maîtriser

- Plan de sauvegarde / restauration / PCA / PRA
- Types de sauvegarde : complète, différentielle, incrémentale
- VSS (Volume Shadow Copy Service)
- Réplication vs sauvegarde
- Logiciels : Veeam, Veritas, Atempo, Arcserve