# Droits sur les fichiers et répertoires (Debian GNU/Linux)

## 🔐 Les droits Unix/Linux

### Types d’accès (par colonne : user / group / other)

|Droit|Octal|Fichier|Répertoire|
|---|---|---|---|
|`r`|4|Lecture|Lister le contenu (ex : `ls`)|
|`w`|2|Écriture|Ajouter/modifier/supprimer (ex : `touch`, `rm`)|
|`x`|1|Exécution|Traverser ou exécuter (ex : `cd`, `./script`)|

### Représentation symbolique et octale

- Exemple : `rwxr-xr--` = 754
- Notation complète : `chmod 750 fichier`

---

## 📁 Affichage et modification des droits

### 🔍 Affichage

```bash
ls -l fichier
```

### ✏️ Modification avec `chmod`

```bash
chmod 770 /dossier
chmod g+w,o-rx fichier
chmod -R 750 /mon/arborescence
```

- `+` : ajout de droits, `-` : suppression, = : définition exacte

---

## 👤 Modification des propriétaires

### 🔧 Utiliser `chown`

```bash
chown user:group fichier
chown -R user:group /dossier
```

- Pour ne modifier que le groupe : `chown :group fichier`

---

## 🧩 Modèle de droits par défaut : `umask`

### 🧮 Calcul du umask

- Droit par défaut :
    - Fichier : 666 (rw-rw-rw-)
    - Dossier : 777 (rwxrwxrwx)
- Exemple : umask 022 → fichier = 644, dossier = 755

### 🛠️ Modifier temporairement

```bash
umask 0007
```

### 🔁 Persistance (dans `~/.bashrc`)

```bash
umask 0007
```

---

## 🧱 Les droits spéciaux Unix

### SetUID (octal 4---)

- Exécution avec les droits du propriétaire du fichier
- Exemple : `/usr/bin/passwd`
- Commande : `chmod u+s fichier`

### SetGID (octal 2---)

- Exécution avec les droits du groupe
- Sur dossier : héritage du groupe et du droit sur les fichiers créés
- Commande : `chmod g+s dossier`

### Sticky Bit (octal 1---)

- Sur dossier : seuls le propriétaire ou root peuvent supprimer les fichiers
- Exemple : `/tmp`
- Commande : `chmod +t dossier`

### Résumé symbolique

|Droit spécial|Position|Commande|Utilité|
|---|---|---|---|
|SetUID|colonne user|`chmod u+s`|Exécute avec UID du propriétaire|
|SetGID|colonne group|`chmod g+s`|Hérite du groupe du dossier|
|Sticky bit|colonne other|`chmod +t`|Protection sur suppression fichiers|

---

## ✅ À retenir pour les révisions

- Les droits sont représentés symboliquement (`rwx`) et numériquement (octal : 0–7)
- `chmod`, `chown`, `umask` permettent de gérer précisément l’accès aux fichiers
- Le `umask` détermine les droits par défaut
- Les droits spéciaux (SetUID, SetGID, Sticky Bit) renforcent le contrôle d’accès

---

## 📌 Bonnes pratiques professionnelles

- Ne jamais utiliser `chmod -R 777` sans une justification sérieuse
- Préférer `chmod` avec précision : `chmod 750`, `chmod g-w`, etc.
- Protéger les répertoires partagés avec le Sticky Bit (`/tmp`)
- Utiliser `umask` adapté par type d’utilisateur (service vs utilisateur réel)

---

## 🔗 Commandes utiles

```bash
ls -l             # Affiche les droits
chmod 750 fichier # Change droits en octal
chmod g+w fichier # Ajoute droit en symbolique
chown user:group fichier
umask             # Affiche/Modifie le masque
chmod u+s fichier # SetUID
chmod g+s dossier # SetGID
chmod +t dossier  # Sticky Bit
```

## Ressources complémentaires

- [Debian File Permissions](https://wiki.debian.org/FilePermissions)