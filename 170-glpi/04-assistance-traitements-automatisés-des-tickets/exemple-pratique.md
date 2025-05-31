# TP – Assistance & automatisation des tickets
## 🏗️ Étapes détaillées

### 1️⃣ Gabarits de tickets

**Configuration > Assistance > Gabarits de tickets**

#### a) Incident serveur

- Champs obligatoires :
    - Titre
    - Catégorie
    - Type
    - Lieu
    - Description

#### b) Incident Bureautique

- Champs obligatoires :
    - Titre
    - Catégorie
    - Type
    - Lieu
    - Description
    - Éléments associés
- Champs masqués :
    - Urgence
    - Impact

#### c) Demande Bureautique

- Champs obligatoires :
    - Titre
    - Catégorie
    - Type
    - Lieu
    - Description
- Champs masqués :
    - Urgence
    - Impact

---

### 2️⃣ Catégories de tickets

**Assistance > Catégories de tickets**

#### Structure demandée :

```text
Logiciel
 ├── Bureautique
 │    ├── Word
 │    ├── Excel
 │    ├── Outlook
 ├── Infographiste
Serveur
 ├── Virtualisation
 ├── Active Directory
Matériel
 ├── Souris/clavier
 ├── Écran
```

#### Liaison gabarits ↔ catégories

|Catégorie|Gabarit(s) associé(s)|
|---|---|
|Bureautique / Word / Excel|Incident Bureautique + Demande Bureautique|
|Serveur / Virtualisation / Active Directory|Incident serveur|

_Astuce : Utiliser la **modification en masse** pour lier plusieurs catégories d’un coup._

---

### 3️⃣ Calendriers

**Configuration > Assistance > Niveaux de service > Intitulés > Calendriers**

#### a) cal serveur

- Jours ouvrés : Lundi à Jeudi → 8h00 - 18h00
- Vendredi → 8h00 - 17h30

#### b) cal utilisateurs

- Jours ouvrés : Lundi à Vendredi → 9h00 - 17h30

_Astuce : Créer **chaque jour individuellement** avec les bons horaires._

---

### 4️⃣ Niveaux de service (SLA)

**Configuration > Assistance > Niveaux de service**

#### a) SLA Incident serveur

- Calendrier : cal serveur
- Temps de prise en charge : < **1h**
- Temps de résolution : < **8h**

##### Escalades :

|Condition|Action|
|---|---|
|Ticket non pris en charge **10 min après création**|Groupe → `GG_GLPI_Super-Admin`, Observateur → Vous|
|Non résolu **-4h avant date butoir**|Priorité → Haute, Technicien → Vous|
|Non résolu **-3h avant date butoir**|Priorité → Très haute, Technicien → Zeus|

**Opérateur logique pour critères : OU**

#### b) SLA Incident bureautique

- Calendrier : cal utilisateurs
- Temps de prise en charge : 4h
- Temps de résolution : 2 jours

#### c) SLA Demande bureautique

- Calendrier : cal utilisateurs
    
- Temps de prise en charge : 4h
    
- Temps de résolution : 10 jours
    

---

### 5️⃣ Règles métier pour les tickets

**Configuration > Assistance > Règles métier pour les tickets**

#### a) règle SLA serveur

|Critères|
|---|
|Catégories : Serveur, Virtualisation, Active Directory|
|Type : Incident|

|Actions|
|---|
|SLA Temps de résolution : Incident serveur|
|SLA Temps de prise en charge : Incident serveur|
|Priorité : Moyenne|
|Groupe technicien : GG_GLPI_Technician|

**Opérateur logique pour critères : OU**

#### b) règle SLA incident bureautique

|Critères|
|---|
|Catégories : Bureautique, Word, Excel|
|Type : Incident|

|Actions|
|---|
|SLA Temps de résolution : Incident bureautique|
|SLA Temps de prise en charge : Incident bureautique|
|Priorité : Basse|
|Groupe technicien : GG_GLPI_hotliner|

#### c) règle SLA demande bureautique

|Critères|
|---|
|Catégories : Bureautique, Word, Excel|
|Type : Demande|

|Actions|
|---|
|SLA Temps de résolution : Demande bureautique|
|SLA Temps de prise en charge : Demande bureautique|
|Priorité : Très basse|
|Groupe technicien : GG_GLPI_hotliner|

---

## ✅ À retenir pour les révisions

- **Gabarits** personnalisent l’interface, pas le workflow
- **Catégories** doivent être structurées de façon claire et hiérarchique
- Les **SLAs** définissent les engagements et les escalades
- Les **règles métier** automatisent l’affectation (SLA, groupe, priorité)
- L’ordre logique recommandé :  
    1️⃣ Catégories →  
    2️⃣ Gabarits →  
    3️⃣ Calendriers →  
    4️⃣ SLA →  
    5️⃣ Règles métier

---

## 📌 Bonnes pratiques professionnelles

- Respecter une **convention de nommage** claire (ex : `Incident serveur`, `Demande bureautique`)
- Vérifier que les **règles métier** n’entrent pas en conflit
- Tester les **escalades** avant mise en production
- **Documenter** les critères de SLA et les responsabilités associées
- Créer des **SLAs atteignables** en fonction des ressources de l’équipe support
- Utiliser **les calendriers métier réels** (jours fériés, horaires) pour un SLA pertinent
- Prévoir des **revues régulières** des règles et SLA pour s’adapter à l’évolution des besoins
