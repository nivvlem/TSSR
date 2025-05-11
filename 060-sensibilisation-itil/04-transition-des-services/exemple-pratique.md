# TP – Stratégie, conception et transition des services

## 🧠 Objectif du TP

Décrire la mise en œuvre d’un nouveau service d’**accueil pour un salarié commercial itinérant**, selon les **processus ITIL** liés à la **stratégie**, à la **conception**, et à la **transition** des services.

---

## 🧾 Contexte global

### Objectifs stratégiques

- Identifier les éléments nécessaires à la mise à disposition du poste de travail.
- S’assurer que les besoins du client interne sont couverts (valeur, qualité, maîtrise des coûts).
- Structurer une offre de service cohérente avec le catalogue et le portefeuille de services.

### Objectifs de conception

- Définir une procédure de déploiement reproductible.
- Anticiper les contraintes matérielles, logicielles, organisationnelles.
- Produire des livrables clairs (CMS, documentation, indicateurs).

### Objectifs de transition

- Planifier et exécuter la mise à disposition avec les bons intervenants.
- Documenter chaque action dans le CMS.
- S’assurer de la continuité et de la qualité de service lors de la mise en production.

---

## 🔍 Vue processus ITIL

### 📌 Phase de stratégie des services

#### Analyse de la demande (Gestion des demandes)

- Besoin exprimé par le service RH pour un profil mobile.
- Nécessité de répondre avec un service standardisé pour les commerciaux itinérants.

#### Portefeuille et catalogue

- Ajout du service dans la base des prestations récurrentes.
- Révision du catalogue si variation d’équipement ou de méthode.

#### Évaluation économique (ROI/TCO)

- Analyse complète du coût de fourniture (matériel, configuration, main d'œuvre).
- Définition du prix de revient si besoin de refacturation interne.

---

### 📌 Phase de conception des services

#### Définition de la solution cible

|Domaine|Détail|
|---|---|
|**Matériel**|PC portable, dock, écran, téléphone IP, smartphone|
|**Comptes**|AD, M365, GLPI, badge, téléphonie|
|**Connectivité**|Prises réseau, alimentation, switch paramétré|
|**Support**|CMS, documentation d’installation, image système|

#### Contraintes identifiées

- Délai court pour la mise à disposition
- Ressources humaines limitées
- Dépendances avec des fournisseurs (matériel, installation électrique)

#### Indicateurs définis

- Taux de conformité
- Délai moyen de mise à disposition
- Taux de satisfaction onboarding (KPI RH)

---

### 📌 Phase de transition des services

#### Planification des interventions

|Étape|Durée estimée|Ressource|
|---|---|---|
|Vérification / commande matériel|15–25 min|Technicien parc|
|Installation mobilier|30 min|Technicien ou prestataire|
|Vérification et installation réseau/électricité|40–60 min|Technicien + entreprise externe|
|Création des comptes (AD, M365, GLPI, badge, téléphonie)|10 min / compte|Admin AD|
|Préparation poste (OS, pilotes, logiciels, tests)|~3 h|Technicien|
|Livraison et validation|~2 h|Technicien + utilisateur|

#### Activités associées

- Étiquetage matériel + inventaire CMS
- Déploiement via PXE/WDS + vérification antivirus et VPN
- Tests téléphonie, connectivité, impression, GPO
- Mise à jour CMS et PV de recette

---

## ✅ À retenir pour les révisions

- La stratégie pose les bases : utilité, valeur, faisabilité, alignement métier.
- La conception structure la réponse technique et documentaire.
- La transition organise l’exécution, avec des rôles, des délais et un suivi documentaire.
- Le CMS doit refléter **chaque étape de la réalité terrain**.

---

## 📌 Bonnes pratiques professionnelles

- Centraliser la gestion des CI dans un CMS unique (GLPI, CMDB...)
- Définir un **processus d’onboarding réplicable** avec rôles et durées standards
- Utiliser des images systèmes avec drivers et logiciels prêts à l’emploi
- Prévoir un test utilisateur + PV de recette avant la validation finale
- Archiver les livrables (scripts, fiches, logs, inventaire) pour réutilisation et traçabilité
- Réévaluer régulièrement le coût total et les indicateurs pour affiner le catalogue de services