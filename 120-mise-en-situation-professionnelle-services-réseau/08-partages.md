# Mise en situation professionnelle : Services réseau

## Partages

## 🧩 1. Méthode AGDLP

### Principe :

```
Utilisateurs (A) → Groupes Globaux (GG_*) → Groupes Locaux (DL_*) → Droits sur dossiers (P)
```

|Type|Nom exemple|Rôle|
|---|---|---|
|A|chef, patron|Comptes utilisateurs|
|GG|GG_Comptabilité|Représente les membres du service|
|DL|DL_Comptabilité_Modif|Sert à appliquer les droits sur un répertoire|
|P|F:\DATA\Comptabilité|Le groupe DL est utilisé dans les permissions de sécurité NTFS|

---

## 💽 2. Ajout de disques et volume tolérant aux pannes

### 📦 Ajout de disques à SRV-SVC-MD

Dans VMware, ajouter **3 disques durs de 1 Go** à la VM `SRV-SVC-MD` (équivalent à 1 To en réel).

### ⚙️ Configuration du volume F:

1. **Gestion des disques** (`diskmgmt.msc`).
2. Initialiser les 3 nouveaux disques.
3. Clique droit > **Nouveau volume agrégé** (RAID-5 si dispo, sinon Striped = tolérance simulée).
4. Lettre de lecteur : `F:`
5. Formatage en **NTFS**.

---

## 📂 3. Création des dossiers partagés

### Arborescence

```
F:\DATA\
│
├── PUBLIC
└── SERVICES
    ├── Direction
    ├── Comptabilité
    ├── Secrétariat
    ├── Support
    └── Informatique
```

---

## 🔐 4. Application des permissions NTFS + partages (AGDLP)

> Rappel : seuls les **groupes DL_*** sont utilisés dans les permissions NTFS/partage.

### Exemple de configuration

#### 📁 `F:\DATA\PUBLIC`

- **NTFS** & **Partage** : `DL_Public_Modif` → Tous les utilisateurs du domaine

#### 📁 `F:\DATA\SERVICES\Direction`

- **NTFS** & **Partage** :
    - `DL_Direction_Modif` → contient `GG_Direction` et `GG_Comptabilité`
    - `DL_Direction_Lecture` → contient `GG_Secrétariat`

#### 📁 `F:\DATA\SERVICES\Comptabilité`

- `DL_Comptabilité_Modif` → `GG_Comptabilité`
- `DL_Comptabilité_Lecture` → `GG_Direction`, `GG_Secrétariat`

#### 📁 `F:\DATA\SERVICES\Secrétariat`

- `DL_Secrétariat_Modif` → `GG_Secrétariat`

#### 📁 `F:\DATA\SERVICES\Support`

- `DL_Support_Modif` → `GG_Support`, `GG_Secrétariat`
- `DL_Support_Lecture` → `GG_Direction`

#### 📁 `F:\DATA\SERVICES\Informatique`

- `DL_Informatique_CT` → `GG_Informatique`
- **Partage caché** : `Outils$`

---

## 🧪 5. Tests depuis un poste client

### À faire depuis CLT-WIN-MD

1. Ouvrir une session avec un utilisateur de chaque groupe.
2. Accès à :

```powershell
\srv-svc-md\public
\srv-svc-md\services\direction
\srv-svc-md\outils$
```

3. Test d’écriture, modification, suppression de fichier selon les droits.
4. Vérification des permissions appliquées **par groupe DL_***.

---

## 🧠 Bonnes pratiques

- Toujours appliquer les droits **via des groupes DL_**_, jamais sur des utilisateurs ou GG__ directement.
- Utiliser **un groupe DL par combinaison logique de droit + ressource**.
- Conserver une **documentation claire des droits et membres** (tableau ou fichier texte).

---

## 📄 Synthèse

|Dossier partagé|Groupe DL utilisé|Membres indirects (GG)|Accès|
|---|---|---|---|
|PUBLIC|DL_Public_Modif|Tous les utilisateurs|Modification|
|Direction|DL_Direction_Modif|GG_Direction, GG_Comptabilité|Modification|
||DL_Direction_Lecture|GG_Secrétariat|Lecture|
|Comptabilité|DL_Comptabilité_Modif|GG_Comptabilité|Modification|
||DL_Comptabilité_Lecture|GG_Secrétariat, GG_Direction|Lecture|
|Secrétariat|DL_Secrétariat_Modif|GG_Secrétariat|Modification|
|Support|DL_Support_Modif|GG_Support, GG_Secrétariat|Modification|
||DL_Support_Lecture|GG_Direction|Lecture|
|Informatique (caché)|DL_Informatique_CT|GG_Informatique|Contrôle total|
