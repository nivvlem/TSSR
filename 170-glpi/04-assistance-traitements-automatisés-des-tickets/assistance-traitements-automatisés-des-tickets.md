# Assistance & Traitements automatisés des tickets
## 🧩 Le cycle de vie d’un ticket

### Objectif du ticket

- Centraliser la gestion des incidents et demandes
- Structurer la **traçabilité** des interventions
- Assurer un **suivi qualitatif** du service rendu

### Types de ticket

|Type|Description|
|---|---|
|Incident|Dysfonctionnement à résoudre|
|Demande|Besoin utilisateur / service à délivrer|

### Cycle de vie classique

```text
Nouveau → En cours → Résolu → Clos
```

- **Suivi de l’avancement** par l’utilisateur et le support

---

## 🚀 Flux d’entrée des tickets

### 1️⃣ Depuis GLPI (interfaces)

#### a) Interface anonyme

- URL : `http(s)://<@glpi>/front/helpdesk.html`
- Pas d’authentification requise
- Paramétrable (HTML/CSS)
- Par défaut lié à l’entité racine

#### b) Interface simplifiée

- Accessible après authentification (utilisateur lambda)
- Formulaire **personnalisé par gabarit**
- Suivi des propres tickets dans le tableau de bord

#### c) Interface standard

- Accessible par **technicien / support N1-N2**
- Accès complet à tous les éléments du ticket (SLAs, tâches…)
- Tickets saisis :
    - Depuis l’interface
    - Par téléphone (client appelle le support)

### 2️⃣ Par mail (collecteur)

- Boîte mail support → **collecteur mail** de GLPI
- Configuration :
    - IMAP / POP3 sécurisé recommandé
    - Transfert en ticket automatique

### 3️⃣ Autres canaux possibles

- Téléphone (via saisie manuelle par technicien)
- API GLPI (intégration outils externes)

---

## 🎛️ Gabarits de tickets

### Rôle

- **Personnaliser l’interface de saisie** du ticket selon :
    - **Type** (incident, demande)
    - **Catégorie**

### Paramétrages possibles

|Élément|Action|
|---|---|
|Champs|Masqués / visibles / obligatoires|
|Valeurs|Pré-remplies|
|Affichage|Adapté à l’interface (standard, simplifiée)|

### Bonnes pratiques

✅ Créer les **catégories de tickets** avant les gabarits  
✅ Nommage : `categorie-type`  
✅ Maximum **2 gabarits par catégorie** (incident / demande)  
✅ Ne pas y intégrer la **priorité / SLA** → gérer cela via les **règles métier**  
✅ Gabarit = uniquement pour l’**interface utilisateur**

---

## 🛠️ Règles métier pour les tickets

### Rôle

- **Automatiser** la configuration du ticket à sa création
- Exemple :
    - Définir la priorité
    - Assigner un technicien ou groupe
    - Attribuer un SLA

### Caractéristiques

- **Interprétées uniquement à la création** du ticket
- Toutes les règles sont lues (pas d’arrêt sur première correspondance)
- L’ordre des règles est **important** (champs concurrents)

### Critères typiques

|Critère|Exemples|
|---|---|
|Type|Incident / Demande|
|Catégorie|Hardware / Software...|
|Temps restant|Pour escalades|

### Actions possibles

|Action|Exemples|
|---|---|
|Priorité|Haute, critique...|
|Affectation|Technicien, groupe|
|SLA|Attribution automatique|

---

## ⏳ SLA (Service Level Agreement)

### Objectif

- Définir des **engagements de service** :
    - Temps de prise en charge
    - Temps de résolution

### Gestion des SLAs

**Configuration > Niveaux de service**

#### Paramétrages

|Élément|Détail|
|---|---|
|Type|Prise en charge / Résolution|
|Durée max|2h, 8h, 2j...|
|Calendrier|Défini pour les jours / heures ouvrées|
|Escalades|Actions si dépassement|

### Attribution

- Manuelle par technicien
- Automatique via **règles métier**

### Exemple de SLA

|Priorité|Temps de résolution|
|---|---|
|1 (Critique)|2h|
|2 (Haute)|8h|
|3 (Normale)|2j|

### Suivi

- Dépassement **non bloquant** mais signalé (alerte)
- Permet le **pilotage de la qualité de service**

---

## ⚙️ Ordre logique de création (préconisation pro)

1️⃣ **Créer les catégories de tickets**

- Catégories cohérentes, hiérarchiques si besoin

2️⃣ **Créer les gabarits de tickets**

- Lier aux catégories, **incident / demande**

3️⃣ **Créer les SLAs**

- Temps de prise en charge et de résolution

4️⃣ **Créer les escalades de SLAs**

- Ex : changement de priorité, réaffectation…

5️⃣ **Créer les règles métier pour les tickets**

- Critères : catégorie, type, temps restant
- Actions : affectation, SLA, priorité

---

## ✅ À retenir pour les révisions

- Le **ticket** est l’élément central de l’assistance
- Les **flux d’entrée** doivent être bien configurés
- Les **gabarits** personnalisent l’interface, pas la logique métier
- Les **règles métier** automatisent le paramétrage à la création
- Les **SLAs** permettent de piloter la qualité de service
- Il faut respecter un **ordre logique** de création pour assurer la cohérence

---

## 📌 Bonnes pratiques professionnelles

- **Documenter** toutes les catégories et règles
- **Structurer** les catégories pour qu’elles soient claires pour les utilisateurs
- **Isoler visuellement** les interfaces anonymes vs internes
- Préférer la **maintenance des règles métier** plutôt que modifier les gabarits
- Créer des **SLAs réalistes** basés sur la capacité réelle du support
- Utiliser les **calendriers de travail** pour des SLAs pertinents
- **Superviser** les dépassements de SLA et les traiter rapidement
- Former les **techniciens N1-N2** à l’usage avancé de l’interface standard
