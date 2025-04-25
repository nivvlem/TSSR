# Mise en situation professionnelle : Services réseau

## GPO
## 🧩 1. Rappel des bonnes pratiques : Filtrage et délégation des GPO

Par défaut, les GPO liées à une OU s'appliquent à **tous les objets contenus**, sauf si un **filtrage de sécurité** ou une **délégation spécifique** est configurée.

### ✅ Filtrage recommandé :

1. Dans la console GPMC, clic droit sur la GPO > **Modifier les autorisations** > Avancé.
2. Vérifier les autorisations de sécurité :
    - **“Authenticated Users”** : garde **Lecture seule**, décoche **“Appliquer la stratégie”** si nécessaire.
    - **Ajouter explicitement** les groupes cibles (ex. `GG_Secrétariat`) avec :
        - Lecture : ✔️
        - Appliquer la stratégie de groupe : ✔️
    - Supprimer l'application pour les **Administrateurs du domaine** pour les exclure.

### ✅ Exemple de tableau de filtrage :

|Groupe|Lecture|Appliquer la stratégie|
|---|---|---|
|Authenticated Users|✔️|❌|
|GG_Secrétariat|✔️|✔️|
|Administrateurs du domaine|✔️|❌|

---

## 🛠️ 2. Création des GPO

Ouvrir **GPMC** (Gestion de la stratégie de groupe) sur `SRV-AD-MD` :

```powershell
gpmc.msc
```

Créer les GPO suivantes :

|GPO|Lien|Cible|
|---|---|---|
|`FondEcranCommun`|OU=Utilisateurs|Tous les utilisateurs|
|`RestrictionsUtilisateurs`|OU=Utilisateurs|Tous sauf Admins|
|`PolitiqueMdp`|Domaine|Tous les comptes utilisateurs|
|`MapDisqueServices`|Secrétariat|Membres du groupe GG_Secrétariat|
|`PolitiqueMAJ_Pilotes`|Domaine|Tous les postes|
|`BlocageRedemarrageAuto`|Domaine|Tous les postes|
|`BloquerRechercheInternet`|Domaine|Tous les postes|
|`BloquerErreursMS`|Domaine|Tous les postes|

---

## ⚙️ 3. Configuration des GPO

### `FondEcranCommun`

1. Stocker un fichier `wallpaper.jpg` sur un partage lisible par tous.
2. Dans **Configuration utilisateur > Modèles d'administration > Bureau > Bureau**.
3. Activer : **Fond d'écran du bureau**.
4. Chemin du fichier (UNC) : `\\SRV-SVC-MD\Public\wallpaper.jpg`

### `RestrictionsUtilisateurs`

Dans **Configuration utilisateur > Panneau de configuration / Paramètres :**

- Empêcher accès au Panneau de configuration et Paramètres Windows
- Empêcher accès à "Modifier les paramètres de l'affichage"

### `PolitiqueMdp`

Dans **Configuration ordinateur > Paramètres Windows > Paramètres de sécurité > Stratégies de compte** :

- Âge maximal : 30 jours
- Longueur minimale : 3 caractères
- Complexité : **Désactivée**

### `MapDisqueServices`

**Configuration utilisateur > Préférences > Paramètres Windows > Lecteurs mappés** :

- Créer un lecteur `S:` vers `\\SRV-SVC-MD\SERVICES`
- Ciblage : membres du groupe `GG_Secrétariat`

### `PolitiqueMAJ_Pilotes`

**Configuration ordinateur > Modèles d'administration > Système > Installation de pilotes** :

- Restreindre l'installation aux admins locaux uniquement

### `BlocageRedemarrageAuto`

**Configuration ordinateur > Windows Update** :

- Empêcher le redémarrage auto en session active

### `BloquerRechercheInternet`

**Configuration utilisateur > Composants Windows > Rechercher** :

- Ne pas rechercher sur Internet

### `BloquerErreursMS`

**Configuration ordinateur > Modèles d'administration > Système > Résolution de problèmes** :

- Empêcher l'envoi de rapports d'erreurs à Microsoft

---

## 🧪 4. Application et tests

### Forcer la mise à jour des GPO

Sur un poste client, lancer :

```powershell
gpupdate /force
```

### Vérification des GPO appliquées

```powershell
gpresult /r
```

Vérifier notamment que :

- Le fond d'écran est appliqué
- Le lecteur `S:` est bien mappé pour les secrétaires
- Les options de redémarrage / panneau sont bien bloquées

---

## 📄 Synthèse

|GPO|Effet principal|Cible|
|---|---|---|
|FondEcranCommun|Fond d'écran identique|Tous les utilisateurs|
|RestrictionsUtilisateurs|Bloque le panneau de configuration|Tous sauf admins|
|PolitiqueMdp|Durée / complexité mots de passe|Domaine|
|MapDisqueServices|Lecteur `S:` vers partages SERVICES|GG_Secrétariat|
|PolitiqueMAJ_Pilotes|Installation réservée aux admins locaux|Tous les postes|
|BlocageRedemarrageAuto|Empêche le redémarrage auto|Tous les postes|
|BloquerRechercheInternet|Recherche web désactivée dans la barre de recherche|Tous les postes|
|BloquerErreursMS|Blocage des rapports d'erreurs à Microsoft|Tous les postes|
