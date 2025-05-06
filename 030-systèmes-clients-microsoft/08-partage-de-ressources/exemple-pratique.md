# TP – Partages et sessions distantes

## 📁 1. Partage de dossiers sur Win10-MD

### 🔹 CoWorkerShare (Dossier "Echange" sur D:)

- Clic droit > Propriétés > Partage > Partage avancé
- Nom du partage : `CoWorkerShare`
- Cocher "Partager ce dossier"
- Autorisations :
    - Supprimer "Tout le monde"
    - Ajouter "Utilisateurs authentifiés" : **Contrôle total**
- Onglet Sécurité > Ajouter `L_Collegues` avec droits de **Modification**

### 🔹 manuels d'utilisation (sur volume TOOLS)

- Même procédure que ci-dessus
- Nom du partage : `manuels d'utilisation`
- Autoriser les **Utilisateurs authentifiés** au niveau du partage (Contrôle total)
- Autoriser le groupe `L_Collegues` en **Modification** au niveau NTFS

### 🔹 Tests d’accès

- Depuis la VM Discovery, ouvrir l’explorateur Windows

```cmd
\\172.28.13.4\CoWorkerShare
\\172.28.13.4\manuels d'utilisation
```

- Authentifier avec un compte membre du groupe `L_Collegues`
- Créer un dossier test pour vérifier les droits en modification

---

## 🧠 2. Interrogation des partages depuis Discovery

### 🔹 Lister les partages disponibles

```powershell
Get-SmbShare
```

### 🔹 Identifier les ressources partagées spéciales

```powershell
Get-SmbShare -Name ADMIN$
```

- Résultat : `Path = C:\Windows`
- ADMIN$ est un partage administratif réservé aux administrateurs

### 🔹 Droits sur le partage N$

```powershell
Get-SmbShareAccess -Name N$
```

- Accès en **Contrôle total** pour :
    - `Administrateurs`
    - `Opérateurs de sauvegarde`
    - `INTERACTIF`

---

## 🖥️ 3. Configuration du Bureau à distance sur Discovery

### 🔹 Activer le Bureau à distance

```bash
sysdm.cpl → Onglet "Utilisation à distance"
→ Cocher "Autoriser les connexions à distance à cet ordinateur"
```

### 🔹 Autoriser Géraldine et Laurent

```bash
Ajouter "giannis" et "lebron" dans le groupe "Utilisateurs du Bureau à distance"
```

- `lusrmgr.msc` > Groupes > Utilisateurs du Bureau à distance > Ajouter

### 🔹 Test depuis Win10-MD

```cmd
mstsc /v:172.28.20.20
```

- Connexion avec :
    - Utilisateur : giannis
    - Mot de passe : `Pa$Sw0rd`

> Un échange de certificat a lieu lors de la première connexion.

### 🔹 Gestion des mots de passe

- Géraldine ne peut **pas** changer le mot de passe de Laurent → pas admin
- `adm` (administrateur) peut se connecter en RDP et changer les mots de passe via `lusrmgr.msc`

---

## ✅ Vérifications

|Élément|Validation|
|---|---|
|Dossiers partagés accessibles|Via UNC avec authentification|
|Dossiers modifiables par L_Collegues|Création de dossier test possible|
|Get-SmbShare affiche tous les partages|Y compris ADMIN$, IPC$, etc.|
|Get-SmbShareAccess sur N$|Montre les autorisations correctes|
|Bureau à distance activé sur Discovery|Connexion possible avec giannis|
|Connexion RDP avec adm|Changement de mot de passe possible|

---

## 📌 Bonnes pratiques professionnelles

|Bonnes pratiques|Pourquoi ?|
|---|---|
|Ne jamais utiliser "Tout le monde" en partage|Risques de sécurité importants|
|Séparer partage et autorisations NTFS|Meilleure granularité et sécurité|
|Tester les accès avec des comptes standards|Vérification des permissions effectives|
|Toujours activer RDP uniquement pour les profils sûrs|Limite les expositions réseau non désirées|
|Utiliser PowerShell pour l'audit des partages|Rapide, scriptable, compatible GPO|
