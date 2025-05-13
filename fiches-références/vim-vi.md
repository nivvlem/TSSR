# Vim / Vi

## 📌 Présentation

Vim (Vi IMproved) est un éditeur de texte puissant en ligne de commande, dérivé du très ancien `vi`. Il est disponible par défaut sur la majorité des systèmes Unix/Linux et est largement utilisé pour l’édition de fichiers de configuration, de scripts, ou de code.

---

## 🧰 Commandes essentielles

### 🔄 Modes

- `Normal` : mode par défaut (navigation, suppression…)
- `Insertion` : pour écrire du texte (`i`, `a`, `o`, etc.)
- `Commande` : pour sauvegarder, quitter, rechercher (`:`)

### 🖥️ Navigation

| Commande | Action |
|----------|--------|
| `h` `j` `k` `l` | Déplacement gauche, bas, haut, droite |
| `gg` / `G` | Aller au début / fin du fichier |
| `0` / `^` / `$` | Début / début réel / fin de ligne |
| `w` / `b` | Mot suivant / précédent |
| `/mot` | Recherche d’un mot |
| `n` / `N` | Recherche suivante / précédente |

### ✍️ Insertion

| Commande | Action                   |
| -------- | ------------------------ |
| `i`      | Insérer avant le curseur |
| `a`      | Insérer après le curseur |
| `o`      | Nouvelle ligne dessous   |
| `O`      | Nouvelle ligne au-dessus |

### 🧹 Suppression et modification

| Commande | Action |
|----------|--------|
| `x` | Supprime le caractère sous le curseur |
| `dd` | Supprime la ligne |
| `d$` / `d0` | Supprime jusqu'à la fin / début de ligne |
| `u` | Annule la dernière action |
| `Ctrl + r` | Rétablir (redo) |
| `r` | Remplace un caractère |
| `cw` / `c$` | Remplace un mot / jusqu’à la fin de ligne |

### 💾 Sauvegarde et fermeture

| Commande | Action |
|----------|--------|
| `:w` | Sauvegarder |
| `:q` | Quitter |
| `:wq` ou `ZZ` | Sauvegarder et quitter |
| `:q!` | Quitter sans sauvegarder |

### 📋 Copier / Coller

| Commande | Action                  |
| -------- | ----------------------- |
| `yy`     | Copier une ligne (yank) |
| `p`      | Coller après le curseur |
| `P`      | Coller avant le curseur |

---

## 🔎 Cas d’usage courant

- Édition rapide de fichiers de configuration dans `/etc`
- Écriture et correction de scripts (Bash, Python, etc.)
- Manipulation rapide de fichiers sur serveurs sans interface graphique (SSH)

---

## ⚠️ Erreurs fréquentes

- Oublier qu’on est en mode **normal** et taper des caractères qui ne s’insèrent pas
- Confondre `:q!` et `:wq`
- Oublier de sauvegarder avec `:w` avant de quitter
- Écraser accidentellement une ligne avec `dd` sans l’avoir copiée (yy)

---

## ✅ Bonnes pratiques

- Toujours vérifier le mode actif (indicateur en bas à gauche dans certains terminaux)
- Prendre l’habitude d’utiliser `:w` fréquemment pour éviter les pertes
- Utiliser `vimtutor` pour s’initier directement dans le terminal
- Apprendre les raccourcis de navigation pour gagner en efficacité
- Utiliser `.vimrc` pour configurer vim selon ses préférences (indentation, numéros de lignes…)

---

## 📚 Ressources complémentaires

- `vimtutor` : formation intégrée à Vim (commande à exécuter dans le terminal)
- [Vim Adventures – jeu pour apprendre Vim](https://vim-adventures.com)
- [Vim Cheat Sheet](https://vim.rtorr.com/)
- `:help` dans Vim pour accéder à l’aide contextuelle
