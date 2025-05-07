# Éditer du texte sous Linux

## 🧰 Éditeurs de texte sous Linux

|Nom|Description|
|---|---|
|**Emacs**|Très puissant, modulaire, pour développeurs|
|**Jed**|Semi-graphique, coloration, proche d'Emacs|
|**Jedit**|Graphique avec plugins, destiné aux programmeurs|
|**Joe**|Mode texte, proche d'Emacs|
|**Nano**|Léger, simple, souvent préinstallé|
|**Geany, Gedit, Xed...**|Graphiques, équivalents de Notepad++|
|**Vim**|Éditeur de référence, puissant, mode commande/insertion|

✅ **Vim** est le focus de ce module.

---

## 🚀 Lancer Vim

```bash
vim fichier.txt
vim +n fichier.txt       # ligne n
vim +/mot fichier.txt    # première occurrence "mot"
vim -R fichier.txt       # en lecture seule
```

---

## 🎮 Modes de Vim

### 🔧 Mode Commande

- Déplacement, suppression, copier/coller, accès à `:` ligne de commande
- Touches de déplacement : `h`, `j`, `k`, `l`, `w`, `b`, `e`, `0`, `$`, `gg`, `G`, etc.
- `:` ouvre la ligne de commande :
    - `:w`, `:q`, `:wq`, `:q!`, `:x`, etc.

### 📝 Mode Insertion

- `i`, `I` : insertion avant/le début de ligne
- `a`, `A` : après/fin de ligne
- `o`, `O` : nouvelle ligne après/avant
- `Échap` : retour au mode commande

### ↩️ Autres raccourcis

- `u` : annuler
- `Ctrl+r` : rétablir
- `:!commande` : exécuter commande shell sans quitter

---

## ✂️ Supprimer, copier, coller

### Suppression

|Commande|Action|
|---|---|
|`nx`|Supprimer n caractères suivants|
|`nX`|n caractères précédents|
|`D`|Jusqu’à fin de ligne|
|`ndd`|n lignes|
|`ndw`|n mots|

### Copier/coller

|Commande|Action|
|---|---|
|`nyy`|Copier n lignes|
|`nyw`|Copier n mots|
|`p` / `P`|Coller après / avant le curseur|
|`"lyy`, `"lp`|Tampon nommé l|

### Couper + insertion directe

|Commande|Action|
|---|---|
|`ncc`|Couper n lignes puis insérer|
|`ncw`|n mots|
|`ncl`|n lettres|
|`rX`|Remplacer caractère sous curseur par `X`|
|`R`|Mode remplacement permanent|

---

## 🔄 Rechercher et remplacer

### Syntaxe

```bash
:g/motif/commande       # global
:15,17g/motif/commande  # plage de lignes
```

### Exemples

```bash
:g/motif/d              # supprimer lignes contenant "motif"
:g/ancien/s//nouveau/g  # remplacer "ancien" par "nouveau"
:30,45g/foo/s/bar/baz/g # remplacer bar -> baz lignes 30 à 45 si contient foo
```

---

## ⚙️ Personnaliser Vim

### Paramètres courants

|Option|Description|
|---|---|
|`:set number`|Numérotation des lignes|
|`:set showmode`|Affiche mode en cours|
|`:set ignorecase`|Recherche insensible à la casse|
|`:set autoindent`|Indentation automatique|
|`:set tabstop=4`|Largeur tabulation|
|`:syntax on`|Activer coloration|

### Configuration persistante

Fichier : `~/.vimrc`

```vim
set nocompatible
set number
syntax on
```

### Aide intégrée

```bash
:help     # aide générale
:help insert
:q        # quitter l’aide
```

---

## 🔁 Fins de lignes : Linux vs Windows

|OS|Fin de ligne|
|---|---|
|Linux|LF (`\n`)|
|Windows|CRLF (`\r\n`)|

### Conversion

```bash
:set fileformat=unix      # dans Vim
# ou avec outils externes
sudo apt install dos2unix
unix2dos fichier.txt
```

✅ Option `.vimrc` : `set fileformats=unix`

---

## ✅ À retenir pour les révisions

- Vim = mode **commande** et **insertion**
- `i`, `a`, `o` : insertion ; `u`, `Ctrl+r` : annuler/rétablir
- `dd`, `yy`, `p`, `P` : base du copier/coller
- `:g/regex/commande` : rechercher/remplacer globalement
- `:set`, `~/.vimrc` pour configurer Vim

---

## 📌 Bonnes pratiques professionnelles

- Utiliser `less` ou `vim -R` pour lire en toute sécurité
- Toujours sauvegarder avant une opération de masse
- Utiliser les tampons nommés pour manipuler plusieurs zones
- Créer un `.vimrc` pour standardiser l’environnement
- Convertir les fichiers texte selon l’OS cible (Unix vs Windows)

---

## 🔗 Liens utiles

- [Vim help en ligne](https://vimhelp.org/)
- [Cheat.sh – Vim](https://cheat.sh/vim)
