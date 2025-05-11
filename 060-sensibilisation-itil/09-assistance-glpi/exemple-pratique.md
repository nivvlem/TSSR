# TP – Assistance avec GLPI

## 🧠 Objectif du TP

Réaliser la mise en œuvre complète d’un **nouveau service** pour un salarié commercial itinérant, en appliquant les principes d’**exploitation ITIL** à l’aide de **GLPI**.

---

## 🧾 Contexte

Ce TP s’inscrit dans la continuité des précédents modules :

- **Stratégie** : définition du besoin d’intégration
- **Conception** : solution technique retenue
- **Transition** : planification des actions
- **Exploitation** : mise en œuvre et traçabilité via GLPI

---

## 🔍 Résolution – Vue ITSM et GLPI

### 1. Création du ticket utilisateur

- Effectuée par le **responsable de service** via interface GLPI
- Type : **Demande**
- Catégorie : _Nouveau Poste Complet_
- Informations du salarié : nom, prénom, fonction, service
- Lien avec le **centre de services** (Service Desk)

### 2. Traitement initial et escalade (Support N1)

- Ouverture du ticket par le technicien N1
- Attribution au **groupe de support parc** et à un **technicien dédié**
- Ajout d’un **suivi** dans le ticket (escalade + infos techniques)

### 3. Gestion du matériel (Technicien parc)

- Recherche et renommage des équipements dans GLPI
- Liaison des éléments (dock, écran, téléphone, etc.) à l’ordinateur
- Changement de **statut** : En stock → À préparer
- Changement de **lieu** : Stock → Zone de préparation
- Lien avec le **CMS** : suivi des CI, connectiques et emplacements
- Mise à jour du ticket avec éléments liés et commentaires de suivi

### 4. Création des comptes (Admin AD)

- Comptes créés : AD, Office 365, GLPI, téléphonie, badge
- Mise à jour du ticket avec confirmation des créations
- Nettoyage des affectations dans les acteurs du ticket

### 5. Préparation logicielle (Technicien parc)

- Renseignement du système d’exploitation installé
- Ajout des logiciels installés + licences
- Mise à jour des statuts : À préparer → À livrer
- Déplacement en lieu : zone de livraison
- Mise à jour du ticket : checklist installation validée

### 6. Livraison du poste (Technicien parc)

- Changement de **statut** des équipements : En stock → En utilisation
- Mise à jour du **lieu** : zone de livraison → bureau utilisateur
- Attribution des équipements à l’utilisateur (CI liés à Deanerys Targaryan)
- Liaison aux prises réseau et ports switch
- Liaison à l’imprimante réseau par connectique GLPI
- Ajout d’une **solution** dans le ticket + statut Résolu

### 7. Clôture par le demandeur (Responsable de service)

- Validation de la solution proposée via l’interface GLPI
- Passage automatique du ticket en statut **Clos**

---

## ✅ À retenir pour les révisions

- Un **ticket ITSM** dans GLPI centralise toute la gestion d’un service IT
- Chaque élément du **cycle de vie ITIL** est représenté dans le ticket (demande, traitement, validation, clôture)
- L’attribution et les suivis permettent la traçabilité des actions et la responsabilité des acteurs
- Le **lien avec les CI** (matériel) est essentiel pour le diagnostic et la maintenance

---

## 📌 Bonnes pratiques professionnelles

- Utiliser des **catégories claires** et types de tickets pertinents
- Lier systématiquement les **CI concernés** pour une traçabilité parfaite
- Mettre à jour les **statuts** et **lieux** des équipements à chaque étape
- Ajouter des **suivis détaillés** pour décrire les interventions
- Créer des **solutions réutilisables** quand pertinent
- Former les responsables à **valider et clôturer** les tickets depuis l’interface GLPI