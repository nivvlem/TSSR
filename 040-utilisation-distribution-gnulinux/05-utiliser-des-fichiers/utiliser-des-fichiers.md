# Utiliser des fichiers sous Linux

## 📁 Types de fichiers Linux

### 🔍 Avec `ls -l`

Le **premier caractère** indique le **type de fichier** :

|Caractère|Type|
|---|---|
|`-`|Fichier standard|
|`d`|Répertoire|
|`l`|Lien symbolique|
|`b`|Périphérique bloc|
|`c`|Périphérique caractère|
|`p`|Tube nommé (pipe)|
|`s`|Socket|

📌 **Remarque** : les **extensions de fichier** ne sont pas interprétées par le système Linux, elles ne sont là que pour les humains.

### 🔎 Avec `file`

Affiche le **type de données** du fichier :

```bash
file Edition
file /bin/bash
```

---

## 🧠 Métadonnées et inodes

Un fichier est composé de :

- Un **nom** (stocké dans le répertoire parent)
- Un **inode** (métadonnées)
- Des **données** (contenu)

### Les métadonnées (informations dans l'inode)

- Type de fichier
- UID / GID (propriétaire/groupe)
- Permissions, dates d’accès, taille
- Nombre de **liens physiques**

Visualisation :

```bash
ls -li fichier.txt
```

---

## 📖 Lire du texte avec Linux

### 📚 Commandes principales

|Commande|Fonction|
|---|---|
|`cat`|Affiche tout le contenu|
|`more` / `less`|Navigation dans un long fichier|
|`head -n X`|Affiche les X premières lignes|
|`tail -n X`|Affiche les X dernières lignes|
|`tail -f`|Affiche dynamiquement (ex: logs)|
|`wc`|Compte lignes, mots, caractères|

#### Exemples

```bash
cat contacts.txt
more /etc/passwd
head -n 5 fichier.txt
tail -f /var/log/syslog
wc -l fichier.txt
```

---

## 🔗 Les liens sous Linux

### 📌 2 types de liens

|Type|Création|Caractéristiques|
|---|---|---|
|**Symbolique**|`ln -s`|Pointeur vers le chemin, peut lier répertoires, traverse partitions|
|**Physique**|`ln`|Même inode, pas de lien sur dossier, ne traverse pas les systèmes de fichiers|

### 🔗 Lien symbolique

```bash
ln -s fichier_original lien_symbolique
```

- Utilise un nouvel inode
- Si fichier original supprimé → lien brisé ("lien mort")
- Peut pointer vers un fichier ou un dossier

### 🔗 Lien physique

```bash
ln fichier_original copie_physique
```

- Les deux noms pointent vers le **même inode**
- Suppression d’un nom ≠ suppression du fichier (tant qu’un autre lien existe)
- Impossible entre partitions différentes

### Vérifier les liens

```bash
ls -li fichier lien
```

- Même inode = lien physique
- Lien `->` = lien symbolique

---

## ✅ À retenir pour les révisions

- Linux distingue types de fichiers par leur **nature**, pas leur extension
- L'inode contient toutes les métadonnées sauf le **nom**
- `cat`, `less`, `head`, `tail`, `wc` sont des commandes essentielles de lecture
- Les **liens symboliques** sont souples et visibles, mais fragiles
- Les **liens physiques** sont robustes mais limités (pas de lien sur dossier, même partition)

---

## 📌 Bonnes pratiques professionnelles

- Utiliser `file` pour identifier le contenu réel d’un fichier
- Utiliser `less` plutôt que `cat` pour les gros fichiers
- Préférer les liens symboliques pour la lisibilité, les physiques pour la fiabilité locale
- Ne pas supprimer un fichier partagé via lien physique sans vérification préalable
- Vérifier les inodes pour s’assurer de la liaison réelle entre fichiers

---

## 🔗 Liens utiles

- [GNU Coreutils – ln](https://www.gnu.org/software/coreutils/manual/html_node/ln-invocation.html)`