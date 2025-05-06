# TP – La sécurité NTFS et les ACL sous Windows

## 📁 Répertoire "Echange" sur le volume `D:\DATA`

### 🔹 Création

```powershell
New-Item -Path "D:\DATA\Echange" -ItemType Directory
```

### 🔹 Droits par défaut (hérités du volume D:)

|Entité|Droits|
|---|---|
|Utilisateurs|Lecture|
|Utilisateurs authentifiés|Modification|
|Système|Contrôle total|
|Administrateurs|Contrôle total|

➡️ Ces droits sont hérités (coches grisées).

### 🔹 Héritage des fichiers créés

- Créer un fichier dans le dossier `Echange`
- Vérifier que les autorisations sont héritées : **coches grisées** + vérification via l’onglet **Avancé**

### 🔹 Modification des droits

1. **Désactiver l’héritage** :
    - Propriétés > Sécurité > Avancé > Désactiver l’héritage
    - Convertir les autorisations héritées en explicites
2. **Configurer les autorisations** :

|Groupe|Droits|
|---|---|
|L_Collegues|Modification|
|Administrateurs|Contrôle total|
|Utilisateurs|Lecture|

3. **Tester avec différents comptes** :
    - `Romain` (standard) : Lecture uniquement
    - `Alix` (L_Collegues) : Lecture + création fichiers
    - `François` (Administrateur) : Contrôle total
4. **Tester via accès effectif** (onglet Avancé > Accès effectif)

---

## 📁 Répertoires "logiciels" et "manuels d'utilisation" sur `E:\TOOLS`

### 🔹 Création

```powershell
New-Item -Path "E:\TOOLS\logiciels" -ItemType Directory
New-Item -Path "E:\TOOLS\manuels d'utilisation" -ItemType Directory
```

### 🔹 Suppression des droits inutiles

- Propriétés du volume `E:` > Sécurité > Modifier > Supprimer `Utilisateurs authentifiés`
- Conserver :
    - `Système` et `Administrateurs` : Contrôle total
    - `Utilisateurs` : Lecture

### 🔹 Application des droits spécifiques

| Groupe          | Droits         |
| --------------- | -------------- |
| L_Informatiques | Modification   |
| Administrateurs | Contrôle total |
| Utilisateurs    | Lecture        |

➡️ Yann et François étant membres de `L_Informatiques`, ils bénéficient des droits de modification.

---

## 🖥️ PowerShell – Lecture et modification des ACL

### 🔹 Lire les droits du dossier `M:\2022` sur la VM Discovery

```powershell
Get-Acl M:\2022 | Format-List
```

### 🔹 Modifier les droits (exemple)

```powershell
$acl = Get-Acl "D:\DATA\Echange"
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("L_Collegues", "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)
Set-Acl "D:\DATA\Echange" $acl
```

---

## ✅ Vérifications et tests

- ✅ Les autorisations sont correctement appliquées sur chaque dossier
- ✅ Tests d’accès (lecture, écriture, modification) effectués par différents utilisateurs
- ✅ Accès effectif vérifié via l’interface graphique
- ✅ PowerShell utilisé pour auditer les droits

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Ne pas supprimer Système/Administrateurs|Risque de perte d’accès au système|
|Éviter les refus explicites|Privilégier le contrôle par omission (absence d’ACE)|
|Toujours tester en condition réelle|Accès effectif ≠ théorique|
|Utiliser des groupes plutôt que des users|Facilité d’administration à grande échelle|
|Garder l’héritage sauf cas spécifiques|Maintien de la cohérence des droits|
